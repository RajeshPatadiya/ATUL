/* Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web;
using System.Xml;


namespace ATUL_v1
{
    /// <summary>
    ///
    /// </summary>
    public class AtulBusinessLogic
    {
        private bool debug = Convert.ToBoolean(ConfigurationManager.AppSettings["debug"]);

        /// <summary>
        /// Helloes the world bool.
        /// </summary>
        /// <returns></returns>
        public bool HelloWorldBool()
        {
            return true;
        }

        /// <summary>
        /// Helloes the world string.
        /// </summary>
        /// <param name="word">The word.</param>
        /// <returns></returns>
        public string HelloWorldString(string word)
        {
            return JsonMethods.StringToJSONString(word);
        }

        /// <summary>
        /// THIS METHOD WILL BE REPLACED WHEN WE AUTOMATE ALL OBJECTS
        /// Processes the Subprocess actor.
        /// When this method is called, the instance will be evaluated to see if there is an actor that is scope for processing.
        /// If an actor is in scope, the actor will be called with relevant parameters.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string ProcessCurrentSubProcessActor(long AtulInstanceProcessID)
        {
            string correlationid = "";
            
            return correlationid;
        }

        public string GetQueueMessageByCorrelationID(string queue, string correlationID)
        {
            return "";
            
        }

        private string ResolveTokens(string ffname, string ffvalue, Dictionary<string, string> resolvers)
        {
            bool foundOne = false;
            do
            {
                foundOne = false;
                foreach (var r in resolvers)
                {
                    string tokenName = "@" + r.Key.ToString() + "@";
                    string tokenValue = r.Value.ToString();
                    if (ffvalue.Contains(tokenName) && tokenName != ffname)
                    {
                        ffvalue = ffvalue.Replace(tokenName, tokenValue);
                        foundOne = true;
                    }
                }
            } while (foundOne);
            return ffvalue;
        }

        private string BuildActorPayload(DataTable actorInfo, Dictionary<string, string> parameterList)
        {
            XmlDocument msgPayload = new XmlDocument();
            XmlDeclaration dec = msgPayload.CreateXmlDeclaration("1.0", null, null);
            msgPayload.AppendChild(dec);
            XmlElement root = msgPayload.CreateElement("servicerequest");
            msgPayload.AppendChild(root);
            //add verb
            XmlElement verb = msgPayload.CreateElement("verb");
            verb.InnerText = actorInfo.Rows[0]["verb"].ToString();
            root.AppendChild(verb);
            //add parameters
            foreach (var p in parameterList)
            {
                XmlElement parameter = msgPayload.CreateElement("parameter");
                XmlElement name = msgPayload.CreateElement("name");
                XmlElement value = msgPayload.CreateElement("value");
                name.InnerText = p.Key.ToString();
                value.InnerText = p.Value.ToString();
                parameter.AppendChild(name);
                parameter.AppendChild(value);
                root.AppendChild(parameter);
            }
            return msgPayload.OuterXml;
        }

        /// <summary>
        /// Pushes to queue.
        /// </summary>
        /// <param name="queue">The queue.</param>
        /// <param name="body">The body.</param>
        /// <param name="headerList">The header list.</param>
        /// <param name="delay">Delay before sending in milliseconds</param>
        /// <returns></returns>
        public string PushToQueue(string queue, string body, List<KeyValuePair<string, string>> headerList)
        {
            //Here we add the headers to the message. This will generally include at least the verb and the response queue.
            string correlationid = "";
           

            return correlationid;
        }

        public bool CreateScheduledProcessInstance(long ProcessID, string scheduleVersion)
        {
            bool success = true;
            Atul_v1Data adb = new Atul_v1Data();
            // get schedule record from db
            Schedule s = adb.GetProcessScheduleByProcessID(ProcessID);
            if (s.ScheduleVersion == scheduleVersion)
            {
                DataTable processStatusTable = adb.GetAllProcessStatus();
                int processStatusID = 0;
                foreach (DataRow processStatusRow in processStatusTable.Rows)
                {
                    if (processStatusRow["ProcessStatus"].ToString().ToLower() == "open")
                    {
                        processStatusID = Convert.ToInt32(processStatusRow["AtulProcessStatusID"]);
                    }
                }
                // instantiate process
                foreach (string u in s.InstantiatedUserList.Split(','))
                {
                    if (u != null)
                    {
                        this.CreateInstanceProcess(s.AtulProcessID, Convert.ToInt32(u), Convert.ToInt32(u), processStatusID, "", "");
                    }
                }
                // if there's a repeat schedule involved, schedule the next fire
                if (s.RepeatSchedule != null && s.RepeatSchedule != string.Empty)
                {
                    // calculate next date from cronstring.
                    DateTime next = s.GetNextScheduled();
                    // update process schedule, passing NextScheduledDate as last run, since that should represent this one
                    UpdateProcessSchedule(s.AtulProcessScheduleID, s.ScheduleVersion, s.NextScheduledDate, next, s.RepeatSchedule, s.InstantiatedUserList);
                    // send new scheduled message to queue
                    this.PushNextScheduleToAdminQueue(s, next);
                }
                else
                {
                    this.DeleteProcessSchedule(s.AtulProcessScheduleID);
                }
            }
            return success;
        }

        public string PushNextScheduleToAdminQueue(Schedule s, DateTime next)
        {
            string correlationid = "";
            string env = ConfigurationManager.AppSettings.Get("Environment");
            string queue = ConfigurationManager.AppSettings.Get(env.ToUpper() + ".AtulAdminQueue");
            XmlDocument doc = s.GetScheduleMessageBodyXML();
            string body = doc.InnerXml;
            List<KeyValuePair<string, string>> headerList = new List<KeyValuePair<string, string>>();
            headerList.Add(new KeyValuePair<string, string>("VERB", "INITINSTANCE"));
            // scale tells how much to multiply the delay by, since the ESB system is passing the delay header from one queue to the next, thus doubling it.
            // when it's fixed, we can push config change to set scale to 1 and thus delay is intact.
            double timescale = Convert.ToDouble(ConfigurationManager.AppSettings.Get("MsgTimeScale"));
            // calculate delay by subtracting now from next scheduled date
            long delay = Convert.ToInt64(Math.Floor(next.Subtract(DateTime.Now).TotalMilliseconds * timescale));
            // if they're scheduled for the next couple minutes, just push it now with no delay so that it doesn't get
            // caught in lag
            if (delay >= 100000)
            {
                headerList.Add(new KeyValuePair<string, string>("AMQ_SCHEDULED_DELAY", delay.ToString()));
            }
            correlationid = this.PushToQueue(queue, body, headerList);
            return correlationid;
        }

        public bool UpdateProcessSchedule(long scheduleProcessID, string scheduleVersion, DateTime? lastInstantiated, DateTime nextScheduled, string repeatSchedule, string instantiatedUsers)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProcessSchedule(scheduleProcessID, scheduleVersion, lastInstantiated, nextScheduled, repeatSchedule, instantiatedUsers);
            return success;
        }

        public Schedule CreateProcessSchedule(long ProcessID, string scheduleVersion, DateTime nextScheduled, string repeatSchedule, string instantiatedUsers)
        {
            long ScheduleID = 0;
            Atul_v1Data adb = new Atul_v1Data();
            Schedule s;
            ScheduleID = adb.CreateProcessSchedule(ProcessID, scheduleVersion, nextScheduled, repeatSchedule, instantiatedUsers);
            s = adb.GetProcessScheduleByID(ScheduleID);
            this.PushNextScheduleToAdminQueue(s, s.NextScheduledDate);
            return s;
        }

        public Schedule GetProcessScheduleByID(long ScheduleID)
        {
            Schedule s;
            Atul_v1Data adb = new Atul_v1Data();
            s = adb.GetProcessScheduleByID(ScheduleID);
            return s;
        }

        public Schedule GetProcessScheduleByProcessID(long ProcessID)
        {
            Schedule s;
            Atul_v1Data adb = new Atul_v1Data();
            s = adb.GetProcessScheduleByProcessID(ProcessID);
            return s;
        }

        public bool DeleteProcessSchedule(long ProcessScheduleID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteProcessSchedule(ProcessScheduleID);
            return success;
        }

        /// <summary>
        /// Gets the instance detail.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string GetInstanceDetail(string AtulInstanceProcessID)
        {
            DataSet dsInstanceDetail = new DataSet("Instance");
            Atul_v1Data adb = new Atul_v1Data();
            DataTable instanceDT = new DataTable("instanceDT");

            DataTable processDT = new DataTable("processDT");
            DataTable subProcessDT = new DataTable("subProcessDT");
            DataTable activityDT = new DataTable("activity");
            DataTable flexfieldDT = new DataTable("flexfield");
            DataTable flexfieldstorageDT = new DataTable("flexfieldstorage");
            //Get The Instance
            instanceDT = adb.GetInstanceProcessByID(Convert.ToInt64(AtulInstanceProcessID));

            //Get The Process
            processDT = adb.GetProcessByID(Convert.ToInt64(instanceDT.Rows[0]["AtulProcessID"].ToString()));

            //Get The Subprocesses
            subProcessDT = adb.GetInstanceSubProcessByID(Convert.ToInt64(AtulInstanceProcessID));

            //Get The SubProcess Activities
            activityDT = adb.GetInstanceProcessActivity(Convert.ToInt64(AtulInstanceProcessID));

            //Get flexfields
            //flexfieldDT = adb.FlexFieldGetByInstanceProcessID(Convert.ToInt64(AtulInstanceProcessID));

            //Get flexfieldstorage
            //flexfieldstorageDT = adb.FlexFieldStorageGetByProcessID(Convert.ToInt64(AtulInstanceProcessID));

            //Make it into one godawful mega dataset
            dsInstanceDetail.Tables.Add(instanceDT);
            dsInstanceDetail.Tables.Add(processDT);
            dsInstanceDetail.Tables.Add(subProcessDT);
            dsInstanceDetail.Tables.Add(activityDT);
            dsInstanceDetail.Tables.Add(flexfieldDT);
            dsInstanceDetail.Tables.Add(flexfieldstorageDT);

            //Convert the whole dataset to XML
            //We do this to avoid the "culture" circular reference and to remove
            //datatypes efficiently
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(dsInstanceDetail.GetXml());
            // Convert XML to a JSON string
            string JSON = JsonMethods.XmlToJSON(doc);

            // Replace \ with \\ because string is being decoded twice
            // JSON = JSON.Replace(@"\", @"\\");
            //this.ProcessCurrentSubProcessActor(Convert.ToInt64(AtulInstanceProcessID));
            return JSON;
        }

        /// <summary>
        /// Gets the providers.
        /// </summary>
        /// <returns></returns>
        public string GetProviders()
        {
            DataSet dsProviders = new DataSet("providers");
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProviders();
            dsProviders.Tables.Add(returnTable);
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(dsProviders.GetXml());
            // Convert XML to a JSON string
            string JSON = JsonMethods.XmlToJSON(doc);
            return JSON;
        }

        /// <summary>
        /// Inserts the provider.
        /// </summary>
        /// <param name="ServiceProviderName">Name of the service provider.</param>
        /// <param name="ServiceProviderDescription">The service provider description.</param>
        /// <param name="AtulServiceProviderClassID">The atul service provider class ID.</param>
        /// <param name="queue">The queue.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="verb">The verb.</param>
        /// <param name="ServiceProviderXML">The service provider XML.</param>
        /// <returns></returns>
        public bool InsertProvider(string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int CreatedBy, string ServiceProviderXML)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.InsertProvider(ServiceProviderName, ServiceProviderDescription, AtulServiceProviderClassID, queue, CreatedBy, ServiceProviderXML);
            return success;
        }

        /// <summary>
        /// Updates the provider.
        /// </summary>
        /// <param name="AtulServiceProviderID">The atul service provider ID.</param>
        /// <param name="ServiceProviderName">Name of the service provider.</param>
        /// <param name="ServiceProviderDescription">The service provider description.</param>
        /// <param name="AtulServiceProviderClassID">The atul service provider class ID.</param>
        /// <param name="WSDL">The WSDL.</param>
        /// <param name="DSN">The DSN.</param>
        /// <param name="verb">The verb.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="ServiceProviderXML">The service provider XML.</param>
        /// <returns></returns>
        public bool UpdateProvider(long AtulServiceProviderID, string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int ModifiedBy, string ServiceProviderXML)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProvider(AtulServiceProviderID, ServiceProviderName, ServiceProviderDescription, AtulServiceProviderClassID, queue, ModifiedBy, ServiceProviderXML);
            return success;
        }

        public Process GetProcessBySummary(string ProcessSummary)
        {
            Process p;
            Atul_v1Data adb = new Atul_v1Data();
            p = adb.GetProcessBySummary(ProcessSummary);
            return p;
        }

        public bool UndeleteInstanceProcess(long InstanceID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UndeleteProcessInstance(InstanceID, ModifiedBy);
            return success;
        }

        public bool UndeleteProcess(long ProcessID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UndeleteProcess(ProcessID, ModifiedBy);
            return success;
        }

        public List<Process> ProcessGetDeleted(int daysBack)
        {
            List<Process> ProcessList = new List<Process>();
            DateTime d = DateTime.Now.AddDays(-(double)daysBack);
            Atul_v1Data adb = new Atul_v1Data();
            ProcessList = adb.ProcessGetDeleted(d);
            return ProcessList;
        }

        public List<ProcessInstance> ProcessInstanceGetDeleted(int daysBack)
        {
            List<ProcessInstance> InstanceList = new List<ProcessInstance>();
            DateTime d = DateTime.Now.AddDays(-(double)daysBack);
            Atul_v1Data adb = new Atul_v1Data();
            InstanceList = adb.ProcessInstanceGetDeleted(d);
            return InstanceList;
        }

        /// <summary>
        /// Upsert provider.
        /// </summary>
        /// <param name="queue">The queue.</param>
        /// <param name="providerXML">The provider XML.</param>
        /// <returns></returns>
        public bool UpSertProvider(string queue, string providerXML)
        {
            StringWriter decodedXML = new StringWriter();
            // Decode the encoded string.
            HttpUtility.HtmlDecode(providerXML, decodedXML);

            bool success = false;
            DataTable pTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            pTable = adb.GetProviders();

            XmlDocument pXML = new XmlDocument();
            pXML.LoadXml(decodedXML.ToString());

            XmlNodeList submittedProviders = pXML.SelectNodes(@"//endpoint/provider");
            foreach (XmlNode xn in submittedProviders)
            {
                int ModifiedBy = -1;
                string xmlproviderName = xn["name"].InnerText;
                string xmlclassid = xn["classid"].InnerText;
                
                string xmlDescription = xn["description"].InnerText;
                //To insert or update, that is the question. We'll add the queue check in when the db gets sorted.
                DataRow providerRow = adb.GetProviderBySearch(xmlproviderName, Convert.ToInt32(xmlclassid), queue);
                string ServiceProviderXML = xn.OuterXml;
                if (providerRow != null)
                {
                    long AtulServiceProviderID = Convert.ToInt64(providerRow["AtulServiceProviderID"]);
                    int AtulServiceProviderClassID = Convert.ToInt32(Convert.ToInt32(xmlclassid));                    
                    success = adb.UpdateProvider(AtulServiceProviderID, xmlproviderName, xmlDescription, AtulServiceProviderClassID, queue, ModifiedBy, ServiceProviderXML);                    
                }
                else
                {                    
                    //insert provider
                    success = adb.InsertProvider(xmlproviderName, xmlDescription, Convert.ToInt32(xmlclassid), queue, ModifiedBy, ServiceProviderXML);
                }
            }
            return success;
        }

        /// <summary>
        /// Adds the activity to activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool AddActivityToActivityGroup(int AtulActivityGroupID, int AtulActivityID, int CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.AddActivityToActivityGroup(AtulActivityGroupID, AtulActivityID, CreatedBy);
            return success;
        }

        /// <summary>
        /// Adds a process manager.
        /// A process can have more than one manager.
        /// This method is intended to create a manager, but is generic since the typeId will change
        /// The typeid should be set in the webconfig and retreived in the logic layer
        /// </summary>
        /// <param name="AtulRemoteSystemID">The atul remote system ID.</param>
        /// <param name="AtulUserTypeID">The atul user type ID.</param>
        /// <param name="RemoteSystemLoginID">The remote system login ID.</param>
        /// <param name="DisplayName">The display name.</param>
        /// <returns></returns>
        public bool AddProcessManager(int AtulRemoteSystemID, int AtulUserTypeID, string RemoteSystemLoginID, string DisplayName)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.AddProcessManager(AtulRemoteSystemID, AtulUserTypeID, RemoteSystemLoginID, DisplayName);
            return success;
        }

        /// <summary>
        /// Creates the activity.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ActivityDescription">The activity description.</param>
        /// <param name="ActivitySummary">The activity summary.</param>
        /// <param name="ActivityProcedure">The activity procedure.</param>
        /// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <param name="OwnedBy">The owned by ID.</param>
        /// <returns></returns>
        public long CreateActivity(long AtulProcessID, long AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, bool deadlineResultsInMissed, int AtulActivitySortOrder, int CreatedBy, int OwnedBy, int deadline, int deadlineTypeID)
        {
            long activityId = 0;
            Atul_v1Data adb = new Atul_v1Data();
            activityId = adb.CreateActivity(AtulProcessID, AtulSubProcessID, ActivityDescription, ActivitySummary, ActivityProcedure, deadlineResultsInMissed, AtulActivitySortOrder, CreatedBy, OwnedBy, deadline, deadlineTypeID);
            return activityId;
        }

        /// <summary>
        /// Creates the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupPurposeID">The atul activity group purpose ID.</param>
        /// <param name="ActivityGroupDescription">The activity group description.</param>
        /// <param name="ActivityGroupSummary">The activity group summary.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool CreateActivityGroup(int AtulActivityGroupPurposeID, string ActivityGroupDescription, string ActivityGroupSummary, int CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.CreateActivityGroup(AtulActivityGroupPurposeID, ActivityGroupDescription, ActivityGroupSummary, CreatedBy);
            return success;
        }

        /// <summary>
        /// Creates the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <param name="OwnedBy">The owned by ID.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <param name="SubjectIdentifier">The identifier for the subject of the instance (e.g. server ID).</param>
        /// <param name="SubjectSummary">The friendly name for the subject of the instance (e.g. host name).</param>
        /// <returns></returns>
        public long CreateInstanceProcess(long AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID, string SubjectIdentifier, string SubjectSummary)
        {
            long processInstanceId = 0;
            Atul_v1Data adb = new Atul_v1Data();
            processInstanceId = adb.CreateInstanceProcess(AtulProcessID, CreatedBy, OwnedBy, AtulProcessStatusID, SubjectIdentifier, SubjectSummary);
            return processInstanceId;
        }

        /// <summary>
        /// Creates the process.
        /// </summary>
        /// <param name="ProcessDescription">The process description.</param>
        /// <param name="ProcessSummary">The process summary.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <param name="DeadLineOffset">The dead line offset.</param>
        /// <returns></returns>
        public long CreateProcess(string ProcessDescription, string ProcessSummary, int CreatedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset)
        {
            long processId = 0;
            Atul_v1Data adb = new Atul_v1Data();
            processId = adb.CreateProcess(ProcessDescription, ProcessSummary, CreatedBy, OwnedBy, AtulProcessStatusID, DeadLineOffset);
            return processId;
        }

        /// <summary>
        /// Creates the sub process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ProcessSubprocessSortOrder">The process subprocess sort order.</param>
        /// <param name="NotificationServiceProvideID">The notification service provide ID.</param>
        /// <param name="NotificationIdentifier">The notification identifier.</param>
        /// <param name="ResponsibilityOf">The responsibility of ID.</param>
        /// <param name="DeadlineOffset">The deadline offset.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool AttachProcessSubProcess(Int64 AtulProcessID, Int64 AtulSubProcessID, int ProcessSubprocessSortOrder, string NotificationIdentifier, int ResponsibilityOf, int DeadlineOffset, int CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.AttachProcessSubProcess(AtulProcessID, AtulSubProcessID, ProcessSubprocessSortOrder, NotificationIdentifier, ResponsibilityOf, DeadlineOffset, CreatedBy);
            return success;
        }

        public long CreateSubProcess(long AtulProcessID, string summary, string description, int sortOrder, string NotificationIdentifier, int ResponsibilityOf, int DeadlineOffset, int CreatedBy, int OwnedBy)
        {
            long subProcessId = 0;
            Atul_v1Data adb = new Atul_v1Data();
            subProcessId = adb.CreateSubProcess(description, summary, CreatedBy, OwnedBy);
            adb.AttachProcessSubProcess(AtulProcessID, subProcessId, sortOrder, NotificationIdentifier, ResponsibilityOf, DeadlineOffset, CreatedBy);
            return subProcessId;
        }

        public bool UpdateActivity(long AtulActivityID, long AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, int AtulActivitySortOrder, int ModifiedBy, int OwnedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateActivity(AtulActivityID, AtulSubProcessID, ActivityDescription, ActivitySummary, ActivityProcedure, AtulActivitySortOrder, ModifiedBy, OwnedBy);
            return success;
        }

        public bool UpdateProcessActivity(long ProcessActivityID, long ProcessID, long ActivityID, int sort, bool deadlineResultsInMissed, int deadlineType, int deadline, int ModifiedBy, long? AutomationServiceProviderID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProcessActivity(ProcessActivityID, ProcessID, ActivityID, sort, deadlineResultsInMissed, deadlineType, deadline, ModifiedBy, AutomationServiceProviderID);
            return success;
        }

        public bool UpdateSubProcess(long SubProcessID, string SubProcessDescription, string SubProcessSummary, int ModifiedBy, int OwnedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateSubProcess(SubProcessID, SubProcessDescription, SubProcessSummary, ModifiedBy, OwnedBy);
            return success;
        }

        public bool UpdateProcess(long ProcessID, string ProcessDescription, string ProcessSummary, int ModifiedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset, long? SubjectServiceProviderID, string ScopeID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProcess(ProcessID, ProcessDescription, ProcessSummary, ModifiedBy, OwnedBy, AtulProcessStatusID, DeadLineOffset, SubjectServiceProviderID, ScopeID);
            return success;
        }

        public bool UpdateActivitySort(long AtulActivityID, int Sort, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateActivitySort(AtulActivityID, Sort, ModifiedBy);
            return success;
        }

        public bool UpdateProcessSubProcessSort(long AtulProcessSubProcessID, int Sort, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProcessSubProcessSort(AtulProcessSubProcessID, Sort, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the activity.
        /// </summary>
        /// <param name="ActivityID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteActivity(long ActivityID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteActivity(ActivityID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteActivityGroup(int AtulActivityGroupID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteActivityGroup(AtulActivityGroupID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the instance process.
        /// </summary>
        /// <returns></returns>
        public bool DeleteInstanceProcess(long AtulInstanceProcessID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteInstanceProcess(AtulInstanceProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the sub process.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteSubProcess(long AtulSubProcessID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteSubProcess(AtulSubProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the instance process activity.
        /// </summary>
        /// <returns></returns>
        public bool DeleteInstanceProcessActivity(int AtulSubProcessID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteInstanceProcessActivity(AtulSubProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the process manager.
        /// TODO: [This is invalid, we would need to specify the process, usertypeID and the userID. Probably need a new proc]
        /// </summary>
        /// <param name="AtulUserID">The atul user ID.</param>
        /// <returns></returns>
        public bool DeleteProcessManager(int AtulUserID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteProcessManager(AtulUserID);
            return success;
        }

        /// <summary>
        /// Enables the activity automation.
        /// TODO: Find/Define appliciable attribute
        /// </summary>
        /// <returns></returns>
        public string EnableActivityAutomation()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.EnableActivityAutomation();
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetAllProcessStatus()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcessStatus();
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetAllDeadlineType()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllDeadlineType();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all activity.
        /// </summary>
        /// <returns></returns>
        public string GetAllActivity()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllActivity();
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetProviderByID(long providerID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProviderByID(providerID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all instance process.
        /// </summary>
        /// <returns></returns>
        public string GetAllInstanceProcess()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllInstanceProcess();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all instance process activity.
        /// </summary>
        /// <returns></returns>
        public string GetAllInstanceProcessActivity()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllInstanceProcessActivity();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all process.
        /// </summary>
        /// <returns></returns>
        public string GetAllProcess()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcess();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all process activity groups.
        /// </summary>
        /// <returns></returns>
        public string GetAllProcessActivityGroups()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcessActivityGroups();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all process sub process.
        /// </summary>
        /// <returns></returns>
        public string GetAllProcessSubProcess()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcessSubProcess();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all process sub process by process ID.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <returns></returns>
        public string GetAllProcessSubProcessByProcessID(Int64 AtulProcessSubprocessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcessSubProcessByProcessID(AtulProcessSubprocessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetAllSubProcessByProcessID(Int64 ProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllSubProcessByProcessID(ProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetAllActivityBySubProcessID(Int64 SubProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllActivityBySubProcessID(SubProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetActivityByID(long ActivityID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetActivityByID(ActivityID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetSubProcessByID(long SubProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetSubProcessByID(SubProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetProcessActivityByProcessIDActivityID(long ProcessID, long ActivityID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProcessActivityByProcessIDActivityID(ProcessID, ActivityID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string GetProcessSubProcessByProcessIDSubProcessID(long ProcessID, long SubProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProcessSubProcessByProcessIDSubProcessID(ProcessID, SubProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Updates the process sub process.
        /// </summary>
        /// <param name="ProcessSubProcessID">The process sub process ID.</param>
        /// <param name="ProcessID">The process ID.</param>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <param name="sort">The sort.</param>
        /// <param name="responsibilityOf">The responsibility of.</param>
        /// <param name="DeadlineOffset">The deadline offset.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="NotificationServiceProviderID">The notification service provider ID.</param>
        /// <returns></returns>
        public bool UpdateProcessSubProcess(long ProcessSubProcessID, long ProcessID, long SubProcessID, int sort, int responsibilityOf, int DeadlineOffset, int ModifiedBy, long? NotificationServiceProviderID)
        {
            bool success = false;
            if (NotificationServiceProviderID == 0)
            {
                NotificationServiceProviderID = null;
            }
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateProcessSubProcess(ProcessSubProcessID, ProcessID, SubProcessID, sort, responsibilityOf, DeadlineOffset, ModifiedBy, NotificationServiceProviderID);
            if (success && NotificationServiceProviderID != null)
            {
                // this.AddSubProcessProviderParameters(Convert.ToInt64(NotificationServiceProviderID), SubProcessID);
            }
            return success;
        }

        public string GetProviderParameters(long providerId, string ProviderVerb)
        {
            //get the provider XML
            DataTable returnTable = new DataTable();
            DataTable flexfields = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.ServiceProviderGetByID(providerId);
            flexfields = adb.FlexFieldGet();
            string ProviderXML = returnTable.Rows[0]["ServiceProviderXML"].ToString();
            string ProviderName = returnTable.Rows[0]["ServiceProviderName"].ToString();
            
            string JSON = string.Empty;
            XmlDocument pxml = new XmlDocument();
            pxml.LoadXml(ProviderXML);
            XmlNodeList parameters = pxml.SelectNodes("//verb[name='"+ProviderVerb+"']/parameter");
            XmlDocument xdoc = new XmlDocument();
            xdoc.LoadXml(@"<parameters></parameters>");

            foreach (XmlNode p in parameters)
            {
                XmlElement e = xdoc.CreateElement("parameter");
                e.InnerText = p.InnerText;
                xdoc.AppendChild(e);
            }

            JSON = JsonMethods.XmlToJSON(xdoc);

            return JSON;
        }

        private bool AddSubProcessProviderParameters(long NotificationServiceProviderID, long SubProcessID)
        {
            // DOESN'T SEEM TO BE IN USE
            // will need to be redone before can be used.

            bool success = false;
            //get the provider XML
/*             DataTable returnTable = new DataTable();
            DataTable flexfields = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.ServiceProviderGetByID(NotificationServiceProviderID);
            flexfields = adb.FlexFieldGet();
            string ProviderXML = returnTable.Rows[0]["ServiceProviderXML"].ToString();
            string ProviderName = returnTable.Rows[0]["ServiceProviderName"].ToString();
            string ProviderClass = returnTable.Rows[0]["AtulServiceProviderClassID"].ToString();
            //string ProviderVerb = returnTable.Rows[0]["verb"].ToString();
            XmlDocument pxml = new XmlDocument();
            pxml.LoadXml(ProviderXML);
           XmlNodeList verbs = pxml.SelectNodes("//provider/verb");

            foreach (XmlNode v in verbs)
            {   //Parse out the params
                if (p["classid"].InnerText == ProviderClass && p["name"].InnerText == ProviderName && p["verb"].InnerText == ProviderVerb)
                {
                    XmlNodeList parameters = p.SelectNodes("parameter");
                    foreach (XmlNode parameter in parameters)
                    {
                        DataRow[] filteredFlexFields = flexfields.Select(string.Format("TokenName = '{0}' AND AtulSubProcessID = '{1}'", parameter.InnerText, SubProcessID));
                        if (filteredFlexFields.Length == 0)
                        {
                            //Add flexfields for the subprocess
                            this.FlexFieldUpsert(parameter.InnerText, 1, -1, 0, SubProcessID, 0, "", string.Format("Parameter{0}", parameter.InnerText), string.Format("{0} Parameter {1}", ProviderName, parameter.InnerText), 1);
                        }
                    }
                }
            } */

            return success;
        }

        /// <summary>
        /// Gets all process sub process by process ID.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <returns></returns>
        public string GetProcessSubProcessDetailsBySubProcessID(Int64 AtulSubProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProcessSubProcessDetailsBySubProcessID(AtulSubProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all process sub process activity.
        /// TODO: New proc needed to get a subprocess's activities
        /// </summary>
        /// <returns></returns>
        public string GetAllProcessSubProcessActivity()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetAllProcessSubProcessActivity();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets the instance process by ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string GetInstanceProcessByID(Int64 AtulInstanceProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetInstanceProcessByID(AtulInstanceProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets all the instance processes for a given process ID.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <returns></returns>
        public string GetInstanceProcessByProcessID(Int64 AtulProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetInstanceProcessByProcessID(AtulProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets the process by ID.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <returns></returns>
        public string GetProcessByID(Int64 AtulProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProcessByID(AtulProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Inserts the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        public string InsertInstanceProcess(int AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.InsertInstanceProcess(AtulProcessID, CreatedBy, OwnedBy, AtulProcessStatusID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Inserts the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        public string InsertInstanceProcessActivity(int AtulInstanceProcessID, int AtulProcessActivityID, int InstanceProcessActivityCompletedBy, int CreatedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.InsertInstanceProcessActivity(AtulInstanceProcessID, AtulProcessActivityID, InstanceProcessActivityCompletedBy, CreatedBy);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Sets the activity dead line.
        /// </summary>
        /// <returns></returns>
        public string SetActivityDeadLine()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.SetActivityDeadLine();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Sets the activity man minutes.
        /// TODO: Add man minute column, update proc(s)
        /// </summary>
        /// <returns></returns>
        public string SetActivityManMinutes()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.SetActivityManMinutes();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Sets the activity prerequsite activity group.
        /// TODO: Request proc to set prereq group Params: ActivityID, GroupID
        /// </summary>
        /// <returns></returns>
        public string SetActivityPrerequsiteActivityGroup()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.SetActivityPrerequsiteActivityGroup();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Updates the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessActivityID">The atul instance process activity ID.</param>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="ProcessActivityCompleted">The process activity completed.</param>
        /// <param name="ProcessActivityDidNotApply">The process activity did not apply.</param>
        /// <param name="ProcessActivityDeadlineMissed">The process activity deadline missed.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public string UpdateInstanceProcessActivity(int AtulInstanceProcessActivityID, int AtulInstanceProcessID, int AtulProcessActivityID, int ProcessActivityCompleted, int ProcessActivityDidNotApply, int ProcessActivityDeadlineMissed, int InstanceProcessActivityCompletedBy, int ModifiedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateInstanceProcessActivity(AtulInstanceProcessActivityID, AtulInstanceProcessID, AtulProcessActivityID, ProcessActivityCompleted, ProcessActivityDidNotApply, ProcessActivityDeadlineMissed, InstanceProcessActivityCompletedBy, ModifiedBy);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Updates the running process specification.
        /// TODO: MAtch to docs, discuss with Cory
        /// </summary>
        /// <returns></returns>
        public string UpdateRunningProcessSpecification()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateRunningProcessSpecification();
            return JsonMethods.GetJSONString(returnTable);
        }

        /*OVERLOADS for the rest interface*/

        /// <summary>
        /// Adds the activity to activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool AddActivityToActivityGroup(string AtulActivityGroupID, string AtulActivityID, string CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.AddActivityToActivityGroup(Convert.ToInt32(AtulActivityGroupID), Convert.ToInt32(AtulActivityID), Convert.ToInt32(CreatedBy));
            return success;
        }

        /// <summary>
        /// Adds a process manager.
        /// A process can have more than one manager.
        /// This method is intended to create a manager, but is generic since the typeId will change
        /// The typeid should be set in the webconfig and retreived in the logic layer
        /// </summary>
        /// <param name="AtulRemoteSystemID">The atul remote system ID.</param>
        /// <param name="AtulUserTypeID">The atul user type ID.</param>
        /// <param name="RemoteSystemLoginID">The remote system login ID.</param>
        /// <param name="DisplayName">The display name.</param>
        /// <returns></returns>
        public bool AddProcessManager(string AtulRemoteSystemID, string AtulUserTypeID, string RemoteSystemLoginID, string DisplayName)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.AddProcessManager(Convert.ToInt32(AtulRemoteSystemID), Convert.ToInt32(AtulUserTypeID), RemoteSystemLoginID, DisplayName);
            return success;
        }

        /// <summary>
        /// Creates the activity.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ActivityDescription">The activity description.</param>
        /// <param name="ActivitySummary">The activity summary.</param>
        /// <param name="ActivityProcedure">The activity procedure.</param>
        /// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <param name="OwnedBy">The owned by ID.</param>
        /// <returns></returns>
        public bool CreateActivity(string AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, string AtulActivitySortOrder, string CreatedBy, string OwnedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            // success = adb.CreateActivity(AtulProcessID, AtulSubProcessID, ActivityDescription, ActivitySummary, ActivityProcedure, deadlineResultsInMissed, AtulActivitySortOrder, CreatedBy, OwnedBy, deadline, deadlineTypeID);
            return success;
        }

        /// <summary>
        /// Creates the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupPurposeID">The atul activity group purpose ID.</param>
        /// <param name="ActivityGroupDescription">The activity group description.</param>
        /// <param name="ActivityGroupSummary">The activity group summary.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool CreateActivityGroup(string AtulActivityGroupPurposeID, string ActivityGroupDescription, string ActivityGroupSummary, string CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.CreateActivityGroup(Convert.ToInt32(AtulActivityGroupPurposeID), ActivityGroupDescription, ActivityGroupSummary, Convert.ToInt32(CreatedBy));
            return success;
        }

        /// <summary>
        /// Creates the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <param name="OwnedBy">The owned by ID.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <param name="SubjectIdentifier">The identifier for the subject of the instance (e.g. server ID).</param>
        /// <param name="SubjectSummary">The friendly name for the subject of the instance (e.g. host name).</param>
        /// <returns></returns>
        public long CreateInstanceProcess(string AtulProcessID, string CreatedBy, string OwnedBy, string AtulProcessStatusID, string SubjectIdentifier, string SubjectSummary)
        {
            long processInstanceId = 0;
            Atul_v1Data adb = new Atul_v1Data();
            processInstanceId = adb.CreateInstanceProcess(Convert.ToInt64(AtulProcessID), Convert.ToInt32(CreatedBy), Convert.ToInt32(OwnedBy), Convert.ToInt32(AtulProcessStatusID), SubjectIdentifier, SubjectSummary);
            //process subject provider
            this.ProcessCurrentSubProcessActor(processInstanceId);
            return processInstanceId;
        }

        /// <summary>
        /// Creates the process.
        /// </summary>
        /// <param name="ProcessDescription">The process description.</param>
        /// <param name="ProcessSummary">The process summary.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <param name="AtulUserDefinedAttributeID">The atul user defined attribute ID.</param>
        /// <param name="DeadLineOffset">The dead line offset.</param>
        /// <returns></returns>
        public long CreateProcess(string ProcessDescription, string ProcessSummary, string CreatedBy, string OwnedBy, string AtulProcessStatusID, string AtulUserDefinedAttributeID, string DeadLineOffset)
        {
            long success = 0;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.CreateProcess(ProcessDescription, ProcessSummary, Convert.ToInt32(CreatedBy), Convert.ToInt32(OwnedBy), Convert.ToInt32(AtulProcessStatusID), Convert.ToInt32(DeadLineOffset));
            return success;
        }

        /// <summary>
        /// Creates the sub process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ProcessSubprocessSortOrder">The process subprocess sort order.</param>
        /// <param name="NotificationServiceProvideID">The notification service provide ID.</param>
        /// <param name="NotificationIdentifier">The notification identifier.</param>
        /// <param name="ResponsibilityOf">The responsibility of ID.</param>
        /// <param name="DeadlineOffset">The deadline offset.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        public bool CreateSubProcess(string AtulProcessID, string AtulSubProcessID, string ProcessSubprocessSortOrder, string NotificationServiceProvideID, string NotificationIdentifier, string ResponsibilityOf, string DeadlineOffset, string CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            //success = adb.CreateSubProcess(Convert.ToInt32(AtulProcessID), Convert.ToInt32(AtulSubProcessID), Convert.ToInt32(ProcessSubprocessSortOrder), Convert.ToInt32(NotificationServiceProvideID), NotificationIdentifier, Convert.ToInt32(ResponsibilityOf), Convert.ToInt32(DeadlineOffset), Convert.ToInt32(CreatedBy));
            return success;
        }

        /// <summary>
        /// Deletes the activity.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <returns></returns>
        public bool DeleteActivity(string AtulProcessID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteActivity(Convert.ToInt32(AtulProcessID), Convert.ToInt32(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Deletes the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteActivityGroup(string AtulActivityGroupID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteActivityGroup(Convert.ToInt32(AtulActivityGroupID), Convert.ToInt32(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Deletes the process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteProcess(long AtulProcessID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteProcess(AtulProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the sub process.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteSubProcess(string AtulSubProcessID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteSubProcess(Convert.ToInt32(AtulSubProcessID), Convert.ToInt32(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Deletes the instance process activity.
        /// </summary>
        /// <returns></returns>
        public bool DeleteInstanceProcessActivity(string AtulSubProcessID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteInstanceProcessActivity(Convert.ToInt32(AtulSubProcessID), Convert.ToInt32(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Deletes the process manager.
        /// TODO: [This is invalid, we would need to specify the process, usertypeID and the userID. Probably need a new proc]
        /// </summary>
        /// <param name="AtulUserID">The atul user ID.</param>
        /// <returns></returns>
        public bool DeleteProcessManager(string AtulUserID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteProcessManager(Convert.ToInt32(AtulUserID));
            return success;
        }

        /// <summary>
        /// Gets the instance process by ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string GetInstanceProcessByID(string AtulInstanceProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetInstanceProcessByID(Convert.ToInt32(AtulInstanceProcessID));
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Inserts the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        public string InsertInstanceProcess(string AtulProcessID, string CreatedBy, string OwnedBy, string AtulProcessStatusID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.InsertInstanceProcess(Convert.ToInt32(AtulProcessID), Convert.ToInt32(CreatedBy), Convert.ToInt32(OwnedBy), Convert.ToInt32(AtulProcessStatusID));
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Inserts the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        public string InsertInstanceProcessActivity(string AtulInstanceProcessID, string AtulProcessActivityID, string InstanceProcessActivityCompletedBy, string CreatedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.InsertInstanceProcessActivity(Convert.ToInt32(AtulInstanceProcessID), Convert.ToInt32(AtulProcessActivityID), Convert.ToInt32(InstanceProcessActivityCompletedBy), Convert.ToInt32(CreatedBy));
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Updates the instance process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        public bool UpdateInstanceProcess(long AtulInstanceProcessID, long AtulProcessID, int ModifiedBy, int OwnedBy, int AtulProcessStatusID, string SubjectIdentifier, string SubjectSummary, long? SubjectServiceProviderID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.UpdateInstanceProcess(AtulInstanceProcessID, AtulProcessID, ModifiedBy, OwnedBy, AtulProcessStatusID, SubjectIdentifier, SubjectSummary, SubjectServiceProviderID);
            return success;
        }

        /// <summary>
        /// Updates the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessActivityID">The atul instance process activity ID.</param>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="ProcessActivityCompleted">The process activity completed.</param>
        /// <param name="ProcessActivityDidNotApply">The process activity did not apply.</param>
        /// <param name="ProcessActivityDeadlineMissed">The process activity deadline missed.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public string UpdateInstanceProcessActivity(string AtulInstanceProcessActivityID, string AtulInstanceProcessID, string AtulProcessActivityID, string ProcessActivityCompleted, string ProcessActivityDidNotApply, string ProcessActivityDeadlineMissed, string InstanceProcessActivityCompletedBy, string ModifiedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateInstanceProcessActivity(Convert.ToInt32(AtulInstanceProcessActivityID), Convert.ToInt32(AtulInstanceProcessID), Convert.ToInt32(AtulProcessActivityID), Convert.ToInt32(ProcessActivityCompleted), Convert.ToInt32(ProcessActivityDidNotApply), Convert.ToInt32(ProcessActivityDeadlineMissed), Convert.ToInt32(InstanceProcessActivityCompletedBy), Convert.ToInt32(ModifiedBy));
            this.ProcessCurrentSubProcessActor(Convert.ToInt64(AtulInstanceProcessID));
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Instances the process activity complete.
        /// </summary>
        /// <param name="AtulInstanceProcessActivityID">The atul instance process activity ID.</param>
        /// <param name="statusBit">The status bit.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool InstanceProcessActivityComplete(Int64 AtulInstanceProcessActivityID, int statusBit, Int64 ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.InstanceProcessActivityComplete(Convert.ToInt64(AtulInstanceProcessActivityID), statusBit, Convert.ToInt64(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Gets the current instance sub process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string GetCurrentInstanceSubProcess(Int64 AtulInstanceProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetCurrentInstanceSubProcess(AtulInstanceProcessID);
            this.ProcessCurrentSubProcessActor(AtulInstanceProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets the provider info by sub process ID.
        /// </summary>
        /// <param name="AtulInstanceProcessSubProcessID">The atul instance process sub process ID.</param>
        /// <returns></returns>
        public string GetProviderInfoBySubProcessID(Int64 AtulInstanceProcessSubProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.GetProviderInfoBySubProcessID(AtulInstanceProcessSubProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Gets the variables get by scriptname.
        /// </summary>
        /// <param name="ScriptName">Name of the script.</param>
        /// <returns></returns>
        public string ConfigVariablesGetByScriptName(string ScriptName)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.ConfigVariablesGetByScriptName(ScriptName);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// delete the Flexfield
        /// </summary>
        /// <param name="AtulFlexFieldID">The atul flexfield ID.</param>
        /// <param name="ModifiedBy">The modifiedby ID.</param>
        /// <returns></returns>
        public bool FlexFieldDelete(long AtulFlexFieldID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.FlexFieldDelete(AtulFlexFieldID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// get the Flexfield.
        /// </summary>
        /// <returns></returns>
        public string FlexFieldGet()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldGet();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// get the Flexfield by ID.
        /// </summary>
        /// <param name="AtulFlexFieldID">The atul flex field ID.</param>
        /// <returns></returns>
        public string FlexFieldGetByID(long AtulFlexFieldID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldGetByID(AtulFlexFieldID);
            return JsonMethods.GetJSONString(returnTable);
        }

        //needs nullable
        /// <summary>
        /// get the Flexfield by search.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <returns></returns>
        public string FlexFieldGetBySearch(long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldGetBySearch(AtulProcessID, AtulSubProcessID, AtulActivityID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// Upsert the flexfield.
        /// </summary>
        /// <param name="TokenName">Name of the token.</param>
        /// <param name="IsRequired">The is required.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <param name="DefaultTokenValue">The default token value.</param>
        /// <param name="FriendlyName">Name of the friendly.</param>
        /// <param name="ToolTip">The tool tip.</param>
        /// <param name="IsParameter">The is parameter.</param>
        /// <returns></returns>
        public bool FlexFieldUpsert(string TokenName, int IsRequired, long CreatedBy, long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID, string DefaultTokenValue, string FriendlyName, string ToolTip, int IsParameter)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.FlexFieldUpsert(TokenName, IsRequired, CreatedBy, AtulProcessID, AtulSubProcessID, AtulActivityID, DefaultTokenValue, FriendlyName, ToolTip, IsParameter);
            return success;
        }

        /// <summary>
        /// delete the flexfield.
        /// </summary>
        /// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool FlexFieldStorageDelete(long AtulFlexFieldStorageID, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.FlexFieldStorageDelete(AtulFlexFieldStorageID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Get the flexfield storage.
        /// </summary>
        /// <returns></returns>
        public string FlexFieldStorageGet()
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldStorageGet();
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// get the flexfield by ID.
        /// </summary>
        /// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
        /// <returns></returns>
        public string FlexFieldStorageGetByID(long AtulFlexFieldStorageID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldStorageGetByID(AtulFlexFieldStorageID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// get the flexfield by process ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        public string FlexFieldStorageGetByProcessID(long AtulInstanceProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldStorageGetByProcessID(AtulInstanceProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        public string FlexFieldsGetByProcessID(long AtulProcessID)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldsGetByProcessID(AtulProcessID);
            return JsonMethods.GetJSONString(returnTable);
        }

        /// <summary>
        /// insert the flexfield.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="tokenValue">The token value.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        public string FlexFieldStorageInsert(long AtulInstanceProcessID, long AtulFlexFieldID, string tokenValue, long CreatedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.FlexFieldStorageInsert(AtulInstanceProcessID, AtulFlexFieldID, tokenValue, CreatedBy);
            return JsonMethods.GetJSONString(returnTable);
        }

        //should this return a bool?
        /// <summary>
        /// update the flexfield.
        /// </summary>
        /// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="TokenValue">The token value.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool FlexFieldStorageUpdate(long AtulFlexFieldStorageID, long AtulInstanceProcessID, string TokenValue, long ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.FlexFieldStorageUpdate(Convert.ToInt64(AtulFlexFieldStorageID), Convert.ToInt64(AtulInstanceProcessID), TokenValue, Convert.ToInt64(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Update the flexfield.
        /// </summary>
        /// <param name="AtulFlexFieldID">The atul flex field ID.</param>
        /// <param name="TokenName">Name of the token.</param>
        /// <param name="IsRequired">The is required.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <returns></returns>
        public bool FlexFieldUpdate(long AtulFlexFieldID, string TokenName, int IsRequired, long ModifiedBy, long AtulProcessID, long AtulSubProcessID, long AtulActivityID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.FlexFieldUpdate(AtulFlexFieldID, TokenName, IsRequired, ModifiedBy, AtulProcessID, AtulSubProcessID, AtulActivityID);
            return success;
        }
    }

    /// <summary>
    ///
    /// </summary>
    public static class JsonMethods
    {
        private static List<Dictionary<string, object>>
            RowsToDictionary(DataTable table)
        {
            List<Dictionary<string, object>> objs =
                new List<Dictionary<string, object>>();
            foreach (DataRow dr in table.Rows)
            {
                Dictionary<string, object> drow = new Dictionary<string, object>();
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    drow.Add(table.Columns[i].ColumnName, dr[i]);
                }
                objs.Add(drow);
            }

            return objs;
        }

        /// <summary>
        /// String to JSON string.
        /// </summary>
        /// <param name="sValue">The s value.</param>
        /// <returns></returns>
        public static string StringToJSONString(string sValue)
        {
            System.Runtime.Serialization.Json.DataContractJsonSerializer serializer = new System.Runtime.Serialization.Json.DataContractJsonSerializer(sValue.GetType());
            MemoryStream ms = new MemoryStream();
            serializer.WriteObject(ms, sValue);
            string json = Encoding.Default.GetString(ms.ToArray());
            return json;
        }

        /// <summary>
        /// Toes the json.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <returns></returns>
        public static Dictionary<string, object> ToJson(DataTable table)
        {
            Dictionary<string, object> d = new Dictionary<string, object>();
            d.Add(table.TableName, RowsToDictionary(table));
            return d;
        }

        /// <summary>
        /// Toes the json.
        /// </summary>
        /// <param name="data">The data.</param>
        /// <returns></returns>
        public static Dictionary<string, object> ToJson(DataSet data)
        {
            Dictionary<string, object> d = new Dictionary<string, object>();
            foreach (DataTable table in data.Tables)
            {
                d.Add(table.TableName, RowsToDictionary(table));
            }
            return d;
        }

        /// <summary>
        /// Gets the JSON string.
        /// </summary>
        /// <param name="Dt">The dt.</param>
        /// <returns></returns>
        public static string GetJSONString(DataTable Dt)
        {
            string[] StrDc = new string[Dt.Columns.Count];
            string HeadStr = string.Empty;

            for (int i = 0; i < Dt.Columns.Count; i++)
            {
                StrDc[i] = Dt.Columns[i].Caption;
                HeadStr += "\"" + StrDc[i] + "\" : \"" + StrDc[i] + i.ToString() + "¾" + "\",";
                //HeadStr += SafeJSON("\"" + StrDc[i] + "\" : \"" + StrDc[i] + i.ToString() + "¾" + "\",");
            }

            HeadStr = HeadStr.Substring(0, HeadStr.Length - 1);

            StringBuilder Sb = new StringBuilder();
            Sb.Append("{\"" + Dt.TableName + "\" : [");

            for (int i = 0; i < Dt.Rows.Count; i++)
            {
                string TempStr = HeadStr;
                Sb.Append("{");

                for (int j = 0; j < Dt.Columns.Count; j++)
                {
                    TempStr = TempStr.Replace(Dt.Columns[j] + j.ToString() + "¾", SafeJSON(Dt.Rows[i][j].ToString()));
                }

                //Sb.Append(SafeJSON(TempStr) + "},");
                Sb.Append(TempStr + "},");
            }

            Sb = new StringBuilder(Sb.ToString().Substring(0, Sb.ToString().Length - 1));
            Sb.Append("]}");

            return Sb.ToString();
        }

        public static string XmlToJSON(XmlDocument xmlDoc)
        {
            StringBuilder sbJSON = new StringBuilder();
            sbJSON.Append("{ ");
            XmlToJSONnode(sbJSON, xmlDoc.DocumentElement, true);
            sbJSON.Append("}");
            return sbJSON.ToString();
        }

        //  XmlToJSONnode:  Output an XmlElement, possibly as part of a higher array
        private static void XmlToJSONnode(StringBuilder sbJSON, XmlElement node, bool showNodeName)
        {
            if (showNodeName)
                sbJSON.Append("\"" + SafeJSON(node.Name) + "\": ");
            sbJSON.Append("{");
            // Build a sorted list of key-value pairs
            //  where   key is case-sensitive nodeName
            //          value is an ArrayList of string or XmlElement
            //  so that we know whether the nodeName is an array or not.
            SortedList childNodeNames = new SortedList();

            //  Add in all node attributes
            if (node.Attributes != null)
                foreach (XmlAttribute attr in node.Attributes)
                    StoreChildNode(childNodeNames, attr.Name, SafeJSON(attr.InnerText));

            //  Add in all nodes
            foreach (XmlNode cnode in node.ChildNodes)
            {
                if (cnode is XmlText)
                    StoreChildNode(childNodeNames, "value", SafeJSON(cnode.InnerText));
                else if (cnode is XmlElement)
                    StoreChildNode(childNodeNames, cnode.Name, cnode);
            }

            // Now output all stored info
            foreach (string childname in childNodeNames.Keys)
            {
                ArrayList alChild = (ArrayList)childNodeNames[childname];
                if (alChild.Count == 1)
                    OutputNode(childname, alChild[0], sbJSON, true);
                else
                {
                    sbJSON.Append(" \"" + SafeJSON(childname) + "\": [ ");
                    foreach (object Child in alChild)
                        OutputNode(childname, Child, sbJSON, false);
                    sbJSON.Remove(sbJSON.Length - 2, 2);
                    sbJSON.Append(" ], ");
                }
            }
            sbJSON.Remove(sbJSON.Length - 2, 2);
            sbJSON.Append(" }");
        }

        //  StoreChildNode: Store data associated with each nodeName
        //                  so that we know whether the nodeName is an array or not.
        private static void StoreChildNode(SortedList childNodeNames, string nodeName, object nodeValue)
        {
            // Pre-process contraction of XmlElement-s
            if (nodeValue is XmlElement)
            {
                // Convert  <aa></aa> into "aa":null
                //          <aa>xx</aa> into "aa":"xx"
                XmlNode cnode = (XmlNode)nodeValue;
                if (cnode.Attributes.Count == 0)
                {
                    XmlNodeList children = cnode.ChildNodes;
                    if (children.Count == 0)
                        nodeValue = null;
                    else if (children.Count == 1 && (children[0] is XmlText))
                        nodeValue = ((XmlText)(children[0])).InnerText;
                }
            }
            // Add nodeValue to ArrayList associated with each nodeName
            // If nodeName doesn't exist then add it
            object oValuesAL = childNodeNames[nodeName];
            ArrayList ValuesAL;
            if (oValuesAL == null)
            {
                ValuesAL = new ArrayList();
                childNodeNames[nodeName] = ValuesAL;
            }
            else
                ValuesAL = (ArrayList)oValuesAL;
            ValuesAL.Add(nodeValue);
        }

        private static void OutputNode(string childname, object alChild, StringBuilder sbJSON, bool showNodeName)
        {
            if (alChild == null)
            {
                if (showNodeName)
                    sbJSON.Append("\"" + SafeJSON(childname) + "\": ");
                sbJSON.Append("null");
            }
            else if (alChild is string)
            {
                if (showNodeName)
                    sbJSON.Append("\"" + SafeJSON(childname) + "\": ");
                string sChild = (string)alChild;
                sChild = sChild.Trim();
                sbJSON.Append("\"" + SafeJSON(sChild) + "\"");
            }
            else
                XmlToJSONnode(sbJSON, (XmlElement)alChild, showNodeName);
            sbJSON.Append(", ");
        }

        // Make a string safe for JSON
        private static string SafeJSON(string sIn)
        {
            StringBuilder sbOut = new StringBuilder(sIn.Length);
            foreach (char ch in sIn)
            {
                if (Char.IsControl(ch) || ch == '\'')
                {
                    int ich = (int)ch;
                    sbOut.Append(@"\u" + ich.ToString("x4"));
                    continue;
                }
                else if (ch == '\"' || ch == '\\' || ch == '/')
                {
                    sbOut.Append('\\');
                }
                sbOut.Append(ch);
            }
            HttpServerUtility u = HttpContext.Current.Server;
            string dirtyString = sbOut.ToString();
            string cleanHTMLEncodedString = u.HtmlEncode(sbOut.ToString());
            return dirtyString;
        }
    }
}