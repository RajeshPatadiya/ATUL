using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Data;
using System.ServiceModel.Activation;
using System.Web.Script.Services;

namespace ATUL_v1
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    /// <summary>
    /// 
    /// </summary>
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.Single,
                 ConcurrencyMode = ConcurrencyMode.Single, IncludeExceptionDetailInFaults = true)]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    [Serializable]
    public class AtulRest : IAtulRest
    {
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
        /// <returns></returns>
        public string HelloWorldString(string word)
        {
            return word;
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
        public long CreateActivity(string processID, string subProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, bool deadlineResultsInMissed, int AtulActivitySortOrder, int CreatedBy, int OwnedBy, int deadline, int deadlineTypeID)
        {
            long activityId = 0;
            long AtulProcessID = Convert.ToInt64(processID);
            long AtulSubProcessID = Convert.ToInt64(subProcessID);
            Atul_v1Data adb = new Atul_v1Data();
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
        /// <returns></returns>
        public bool CreateInstanceProcess(int AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.CreateInstanceProcess(AtulProcessID, CreatedBy, OwnedBy, AtulProcessStatusID);
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
        public bool CreateSubProcess(int AtulProcessID, int AtulSubProcessID, int ProcessSubprocessSortOrder, int NotificationServiceProvideID, string NotificationIdentifier, int ResponsibilityOf, int DeadlineOffset, int CreatedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            //success = adb.CreateSubProcess(AtulProcessID, AtulSubProcessID, ProcessSubprocessSortOrder, NotificationServiceProvideID, NotificationIdentifier, ResponsibilityOf, DeadlineOffset, CreatedBy);
            return success;
        }
        /// <summary>
        /// Deletes the activity.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteActivity(int AtulProcessID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteActivity(AtulProcessID, ModifiedBy);
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
        public bool DeleteInstanceProcess(int AtulInstanceProcessID, int ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteInstanceProcess(AtulInstanceProcessID, ModifiedBy);
            return success;
        }
        /// <summary>
        /// Deletes the process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteProcess(int AtulProcessID, int ModifiedBy)
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
        public bool DeleteSubProcess(int AtulSubProcessID, int ModifiedBy)
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
        /// Updates the instance process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        public string UpdateInstanceProcess(int AtulInstanceProcessID, int AtulProcessID, int ModifiedBy, int OwnedBy, int AtulProcessStatusID)
        {

            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateInstanceProcess(AtulInstanceProcessID, AtulProcessID, ModifiedBy, OwnedBy, AtulProcessStatusID);
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
           // success = adb.CreateActivity(Convert.ToInt32(AtulSubProcessID), ActivityDescription, ActivitySummary, ActivityProcedure, Convert.ToInt32(AtulActivitySortOrder), Convert.ToInt32(CreatedBy), Convert.ToInt32(OwnedBy));
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
        /// <returns></returns>
        public bool CreateInstanceProcess(string AtulProcessID, string CreatedBy, string OwnedBy, string AtulProcessStatusID)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.CreateInstanceProcess(Convert.ToInt32(AtulProcessID), Convert.ToInt32(CreatedBy), Convert.ToInt32(OwnedBy), Convert.ToInt32(AtulProcessStatusID));
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
        /// <param name="AtulUserDefinedAttributeID">The atul user defined attribute ID.</param>
        /// <param name="DeadLineOffset">The dead line offset.</param>
        /// <returns></returns>
        public long CreateProcess(string ProcessDescription, string ProcessSummary, string CreatedBy, string OwnedBy, string AtulProcessStatusID, string DeadLineOffset)
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
        /// Deletes the instance process.
        /// </summary>
        /// <returns></returns>        
        public bool DeleteInstanceProcess(string AtulInstanceProcessID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteInstanceProcess(Convert.ToInt32(AtulInstanceProcessID), Convert.ToInt32(ModifiedBy));
            return success;
        }
        /// <summary>
        /// Deletes the process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        public bool DeleteProcess(string AtulProcessID, string ModifiedBy)
        {
            bool success = false;
            Atul_v1Data adb = new Atul_v1Data();
            success = adb.DeleteProcess(Convert.ToInt32(AtulProcessID), Convert.ToInt32(ModifiedBy));
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
        public string UpdateInstanceProcess(string AtulInstanceProcessID, string AtulProcessID, string ModifiedBy, string OwnedBy, string AtulProcessStatusID)
        {

            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateInstanceProcess(Convert.ToInt32(AtulInstanceProcessID), Convert.ToInt32(AtulProcessID), Convert.ToInt32(ModifiedBy), Convert.ToInt32(OwnedBy), Convert.ToInt32(AtulProcessStatusID));
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
        public string UpdateInstanceProcessActivity(string AtulInstanceProcessActivityID, string AtulInstanceProcessID, string AtulProcessActivityID, string ProcessActivityCompleted, string ProcessActivityDidNotApply, string ProcessActivityDeadlineMissed, string InstanceProcessActivityCompletedBy, string ModifiedBy)
        {
            DataTable returnTable = new DataTable();
            Atul_v1Data adb = new Atul_v1Data();
            returnTable = adb.UpdateInstanceProcessActivity(Convert.ToInt32(AtulInstanceProcessActivityID), Convert.ToInt32(AtulInstanceProcessID), Convert.ToInt32(AtulProcessActivityID), Convert.ToInt32(ProcessActivityCompleted), Convert.ToInt32(ProcessActivityDidNotApply), Convert.ToInt32(ProcessActivityDeadlineMissed), Convert.ToInt32(InstanceProcessActivityCompletedBy), Convert.ToInt32(ModifiedBy));
            return JsonMethods.GetJSONString(returnTable);
        }

    }


}