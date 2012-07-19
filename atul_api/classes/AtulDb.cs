/*Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;

namespace ATUL_v1
{
	/// <summary>
	///
	/// </summary>
	public class Atul_v1Data : IDisposable
	{
        private SqlConnection _connection;

        public Atul_v1Data()
        {

            string user = ConfigurationManager.AppSettings.Get("DBUser");
            string pass = ConfigurationManager.AppSettings.Get("DBPass");
            string db = ConfigurationManager.AppSettings.Get("DBName");
            string server = ConfigurationManager.AppSettings.Get("DBServer");

            string connectionString = "user id="+user+";" +
                                       "password="+pass+";server="+server+";" +
                                       "Trusted_Connection=yes;" +
                                       "database="+db+"; " +
                                       "connection timeout=30";
            this._connection = new SqlConnection(connectionString);
            try
            {
                this._connection.Open();
            }
            catch (Exception e)
            {
                Trace.WriteLineIf(debug, e.Message);
                throw e;
            }
        }

        public void Dispose()
        {
            if (this._connection.State == ConnectionState.Open)
            {
                this._connection.Close();
            }
        }

		private bool debug = Convert.ToBoolean(ConfigurationManager.AppSettings["debug"]);

		/// <summary>
		/// Adds the activity to activity group.
		/// </summary>
		/// <param name="AtulActivityGroupID">The atul activity group ID.</param>
		/// <param name="AtulActivityID">The atul activity ID.</param>
		/// <param name="CreatedBy">The created by ID.</param>
		/// <returns></returns>
		public bool AddActivityToActivityGroup(int AtulActivityGroupID, int AtulActivityID, int CreatedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGroupActivityInsert_sp @AtulActivityGroupID, @AtulActivityID, @CreatedBy", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@AtulActivityGroupID", AtulActivityGroupID));            
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));            
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());			
			return success;
		}

		public Process GetProcessBySummary(string ProcessSummary)
		{
			Process p = new Process();
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessGetByProcessSummary_sp @ProcessSummary", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@ProcessSummary", ProcessSummary));        
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "process";
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            p.AtulProcessID = Convert.ToInt64(r["AtulProcessID"]);
            p.AtulProcessStatusID = (int)r["AtulProcessStatusID"];
            p.CreatedBy = Convert.ToInt64(r["CreatedBy"]);
            p.CreatedByName = r["CreatedByName"].ToString();
            p.CreatedDate = Convert.ToDateTime(r["CreatedDate"]);
            
            p.DeadLineOffset = (int)r["DeadLineOffset"];
            p.IsActive = Convert.ToBoolean(r["IsActive"]);
            p.ModifiedBy = Convert.ToInt64(r["ModifiedBy"]);
            p.ModifiedByName = r["ModifiedByName"].ToString();
            if (r["ModifiedDate"] != DBNull.Value)
            {
                p.ModifiedDate = Convert.ToDateTime(r["ModifiedDate"]);
            }
            p.OwnedBy = Convert.ToInt64(r["OwnedBy"]);
            p.OwnedByName = r["OwnedByName"].ToString();
            p.ProcessDescription = r["ProcessDescription"].ToString();
            p.ProcessStatus = r["ProcessStatus"].ToString();
            p.ProcessSummary = r["ProcessSummary"].ToString();
            long providerid;
            if (Int64.TryParse(r["SubjectServiceProviderID"].ToString(), out providerid))
            {
                p.SubjectServiceProviderID = providerid;
            }
			return p;
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_UserInsert_sp @AtulRemoteSystemID, @AtulUserTypeID, @RemoteSystemLoginID, @DisplayName", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@AtulRemoteSystemID", AtulRemoteSystemID));            
            cmd.Parameters.Add(new SqlParameter("@AtulUserTypeID", AtulUserTypeID));            
            cmd.Parameters.Add(new SqlParameter("@RemoteSystemLoginID", RemoteSystemLoginID));            
            cmd.Parameters.Add(new SqlParameter("@DisplayName", DisplayName));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public Schedule GetProcessScheduleByProcessID(long ProcessID)
		{
            Schedule s = new Schedule();
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessScheduleGetByProcessId_sp @AtulProcessID", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); //returnTable.TableName = "schedule";
            da.Fill(returnTable);
            if (returnTable.Rows.Count > 0)
            {
                DataRow r = returnTable.Rows[0];
                s.AtulProcessID = Convert.ToInt64(r["AtulProcessScheduleID"]);
                s.AtulProcessScheduleID = Convert.ToInt64(r["AtulProcessScheduleID"]);
                s.InstantiatedUserList = r["InstantiatedUserList"].ToString();
                if (r["LastInstantiated"] != DBNull.Value)
                {
                    s.LastInstantiated = Convert.ToDateTime(r["LastInstantiated"]);
                }
                s.NextScheduledDate = Convert.ToDateTime(r["NextScheduledDate"]);
                s.RepeatSchedule = r["RepeatSchedule"].ToString();
                s.ScheduleVersion = r["ScheduleVersion"].ToString();
                return s;
            }
            return null;
		}

		public Schedule GetProcessScheduleByID(long ScheduleID)
		{
            Schedule s = new Schedule();
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessScheduleGetByID_sp @AtulProcessScheduleID", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@AtulProcessScheduleID", ScheduleID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); //returnTable.TableName = "schedule";
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            s.AtulProcessID = Convert.ToInt64(r["AtulProcessScheduleID"]);
            s.AtulProcessScheduleID = Convert.ToInt64(r["AtulProcessScheduleID"]);
            s.InstantiatedUserList = r["InstantiatedUserList"].ToString();
            if (r["LastInstantiated"] != DBNull.Value)
            {
                s.LastInstantiated = Convert.ToDateTime(r["LastInstantiated"]);
            }
            s.NextScheduledDate = Convert.ToDateTime(r["NextScheduledDate"]);
            s.RepeatSchedule = r["RepeatSchedule"].ToString();
            s.ScheduleVersion = r["ScheduleVersion"].ToString();
            return s;		
		}

		public bool UpdateProcessSchedule(long scheduleProcessID, string scheduleVersion, DateTime? lastInstantiated, DateTime nextScheduled, string repeatSchedule, string instantiatedUsers)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessScheduleUpdate_sp @AtulProcessScheduleID, @ScheduleVersion, @LastInstantiated, @NextScheduledDate, @RepeatSchedule, @InstantiatedUserList", this._connection);            
            cmd.Parameters.Add(new SqlParameter("@AtulProcessScheduleID", scheduleProcessID));            
            cmd.Parameters.Add(new SqlParameter("@ScheduleVersion", scheduleVersion));            
            cmd.Parameters.Add(new SqlParameter("@LastInstantiated", lastInstantiated));            
            cmd.Parameters.Add(new SqlParameter("@NextScheduledDate", nextScheduled));            
            cmd.Parameters.Add(new SqlParameter("@RepeatSchedule", repeatSchedule));            
            cmd.Parameters.Add(new SqlParameter("@InstantiatedUserList", instantiatedUsers));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;			
		}

		public bool DeleteProcessSchedule(long ProcessScheduleID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessScheduleDelete_sp @AtulProcessScheduleID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessScheduleID", ProcessScheduleID));          
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;					
		}

		public long CreateProcessSchedule(long ProcessID, string scheduleVersion, DateTime nextScheduled, string repeatSchedule, string instantiatedUsers)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessScheduleInsert_sp @AtulProcessID, @RepeatSchedule, @NextScheduledDate, @ScheduleVersion, @InstantiatedUserList", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@RepeatSchedule", repeatSchedule));
            cmd.Parameters.Add(new SqlParameter("@NextScheduledDate", nextScheduled));
            cmd.Parameters.Add(new SqlParameter("@ScheduleVersion", scheduleVersion));
            cmd.Parameters.Add(new SqlParameter("@InstantiatedUserList", instantiatedUsers));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); 
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            long ScheduleID = Convert.ToInt64(r["AtulProcessScheduleID"]);		
			return ScheduleID;
		}

		/// <summary>
		/// Creates the activity.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <param name="AtulSubProcessID">The atul sub process ID.</param>
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
		public long CreateActivity(long AtulProcessID, long AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, bool deadlineResultsInMissed, int AtulActivitySortOrder, int CreatedBy, int OwnedBy, int deadline, int deadlineTypeID)
		{           
            long activityId = 0;
            int? blankID = null;
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityInsert_sp @AtulSubProcessID, @ActivityDescription, @ActivitySummary, @ActivityProcedure, @AtulActivitySortOrder, @CreatedBy, @OwnedBy, @AtulProcessID, @ProcessActivitySortOrder, @AutomationServiceProviderID, @AutomationTriggerActivityGroupID, @AutomationIdentifier, @AutomationExpectedDuration, @PrerequisiteActivityGroupID, @AtulDeadlineTypeID, @DeadlineActivityGroupID, @DeadlineResultsInMissed, @DeadlineOffset", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ActivityDescription", ActivityDescription));
            cmd.Parameters.Add(new SqlParameter("@ActivitySummary", ActivitySummary));
            cmd.Parameters.Add(new SqlParameter("@ActivityProcedure", ActivityProcedure));
            cmd.Parameters.Add(new SqlParameter("@AtulActivitySortOrder", AtulActivitySortOrder));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@ProcessActivitySortOrder", AtulActivitySortOrder));
            cmd.Parameters.Add(new SqlParameter("@AutomationServiceProviderID", blankID));
            cmd.Parameters.Add(new SqlParameter("@AutomationTriggerActivityGroupID", blankID));
            cmd.Parameters.Add(new SqlParameter("@AutomationIdentifier", string.Empty));
            cmd.Parameters.Add(new SqlParameter("@AutomationExpectedDuration", blankID));
            cmd.Parameters.Add(new SqlParameter("@PrerequisiteActivityGroupID", blankID));
            cmd.Parameters.Add(new SqlParameter("@AtulDeadlineTypeID", deadlineTypeID));
            cmd.Parameters.Add(new SqlParameter("@DeadlineActivityGroupID", blankID));
            cmd.Parameters.Add(new SqlParameter("@DeadlineResultsInMissed", deadlineResultsInMissed));
            cmd.Parameters.Add(new SqlParameter("@DeadlineOffset", deadline));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable();
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            activityId = Convert.ToInt64(r["AtulActivityID"]);
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGroupInsert_sp @AtulActivityGroupPurposeID, @ActivityGroupDescription, @ActivityGroupSummary, @CreatedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityGroupPurposeID", AtulActivityGroupPurposeID));
            cmd.Parameters.Add(new SqlParameter("@ActivityGroupDescription", ActivityGroupDescription));
            cmd.Parameters.Add(new SqlParameter("@ActivityGroupSummary", ActivityGroupSummary));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            SqlDataAdapter da = new SqlDataAdapter();
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessInsert_sp @AtulProcessID, @CreatedBy, @OwnedBy, @AtulProcessStatusID, @SubjectIdentifier, @SubjectSummary", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessStatusID", AtulProcessStatusID));
            cmd.Parameters.Add(new SqlParameter("@SubjectIdentifier", SubjectIdentifier));
            cmd.Parameters.Add(new SqlParameter("@SubjectSummary", SubjectSummary));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable();
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            long processInstanceId = Convert.ToInt64(r["AtulInstanceProcessID"]);
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
		public long CreateProcess(string ProcessDescription, string ProcessSummary, int CreatedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessInsert_sp @ProcessDescription, @ProcessSummary, @CreatedBy, @OwnedBy, @AtulProcessStatusID, @DeadLineOffset", this._connection);
            cmd.Parameters.Add(new SqlParameter("@ProcessDescription", ProcessDescription));
            cmd.Parameters.Add(new SqlParameter("@ProcessSummary", ProcessSummary));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessStatusID", AtulProcessStatusID));
            cmd.Parameters.Add(new SqlParameter("@DeadLineOffset", DeadLineOffset));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable();
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            long processId = Convert.ToInt64(r["AtulProcessID"]);
            return processId;	
		}

		/// <summary>
		/// Creates the sub process.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <param name="AtulSubProcessID">The atul sub process ID.</param>
		/// <param name="ProcessSubprocessSortOrder">The process subprocess sort order.</param>
		/// <param name="NotificationIdentifier">The notification identifier.</param>
		/// <param name="ResponsibilityOf">The responsibility of ID.</param>
		/// <param name="DeadlineOffset">The deadline offset.</param>
		/// <param name="CreatedBy">The created by ID.</param>
		/// <returns></returns>
		public bool AttachProcessSubProcess(Int64 AtulProcessID, Int64 AtulSubProcessID, int ProcessSubprocessSortOrder, string NotificationIdentifier, int ResponsibilityOf, int DeadlineOffset, int CreatedBy)
		{

            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessInsert_sp @AtulProcessID, @AtulSubProcessID, @ProcessSubprocessSortOrder, @NotificationIdentifier, @ResponsibilityOf, @DeadLineOffset, @CreatedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ProcessSubprocessSortOrder", ProcessSubprocessSortOrder));
            cmd.Parameters.Add(new SqlParameter("@NotificationIdentifier", NotificationIdentifier));
            cmd.Parameters.Add(new SqlParameter("@ResponsibilityOf", ResponsibilityOf));
            cmd.Parameters.Add(new SqlParameter("@DeadlineOffset", DeadlineOffset));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;			
		}

		/// <summary>
		/// Creates the sub process.
		/// </summary>
		/// <param name="SubProcessDescription">The sub process description.</param>
		/// <param name="SubProcessSummary">The sub process summary.</param>
		/// <param name="CreatedBy">The created by.</param>
		/// <param name="OwnedBy">The owned by.</param>
		/// <returns></returns>
		public long CreateSubProcess(string SubProcessDescription, string SubProcessSummary, int CreatedBy, int OwnedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessInsert_sp @SubProcessDescription, @SubProcessSummary, @CreatedBy, @OwnedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@SubProcessDescription", SubProcessDescription));
            cmd.Parameters.Add(new SqlParameter("@SubProcessSummary", SubProcessSummary));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));            
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable();
            da.Fill(returnTable);
            DataRow r = returnTable.Rows[0];
            long subProcessId = Convert.ToInt64(r["AtulSubProcessID"]);
            return subProcessId;				
		}

		/// <summary>
		/// Deletes the activity.
		/// </summary>
		/// <param name="ActivityID">The atul process ID.</param>
		/// <param name="ModifiedBy">The modified by.</param>
		/// <returns></returns>
		public bool DeleteActivity(long ActivityID, int ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityDelete_sp @AtulActivityID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", ActivityID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));         
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGroupDelete_sp @AtulActivityGroupID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityGroupID", AtulActivityGroupID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;			
		}

		/// <summary>
		/// Deletes the instance process.
		/// </summary>
		/// <returns></returns>
		public bool DeleteInstanceProcess(long AtulInstanceProcessID, long ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessDelete_sp @AtulInstanceProcessID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessDelete_sp @AtulProcessID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessDelete_sp @AtulSubProcessID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		/// <summary>
		/// Deletes the instance process activity.
		/// </summary>
		/// <returns></returns>
		public bool DeleteInstanceProcessActivity(int AtulSubProcessID, int ModifiedBy)
		{
            bool success = false;
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_UserDelete_sp @AtulUserID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulUserID", AtulUserID));            
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;			
		}

		public bool UndeleteProcess(long ProcessID, long ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessUnDelete_sp @AtulProcessID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public bool UndeleteProcessInstance(long InstanceID, long ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessUnDelete_sp @AtulInstanceProcessID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", InstanceID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public List<Process> ProcessGetDeleted(DateTime startDate)
		{
			List<Process> ProcessList = new List<Process>();

            Process p = new Process();
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessGetDeleted_sp @startdate", this._connection);
            cmd.Parameters.Add(new SqlParameter("@startdate", startDate));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "process";
            da.Fill(returnTable);
            foreach (DataRow r in returnTable.Rows)
            {
                if (r != null)
                {
                    p.AtulProcessID = Convert.ToInt64(r["AtulProcessID"]);
                    p.AtulProcessStatusID = (int)r["AtulProcessStatusID"];
                    p.CreatedBy = Convert.ToInt64(r["CreatedBy"]);
                    p.CreatedByName = r["CreatedByName"].ToString();
                    p.CreatedDate = Convert.ToDateTime(r["CreatedDate"]);

                    p.DeadLineOffset = (int)r["DeadLineOffset"];
                    p.IsActive = Convert.ToBoolean(r["IsActive"]);
                    p.ModifiedBy = Convert.ToInt64(r["ModifiedBy"]);
                    p.ModifiedByName = r["ModifiedByName"].ToString();
                    if (r["ModifiedDate"] != DBNull.Value)
                    {
                        p.ModifiedDate = Convert.ToDateTime(r["ModifiedDate"]);
                    }
                    p.OwnedBy = Convert.ToInt64(r["OwnedBy"]);
                    p.OwnedByName = r["OwnedByName"].ToString();
                    p.ProcessDescription = r["ProcessDescription"].ToString();
                    p.ProcessStatus = r["ProcessStatus"].ToString();
                    p.ProcessSummary = r["ProcessSummary"].ToString();
                    long providerid;
                    if (Int64.TryParse(r["SubjectServiceProviderID"].ToString(), out providerid))
                    {
                        p.SubjectServiceProviderID = providerid;
                    }
                    ProcessList.Add(p);
                }
            }
            return ProcessList;
		}

		public List<ProcessInstance> ProcessInstanceGetDeleted(DateTime startDate)
		{

            List<ProcessInstance> InstanceList = new List<ProcessInstance>();

            ProcessInstance p = new ProcessInstance();
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessGetDeleted_sp @startdate", this._connection);
            cmd.Parameters.Add(new SqlParameter("@startdate", startDate));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "processinstance";
            da.Fill(returnTable);
            foreach (DataRow r in returnTable.Rows)
            {
                if (r != null)
                {                  
                    p.AtulInstanceProcessID = Convert.ToInt64(r["AtulInstanceProcessID"]);
                    p.AtulProcessID = Convert.ToInt64(r["AtulProcessID"]);
                    p.AtulProcessStatusID = (int)r["AtulProcessStatusID"];
                    p.CreatedBy = Convert.ToInt64(r["CreatedBy"]);
                    p.CreatedByName = r["CreatedByName"].ToString();
                    p.CreatedDate = Convert.ToDateTime(r["CreatedDate"]);
                    p.IsActive = Convert.ToBoolean(r["IsActive"]);
                    p.ModifiedBy = Convert.ToInt64(r["ModifiedBy"]);
                    p.ModifiedByName = r["ModifiedByName"].ToString();
                    if (r["ModifiedDate"] != DBNull.Value)
                    {
                        p.ModifiedDate = Convert.ToDateTime(r["ModifiedDate"]);
                    }
                    p.OwnedBy = Convert.ToInt64(r["OwnedBy"]);
                    p.OwnedByName = r["OwnedByName"].ToString();
                    p.ProcessStatus = r["ProcessStatus"].ToString();
                    p.ProcessStatus = r["ProcessStatus"].ToString();
                    p.ProcessSummary = r["ProcessSummary"].ToString();
                    long providerid;
                    if (Int64.TryParse(r["SubjectServiceProviderID"].ToString(), out providerid))
                    {
                        p.SubjectServiceProviderID = providerid;
                    }
                    p.SubjectSummary = r["SubjectSummary"].ToString();
                    InstanceList.Add(p);
                }
            }
            return InstanceList;
		}

		/// <summary>
		/// Enables the activity automation.
		/// TODO: Find/Define appliciable attribute
		/// </summary>
		/// <returns></returns>
		public DataTable EnableActivityAutomation()
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultblautomation";
			return returnTable;
		}

		public DataTable GetAllProcessStatus()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessStatusGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "statusList";
            da.Fill(returnTable);
            return returnTable;
		}

		public DataTable GetAllDeadlineType()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_DeadlineTypeGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "deadlineTypeList";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all activity.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllActivity()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblactivity";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all instance process.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllInstanceProcess()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblinstance";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all instance process activity.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllInstanceProcessActivity()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessActivityGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceProcessActivity";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all process.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllProcess()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;            
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultblprocess";
            da.Fill(returnTable);
			return returnTable;
		}

		/// <summary>
		/// Gets all process activity groups.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllProcessActivityGroups()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGroupGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblProcessActivityGroups";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all process sub process.
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllProcessSubProcess()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblProcessSubProcess";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all process sub process activity.
		/// TODO: New proc needed to get a subprocess's activities
		/// </summary>
		/// <returns></returns>
		public DataTable GetAllProcessSubProcessActivity()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblProcessSubProcessActivity";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all process sub process by process ID.
		/// We use this proc to get the subprocesses of a process. You still need to call
		/// GetProcessSubProcessDetailsBySubProcessID on each subprocess to get the details
		/// </summary>
		/// <param name="AtulProcessSubprocessID">The atul process subprocess ID.</param>
		/// <returns></returns>
		public DataTable GetAllProcessSubProcessByProcessID(Int64 AtulProcessSubprocessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessGetByID_sp @AtulProcessSubprocessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessSubprocessID", AtulProcessSubprocessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblProcessSubProcess";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets the current instance's sub process.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <returns></returns>
		public DataTable GetCurrentInstanceSubProcess(Int64 AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_GetCurrentInstanceSubProcess_sp @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atulinstanceSubProcess";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets the provider info by instance sub process ID.
		/// </summary>
		/// <param name="AtulInstanceProcessSubProcessID">The atul instance process sub process ID.</param>
		/// <returns></returns>
		public DataTable GetProviderInfoBySubProcessID(Int64 AtulInstanceProcessSubProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_GetProviderInfoBySubProcessID_sp @AtulInstanceProcessSubProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessSubProcessID", AtulInstanceProcessSubProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atulinstanceSubProcessProviderInfo";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// Gets all sub process by process ID.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <returns></returns>
		public DataTable GetAllSubProcessByProcessID(Int64 AtulProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessGetByProcessID_sp @AtulProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "SubProcesses";
            da.Fill(returnTable);
            return returnTable;
		}

		public DataTable GetAllActivityBySubProcessID(long SubProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivitiesGetBySubProcessID_sp @AtulSubProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", SubProcessID));

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "Activites";
            da.Fill(returnTable);
            return returnTable;			
		}

		public DataTable GetActivityByID(long ActivityID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityGetByActivityID_sp @AtulActivityID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", ActivityID));

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "Activity";
            da.Fill(returnTable);
            return returnTable;	
		}

		public DataTable GetSubProcessByID(long SubProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessGetByID_sp @AtulSubProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", SubProcessID));

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "SubProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		public DataTable GetProcessActivityByProcessIDActivityID(long ProcessID, long ActivityID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessActivityGetByProcessIDActivityID_sp @AtulActivityID, @AtulProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", ActivityID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "ProcessActivity";
            da.Fill(returnTable);
            return returnTable;	
		}

		public DataTable GetProcessSubProcessByProcessIDSubProcessID(long ProcessID, long SubProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessGetByProcessIDSubProcessID_sp @AtulProcessID, @AtulSubProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", SubProcessID));

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "ProcessSubProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		public bool UpdateActivity(long AtulActivityID, long AtulSubProcessID, string ActivityDescription, string ActivitySummary, string ActivityProcedure, int AtulActivitySortOrder, int ModifiedBy, int OwnedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivityUpdate_sp @AtulActivityID, @AtulSubProcessID, @ActivityDescription, @ActivitySummary, @ActivityProcedure, @AtulActivitySortOrder, @ModifiedBy, @OwnedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ActivityDescription", ActivityDescription));
            cmd.Parameters.Add(new SqlParameter("@ActivitySummary", ActivitySummary));
            cmd.Parameters.Add(new SqlParameter("@ActivityProcedure", ActivityProcedure));
            cmd.Parameters.Add(new SqlParameter("@AtulActivitySortOrder", AtulActivitySortOrder));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));

            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public bool UpdateProcessActivity(long ProcessActivityID, long ProcessID, long ActivityID, int sort, bool deadlineResultsInMissed, int deadlineType, int deadline, int ModifiedBy, long? AutomationServiceProviderID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessActivityUpdate_sp @AtulProcessActivityID, @AtulProcessID, @AtulActivityID, @ProcessActivitySortOrder, @AtulDeadlineTypeID, @DeadlineResultsInMissed, @DeadlineOffset, @ModifiedBy, @AutomationServiceProviderID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessActivityID", ProcessActivityID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", ActivityID));
            cmd.Parameters.Add(new SqlParameter("@ProcessActivitySortOrder", sort));
            cmd.Parameters.Add(new SqlParameter("@AtulDeadlineTypeID", deadlineType));
            cmd.Parameters.Add(new SqlParameter("@DeadlineResultsInMissed", deadlineResultsInMissed));
            cmd.Parameters.Add(new SqlParameter("@DeadlineOffset", deadline));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@AutomationServiceProviderID", AutomationServiceProviderID));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public bool UpdateSubProcess(long SubProcessID, string SubProcessDescription, string SubProcessSummary, int ModifiedBy, int OwnedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessUpdate_sp @AtulSubProcessID, @SubProcessDescription, @SubProcessSummary, @ModifiedBy, @OwnedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", SubProcessID));
            cmd.Parameters.Add(new SqlParameter("@SubProcessDescription", SubProcessDescription));
            cmd.Parameters.Add(new SqlParameter("@SubProcessSummary", SubProcessSummary));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));      
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public bool UpdateProcess(long ProcessID, string ProcessDescription, string ProcessSummary, int ModifiedBy, int OwnedBy, int AtulProcessStatusID, int DeadLineOffset, long? SubjectServiceProviderID, string ScopeID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessUpdate_sp @AtulProcessID, @ProcessDescription, @ProcessSummary, @ModifiedBy, @OwnedBy, @AtulProcessStatusID, @DeadLineOffset, @SubjectServiceProviderID, @SubjectScopeIdentifier", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@ProcessDescription", ProcessDescription));
            cmd.Parameters.Add(new SqlParameter("@ProcessSummary", ProcessSummary));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessStatusID", AtulProcessStatusID));
            cmd.Parameters.Add(new SqlParameter("@DeadLineOffset", DeadLineOffset));
            cmd.Parameters.Add(new SqlParameter("@SubjectServiceProviderID", SubjectServiceProviderID));
            cmd.Parameters.Add(new SqlParameter("@SubjectScopeIdentifier", ScopeID));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		public bool UpdateActivitySort(long ActivityID, int Sort, int ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ActivitySortOrderUpdate_sp @AtulActivityID, @AtulActivitySortOrder, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", ActivityID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivitySortOrder", Sort));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));          
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;
		}

		/// <summary>
		/// Updates the process sub process sort.
		/// </summary>
		/// <param name="ProcessSubProcessID">The process sub process ID.</param>
		/// <param name="Sort">The sort.</param>
		/// <param name="ModifiedBy">The modified by.</param>
		/// <returns></returns>
		public bool UpdateProcessSubProcessSort(long ProcessSubProcessID, int Sort, int ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessSortOrderUpdate_sp @AtulProcessSubprocessID, @ProcessSubprocessSortOrder, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessSubprocessID", ProcessSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ProcessSubprocessSortOrder", Sort));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
		public bool UpdateProcessSubProcess(long ProcessSubProcessID, long ProcessID, long SubProcessID, int sort, int responsibilityOf, int DeadlineOffset, int ModifiedBy, long? NotificationServiceProviderID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessSubprocessUpdate_sp @AtulProcessSubprocessID, @AtulProcessID, @AtulSubProcessID, @ProcessSubprocessSortOrder, @ResponsibilityOf, @DeadlineOffset, @ModifiedBy, @NotificationServiceProviderID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessSubprocessID", ProcessSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", ProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", SubProcessID));
            cmd.Parameters.Add(new SqlParameter("@ProcessSubprocessSortOrder", sort));
            cmd.Parameters.Add(new SqlParameter("@ResponsibilityOf", responsibilityOf));
            cmd.Parameters.Add(new SqlParameter("@DeadlineOffset", DeadlineOffset));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@NotificationServiceProviderID", NotificationServiceProviderID));      
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;			
		}

		/// <summary>
		/// Gets all process sub process by process ID.
		/// </summary>
		/// <param name="AtulSubProcessID">The atul sub process ID.</param>
		/// <returns></returns>
		public DataTable GetProcessSubProcessDetailsBySubProcessID(Int64 AtulSubProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_SubProcessGetByID_sp @AtulSubProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));        
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblSubProcessDetails";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Gets the instance process activity.
		/// </summary>
		/// <returns></returns>
		public DataTable GetInstanceProcessActivity(Int64 AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessActivityGetBy_sp @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblProcessActivity";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Gets the instance process by ID.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <returns></returns>
		public DataTable GetInstanceProcessByID(Int64 AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessGetByID_sp @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Gets instance processes by process ID.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <returns></returns>
		public DataTable GetInstanceProcessByProcessID(Int64 AtulProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessGetByProcessID_sp @AtulProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Gets the instance sub process by ID.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <returns></returns>
		public DataTable GetInstanceSubProcessByID(Int64 AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessSubProcess_GetByID @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceSubProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Gets the process by ID.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <returns></returns>
		public DataTable GetProcessByID(Int64 AtulProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ProcessGetByProcessID_sp @AtulProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "Process";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Inserts the instance process.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <param name="CreatedBy">The created by.</param>
		/// <param name="OwnedBy">The owned by.</param>
		/// <param name="AtulProcessStatusID">The atul process status ID.</param>
		/// <returns></returns>
		public DataTable InsertInstanceProcess(int AtulProcessID, int CreatedBy, int OwnedBy, int AtulProcessStatusID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessInsert_sp @AtulProcessID, @CreatedBy, @OwnedBy, @AtulProcessStatusID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessStatusID", AtulProcessStatusID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceProcess";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Inserts the instance process activity.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <param name="AtulProcessActivityID">The atul process activity ID.</param>
		/// <param name="InstanceProcessActivityCompletedBy">The instance process activity completed by.</param>
		/// <param name="CreatedBy">The created by.</param>
		/// <returns></returns>
		public DataTable InsertInstanceProcessActivity(int AtulInstanceProcessID, int AtulProcessActivityID, int InstanceProcessActivityCompletedBy, int CreatedBy)
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultblInstanceProcessActivity";
			return returnTable;
		}

		/// <summary>
		/// Sets the activity dead line.
		/// </summary>
		/// <returns></returns>
		public DataTable SetActivityDeadLine()
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultbl";
			return returnTable;
		}

		/// <summary>
		/// Sets the activity man minutes.
		/// TODO: Add man minute column, update proc(s)
		/// </summary>
		/// <returns></returns>
		public DataTable SetActivityManMinutes()
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultbl";
			return returnTable;
		}

		/// <summary>
		/// Sets the activity prerequsite activity group.
		/// TODO: Request proc to set prereq group Params: ActivityID, GroupID
		/// </summary>
		/// <returns></returns>
		public DataTable SetActivityPrerequsiteActivityGroup()
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultbl";
			return returnTable;
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessUpdate_sp @AtulInstanceProcessID, @AtulProcessID, @ModifiedBy, @OwnedBy, @AtulProcessStatusID, @SubjectIdentifier, @SubjectSummary, @SubjectServiceProviderID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@OwnedBy", OwnedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessStatusID", AtulProcessStatusID));
            cmd.Parameters.Add(new SqlParameter("@SubjectIdentifier", SubjectIdentifier));
            cmd.Parameters.Add(new SqlParameter("@SubjectSummary", SubjectSummary));
            cmd.Parameters.Add(new SqlParameter("@SubjectServiceProviderID", SubjectServiceProviderID));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
		/// <param name="AtulServiceProviderID">The atul service provider ID.</param>
		/// <returns></returns>
		public DataTable UpdateInstanceProcessActivity(int AtulInstanceProcessActivityID, int AtulInstanceProcessID, int AtulProcessActivityID, int ProcessActivityCompleted, int ProcessActivityDidNotApply, int ProcessActivityDeadlineMissed, int InstanceProcessActivityCompletedBy, int ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessActivityUpdate_sp @AtulInstanceProcessActivityID, @AtulInstanceProcessID, @AtulProcessActivityID, @ProcessActivityCompleted, @ProcessActivityDidNotApply, @ProcessActivityDeadlineMissed, @InstanceProcessActivityCompletedBy, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessActivityID", AtulInstanceProcessActivityID));
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessActivityID", AtulProcessActivityID));
            cmd.Parameters.Add(new SqlParameter("@ProcessActivityCompleted", ProcessActivityCompleted));
            cmd.Parameters.Add(new SqlParameter("@ProcessActivityDidNotApply", ProcessActivityDidNotApply));
            cmd.Parameters.Add(new SqlParameter("@ProcessActivityDeadlineMissed", ProcessActivityDeadlineMissed));
            cmd.Parameters.Add(new SqlParameter("@InstanceProcessActivityCompletedBy", InstanceProcessActivityCompletedBy));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atultbl";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Get The config variables get by scriptname.
		/// </summary>
		/// <param name="ScriptName">Name of the script.</param>
		/// <returns></returns>
		public DataTable ConfigVariablesGetByScriptName(string ScriptName)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ConfigVariablesGetByScriptName_sp @ScriptName", this._connection);
            cmd.Parameters.Add(new SqlParameter("@ScriptName", ScriptName));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "atulConfigVars";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Updates the running process specification.
		/// TODO: MAtch to docs, discuss with Cory
		/// </summary>
		/// <returns></returns>
		public DataTable UpdateRunningProcessSpecification()
		{
			DataTable returnTable = new DataTable(); returnTable.TableName = "atultbl";
			return returnTable;
		}

		public bool InstanceProcessActivityComplete(Int64 AtulInstanceProcessActivityID, int statusBit, Int64 ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessActivityCompleteUpdate_sp @AtulInstanceProcessActivityID, @statusBit, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessActivityID", AtulInstanceProcessActivityID));
            cmd.Parameters.Add(new SqlParameter("@statusBit", statusBit));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));   
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}

		/// <summary>
		/// Gets the providers.
		/// </summary>
		/// <returns></returns>
		public DataTable GetProviders()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderGet_sp", this._connection);
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "providers";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// Inserts the provider.
		/// </summary>
		/// <param name="ServiceProviderName">Name of the service provider.</param>
		/// <param name="ServiceProviderDescription">The service provider description.</param>
		/// <param name="AtulServiceProviderClassID">The atul service provider class ID.</param>
		/// <param name="queue">The queue.</param>
		/// <param name="CreatedBy">The created by id.</param>
		/// <param name="verb">The verb.</param>
		/// <param name="ServiceProviderXML">The service provider XML.</param>
		/// <returns></returns>
		public bool InsertProvider(string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int CreatedBy, string ServiceProviderXML)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderInsert_sp @ServiceProviderName, @ServiceProviderDescription, @AtulServiceProviderClassID, @CreatedBy, @ServiceProviderXML, @ESBQueue", this._connection);
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderName", ServiceProviderName.Trim()));
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderDescription", ServiceProviderDescription.Trim()));
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderClassID", AtulServiceProviderClassID));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderXML",ServiceProviderXML.Trim()));
            cmd.Parameters.Add(new SqlParameter("@ESBQueue", queue));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}

		/// <summary>
		/// Updates the provider.
		/// </summary>
		/// <param name="AtulServiceProviderID">The atul service provider ID.</param>
		/// <param name="ServiceProviderName">Name of the service provider.</param>
		/// <param name="ServiceProviderDescription">The service provider description.</param>
		/// <param name="AtulServiceProviderClassID">The atul service provider class ID.</param>
		/// <param name="queue">The queue.</param>
		/// <param name="verb">The verb.</param>
		/// <param name="ModifiedBy">The modified by.</param>
		/// <param name="ServiceProviderXML">The service provider XML.</param>
		/// <returns></returns>
		public bool UpdateProvider(long AtulServiceProviderID, string ServiceProviderName, string ServiceProviderDescription, int AtulServiceProviderClassID, string queue, int ModifiedBy, string ServiceProviderXML)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderUpdate_sp @ServiceProviderName, @ServiceProviderDescription, @AtulServiceProviderClassID, @CreatedBy, @ServiceProviderXML, @ESBQueue", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderID", AtulServiceProviderID));
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderName", ServiceProviderName.Trim()));
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderDescription", ServiceProviderDescription.Trim()));
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderClassID", AtulServiceProviderClassID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderXML",ServiceProviderXML.Trim()));
            cmd.Parameters.Add(new SqlParameter("@ESBQueue", queue));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}

        public DataRow GetProviderBySearch(string name, int classID, string queue)
        {
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderGetBySearch_sp @ServiceProviderName, @AtulServiceProviderClassID, @ESBQueue", this._connection);
            cmd.Parameters.Add(new SqlParameter("@ServiceProviderName", name));
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderClassID", classID));
            cmd.Parameters.Add(new SqlParameter("@ESBQueue", queue));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "providers";
            da.Fill(returnTable);
            if (returnTable.Rows.Count > 0)
            {
                return returnTable.Rows[0];
            }
            return null;
        }

        public DataTable GetProviderByID(long providerID)
        {
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderGetByID_sp @AtulServiceProviderID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderID", providerID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "providers";
            da.Fill(returnTable);
            return returnTable;	
        }

		/*
		 *Atul_FlexFieldDelete_sp
		 *Atul_FlexFieldGet_sp
		 *Atul_FlexFieldGetByID_sp
		 *Atul_FlexFieldGetBySearch_sp
		 *Atul_FlexFieldInsert_sp
		 *Atul_FlexFieldStorageDelete_sp
		 *Atul_FlexFieldStorageGet_sp
		 *Atul_FlexFieldStorageGetByID_sp
		 *Atul_FlexFieldStorageGetByProcessID_sp
		 *Atul_FlexFieldStorageInsert_sp
		 *Atul_FlexFieldStorageUpdate_sp
		 *Atul_FlexFieldUpdate_sp
		 */

		/// <summary>
		/// delete the Flexfield
		/// </summary>
		/// <param name="AtulFlexFieldID">The atul flexfield ID.</param>
		/// <param name="ModifiedBy">The modifiedby ID.</param>
		/// <returns></returns>
		public bool FlexFieldDelete(long AtulFlexFieldID, long ModifiedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldDelete_sp @AtulFlexFieldID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldID", AtulFlexFieldID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));          
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}

		/// <summary>
		/// get the Flexfield.
		/// </summary>
		/// <returns></returns>
		public DataTable FlexFieldGet()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldGet_sp", this._connection);           
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexField";
            da.Fill(returnTable);
            return returnTable;	
		}

		/// <summary>
		/// get the Flexfield by ID.
		/// </summary>
		/// <param name="AtulFlexFieldID">The atul flex field ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldGetByID(long AtulFlexFieldID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldGetByID_sp @AtulFlexFieldID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldID", AtulFlexFieldID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexField";
            da.Fill(returnTable);
            return returnTable;	
		}

		//needs nullable
		/// <summary>
		/// get the Flexfield by search.
		/// </summary>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <param name="AtulSubProcessID">The atul sub process ID.</param>
		/// <param name="AtulActivityID">The atul activity ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldGetBySearch(long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID)
		{
			if (AtulProcessID == 0)
			{
				AtulProcessID = null;
			}
			if (AtulSubProcessID == 0)
			{
				AtulSubProcessID = null;
			}
			if (AtulActivityID == 0)
			{
				AtulActivityID = null;
			}

            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldGetBySearch_sp @AtulProcessID, @AtulSubProcessID, @AtulActivityID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFields";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// insert the flexfield.
		/// </summary>
		/// <param name="TokenName">Name of the token.</param>
		/// <param name="IsRequired">The is required.</param>
		/// <param name="CreatedBy">The created by.</param>
		/// <param name="AtulProcessID">The atul process ID.</param>
		/// <param name="AtulSubProcessID">The atul sub process ID.</param>
		/// <param name="AtulActivityID">The atul activity ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldInsert(string TokenName, int IsRequired, long CreatedBy, long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID)
		{
			if (AtulProcessID == 0)
			{
				AtulProcessID = null;
			}
			if (AtulSubProcessID == 0)
			{
				AtulSubProcessID = null;
			}
			if (AtulActivityID == 0)
			{
				AtulActivityID = null;
			}

            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldInsert_sp @TokenName, @IsRequired, @CreatedBy, @AtulProcessID, @AtulSubProcessID, @AtulActivityID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@TokenName", TokenName));
            cmd.Parameters.Add(new SqlParameter("@IsRequired", IsRequired));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFieldUpsert";
            da.Fill(returnTable);
            return returnTable;
		}
		public bool FlexFieldUpsert(string TokenName, int IsRequired, long CreatedBy, long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID, string DefaultTokenValue, string FriendlyName, string ToolTip, int IsParameter)
		{
			if (AtulProcessID == 0)
			{
				AtulProcessID = null;
			}
			if (AtulSubProcessID == 0)
			{
				AtulSubProcessID = null;
			}
			if (AtulActivityID == 0)
			{
				AtulActivityID = null;
			}

            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldUpsert_sp @TokenName, @IsRequired, @CreatedBy, @AtulProcessID, @AtulSubProcessID, @AtulActivityID, @DefaultTokenValue, @FriendlyName, @ToolTip, @IsParameter", this._connection);
            cmd.Parameters.Add(new SqlParameter("@TokenName", TokenName));
            cmd.Parameters.Add(new SqlParameter("@IsRequired", IsRequired));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));
            cmd.Parameters.Add(new SqlParameter("@DefaultTokenValue", DefaultTokenValue));
            cmd.Parameters.Add(new SqlParameter("@FriendlyName", FriendlyName));
            cmd.Parameters.Add(new SqlParameter("@ToolTip", ToolTip));
            cmd.Parameters.Add(new SqlParameter("@IsParameter", IsParameter));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageDelete_sp @AtulFlexFieldStorageID, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldStorageID", AtulFlexFieldStorageID));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}

		/// <summary>
		/// Get the flexfield storage.
		/// </summary>
		/// <returns></returns>
		public DataTable FlexFieldStorageGet()
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageGet_sp", this._connection);        
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFieldStorage";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// get the flexfield by ID.
		/// </summary>
		/// <param name="AtulFlexFieldStorageID">The atul flex field storage ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldStorageGetByID(long AtulFlexFieldStorageID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageGetByID_sp @AtulFlexFieldStorageID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldStorageID", AtulFlexFieldStorageID));         
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFieldStorage";
            da.Fill(returnTable);
            return returnTable;
		}

		/// <summary>
		/// get the flexfield by process ID.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldStorageGetByProcessID(long AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageGetByProcessID_sp @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFieldStorage";
            da.Fill(returnTable);
            return returnTable;
		}
		/// <summary>
		/// Flexes the field get by process ID.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <returns></returns>
		public DataTable FlexFieldGetByInstanceProcessID(long AtulInstanceProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldGetByInstanceProcessID_sp @AtulInstanceProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexField";
            da.Fill(returnTable);
            return returnTable;
		}
        public DataTable FlexFieldsGetByProcessID(long AtulProcessID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldGetByProcessID_sp @AtulProcessID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexField";
            da.Fill(returnTable);
            return returnTable;
		}
		/// <summary>
		/// insert the flexfield.
		/// </summary>
		/// <param name="AtulInstanceProcessID">The atul instance process ID.</param>
		/// <param name="tokenValue">The token value.</param>
		/// <param name="CreatedBy">The created by.</param>
		/// <returns></returns>
		public DataTable FlexFieldStorageInsert(long AtulInstanceProcessID, long AtulFlexFieldID, string tokenValue, long CreatedBy)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageInsert_sp @AtulInstanceProcessID, @AtulFlexFieldID, @tokenValue, @CreatedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldID", AtulFlexFieldID));
            cmd.Parameters.Add(new SqlParameter("@tokenValue", tokenValue));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "FlexFieldStorageInsert";
            da.Fill(returnTable);
            return returnTable;
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
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldStorageUpdate_sp @AtulFlexFieldStorageID, @AtulInstanceProcessID, @TokenValue, @ModifiedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldStorageID", AtulFlexFieldStorageID));
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@TokenValue", TokenValue));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
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
		public bool FlexFieldUpdate(long AtulFlexFieldID, string TokenName, int IsRequired, long ModifiedBy, long? AtulProcessID, long? AtulSubProcessID, long? AtulActivityID)
		{			
			if (AtulProcessID == 0)
			{
				AtulProcessID = null;
			}
			if (AtulSubProcessID == 0)
			{
				AtulSubProcessID = null;
			}
			if (AtulActivityID == 0)
			{
				AtulActivityID = null;
			}

            SqlCommand cmd = new SqlCommand("exec dbo.Atul_FlexFieldUpdate_sp @AtulFlexFieldID, @TokenName, @IsRequired, @ModifiedBy, @AtulProcessID, @AtulSubProcessID, @AtulActivityID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulFlexFieldID", AtulFlexFieldID));
            cmd.Parameters.Add(new SqlParameter("@TokenName", TokenName));
            cmd.Parameters.Add(new SqlParameter("@IsRequired", IsRequired));
            cmd.Parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessID", AtulProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulSubProcessID", AtulSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulActivityID", AtulActivityID));
            bool success = Convert.ToBoolean(cmd.ExecuteNonQuery());
            return success;	
		}
		public DataTable ServiceProviderGetByID(long AtulServiceProviderID)
		{
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_ServiceProviderGetByID_sp @AtulServiceProviderID", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderID", AtulServiceProviderID));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "AtulServiceProvider";
            da.Fill(returnTable);
            return returnTable;
		}
        public DataTable InsertInstanceProcessSubProcessInteraction(long AtulInstanceProcessID, long AtulProcessSubProcessID, long AtulServiceProviderID, string ActivityInteractionLabel, string ActivityInteractionIdentifer, string ActivityInteractionURL,  long CreatedBy)
        {
            SqlCommand cmd = new SqlCommand("exec dbo.Atul_InstanceProcessSubProcessInteractionInsert_sp @AtulInstanceProcessID, @AtulProcessSubProcessID, @AtulServiceProviderID, @ActivityInteractionLabel, @ActivityInteractionIdentifer, @ActivityInteractionURL, @CreatedBy", this._connection);
            cmd.Parameters.Add(new SqlParameter("@AtulInstanceProcessID", AtulInstanceProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulProcessSubProcessID", AtulProcessSubProcessID));
            cmd.Parameters.Add(new SqlParameter("@AtulServiceProviderID", AtulServiceProviderID));
            cmd.Parameters.Add(new SqlParameter("@ActivityInteractionLabel", ActivityInteractionLabel));
            cmd.Parameters.Add(new SqlParameter("@ActivityInteractionIdentifer", ActivityInteractionIdentifer));
            cmd.Parameters.Add(new SqlParameter("@ActivityInteractionURL", ActivityInteractionURL));
            cmd.Parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            DataTable returnTable = new DataTable(); returnTable.TableName = "InstanceProcessSubProcessInteraction";
            da.Fill(returnTable);
            return returnTable;        
        }

		
	}
}