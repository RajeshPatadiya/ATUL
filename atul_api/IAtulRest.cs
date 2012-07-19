/**
  Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
using System.ServiceModel;
using System.ServiceModel.Web;

namespace ATUL_v1
{
    /// <summary>
    ///
    /// </summary>
    [ServiceContractAttribute]
    public interface IAtulRest
    {
        /// <summary>
        /// Helloes the world bool.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.HelloWorldBool, BodyStyle = WebMessageBodyStyle.Bare)]
        bool HelloWorldBool();

        /// <summary>
        /// Helloes the world string.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.HelloWorldString, BodyStyle = WebMessageBodyStyle.Bare)]
        string HelloWorldString(string word);

        /// <summary>
        /// Adds the activity to activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="AtulActivityID">The atul activity ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.AddActivityToActivityGroup, BodyStyle = WebMessageBodyStyle.Bare)]
        bool AddActivityToActivityGroup(string AtulActivityGroupID, string AtulActivityID, string CreatedBy);

        /// <summary>
        /// Adds the process manager.
        /// </summary>
        /// <param name="AtulRemoteSystemID">The atul remote system ID.</param>
        /// <param name="AtulUserTypeID">The atul user type ID.</param>
        /// <param name="RemoteSystemLoginID">The remote system login ID.</param>
        /// <param name="DisplayName">The display name.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.AddProcessManager, BodyStyle = WebMessageBodyStyle.Bare)]
        bool AddProcessManager(string AtulRemoteSystemID, string AtulUserTypeID, string RemoteSystemLoginID, string DisplayName);

        /// <summary>
        /// Creates the activity.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ActivityDescription">The activity description.</param>
        /// <param name="ActivitySummary">The activity summary.</param>
        /// <param name="ActivityProcedure">The activity procedure.</param>
        /// <param name="AtulActivitySortOrder">The atul activity sort order.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.CreateActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CreateActivity(string AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, string AtulActivitySortOrder, string CreatedBy, string OwnedBy);

        /// <summary>
        /// Creates the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupPurposeID">The atul activity group purpose ID.</param>
        /// <param name="ActivityGroupDescription">The activity group description.</param>
        /// <param name="ActivityGroupSummary">The activity group summary.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.CreateActivityGroup, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CreateActivityGroup(string AtulActivityGroupPurposeID, string ActivityGroupDescription, string ActivityGroupSummary, string CreatedBy);

        /// <summary>
        /// Creates the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.CreateInstanceProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CreateInstanceProcess(string AtulProcessID, string CreatedBy, string OwnedBy, string AtulProcessStatusID);

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
        /*  [OperationContract]
          [WebGet(UriTemplate = Routing.CreateProcess, BodyStyle = WebMessageBodyStyle.Bare)]
          bool CreateProcess(string ProcessDescription, string ProcessSummary, string CreatedBy, string OwnedBy, string AtulProcessStatusID, string DeadLineOffset);

         */

        /// <summary>
        /// Creates the sub process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ProcessSubprocessSortOrder">The process subprocess sort order.</param>
        /// <param name="NotificationServiceProvideID">The notification service provide ID.</param>
        /// <param name="NotificationIdentifier">The notification identifier.</param>
        /// <param name="ResponsibilityOf">The responsibility of.</param>
        /// <param name="DeadlineOffset">The deadline offset.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.CreateSubProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CreateSubProcess(string AtulProcessID, string AtulSubProcessID, string ProcessSubprocessSortOrder, string NotificationServiceProvideID, string NotificationIdentifier, string ResponsibilityOf, string DeadlineOffset, string CreatedBy);

        /// <summary>
        /// Deletes the activity.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteActivity(string AtulProcessID, string ModifiedBy);

        /// <summary>
        /// Deletes the activity group.
        /// </summary>
        /// <param name="AtulActivityGroupID">The atul activity group ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteActivityGroup, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteActivityGroup(string AtulActivityGroupID, string ModifiedBy);

        /// <summary>
        /// Deletes the instance process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteInstanceProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteInstanceProcess(string AtulInstanceProcessID, string ModifiedBy);

        /// <summary>
        /// Deletes the process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteProcess(string AtulProcessID, string ModifiedBy);

        /// <summary>
        /// Deletes the sub process.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteSubProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteSubProcess(string AtulSubProcessID, string ModifiedBy);

        /// <summary>
        /// Deletes the instance process activity.
        /// </summary>
        /// <param name="AtulSubProcessID">The atul sub process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteInstanceProcessActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteInstanceProcessActivity(string AtulSubProcessID, string ModifiedBy);

        /// <summary>
        /// Deletes the process manager.
        /// </summary>
        /// <param name="AtulUserID">The atul user ID.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.DeleteProcessManager, BodyStyle = WebMessageBodyStyle.Bare)]
        bool DeleteProcessManager(string AtulUserID);

        /// <summary>
        /// Enables the activity automation.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.EnableActivityAutomation, BodyStyle = WebMessageBodyStyle.Bare)]
        string EnableActivityAutomation();

        /// <summary>
        /// Gets all activity.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllActivity();

        /// <summary>
        /// Gets all instance process.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllInstanceProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllInstanceProcess();

        /// <summary>
        /// Gets all instance process activity.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllInstanceProcessActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllInstanceProcessActivity();

        /// <summary>
        /// Gets all process.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllProcess();

        /// <summary>
        /// Gets all process activity groups.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllProcessActivityGroups, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllProcessActivityGroups();

        /// <summary>
        /// Gets all process sub process.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllProcessSubProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllProcessSubProcess();

        /// <summary>
        /// Gets all process sub process activity.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetAllProcessSubProcessActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetAllProcessSubProcessActivity();

        /// <summary>
        /// Gets the instance process by ID.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.GetInstanceProcessByID, BodyStyle = WebMessageBodyStyle.Bare)]
        string GetInstanceProcessByID(string AtulInstanceProcessID);

        /// <summary>
        /// Inserts the instance process.
        /// </summary>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.InsertInstanceProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        string InsertInstanceProcess(string AtulProcessID, string CreatedBy, string OwnedBy, string AtulProcessStatusID);

        /// <summary>
        /// Inserts the instance process activity.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessActivityID">The atul process activity ID.</param>
        /// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
        /// <param name="CreatedBy">The created by.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.InsertInstanceProcessActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        string InsertInstanceProcessActivity(string AtulInstanceProcessID, string AtulProcessActivityID, string InstanceProcessActivityCompletedBy, string CreatedBy);

        /// <summary>
        /// Sets the activity dead line.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.SetActivityDeadLine, BodyStyle = WebMessageBodyStyle.Bare)]
        string SetActivityDeadLine();

        /// <summary>
        /// Sets the activity man minutes.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.SetActivityManMinutes, BodyStyle = WebMessageBodyStyle.Bare)]
        string SetActivityManMinutes();

        /// <summary>
        /// Sets the activity prerequsite activity group.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.SetActivityPrerequsiteActivityGroup, BodyStyle = WebMessageBodyStyle.Bare)]
        string SetActivityPrerequsiteActivityGroup();

        /// <summary>
        /// Updates the instance process.
        /// </summary>
        /// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
        /// <param name="AtulProcessID">The atul process ID.</param>
        /// <param name="ModifiedBy">The modified by.</param>
        /// <param name="OwnedBy">The owned by.</param>
        /// <param name="AtulProcessStatusID">The atul process status ID.</param>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.UpdateInstanceProcess, BodyStyle = WebMessageBodyStyle.Bare)]
        string UpdateInstanceProcess(string AtulInstanceProcessID, string AtulProcessID, string ModifiedBy, string OwnedBy, string AtulProcessStatusID);

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
        [OperationContract]
        [WebGet(UriTemplate = Routing.UpdateInstanceProcessActivity, BodyStyle = WebMessageBodyStyle.Bare)]
        string UpdateInstanceProcessActivity(string AtulInstanceProcessActivityID, string AtulInstanceProcessID, string AtulProcessActivityID, string ProcessActivityCompleted, string ProcessActivityDidNotApply, string ProcessActivityDeadlineMissed, string InstanceProcessActivityCompletedBy, string ModifiedBy);

        /// <summary>
        /// Updates the running process specification.
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        [WebGet(UriTemplate = Routing.UpdateRunningProcessSpecification, BodyStyle = WebMessageBodyStyle.Bare)]
        string UpdateRunningProcessSpecification();
    }

    /// <summary>
    ///
    /// </summary>
    public static class Routing
    {
        /// <summary>
        ///
        /// </summary>
        public const string HelloWorldBool = "/HelloWorldBool";
        /// <summary>
        ///
        /// </summary>
        public const string HelloWorldString = "/HelloWorldString/{word}";
        public const string AddActivityToActivityGroup = "/AddActivityToActivityGroup/{AtulActivityGroupID}/{AtulActivityID}/{CreatedBy}";
        /// <summary>
        ///
        /// </summary>
        public const string AddProcessManager = "/AddProcessManager/{AtulRemoteSystemID}/{AtulUserTypeID}/{RemoteSystemLoginID}/{DisplayName}";
        public const string CreateActivity = "/CreateActivity/{AtulSubProcessID}/{ActivityDescription}/{ActivitySummary}/{ActivityProcedure}/{AtulActivitySortOrder}/{CreatedBy}/{OwnedBy}";
        public const string CreateActivityGroup = "/CreateActivityGroup/{AtulActivityGroupPurposeID}/{ActivityGroupDescription}/{ActivityGroupSummary}/{CreatedBy}";
        public const string CreateInstanceProcess = "/CreateInstanceProcess/{AtulProcessID}/{CreatedBy}/{OwnedBy}/{AtulProcessStatusID}";
        public const string CreateProcess = "/CreateProcess/{ProcessDescription}/{ProcessSummary}/{CreatedBy}/{OwnedBy}/{AtulProcessStatusID}/{DeadLineOffset}";
        public const string CreateSubProcess = "/CreateSubProcess/{AtulProcessID}/{AtulSubProcessID}/{ProcessSubprocessSortOrder}/{NotificationServiceProvideID}/{NotificationIdentifier}/{ResponsibilityOf}/{DeadlineOffset}/{CreatedBy}";
        public const string DeleteActivity = "/DeleteActivity/{AtulProcessID}/{ModifiedBy}";
        public const string DeleteActivityGroup = "/DeleteActivityGroup/{AtulActivityGroupID}/{ModifiedBy}";
        public const string DeleteInstanceProcess = "/DeleteInstanceProcess/{AtulInstanceProcessID}/{ModifiedBy}";
        public const string DeleteProcess = "/DeleteProcess/{AtulProcessID}/{ModifiedBy}";
        public const string DeleteSubProcess = "/DeleteSubProcess/{AtulSubProcessID}/{ModifiedBy}";
        public const string DeleteInstanceProcessActivity = "/DeleteInstanceProcessActivity/{AtulSubProcessID}/{ModifiedBy}";
        public const string DeleteProcessManager = "/DeleteProcessManager/{AtulUserID}";
        public const string EnableActivityAutomation = "/EnableActivityAutomation";
        public const string GetAllActivity = "/GetAllActivity";
        public const string GetAllInstanceProcess = "/GetAllInstanceProcess";
        public const string GetAllInstanceProcessActivity = "/GetAllInstanceProcessActivity";
        public const string GetAllProcess = "/GetAllProcess";
        public const string GetAllProcessActivityGroups = "/GetAllProcessActivityGroups";
        public const string GetAllProcessSubProcess = "/GetAllProcessSubProcess";
        public const string GetAllProcessSubProcessActivity = "/GetAllProcessSubProcessActivity";
        public const string GetInstanceProcessActivity = "/GetInstanceProcessActivity";
        public const string GetInstanceProcessByID = "/GetInstanceProcessByID/{AtulInstanceProcessID}";
        public const string InsertInstanceProcess = "/InsertInstanceProcess/{AtulProcessID}/{CreatedBy}/{OwnedBy}/{AtulProcessStatusID}";
        public const string InsertInstanceProcessActivity = "/InsertInstanceProcessActivity/{AtulInstanceProcessID}/{AtulProcessActivityID}/{InstanceProcessActivityCompletedBy}/{CreatedBy}";
        public const string SetActivityDeadLine = "/SetActivityDeadLine";
        public const string SetActivityManMinutes = "/SetActivityManMinutes";
        public const string SetActivityPrerequsiteActivityGroup = "/SetActivityPrerequsiteActivityGroup";
        public const string UpdateInstanceProcess = "/UpdateInstanceProcess/{AtulInstanceProcessID}/{AtulProcessID}/{ModifiedBy}/{OwnedBy}/{AtulProcessStatusID}";
        public const string UpdateInstanceProcessActivity = "/UpdateInstanceProcessActivity/{AtulInstanceProcessActivityID}/{AtulInstanceProcessID}/{AtulProcessActivityID}/{ProcessActivityCompleted}/{ProcessActivityDidNotApply}/{ProcessActivityDeadlineMissed}/{InstanceProcessActivityCompletedBy}/{ModifiedBy}";
        public const string UpdateRunningProcessSpecification = "/UpdateRunningProcessSpecification";
    }
}