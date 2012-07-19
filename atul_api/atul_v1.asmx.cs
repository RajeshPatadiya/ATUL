/**
Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Web.Script.Services;
using System.Web.Services;

namespace ATUL_v1
{
    /// <summary>
    /// ATUL Web Service
    /// Provides methods for the generic checklist project.
    /// Important terms:
    /// Process - A checklist
    /// SubProcess - A group of related steps in a checklist
    /// Activity - A step in a checklist
    /// ActivityGroup - A group of steps, generally steps that must be done before a subsequent step can be started.
    /// InstanceProcess - An instance of a checklist
    /// </summary>
    [WebService(Namespace = "http://atul.godaddy.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [ScriptService]
    public class ATUL : System.Web.Services.WebService
    {
        private bool debug = Convert.ToBoolean(ConfigurationManager.AppSettings["debug"]);

        //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        private string UpdateRunningProcessSpecification()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.UpdateRunningProcessSpecification();
            return d;
        }

        [WebMethod]
        public string GetProviderParameters(string providerId, string verb)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProviderParameters(Convert.ToInt64(providerId), verb);
            return d;
        }

        /// <summary>
        /// Adds the activity to activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <returns></returns>
        [WebMethod]
        public bool AddActivityToActivityGroup(int AtulActivityGroupID, int AtulActivityID, int CreatedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
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
        [WebMethod]
        public bool AddProcessManager(int AtulRemoteSystemID, int AtulUserTypeID, string RemoteSystemLoginID, string DisplayName)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.AddProcessManager(AtulRemoteSystemID, AtulUserTypeID, RemoteSystemLoginID, DisplayName);
            return success;
        }

        /// <summary>
        /// Creates the activity.
        /// </summary>
        /// <param name="processID">The process ID.</param>
        /// <param name="subProcessID">The sub process ID.</param>
        /// <param name="ActivityDescription">The activity description.</param>
        /// <param name="ActivitySummary">The activity summary.</param>
        /// <param name="ActivityProcedure">The activity procedure.</param>
        /// <param name="deadlineResultsInMissed">if set to <c>true</c> [deadline results in missed].</param>
        /// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
        /// <param name="CreatedBy">The created by ID.</param>
        /// <param name="OwnedBy">The owned by ID.</param>
        /// <param name="deadline">The deadline.</param>
        /// <param name="deadlineTypeID">The deadline type ID.</param>
        /// <returns></returns>
        [WebMethod]
        public long CreateActivity(string processID, string subProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, bool deadlineResultsInMissed, int AtulActivitySortOrder, int CreatedBy, int OwnedBy, int deadline, int deadlineTypeID)
        {
            long activityId = 0;
            long AtulProcessID = Convert.ToInt64(processID);
            long AtulSubProcessID = Convert.ToInt64(subProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            activityId = adb.CreateActivity(AtulProcessID, AtulSubProcessID, ActivityDescription, ActivitySummary, ActivityProcedure,
                deadlineResultsInMissed, AtulActivitySortOrder, CreatedBy, OwnedBy, deadline, deadlineTypeID);
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
        [WebMethod]
        public bool CreateActivityGroup(int AtulActivityGroupPurposeID, string ActivityGroupDescription, string ActivityGroupSummary, int CreatedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
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
        /// <param name="SubjectIdentifier">The subject identifier.</param>
        /// <param name="SubjectSummary">The subject summary.</param>
        /// <returns></returns>
        [WebMethod]
        public long CreateInstanceProcess(long AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID, string SubjectIdentifier, string SubjectSummary)
        {
            long processInstanceId = 0;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            processInstanceId = adb.CreateInstanceProcess(AtulProcessID, CreatedBy, OwnedBy, AtulProcessStatusID, SubjectIdentifier, SubjectSummary);
            return processInstanceId;
        }

        [WebMethod]
        public Schedule CreateProcessSchedule(string ProcessID, string scheduleVersion, string nextScheduled, string repeatSchedule, string instantiatedUsers)
        {
            Schedule s;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            DateTime NextScheduledDate = DateTime.Parse(nextScheduled);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            s = adb.CreateProcessSchedule(AtulProcessID, scheduleVersion, NextScheduledDate, repeatSchedule, instantiatedUsers);
            return s;
        }

        [WebMethod]
        public bool UpdateProcessScheduleByProcessID(string ProcessID, string scheduleVersion, string nextScheduled, string repeatSchedule, string instantiatedUsers)
        {
            bool success = false;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            DateTime NextScheduledDate = DateTime.Parse(nextScheduled);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Schedule s = adb.GetProcessScheduleByProcessID(AtulProcessID);
            success = adb.UpdateProcessSchedule(s.AtulProcessScheduleID, scheduleVersion, s.LastInstantiated, NextScheduledDate, repeatSchedule, instantiatedUsers);
            return success;
        }

        [WebMethod]
        public Schedule GetProcessScheduleByProcessID(string ProcessID)
        {
            Schedule s;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            s = adb.GetProcessScheduleByProcessID(AtulProcessID);
            return s;
        }

        [WebMethod]
        public Schedule GetProcessScheduleByID(string ScheduleID)
        {
            Schedule s;
            long AtulProcessScheduleID = Convert.ToInt64(ScheduleID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            s = adb.GetProcessScheduleByID(AtulProcessScheduleID);
            return s;
        }

        [WebMethod]
        public bool CreateScheduledProcessInstance(long ProcessID, string scheduleVersion)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.CreateScheduledProcessInstance(ProcessID, scheduleVersion);
            return success;
        }

        [WebMethod]
        public bool DeleteProcessSchedule(string ProcessScheduleID)
        {
            bool success = false;
            long AtulProcessScheduleID = Convert.ToInt64(ProcessScheduleID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteProcessSchedule(AtulProcessScheduleID);
            return success;
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
        [WebMethod]
        public long CreateProcess(string ProcessDescription, string ProcessSummary, int CreatedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset)
        {
            long processId = 0;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Process p = adb.GetProcessBySummary(ProcessSummary);
            if (p == null)
            {
                processId = adb.CreateProcess(ProcessDescription, ProcessSummary, CreatedBy, OwnedBy, AtulProcessStatusID, DeadLineOffset);
            }
            else
            {
                throw new Exception("A Process with that name already exists.");
            }
            return processId;
        }

        [WebMethod]
        public Process GetProcessBySummary(string ProcessSummary)
        {
            Process p;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            p = adb.GetProcessBySummary(ProcessSummary);
            return p;
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
        [WebMethod]
        public long CreateSubProcess(string AtulProcessID, string summary, string description, int sortOrder, string NotificationIdentifier, int ResponsibilityOf, int DeadlineOffset, int CreatedBy, int OwnedBy)
        {
            long processId = Convert.ToInt64(AtulProcessID);
            long subProcessId = 0;

            AtulBusinessLogic adb = new AtulBusinessLogic();
            subProcessId = adb.CreateSubProcess(processId, summary, description, sortOrder, NotificationIdentifier, ResponsibilityOf, DeadlineOffset, CreatedBy, OwnedBy);
            return subProcessId;
        }

        /// <summary>
        /// Deletes the activity.
        /// </summary>
        /// <param name="ActivityID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteActivity(string ActivityID, int ModifiedBy)
        {
            bool success = false;
            long AtulActivityID = Convert.ToInt64(ActivityID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteActivity(AtulActivityID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteActivityGroup(int AtulActivityGroupID, int ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteActivityGroup(AtulActivityGroupID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the instance process.
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteInstanceProcess(string AtulInstanceProcessID, string ModifiedBy)
        {
            bool success = false;
            long InstanceID = Convert.ToInt64(AtulInstanceProcessID);
            long ModifiedByID = Convert.ToInt64(ModifiedBy);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteInstanceProcess(InstanceID, ModifiedByID);
            return success;
        }

        /// <summary>
        /// Deletes the process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteProcess(string AtulProcessID, string ModifiedBy)
        {
            bool success = false;
            long ProcessID = Convert.ToInt64(AtulProcessID);
            long ModifiedByID = Convert.ToInt64(ModifiedBy);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteProcess(ProcessID, ModifiedByID);
            return success;
        }

        [WebMethod]
        public List<ProcessInstance> InstanceProcessGetDeleted(int daysBack)
        {
            List<ProcessInstance> InstanceList = new List<ProcessInstance>();
            AtulBusinessLogic adb = new AtulBusinessLogic();
            InstanceList = adb.ProcessInstanceGetDeleted(daysBack);
            return InstanceList;
        }

        [WebMethod]
        public bool UndeleteInstanceProcess(string InstanceID, string ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            long AtulInstanceID = Convert.ToInt64(InstanceID);
            long ModifiedByID = Convert.ToInt64(ModifiedBy);
            success = adb.UndeleteInstanceProcess(AtulInstanceID, ModifiedByID);
            return success;
        }

        [WebMethod]
        public List<Process> ProcessGetDeleted(int daysBack)
        {
            List<Process> ProcessList = new List<Process>();
            AtulBusinessLogic adb = new AtulBusinessLogic();
            ProcessList = adb.ProcessGetDeleted(daysBack);
            return ProcessList;
        }

        [WebMethod]
        public bool UndeleteProcess(string ProcessID, string ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long ModifiedByID = Convert.ToInt64(ModifiedBy);
            success = adb.UndeleteProcess(AtulProcessID, ModifiedByID);
            return success;
        }

        /// <summary>
        /// Deletes the sub process.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteSubProcess(string SubProcessID, int ModifiedBy)
        {
            bool success = false;
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteSubProcess(AtulSubProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the instance process activity.
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteInstanceProcessActivity(int AtulSubProcessID, int ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteInstanceProcessActivity(AtulSubProcessID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Deletes the process manager.
        /// TODO: [This is invalid, we would need to specify the process, usertypeID and the userID. Probably need a new proc]
        /// </summary>
        /// <param name="AtulUserID">The atul user ID.</param>
        /// <returns></returns>
        [WebMethod]
        public bool DeleteProcessManager(int AtulUserID)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.DeleteProcessManager(AtulUserID);
            return success;
        }

        /// <summary>
        /// Describes the actor.
        /// </summary>
        /// <param name="queuename">The queuename.</param>
        /// <returns></returns>
        [WebMethod]
        public string DescribeActor(string queuename)
        {
            Trace.WriteLineIf(debug, DateTime.Now + string.Format(" Building describe message for queue: {0}", queuename));
            string env = ConfigurationManager.AppSettings["environment"].ToString();
            string correlationid = "";
            string describeMessage = "A simple DESCRIBE request";
            List<KeyValuePair<string, string>> headerList = new List<KeyValuePair<string, string>>();
            headerList.Add(new KeyValuePair<string, string>("VERB", "DESCRIBE"));
            headerList.Add(new KeyValuePair<string, string>("RETURNQUEUE", ConfigurationManager.AppSettings[env + "." + "AtulAdminQueue"].ToString()));
            AtulBusinessLogic adb = new AtulBusinessLogic();
            correlationid = adb.PushToQueue(queuename, describeMessage, headerList);
            return correlationid;
        }

        /// <summary>
        /// Enables the activity automation.
        /// TODO: Find/Define appliciable attribute
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string EnableActivityAutomation()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.EnableActivityAutomation();
            return d;
        }

        [WebMethod]
        public string GetAllProcessStatus()
        {
            string Statuses;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Statuses = adb.GetAllProcessStatus();
            return Statuses;
        }

        [WebMethod]
        public string GetAllDeadlineType()
        {
            string Types;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Types = adb.GetAllDeadlineType();
            return Types;
        }

        /// <summary>
        /// Gets all activity.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllActivity()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllActivity();
            return d;
        }

        /// <summary>
        /// Gets all instance process.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllInstanceProcess()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllInstanceProcess();
            return d;
        }

        /// <summary>
        /// Gets all instance process activity.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllInstanceProcessActivity()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllInstanceProcessActivity();
            return d;
        }

        /// <summary>
        /// Gets all process.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllProcess()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllProcess();
            return d;
        }

        /// <summary>
        /// Gets all process activity groups.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllProcessActivityGroups()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllProcessActivityGroups();
            return d;
        }

        /// <summary>
        /// Gets all process sub process.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllProcessSubProcess()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllProcessSubProcess();
            return d;
        }

        /// <summary>
        /// Gets all process sub process by process ID.
        /// </summary>
        /// <param name="AtulProcessSubprocessID">The atul process subprocess ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllProcessSubProcessByProcessID(string AtulProcessSubprocessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllProcessSubProcessByProcessID(Convert.ToInt64(AtulProcessSubprocessID));
            return d;
        }

        /// <summary>
        /// Gets all sub process by process ID.
        /// </summary>
        /// <param name="ProcessID">The process ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetAllSubProcessByProcessID(string ProcessID)
        {
            string d = string.Empty;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllSubProcessByProcessID(AtulProcessID);
            return d;
        }

        /// <summary>
        /// Gets all activity by sub process ID.
        /// </summary>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetAllActivityBySubProcessID(string SubProcessID)
        {
            string d = string.Empty;
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllActivityBySubProcessID(AtulSubProcessID);
            return d;
        }

        /// <summary>
        /// Gets the sub process by ID.
        /// </summary>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetSubProcessByID(string SubProcessID)
        {
            string d = string.Empty;
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetSubProcessByID(AtulSubProcessID);
            return d;
        }

        /// <summary>
        /// Gets the activity by ID.
        /// </summary>
        /// <param name="ActivityID">The activity ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetActivityByID(string ActivityID)
        {
            string d = string.Empty;
            long AtulActivityID = Convert.ToInt64(ActivityID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetActivityByID(AtulActivityID);
            return d;
        }

        /// <summary>
        /// Gets the providers.
        /// </summary>
        /// <returns></returns>
        [WebMethod]
        public string GetProviders()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProviders();
            return d;
        }

        [WebMethod]
        public string GetProviderByID(string ProviderID)
        {
            string d = string.Empty;
            long AtulProviderID = Convert.ToInt64(ProviderID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProviderByID(AtulProviderID);
            return d;
        }

        /// <summary>
        /// Inserts the provider.
        /// </summary>
        /// <param name="ServiceProviderName">Name of the service provider.</param>
        /// <param name="ServiceProviderDescription">The service provider description.</param>
        /// <param name="AtulServiceProviderClassID">The atul service provider class ID.</param>
        /// <param name="WSDL">The WSDL.</param>
        /// <param name="DSN">The DSN.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool InsertProvider(string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int CreatedBy, string ServiceProviderXML)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.InsertProvider(ServiceProviderName.Trim(), ServiceProviderDescription.Trim(), AtulServiceProviderClassID, queue.Trim(), CreatedBy, ServiceProviderXML.Trim());
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
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateProvider(long AtulServiceProviderID, string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int ModifiedBy, string ServiceProviderXML)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateProvider(AtulServiceProviderID, ServiceProviderName, ServiceProviderDescription, AtulServiceProviderClassID, queue, ModifiedBy, ServiceProviderXML);
            return success;
        }

        /// <summary>
        /// Updates the provider.
        /// </summary>
        /// <param name="queue">The queue.</param>
        /// <param name="ServiceProviderXML">The service provider XML.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpSertProvider(string queue, string ServiceProviderXML)
        {
            Trace.WriteLine(DateTime.Now + " Upserting Providers");
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            try
            {
                success = adb.UpSertProvider(queue, ServiceProviderXML);
            }
            catch (Exception e)
            {
                Trace.WriteLineIf(debug, DateTime.Now + " " + e.Message);
                success = false;
            }
            return success;
        }

        /// <summary>
        /// Updates the activity.
        /// </summary>
        /// <param name="ActivityID">The activity ID.</param>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <param name="ActivityDescription">The activity description.</param>
        /// <param name="ActivitySummary">The activity summary.</param>
        /// <param name="ActivityProcedure">The activity procedure.</param>
        /// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateActivity(string ActivityID, string SubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, int AtulActivitySortOrder, int ModifiedBy, int OwnedBy)
        {
            bool success = false;
            long AtulActivityID = Convert.ToInt64(ActivityID);
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateActivity(AtulActivityID, AtulSubProcessID, ActivityDescription, ActivitySummary, ActivityProcedure, AtulActivitySortOrder, ModifiedBy, OwnedBy);
            return success;
        }

        /// <summary>
        /// Updates the sub process.
        /// </summary>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <param name="SubProcessDescription">The sub process description.</param>
        /// <param name="SubProcessSummary">The sub process summary.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateSubProcess(string SubProcessID, string SubProcessDescription, string SubProcessSummary, int ModifiedBy, int OwnedBy)
        {
            bool success = false;
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateSubProcess(AtulSubProcessID, SubProcessDescription, SubProcessSummary, ModifiedBy, OwnedBy);
            return success;
        }

        /// <summary>
        /// Updates the process.
        /// </summary>
        /// <param name="ProcessID">The process ID.</param>
        /// <param name="ProcessDescription">The process description.</param>
        /// <param name="ProcessSummary">The process summary.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <param name="DeadLineOffset">The dead line offset.</param>
        /// <param name="SubjectServiceProviderID">The subject service provider ID.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateProcess(string ProcessID, string ProcessDescription, string ProcessSummary, int ModifiedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset, string SubjectServiceProviderID, string ScopeID)
        {
            bool success = false;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long? SSID = null;
            if (SubjectServiceProviderID.Trim() != string.Empty)
            {
                SSID = Convert.ToInt64(SubjectServiceProviderID);
            }

            AtulBusinessLogic adb = new AtulBusinessLogic();
            Process p = adb.GetProcessBySummary(ProcessSummary);
            if (p == null || p.AtulProcessID == AtulProcessID)
            {
                success = adb.UpdateProcess(AtulProcessID, ProcessDescription, ProcessSummary, ModifiedBy, OwnedBy, AtulProcessStatusID, DeadLineOffset, SSID, ScopeID);
            }
            return success;
        }

        /// <summary>
        /// Updates the activity sort.
        /// </summary>
        /// <param name="ActivityID">The activity ID.</param>
        /// <param name="Sort">The sort.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateActivitySort(string ActivityID, int Sort, int ModifiedBy)
        {
            bool success = false;
            long AtulActivityID = Convert.ToInt64(ActivityID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateActivitySort(AtulActivityID, Sort, ModifiedBy);
            return success;
        }

        /// <summary>
        /// Updates the process sub process sort.
        /// </summary>
        /// <param name="ProcessSubProcessID">The process sub process ID.</param>
        /// <param name="Sort">The sort.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateProcessSubProcessSort(string ProcessSubProcessID, int Sort, int ModifiedBy)
        {
            bool success = false;
            long AtulProcessSubProcessID = Convert.ToInt64(ProcessSubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateProcessSubProcessSort(AtulProcessSubProcessID, Sort, ModifiedBy);
            return success;
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
        [WebMethod]
        public bool UpdateProcessSubProcess(string ProcessSubProcessID, string ProcessID, string SubProcessID, int sort, int responsibilityOf, int DeadlineOffset, int ModifiedBy, string NotificationServiceProviderID)
        {
            bool success = false;
            long AtulProcessSubProcessID = Convert.ToInt64(ProcessSubProcessID);
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            long? providerId;
            if (NotificationServiceProviderID == null || NotificationServiceProviderID.Trim() == "")
            {
                providerId = null;
            }
            else
            {
                providerId = Convert.ToInt64(NotificationServiceProviderID);
            }
            success = adb.UpdateProcessSubProcess(AtulProcessSubProcessID, AtulProcessID, AtulSubProcessID, sort, responsibilityOf, DeadlineOffset, ModifiedBy, providerId);
            return success;
        }

        /// <summary>
        /// Gets the process activity by process ID activity ID.
        /// </summary>
        /// <param name="ProcessID">The process ID.</param>
        /// <param name="ActivityID">The activity ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetProcessActivityByProcessIDActivityID(string ProcessID, string ActivityID)
        {
            string d = string.Empty;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long AtulActivityID = Convert.ToInt64(ActivityID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProcessActivityByProcessIDActivityID(AtulProcessID, AtulActivityID);
            return d;
        }

        /// <summary>
        /// Updates the process activity.
        /// </summary>
        /// <param name="ProcessActivityID">The process activity ID.</param>
        /// <param name="ProcessID">The process ID.</param>
        /// <param name="ActivityID">The activity ID.</param>
        /// <param name="sort">The sort.</param>
        /// <param name="deadlineResultsInMissed">if set to <c>true</c> [deadline results in missed].</param>
        /// <param name="deadlineType">Type of the deadline.</param>
        /// <param name="deadline">The deadline.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="AtulServiceProviderID">The atul service provider ID.</param>
        /// <returns></returns>
        [WebMethod]
        public bool UpdateProcessActivity(string ProcessActivityID, string ProcessID, string ActivityID, int sort, bool deadlineResultsInMissed, int deadlineType, int deadline, int ModifiedBy, long? AutomationServiceProviderID)
        {
            if (AutomationServiceProviderID == 0) { AutomationServiceProviderID = null; }
            bool success = false;
            long AtulProcessActivityID = Convert.ToInt64(ProcessActivityID);
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long AtulActivityID = Convert.ToInt64(ActivityID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.UpdateProcessActivity(AtulProcessActivityID, AtulProcessID, AtulActivityID, sort, deadlineResultsInMissed, deadlineType, deadline, ModifiedBy, AutomationServiceProviderID);
            return success;
        }

        /// <summary>
        /// Gets the process sub process by process ID sub process ID.
        /// </summary>
        /// <param name="ProcessID">The process ID.</param>
        /// <param name="SubProcessID">The sub process ID.</param>
        /// <returns></returns>
        [WebMethod]
        public string GetProcessSubProcessByProcessIDSubProcessID(string ProcessID, string SubProcessID)
        {
            string d = string.Empty;
            long AtulProcessID = Convert.ToInt64(ProcessID);
            long AtulSubProcessID = Convert.ToInt64(SubProcessID);
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProcessSubProcessByProcessIDSubProcessID(AtulProcessID, AtulSubProcessID);
            return d;
        }

        /// <summary>
        /// Gets the process sub process details by sub process ID.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetProcessSubProcessDetailsBySubProcessID(string AtulSubProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProcessSubProcessDetailsBySubProcessID(Convert.ToInt64(AtulSubProcessID));
            return d;
        }

        /// <summary>
        /// Gets all process sub process activity.
        /// TODO: New proc needed to get a subprocess's activities
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetAllProcessSubProcessActivity()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetAllProcessSubProcessActivity();
            return d;
        }

        /// <summary>
        /// Gets the instance process by ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetInstanceProcessByID(string AtulInstanceProcessID)
        {//GetInstanceDetail(string AtulInstanceProcessID)
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetInstanceProcessByID(Convert.ToInt64(AtulInstanceProcessID));
            return d;
        }

        /// <summary>
        /// Gets the current instance sub process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetCurrentInstanceSubProcess(Int64 AtulInstanceProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetCurrentInstanceSubProcess(Convert.ToInt64(AtulInstanceProcessID));
            return d;
        }

        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetProviderInfoBySubProcessID(Int64 AtulInstanceProcessSubProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProviderInfoBySubProcessID(Convert.ToInt64(AtulInstanceProcessSubProcessID));
            return d;
        }

        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetInstanceProcessByProcessID(string AtulProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetInstanceProcessByProcessID(Convert.ToInt64(AtulProcessID));
            return d;
        }

        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetInstanceDetail(string AtulInstanceProcessID)
        {//
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetInstanceDetail(AtulInstanceProcessID);
            return d;
        }

        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetProcessByID(string AtulProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.GetProcessByID(Convert.ToInt64(AtulProcessID));
            return d;
        }

        /// <summary>
        /// Inserts the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string InsertInstanceProcess(int AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.InsertInstanceProcess(AtulProcessID, CreatedBy, OwnedBy, AtulProcessStatusID);
            return d;
        }

        /// <summary>
        /// Inserts the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string InsertInstanceProcessActivity(int AtulInstanceProcessID, int AtulProcessActivityID, int InstanceProcessActivityCompletedBy, int CreatedBy)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.InsertInstanceProcessActivity(AtulInstanceProcessID, AtulProcessActivityID, InstanceProcessActivityCompletedBy, CreatedBy);
            return d;
        }

        /// <summary>
        /// Sets the activity dead line.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string SetActivityDeadLine()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.SetActivityDeadLine();
            return d;
        }

        /// <summary>
        /// Sets the activity man minutes.
        /// TODO: Add man minute column, update proc(s)
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string SetActivityManMinutes()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.SetActivityManMinutes();
            return d;
        }

        /// <summary>
        /// Sets the activity prerequsite activity group.
        /// TODO: Request proc to set prereq group Params: ActivityID, GroupID
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string SetActivityPrerequsiteActivityGroup()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.SetActivityPrerequsiteActivityGroup();
            return d;
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
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool UpdateInstanceProcess(string AtulInstanceProcessID, string AtulProcessID, int ModifiedBy, int OwnedBy, int AtulProcessStatusID, string SubjectIdentifier, string SubjectSummary, string SubjectServiceProviderID)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            long InstanceProcessID = Convert.ToInt64(AtulInstanceProcessID);
            long ProcessID = Convert.ToInt64(AtulProcessID);
            long? SSPID;
            if (SubjectServiceProviderID.Trim() == string.Empty)
            {
                SSPID = null;
            }
            else
            {
                SSPID = Convert.ToInt64(SubjectServiceProviderID);
            }
            success = adb.UpdateInstanceProcess(InstanceProcessID, ProcessID, ModifiedBy, OwnedBy, AtulProcessStatusID, SubjectIdentifier, SubjectSummary, SSPID);
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
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string UpdateInstanceProcessActivity(int AtulInstanceProcessActivityID, int AtulInstanceProcessID, int AtulProcessActivityID, int ProcessActivityCompleted, int ProcessActivityDidNotApply, int ProcessActivityDeadlineMissed, int InstanceProcessActivityCompletedBy, int ModifiedBy)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.UpdateInstanceProcessActivity(AtulInstanceProcessActivityID, AtulInstanceProcessID, AtulProcessActivityID, ProcessActivityCompleted, ProcessActivityDidNotApply, ProcessActivityDeadlineMissed, InstanceProcessActivityCompletedBy, ModifiedBy);
            return d;
        }

        /// <summary>
        /// Gets the config variables by scriptname.
        /// </summary>
        /// <param name="ScriptName">Name of the script.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string GetConfigVariablesByScriptName(string ScriptName)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.ConfigVariablesGetByScriptName(ScriptName);
            return d;
        }

        /// <summary>
        /// Instances the process activity complete.
        /// </summary>
        /// <param name="AtulInstanceProcessActivityID">The atul instance process activity ID.</param>
        /// <param name="statusBit">The status bit.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool InstanceProcessActivityComplete(string AtulInstanceProcessActivityID, int statusBit, string ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.InstanceProcessActivityComplete(Convert.ToInt64(AtulInstanceProcessActivityID), statusBit, Convert.ToInt64(ModifiedBy));
            return success;
        }

        /// <summary>
        /// delete the Flexfield
        /// </summary>
        /// <param name="AtulFlexFieldID">The atul flexfield ID.</param>
        /// <param name="ModifiedBy">The modifiedby ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool FlexFieldDelete(long AtulFlexFieldID, long ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.FlexFieldDelete(AtulFlexFieldID, ModifiedBy);
            return success;
        }

        /// <summary>
        /// get the Flexfield.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldsGetByProcessID(long AtulProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldsGetByProcessID(AtulProcessID);
            return d;
        }

        /// <summary>
        /// get the Flexfield.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldGet()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldGet();
            return d;
        }

        /// <summary>
        /// get the Flexfield by ID.
        /// </summary>
        /// <param name="AtulFlexFieldID">The atul flex field ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldGetByID(long AtulFlexFieldID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldGetByID(AtulFlexFieldID);
            return d;
        }

        //needs nullable
        /// <summary>
        /// get the Flexfield by search.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldGetBySearch(string AtulProcessID, string AtulSubProcessID, string AtulActivityID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldGetBySearch(Convert.ToInt64(AtulProcessID), Convert.ToInt64(AtulSubProcessID), Convert.ToInt64(AtulActivityID));
            return d;
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
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool FlexFieldUpsert(string TokenName, int IsRequired, string CreatedBy, string AtulProcessID, string AtulSubProcessID, string AtulActivityID, string DefaultTokenValue, string FriendlyName, string ToolTip, int IsParameter)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.FlexFieldUpsert(TokenName, IsRequired, Convert.ToInt64(CreatedBy), Convert.ToInt64(AtulProcessID), Convert.ToInt64(AtulSubProcessID), Convert.ToInt64(AtulActivityID), DefaultTokenValue, FriendlyName, ToolTip, IsParameter);
            return success;
        }

        /// <summary>
        /// delete the flexfield.
        /// </summary>
        /// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool FlexFieldStorageDelete(string AtulFlexFieldStorageID, string ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            success = adb.FlexFieldStorageDelete(Convert.ToInt64(AtulFlexFieldStorageID), Convert.ToInt64(ModifiedBy));
            return success;
        }

        /// <summary>
        /// Get the flexfield storage.
        /// </summary>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldStorageGet()
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldStorageGet();
            return d;
        }

        /// <summary>
        /// get the flexfield by ID.
        /// </summary>
        /// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldStorageGetByID(string AtulFlexFieldStorageID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldStorageGetByID(Convert.ToInt64(AtulFlexFieldStorageID));
            return d;
        }

        /// <summary>
        /// get the flexfield by process ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldStorageGetByProcessID(string AtulInstanceProcessID)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.FlexFieldStorageGetByProcessID(Convert.ToInt64(AtulInstanceProcessID));
            return d;
        }

        /// <summary>
        /// insert the flexfield.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="tokenValue">The token value.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public string FlexFieldStorageInsert(string AtulInstanceProcessID, long AtulFlexFieldID, string tokenValue, string CreatedBy)
        {
            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Trace.WriteLineIf(debug, tokenValue);
            d = adb.FlexFieldStorageInsert(Convert.ToInt64(AtulInstanceProcessID), Convert.ToInt64(AtulFlexFieldID), tokenValue, Convert.ToInt64(CreatedBy));
            return d;
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
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool FlexFieldStorageUpdate(string AtulFlexFieldStorageID, string AtulInstanceProcessID, string TokenValue, string ModifiedBy)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
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
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        [WebMethod]
        public bool FlexFieldUpdate(string AtulFlexFieldID, string TokenName, int IsRequired, string ModifiedBy, string AtulProcessID, string AtulSubProcessID, string AtulActivityID)
        {
            bool success = false;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            Trace.WriteLineIf(debug, TokenName);
            success = adb.FlexFieldUpdate(Convert.ToInt64(AtulFlexFieldID), TokenName, IsRequired, Convert.ToInt64(ModifiedBy), Convert.ToInt64(AtulProcessID), Convert.ToInt64(AtulSubProcessID), Convert.ToInt64(AtulActivityID));
            return success;
        }

        [WebMethod]
        public string PushToQueue(string queue, string body, string headers)
        {
            List<KeyValuePair<string, string>> headerList = new List<KeyValuePair<string, string>>();
            try
            {
                string[] parts = headers.Split(new char[] { ',' });
                foreach (string part in parts)
                {
                    if (part.Trim() != string.Empty && part != null)
                    {
                        string[] x = part.Split(new char[] { ':' });
                        if (x.Length > 1)
                        {
                            headerList.Add(new KeyValuePair<string, string>(x[0], x[1]));
                        }
                    }
                }
            }

            catch (Exception e)
            {
                throw new Exception("Headers may be in invalid format.");
            }

            string d = string.Empty;
            AtulBusinessLogic adb = new AtulBusinessLogic();
            d = adb.PushToQueue(queue.Trim(), body.Trim(), headerList);
            return d;
        }

        [WebMethod]
        public List<string> GetTokenKeys(string xml)
        {
            List<string> keys = new List<string>();
            TokenManager t = new TokenManager();
            t.Load(xml);
            keys = t.GetTokenKeys();
            return keys;
        }

        [WebMethod]
        public string DeTokenizeString(string tokenizedString, string tokenKeyXML)
        {
            string detokenized = string.Empty;
            TokenManager t = new TokenManager();
            t.Load(tokenKeyXML);
            detokenized = t.ProcessTokenizedText(tokenizedString);
            return detokenized;
        }

        [WebMethod]
        public string GetQueueMessageByCorrelationID(string queue, string correlationID)
        {
            string msg = string.Empty;
            AtulBusinessLogic b = new AtulBusinessLogic();
            msg = b.GetQueueMessageByCorrelationID(queue, correlationID);
            return msg;
        }
    }
}