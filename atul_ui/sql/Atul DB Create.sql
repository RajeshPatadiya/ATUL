create table dbo.AtulActivity(
  AtulActivityID bigint   not null identity constraint PK_AtulActivity primary key,
  AtulSubProcessID bigint   not null,
  ActivityDescription nvarchar(256) not null,
  ActivitySummary nvarchar(50) not null,
  ActivityProcedure nvarchar(max) not null,
  AtulActivitySortOrder int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulActivityGroup(
  AtulActivityGroupID bigint   not null identity constraint PK_AtulActvityGroup primary key,
  AtulActivityGroupPurposeID bigint   not null,
  ActivityGroupDescription nvarchar(256) not null,
  ActivityGroupSummary nvarchar(50) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulActivityGroupActivity(
  AtulActivityGroupActivityID bigint   not null identity constraint PK_AtulActivityGroupActivity primary key,
  AtulActivityGroupID bigint   not null,
  AtulActivityID bigint   not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulActivityGroupActivity add
  constraint FK_AtulActivityGroupActivity_AtulActivityGroup foreign key(AtulActivityGroupID) references dbo.AtulActivityGroup(AtulActivityGroupID),
  constraint FK_AtulActivityGroupActivity_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID);
go

create table dbo.AtulActivityGroupPurpose(
  AtulActivityGroupPurposeID bigint   not null identity constraint PK_AtulActivityGroupPurpose primary key,
  ActivityGroupPurposeName nvarchar(50) not null,
  ActivityGroupPurposeDescription nvarchar(max) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulConfigVariables(
  AtulConfigVariablesID int      not null identity constraint PK_AtulConfigVariables primary key,
  ConfigVariableName nvarchar(200) not null,
  ConfigVariableValue nvarchar(max) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  ScriptName nvarchar(100)
);
go

create unique index UX_AtulConfigVariables_1 on dbo.AtulConfigVariables(ConfigVariableName);
go

create table dbo.AtulDeadlineType(
  AtulDeadlineTypeID bigint   not null identity constraint PK_AtulDeadlineType primary key,
  DeadlineName nvarchar(150) not null,
  DeadlineDescription nvarchar(256) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulFlexField(
  AtulFlexFieldID bigint   not null identity constraint PK_AtulFlexField primary key,
  TokenName nvarchar(200) not null,
  IsRequired bit      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  AtulProcessID bigint,
  AtulSubProcessID bigint,
  AtulActivityID bigint,
  DefaultTokenValue nvarchar(max),
  FriendlyName nvarchar(100),
  ToolTip  nvarchar(max),
  IsParameter bit
);
go

alter table dbo.AtulFlexField add
  constraint FK_AtulFlexField_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID);
go

create table dbo.AtulFlexFieldStorage(
  AtulFlexFieldStorageID bigint   not null identity constraint PK_AtulFlexFieldStorage primary key,
  AtulInstanceProcessID bigint   not null,
  AtulFlexFieldID bigint   not null,
  TokenValue nvarchar(max) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulInstanceProcess(
  AtulInstanceProcessID bigint   not null identity constraint PK_AtulInstanceProcess primary key,
  AtulProcessID bigint   not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  OwnedBy  bigint   not null,
  AtulProcessStatusID int      not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  SubjectIdentifier nvarchar(50),
  SubjectSummary nvarchar(255),
  InstanceProcessProcessCompleted bit      not null default ((0)),
  InstanceProcessProcessDeadlineMissed bit      not null default ((0)),
  InstanceProcessProcessCompletedBy bigint,
  SubjectServiceProviderID bigint
);
go

create table dbo.AtulInstanceProcessActivity(
  AtulInstanceProcessActivityID bigint   not null identity constraint PK_AtulInstanceProcessActivity primary key,
  AtulInstanceProcessID bigint   not null,
  AtulProcessActivityID bigint   not null,
  InstanceProcessActivityDeadline datetime,
  InstanceProcessActivityCompleted bit      not null,
  InstanceProcessActivityDidNotApply bit      not null,
  InstanceProcessActivityDeadlineMissed bit      not null,
  InstanceProcessActivityCompletedBy bigint,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  AtulServiceProviderID bigint
);
go

alter table dbo.AtulInstanceProcessActivity add
  constraint FK_AtulInstanceProcessActivity_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table dbo.AtulInstanceProcessActivityInteraction(
  AtulInstanceProcessActivityInteractionID bigint   not null identity constraint PK_AtulInstanceProcessActivityInteraction primary key,
  AtulInstanceProcessID bigint   not null,
  AtulActivityID bigint   not null,
  AtulServiceProviderID bigint   not null,
  ActivityInteractionLabel nvarchar(150) not null,
  ActivityInteractionIdentifer nvarchar(150) not null,
  ActivityInteractionURL nvarchar(150) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulInstanceProcessActivityInteraction add
  constraint FK_AtulInstanceProcessActivityInteraction_AtulProcessActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulInstanceProcessActivityInteraction_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table dbo.AtulInstanceProcessSubProcess(
  AtulInstanceProcessSubProcessID bigint   not null identity constraint PK_AtulInstanceProcessSubProcess primary key,
  AtulInstanceProcessID bigint   not null,
  AtulProcessSubprocessID bigint   not null,
  InstanceProcessSubProcessCompleted bit      not null,
  InstanceProcessSubProcessDidNotApply bit      not null,
  InstanceProcessSubProcessDeadlineMissed bit      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  InstanceProcessSubProcessCompletedBy bigint,
  InstanceProcessSubProcessDeadline datetime
);
go

alter table dbo.AtulInstanceProcessSubProcess add
  constraint FK_AtulInstanceProcessSubProcess_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table dbo.AtulInstanceProcessSubProcessInteraction(
  AtulInstanceProcessSubProcessInteractionID bigint   not null identity constraint PK_AtulInstanceProcessSubProcessInteraction primary key,
  AtulInstanceProcessID bigint   not null,
  AtulProcessSubProcessID bigint   not null,
  AtulServiceProviderID bigint   not null,
  ActivityInteractionLabel nvarchar(150) not null,
  ActivityInteractionIdentifer nvarchar(150) not null,
  ActivityInteractionURL nvarchar(150) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulInstanceProcessSubProcessInteraction add
  constraint FK_AtulInstanceProcessSubProcessInteraction_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table dbo.AtulProcess(
  AtulProcessID bigint   not null identity constraint PK_AtulProcess primary key,
  ProcessDescription nvarchar(256) not null,
  ProcessSummary nvarchar(500) not null,
  AtulProcessStatusID int      not null,
  DeadLineOffset int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  IsActive bit      not null,
  SubjectServiceProviderID bigint,
  SubjectScopeIdentifier nvarchar(255)
);
go

create table dbo.AtulProcessActivity(
  AtulProcessActivityID bigint   not null identity constraint PK_AtulProcessActivity primary key,
  AtulProcessID bigint   not null,
  AtulActivityID bigint   not null,
  ProcessActivitySortOrder int      not null,
  AutomationServiceProviderID bigint,
  AutomationIdentifier nvarchar(50),
  AutomationTriggerActivityGroupID bigint,
  AutomationExpectedDuration int,
  PrerequisiteActivityGroupID bigint,
  AtulDeadlineTypeID bigint,
  DeadlineActivityGroupID bigint,
  DeadlineResultsInMissed bit      not null,
  DeadlineOffset int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulProcessActivity add
  constraint FK_AtulProcessActivity_AtulDeadlineType foreign key(AtulDeadlineTypeID) references dbo.AtulDeadlineType(AtulDeadlineTypeID),
  constraint FK_AtulProcessActivity_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulProcessActivity_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID);
go

create table dbo.AtulProcessSchedule(
  AtulProcessScheduleID bigint   not null identity constraint PK_AtulProcessSchedule primary key,
  AtulProcessID bigint   not null,
  RepeatSchedule nvarchar(100) not null,
  LastInstantiated datetime,
  NextScheduledDate datetime not null,
  ScheduleVersion nvarchar(150) not null,
  IsActive bit      not null,
  CreatedDate datetime not null,
  ModifiedDate datetime not null,
  InstantiatedUserList nvarchar(max)
);
go

create table dbo.AtulProcessStatus(
  AtulProcessStatusID int      not null identity constraint PK_AtulProcessStatus primary key,
  ProcessStatus nvarchar(50) not null
);
go

create table dbo.AtulProcessSubprocess(
  AtulProcessSubprocessID bigint   not null identity constraint PK_AtulProcessSubprocess primary key,
  AtulProcessID bigint   not null,
  AtulSubProcessID bigint   not null,
  ProcessSubprocessSortOrder int      not null,
  NotificationServiceProviderID bigint,
  NotificationIdentifier nvarchar(100),
  ResponsibilityOf bigint   not null,
  DeadlineOffset int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulProcessSubprocess add
  constraint FK_AtulProcessSubprocess_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID);
go

create table dbo.AtulRemoteSystem(
  AtulRemoteSystemID bigint   not null identity constraint PK_AtulRemoteSystem primary key,
  RemoteSystem nvarchar(150) not null,
  IsActive bit      not null
);
go

create table dbo.AtulServiceProvider(
  AtulServiceProviderID bigint   not null identity constraint PK_AtulServiceProvider primary key,
  ServiceProviderName nvarchar(50) not null,
  ServiceProviderDescription nvarchar(256) not null,
  AtulServiceProviderClassID bigint   not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null,
  ServiceProviderXML nvarchar(max),
  ESBQueue nvarchar(max)
);
go

create table dbo.AtulServiceProviderClass(
  AtulServiceProviderClassID bigint   not null identity constraint PK_AtulServiceProviderClass primary key,
  ServiceProviderClassName nvarchar(50) not null,
  ServiceProviderClassDescription nvarchar(256) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulSubProcess(
  AtulSubProcessID bigint   not null identity constraint PK_AtulSubProcess primary key,
  SubProcessDescription nvarchar(256) not null,
  SubProcessSummary nvarchar(50) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  IsActive bit      not null
);
go

create table dbo.AtulUser(
  AtulUserID bigint   not null identity constraint PK_AtulUser primary key,
  AtulRemoteSystemID bigint   not null,
  AtulUserTypeID bigint   not null,
  RemoteSystemLoginID nvarchar(100) not null,
  DisplayName nvarchar(150) not null,
  IsActive bit      not null,
  Email    nvarchar(150)
);
go

alter table dbo.AtulUser add
  constraint FK_AtulUser_AtulRemoteSystem foreign key(AtulRemoteSystemID) references dbo.AtulRemoteSystem(AtulRemoteSystemID);
go

create table dbo.AtulUserDefinedAttribute(
  AtulUserDefinedAttributeID bigint   not null identity constraint PK_AtulUserDefinedAttribute primary key,
  AtulUserDefinedFieldID bigint   not null,
  AtulUserDefinedValueID bigint   not null,
  SortOrder int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulUserDefinedAttribute add
  constraint FK_AtulUserDefinedAttribute_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedAttribute_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulUserDefinedField(
  AtulUserDefinedFieldID bigint   not null identity constraint PK_AtulUserDefinedField primary key,
  UserDefinedFieldName nvarchar(50) not null,
  UserDefinedFieldComment nvarchar(256) not null,
  UserDefinedFieldTypeID int      not null,
  UserDefinedFieldSortOrder int      not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  ValidationRegExp nvarchar(255),
  InfoUrl  nvarchar(1024),
  IsActive bit      not null
);
go

alter table dbo.AtulUserDefinedField add
  constraint FK_AtulUserDefinedField_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedField_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulUserDefinedFieldType(
  AtulUserDefinedFieldTypeID int      not null identity constraint PK_AtulUserDefinedFieldType primary key,
  UserDefinedFieldTypeName nvarchar(50) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  Modifiedby bigint   not null
);
go

alter table dbo.AtulUserDefinedFieldType add
  constraint FK_AtulUserDefinedFieldType_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedFieldType_AtulUser1 foreign key(Modifiedby) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulUserDefinedValue(
  AtulUserDefinedValueID bigint   not null identity constraint PK_AtulUserDefinedValue primary key,
  UserDefinedValue nvarchar(255) not null,
  CreatedDate datetime not null,
  CreatedBy bigint   not null,
  ModifiedDate datetime not null,
  ModifiedBy bigint   not null,
  IsActive bit      not null
);
go

alter table dbo.AtulUserDefinedValue add
  constraint FK_AtulUserDefinedValue_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedValue_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulUserType(
  AtulUserTypeID bigint   not null identity constraint PK_AtulUserType primary key,
  UserTypeName nvarchar(50) not null,
  IsActive bit      not null
);
go

alter table dbo.AtulUserDefinedField add
  constraint FK_AtulUserDefinedField_AtulUserDefinedFieldType foreign key(UserDefinedFieldTypeID) references dbo.AtulUserDefinedFieldType(AtulUserDefinedFieldTypeID);
go

alter table dbo.AtulUserDefinedAttribute add
  constraint FK_AtulUserDefinedAttribute_AtulUserDefinedValue foreign key(AtulUserDefinedValueID) references dbo.AtulUserDefinedValue(AtulUserDefinedValueID),
  constraint FK_AtulUserDefinedAttribute_AtulUserDefinedField foreign key(AtulUserDefinedFieldID) references dbo.AtulUserDefinedField(AtulUserDefinedFieldID);
go

alter table dbo.AtulUser add
  constraint FK_AtulUser_AtulUserType foreign key(AtulUserTypeID) references dbo.AtulUserType(AtulUserTypeID);
go

alter table dbo.AtulSubProcess add
  constraint FK_AtulSubProcess_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulSubProcess_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulSubProcess_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulServiceProvider add
  constraint FK_AtulServiceProvider_AtulServiceProviderClass foreign key(AtulServiceProviderClassID) references dbo.AtulServiceProviderClass(AtulServiceProviderClassID);
go

alter table dbo.AtulProcessSubprocess add
  constraint FK_AtulProcessSubprocess_AtulServiceProvider foreign key(NotificationServiceProviderID) references dbo.AtulServiceProvider(AtulServiceProviderID),
  constraint FK_AtulProcessSubprocess_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulProcessSubprocess_AtulUser foreign key(ResponsibilityOf) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessSubprocess_AtulUser2 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessSubprocess_AtulUser1 foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulProcessActivity add
  constraint FK_AtulProcessActivity_AtulServiceProvider foreign key(AutomationServiceProviderID) references dbo.AtulServiceProvider(AtulServiceProviderID),
  constraint FK_AtulProcessActivity_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessActivity_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulProcess add
  constraint FK_AtulProcess_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcess_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcess_AtulProcessStatus foreign key(AtulProcessStatusID) references dbo.AtulProcessStatus(AtulProcessStatusID),
  constraint FK_AtulProcess_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulInstanceProcessSubProcessInteraction add
  constraint FK_AtulInstanceProcessSubProcessInteraction_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcessInteraction_AtulProcessActivity foreign key(AtulProcessSubProcessID) references dbo.AtulProcessSubprocess(AtulProcessSubprocessID),
  constraint FK_AtulInstanceProcessSubProcessInteraction_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulInstanceProcessSubProcess add
  constraint FK_AtulInstanceProcessSubProcess_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcess_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcess_AtulProcessActivity foreign key(AtulProcessSubprocessID) references dbo.AtulProcessSubprocess(AtulProcessSubprocessID);
go

alter table dbo.AtulInstanceProcessActivityInteraction add
  constraint FK_AtulInstanceProcessActivityInteraction_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessActivityInteraction_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulInstanceProcessActivity add
  constraint FK_AtulInstanceProcessActivity_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessActivity_AtulProcessActivity foreign key(AtulProcessActivityID) references dbo.AtulProcessActivity(AtulProcessActivityID),
  constraint FK_AtulInstanceProcessActivity_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulInstanceProcess add
  constraint FK_AtulInstanceProcess_AtulProcessStatus foreign key(AtulProcessStatusID) references dbo.AtulProcessStatus(AtulProcessStatusID),
  constraint FK_AtulInstanceProcess_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID),
  constraint FK_AtulInstanceProcess_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcess_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulFlexFieldStorage add
  constraint FK_AtulFlexFieldStorage_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexFieldStorage_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexFieldStorage_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

alter table dbo.AtulFlexField add
  constraint FK_AtulFlexField_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexField_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexField_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulFlexField_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID);
go

alter table dbo.AtulConfigVariables add
  constraint FK_AtulConfigVariables_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulConfigVariables_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulActivityGroupActivity add
  constraint FK_AtulActivityGroupActivity_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivityGroupActivity_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulActivityGroup add
  constraint FK_AtulActivityGroup_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActvityGroup_AtulActivityGroupPurpose foreign key(AtulActivityGroupPurposeID) references dbo.AtulActivityGroupPurpose(AtulActivityGroupPurposeID),
  constraint FK_AtulActivityGroup_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

alter table dbo.AtulActivity add
  constraint FK_AtulActivity_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivity_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulActivity_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivity_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulGroupMemeber(
  AtulGroupMemeberID int      not null identity constraint PK_AtulGroupMemeber primary key,
  AtulGroupID bigint   not null,
  AtulUserID bigint   not null
);
go

alter table dbo.AtulGroupMemeber add
  constraint FK_AtulGroupMemeber_AtulUserGroup foreign key(AtulGroupID) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulGroupMemeber_AtulUserMember foreign key(AtulUserID) references dbo.AtulUser(AtulUserID);
go

create table dbo.AtulGroupSupervisor(
  AtulGroupSupervisorID int      not null identity constraint PK_AtulGroupSupervisor primary key,
  AtulGroupID bigint   not null,
  AtulSupervisorID bigint   not null
);
go

alter table dbo.AtulGroupSupervisor add
  constraint FK_AtulGroupSupervisor_AtulUserGroup foreign key(AtulGroupID) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulGroupSupervisor_AtulUserMember foreign key(AtulSupervisorID) references dbo.AtulUser(AtulUserID);
go


create schema audit;
go



create table audit.AtulActivity(
  AtulActivityAuditID bigint   not null identity constraint PK_AtulActivity primary key,
  AtulActivityID bigint   not null,
  AtulSubProcessID bigint   not null,
  ActivityDescription nvarchar(256) not null,
  ActivitySummary nvarchar(50) not null,
  ActivityProcedure nvarchar(max) not null,
  AtulActivitySortOrder int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulActivity add
  constraint FK_AtulActivityAudit_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulActivityAudit_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulActivityAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivityAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivityAudit_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulActivityGroup(
  AtulActivityGroupAuditID bigint   not null identity constraint PK_AtulActivityGroup primary key,
  AtulActivityGroupID bigint   not null,
  AtulActivityGroupPurposeID bigint   not null,
  ActivityGroupDescription nvarchar(256) not null,
  ActivityGroupSummary nvarchar(50) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulActivityGroup add
  constraint FK_AtulActivityGroupAudit_AtulActivityGroup foreign key(AtulActivityGroupID) references dbo.AtulActivityGroup(AtulActivityGroupID),
  constraint FK_AtulActivityGroupAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivityGroupAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActvityGroupAudit_AtulActivityGroupPurpose foreign key(AtulActivityGroupPurposeID) references dbo.AtulActivityGroupPurpose(AtulActivityGroupPurposeID);
go

create table audit.AtulActivityGroupActivity(
  AtulActivityGroupActivityAuditID bigint   not null identity constraint PK_AtulActivityGroupActivity primary key,
  AtulActivityGroupActivityID bigint   not null,
  AtulActivityGroupID bigint   not null,
  AtulActivityID bigint   not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime not null
);
go

alter table audit.AtulActivityGroupActivity add
  constraint FK_AtulActivityGroupActivityAudit_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulActivityGroupActivityAudit_AtulActivityGroup foreign key(AtulActivityGroupID) references dbo.AtulActivityGroup(AtulActivityGroupID),
  constraint FK_AtulActivityGroupActivityAudit_AtulActivityGroupActivity foreign key(AtulActivityGroupActivityID) references dbo.AtulActivityGroupActivity(AtulActivityGroupActivityID),
  constraint FK_AtulActivityGroupActivityAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulActivityGroupActivityAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulActivityGroupPurpose(
  AtulActivityGroupPurposeAuditID bigint   not null identity constraint PK_AtulActivityGroupPurpose primary key,
  AtulActivityGroupPurposeID bigint   not null,
  ActivityGroupPurposeName nvarchar(50) not null,
  ActivityGroupPurposeDescription nvarchar(max) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime not null
);
go

create table audit.AtulConfigVariables(
  AtulConfigVariablesAuditID bigint   not null identity constraint PK_AtulConfigVariables primary key,
  AtulConfigVariablesID int      not null,
  ConfigVariableName nvarchar(200) not null,
  ConfigVariableValue nvarchar(max) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  ScriptName nvarchar(100),
  EndDate  datetime
);
go

alter table audit.AtulConfigVariables add
  constraint FK_AtulConfigVariablesAudit_AtulConfigVariables foreign key(AtulConfigVariablesID) references dbo.AtulConfigVariables(AtulConfigVariablesID),
  constraint FK_AtulConfigVariablesAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulConfigVariablesAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulDeadlineType(
  AtulDeadlineTypeAuditID bigint   not null identity constraint PK_AtulDeadlineType primary key,
  AtulDeadlineTypeID bigint   not null,
  DeadlineName nvarchar(150) not null,
  DeadlineDescription nvarchar(256) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

create table audit.AtulFlexField(
  AtulFlexFieldAuditID bigint   not null identity constraint PK_AtulFlexField_1 primary key,
  AtulFlexFieldID bigint   not null,
  TokenName nvarchar(200) not null,
  IsRequired bit      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime,
  AtulProcessID bigint,
  AtulSubProcessID bigint,
  AtulActivityID bigint,
  DefaultTokenValue nvarchar(max),
  FriendlyName nvarchar(100),
  ToolTip  nvarchar(max),
  IsParameter bit
);
go

alter table audit.AtulFlexField add
  constraint FK_AtulFlexFieldAudit_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulFlexFieldAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexFieldAudit_AtulFlexField foreign key(AtulFlexFieldID) references dbo.AtulFlexField(AtulFlexFieldID),
  constraint FK_AtulFlexFieldAudit_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulFlexFieldAudit_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID),
  constraint FK_AtulFlexFieldAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulFlexFieldStorage(
  AtulFlexFieldStorageAuditID bigint   not null identity constraint PK_AtulFlexFieldStorage_1 primary key,
  AtulFlexFieldStorageID bigint   not null,
  AtulInstanceProcessID bigint   not null,
  AtulFlexFieldID bigint   not null,
  TokenValue nvarchar(max) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulFlexFieldStorage add
  constraint FK_AtulFlexFieldStorageAudit_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID),
  constraint FK_AtulFlexFieldStorageAudit_AtulFlexFieldStorage foreign key(AtulFlexFieldStorageID) references dbo.AtulFlexFieldStorage(AtulFlexFieldStorageID),
  constraint FK_AtulFlexFieldStorageAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulFlexFieldStorageAudit_AtulFlexField foreign key(AtulFlexFieldID) references dbo.AtulFlexField(AtulFlexFieldID),
  constraint FK_AtulFlexFieldStorageAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulInstanceProcess(
  AtulInstanceProcessAuditID bigint   not null identity constraint PK_AtulInstanceProcess primary key,
  AtulInstanceProcessID bigint   not null,
  AtulProcessID bigint   not null,
  CreatedBy bigint   not null,
  OwnedBy  bigint   not null,
  AtulProcessStatusID int      not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime,
  SubjectIdentifier nvarchar(50),
  SubjectSummary nvarchar(255),
  InstanceProcessProcessCompleted bit      not null default ((0)),
  InstanceProcessProcessDeadlineMissed bit      not null default ((0)),
  InstanceProcessProcessCompletedBy bigint,
  SubjectServiceProviderID bigint
);
go

create table audit.AtulInstanceProcessActivity(
  AtulInstanceProcessActivityAuditID bigint   not null identity constraint PK_AtulInstanceProcessActivity primary key,
  AtulInstanceProcessActivityID bigint   not null,
  AtulInstanceProcessID bigint   not null,
  AtulProcessActivityID bigint   not null,
  InstanceProcessActivityDeadline datetime,
  InstanceProcessActivityCompleted bit      not null,
  InstanceProcessActivityDidNotApply bit      not null,
  InstanceProcessActivityDeadlineMissed bit      not null,
  InstanceProcessActivityCompletedBy bigint,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime,
  AtulServiceProviderID bigint
);
go

create table audit.AtulInstanceProcessActivityInteraction(
  AtulInstanceProcessActivityInteractionAuditID bigint   not null identity constraint PK_AtulInstanceProcessActivityInteraction primary key,
  AtulInstanceProcessActivityInteractionID bigint   not null,
  AtulInstanceProcessID bigint   not null,
  AtulActivityID bigint   not null,
  AtulServiceProviderID bigint   not null,
  ActivityInteractionLabel nvarchar(150) not null,
  ActivityInteractionIdentifer nvarchar(150) not null,
  ActivityInteractionURL nvarchar(150) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulInstanceProcessActivityInteraction add
  constraint FK_AtulInstanceProcessActivityInteractionAudit_AtulProcessActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulInstanceProcessActivityInteractionAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessActivityInteractionAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessActivityInteractionAudit_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table audit.AtulInstanceProcessSubProcess(
  AtulInstanceProcessSubProcessAuditID bigint   not null identity constraint PK_AtulInstanceProcessSubProcess_1 primary key,
  AtulInstanceProcessSubProcessID bigint   not null,
  AtulInstanceProcessID bigint   not null,
  AtulProcessSubprocessID bigint   not null,
  InstanceProcessSubProcessCompleted bit      not null,
  InstanceProcessSubProcessDidNotApply bit      not null,
  InstanceProcessSubProcessDeadlineMissed bit      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  InstanceProcessSubProcessCompletedBy bigint,
  InstanceProcessSubprocessDeadline datetime,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulInstanceProcessSubProcess add
  constraint FK_AtulInstanceProcessSubProcessAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcessAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcessAudit_AtulProcessActivity foreign key(AtulProcessSubprocessID) references dbo.AtulProcessSubprocess(AtulProcessSubprocessID),
  constraint FK_AtulInstanceProcessSubProcessAudit_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID);
go

create table audit.AtulInstanceProcessSubProcessInteraction(
  AtulInstanceProcessSubProcessInteractionAuditID bigint   not null identity constraint PK_AtulInstanceProcessSubProcessInteractionAudit primary key,
  AtulInstanceProcessSubProcessInteractionID bigint   not null,
  AtulInstanceProcessID bigint   not null,
  AtulProcessSubProcessID bigint   not null,
  AtulServiceProviderID bigint   not null,
  ActivityInteractionLabel nvarchar(150) not null,
  ActivityInteractionIdentifer nvarchar(150) not null,
  ActivityInteractionURL nvarchar(150) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulInstanceProcessSubProcessInteraction add
  constraint FK_AtulInstanceProcessSubProcessInteractionAudit_AtulProcessActivity foreign key(AtulProcessSubProcessID) references dbo.AtulProcessSubprocess(AtulProcessSubprocessID),
  constraint FK_AtulInstanceProcessSubProcessInteractionAudit_AtulInstanceProcess foreign key(AtulInstanceProcessID) references dbo.AtulInstanceProcess(AtulInstanceProcessID),
  constraint FK_AtulInstanceProcessSubProcessInteractionAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulInstanceProcessSubProcessInteractionAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulProcess(
  AtulProcessAuditID bigint   not null identity constraint PK_AtulProcess primary key,
  AtulProcessID bigint   not null,
  ProcessDescription nvarchar(256) not null,
  ProcessSummary nvarchar(500) not null,
  AtulProcessStatusID int      not null,
  DeadLineOffset int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  StartDate datetime not null,
  EndDate  datetime,
  SubjectServiceProviderID bigint,
  SubjectScopeIdentifier nvarchar(255)
);
go

alter table audit.AtulProcess add
  constraint FK_AtulProcessAudit_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessAudit_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID),
  constraint FK_AtulProcessAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulProcessActivity(
  AtulProcessActivityAuditID bigint   not null identity constraint PK_AtulProcessActivity primary key,
  AtulProcessActivityID bigint   not null,
  AtulProcessID bigint   not null,
  AtulActivityID bigint   not null,
  ProcessActivitySortOrder int      not null,
  AutomationServiceProviderID bigint,
  AutomationIdentifier nvarchar(50),
  AutomationTriggerActivityGroupID bigint,
  AutomationExpectedDuration int,
  PrerequisiteActivityGroupID bigint,
  AtulDeadlineTypeID bigint   not null,
  DeadlineActivityGroupID bigint,
  DeadlineResultsInMissed bit      not null,
  DeadlineOffset int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulProcessActivity add
  constraint FK_AtulProcessActivityAudit_AtulProcessActivity foreign key(AtulProcessActivityID) references dbo.AtulProcessActivity(AtulProcessActivityID),
  constraint FK_AtulProcessActivityAudit_AtulDeadlineType foreign key(AtulDeadlineTypeID) references dbo.AtulDeadlineType(AtulDeadlineTypeID),
  constraint FK_AtulProcessActivityAudit_AtulServiceProvider foreign key(AutomationServiceProviderID) references dbo.AtulServiceProvider(AtulServiceProviderID),
  constraint FK_AtulProcessActivityAudit_AtulActivity foreign key(AtulActivityID) references dbo.AtulActivity(AtulActivityID),
  constraint FK_AtulProcessActivityAudit_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID);
go

create table audit.AtulProcessSchedule(
  AtulProcessScheduleAuditID bigint   not null identity constraint PK_AtulProcessSchedule primary key,
  AtulProcessScheduleID bigint   not null,
  AtulProcessID bigint   not null,
  RepeatSchedule nvarchar(100) not null,
  LastInstantiated datetime,
  NextScheduledDate datetime not null,
  ScheduleVersion nvarchar(150) not null,
  IsActive bit      not null,
  CreatedDate datetime not null,
  StartDate datetime not null,
  EndDate  datetime,
  InstantiatedUserList nvarchar(max)
);
go

create table audit.AtulProcessSubprocess(
  AtulProcessSubprocessAuditID bigint   not null identity constraint PK_AtulProcessSubprocess primary key,
  AtulProcessSubprocessID bigint   not null,
  AtulProcessID bigint   not null,
  AtulSubProcessID bigint   not null,
  ProcessSubprocessSortOrder int      not null,
  NotificationServiceProviderID bigint,
  NotificationIdentifier nvarchar(100),
  ResponsibilityOf bigint   not null,
  DeadlineOffset int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulProcessSubprocess add
  constraint FK_AtulProcessSubprocessAudit_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulProcessSubprocessAudit_AtulServiceProvider foreign key(NotificationServiceProviderID) references dbo.AtulServiceProvider(AtulServiceProviderID),
  constraint FK_AtulProcessSubprocessAudit_AtulUser2 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessSubprocessAudit_AtulUser1 foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessSubprocessAudit_AtulUser foreign key(ResponsibilityOf) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulProcessSubprocessAudit_AtulProcess foreign key(AtulProcessID) references dbo.AtulProcess(AtulProcessID);
go

create table audit.AtulServiceProvider(
  AtulServiceProviderAuditID bigint   not null identity constraint PK_AtulServiceProvider primary key,
  AtulServiceProviderID bigint   not null,
  ServiceProviderName nvarchar(50) not null,
  ServiceProviderDescription nvarchar(256) not null,
  AtulServiceProviderClassID bigint   not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime,
  ServiceProviderXML nvarchar(max),
  ESBQueue nvarchar(max)
);
go

alter table audit.AtulServiceProvider add
  constraint FK_AtulServiceProviderAudit_AtulServiceProviderClass foreign key(AtulServiceProviderClassID) references dbo.AtulServiceProviderClass(AtulServiceProviderClassID);
go

create table audit.AtulServiceProviderClass(
  AtulServiceProviderClassAuditID bigint   not null identity constraint PK_AtulServiceProviderClass primary key,
  AtulServiceProviderClassID bigint   not null,
  ServiceProviderClassName nvarchar(50) not null,
  ServiceProviderClassDescription nvarchar(256) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

create table audit.AtulSubProcess(
  AtulSubProcessAuditID bigint   not null identity constraint PK_AtulSubProcess primary key,
  AtulSubProcessID bigint   not null,
  SubProcessDescription nvarchar(256) not null,
  SubProcessSummary nvarchar(50) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  OwnedBy  bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulSubProcess add
  constraint FK_AtulSubProcessAudit_AtulUser2 foreign key(OwnedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulSubProcessAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulSubProcessAudit_AtulSubProcess foreign key(AtulSubProcessID) references dbo.AtulSubProcess(AtulSubProcessID),
  constraint FK_AtulSubProcessAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go

create table audit.AtulUserDefinedAttribute(
  AtulUserDefinedAttributeAuditID bigint   not null identity constraint PK_AtulUserDefinedAttribute primary key,
  AtulUserDefinedAttributeID bigint   not null,
  AtulUserDefinedFieldID bigint   not null,
  AtulUserDefinedValueID bigint   not null,
  SortOrder int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulUserDefinedAttribute add
  constraint FK_AtulUserDefinedAttributeAudit_AtulUserDefinedField foreign key(AtulUserDefinedFieldID) references dbo.AtulUserDefinedField(AtulUserDefinedFieldID),
  constraint FK_AtulUserDefinedAttributeAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedAttributeAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedAttributeAudit_AtulUserDefinedAttribute foreign key(AtulUserDefinedAttributeID) references dbo.AtulUserDefinedAttribute(AtulUserDefinedAttributeID),
  constraint FK_AtulUserDefinedAttributeAudit_AtulUserDefinedValue foreign key(AtulUserDefinedValueID) references dbo.AtulUserDefinedValue(AtulUserDefinedValueID);
go

create table audit.AtulUserDefinedField(
  AtulUserDefinedFieldAuditID bigint   not null identity constraint PK_AtulUserDefinedField primary key,
  AtulUserDefinedFieldID bigint   not null,
  UserDefinedFieldName nvarchar(50) not null,
  UserDefinedFieldComment nvarchar(256) not null,
  UserDefinedFieldTypeID int      not null,
  UserDefinedFieldSortOrder int      not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  ValidationRegExp nvarchar(255),
  InfoUrl  nvarchar(1024),
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulUserDefinedField add
  constraint FK_AtulUserDefinedFieldAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedFieldAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedFieldAudit_AtulUserDefinedField foreign key(AtulUserDefinedFieldID) references dbo.AtulUserDefinedField(AtulUserDefinedFieldID);
go

create table audit.AtulUserDefinedValue(
  AtulUserDefinedValueAuditID bigint   not null identity constraint PK_AtulUserDefinedValue primary key,
  AtulUserDefinedValueID bigint   not null,
  UserDefinedValue nvarchar(255) not null,
  CreatedBy bigint   not null,
  ModifiedBy bigint   not null,
  StartDate datetime not null,
  EndDate  datetime
);
go

alter table audit.AtulUserDefinedValue add
  constraint FK_AtulUserDefinedValueAudit_AtulUser foreign key(CreatedBy) references dbo.AtulUser(AtulUserID),
  constraint FK_AtulUserDefinedValueAudit_AtulUserDefinedValue foreign key(AtulUserDefinedValueID) references dbo.AtulUserDefinedValue(AtulUserDefinedValueID),
  constraint FK_AtulUserDefinedValueAudit_AtulUser1 foreign key(ModifiedBy) references dbo.AtulUser(AtulUserID);
go



create PROCEDURE dbo.Atul_ActivitiesGetBySubProcessID_sp
(
	@AtulSubProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	a.AtulActivityID			AS AtulActivityID,
		a.AtulSubProcessID			AS AtulSubProcessID,
		a.ActivityDescription			AS ActivityDescription,
		a.ActivitySummary			AS ActivitySummary,
		a.ActivityProcedure			AS ActivityProcedure,
		a.AtulActivitySortOrder			AS AtulActivitySortOrder,
		a.CreatedDate				AS CreatedDate,
		a.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		a.ModifiedDate				AS ModifiedDate,
		a.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		a.OwnedBy				AS OwnedBy,
		ou.DisplayName				AS OwnedByName
	FROM	dbo.AtulActivity a
	JOIN	dbo.AtulUser cu ON a.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON a.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON a.OwnedBy = ou.AtulUserID
	WHERE	a.AtulSubProcessID = @AtulSubProcessID
	AND	a.IsActive = CAST ( 1 AS BIT )
	ORDER BY a.AtulActivitySortOrder;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityDelete_sp
(
	@AtulActivityID		BIGINT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;
	
	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	p
		SET	p.IsActive	= CAST ( 0 AS BIT ),
			p.ModifiedDate	= @now,
			p.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulActivity p 
		WHERE	p.AtulActivityID = @AtulActivityID;
		
		UPDATE	audit.AtulActivity
		SET	EndDate		= @now
		WHERE	AtulActivityID = @AtulActivityID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGetByActivityID_sp
(
	@AtulActivityID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	a.AtulActivityID			AS AtulActivityID,
		a.AtulSubProcessID			AS AtulSubProcessID,
		a.ActivityDescription			AS ActivityDescription,
		a.ActivitySummary			AS ActivitySummary,
		a.ActivityProcedure			AS ActivityProcedure,
		a.AtulActivitySortOrder			AS AtulActivitySortOrder,
		a.CreatedDate				AS CreatedDate,
		a.CreatedBy				AS CreatedBy,
	        c.DisplayName				AS CreatedByName,
		a.ModifiedDate				AS ModifiedDate,
		a.ModifiedBy				AS ModifiedBy,
	        m.DisplayName				AS ModifiedByName,
		a.OwnedBy				AS OwnedBy,
	        o.DisplayName				AS OwnedByName
	FROM	dbo.AtulActivity a
	JOIN	dbo.AtulUser c ON a.CreatedBy = c.AtulUserID
	JOIN	dbo.AtulUser m ON a.ModifiedBy = m.AtulUserID
	JOIN	dbo.AtulUser o ON a.OwnedBy = o.AtulUserID
	WHERE	AtulActivityID = @AtulActivityID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	a.AtulActivityID			AS AtulActivityID,
		a.AtulSubProcessID			AS AtulSubProcessID,
		a.ActivityDescription			AS ActivityDescription,
		a.ActivitySummary			AS ActivitySummary,
		a.ActivityProcedure			AS ActivityProcedure,
		a.AtulActivitySortOrder			AS AtulActivitySortOrder,
		a.CreatedDate				AS CreatedDate,
		a.CreatedBy				AS CreatedBy,
	        c.DisplayName				AS CreatedByName,
		a.ModifiedDate				AS ModifiedDate,
		a.ModifiedBy				AS ModifiedBy,
	        m.DisplayName				AS ModifiedByName,
		a.OwnedBy				AS OwnedBy,
	        o.DisplayName				AS OwnedByName
	FROM	dbo.AtulActivity a
	JOIN	dbo.AtulUser c ON a.CreatedBy = c.AtulUserID
	JOIN	dbo.AtulUser m ON a.ModifiedBy = m.AtulUserID
	JOIN	dbo.AtulUser o ON a.OwnedBy = o.AtulUserID
	WHERE	a.IsActive = CAST(1 AS BIT)
	ORDER BY a.AtulSubProcessID ASC, a.AtulActivitySortOrder ASC;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupActivityDelete_sp
(
	@AtulActivityGroupActivityID	BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroupActivity ag
		WHERE	ag.AtulActivityGroupActivityID	= @AtulActivityGroupActivityID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulActivityGroupActivity aga
		WHERE	aga.AtulActivityGroupActivityID	= @AtulActivityGroupActivityID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupActivityGetByID_sp
(
	@AtulActivityGroupActivityID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	aga.AtulActivityGroupActivityID		AS AtulActivityGroupActivityID,
		aga.AtulActivityGroupID			AS AtulActivityGroupID,
		aga.AtulActivityID			AS AtulActivityID,
		aga.CreatedDate				AS CreatedDate,
		aga.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		aga.ModifiedDate			AS ModifiedDate,
		aga.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulActivityGroupActivity aga 
	JOIN	dbo.AtulUser cu ON aga.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON aga.ModifiedBy = mu.AtulUserID
	WHERE	aga.AtulActivityGroupActivityID = @AtulActivityGroupActivityID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupActivityGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	aga.AtulActivityGroupActivityID		AS AtulActivityGroupActivityID,
		aga.AtulActivityGroupID			AS AtulActivityGroupID,
		aga.AtulActivityID			AS AtulActivityID,
		aga.CreatedDate				AS CreatedDate,
		aga.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		aga.ModifiedDate			AS ModifiedDate,
		aga.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulActivityGroupActivity aga 
	JOIN	dbo.AtulUser cu ON aga.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON aga.ModifiedBy = mu.AtulUserID
	WHERE	aga.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupActivityInsert_sp
(
	@AtulActivityGroupID	BIGINT,
	@AtulActivityID		BIGINT,
	@CreatedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulActivityGroupActivityID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulActivityGroupActivity (
			AtulActivityGroupID,
			AtulActivityID,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulActivityGroupID,
			@AtulActivityID,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulActivityGroupActivityID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulActivityGroupActivity (
			AtulActivityGroupActivityID,
			AtulActivityGroupID,
			AtulActivityID,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupActivityID,
			AtulActivityGroupID,
			AtulActivityID,
			CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulActivityGroupActivity WITH (NOLOCK)
		WHERE	AtulActivityGroupActivityID = @AtulActivityGroupActivityID;
	COMMIT TRAN;

	SELECT	@AtulActivityGroupActivityID		AS AtulActivityGroupActivityID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupActivityUpdate_sp
(
	@AtulActivityGroupActivityID	BIGINT,
	@AtulActivityGroupID		BIGINT,
	@AtulActivityID			BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	aga
		SET	AtulActivityGroupID		= @AtulActivityGroupID,
			AtulActivityID			= @AtulActivityID,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroupActivity aga WITH (ROWLOCK)
		WHERE	AtulActivityGroupActivityID	= @AtulActivityGroupActivityID;

		UPDATE	aaga
		SET	aaga.EndDate			= @now
		FROM	audit.AtulActivityGroupActivity aaga WITH (ROWLOCK)
		WHERE	AtulActivityGroupActivityID	= @AtulActivityGroupActivityID
		AND	aaga.EndDate	IS NULL;
		
		INSERT	audit.AtulActivityGroupActivity (
			AtulActivityGroupActivityID,
			AtulActivityGroupID,
			AtulActivityID,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupActivityID,
			AtulActivityGroupID,
			AtulActivityID,
			CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulActivityGroupActivity WITH (NOLOCK)
		WHERE	AtulActivityGroupActivityID = @AtulActivityGroupActivityID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupDelete_sp
(
	@AtulActivityGroupID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroup ag
		WHERE	ag.AtulActivityGroupID		= @AtulActivityGroupID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulActivityGroup aga
		WHERE	aga.AtulActivityGroupID		= @AtulActivityGroupID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupGetByID_sp
(
	@AtulActivityGroupID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ag.AtulActivityGroupID			AS AtulActivityGroupID,
		ag.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		ag.ActivityGroupDescription		AS ActivityGroupDescription,
		ag.ActivityGroupSummary			AS ActivityGroupSummary,
		ag.CreatedDate				AS CreatedDate,
		ag.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ag.ModifiedDate				AS ModifiedDate,
		ag.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		gp.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		gp.ActivityGroupPurposeName		AS ActivityGroupPurposeName,
		gp.ActivityGroupPurposeDescription	AS ActivityGroupPurposeDescription
	FROM	dbo.AtulActivityGroup ag
	JOIN	dbo.AtulActivityGroupPurpose gp ON ag.AtulActivityGroupPurposeID = gp.AtulActivityGroupPurposeID
	JOIN	dbo.AtulUser cu ON ag.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ag.ModifiedBy = mu.AtulUserID
	WHERE	ag.AtulActivityGroupID = @AtulActivityGroupID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ag.AtulActivityGroupID			AS AtulActivityGroupID,
		ag.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		ag.ActivityGroupDescription		AS ActivityGroupDescription,
		ag.ActivityGroupSummary			AS ActivityGroupSummary,
		ag.CreatedDate				AS CreatedDate,
		ag.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ag.ModifiedDate				AS ModifiedDate,
		ag.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		gp.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		gp.ActivityGroupPurposeName		AS ActivityGroupPurposeName,
		gp.ActivityGroupPurposeDescription	AS ActivityGroupPurposeDescription
	FROM	dbo.AtulActivityGroup ag
	JOIN	dbo.AtulActivityGroupPurpose gp ON ag.AtulActivityGroupPurposeID = gp.AtulActivityGroupPurposeID
	JOIN	dbo.AtulUser cu ON ag.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ag.ModifiedBy = mu.AtulUserID
	WHERE	ag.IsActive = CAST ( 1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupInsert_sp
(
	@AtulActivityGroupPurposeID	BIGINT,
	@ActivityGroupDescription	NVARCHAR(256),
	@ActivityGroupSummary		NVARCHAR(50),
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME,
		@AtulActivityGroupID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulActivityGroup (
			AtulActivityGroupPurposeID,
			ActivityGroupDescription,
			ActivityGroupSummary,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulActivityGroupPurposeID,
			@ActivityGroupDescription,
			@ActivityGroupSummary,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulActivityGroupID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulActivityGroup (
			AtulActivityGroupID,
			AtulActivityGroupPurposeID,
			ActivityGroupDescription,
			ActivityGroupSummary,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupID,
		        AtulActivityGroupPurposeID,
		        ActivityGroupDescription,
		        ActivityGroupSummary,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulActivityGroup WITH (NOLOCK)
		WHERE	AtulActivityGroupID = @AtulActivityGroupID;
	COMMIT TRAN;

	SELECT	@AtulActivityGroupID		AS AtulActivityGroupID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupPurposeDelete_sp
(
	@AtulActivityGroupPurposeID	BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	pa
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroupPurpose pa
		WHERE	pa.AtulActivityGroupPurposeID	= @AtulActivityGroupPurposeID;
		
		UPDATE	paa
		SET	EndDate				= @now
		FROM	audit.AtulActivityGroupPurpose paa
		WHERE	paa.AtulActivityGroupPurposeID	= @AtulActivityGroupPurposeID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupPurposeGetByID_sp
(
	@AtulActivityGroupPurposeID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	gp.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		gp.ActivityGroupPurposeName		AS ActivityGroupPurposeName,
		gp.ActivityGroupPurposeDescription	AS ActivityGroupPurposeDescription,
		gp.CreatedDate				AS CreatedDate,
		gp.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		gp.ModifiedDate				AS ModifiedDate,
		gp.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulActivityGroupPurpose gp
	JOIN	dbo.AtulUser cu ON gp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON gp.ModifiedBy = mu.AtulUserID
	WHERE	gp.AtulActivityGroupPurposeID = @AtulActivityGroupPurposeID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupPurposeGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	gp.AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID,
		gp.ActivityGroupPurposeName		AS ActivityGroupPurposeName,
		gp.ActivityGroupPurposeDescription	AS ActivityGroupPurposeDescription,
		gp.CreatedDate				AS CreatedDate,
		gp.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		gp.ModifiedDate				AS ModifiedDate,
		gp.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulActivityGroupPurpose gp
	JOIN	dbo.AtulUser cu ON gp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON gp.ModifiedBy = mu.AtulUserID
	WHERE	gp.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupPurposeInsert_sp
(
	@ActivityGroupPurposeName		NVARCHAR(50),
	@ActivityGroupPurposeDescription	NVARCHAR(MAX),
	@CreatedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulActivityGroupPurposeID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulActivityGroupPurpose (
			ActivityGroupPurposeName,
			ActivityGroupPurposeDescription,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@ActivityGroupPurposeName,
			@ActivityGroupPurposeDescription,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT )

		SET	@AtulActivityGroupPurposeID = SCOPE_IDENTITY();

		INSERT	audit.AtulActivityGroupPurpose (
			AtulActivityGroupPurposeID,
			ActivityGroupPurposeName,
			ActivityGroupPurposeDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupPurposeID,
			ActivityGroupPurposeName,
			ActivityGroupPurposeDescription,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulActivityGroupPurpose WITH (NOLOCK)
		WHERE	AtulActivityGroupPurposeID = @AtulActivityGroupPurposeID;
		
	COMMIT TRAN;

	SELECT	@AtulActivityGroupPurposeID		AS AtulActivityGroupPurposeID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupPurposeUpdate_sp
(
	@AtulActivityGroupPurposeID		BIGINT,
	@ActivityGroupPurposeName		NVARCHAR(50),
	@ActivityGroupPurposeDescription	NVARCHAR(MAX),
	@ModifiedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	agp
		SET	ActivityGroupPurposeName	= @ActivityGroupPurposeName,
			ActivityGroupPurposeDescription	= @ActivityGroupPurposeDescription,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroupPurpose agp WITH (ROWLOCK)
		WHERE	agp.AtulActivityGroupPurposeID	= @AtulActivityGroupPurposeID;

		UPDATE	aagp
		SET	aagp.EndDate			= @now
		FROM	audit.AtulActivityGroupPurpose aagp WITH (ROWLOCK)
		WHERE	aagp.AtulActivityGroupPurposeID	= @AtulActivityGroupPurposeID
		AND	aagp.EndDate	IS NULL;

		INSERT	audit.AtulActivityGroupPurpose (
			AtulActivityGroupPurposeID,
			ActivityGroupPurposeName,
			ActivityGroupPurposeDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupPurposeID,
			ActivityGroupPurposeName,
			ActivityGroupPurposeDescription,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulActivityGroupPurpose WITH (NOLOCK)
		WHERE	AtulActivityGroupPurposeID = @AtulActivityGroupPurposeID;
		
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityGroupUpdate_sp
(
	@AtulActivityGroupID		BIGINT,
	@AtulActivityGroupPurposeID	BIGINT,
	@ActivityGroupDescription	NVARCHAR(256),
	@ActivityGroupSummary		NVARCHAR(50),
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	AtulActivityGroupPurposeID	= @AtulActivityGroupPurposeID,
			ActivityGroupDescription	= @ActivityGroupDescription,
			ActivityGroupSummary		= @ActivityGroupSummary,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulActivityGroup ag WITH (ROWLOCK)
		WHERE	AtulActivityGroupID		= @AtulActivityGroupID;
		
		UPDATE	aag
		SET	EndDate				= @now
		FROM	audit.AtulActivityGroup aag WITH (ROWLOCK)
		WHERE	AtulActivityGroupID		= @AtulActivityGroupID
		AND	EndDate IS NULL;

		INSERT	audit.AtulActivityGroup (
			AtulActivityGroupID,
			AtulActivityGroupPurposeID,
			ActivityGroupDescription,
			ActivityGroupSummary,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulActivityGroupID,
		        AtulActivityGroupPurposeID,
		        ActivityGroupDescription,
		        ActivityGroupSummary,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulActivityGroup WITH (NOLOCK)
		WHERE	AtulActivityGroupID = @AtulActivityGroupID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityInsert_sp
(
	@AtulSubProcessID			BIGINT,
	@ActivityDescription			NVARCHAR(256),
	@ActivitySummary			NVARCHAR(50),
	@ActivityProcedure			NVARCHAR(MAX),
	@AtulActivitySortOrder			INT,
	@CreatedBy				BIGINT,
	@OwnedBy				BIGINT,
	@AtulProcessID				BIGINT,
	@ProcessActivitySortOrder		INT,
	@AutomationServiceProviderID		BIGINT		= NULL,
	@AutomationTriggerActivityGroupID	BIGINT		= NULL,
	@AutomationIdentifier			NVARCHAR(50)	= NULL,
	@AutomationExpectedDuration		INT		= NULL,
	@PrerequisiteActivityGroupID		BIGINT,
	@AtulDeadlineTypeID			BIGINT,
	@DeadlineActivityGroupID		BIGINT = NULL,
	@DeadlineResultsInMissed		BIT,
	@DeadlineOffset				INT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now			DATETIME,
		@AtulActivityID		BIGINT,
		@AtulProcessActivityID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulActivity (
			AtulSubProcessID,
			ActivityDescription,
			ActivitySummary,
			ActivityProcedure,
			AtulActivitySortOrder,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			OwnedBy,
			IsActive )
		SELECT	@AtulSubProcessID,
			@ActivityDescription,
			@ActivitySummary,
			@ActivityProcedure,
			@AtulActivitySortOrder,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@OwnedBy,
			CAST ( 1 AS BIT );

		SET	@AtulActivityID = SCOPE_IDENTITY();

		INSERT	audit.AtulActivity(
			AtulActivityID,
			AtulSubProcessID,
			ActivityDescription,
			ActivitySummary,
			ActivityProcedure,
			AtulActivitySortOrder,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate )
		SELECT	AtulActivityID,
			AtulSubProcessID ,
			ActivityDescription ,
			ActivitySummary ,
			ActivityProcedure ,
			AtulActivitySortOrder ,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now
		FROM	dbo.AtulActivity WITH (NOLOCK)
		WHERE	AtulActivityID = @AtulActivityID;
		
		INSERT	dbo.AtulProcessActivity (
			AtulProcessID,
			AtulActivityID,
			ProcessActivitySortOrder,
			AutomationServiceProviderID,
			AutomationIdentifier,
			AutomationTriggerActivityGroupID,
			AutomationExpectedDuration,
			PrerequisiteActivityGroupID,
			AtulDeadlineTypeID,
			DeadlineActivityGroupID,
			DeadlineResultsInMissed,
			DeadlineOffset,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulProcessID,
			@AtulActivityID,
			@ProcessActivitySortOrder,
			@AutomationServiceProviderID,
			@AutomationIdentifier,
			@AutomationTriggerActivityGroupID,
			@AutomationExpectedDuration,
			@PrerequisiteActivityGroupID,
			@AtulDeadlineTypeID,
			@DeadlineActivityGroupID,
			@DeadlineResultsInMissed,
			@DeadlineOffset,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulProcessActivityID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulProcessActivity (
			AtulProcessActivityID,
			AtulProcessID,
			AtulActivityID,
			ProcessActivitySortOrder,
			AutomationServiceProviderID,
			AutomationIdentifier,
			AutomationTriggerActivityGroupID,
			AutomationExpectedDuration,
			PrerequisiteActivityGroupID,
			AtulDeadlineTypeID,
			DeadlineActivityGroupID,
			DeadlineResultsInMissed,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessActivityID,
		        AtulProcessID,
		        AtulActivityID,
		        ProcessActivitySortOrder,
		        AutomationServiceProviderID,
		        AutomationIdentifier,
			AutomationTriggerActivityGroupID,
		        AutomationExpectedDuration,
		        PrerequisiteActivityGroupID,
		        AtulDeadlineTypeID,
		        DeadlineActivityGroupID,
		        DeadlineResultsInMissed,
		        DeadlineOffset,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulProcessActivity WITH (NOLOCK)
		WHERE	AtulProcessActivityID = @AtulProcessActivityID;
	COMMIT TRAN;

	SELECT	@AtulActivityID		AS AtulActivityID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivitySortOrderUpdate_sp
(
	@AtulActivityID		BIGINT,
	@AtulActivitySortOrder	INT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	a
		SET	a.AtulActivitySortOrder	= @AtulActivitySortOrder,
			a.ModifiedBy		= @ModifiedBy,
			a.ModifiedDate		= @now
		FROM	dbo.AtulActivity a
		WHERE	a.AtulActivityID	= @AtulActivityID;
		
		UPDATE	aa
		SET	aa.EndDate		= @now
		FROM	audit.AtulActivity aa
		WHERE	aa.AtulActivityID	= @AtulActivityID
		AND	aa.EndDate	IS NULL;
		
		INSERT	audit.AtulActivity (
			AtulActivityID,
			AtulSubProcessID,
			ActivityDescription,
			ActivitySummary,
			ActivityProcedure,
			AtulActivitySortOrder,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate )
		SELECT	AtulActivityID,
			AtulSubProcessID,
			ActivityDescription,
			ActivitySummary,
			ActivityProcedure,
			AtulActivitySortOrder,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now
		FROM	dbo.AtulActivity a WITH (NOLOCK)
		WHERE	a.AtulActivityID	= @AtulActivityID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ActivityUpdate_sp
(
	@AtulActivityID		BIGINT,
	@AtulSubProcessID	BIGINT,
	@ActivityDescription	NVARCHAR(256),
	@ActivitySummary	NVARCHAR(50),
	@ActivityProcedure	NVARCHAR(MAX),
	@AtulActivitySortOrder	INT,
	@ModifiedBy		BIGINT,
	@OwnedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	a
		SET	AtulSubProcessID	= @AtulSubProcessID,
			ActivityDescription	= @ActivityDescription,
			ActivitySummary		= @ActivitySummary,
			ActivityProcedure	= @ActivityProcedure,
			AtulActivitySortOrder	= @AtulActivitySortOrder,
			ModifiedDate		= @now,
			ModifiedBy		= @ModifiedBy,
			OwnedBy			= @OwnedBy
		FROM	dbo.AtulActivity a
		WHERE	a.AtulActivityID	= @AtulActivityID;

		UPDATE	aa
		SET	EndDate			= @now
		FROM	audit.AtulActivity aa
		WHERE	AtulActivityID		= @AtulActivityID
		AND	EndDate IS NULL;
		
		INSERT	audit.AtulActivity (
			AtulActivityID,
			AtulSubProcessID,
			ActivityDescription,
			ActivitySummary,
			ActivityProcedure,
			AtulActivitySortOrder,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate )
		SELECT	AtulActivityID,
			AtulSubProcessID ,
			ActivityDescription ,
			ActivitySummary ,
			ActivityProcedure ,
			AtulActivitySortOrder ,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now
		FROM	dbo.AtulActivity WITH (NOLOCK)
		WHERE	AtulActivityID = @AtulActivityID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariableDelete_sp
(
	@AtulConfigVariablesID	BIGINT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME
	
	SET	@now	= GETUTCDATE()
	
	BEGIN TRAN;
		UPDATE	c
		SET	c.IsActive	= CAST ( 0 AS BIT ),
			c.ModifiedDate	= @now,
			c.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulConfigVariables c 
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID;
		
		UPDATE	audit.AtulConfigVariables
		SET	EndDate		= @now
		WHERE	AtulConfigVariablesID	= @AtulConfigVariablesID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariableInsert_sp
(
	@ConfigVariableName	NVARCHAR(200),
	@ConfigVariableValue	NVARCHAR(MAX),
	@CreatedBy		BIGINT,
	@ScriptName		NVARCHAR(100)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulConfigVariablesID		INT,
		@true				BIT,
		@false				BIT,
		@active				BIT;

	SET	@now	= GETUTCDATE();
	SET	@true	= CAST (1 AS BIT);
	SET	@false	= CAST (0 AS BIT);

	SELECT	@AtulConfigVariablesID	= AtulConfigVariablesID,
		@active			= IsActive
	FROM	dbo.AtulConfigVariables c
	WHERE	c.ConfigVariableName	= @ConfigVariableName;

	IF @active = @false
	BEGIN;
	BEGIN TRAN;
		UPDATE	c
		SET	c.IsActive		= @true,
			c.ModifiedDate		= @now,
			c.ModifiedBy		= @CreatedBy,
			c.ConfigVariableValue	= @ConfigVariableValue,
			c.ScriptName		= Coalesce(@ScriptName, c.ScriptName)
		FROM	dbo.AtulConfigVariables c
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID;
		
		UPDATE	a
		SET	a.EndDate		= @now
		FROM	audit.AtulConfigVariables a
		WHERE	a.AtulConfigVariablesID = @AtulConfigVariablesID
		AND	a.EndDate IS NULL;
		
		INSERT	audit.AtulConfigVariables (
			AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			StartDate,
			ScriptName )
		SELECT	AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			@now,
			ScriptName
		FROM	dbo.AtulConfigVariables c WITH (NOLOCK)
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID;
	COMMIT TRAN;
	END;
	ELSE
	BEGIN;
	BEGIN TRAN;
		INSERT dbo.AtulConfigVariables (
			ConfigVariableName,
			ConfigVariableValue,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive,
			ScriptName )
		SELECT	@ConfigVariableName,
			@ConfigVariableValue,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@true,
			@ScriptName;
			
		SET	@AtulConfigVariablesID = SCOPE_IDENTITY();

		INSERT	audit.AtulConfigVariables (
			AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			StartDate,
			ScriptName )
		SELECT	AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			@now,
			ScriptName
		FROM	dbo.AtulConfigVariables c WITH (NOLOCK)
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID;
	COMMIT TRAN;
	END;

	SELECT	@AtulConfigVariablesID		AS AtulConfigVariablesID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariableUpdate_sp
(
	@AtulConfigVariablesID	BIGINT,
	@ConfigVariableName	NVARCHAR(200),
	@ConfigVariableValue	NVARCHAR(MAX),
	@ModifiedBy		BIGINT,
	@ScriptName		NVARCHAR(100)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	c
		SET	c.ModifiedDate		= @now,
			c.ModifiedBy		= @ModifiedBy,
			c.ConfigVariableName	= @ConfigVariableName,
			c.ConfigVariableValue	= @ConfigVariableValue,
			c.ScriptName		= Coalesce(@ScriptName, c.ScriptName)
		FROM	dbo.AtulConfigVariables c
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID;

		UPDATE	a
		SET	a.EndDate		= @now
		FROM	audit.AtulConfigVariables a
		WHERE	a.AtulConfigVariablesID = @AtulConfigVariablesID
		AND	a.EndDate IS NULL;
		
		INSERT	audit.AtulConfigVariables (
			AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			StartDate,
			ScriptName )
		SELECT	AtulConfigVariablesID,
			ConfigVariableName,
			ConfigVariableValue,
			CreatedBy,
			ModifiedBy,
			@now,
			ScriptName
		FROM	dbo.AtulConfigVariables c WITH (NOLOCK)
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariablesGetByID_sp
(
	@AtulConfigVariablesID	INT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulConfigVariablesID		AS AtulConfigVariablesID,
			ConfigVariableName		AS ConfigVariableName,
			ConfigVariableValue		AS ConfigVariableValue,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			CreatedDate			AS CreatedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			ModifiedDate			AS ModifiedDate,
			ScriptName			AS ScriptName
		FROM	dbo.AtulConfigVariables c
		JOIN	dbo.AtulUser cu ON c.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON c.ModifiedBy = mu.AtulUserID
		WHERE	c.AtulConfigVariablesID = @AtulConfigVariablesID
		AND	c.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariablesGetByName_sp
(
	@ConfigVariableName	NVARCHAR(200)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulConfigVariablesID		AS AtulConfigVariablesID,
			ConfigVariableName		AS ConfigVariableName,
			ConfigVariableValue		AS ConfigVariableValue,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			CreatedDate			AS CreatedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			ModifiedDate			AS ModifiedDate,
			ScriptName			AS ScriptName
		FROM	dbo.AtulConfigVariables c
		JOIN	dbo.AtulUser cu ON c.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON c.ModifiedBy = mu.AtulUserID
		WHERE	c.ConfigVariableName = @ConfigVariableName
		AND	c.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ConfigVariablesGetByScriptName_sp
(
	@ScriptName	NVARCHAR(200)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulConfigVariablesID		AS AtulConfigVariablesID,
			ConfigVariableName		AS ConfigVariableName,
			ConfigVariableValue		AS ConfigVariableValue,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			CreatedDate			AS CreatedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			ModifiedDate			AS ModifiedDate,
			ScriptName			AS ScriptName
		FROM	dbo.AtulConfigVariables c
		JOIN	dbo.AtulUser cu ON c.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON c.ModifiedBy = mu.AtulUserID
		WHERE	c.ScriptName = @ScriptName
		AND	c.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_DeadlineTypeDelete_sp
(
	@AtulDeadlineTypeID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulDeadlineType ag
		WHERE	ag.AtulDeadlineTypeID		= @AtulDeadlineTypeID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulDeadlineType aga
		WHERE	aga.AtulDeadlineTypeID		= @AtulDeadlineTypeID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_DeadlineTypeGetByID_sp
(
	@AtulDeadlineTypeID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	dt.AtulDeadlineTypeID,
		dt.DeadlineName,
		dt.DeadlineDescription,
		dt.CreatedDate				AS CreatedDate,
		dt.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		dt.ModifiedDate				AS ModifiedDate,
		dt.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulDeadlineType dt
	JOIN	dbo.AtulUser cu ON dt.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON dt.ModifiedBy = mu.AtulUserID
	WHERE	dt.AtulDeadlineTypeID = @AtulDeadlineTypeID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_DeadlineTypeGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	dt.AtulDeadlineTypeID,
		dt.DeadlineName,
		dt.DeadlineDescription,
		dt.CreatedDate				AS CreatedDate,
		dt.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		dt.ModifiedDate				AS ModifiedDate,
		dt.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulDeadlineType dt
	JOIN	dbo.AtulUser cu ON dt.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON dt.ModifiedBy = mu.AtulUserID
	WHERE	dt.IsActive	= CAST(1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_DeadlineTypeInsert_sp
(
	@DeadlineName		NVARCHAR(150),
	@DeadlineDescription	NVARCHAR(256),
	@CreatedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulDeadlineTypeID		BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulDeadlineType (
			DeadlineName,
			DeadlineDescription,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@DeadlineName,
			@DeadlineDescription,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulDeadlineTypeID = SCOPE_IDENTITY();

		INSERT	audit.AtulDeadlineType (
			AtulDeadlineTypeID,
			DeadlineName,
			DeadlineDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulDeadlineTypeID,
			DeadlineName,
			DeadlineDescription,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulDeadlineType WITH (NOLOCK)
		WHERE	AtulDeadlineTypeID = @AtulDeadlineTypeID;
	COMMIT TRAN;

	SELECT	@AtulDeadlineTypeID		AS AtulDeadlineTypeID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_DeadlineTypeUpdate_sp
(
	@AtulDeadlineTypeID	BIGINT,
	@DeadlineName		NVARCHAR(150),
	@DeadlineDescription	NVARCHAR(256),
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	adt
		SET	DeadlineName		= @DeadlineName,
			DeadlineDescription	= @DeadlineDescription,
			ModifiedDate		= @now,
			ModifiedBy		= @ModifiedBy
		FROM	dbo.AtulDeadlineType adt WITH (ROWLOCK)
		WHERE	adt.AtulDeadlineTypeID	= @AtulDeadlineTypeID;

		UPDATE	aadt
		SET	aadt.EndDate		= @now
		FROM	audit.AtulDeadlineType aadt WITH (ROWLOCK)
		WHERE	aadt.AtulDeadlineTypeID	= @AtulDeadlineTypeID
		AND	aadt.EndDate	IS NULL;

		INSERT	audit.AtulDeadlineType (
			AtulDeadlineTypeID,
			DeadlineName,
			DeadlineDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulDeadlineTypeID,
			DeadlineName,
			DeadlineDescription,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulDeadlineType WITH (NOLOCK)
		WHERE	AtulDeadlineTypeID = @AtulDeadlineTypeID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldDelete_sp
(
	@AtulFlexFieldID	BIGINT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME
	
	SET	@now	= GETUTCDATE()
	
	BEGIN TRAN;
		UPDATE	f
		SET	f.IsActive	= CAST ( 0 AS BIT ),
			f.ModifiedDate	= @now,
			f.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulFlexField f 
		WHERE	f.AtulFlexFieldID = @AtulFlexFieldID;
		
		UPDATE	audit.AtulFlexField
		SET	EndDate		= @now
		WHERE	AtulFlexFieldID = @AtulFlexFieldID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldGetByID_sp
(
	@AtulFlexFieldID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulFlexFieldID			AS AtulFlexFieldID,
			TokenName			AS TokenName,
			IsRequired			AS IsRequired,
			CreatedDate			AS CreatedDate,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			ModifiedDate			AS ModifiedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			AtulProcessID			AS AtulProcessID,
			AtulSubProcessID		AS AtulSubProcessID,
			AtulActivityID			AS AtulActivityID,
			DefaultTokenValue		AS DefaultTokenValue,
			FriendlyName			AS FriendlyName,
			ToolTip					AS ToolTip,
			IsParameter				AS IsParameter
		FROM	dbo.AtulFlexField f
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.AtulFlexFieldID = @AtulFlexFieldID
		AND	f.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldGetByInstanceProcessID_sp
(
	@AtulInstanceProcessID BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE @process AS TABLE (
		AtulProcessID		BIGINT );
	
	DECLARE @subprocess AS TABLE (
		AtulSubProcessID	BIGINT );

	DECLARE @activity AS TABLE (
		AtulActivityID		BIGINT );

	DECLARE	@true	BIT;
	
	SET	@true	= CAST (1 AS BIT);

	INSERT	@process (
		AtulProcessID )
	SELECT	DISTINCT
		AtulProcessID
	FROM	dbo.AtulInstanceProcess ip
	WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	ip.IsActive = @true;

	INSERT	@activity (
		AtulActivityID )
	SELECT	DISTINCT
		pa.AtulActivityID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulInstanceProcessActivity ipa ON ip.AtulInstanceProcessID = ipa.AtulInstanceProcessID
				AND ipa.IsActive = @true
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
				AND pa.IsActive = @true
	WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	ip.IsActive = @true;

	INSERT	@subprocess (
		AtulSubProcessID )
	SELECT	DISTINCT
		psp.AtulSubProcessID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulInstanceProcessSubProcess ipsp ON ip.AtulInstanceProcessID = ipsp.AtulInstanceProcessID
				AND ipsp.IsActive = @true
	JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
				AND psp.IsActive = @true
	WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	ip.IsActive = @true;

	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@process p
	JOIN	dbo.AtulFlexField ff ON p.AtulProcessID = ff.AtulProcessID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID

	UNION
		
	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@activity a
	JOIN	dbo.AtulFlexField ff ON a.AtulActivityID = ff.AtulActivityID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID

	UNION
		
	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@subprocess s
	JOIN	dbo.AtulFlexField ff ON s.AtulSubProcessID = ff.AtulSubProcessID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldGetByProcessID_sp
(
	@AtulProcessID BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE @process AS TABLE (
		AtulProcessID		BIGINT );
	
	DECLARE @subprocess AS TABLE (
		AtulSubProcessID	BIGINT );

	DECLARE @activity AS TABLE (
		AtulActivityID		BIGINT );

	DECLARE	@true	BIT;
	
	SET	@true	= CAST (1 AS BIT);

	INSERT	@process (
		AtulProcessID )
	SELECT	DISTINCT
		AtulProcessID
	FROM	dbo.AtulInstanceProcess ip
	WHERE	ip.AtulInstanceProcessID = @AtulProcessID
	AND	ip.IsActive = @true;

	INSERT	@activity (
		AtulActivityID )
	SELECT	DISTINCT
		pa.AtulActivityID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulInstanceProcessActivity ipa ON ip.AtulInstanceProcessID = ipa.AtulInstanceProcessID
				AND ipa.IsActive = @true
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
				AND pa.IsActive = @true
	WHERE	ip.AtulProcessID = @AtulProcessID
	AND	ip.IsActive = @true;

	INSERT	@subprocess (
		AtulSubProcessID )
	SELECT	DISTINCT
		psp.AtulSubProcessID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulInstanceProcessSubProcess ipsp ON ip.AtulInstanceProcessID = ipsp.AtulInstanceProcessID
				AND ipsp.IsActive = @true
	JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
				AND psp.IsActive = @true
	WHERE	ip.AtulProcessID = @AtulProcessID
	AND	ip.IsActive = @true;

	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@process p
	JOIN	dbo.AtulFlexField ff ON p.AtulProcessID = ff.AtulProcessID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID

	UNION
		
	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@activity a
	JOIN	dbo.AtulFlexField ff ON a.AtulActivityID = ff.AtulActivityID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID

	UNION
		
	SELECT	ff.AtulFlexFieldID		AS AtulFlexFieldID,
		ff.TokenName			AS TokenName,
		ff.IsRequired			AS IsRequired,
	        ff.CreatedDate			AS CreatedDate,
	        ff.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
	        ff.ModifiedDate			AS ModifiedDate,
	        ff.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
	        ff.AtulProcessID		AS AtulProcessID,
	        ff.AtulSubProcessID		AS AtulSubProcessID,
	        ff.AtulActivityID		AS AtulActivityID,
	        ff.DefaultTokenValue		AS DefaultTokenValue,
	        ff.FriendlyName			AS FriendlyName,
	        ff.ToolTip			AS ToolTip,
	        ff.IsParameter			AS IsParameter
	FROM	@subprocess s
	JOIN	dbo.AtulFlexField ff ON s.AtulSubProcessID = ff.AtulSubProcessID
					AND	ff.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ff.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ff.ModifiedBy = mu.AtulUserID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldGetBySearch_sp
(
	@AtulProcessID		BIGINT = NULL,
	@AtulSubProcessID	BIGINT = NULL,
	@AtulActivityID		BIGINT = NULL
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulFlexFieldID			AS AtulFlexFieldID,
			TokenName			AS TokenName,
			IsRequired			AS IsRequired,
			CreatedDate			AS CreatedDate,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			ModifiedDate			AS ModifiedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			AtulProcessID			AS AtulProcessID,
			AtulSubProcessID		AS AtulSubProcessID,
			AtulActivityID			AS AtulActivityID,
			DefaultTokenValue		AS DefaultTokenValue,
			FriendlyName			AS FriendlyName,
			ToolTip					AS ToolTip,
			IsParameter				AS IsParameter
		FROM	dbo.AtulFlexField f
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.IsActive = CAST (1 AS BIT)
		AND	(@AtulProcessID IS NULL OR f.AtulProcessID = @AtulProcessID)
		AND	(@AtulSubProcessID IS NULL OR f.AtulSubProcessID = @AtulSubProcessID)
		AND	(@AtulActivityID IS NULL OR f.AtulActivityID = @AtulActivityID);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	AtulFlexFieldID			AS AtulFlexFieldID,
			TokenName			AS TokenName,
			IsRequired			AS IsRequired,
			CreatedDate			AS CreatedDate,
			CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			ModifiedDate			AS ModifiedDate,
			ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName,
			AtulProcessID			AS AtulProcessID,
			AtulSubProcessID		AS AtulSubProcessID,
			AtulActivityID			AS AtulActivityID,
			DefaultTokenValue		AS DefaultTokenValue,
			FriendlyName			AS FriendlyName,
			ToolTip					AS ToolTip,
			IsParameter				AS IsParameter
		FROM	dbo.AtulFlexField f
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageDelete_sp
(
	@AtulFlexFieldStorageID	BIGINT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME
	
	SET	@now	= GETUTCDATE()
	
	BEGIN TRAN;
		UPDATE	f
		SET	f.IsActive	= CAST ( 0 AS BIT ),
			f.ModifiedDate	= @now,
			f.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulFlexFieldStorage f 
		WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID;
		
		UPDATE	audit.AtulFlexFieldStorage
		SET	EndDate		= @now
		WHERE	AtulFlexFieldStorageID = @AtulFlexFieldStorageID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageGetByID_sp
(
	@AtulFlexFieldStorageID BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	f.AtulFlexFieldStorageID	AS AtulFlexFieldStorageID,
			f.AtulInstanceProcessID		AS AtulInstanceProcessID,
			f.AtulFlexFieldID		AS AtulFlexFieldID,
			ff.AtulActivityID		AS AtulActivityID,
			ff.AtulProcessID		AS AtulProcessID,
			ff.AtulSubProcessID		AS AtulSubProcessID,
			ff.IsRequired			AS IsRequired,
			f.TokenValue			AS TokenValue,
			f.CreatedDate			AS CreatedDate,
			f.CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			f.ModifiedDate			AS ModifiedDate,
			f.ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName
		FROM	dbo.AtulFlexFieldStorage f
		JOIN	dbo.AtulFlexField ff ON f.AtulFlexFieldID = ff.AtulFlexFieldID
					AND ff.IsActive = CAST (1 AS BIT)
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID
		AND	f.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageGetByProcessID_sp
(
	@AtulInstanceProcessID BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	f.AtulFlexFieldStorageID	AS AtulFlexFieldStorageID,
			f.AtulInstanceProcessID		AS AtulInstanceProcessID,
			f.AtulFlexFieldID		AS AtulFlexFieldID,
			ff.TokenName			AS TokenName,
			ff.AtulActivityID		AS AtulActivityID,
			ff.AtulProcessID		AS AtulProcessID,
			ff.AtulSubProcessID		AS AtulSubProcessID,
			ff.IsRequired			AS IsRequired,
			f.TokenValue			AS TokenValue,
			f.CreatedDate			AS CreatedDate,
			f.CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			f.ModifiedDate			AS ModifiedDate,
			f.ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName
		FROM	dbo.AtulFlexFieldStorage f
		JOIN	dbo.AtulFlexField ff ON f.AtulFlexFieldID = ff.AtulFlexFieldID
					AND ff.IsActive = CAST (1 AS BIT)
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.AtulInstanceProcessID = @AtulInstanceProcessID
		AND	f.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
		SELECT	f.AtulFlexFieldStorageID	AS AtulFlexFieldStorageID,
			f.AtulInstanceProcessID		AS AtulInstanceProcessID,
			f.AtulFlexFieldID		AS AtulFlexFieldID,
			ff.AtulActivityID		AS AtulActivityID,
			ff.AtulProcessID		AS AtulProcessID,
			ff.AtulSubProcessID		AS AtulSubProcessID,
			ff.IsRequired			AS IsRequired,
			f.TokenValue			AS TokenValue,
			f.CreatedDate			AS CreatedDate,
			f.CreatedBy			AS CreatedBy,
			cu.DisplayName			AS CreatedByName,
			f.ModifiedDate			AS ModifiedDate,
			f.ModifiedBy			AS ModifiedBy,
			mu.DisplayName			AS ModifiedByName
		FROM	dbo.AtulFlexFieldStorage f
		JOIN	dbo.AtulFlexField ff ON f.AtulFlexFieldID = ff.AtulFlexFieldID
					AND ff.IsActive = CAST (1 AS BIT)
		JOIN	dbo.AtulUser cu ON f.CreatedBy = cu.AtulUserID
		JOIN	dbo.AtulUser mu ON f.ModifiedBy = mu.AtulUserID
		WHERE	f.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageInsert_sp
(
	@AtulInstanceProcessID	BIGINT,
	@AtulFlexFieldID	BIGINT,
	@TokenValue		NVARCHAR(MAX),
	@CreatedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulFlexFieldStorageID		BIGINT,
		@true				BIT,
		@false				BIT,
		@active				BIT;

	SET	@now	= GETUTCDATE();
	SET	@true	= CAST (1 AS BIT);
	SET	@false	= CAST (0 AS BIT);
	
	SELECT	@AtulFlexFieldStorageID = f.AtulFlexFieldStorageID
	FROM	dbo.AtulFlexFieldStorage f
	WHERE	AtulInstanceProcessID = @AtulInstanceProcessID
	AND	AtulFlexFieldID = @AtulFlexFieldID

	IF (@AtulFlexFieldStorageID IS NOT NULL)
	BEGIN;
		UPDATE	f
		SET	f.TokenValue		= @TokenValue,
			f.ModifiedBy		= @CreatedBy,
			f.ModifiedDate		= @now,
			f.IsActive		= @true
		FROM	dbo.AtulFlexFieldStorage f
		WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID;

		UPDATE	audit.AtulFlexFieldStorage
		SET	EndDate		= @now
		WHERE	AtulFlexFieldStorageID = @AtulFlexFieldStorageID
		AND	EndDate IS NULL;
	END;
	ELSE
	BEGIN;
		INSERT	dbo.AtulFlexFieldStorage ( 
			AtulInstanceProcessID,
			AtulFlexFieldID,
			TokenValue,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulInstanceProcessID,
			@AtulFlexFieldID,
			@TokenValue,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@true;

		SET	@AtulFlexFieldStorageID = SCOPE_IDENTITY();
	END;

	INSERT	audit.AtulFlexFieldStorage (
		AtulFlexFieldStorageID,
		AtulInstanceProcessID,
		AtulFlexFieldID,
		TokenValue,
		CreatedBy,
		ModifiedBy,
		StartDate )
	SELECT	AtulFlexFieldStorageID,
		AtulInstanceProcessID,
		AtulFlexFieldID,
		TokenValue,
		CreatedBy,
		ModifiedBy,
		@now
	FROM	dbo.AtulFlexFieldStorage f WITH (NOLOCK)
	WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID;

	SELECT	@AtulFlexFieldStorageID		AS AtulFlexFieldStorageID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldStorageUpdate_sp
(
	@AtulFlexFieldStorageID	BIGINT,
	@AtulInstanceProcessID	BIGINT,
	@AtulFlexFieldID	BIGINT,
	@TokenValue		NVARCHAR(MAX),
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	f
		SET	f.AtulInstanceProcessID	= @AtulInstanceProcessID,
			f.AtulFlexFieldID	= @AtulFlexFieldID,
			f.TokenValue		= @TokenValue,
			f.ModifiedBy		= @ModifiedBy,
			f.ModifiedDate		= @now
		FROM	dbo.AtulFlexFieldStorage f
		WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID;

		UPDATE	audit.AtulFlexFieldStorage
		SET	EndDate		= @now
		WHERE	AtulFlexFieldStorageID = @AtulFlexFieldStorageID
		AND	EndDate IS NULL;
		
		INSERT	audit.AtulFlexFieldStorage (
			AtulFlexFieldStorageID,
			AtulInstanceProcessID,
			AtulFlexFieldID,
			TokenValue,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulFlexFieldStorageID,
			AtulInstanceProcessID,
			AtulFlexFieldID,
			TokenValue,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulFlexFieldStorage f WITH (NOLOCK)
		WHERE	f.AtulFlexFieldStorageID = @AtulFlexFieldStorageID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_FlexFieldUpsert_sp
(
	@TokenName		NVARCHAR(200),
	@IsRequired		BIT,
	@CreatedBy		BIGINT,
	@AtulProcessID		BIGINT= NULL,
	@AtulSubProcessID	BIGINT= NULL,
	@AtulActivityID		BIGINT= NULL,
	@DefaultTokenValue	NVARCHAR(MAX) = NULL,
	@FriendlyName		NVARCHAR(100) = NULL,
	@ToolTip			NVARCHAR(MAX) = NULL,
	@IsParameter		BIT = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	--Error check to make sure that one of processes was passed in
	IF @AtulProcessID IS NULL AND @AtulSubProcessID IS NULL AND @AtulActivityID IS NULL	
	BEGIN;
	
		RAISERROR ('No proccess, subprocess or activity ID was provided. No updates were made.', 15, -1) WITH NOWAIT;
		
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;			
	
	END;
	
	IF CASE WHEN @AtulProcessID IS NOT NULL THEN 1 ELSE 0 END  + 
		CASE WHEN @AtulSubProcessID IS NOT NULL THEN 1 ELSE 0 END + 
		CASE WHEN @AtulActivityID IS NOT NULL THEN 1 ELSE 0 END <> 1
	BEGIN;
	
		RAISERROR ('More than one proccess, subprocess or activity ID was provided. No updates were made.', 15, -1) WITH NOWAIT;
	
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;		
	
	END;

	DECLARE	@now				DATETIME,
		@AtulFlexFieldID		BIGINT,
		@true				BIT,
		@false				BIT,
		@active				BIT,
		@rc					INT;

	SET	@now	= GETUTCDATE();
	SET	@true	= CAST (1 AS BIT);
	SET	@false	= CAST (0 AS BIT);
	
	DECLARE @updates AS TABLE
	(AtulFlexFieldID BIGINT);	
	
	
	
	UPDATE	f
		SET	f.TokenName		= @TokenName,
			f.IsRequired		= @IsRequired,
			f.ModifiedBy		= @CreatedBy,
			f.ModifiedDate		= @now,
			f.AtulProcessID		= @AtulProcessID,
			f.AtulSubProcessID	= @AtulSubProcessID,
			f.AtulActivityID	= @AtulActivityID,
			f.DefaultTokenValue	= COALESCE(@DefaultTokenValue, f.DefaultTokenValue),
			f.FriendlyName		= COALESCE(@FriendlyName, f.FriendlyName),
			f.ToolTip			= COALESCE(@ToolTip, f.ToolTip),
			f.IsParameter		= COALESCE(@IsParameter, f.IsParameter)
		OUTPUT INSERTED.AtulFlexFieldID 
		INTO @updates
		FROM	dbo.AtulFlexField f
		WHERE	f.TokenName = @TokenName
				AND 
					(f.AtulProcessID = @AtulProcessID
					OR f.AtulSubProcessID = @AtulSubProcessID
					OR f.AtulActivityID = @AtulActivityID)
				AND f.IsActive = 1;

		SELECT @rc = @@ROWCOUNT;
		
		IF @rc > 0
		BEGIN -- If rows were updated, log the changes

			UPDATE	a
			SET	EndDate		= @now
			FROM audit.AtulFlexField a
				INNER JOIN @updates u
					ON a.AtulFlexFieldID = u.AtulFlexFieldID
			WHERE EndDate IS NULL;	
		
			INSERT	audit.AtulFlexField (
				AtulFlexFieldID,
				TokenName,
				IsRequired,
				CreatedBy,
				ModifiedBy,
				StartDate,
				AtulProcessID,
				AtulSubProcessID,
				AtulActivityID,
				DefaultTokenValue,
				FriendlyName,
				ToolTip,
				IsParameter )
			SELECT	f.AtulFlexFieldID,
				TokenName,
				IsRequired,
				CreatedBy,
				ModifiedBy,
				@now,
				AtulProcessID,
				AtulSubProcessID,
				AtulActivityID,
				DefaultTokenValue,
				FriendlyName,
				ToolTip,
				IsParameter
			FROM	dbo.AtulFlexField f WITH (NOLOCK)
				INNER JOIN @updates u
					ON f.AtulFlexFieldID = u.AtulFlexFieldID;
		END 
		ELSE
		BEGIN --rows were not updated, insert the field
		
			INSERT	dbo.AtulFlexField (
				TokenName,
				IsRequired,
				CreatedDate,
				CreatedBy,
				ModifiedDate,
				ModifiedBy,
				IsActive,
				AtulProcessID,
				AtulSubProcessID,
				AtulActivityID,
				DefaultTokenValue,
				FriendlyName,
				ToolTip,
				IsParameter )
			SELECT	@TokenName,
				@IsRequired,
				@now,
				@CreatedBy,
				@now,
				@CreatedBy,
				@true,
				@AtulProcessID,
				@AtulSubProcessID,
				@AtulActivityID,
				@DefaultTokenValue,
				@FriendlyName,
				@ToolTip,
				@IsParameter;

			SET	@AtulFlexFieldID = SCOPE_IDENTITY();

			INSERT	audit.AtulFlexField (
				AtulFlexFieldID,
				TokenName,
				IsRequired,
				CreatedBy,
				ModifiedBy,
				StartDate,
				AtulProcessID,
				AtulSubProcessID,
				AtulActivityID,
				DefaultTokenValue,
				FriendlyName,
				ToolTip,
				IsParameter  )
			SELECT	AtulFlexFieldID,
				TokenName,
				IsRequired,
				CreatedBy,
				ModifiedBy,
				@now,
				AtulProcessID,
				AtulSubProcessID,
				AtulActivityID,
				DefaultTokenValue,
				FriendlyName,
				ToolTip,
				IsParameter 
			FROM	dbo.AtulFlexField f WITH (NOLOCK)
			WHERE	f.AtulFlexFieldID = @AtulFlexFieldID;

	END

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_GetCurrentInstanceSubProcess_sp
(
	@AtulInstanceProcessID		BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE	@true		BIT,
		@ranking	INT;
	
	SET	@true	= CAST (1 AS BIT);

	DECLARE	@holding AS TABLE (
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT );

	DECLARE	@return AS TABLE (
		Ranking				INT IDENTITY (1,1),
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT );

	INSERT	@holding (
		AtulInstanceProcessSubProcessID,
		AtulInstanceProcessID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed )
	SELECT	DISTINCT
		ipsp.AtulInstanceProcessSubProcessID		AS AtulInstanceProcessSubProcessID,
	        ipsp.AtulInstanceProcessID			AS AtulInstanceProcessID,
	        ipsp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
	        p.AtulProcessID					AS AtulProcessID,
		psp.AtulSubProcessID				AS AtulSubProcessID,
		psp.ProcessSubprocessSortOrder			AS SubProcessSortOrder,
		0						AS ProcessActivitySortOrder,
	        ipsp.InstanceProcessSubProcessCompleted		AS Completed
	FROM	dbo.AtulInstanceProcessSubProcess ipsp
	JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
					AND psp.IsActive = @true
	JOIN	dbo.AtulProcess p ON psp.AtulProcessID = p.AtulProcessID
					AND p.IsActive = @true
	JOIN	dbo.AtulInstanceProcess ip ON ipsp.AtulInstanceProcessID = ip.AtulInstanceProcessID
					AND ip.IsActive = @true
	JOIN	dbo.AtulSubProcess sp ON psp.AtulSubProcessID = sp.AtulSubProcessID
					AND sp.IsActive = @true
	WHERE	ipsp.AtulInstanceProcessID	= @AtulInstanceProcessID
	AND	ipsp.IsActive			= @true;

	INSERT	@holding (
 		AtulInstanceProcessID,
 		AtulInstanceProcessActivityID,
 		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed
		)
	SELECT	ipa.AtulInstanceProcessID			AS AtulInstanceProcessID,
		ipa.AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID,
		ipa.AtulProcessActivityID			AS AtulProcessActivityID,
		psp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
		pa.AtulProcessID				AS AtulProcessID,
		a.AtulSubProcessID				AS AtulSubProcessID,
		psp.ProcessSubprocessSortOrder			AS ProcessSubprocessSortOrder,
		pa.ProcessActivitySortOrder			AS ProcessActivitySortOrder,
		ipa.InstanceProcessActivityCompleted		AS InstanceProcessActivityCompleted
	FROM	dbo.AtulInstanceProcessActivity ipa
	JOIN	dbo.AtulInstanceProcess ip ON ipa.AtulInstanceProcessID = ip.AtulInstanceProcessID
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
	JOIN	dbo.AtulActivity a ON pa.AtulActivityID = a.AtulActivityID
					AND a.IsActive = @true
	JOIN	dbo.AtulSubProcess sp ON a.AtulSubProcessID = sp.AtulSubProcessID
 					AND sp.IsActive = @true
 	JOIN	dbo.AtulProcessSubprocess psp ON psp.AtulSubProcessID = sp.AtulSubProcessID
 					AND psp.AtulProcessID = pa.AtulProcessID
 					AND psp.IsActive = @true
	WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID;

	INSERT	@return (
		AtulInstanceProcessSubProcessID,
		AtulInstanceProcessActivityID,
		AtulInstanceProcessID,
		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed)
	SELECT	AtulInstanceProcessSubProcessID,
		AtulInstanceProcessActivityID,
		AtulInstanceProcessID,
		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed
	FROM	@holding
	ORDER BY SubProcessSortOrder, ProcessActivitySortOrder;

	SELECT	@ranking = MIN(Ranking)
	FROM	@return
	WHERE	Completed = 0;

	SELECT	DISTINCT
		r.AtulInstanceProcessSubProcessID,
		r.AtulSubProcessID,
		r.AtulProcessSubprocessID,
		i.AtulInstanceProcessSubProcessInteractionID
	FROM	@return r
	LEFT JOIN	dbo.AtulInstanceProcessSubProcessInteraction i ON r.AtulProcessSubprocessID = i.AtulProcessSubProcessID
					AND i.AtulInstanceProcessID = @AtulInstanceProcessID
					AND i.IsActive = @true
	WHERE	Ranking = @ranking;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_GetInstanceProcessActivities_GetByID
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ipa.AtulInstanceProcessActivityID,
		ipa.AtulInstanceProcessID,
		ipa.AtulProcessActivityID,
		ipa.InstanceProcessActivityDeadline,
		ipa.InstanceProcessActivityCompleted,
		ipa.InstanceProcessActivityDidNotApply,
		ipa.InstanceProcessActivityDeadlineMissed,
		ipa.InstanceProcessActivityCompletedBy,
		pa.AutomationExpectedDuration,
		pa.AutomationIdentifier,
		pa.AutomationServiceProviderID,
		pa.AutomationTriggerActivityGroupID,
		pa.DeadlineActivityGroupID		AS ProcessActivityDeadlineActivityGroupID,
		pa.AtulDeadlineTypeID			AS ProcessActivityDeadlineTypeID,
		pa.DeadlineOffset			AS ProcessActivityDeadlineOffset,
		pa.DeadlineResultsInMissed		AS ProcessActivityDeadlineResultsInMissed,
		a.ActivityDescription,
		a.ActivityProcedure,
		a.ActivitySummary,
		a.AtulActivitySortOrder,
		a.AtulSubProcessID,
		cb.DisplayName				AS InstanceProcessActivityCompletedByName,
		ipa.CreatedDate,
		ipa.CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ipa.ModifiedDate,
		ipa.ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulInstanceProcessActivity ipa
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
					AND pa.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulActivity a ON pa.AtulActivityID = a.AtulActivityID
					AND a.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser cu ON ipa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ipa.ModifiedBy = mu.AtulUserID
	LEFT JOIN	dbo.AtulUser cb ON ipa.InstanceProcessActivityCompletedBy = cb.AtulUserID
	WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	ipa.IsActive = CAST(1 AS BIT)
	ORDER BY a.AtulSubProcessID ASC, a.AtulActivitySortOrder ASC;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_GetInstanceProcessSubProcess_GetByID
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE	@true	AS BIT;
	
	SET	@true	= CAST (1 AS BIT);
	
	SELECT	isp.AtulInstanceProcessSubProcessID		AS AtulInstanceProcessSubProcessID,
	        isp.AtulInstanceProcessID			AS AtulInstanceProcessID,
	        isp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
	        sp.AtulSubProcessID				AS AtulSubProcessID,
	        sp.ProcessSubprocessSortOrder			AS ProcessSubprocessSortOrder,
	        sp.NotificationIdentifier			AS NotificationIdentifier,
	        sp.NotificationServiceProviderID		AS NotificationServiceProviderID,
	        sp.ResponsibilityOf				AS ResponsibilityOf,
	        ru.DisplayName					AS ResponsibilityOfName,
	        isp.InstanceProcessSubProcessCompleted		AS InstanceProcessSubProcessCompleted,
	        isp.InstanceProcessSubProcessDidNotApply	AS InstanceProcessSubProcessDidNotApply,
	        isp.InstanceProcessSubProcessDeadlineMissed	AS InstanceProcessSubProcessDeadlineMissed,
	        isp.InstanceProcessSubProcessCompletedBy	AS InstanceProcessSubProcessCompletedBy,
		cb.DisplayName					AS InstanceProcessActivityCompletedByName,
	        isp.CreatedDate					AS CreatedDate,
	        isp.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
	        isp.ModifiedDate				AS ModifiedDate,
	        isp.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName
	FROM	dbo.AtulInstanceProcessSubProcess isp
	JOIN	dbo.AtulInstanceProcess ip ON isp.AtulInstanceProcessID = ip.AtulInstanceProcessID
					AND ip.IsActive = @true
	JOIN	dbo.AtulProcessSubprocess sp ON sp.AtulProcessSubprocessID = isp.AtulProcessSubprocessID
					AND sp.AtulProcessID = ip.AtulProcessID
					AND sp.IsActive = @true
	JOIN	dbo.AtulUser cu ON isp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON isp.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ru ON sp.ResponsibilityOf = ru.AtulUserID
	LEFT JOIN	dbo.AtulUser cb ON isp.InstanceProcessSubProcessCompletedBy = cb.AtulUserID
	WHERE	isp.AtulInstanceProcessID	= @AtulInstanceProcessID
	AND	isp.IsActive			= @true
	ORDER BY sp.ProcessSubprocessSortOrder;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_GetProviderInfoBySubProcessID_sp
(
	@AtulInstanceProcessSubProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE	@true	BIT,
		@false	BIT;
	
	SET	@true	= CAST(1 AS BIT);
	SET	@false	= CAST(0 AS BIT);

	SELECT	sp.AtulInstanceProcessID,
		sp.AtulInstanceProcessSubProcessID,
		sp.AtulProcessSubprocessID,
		psp.NotificationServiceProviderID,
		p.ESBQueue,
		p.ServiceProviderDescription,
		p.ServiceProviderName,
		p.ServiceProviderXML
	FROM	dbo.AtulInstanceProcessSubProcess sp
	JOIN	dbo.AtulProcessSubprocess psp ON sp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
				AND psp.IsActive = @true
	JOIN	dbo.AtulServiceProvider p ON psp.NotificationServiceProviderID = p.AtulServiceProviderID
				AND p.IsActive = @true
	WHERE	sp.AtulInstanceProcessSubProcessID = @AtulInstanceProcessSubProcessID
	AND	sp.IsActive = @true
	AND	sp.InstanceProcessSubProcessCompleted = @false;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityCompleteUpdate_sp
(
	@AtulInstanceProcessActivityID		BIGINT,
	@statusBit				INT,
	@ModifiedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY;
	
	DECLARE @outputSubProcess AS TABLE (
		AtulInstanceProcessSubProcessID	BIGINT
		)

	DECLARE	@holding AS TABLE (
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT,
		NA				BIT );

	DECLARE	@return AS TABLE (
		Ranking				INT IDENTITY (1,1),
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT,
		NA				BIT );

	DECLARE	@now				DATETIME,
		@deadlinedate			DATETIME,
		@true				BIT,
		@false				BIT,
		@misseddeadline			BIT,
		@notapply			BIT,
		@completed			BIT,
		@AtulInstanceProcessID		BIGINT,
		@AtulProcessSubprocessID	BIGINT,
		@ProcessComplete		INT,
		@ProcessMissedDeadline		INT;

	SET	@now			= GETUTCDATE();
	SET	@true			= CAST (1 AS BIT);
	SET	@false			= CAST (0 AS BIT);
	SET	@completed		= @false;
	SET	@misseddeadline		= @false;
	SET	@notapply		= @false;
	SET	@ProcessComplete	= @false;
	SET	@ProcessMissedDeadline	= @false;

	SELECT	@deadlinedate		= COALESCE(ipa.InstanceProcessActivityDeadline, '12/31/9999 00:00:00'),
		@AtulInstanceProcessID	= ipa.AtulInstanceProcessID
	FROM	dbo.AtulInstanceProcessActivity ipa WITH (NOLOCK)
	WHERE	ipa.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;
	
	IF (@now <= @deadlinedate )
	BEGIN;
		SET @misseddeadline = 0;
	END;
	ELSE
	BEGIN;
		SET @misseddeadline = 1;
	END;

	IF (@statusBit = 1 )
	BEGIN;
		SET @completed		= @true;
	END;
	ELSE IF (@statusBit = 2 )
	BEGIN;
		SET @completed		= @true;
		SET @notapply		= @true;
	END;

	BEGIN TRAN;
		UPDATE	ipa
		SET	InstanceProcessActivityCompleted	= @completed,
			InstanceProcessActivityDidNotApply	= @notapply,
			InstanceProcessActivityDeadlineMissed	= @misseddeadline,
			InstanceProcessActivityCompletedBy	= @ModifiedBy,
			ModifiedDate				= @now,
			ModifiedBy				= @ModifiedBy
		FROM	dbo.AtulInstanceProcessActivity ipa WITH (ROWLOCK)
		WHERE	ipa.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;

		UPDATE	aipa
		SET	aipa.EndDate				= @now
		FROM	audit.AtulInstanceProcessActivity aipa WITH (ROWLOCK)
		WHERE	aipa.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID
		AND	aipa.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessActivity (
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			CreatedBy,
			ModifiedBy,
		        @now
		FROM	dbo.AtulInstanceProcessActivity WITH (NOLOCK)
		WHERE	AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;

		-- Mark the Instance Sub process if the activity just completed finished up the sub process.
		--  FIRST:  Gather the info.
		--   SubProcesses
		INSERT	@holding (
			AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			SubProcessSortOrder,
			ProcessActivitySortOrder,
			Completed )
		SELECT	DISTINCT
			ipsp.AtulInstanceProcessSubProcessID		AS AtulInstanceProcessSubProcessID,
	        	ipsp.AtulInstanceProcessID			AS AtulInstanceProcessID,
		        ipsp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
		        p.AtulProcessID					AS AtulProcessID,
			psp.AtulSubProcessID				AS AtulSubProcessID,
			psp.ProcessSubprocessSortOrder			AS SubProcessSortOrder,
			0						AS ProcessActivitySortOrder,
	        	ipsp.InstanceProcessSubProcessCompleted		AS Completed
		FROM	dbo.AtulInstanceProcessSubProcess ipsp
		JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
						AND psp.IsActive = @true
		JOIN	dbo.AtulProcess p ON psp.AtulProcessID = p.AtulProcessID
						AND p.IsActive = @true
		JOIN	dbo.AtulInstanceProcess ip ON ipsp.AtulInstanceProcessID = ip.AtulInstanceProcessID
						AND ip.IsActive = @true
		JOIN	dbo.AtulSubProcess sp ON psp.AtulSubProcessID = sp.AtulSubProcessID
						AND sp.IsActive = @true
		WHERE	ipsp.AtulInstanceProcessID	= @AtulInstanceProcessID
		AND	ipsp.IsActive			= @true;

		--  Activities
		INSERT	@holding (
 			AtulInstanceProcessID,
	 		AtulInstanceProcessActivityID,
 			AtulProcessActivityID,
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			SubProcessSortOrder,
			ProcessActivitySortOrder,
			Completed,
			NA
			)
		SELECT	ipa.AtulInstanceProcessID			AS AtulInstanceProcessID,
			ipa.AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID,
			ipa.AtulProcessActivityID			AS AtulProcessActivityID,
			psp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
			pa.AtulProcessID				AS AtulProcessID,
			a.AtulSubProcessID				AS AtulSubProcessID,
			psp.ProcessSubprocessSortOrder			AS ProcessSubprocessSortOrder,
			pa.ProcessActivitySortOrder			AS ProcessActivitySortOrder,
			ipa.InstanceProcessActivityCompleted		AS InstanceProcessActivityCompleted,
			ipa.InstanceProcessActivityDidNotApply		AS InstanceProcessActivityDidNotApply
		FROM	dbo.AtulInstanceProcessActivity ipa
		JOIN	dbo.AtulInstanceProcess ip ON ipa.AtulInstanceProcessID = ip.AtulInstanceProcessID
		JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
		JOIN	dbo.AtulActivity a ON pa.AtulActivityID = a.AtulActivityID
						AND a.IsActive = @true
		JOIN	dbo.AtulSubProcess sp ON a.AtulSubProcessID = sp.AtulSubProcessID
 						AND sp.IsActive = @true
	 	JOIN	dbo.AtulProcessSubprocess psp ON psp.AtulSubProcessID = sp.AtulSubProcessID
 						AND psp.AtulProcessID = pa.AtulProcessID
 						AND psp.IsActive = @true
		WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID;

		INSERT	@return (
			AtulInstanceProcessSubProcessID,
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			SubProcessSortOrder,
			ProcessActivitySortOrder,
			Completed,
			NA)
		SELECT	AtulInstanceProcessSubProcessID,
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			SubProcessSortOrder,
			ProcessActivitySortOrder,
			Completed,
			NA
		FROM	@holding
		ORDER BY AtulSubProcessID, ProcessActivitySortOrder;


		-- Mark the Instance Sub process if the activity just completed finished up the sub process.
		-- lastly mark the InstanceProcessSubProcess records.		
		UPDATE	ipsp
		SET	ipsp.InstanceProcessSubProcessCompleted		= @true,
			ipsp.InstanceProcessSubProcessDeadlineMissed	= CASE WHEN InstanceProcessSubProcessDeadline < @now THEN 1 ELSE 0 END,
			ipsp.InstanceProcessSubProcessCompletedBy	= @ModifiedBy,
			ipsp.InstanceProcessSubProcessDidNotApply	= x.NA,
			ipsp.ModifiedDate				= @now,
			ipsp.ModifiedBy					= @ModifiedBy
		OUTPUT 	INSERTED.AtulInstanceProcessSubProcessID
		INTO	@outputSubProcess (
			AtulInstanceProcessSubProcessID
			)
		FROM	dbo.AtulInstanceProcessSubProcess ipsp
		JOIN	@return s ON ipsp.AtulInstanceProcessSubProcessID = s.AtulInstanceProcessSubProcessID
		JOIN	(	SELECT	AtulProcessSubprocessID,
				MIN(CAST (Completed AS INT)) AS Completed,
				MIN(CAST (NA AS INT)) AS NA
				FROM	@return a
				WHERE	AtulProcessActivityID IS NOT NULL
				GROUP BY AtulProcessSubprocessID
			) x ON s.AtulProcessSubprocessID = x.AtulProcessSubprocessID
				AND x.Completed = 1
				AND s.AtulProcessActivityID IS NULL
		JOIN	@return a ON x.AtulProcessSubprocessID = a.AtulProcessSubprocessID
				AND a.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID  -- Mark subprocess affected by the activity completed
		WHERE	ipsp.InstanceProcessSubProcessCompleted = @false;

		UPDATE	a
		SET	a.EndDate	= @now
		FROM	audit.AtulInstanceProcessSubProcess a WITH (ROWLOCK)
		JOIN	@outputSubProcess b ON a.AtulInstanceProcessSubProcessID = b.AtulInstanceProcessSubProcessID
		WHERE	a.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessSubProcess (
			AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			StartDate )
		SELECT	sp.AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			@now
		FROM	dbo.AtulInstanceProcessSubProcess sp WITH (NOLOCK)
		JOIN	@outputSubProcess h ON h.AtulInstanceProcessSubProcessID = sp.AtulInstanceProcessSubProcessID;

		-- Mark the Instanc Process if completed
		SELECT	@ProcessComplete	= MIN(CAST (ipa.InstanceProcessActivityCompleted AS INT) ),
			@ProcessMissedDeadline	= MIN(CAST (ipa.InstanceProcessActivityDeadlineMissed AS INT) )
		FROM	dbo.AtulInstanceProcessActivity ipa WITH (NOLOCK)
		WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID;
		
		IF (@ProcessComplete = 1)
		BEGIN;
			UPDATE	ip
			SET	InstanceProcessProcessCompleted		= @completed,
				InstanceProcessProcessDeadlineMissed	= @ProcessMissedDeadline,
				AtulProcessStatusID			= 2,
				ModifiedDate				= @now,
				ModifiedBy				= @ModifiedBy
			FROM	dbo.AtulInstanceProcess ip WITH (ROWLOCK)
			WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID;

			UPDATE	aip
			SET	aip.EndDate		= @now
			FROM	audit.AtulInstanceProcess aip WITH (ROWLOCK)
			WHERE	aip.AtulInstanceProcessID = @AtulInstanceProcessID
			AND	aip.EndDate	IS NULL;

			INSERT	audit.AtulInstanceProcess (
				AtulInstanceProcessID,
				AtulProcessID,
				CreatedBy,
				OwnedBy,
				AtulProcessStatusID,
				ModifiedBy,
				StartDate,
				SubjectIdentifier,
				SubjectSummary,
				InstanceProcessProcessCompleted,
				InstanceProcessProcessDeadlineMissed,
				InstanceProcessProcessCompletedBy,
				SubjectServiceProviderID )
			SELECT	AtulInstanceProcessID,
			        AtulProcessID,
			        CreatedBy,
		        	OwnedBy,
			        AtulProcessStatusID,
			        ModifiedBy,
			        @now,
			        SubjectIdentifier,
			        SubjectSummary,
				InstanceProcessProcessCompleted,
				InstanceProcessProcessDeadlineMissed,
				InstanceProcessProcessCompletedBy,
			        SubjectServiceProviderID
			FROM	dbo.AtulInstanceProcess WITH (NOLOCK)
			WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;
		END;		
				
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityDelete_sp
(
	@AtulInstanceProcessActivityID	BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcessActivity ag
		WHERE	ag.AtulInstanceProcessActivityID		= @AtulInstanceProcessActivityID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulInstanceProcessActivity aga
		WHERE	aga.AtulInstanceProcessActivityID		= @AtulInstanceProcessActivityID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityGetBy_sp
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ipa.AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID,
		ipa.AtulInstanceProcessID			AS AtulInstanceProcessID,
		ipa.AtulProcessActivityID			AS AtulProcessActivityID,
		ipa.InstanceProcessActivityDeadline		AS InstanceProcessActivityDeadline,
		ipa.InstanceProcessActivityCompleted		AS InstanceProcessActivityCompleted,
		ipa.InstanceProcessActivityDidNotApply		AS InstanceProcessActivityDidNotApply,
		ipa.InstanceProcessActivityDeadlineMissed	AS InstanceProcessActivityDeadlineMissed,
		ipa.InstanceProcessActivityCompletedBy		AS InstanceProcessActivityCompletedBy,
		a.AtulSubProcessID				AS AtulSubProcessID,
		a.ActivityDescription				AS ActivityDescription,
		a.ActivityProcedure				AS ActivityProcedure,
		a.ActivitySummary				AS ActivitySummary,
		a.AtulActivitySortOrder				AS AtulActivitySortOrder,
		a.AtulActivityID					AS AtulActivityID,
		sp.SubProcessDescription			AS SubProcessDescription,
		sp.SubProcessSummary				AS SubProcessSummary,
		cb.DisplayName					AS InstanceProcessActivityCompletedByName,
		ipa.CreatedDate					AS CreatedDate,
		ipa.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
		ipa.ModifiedDate				AS ModifiedDate,
		ipa.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName,
		sp.OwnedBy					AS OwnedBy,
		ob.DisplayName					AS OwnedByName,
		ipa.AtulServiceProviderID			AS AtulServiceProviderID
	FROM	dbo.AtulInstanceProcessActivity ipa
	JOIN	dbo.AtulUser cu ON ipa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ipa.ModifiedBy = mu.AtulUserID
	LEFT JOIN	dbo.AtulUser cb ON ipa.InstanceProcessActivityCompletedBy = cb.AtulUserID
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
	JOIN	dbo.AtulActivity a ON pa.AtulActivityID = a.AtulActivityID
	JOIN	dbo.AtulSubProcess sp ON a.AtulSubProcessID = sp.AtulSubProcessID
	JOIN	dbo.AtulUser ob ON sp.OwnedBy = ob.AtulUserID
	WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID
	ORDER BY a.AtulSubProcessID ASC, a.AtulActivitySortOrder ASC;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ipa.AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID,
		ipa.AtulInstanceProcessID			AS AtulInstanceProcessID,
		ipa.AtulProcessActivityID			AS AtulProcessActivityID,
		ipa.InstanceProcessActivityDeadline		AS InstanceProcessActivityDeadline,
		ipa.InstanceProcessActivityCompleted		AS InstanceProcessActivityCompleted,
		ipa.InstanceProcessActivityDidNotApply		AS InstanceProcessActivityDidNotApply,
		ipa.InstanceProcessActivityDeadlineMissed	AS InstanceProcessActivityDeadlineMissed,
		ipa.InstanceProcessActivityCompletedBy		AS InstanceProcessActivityCompletedBy,
		cb.DisplayName					AS InstanceProcessActivityCompletedByName,
		ipa.CreatedDate					AS CreatedDate,
		ipa.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
		ipa.ModifiedDate				AS ModifiedDate,
		ipa.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName,
		ipa.AtulServiceProviderID			AS AtulServiceProviderID
	FROM	dbo.AtulInstanceProcessActivity ipa
	JOIN	dbo.AtulUser cu ON ipa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ipa.ModifiedBy = mu.AtulUserID
	LEFT JOIN	dbo.AtulUser cb ON ipa.InstanceProcessActivityCompletedBy = cb.AtulUserID
	WHERE	ipa.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityInsert_sp
(
	@AtulInstanceProcessID			BIGINT,
	@AtulProcessActivityID			BIGINT,
	@CreatedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulInstanceProcessActivityID	BIGINT,
		@deadlineoffset			INT,
		@deadlinedate			DATETIME;

	SET	@now	= GETUTCDATE();

	SELECT	@deadlineoffset			= pa.DeadlineOffset
	FROM	dbo.AtulProcessActivity pa
	WHERE	pa.AtulProcessActivityID	= @AtulProcessActivityID;

	IF @deadlineoffset = 0
	BEGIN;
		SET	@deadlinedate = NULL;
	END;
	ELSE
	BEGIN;
		SELECT	@deadlinedate = DATEADD(mi, @deadlineoffset, @now)
	END;

	BEGIN TRAN;
		INSERT	dbo.AtulInstanceProcessActivity (
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulInstanceProcessID,
			@AtulProcessActivityID,
			@deadlinedate,			-- ProcessActivityDeadline
			CAST ( 0 AS BIT ),		-- ProcessActivityCompleted
			CAST ( 0 AS BIT ),		-- ProcessActivityDidNotApply
			CAST ( 0 AS BIT ),		-- ProcessActivityDeadlineMissed
			@now,				-- CreatedDate
			@CreatedBy,			-- CreatedBy
			@now,				-- ModifiedDate
			@CreatedBy,			-- ModifiedBy
			CAST ( 1 AS BIT);		-- IsActive

		SET	@AtulInstanceProcessActivityID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulInstanceProcessActivity (
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
		        @now
		FROM	dbo.AtulInstanceProcessActivity WITH (NOLOCK)
		WHERE	AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;
	COMMIT TRAN;

	SELECT	@AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityInteractionDelete_sp
(
	@AtulInstanceProcessActivityInteractionID	BIGINT,
	@ModifiedBy					BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	i
		SET	IsActive			= CAST (0 AS BIT),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcessActivityInteraction i
		WHERE	AtulInstanceProcessActivityInteractionID	= @AtulInstanceProcessActivityInteractionID;

		UPDATE	a
		SET	EndDate				= @now
		FROM	audit.AtulInstanceProcessActivityInteraction a
		WHERE	AtulInstanceProcessActivityInteractionID	= @AtulInstanceProcessActivityInteractionID
		AND	a.EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityInteractionGetByID_sp
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	i.AtulInstanceProcessActivityInteractionID	AS AtulInstanceProcessActivityInteractionID,
	        i.AtulInstanceProcessID				AS AtulInstanceProcessID,
	        i.AtulActivityID				AS AtulActivityID,
	        i.AtulServiceProviderID				AS AtulServiceProviderID,
	        i.ActivityInteractionLabel			AS ActivityInteractionLabel,
	        i.ActivityInteractionIdentifer			AS ActivityInteractionIdentifer,
	        i.ActivityInteractionURL			AS ActivityInteractionURL,
	        i.CreatedDate					AS CreatedDate,
	        i.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
	        i.ModifiedDate					AS ModifiedDate,
	        i.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName
	FROM	dbo.AtulInstanceProcessActivityInteraction i
	JOIN	dbo.AtulUser cu ON i.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON i.ModifiedBy = mu.AtulUserID
	WHERE	i.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	i.IsActive		= CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityInteractionInsert_sp
(
	@AtulInstanceProcessID		BIGINT,
	@AtulActivityID			BIGINT,
	@AtulServiceProviderID		BIGINT,
	@ActivityInteractionLabel	NVARCHAR(150),
	@ActivityInteractionIdentifer	NVARCHAR(150),
	@ActivityInteractionURL		NVARCHAR(150),
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulInstanceProcessActivityInteractionID		BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulInstanceProcessActivityInteraction (
			AtulInstanceProcessID,
			AtulActivityID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulInstanceProcessID,
			@AtulActivityID,
			@AtulServiceProviderID,
			@ActivityInteractionLabel,
			@ActivityInteractionIdentifer,
			@ActivityInteractionURL,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulInstanceProcessActivityInteractionID = SCOPE_IDENTITY();

		INSERT	audit.AtulInstanceProcessActivityInteraction (
			AtulInstanceProcessActivityInteractionID,
			AtulInstanceProcessID,
			AtulActivityID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityInteractionID,
			AtulInstanceProcessID,
			AtulActivityID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulInstanceProcessActivityInteraction WITH (NOLOCK)
		WHERE	AtulInstanceProcessActivityInteractionID = @AtulInstanceProcessActivityInteractionID;
	COMMIT TRAN;

	SELECT	@AtulInstanceProcessActivityInteractionID		AS AtulInstanceProcessActivityInteractionID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityInteractionUpdate_sp
(
	@AtulInstanceProcessActivityInteractionID	BIGINT,
	@AtulInstanceProcessID				BIGINT,
	@AtulActivityID					BIGINT,
	@AtulServiceProviderID				BIGINT,
	@ActivityInteractionLabel			NVARCHAR(150),
	@ActivityInteractionIdentifer			NVARCHAR(150),
	@ActivityInteractionURL				NVARCHAR(150),
	@ModifiedBy					BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	i
		SET	AtulInstanceProcessID		= @AtulInstanceProcessID,
			AtulActivityID			= @AtulActivityID,
			AtulServiceProviderID		= @AtulServiceProviderID,
			ActivityInteractionLabel	= @ActivityInteractionLabel,
			ActivityInteractionIdentifer	= @ActivityInteractionIdentifer,
			ActivityInteractionURL		= @ActivityInteractionURL,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcessActivityInteraction i
		WHERE	AtulInstanceProcessActivityInteractionID	= @AtulInstanceProcessActivityInteractionID;

		UPDATE	a
		SET	EndDate				= @now
		FROM	audit.AtulInstanceProcessActivityInteraction a
		WHERE	AtulInstanceProcessActivityInteractionID	= @AtulInstanceProcessActivityInteractionID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessActivityInteraction (
			AtulInstanceProcessActivityInteractionID,
			AtulInstanceProcessID,
			AtulActivityID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityInteractionID,
			AtulInstanceProcessID,
			AtulActivityID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulInstanceProcessActivityInteraction WITH (NOLOCK)
		WHERE	AtulInstanceProcessActivityInteractionID = @AtulInstanceProcessActivityInteractionID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessActivityUpdate_sp
(
	@AtulInstanceProcessActivityID		BIGINT,
	@AtulInstanceProcessID			BIGINT,
	@AtulProcessActivityID			BIGINT,
	@ProcessActivityCompleted		BIT,
	@ProcessActivityDidNotApply		BIT,
	@ProcessActivityDeadlineMissed		BIT,
	@InstanceProcessActivityCompletedBy	BIGINT,
	@ModifiedBy				BIGINT,
	@AtulServiceProviderID			BIGINT = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@deadlineoffset			INT,
		@deadlinedate			DATETIME;

	SET	@now	= GETUTCDATE();

	SELECT	@deadlineoffset			= pa.DeadlineOffset
	FROM	dbo.AtulProcessActivity pa
	WHERE	pa.AtulProcessActivityID	= @AtulProcessActivityID;

	IF @deadlineoffset = 0
	BEGIN;
		SET	@deadlinedate = NULL;
	END;
	ELSE
	BEGIN;
		SELECT	@deadlinedate = DATEADD(mi, @deadlineoffset, @now)
	END;

	BEGIN TRAN;
		UPDATE	ipa
		SET	AtulInstanceProcessID			= @AtulInstanceProcessID,
			AtulProcessActivityID			= @AtulProcessActivityID,
			InstanceProcessActivityDeadline		= @deadlinedate,
			InstanceProcessActivityCompleted	= @ProcessActivityCompleted,
			InstanceProcessActivityDidNotApply	= @ProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed	= @ProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy	= @InstanceProcessActivityCompletedBy,
			ModifiedDate				= @now,
			ModifiedBy				= @ModifiedBy,
			AtulServiceProviderID			= COALESCE(@AtulServiceProviderID, AtulServiceProviderID)
		FROM	dbo.AtulInstanceProcessActivity ipa WITH (ROWLOCK)
		WHERE	ipa.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;

		UPDATE	aipa
		SET	aipa.EndDate				= @now
		FROM	audit.AtulInstanceProcessActivity aipa WITH (ROWLOCK)
		WHERE	aipa.AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID
		AND	aipa.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessActivity (
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
		        @now
		FROM	dbo.AtulInstanceProcessActivity WITH (NOLOCK)
		WHERE	AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessDelete_sp
(
	@AtulInstanceProcessID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcess ag
		WHERE	ag.AtulInstanceProcessID	= @AtulInstanceProcessID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulInstanceProcess aga
		WHERE	aga.AtulInstanceProcessID	= @AtulInstanceProcessID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessGetByID_sp
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ip.AtulInstanceProcessID		AS AtulInstanceProcessID,
		ip.AtulProcessID			AS AtulProcessID,
		ip.CreatedDate				AS CreatedDate,
		ip.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ip.OwnedBy				AS OwnedBy,
		ou.DisplayName				AS OwnedByName,
		ip.AtulProcessStatusID			AS AtulProcessStatusID,
		ps.ProcessStatus			AS ProcessStatus,
		ip.SubjectIdentifier			AS SubjectIdentifier,
		ip.SubjectSummary			AS SubjectSummary,
		ip.ModifiedDate				AS ModifiedDate,
		ip.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		ip.SubjectServiceProviderID		AS SubjectServiceProviderID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulProcessStatus ps ON ip.AtulProcessStatusID = ps.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON ip.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ip.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON ip.OwnedBy = ou.AtulUserID
	WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	ip.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessGetByProcessID_sp
(
	@AtulProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ip.AtulInstanceProcessID		AS AtulInstanceProcessID,
		ip.AtulProcessID			AS AtulProcessID,
		ip.CreatedDate				AS CreatedDate,
		ip.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ip.OwnedBy				AS OwnedBy,
		ou.DisplayName				AS OwnedByName,
		ip.AtulProcessStatusID			AS AtulProcessStatusID,
		ps.ProcessStatus			AS ProcessStatus,
		ip.SubjectIdentifier			AS SubjectIdentifier,
		ip.SubjectSummary			AS SubjectSummary,
		ip.ModifiedDate				AS ModifiedDate,
		ip.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		ip.SubjectServiceProviderID		AS SubjectServiceProviderID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulProcessStatus ps ON ip.AtulProcessStatusID = ps.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON ip.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ip.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON ip.OwnedBy = ou.AtulUserID
	WHERE	ip.AtulProcessID = @AtulProcessID
	AND	ip.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessGetDeleted_sp
(
	@startdate	DATETIME
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ip.AtulInstanceProcessID		AS AtulInstanceProcessID,
		p.ProcessSummary			AS ProcessSummary,
		ip.AtulProcessID			AS AtulProcessID,
		ip.CreatedDate				AS CreatedDate,
		ip.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ip.OwnedBy				AS OwnedBy,
		ou.DisplayName				AS OwnedByName,
		ip.AtulProcessStatusID			AS AtulProcessStatusID,
		ps.ProcessStatus			AS ProcessStatus,
		ip.SubjectIdentifier			AS SubjectIdentifier,
		ip.SubjectSummary			AS SubjectSummary,
		ip.ModifiedDate				AS ModifiedDate,
		ip.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		ip.SubjectServiceProviderID		AS SubjectServiceProviderID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulProcessStatus ps ON ip.AtulProcessStatusID = ps.AtulProcessStatusID
	JOIN	dbo.AtulProcess p ON ip.AtulProcessID = p.AtulProcessID
	JOIN	dbo.AtulUser cu ON ip.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ip.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON ip.OwnedBy = ou.AtulUserID
	WHERE	ip.IsActive = CAST ( 0 AS BIT )
	AND	( @startdate IS NULL OR ip.ModifiedDate >= @startdate);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessGetNameValueByID_sp
(
	@AtulInstanceProcessID	BIGINT
)
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Output AS TABLE
(
name NVARCHAR(200),
value NVARCHAR(MAX)
);
 
INSERT INTO @Output
(
name,
value
) 
SELECT 
ConfigVariableName,
ConfigVariableValue
FROM dbo.AtulConfigVariables
WHERE ScriptName = 'Atul';


INSERT INTO @Output
(
name,
value
) 
SELECT names, value
FROM 
	(
	SELECT
	CAST(1 AS NVARCHAR(MAX)) AS name,
	CAST(AtulProcessID AS NVARCHAR(MAX))  AtulProcessID,
	CAST(CreatedDate AS NVARCHAR(MAX)) CreatedDate,
	CAST(CreatedBy AS NVARCHAR(MAX)) CreatedBy,
	CAST(OwnedBy  AS NVARCHAR(MAX)) OwnedBy,
	CAST(ps.AtulProcessStatusID AS NVARCHAR(MAX)) AtulProcessStatusID,
	CAST(ps.ProcessStatus AS NVARCHAR(MAX)) ProcessStatus,
	CAST(SubjectIdentifier AS NVARCHAR(MAX)) SubjectIdentifier,
	CAST(SubjectSummary AS NVARCHAR(MAX)) SubjectSummary,
	CAST(SubjectServiceProviderID AS NVARCHAR(MAX)) SubjectServiceProviderID
	FROM dbo.AtulInstanceProcess ip
		INNER JOIN dbo.AtulProcessStatus ps
			ON ip.AtulProcessStatusID = ps.AtulProcessStatusID
	WHERE AtulInstanceProcessID = @AtulInstanceProcessID
	) p
UNPIVOT
	(value FOR names IN 
		(AtulProcessID,
		CreatedDate,
		CreatedBy,
		OwnedBy,
		AtulProcessStatusID,
		ProcessStatus,
		SubjectIdentifier,
		SubjectSummary,
		SubjectServiceProviderID)
	)	AS unpvt;
	
	
INSERT INTO @Output
        ( name, value )
SELECT
ff.TokenName,
ffs.TokenValue
FROM dbo.AtulFlexFieldStorage ffs
	INNER JOIN dbo.AtulFlexField ff
		ON ffs.AtulFlexFieldID = ff.AtulFlexFieldID
WHERE ffs.AtulInstanceProcessID = @AtulInstanceProcessID;		


SELECT
name,
value
FROM @Output;

SET NOCOUNT OFF;
END
RETURN	0;
go

create PROCEDURE dbo.Atul_InstanceProcessGetNextActvities_sp
(
	@AtulInstanceProcessID		BIGINT,
	@AtulInstanceProcessActivityID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;

	DECLARE	@true		BIT,
		@ranking	INT;
	
	SET	@true	= CAST (1 AS BIT);

	DECLARE	@holding AS TABLE (
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessDescription		NVARCHAR(256),
		SubProcessSummary		NVARCHAR(50),
		ActivityDescription		NVARCHAR(256),
		ActivitySummary			NVARCHAR(50),
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT,
		ProcessStatus			INT,
		ServiceProvider			BIGINT );

	DECLARE	@return AS TABLE (
		Ranking				INT IDENTITY (1,1),
		AtulInstanceProcessSubProcessID	BIGINT,
		AtulInstanceProcessActivityID	BIGINT,
		AtulInstanceProcessID		BIGINT,
		AtulProcessActivityID		BIGINT,
		AtulProcessSubprocessID		BIGINT,
		AtulProcessID			BIGINT,
		AtulSubProcessID		BIGINT,
		SubProcessDescription		NVARCHAR(256),
		SubProcessSummary		NVARCHAR(50),
		ActivityDescription		NVARCHAR(256),
		ActivitySummary			NVARCHAR(50),
		SubProcessSortOrder		INT,
		ProcessActivitySortOrder	INT,
		Completed			BIT,
		ProcessStatus			INT,
		ServiceProvider			BIGINT );

	INSERT	@holding (
		AtulInstanceProcessSubProcessID,
		AtulInstanceProcessID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		SubProcessDescription,
		SubProcessSummary,
		Completed,
		ProcessStatus,
		ServiceProvider )
	SELECT	DISTINCT
		ipsp.AtulInstanceProcessSubProcessID		AS AtulInstanceProcessSubProcessID,
	        ipsp.AtulInstanceProcessID			AS AtulInstanceProcessID,
	        ipsp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
	        p.AtulProcessID					AS AtulProcessID,
		psp.AtulSubProcessID				AS AtulSubProcessID,
		psp.ProcessSubprocessSortOrder			AS SubProcessSortOrder,
		0						AS ProcessActivitySortOrder,
		sp.SubProcessDescription			AS SubProcessDescription,
		sp.SubProcessSummary				AS SubProcessSummary,
	        ipsp.InstanceProcessSubProcessCompleted		AS Completed,
 	        ip.AtulProcessStatusID				AS ProcessStatus,
 	        psp.NotificationServiceProviderID		AS ServiceProvider
	FROM	dbo.AtulInstanceProcessSubProcess ipsp
	JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
					AND psp.IsActive = @true
	JOIN	dbo.AtulProcess p ON psp.AtulProcessID = p.AtulProcessID
					AND p.IsActive = @true
	JOIN	dbo.AtulInstanceProcess ip ON ipsp.AtulInstanceProcessID = ip.AtulInstanceProcessID
					AND ip.IsActive = @true
	JOIN	dbo.AtulSubProcess sp ON psp.AtulSubProcessID = sp.AtulSubProcessID
					AND sp.IsActive = @true
	WHERE	ipsp.AtulInstanceProcessID	= @AtulInstanceProcessID
	AND	ipsp.IsActive			= @true;

	INSERT	@holding (
 		AtulInstanceProcessID,
 		AtulInstanceProcessActivityID,
 		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessDescription,
		SubProcessSummary,
		ActivityDescription,
		ActivitySummary,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed,
		ProcessStatus,
		ServiceProvider
		)
	SELECT	ipa.AtulInstanceProcessID			AS AtulInstanceProcessID,
		ipa.AtulInstanceProcessActivityID		AS AtulInstanceProcessActivityID,
		ipa.AtulProcessActivityID			AS AtulProcessActivityID,
		psp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
		pa.AtulProcessID				AS AtulProcessID,
		a.AtulSubProcessID				AS AtulSubProcessID,
		sp.SubProcessDescription			AS SubProcessDescription,
		sp.SubProcessSummary				AS SubProcessSummary,
		a.ActivityDescription				AS ActivityDescription,
		a.ActivitySummary				AS ActivitySummary,
		psp.ProcessSubprocessSortOrder			AS ProcessSubprocessSortOrder,
		pa.ProcessActivitySortOrder			AS ProcessActivitySortOrder,
		ipa.InstanceProcessActivityCompleted		AS InstanceProcessActivityCompleted,
 	        ip.AtulProcessStatusID				AS AtulProcessStatusID,
 	        ipa.AtulServiceProviderID			AS ServiceProvider
	FROM	dbo.AtulInstanceProcessActivity ipa
	JOIN	dbo.AtulInstanceProcess ip ON ipa.AtulInstanceProcessID = ip.AtulInstanceProcessID
	JOIN	dbo.AtulProcessActivity pa ON ipa.AtulProcessActivityID = pa.AtulProcessActivityID
	JOIN	dbo.AtulActivity a ON pa.AtulActivityID = a.AtulActivityID
					AND a.IsActive = @true
	JOIN	dbo.AtulSubProcess sp ON a.AtulSubProcessID = sp.AtulSubProcessID
 					AND sp.IsActive = @true
 	JOIN	dbo.AtulProcessSubprocess psp ON psp.AtulSubProcessID = sp.AtulSubProcessID
 					AND psp.AtulProcessID = pa.AtulProcessID
 					AND psp.IsActive = @true
	WHERE	ipa.AtulInstanceProcessID = @AtulInstanceProcessID;

	INSERT	@return (
		AtulInstanceProcessSubProcessID,
		AtulInstanceProcessActivityID,
		AtulInstanceProcessID,
		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessDescription,
		SubProcessSummary,
		ActivityDescription,
		ActivitySummary,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed,
		ProcessStatus,
		ServiceProvider)
	SELECT	AtulInstanceProcessSubProcessID,
		AtulInstanceProcessActivityID,
		AtulInstanceProcessID,
		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessDescription,
		SubProcessSummary,
		ActivityDescription,
		ActivitySummary,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed,
		ProcessStatus,
		ServiceProvider
	FROM	@holding
	ORDER BY AtulSubProcessID, ProcessActivitySortOrder;

	SELECT	@ranking = Ranking
	FROM	@return
	WHERE	AtulInstanceProcessActivityID = @AtulInstanceProcessActivityID;

	SELECT	AtulInstanceProcessSubProcessID,
		AtulInstanceProcessActivityID,
		AtulInstanceProcessID,
		AtulProcessActivityID,
		AtulProcessSubprocessID,
		AtulProcessID,
		AtulSubProcessID,
		SubProcessDescription,
		SubProcessSummary,
		ActivityDescription,
		ActivitySummary,
		SubProcessSortOrder,
		ProcessActivitySortOrder,
		Completed,
		ProcessStatus,
		ServiceProvider
	FROM	@return
	WHERE	Ranking > COALESCE(@ranking, 0)
	AND	Completed = CAST( 0 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ip.AtulInstanceProcessID		AS AtulInstanceProcessID,
		ip.AtulProcessID			AS AtulProcessID,
		ip.CreatedDate				AS CreatedDate,
		ip.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		ip.OwnedBy				AS OwnedBy,
		ou.DisplayName				AS OwnedByName,
		ip.AtulProcessStatusID			AS AtulProcessStatusID,
		ps.ProcessStatus			AS ProcessStatus,
		ip.SubjectIdentifier			AS SubjectIdentifier,
		ip.SubjectSummary			AS SubjectSummary,
		ip.ModifiedDate				AS ModifiedDate,
		ip.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		ip.SubjectServiceProviderID		AS SubjectServiceProviderID
	FROM	dbo.AtulInstanceProcess ip
	JOIN	dbo.AtulProcessStatus ps ON ip.AtulProcessStatusID = ps.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON ip.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ip.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON ip.OwnedBy = ou.AtulUserID
	WHERE	ip.IsActive = CAST ( 1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessInsert_sp
(
	@AtulProcessID			BIGINT,
	@CreatedBy			BIGINT,
	@OwnedBy			BIGINT,
	@AtulProcessStatusID		INT,
	@SubjectIdentifier		NVARCHAR(50),
	@SubjectSummary			NVARCHAR(255)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulInstanceProcessID		BIGINT,
		@true				BIT,
		@false				BIT,
		@SubjectServiceProviderID	BIGINT;

	DECLARE @holding AS TABLE (
		AtulProcessActivityID		BIGINT,
		InstanceProcessActivityDeadline	DATETIME,
		PRIMARY KEY CLUSTERED (AtulProcessActivityID) )

	DECLARE @holding2 AS TABLE (
		AtulProcessSubprocessID			BIGINT,
		InstanceProcessSubprocessDeadline	DATETIME,
		PRIMARY KEY CLUSTERED (AtulProcessSubprocessID) )

	SET	@now	= GETUTCDATE();
	SET	@true	= CAST (1 AS BIT);
	SET	@false	= CAST (0 AS BIT);

	SELECT	@SubjectServiceProviderID	= p.SubjectServiceProviderID
	FROM	dbo.AtulProcess p WITH (NOLOCK)
	WHERE	p.AtulProcessID			= @AtulProcessID;

	INSERT	@holding (
		AtulProcessActivityID,
	        InstanceProcessActivityDeadline )
	SELECT	pa.AtulProcessActivityID
		,DATEADD(mi, pa.DeadlineOffset, @now)
	FROM	dbo.AtulProcessActivity pa WITH (NOLOCK)
	JOIN	dbo.AtulActivity a WITH (NOLOCK) ON pa.AtulActivityID = a.AtulActivityID
				AND a.IsActive = @true
	WHERE	pa.AtulProcessID	= @AtulProcessID
	AND	pa.IsActive		= @true;
	
	INSERT	@holding2 (
		AtulProcessSubprocessID,
		InstanceProcessSubprocessDeadline )
	SELECT	sp.AtulProcessSubprocessID,
		DATEADD(mi, sp.DeadlineOffset, @now)
	FROM	dbo.AtulProcessSubprocess sp WITH (NOLOCK)
	WHERE	sp.AtulProcessID	= @AtulProcessID
	AND	sp.IsActive		= @true;

	BEGIN TRAN;
		INSERT	dbo.AtulInstanceProcess (
			AtulProcessID,
			CreatedDate,
			CreatedBy,
			OwnedBy,
			AtulProcessStatusID,
			ModifiedDate,
			ModifiedBy,
			IsActive,
			SubjectIdentifier,
			SubjectSummary,
			InstanceProcessProcessCompleted,
			InstanceProcessProcessDeadlineMissed,
			SubjectServiceProviderID )
		SELECT	@AtulProcessID,
			@now,
			@CreatedBy,
			@OwnedBy,
			@AtulProcessStatusID,
			@now,
			@CreatedBy,
			@true,
			@SubjectIdentifier,
			@SubjectSummary,
			@false,
			@false,
			@SubjectServiceProviderID;

		SET	@AtulInstanceProcessID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulInstanceProcess (
			AtulInstanceProcessID,
			AtulProcessID,
			CreatedBy,
			OwnedBy,
			AtulProcessStatusID,
			ModifiedBy,
			StartDate,
			SubjectIdentifier,
			SubjectSummary,
			InstanceProcessProcessCompleted,
			InstanceProcessProcessDeadlineMissed,
			SubjectServiceProviderID )
		SELECT	AtulInstanceProcessID,
		        AtulProcessID,
		        CreatedBy,
		        OwnedBy,
		        AtulProcessStatusID,
		        ModifiedBy,
		        @now,
		        SubjectIdentifier,
		        SubjectSummary,
		        InstanceProcessProcessCompleted,
		        InstanceProcessProcessDeadlineMissed,
		        SubjectServiceProviderID
		FROM	dbo.AtulInstanceProcess WITH (NOLOCK)
		WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;

		INSERT	dbo.AtulInstanceProcessActivity (
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			CAST ( 0 AS BIT ),
			CAST ( 0 AS BIT ),
			CAST ( 0 AS BIT ),
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST (1 AS BIT)
		FROM	@holding;

		INSERT	audit.AtulInstanceProcessActivity (
			AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessActivityID,
			AtulInstanceProcessID,
			AtulProcessActivityID,
			InstanceProcessActivityDeadline,
			InstanceProcessActivityCompleted,
			InstanceProcessActivityDidNotApply,
			InstanceProcessActivityDeadlineMissed,
			InstanceProcessActivityCompletedBy,
			AtulServiceProviderID,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulInstanceProcessActivity WITH (NOLOCK)
		WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;
		
		INSERT	dbo.AtulInstanceProcessSubProcess (
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive,
			InstanceProcessSubProcessDeadline )
		SELECT	@AtulInstanceProcessID,
			AtulProcessSubprocessID,
			CAST ( 0 AS BIT ),
			CAST ( 0 AS BIT ),
			CAST ( 0 AS BIT ),
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST (1 AS BIT),
			InstanceProcessSubprocessDeadline
		FROM	@holding2;
		
		INSERT	audit.AtulInstanceProcessSubProcess (
			AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			StartDate )
		SELECT	AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			@now
		FROM	dbo.AtulInstanceProcessSubProcess
		WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;
	COMMIT TRAN;

	SELECT	@AtulInstanceProcessID		AS AtulInstanceProcessID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcessCompleteUpdate_sp
(
	@AtulInstanceProcessSubProcessID	BIGINT,
	@statusBit				INT,
	@ModifiedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@deadlinedate			DATETIME,
		@misseddeadline			BIT,
		@notapply			BIT,
		@completed			BIT;

	SET	@now		= GETUTCDATE();
	SET	@completed	= CAST (0 AS BIT);
	SET	@misseddeadline = CAST (0 AS BIT);
	SET	@notapply	= CAST (0 AS BIT);

	SELECT	@deadlinedate	= COALESCE(ipsp.InstanceProcessSubProcessDeadline, '12/31/9999 00:00:00')
	FROM	dbo.AtulInstanceProcessSubProcess ipsp WITH (NOLOCK)
	WHERE	ipsp.AtulInstanceProcessSubProcessID = @AtulInstanceProcessSubProcessID;
	
	IF (@now <= @deadlinedate )
	BEGIN;
		SET @misseddeadline = 0;
	END;
	ELSE
	BEGIN;
		SET @misseddeadline = 1;
	END;

	IF (@statusBit = 1 )
	BEGIN;
		SET @completed		= CAST (1 AS BIT);
	END;
	ELSE IF (@statusBit = 2 )
	BEGIN;
		SET @completed		= CAST (1 AS BIT);
		SET @notapply		= CAST (1 AS BIT);
	END;

	BEGIN TRAN;
		UPDATE	ipsp
		SET	InstanceProcessSubProcessCompleted	= @completed,
			InstanceProcessSubProcessDidNotApply	= @notapply,
			InstanceProcessSubProcessDeadlineMissed	= @misseddeadline,
			InstanceProcessSubProcessCompletedBy	= @ModifiedBy,
			ModifiedDate				= @now,
			ModifiedBy				= @ModifiedBy
		FROM	dbo.AtulInstanceProcessSubProcess ipsp WITH (ROWLOCK)
		WHERE	ipsp.AtulInstanceProcessSubProcessID = @AtulInstanceProcessSubProcessID;

		UPDATE	aipsp
		SET	aipsp.EndDate				= @now
		FROM	audit.AtulInstanceProcessSubProcess aipsp WITH (ROWLOCK)
		WHERE	aipsp.AtulInstanceProcessSubProcessID = @AtulInstanceProcessSubProcessID
		AND	aipsp.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessSubProcess (
			AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			StartDate )
		SELECT	AtulInstanceProcessSubProcessID,
			AtulInstanceProcessID,
			AtulProcessSubprocessID,
			InstanceProcessSubProcessCompleted,
			InstanceProcessSubProcessDidNotApply,
			InstanceProcessSubProcessDeadlineMissed,
			CreatedBy,
			ModifiedBy,
			InstanceProcessSubProcessCompletedBy,
			InstanceProcessSubprocessDeadline,
			@now
		FROM	dbo.AtulInstanceProcessSubProcess WITH (NOLOCK)
		WHERE	AtulInstanceProcessSubProcessID = @AtulInstanceProcessSubProcessID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcessInteractionDelete_sp
(
	@AtulInstanceProcessSubProcessInteractionID	BIGINT,
	@ModifiedBy					BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	i
		SET	IsActive			= CAST (0 AS BIT),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcessSubProcessInteraction i
		WHERE	@AtulInstanceProcessSubProcessInteractionID	= @AtulInstanceProcessSubProcessInteractionID

		UPDATE	a
		SET	a.EndDate			= @now
		FROM	audit.AtulInstanceProcessSubProcessInteraction a
		WHERE	a.AtulInstanceProcessSubProcessInteractionID	= @AtulInstanceProcessSubProcessInteractionID
		AND	a.EndDate IS NULL;
	COMMIT TRAN;
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcessInteractionGetByID_sp
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	i.AtulInstanceProcessSubProcessInteractionID	AS AtulInstanceProcessSubProcessInteractionID,
	        i.AtulInstanceProcessID				AS AtulInstanceProcessID,
	        i.AtulProcessSubProcessID			AS AtulProcessSubProcessID,
	        i.AtulServiceProviderID				AS AtulServiceProviderID,
	        i.ActivityInteractionLabel			AS ActivityInteractionLabel,
	        i.ActivityInteractionIdentifer			AS ActivityInteractionIdentifer,
	        i.ActivityInteractionURL			AS ActivityInteractionURL,
	        i.CreatedDate					AS CreatedDate,
	        i.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
	        i.ModifiedDate					AS ModifiedDate,
	        i.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName
	FROM	dbo.AtulInstanceProcessSubProcessInteraction i
	JOIN	dbo.AtulUser cu ON i.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON i.ModifiedBy = mu.AtulUserID
	WHERE	i.AtulInstanceProcessID = @AtulInstanceProcessID
	AND	i.IsActive		= CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcessInteractionInsert_sp
(
	@AtulInstanceProcessID		BIGINT,
	@AtulProcessSubProcessID	BIGINT,
	@AtulServiceProviderID		BIGINT,
	@ActivityInteractionLabel	NVARCHAR(150),
	@ActivityInteractionIdentifer	NVARCHAR(150),
	@ActivityInteractionURL		NVARCHAR(150),
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now						DATETIME,
		@AtulInstanceProcessSubProcessInteractionID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulInstanceProcessSubProcessInteraction (
			AtulInstanceProcessID,
			AtulProcessSubProcessID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulInstanceProcessID,
			@AtulProcessSubProcessID,
			@AtulServiceProviderID,
			@ActivityInteractionLabel,
			@ActivityInteractionIdentifer,
			@ActivityInteractionURL,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulInstanceProcessSubProcessInteractionID = SCOPE_IDENTITY();

		INSERT	audit.AtulInstanceProcessSubProcessInteraction (
			AtulInstanceProcessSubProcessInteractionID,
			AtulInstanceProcessID,
			AtulProcessSubProcessID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessSubProcessInteractionID,
			AtulInstanceProcessID,
			AtulProcessSubProcessID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulInstanceProcessSubProcessInteraction WITH (NOLOCK)
		WHERE	AtulInstanceProcessSubProcessInteractionID = @AtulInstanceProcessSubProcessInteractionID;
	COMMIT TRAN;

	SELECT	@AtulInstanceProcessSubProcessInteractionID		AS AtulInstanceProcessSubProcessInteractionID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcessInteractionUpdate_sp
(
	@AtulInstanceProcessSubProcessInteractionID	BIGINT,
	@AtulInstanceProcessID				BIGINT,
	@AtulProcessSubProcessID			BIGINT,
	@AtulServiceProviderID				BIGINT,
	@ActivityInteractionLabel			NVARCHAR(150),
	@ActivityInteractionIdentifer			NVARCHAR(150),
	@ActivityInteractionURL				NVARCHAR(150),
	@ModifiedBy					BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	i
		SET	AtulInstanceProcessID		= @AtulInstanceProcessID,
			AtulProcessSubProcessID		= @AtulProcessSubProcessID,
			AtulServiceProviderID		= @AtulServiceProviderID,
			ActivityInteractionLabel	= @ActivityInteractionLabel,
			ActivityInteractionIdentifer	= @ActivityInteractionIdentifer,
			ActivityInteractionURL		= @ActivityInteractionURL,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcessSubProcessInteraction i
		WHERE	@AtulInstanceProcessSubProcessInteractionID	= @AtulInstanceProcessSubProcessInteractionID

		UPDATE	a
		SET	a.EndDate			= @now
		FROM	audit.AtulInstanceProcessSubProcessInteraction a
		WHERE	a.AtulInstanceProcessSubProcessInteractionID	= @AtulInstanceProcessSubProcessInteractionID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulInstanceProcessSubProcessInteraction (
			AtulInstanceProcessSubProcessInteractionID,
			AtulInstanceProcessID,
			AtulProcessSubProcessID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulInstanceProcessSubProcessInteractionID,
			AtulInstanceProcessID,
			AtulProcessSubProcessID,
			AtulServiceProviderID,
			ActivityInteractionLabel,
			ActivityInteractionIdentifer,
			ActivityInteractionURL,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulInstanceProcessSubProcessInteraction WITH (NOLOCK)
		WHERE	AtulInstanceProcessSubProcessInteractionID = @AtulInstanceProcessSubProcessInteractionID;
	COMMIT TRAN;
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessSubProcess_GetByID
(
	@AtulInstanceProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	DECLARE	@true	BIT;
	
	SET	@true	= CAST (1 AS BIT);
	
	SELECT	DISTINCT
		ipsp.AtulInstanceProcessSubProcessID		AS AtulInstanceProcessSubProcessID,
	        ipsp.AtulInstanceProcessID			AS AtulInstanceProcessID,
	        ipsp.AtulProcessSubprocessID			AS AtulProcessSubprocessID,
	        ipsp.InstanceProcessSubProcessCompleted		AS InstanceProcessSubProcessCompleted,
	        ipsp.InstanceProcessSubProcessDidNotApply	AS InstanceProcessSubProcessDidNotApply,
	        ipsp.InstanceProcessSubProcessDeadlineMissed	AS InstanceProcessSubProcessDeadlineMissed,
	        ipsp.CreatedDate				AS CreatedDate,
	        ipsp.CreatedBy					AS CreatedBy,
		cu.DisplayName					AS CreatedByName,
	        ipsp.ModifiedDate				AS ModifiedDate,
	        ipsp.ModifiedBy					AS ModifiedBy,
		mu.DisplayName					AS ModifiedByName,
	        ipsp.InstanceProcessSubProcessCompletedBy	AS InstanceProcessSubProcessCompletedBy,
		cb.DisplayName					AS InstanceProcessSubProcessCompletedByName,
	        ipsp.InstanceProcessSubProcessDeadline		AS InstanceProcessSubProcessDeadline,
	        p.AtulProcessID					AS AtulProcessID,
	        ip.OwnedBy					AS InstanceProcessOwnedById,
	        iob.DisplayName					AS InstanceProcessOwnedByName,
	        ip.AtulProcessStatusID				AS AtulProcessStatusID,
	        s.ProcessStatus					AS ProcessStatus,
		psp.AtulSubProcessID				AS AtulSubProcessID,
		sp.SubProcessDescription			AS SubProcessDescription,
		sp.SubProcessSummary				AS SubProcessSummary,
		sp.OwnedBy					AS OwnedBy,
		ob.DisplayName					AS OwnedByName,
		psp.ProcessSubprocessSortOrder			AS ProcessSubprocessSortOrder
	FROM	dbo.AtulInstanceProcessSubProcess ipsp
	JOIN	dbo.AtulProcessSubprocess psp ON ipsp.AtulProcessSubprocessID = psp.AtulProcessSubprocessID
					AND psp.IsActive = @true
	JOIN	dbo.AtulProcess p ON psp.AtulProcessID = p.AtulProcessID
					AND p.IsActive = @true
	JOIN	dbo.AtulInstanceProcess ip ON ipsp.AtulInstanceProcessID = ip.AtulInstanceProcessID
					AND ip.IsActive = @true
	JOIN	dbo.AtulSubProcess sp ON psp.AtulSubProcessID = sp.AtulSubProcessID
					AND sp.IsActive = @true
	JOIN	dbo.AtulProcessStatus s ON ip.AtulProcessStatusID = s.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON ipsp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON ipsp.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser iob ON ip.OwnedBy = iob.AtulUserID
	JOIN	dbo.AtulUser ob ON sp.OwnedBy = ob.AtulUserID
	LEFT JOIN dbo.AtulUser cb ON ipsp.InstanceProcessSubProcessCompletedBy = cb.AtulUserID
	WHERE	ipsp.AtulInstanceProcessID	= @AtulInstanceProcessID
	AND	ipsp.IsActive			= @true
	ORDER BY psp.ProcessSubprocessSortOrder;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessUnDelete_sp
(
	@AtulInstanceProcessID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 1 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulInstanceProcess ag
		WHERE	ag.AtulInstanceProcessID	= @AtulInstanceProcessID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulInstanceProcess aga
		WHERE	aga.AtulInstanceProcessID	= @AtulInstanceProcessID
		AND	EndDate IS NULL;
		
		INSERT	audit.AtulInstanceProcess (
			AtulInstanceProcessID,
			AtulProcessID,
			CreatedBy,
			OwnedBy,
			AtulProcessStatusID,
			ModifiedBy,
			StartDate,
			SubjectIdentifier,
			SubjectSummary,
			InstanceProcessProcessCompleted,
			InstanceProcessProcessDeadlineMissed,
			SubjectServiceProviderID )
		SELECT	AtulInstanceProcessID,
		        AtulProcessID,
		        CreatedBy,
		        OwnedBy,
		        AtulProcessStatusID,
		        ModifiedBy,
		        @now,
		        SubjectIdentifier,
		        SubjectSummary,
		        InstanceProcessProcessCompleted,
		        InstanceProcessProcessDeadlineMissed,
		        SubjectServiceProviderID
		FROM	dbo.AtulInstanceProcess WITH (NOLOCK)
		WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_InstanceProcessUpdate_sp
(
	@AtulInstanceProcessID		BIGINT,
	@AtulProcessID			BIGINT,
	@ModifiedBy			BIGINT,
	@OwnedBy			BIGINT,
	@AtulProcessStatusID		INT,
	@SubjectIdentifier		NVARCHAR(50),
	@SubjectSummary			NVARCHAR(255),
	@SubjectServiceProviderID	BIGINT = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ip
		SET	AtulProcessID			= @AtulProcessID,
			OwnedBy				= @OwnedBy,
			AtulProcessStatusID		= @AtulProcessStatusID,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy,
			SubjectIdentifier		= @SubjectIdentifier,
			SubjectSummary			= @SubjectSummary,
			SubjectServiceProviderID	= COALESCE(@SubjectServiceProviderID, ip.SubjectServiceProviderID)
		FROM	dbo.AtulInstanceProcess ip WITH (ROWLOCK)
		WHERE	ip.AtulInstanceProcessID = @AtulInstanceProcessID;

		UPDATE	aip
		SET	aip.EndDate		= @now
		FROM	audit.AtulInstanceProcess aip WITH (ROWLOCK)
		WHERE	aip.AtulInstanceProcessID = @AtulInstanceProcessID
		AND	aip.EndDate	IS NULL;

		INSERT	audit.AtulInstanceProcess (
			AtulInstanceProcessID,
			AtulProcessID,
			CreatedBy,
			OwnedBy,
			AtulProcessStatusID,
			ModifiedBy,
			StartDate,
			SubjectIdentifier,
			SubjectSummary,
			SubjectServiceProviderID )
		SELECT	AtulInstanceProcessID,
		        AtulProcessID,
		        CreatedBy,
		        OwnedBy,
		        AtulProcessStatusID,
		        ModifiedBy,
		        @now,
		        SubjectIdentifier,
		        SubjectSummary,
		        SubjectServiceProviderID
		FROM	dbo.AtulInstanceProcess WITH (NOLOCK)
		WHERE	AtulInstanceProcessID = @AtulInstanceProcessID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityDelete_sp
(
	@AtulProcessActivityID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	pa
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulProcessActivity pa
		WHERE	pa.AtulProcessActivityID	= @AtulProcessActivityID;
		
		UPDATE	paa
		SET	EndDate				= @now
		FROM	audit.AtulProcessActivity paa
		WHERE	paa.AtulProcessActivityID	= @AtulProcessActivityID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityGetByID_sp
(
	@AtulProcessActivityID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	pa.AtulProcessActivityID		AS AtulProcessActivityID,
		pa.AtulProcessID			AS AtulProcessID,
		pa.AtulActivityID			AS AtulActivityID,
		pa.ProcessActivitySortOrder		AS ProcessActivitySortOrder,
		pa.AutomationServiceProviderID		AS AutomationServiceProviderID,
		pa.AutomationIdentifier			AS AutomationIdentifier,
		pa.AutomationExpectedDuration		AS AutomationExpectedDuration,
		pa.PrerequisiteActivityGroupID		AS PrerequisiteActivityGroupID,
		pa.AtulDeadlineTypeID			AS AtulDeadlineTypeID,
		pa.DeadlineActivityGroupID		AS DeadlineActivityGroupID,
		pa.DeadlineResultsInMissed		AS DeadlineResultsInMissed,
		pa.CreatedDate				AS CreatedDate,
		pa.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		pa.ModifiedDate				AS ModifiedDate,
		pa.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName
	FROM	dbo.AtulProcessActivity pa
	JOIN	dbo.AtulUser cu ON pa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON pa.ModifiedBy = mu.AtulUserID
	WHERE	pa.AtulProcessActivityID = @AtulProcessActivityID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityGetByProcessIDActivityID_sp
(
	@AtulProcessID	BIGINT,
	@AtulActivityID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT 	apa.AtulProcessActivityID		AS AtulProcessActivityID,
		apa.AtulProcessID			AS AtulProcessID,
		apa.AtulActivityID			AS AtulActivityID,
		apa.ProcessActivitySortOrder		AS ProcessActivitySortOrder,
		apa.AutomationServiceProviderID		AS AutomationServiceProviderID,
		apa.AutomationIdentifier		AS AutomationIdentifier,
		apa.AutomationTriggerActivityGroupID	AS AutomationTriggerActivityGroupID,
		apa.AutomationExpectedDuration		AS AutomationExpectedDuration,
		apa.PrerequisiteActivityGroupID		AS PrerequisiteActivityGroupID,
		apa.AtulDeadlineTypeID			AS AtulDeadlineTypeID,
		apa.DeadlineActivityGroupID		AS DeadlineActivityGroupID,
		apa.DeadlineResultsInMissed		AS DeadlineResultsInMissed,
		apa.DeadlineOffset			AS DeadlineOffset,
		apa.CreatedDate				AS CreatedDate,
		apa.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		apa.ModifiedDate			AS ModifiedDate,
		apa.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulProcessActivity apa
	JOIN	dbo.AtulUser cu ON apa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON apa.ModifiedBy = mu.AtulUserID
	WHERE	apa.AtulProcessID	= @AtulProcessID
	AND	apa.AtulActivityID	= @AtulActivityID
	AND	apa.IsActive = CAST ( 1 AS BIT )
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	pa.AtulProcessActivityID		AS AtulProcessActivityID,
		pa.AtulProcessID			AS AtulProcessID,
		pa.AtulActivityID			AS AtulActivityID,
		pa.ProcessActivitySortOrder		AS ProcessActivitySortOrder,
		pa.AutomationServiceProviderID		AS AutomationServiceProviderID,
		pa.AutomationIdentifier			AS AutomationIdentifier,
		pa.AutomationExpectedDuration		AS AutomationExpectedDuration,
		pa.PrerequisiteActivityGroupID		AS PrerequisiteActivityGroupID,
		pa.AtulDeadlineTypeID			AS AtulDeadlineTypeID,
		pa.DeadlineActivityGroupID		AS DeadlineActivityGroupID,
		pa.DeadlineResultsInMissed		AS DeadlineResultsInMissed,
		pa.CreatedDate				AS CreatedDate,
		pa.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		pa.ModifiedDate				AS ModifiedDate,
		pa.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName
	FROM	dbo.AtulProcessActivity pa
	JOIN	dbo.AtulUser cu ON pa.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON pa.ModifiedBy = mu.AtulUserID
	WHERE	pa.IsActive = CAST ( 1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityInsert_sp
(
	@AtulProcessID				BIGINT,
	@AtulActivityID				BIGINT,
	@ProcessActivitySortOrder		INT,
	@AutomationServiceProviderID		BIGINT		= NULL,
	@AutomationTriggerActivityGroupID	BIGINT		= NULL,
	@AutomationIdentifier			NVARCHAR(50)	= NULL,
	@AutomationExpectedDuration		INT		= NULL,
	@PrerequisiteActivityGroupID		BIGINT,
	@AtulDeadlineTypeID			BIGINT,
	@DeadlineActivityGroupID		BIGINT	= NULl,
	@DeadlineResultsInMissed		BIT,
	@DeadlineOffset				INT,
	@CreatedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME,
		@AtulProcessActivityID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulProcessActivity (
			AtulProcessID,
			AtulActivityID,
			ProcessActivitySortOrder,
			AutomationServiceProviderID,
			AutomationIdentifier,
			AutomationTriggerActivityGroupID,
			AutomationExpectedDuration,
			PrerequisiteActivityGroupID,
			AtulDeadlineTypeID,
			DeadlineActivityGroupID,
			DeadlineResultsInMissed,
			DeadlineOffset,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulProcessID,
			@AtulActivityID,
			@ProcessActivitySortOrder,
			@AutomationServiceProviderID,
			@AutomationIdentifier,
			@AutomationTriggerActivityGroupID,
			@AutomationExpectedDuration,
			@PrerequisiteActivityGroupID,
			@AtulDeadlineTypeID,
			@DeadlineActivityGroupID,
			@DeadlineResultsInMissed,
			@DeadlineOffset,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulProcessActivityID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulProcessActivity (
			AtulProcessActivityID,
			AtulProcessID,
			AtulActivityID,
			ProcessActivitySortOrder,
			AutomationServiceProviderID,
			AutomationIdentifier,
			AutomationTriggerActivityGroupID,
			AutomationExpectedDuration,
			PrerequisiteActivityGroupID,
			AtulDeadlineTypeID,
			DeadlineActivityGroupID,
			DeadlineResultsInMissed,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessActivityID,
		        AtulProcessID,
		        AtulActivityID,
		        ProcessActivitySortOrder,
		        AutomationServiceProviderID,
		        AutomationIdentifier,
			AutomationTriggerActivityGroupID,
		        AutomationExpectedDuration,
		        PrerequisiteActivityGroupID,
		        AtulDeadlineTypeID,
		        DeadlineActivityGroupID,
		        DeadlineResultsInMissed,
		        DeadlineOffset,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulProcessActivity WITH (NOLOCK)
		WHERE	AtulProcessActivityID = @AtulProcessActivityID;
	COMMIT TRAN;

	SELECT	@AtulProcessActivityID		AS AtulProcessActivityID;
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessActivityUpdate_sp
(
	@AtulProcessActivityID			BIGINT,
	@AtulProcessID				BIGINT,
	@AtulActivityID				BIGINT,
	@ProcessActivitySortOrder		INT,
	@AutomationServiceProviderID		BIGINT		= NULL,
	@AutomationTriggerActivityGroupID	BIGINT		= NULL,
	@AutomationIdentifier			NVARCHAR(50)	= NULL,
	@AutomationExpectedDuration		INT		= NULL,
	@PrerequisiteActivityGroupID		BIGINT		= NULL,
	@AtulDeadlineTypeID			BIGINT		= NULL,
	@DeadlineActivityGroupID		BIGINT		= NULL,
	@DeadlineResultsInMissed		BIT,
	@DeadlineOffset				INT,
	@ModifiedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	pa
		SET	pa.AtulProcessID			= @AtulProcessID,
			pa.AtulActivityID			= @AtulActivityID,
			pa.ProcessActivitySortOrder		= @ProcessActivitySortOrder,
			pa.AutomationServiceProviderID		= @AutomationServiceProviderID,
			pa.AutomationTriggerActivityGroupID	= @AutomationTriggerActivityGroupID,
			pa.AutomationIdentifier			= @AutomationIdentifier,
			pa.AutomationExpectedDuration		= @AutomationExpectedDuration,
			pa.PrerequisiteActivityGroupID		= @PrerequisiteActivityGroupID,
			pa.AtulDeadlineTypeID			= @AtulDeadlineTypeID,
			pa.DeadlineActivityGroupID		= @DeadlineActivityGroupID,
			pa.DeadlineResultsInMissed		= @DeadlineResultsInMissed,
			pa.DeadlineOffset			= @DeadlineOffset,
			pa.ModifiedDate				= @now,
			pa.ModifiedBy				= @ModifiedBy
		FROM	dbo.AtulProcessActivity pa WITH (ROWLOCK)
		WHERE	pa.AtulProcessActivityID	= @AtulProcessActivityID;

		UPDATE	apaa
		SET	apaa.EndDate			= @now
		FROM	audit.AtulProcessActivity apaa WITH (ROWLOCK)
		WHERE	apaa.AtulProcessActivityID	= @AtulProcessActivityID
		AND	apaa.EndDate IS NULL;
		
		INSERT	audit.AtulProcessActivity (
			AtulProcessActivityID,
			AtulProcessID,
			AtulActivityID,
			ProcessActivitySortOrder,
			AutomationServiceProviderID,
			AutomationIdentifier,
			AutomationTriggerActivityGroupID,
			AutomationExpectedDuration,
			PrerequisiteActivityGroupID,
			AtulDeadlineTypeID,
			DeadlineActivityGroupID,
			DeadlineResultsInMissed,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessActivityID,
		        AtulProcessID,
		        AtulActivityID,
		        ProcessActivitySortOrder,
		        AutomationServiceProviderID,
		        AutomationIdentifier,
			AutomationTriggerActivityGroupID,
		        AutomationExpectedDuration,
		        PrerequisiteActivityGroupID,
		        AtulDeadlineTypeID,
		        DeadlineActivityGroupID,
		        DeadlineResultsInMissed,
		        DeadlineOffset,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulProcessActivity WITH (NOLOCK)
		WHERE	AtulProcessActivityID = @AtulProcessActivityID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessDelete_sp
(
	@AtulProcessID	BIGINT,
	@ModifiedBy	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME
	
	SET	@now	= GETUTCDATE()
	
	BEGIN TRAN;
		UPDATE	p
		SET	p.IsActive	= CAST ( 0 AS BIT ),
			p.ModifiedDate	= @now,
			p.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulProcess p 
		WHERE	p.AtulProcessID = @AtulProcessID;
		
		UPDATE	audit.AtulProcess
		SET	EndDate		= @now
		WHERE	AtulProcessID	= @AtulProcessID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessGetByProcessID_sp
(
	@AtulProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	p.AtulProcessID			AS AtulProcessID,
		p.ProcessDescription		AS ProcessDescription,
		p.ProcessSummary		AS ProcessSummary,
		p.AtulProcessStatusID		AS AtulProcessStatusID,
		s.ProcessStatus			AS ProcessStatus,
		p.DeadLineOffset		AS DeadLineOffset,
		p.CreatedDate			AS CreatedDate,
		p.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
		p.ModifiedDate			AS ModifiedDate,
		p.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		p.OwnedBy			AS OwnedBy,
		ou.DisplayName			AS OwnedByName,
		p.IsActive			AS IsActive,
		p.SubjectServiceProviderID	AS SubjectServiceProviderID,
		p.SubjectScopeIdentifier	AS SubjectScopeIdentifier
	FROM	dbo.AtulProcess p
	JOIN	dbo.AtulProcessStatus s ON p.AtulProcessStatusID = s.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON p.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON p.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON p.OwnedBy = ou.AtulUserID
	WHERE	p.AtulProcessID = @AtulProcessID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessGetByProcessSummary_sp
(
	@ProcessSummary	NVARCHAR(500)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	p.AtulProcessID			AS AtulProcessID,
		p.ProcessDescription		AS ProcessDescription,
		p.ProcessSummary		AS ProcessSummary,
		p.AtulProcessStatusID		AS AtulProcessStatusID,
		s.ProcessStatus			AS ProcessStatus,
		p.DeadLineOffset		AS DeadLineOffset,
		p.CreatedDate			AS CreatedDate,
		p.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
		p.ModifiedDate			AS ModifiedDate,
		p.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		p.OwnedBy			AS OwnedBy,
		ou.DisplayName			AS OwnedByName,
		p.IsActive			AS IsActive,
		p.SubjectServiceProviderID	AS SubjectServiceProviderID,
		p.SubjectScopeIdentifier	AS SubjectScopeIdentifier
	FROM	dbo.AtulProcess p
	JOIN	dbo.AtulProcessStatus s ON p.AtulProcessStatusID = s.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON p.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON p.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON p.OwnedBy = ou.AtulUserID
	WHERE	p.ProcessSummary = @ProcessSummary
	AND	p.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessGetDeleted_sp
(
	@startdate	DATETIME
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	p.AtulProcessID			AS AtulProcessID,
		p.ProcessDescription		AS ProcessDescription,
		p.ProcessSummary		AS ProcessSummary,
		p.AtulProcessStatusID		AS AtulProcessStatusID,
		s.ProcessStatus			AS ProcessStatus,
		p.DeadLineOffset		AS DeadLineOffset,
		p.CreatedDate			AS CreatedDate,
		p.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
		p.ModifiedDate			AS ModifiedDate,
		p.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		p.OwnedBy			AS OwnedBy,
		ou.DisplayName			AS OwnedByName,
		p.IsActive			AS IsActive,
		p.SubjectServiceProviderID	AS SubjectServiceProviderID
	FROM	dbo.AtulProcess p
	JOIN	dbo.AtulProcessStatus s ON p.AtulProcessStatusID = s.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON p.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON p.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON p.OwnedBy = ou.AtulUserID
	WHERE	p.IsActive = CAST ( 0 AS BIT )
	AND	( @startdate IS NULL OR p.ModifiedDate >= @startdate);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	p.AtulProcessID			AS AtulProcessID,
		p.ProcessDescription		AS ProcessDescription,
		p.ProcessSummary		AS ProcessSummary,
		p.AtulProcessStatusID		AS AtulProcessStatusID,
		s.ProcessStatus			AS ProcessStatus,
		p.CreatedDate			AS CreatedDate,
		p.CreatedBy			AS CreatedBy,
		cu.DisplayName			AS CreatedByName,
		p.ModifiedDate			AS ModifiedDate,
		p.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		p.OwnedBy			AS OwnedBy,
		ou.DisplayName			AS OwnedByName,
		p.IsActive			AS IsActive,
		p.SubjectServiceProviderID	AS SubjectServiceProviderID,
		p.SubjectScopeIdentifier	AS SubjectScopeIdentifier
	FROM	dbo.AtulProcess p
	JOIN	dbo.AtulProcessStatus s ON p.AtulProcessStatusID = s.AtulProcessStatusID
	JOIN	dbo.AtulUser cu ON p.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON p.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON p.OwnedBy = ou.AtulUserID
	WHERE	p.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessInsert_sp
(
	@ProcessDescription		NVARCHAR(256),
	@ProcessSummary			NVARCHAR(500),
	@CreatedBy			BIGINT,
	@OwnedBy			BIGINT,
	@AtulProcessStatusID		INT,
	@DeadLineOffset			INT,
	@SubjectServiceProviderID	BIGINT = NULL,
	@SubjectScopeIdentifier		NVARCHAR(255) = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@active			BIT,
		@AtulProcessID		BIGINT,
		@now			DATETIME;

	SET	@now	= GETUTCDATE();
	SET	@active	= CAST (0 AS BIT);
	
	SELECT	@active			= a.IsActive
	FROM	dbo.AtulProcess a
	WHERE	a.ProcessSummary	= @ProcessSummary
	AND	a.IsActive = CAST (1 AS BIT);
	
	-- if there is already an active process, error.
	IF @active = CAST ( 1 AS BIT )
	BEGIN;
		RAISERROR ('A Process with that name already exists.'
				,15
				,-1		-- Return error text'
				);

		RETURN	-1;			-- Return retcode
	END;
	
	IF (@ProcessSummary = '' )
	BEGIN;
		RAISERROR ('Process name can not be blank.'
				,15
				,-1		-- Return error text'
				);

		RETURN	-1;			-- Return retcode
	END;
	
	
	BEGIN TRAN;
		INSERT	dbo.AtulProcess (
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			OwnedBy,
			IsActive,
			SubjectServiceProviderID,
			SubjectScopeIdentifier )
		SELECT	@ProcessDescription,
			@ProcessSummary,
			@AtulProcessStatusID,
			@DeadLineOffset,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@OwnedBy,
			CAST ( 1 AS BIT),
			@SubjectServiceProviderID,
			@SubjectScopeIdentifier;

		SET	@AtulProcessID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulProcess (
			AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate,
			SubjectServiceProviderID,
			SubjectScopeIdentifier )
		SELECT	AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now,
			SubjectServiceProviderID,
			SubjectScopeIdentifier
		FROM	dbo.AtulProcess WITH (NOLOCK)
		WHERE	AtulProcessID = @AtulProcessID;
	COMMIT TRAN;

	SELECT	@AtulProcessID			AS AtulProcessID;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleDeleteByProcessId_sp
(
	@AtulProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE @holding AS TABLE (
		AtulProcessScheduleID BIGINT,
		PRIMARY KEY CLUSTERED (AtulProcessScheduleID) )

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	s
		SET	IsActive	= CAST (0 AS BIT)
		OUTPUT	INSERTED.AtulProcessScheduleID
		INTO	@holding ( AtulProcessScheduleID)
		FROM	dbo.AtulProcessSchedule s
		WHERE	AtulProcessID	= @AtulProcessID
		AND	IsActive	= CAST (1 AS BIT);
	
		UPDATE	a
		SET	a.EndDate	= @now
		FROM	audit.AtulProcessSchedule a
		JOIN	@holding x ON a.AtulProcessScheduleID = x.AtulProcessScheduleID
		WHERE	a.AtulProcessID	= @AtulProcessID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulProcessSchedule (
			AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			StartDate,
			InstantiatedUserList )
		SELECT	s.AtulProcessScheduleID,
			s.AtulProcessID,
			s.RepeatSchedule,
			s.LastInstantiated,
			s.NextScheduledDate,
			s.ScheduleVersion,
			s.IsActive,
			s.CreatedDate,
			@now,
			InstantiatedUserList
		FROM	dbo.AtulProcessSchedule s WITH (NOLOCK)
		JOIN	@holding x ON s.AtulProcessScheduleID = x.AtulProcessScheduleID
		WHERE	s.AtulProcessID = @AtulProcessID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleDelete_sp
(
	@AtulProcessScheduleID	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	s
		SET	IsActive	= CAST (0 AS BIT)
		FROM	dbo.AtulProcessSchedule s
		WHERE	AtulProcessScheduleID	= @AtulProcessScheduleID;
	
		UPDATE	a
		SET	a.EndDate	= @now
		FROM	audit.AtulProcessSchedule a
		WHERE	a.AtulProcessScheduleID	= @AtulProcessScheduleID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulProcessSchedule (
			AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			StartDate,
			InstantiatedUserList )
		SELECT	AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			@now,
			InstantiatedUserList
		FROM	dbo.AtulProcessSchedule WITH (NOLOCK)
		WHERE	AtulProcessScheduleID = @AtulProcessScheduleID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleGetByID_sp
(
	@AtulProcessScheduleID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	AtulProcessScheduleID,
		AtulProcessID,
		RepeatSchedule,
		LastInstantiated,
		NextScheduledDate,
		ScheduleVersion,
		InstantiatedUserList
	FROM	dbo.AtulProcessSchedule s
	WHERE	s.AtulProcessScheduleID = @AtulProcessScheduleID
	AND	s.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleGetByProcessId_sp
(
	@AtulProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	AtulProcessScheduleID,
		AtulProcessID,
		RepeatSchedule,
		LastInstantiated,
		NextScheduledDate,
		ScheduleVersion,
		InstantiatedUserList
	FROM	dbo.AtulProcessSchedule s
	WHERE	s.AtulProcessID = @AtulProcessID
	AND	s.IsActive = CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleInsert_sp
(
	@AtulProcessID		BIGINT,
	@RepeatSchedule		NVARCHAR(100),
	@NextScheduledDate	DATETIME,
	@ScheduleVersion	NVARCHAR(150),
	@InstantiatedUserList	NVARCHAR(MAX) = NULL
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME,
		@AtulProcessScheduleID	BIGINT,
		@active			BIT;

	SET	@now	= GETUTCDATE();
	SET	@AtulProcessScheduleID = NULL;

	-- Only 1 schedule per ProcessID allowed.
	SELECT	@AtulProcessScheduleID	= AtulProcessScheduleID
	FROM	dbo.AtulProcessSchedule s
	WHERE	s.AtulProcessID		= @AtulProcessID;

	BEGIN TRAN;
		IF ( @AtulProcessScheduleID IS NULL )
		BEGIN;
			INSERT	dbo.AtulProcessSchedule (
				AtulProcessID,
				RepeatSchedule,
				NextScheduledDate,
				ScheduleVersion,
				IsActive,
				CreatedDate,
				ModifiedDate,
				InstantiatedUserList )
			SELECT	@AtulProcessID,
				@RepeatSchedule,
				@NextScheduledDate,
				@ScheduleVersion,
				CAST (1 AS BIT),
				@now,
				@now,
				@InstantiatedUserList;

			SET	@AtulProcessScheduleID	= SCOPE_IDENTITY();
	
			INSERT	audit.AtulProcessSchedule (
				AtulProcessScheduleID,
				AtulProcessID,
				RepeatSchedule,
				LastInstantiated,
				NextScheduledDate,
				ScheduleVersion,
				IsActive,
				CreatedDate,
				StartDate,
				InstantiatedUserList )
			SELECT	AtulProcessScheduleID,
				AtulProcessID,
				RepeatSchedule,
				LastInstantiated,
				NextScheduledDate,
				ScheduleVersion,
				IsActive,
				CreatedDate,
				@now,
				InstantiatedUserList
			FROM	dbo.AtulProcessSchedule
			WHERE	AtulProcessScheduleID = @AtulProcessScheduleID;
		END;
		ELSE
		BEGIN;
			UPDATE	s
			SET	s.ScheduleVersion	= @ScheduleVersion,
				s.NextScheduledDate	= @NextScheduledDate,
				s.RepeatSchedule	= @RepeatSchedule,
				s.InstantiatedUserList	= COALESCE(@InstantiatedUserList, InstantiatedUserList),
				s.IsActive		= CAST (1 AS BIT)
			FROM	dbo.AtulProcessSchedule s
			WHERE	AtulProcessScheduleID	= @AtulProcessScheduleID;
	
			UPDATE	a
			SET	a.EndDate	= @now
			FROM	audit.AtulProcessSchedule a
			WHERE	a.AtulProcessScheduleID	= @AtulProcessScheduleID
			AND	a.EndDate IS NULL;

			INSERT	audit.AtulProcessSchedule (
				AtulProcessScheduleID,
				AtulProcessID,
				RepeatSchedule,
				LastInstantiated,
				NextScheduledDate,
				ScheduleVersion,
				IsActive,
				CreatedDate,
				StartDate,
				InstantiatedUserList )
			SELECT	AtulProcessScheduleID,
				AtulProcessID,
				RepeatSchedule,
				LastInstantiated,
				NextScheduledDate,
				ScheduleVersion,
				IsActive,
				CreatedDate,
				@now,
				InstantiatedUserList
			FROM	dbo.AtulProcessSchedule
			WHERE	AtulProcessScheduleID = @AtulProcessScheduleID;
		END;
		
		SELECT	@AtulProcessScheduleID AS AtulProcessScheduleID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleUpdateVersion_sp
(
	@AtulProcessScheduleID	BIGINT,
	@ScheduleVersion	NVARCHAR(150)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	s
		SET	ScheduleVersion = @ScheduleVersion
		FROM	dbo.AtulProcessSchedule s
		WHERE	AtulProcessScheduleID	= @AtulProcessScheduleID;
	
		UPDATE	a
		SET	a.EndDate	= @now
		FROM	audit.AtulProcessSchedule a
		WHERE	a.AtulProcessScheduleID	= @AtulProcessScheduleID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulProcessSchedule (
			AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			StartDate,
			InstantiatedUserList )
		SELECT	AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			@now,
			InstantiatedUserList
		FROM	dbo.AtulProcessSchedule WITH (NOLOCK)
		WHERE	AtulProcessScheduleID = @AtulProcessScheduleID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessScheduleUpdate_sp
(
	@AtulProcessScheduleID	BIGINT,
	@ScheduleVersion	NVARCHAR(150),
	@LastInstantiated	DATETIME = NULL,
	@NextScheduledDate	DATETIME,
	@RepeatSchedule		NVARCHAR(100),
	@InstantiatedUserList	NVARCHAR(MAX) = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	s
		SET	s.ScheduleVersion	= @ScheduleVersion,
			s.LastInstantiated	= COALESCE(@LastInstantiated, LastInstantiated),
			s.NextScheduledDate	= @NextScheduledDate,
			s.RepeatSchedule	= @RepeatSchedule,
			s.InstantiatedUserList	= COALESCE(@InstantiatedUserList, InstantiatedUserList)
		FROM	dbo.AtulProcessSchedule s
		WHERE	AtulProcessScheduleID	= @AtulProcessScheduleID;
	
		UPDATE	a
		SET	a.EndDate	= @now
		FROM	audit.AtulProcessSchedule a
		WHERE	a.AtulProcessScheduleID	= @AtulProcessScheduleID
		AND	a.EndDate IS NULL;

		INSERT	audit.AtulProcessSchedule (
			AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			StartDate,
			InstantiatedUserList )
		SELECT	AtulProcessScheduleID,
			AtulProcessID,
			RepeatSchedule,
			LastInstantiated,
			NextScheduledDate,
			ScheduleVersion,
			IsActive,
			CreatedDate,
			@now,
			InstantiatedUserList
		FROM	dbo.AtulProcessSchedule WITH (NOLOCK)
		WHERE	AtulProcessScheduleID = @AtulProcessScheduleID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessStatusGet_sp
AS
SET NOCOUNT ON;
BEGIN;
	SELECT	AtulProcessStatusID,
		ProcessStatus
	FROM	dbo.AtulProcessStatus
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessStatusInsert_sp
(
	@ProcessStatus		NVARCHAR(50)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@active			BIT,
		@now			DATETIME,
		@AtulProcessStatusID	INT;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		INSERT	dbo.AtulProcessStatus (
			ProcessStatus )
		SELECT	@ProcessStatus;

		SET	@AtulProcessStatusID = SCOPE_IDENTITY();
	COMMIT TRAN;

	SELECT	@AtulProcessStatusID		AS AtulProcessStatusID;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessDelete_sp
(
	@AtulProcessSubprocessID	BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	psp
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulProcessSubprocess psp
		WHERE	psp.AtulProcessSubprocessID	= @AtulProcessSubprocessID;
		
		UPDATE	psa
		SET	EndDate				= @now
		FROM	audit.AtulProcessSubprocess psa
		WHERE	psa.AtulProcessSubprocessID	= @AtulProcessSubprocessID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessGetByID_sp
(
	@AtulProcessSubprocessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulProcessSubprocessID	AS AtulProcessSubprocessID,
	        sp.AtulProcessID		AS AtulProcessID,
	        sp.AtulSubProcessID		AS AtulSubProcessID,
	        sp.ProcessSubprocessSortOrder	AS ProcessSubprocessSortOrder,
	        sp.NotificationServiceProviderID	AS NotificationServiceProviderID,
	        sp.NotificationIdentifier	AS NotificationIdentifier,
	        sp.ResponsibilityOf		AS ResponsibilityOf,
	        ru.DisplayName			AS ResponsibilityOfName,
	        sp.CreatedDate			AS CreatedDate,
	        sp.CreatedBy			AS CreatedBy,
	        sp.ModifiedDate			AS ModifiedDate,
	        sp.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		cu.DisplayName			AS CreatedByName
	FROM	dbo.AtulProcessSubprocess sp
	JOIN	dbo.AtulUser ru ON sp.ResponsibilityOf = ru.AtulUserID
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.AtulProcessSubprocessID = @AtulProcessSubprocessID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessGetByProcessIDSubProcessID_sp
(
	@AtulProcessID		BIGINT,
	@AtulSubProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulProcessSubprocessID	AS AtulProcessSubprocessID,
	        sp.AtulProcessID		AS AtulProcessID,
	        sp.AtulSubProcessID		AS AtulSubProcessID,
	        sp.ProcessSubprocessSortOrder	AS ProcessSubprocessSortOrder,
	        sp.NotificationServiceProviderID	AS NotificationServiceProviderID,
	        sp.NotificationIdentifier	AS NotificationIdentifier,
	        sp.DeadlineOffset		AS DeadlineOffset,
	        sp.ResponsibilityOf		AS ResponsibilityOf,
	        ru.DisplayName			AS ResponsibilityOfName,
	        sp.CreatedDate			AS CreatedDate,
	        sp.CreatedBy			AS CreatedBy,
	        sp.ModifiedDate			AS ModifiedDate,
	        sp.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		cu.DisplayName			AS CreatedByName
	FROM	dbo.AtulProcessSubprocess sp
	JOIN	dbo.AtulUser ru ON sp.ResponsibilityOf = ru.AtulUserID
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.AtulProcessID	= @AtulProcessID
	AND	sp.AtulSubProcessID	= @AtulSubProcessID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulProcessSubprocessID	AS AtulProcessSubprocessID,
	        sp.AtulProcessID		AS AtulProcessID,
	        sp.AtulSubProcessID		AS AtulSubProcessID,
	        sp.ProcessSubprocessSortOrder	AS ProcessSubprocessSortOrder,
	        sp.NotificationServiceProviderID	AS NotificationServiceProviderID,
	        sp.NotificationIdentifier	AS NotificationIdentifier,
	        sp.ResponsibilityOf		AS ResponsibilityOf,
	        ru.DisplayName			AS ResponsibilityOfName,
	        sp.CreatedDate			AS CreatedDate,
	        sp.CreatedBy			AS CreatedBy,
	        sp.ModifiedDate			AS ModifiedDate,
	        sp.ModifiedBy			AS ModifiedBy,
		mu.DisplayName			AS ModifiedByName,
		cu.DisplayName			AS CreatedByName
	FROM	dbo.AtulProcessSubprocess sp
	JOIN	dbo.AtulUser ru ON sp.ResponsibilityOf = ru.AtulUserID
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessInsert_sp
(
	@AtulProcessID			BIGINT,
	@AtulSubProcessID		BIGINT,
	@ProcessSubprocessSortOrder	INT,
	@NotificationServiceProviderID	BIGINT = NULL,
	@NotificationIdentifier		NVARCHAR(100) = NULL,
	@ResponsibilityOf		BIGINT,
	@DeadlineOffset			INT,
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulProcessSubprocessID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulProcessSubprocess (
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@AtulProcessID,
			@AtulSubProcessID,
			@ProcessSubprocessSortOrder,
			@NotificationServiceProviderID,
			@NotificationIdentifier,
			@ResponsibilityOf,
			@DeadlineOffset,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );		-- IsActive

		SET	@AtulProcessSubprocessID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulProcessSubprocess (
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulProcessSubprocess WITH (NOLOCK)
		WHERE	AtulProcessSubprocessID = @AtulProcessSubprocessID;
	COMMIT TRAN;

	SELECT	@AtulProcessSubprocessID		AS AtulProcessSubprocessID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessSortOrderUpdate_sp
(
	@AtulProcessSubprocessID	BIGINT,
	@ProcessSubprocessSortOrder	INT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now			DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	psp
		SET	psp.ProcessSubprocessSortOrder	= @ProcessSubprocessSortOrder,
			psp.ModifiedBy			= @ModifiedBy,
			psp.ModifiedDate		= @now
		FROM	dbo.AtulProcessSubprocess psp
		WHERE	psp.AtulProcessSubprocessID	= @AtulProcessSubprocessID;
		
		UPDATE	apsp
		SET	apsp.EndDate			= @now
		FROM	audit.AtulProcessSubprocess apsp
		WHERE	apsp.AtulProcessSubprocessID	= @AtulProcessSubprocessID
		AND	apsp.EndDate	IS NULL;
		
		INSERT	audit.AtulProcessSubprocess (
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
		        @now
		FROM	dbo.AtulProcessSubprocess apsp WITH (NOLOCK)
		WHERE	apsp.AtulProcessSubprocessID	= @AtulProcessSubprocessID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessSubprocessUpdate_sp
(
	@AtulProcessSubprocessID	BIGINT,
	@AtulProcessID			BIGINT,
	@AtulSubProcessID		BIGINT,
	@ProcessSubprocessSortOrder	INT,
	@NotificationServiceProviderID	BIGINT = NULL,
	@NotificationIdentifier		NVARCHAR(100) = NULL,
	@ResponsibilityOf		BIGINT,
	@DeadlineOffset			INT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	psp
		SET	AtulProcessID			= @AtulProcessID,
			AtulSubProcessID		= @AtulSubProcessID,
			ProcessSubprocessSortOrder	= @ProcessSubprocessSortOrder,
			NotificationServiceProviderID	= @NotificationServiceProviderID,
			NotificationIdentifier		= @NotificationIdentifier,
			ResponsibilityOf		= @ResponsibilityOf,
			DeadlineOffset			= @DeadlineOffset,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulProcessSubprocess psp
		WHERE	psp.AtulProcessSubprocessID	= @AtulProcessSubprocessID;
		
		UPDATE	psa
		SET	EndDate				= @now
		FROM	audit.AtulProcessSubprocess psa
		WHERE	psa.AtulProcessSubprocessID	= @AtulProcessSubprocessID
		AND	EndDate IS NULL;

		INSERT	audit.AtulProcessSubprocess (
			AtulProcessSubprocessID,
			AtulProcessID,
			AtulSubProcessID,
			ProcessSubprocessSortOrder,
			NotificationServiceProviderID,
			NotificationIdentifier,
			ResponsibilityOf,
			DeadlineOffset,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulProcessSubprocessID,
		        AtulProcessID,
		        AtulSubProcessID,
		        ProcessSubprocessSortOrder,
		        NotificationServiceProviderID,
		        NotificationIdentifier,
		        ResponsibilityOf,
		        DeadlineOffset,
		        CreatedBy,
		        ModifiedBy,
		        @now
		FROM	dbo.AtulProcessSubprocess WITH (NOLOCK)
		WHERE	AtulProcessSubprocessID = @AtulProcessSubprocessID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessUnDelete_sp
(
	@AtulProcessID	BIGINT,
	@ModifiedBy	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now		DATETIME,
		@ProcessSummary	NVARCHAR(500),
		@existing	BIT,
		@true		INT;
	
	SET	@now		= GETUTCDATE();
	SET	@existing	= 0;
	SET	@true		= CAST (1 AS BIT)
	
	SELECT	@ProcessSummary = p.ProcessSummary
	FROM	dbo.AtulProcess p WITH (NOLOCK)
	WHERE	p.AtulProcessID = @AtulProcessID;
	
	SELECT	@existing	= 1
	FROM	dbo.AtulProcess p WITH (NOLOCK)
	WHERE	p.ProcessSummary = @ProcessSummary
	AND	p.IsActive	= @true;
	
	IF ( @existing = 1 )
	BEGIN;
		RAISERROR ('A Process with that name already exists.'
				,15
				,-1			-- Return error text'
				);

		RETURN	-1;			-- Return retcode
	END;
	
	BEGIN TRAN;
		UPDATE	p
		SET	p.IsActive	= @true,
			p.ModifiedDate	= @now,
			p.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulProcess p WITH (ROWLOCK)
		WHERE	p.AtulProcessID = @AtulProcessID;
		
		UPDATE	audit.AtulProcess
		SET	EndDate		= @now
		WHERE	AtulProcessID	= @AtulProcessID
		AND	EndDate IS NULL;
		
		INSERT	audit.AtulProcess (
			AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate,
			SubjectServiceProviderID )
		SELECT	AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now,
			SubjectServiceProviderID
		FROM	dbo.AtulProcess WITH (NOLOCK)
		WHERE	AtulProcessID = @AtulProcessID;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ProcessUpdate_sp
(
	@AtulProcessID			BIGINT,
	@ProcessDescription		NVARCHAR(256),
	@ProcessSummary			NVARCHAR(500),
	@ModifiedBy			BIGINT,
	@OwnedBy			BIGINT,
	@AtulProcessStatusID		INT,
	@DeadLineOffset			INT,
	@SubjectServiceProviderID	BIGINT,
	@SubjectScopeIdentifier		NVARCHAR(255)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	p
		SET	ProcessDescription			= @ProcessDescription,
			ProcessSummary				= @ProcessSummary,
			AtulProcessStatusID			= @AtulProcessStatusID,
			DeadLineOffset				= @DeadLineOffset,
			ModifiedDate				= @now,
			ModifiedBy					= @ModifiedBy,
			OwnedBy						= @OwnedBy,
			SubjectServiceProviderID	= @SubjectServiceProviderID,
			SubjectScopeIdentifier		= @SubjectScopeIdentifier
		FROM	dbo.AtulProcess p
		WHERE	p.AtulProcessID			= @AtulProcessID;

		UPDATE	pa
		SET	EndDate				= @now
		FROM	audit.AtulProcess pa
		WHERE	pa.AtulProcessID		= @AtulProcessID
		AND	EndDate IS NULL;
		
		INSERT	audit.AtulProcess (
			AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate,
			SubjectServiceProviderID,
			SubjectScopeIdentifier )
		SELECT	AtulProcessID,
			ProcessDescription,
			ProcessSummary,
			AtulProcessStatusID,
			DeadLineOffset,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now,
			SubjectServiceProviderID,
			SubjectScopeIdentifier
		FROM	dbo.AtulProcess
		WHERE	AtulProcessID = @AtulProcessID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_RemoteSystemDelete_sp
(
	@AtulRemoteSystemID	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	BEGIN TRAN;
		UPDATE	t
		SET	t.IsActive = CAST ( 0 AS BIT )
		FROM	dbo.AtulRemoteSystem t 
		WHERE	t.AtulRemoteSystemID = @AtulRemoteSystemID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_RemoteSystemGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	rs.AtulRemoteSystemID,
		rs.RemoteSystem,
		rs.IsActive
	FROM	dbo.AtulRemoteSystem rs;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_RemoteSystemInsert_sp
(
	@RemoteSystem		NVARCHAR(150)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@AtulRemoteSystemID	BIGINT;
	
	SELECT	@AtulRemoteSystemID = a.AtulRemoteSystemID
	FROM	dbo.AtulRemoteSystem a WITH (NOLOCK)
	WHERE	a.RemoteSystem = @RemoteSystem

	IF @AtulRemoteSystemID IS NULL
	BEGIN;
	BEGIN TRAN;

		INSERT	dbo.AtulRemoteSystem (
			RemoteSystem,
			IsActive )
		SELECT	@RemoteSystem,
			CAST (1 AS bit );

		SET	@AtulRemoteSystemID = SCOPE_IDENTITY();

	COMMIT TRAN;
	END;

	SELECT	@AtulRemoteSystemID		AS AtulRemoteSystemID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF (XACT_STATE() = -1 ) OR @@TRANCOUNT > 0
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderClassDelete_sp
(
	@AtulServiceProviderClassID	BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulServiceProviderClass ag
		WHERE	ag.AtulServiceProviderClassID	= @AtulServiceProviderClassID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulServiceProviderClass aga
		WHERE	aga.AtulServiceProviderClassID	= @AtulServiceProviderClassID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderClassGetByID_sp
(
	@AtulServiceProviderClassID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	spc.AtulServiceProviderClassID,
		spc.ServiceProviderClassName,
		spc.ServiceProviderClassDescription,
		spc.CreatedDate				AS CreatedDate,
		spc.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		spc.ModifiedDate				AS ModifiedDate,
		spc.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulServiceProviderClass spc
	JOIN	dbo.AtulUser cu ON spc.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON spc.ModifiedBy = mu.AtulUserID
	WHERE	spc.AtulServiceProviderClassID = @AtulServiceProviderClassID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderClassGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	spc.AtulServiceProviderClassID,
		spc.ServiceProviderClassName,
		spc.ServiceProviderClassDescription,
		spc.CreatedDate				AS CreatedDate,
		spc.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		spc.ModifiedDate				AS ModifiedDate,
		spc.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulServiceProviderClass spc
	JOIN	dbo.AtulUser cu ON spc.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON spc.ModifiedBy = mu.AtulUserID
	WHERE	spc.IsActive = CAST ( 1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderClassInsert_sp
(
	@ServiceProviderClassName		NVARCHAR(50),
	@ServiceProviderClassDescription	NVARCHAR(256),
	@CreatedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulServiceProviderClassID	BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulServiceProviderClass (
			ServiceProviderClassName,
			ServiceProviderClassDescription,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@ServiceProviderClassName,
			@ServiceProviderClassDescription,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT );

		SET	@AtulServiceProviderClassID = SCOPE_IDENTITY();

		INSERT	audit.AtulServiceProviderClass (
			AtulServiceProviderClassID,
			ServiceProviderClassName,
			ServiceProviderClassDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulServiceProviderClassID,
			ServiceProviderClassName,
			ServiceProviderClassDescription ,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulServiceProviderClass WITH (NOLOCK)
		WHERE	AtulServiceProviderClassID = @AtulServiceProviderClassID;
	COMMIT TRAN;

	SELECT	@AtulServiceProviderClassID		AS AtulServiceProviderClassID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderClassUpdate_sp
(
	@AtulServiceProviderClassID		BIGINT,
	@ServiceProviderClassName		NVARCHAR(50),
	@ServiceProviderClassDescription	NVARCHAR(256),
	@ModifiedBy				BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	apc
		SET	ServiceProviderClassName		= @ServiceProviderClassName,
			ServiceProviderClassDescription		= @ServiceProviderClassDescription,
			ModifiedDate				= @now,
			ModifiedBy				= @ModifiedBy
		FROM	dbo.AtulServiceProviderClass apc WITH (ROWLOCK)
		WHERE	AtulServiceProviderClassID 		= @AtulServiceProviderClassID;

		UPDATE	aapc
		SET	aapc.EndDate				= @now
		FROM	audit.AtulServiceProviderClass aapc WITH (ROWLOCK)
		WHERE	AtulServiceProviderClassID 		= @AtulServiceProviderClassID
		AND	aapc.EndDate	IS NULL;

		INSERT	audit.AtulServiceProviderClass (
			AtulServiceProviderClassID,
			ServiceProviderClassName,
			ServiceProviderClassDescription,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulServiceProviderClassID,
			ServiceProviderClassName,
			ServiceProviderClassDescription ,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulServiceProviderClass WITH (NOLOCK)
		WHERE	AtulServiceProviderClassID = @AtulServiceProviderClassID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderDelete_sp
(
	@AtulServiceProviderID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulServiceProvider ag
		WHERE	ag.AtulServiceProviderID	= @AtulServiceProviderID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulServiceProvider aga
		WHERE	aga.AtulServiceProviderID	= @AtulServiceProviderID
		AND	EndDate IS NULL;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderGetByID_sp
(
	@AtulServiceProviderID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulServiceProviderID		AS AtulServiceProviderID,
		sp.ServiceProviderName			AS ServiceProviderName,
		sp.ServiceProviderDescription		AS ServiceProviderDescription,
		sp.AtulServiceProviderClassID		AS AtulServiceProviderClassID,
		sp.CreatedDate				AS CreatedDate,
		sp.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		sp.ModifiedDate				AS ModifiedDate,
		sp.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		sp.ServiceProviderXML			AS ServiceProviderXML,
		sp.ESBQueue				AS ESBQueue
	FROM	dbo.AtulServiceProvider sp
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.AtulServiceProviderID = @AtulServiceProviderID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderGetBySearch_sp
(
	@ServiceProviderName		NVARCHAR(50),
	@AtulServiceProviderClassID	BIGINT,
	@ESBQueue			NVARCHAR(MAX)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulServiceProviderID		AS AtulServiceProviderID,
		sp.ServiceProviderName			AS ServiceProviderName,
		sp.ServiceProviderDescription		AS ServiceProviderDescription,
		sp.AtulServiceProviderClassID		AS AtulServiceProviderClassID,
		cl.ServiceProviderClassName		AS ServiceProviderClassName,
		cl.ServiceProviderClassDescription	AS ServiceProviderClassDescription,
		sp.CreatedDate				AS CreatedDate,
		sp.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		sp.ModifiedDate				AS ModifiedDate,
		sp.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		sp.ServiceProviderXML			AS ServiceProviderXML,
		sp.ESBQueue				AS ESBQueue
	FROM	dbo.AtulServiceProvider sp
	JOIN	dbo.AtulServiceProviderClass cl ON sp.AtulServiceProviderClassID = cl.AtulServiceProviderClassID
					AND cl.IsActive = CAST ( 1 AS BIT)
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.IsActive = CAST ( 1 AS BIT)
	AND	( @ServiceProviderName IS NULL OR sp.ServiceProviderName = @ServiceProviderName )
	AND	( @AtulServiceProviderClassID IS NULL OR sp.AtulServiceProviderClassID = @AtulServiceProviderClassID )
	AND	( @ESBQueue IS NULL OR sp.ESBQueue = @ESBQueue );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulServiceProviderID		AS AtulServiceProviderID,
		sp.ServiceProviderName			AS ServiceProviderName,
		sp.ServiceProviderDescription		AS ServiceProviderDescription,
		sp.AtulServiceProviderClassID		AS AtulServiceProviderClassID,
		sp.CreatedDate				AS CreatedDate,
		sp.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		sp.ModifiedDate				AS ModifiedDate,
		sp.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		sp.ServiceProviderXML			AS ServiceProviderXML,
		sp.ESBQueue				AS ESBQueue
	FROM	dbo.AtulServiceProvider sp
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	WHERE	sp.IsActive = CAST ( 1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderInsert_sp
(
	@ServiceProviderName		NVARCHAR(50),
	@ServiceProviderDescription	NVARCHAR(256),
	@AtulServiceProviderClassID	BIGINT,
	@CreatedBy			BIGINT,
	@ServiceProviderXML		NVARCHAR(MAX) = NULL,
	@ESBQueue			NVARCHAR(MAX) = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulServiceProviderID		BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulServiceProvider (
			ServiceProviderName,
			ServiceProviderDescription,
			AtulServiceProviderClassID,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive,
			ServiceProviderXML,
			ESBQueue )
		SELECT	@ServiceProviderName,
			@ServiceProviderDescription,
			@AtulServiceProviderClassID,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT ),
			@ServiceProviderXML,
			@ESBQueue;

		SET	@AtulServiceProviderID = SCOPE_IDENTITY();

		INSERT	audit.AtulServiceProvider (
			AtulServiceProviderID,
			ServiceProviderName,
			ServiceProviderDescription,
			AtulServiceProviderClassID,
			CreatedBy,
			ModifiedBy,
			StartDate,
			ServiceProviderXML,
			ESBQueue )
		SELECT	AtulServiceProviderID,
			ServiceProviderName,
			ServiceProviderDescription,
			AtulServiceProviderClassID,
			CreatedBy,
			ModifiedBy,
			@now,
			ServiceProviderXML,
			ESBQueue
		FROM	dbo.AtulServiceProvider WITH (NOLOCK)
		WHERE	AtulServiceProviderID = @AtulServiceProviderID;
	COMMIT TRAN;

	SELECT	@AtulServiceProviderID		AS AtulServiceProviderID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_ServiceProviderUpdate_sp
(
	@AtulServiceProviderID		BIGINT,
	@ServiceProviderName		NVARCHAR(50),
	@ServiceProviderDescription	NVARCHAR(256),
	@AtulServiceProviderClassID	BIGINT,
	@ModifiedBy			BIGINT,
	@ServiceProviderXML		NVARCHAR(MAX) = NULL,
	@ESBQueue			NVARCHAR(MAX) = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	asp
		SET	ServiceProviderName		= @ServiceProviderName,
			ServiceProviderDescription	= @ServiceProviderDescription,
			AtulServiceProviderClassID	= @AtulServiceProviderClassID,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy,
			ServiceProviderXML		= COALESCE(@ServiceProviderXML, ServiceProviderXML),
			ESBQueue			= COALESCE(@ESBQueue, ESBQueue)
		FROM	dbo.AtulServiceProvider asp WITH (ROWLOCK)
		WHERE	asp.AtulServiceProviderID	= @AtulServiceProviderID;

		UPDATE	aspa
		SET	aspa.EndDate			= @now
		FROM	audit.AtulServiceProvider aspa WITH (ROWLOCK)
		WHERE	aspa.AtulServiceProviderID	= @AtulServiceProviderID
		AND	aspa.EndDate IS NULL;

		INSERT	audit.AtulServiceProvider (
			AtulServiceProviderID,
			ServiceProviderName,
			ServiceProviderDescription,
			AtulServiceProviderClassID,
			CreatedBy,
			ModifiedBy,
			StartDate,
			ServiceProviderXML,
			ESBQueue )
		SELECT	AtulServiceProviderID,
			ServiceProviderName,
			ServiceProviderDescription,
			AtulServiceProviderClassID,
			CreatedBy,
			ModifiedBy,
			@now,
			ServiceProviderXML,
			ESBQueue
		FROM	dbo.AtulServiceProvider WITH (NOLOCK)
		WHERE	AtulServiceProviderID = @AtulServiceProviderID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessDelete_sp
(
	@AtulSubProcessID	BIGINT,
	@ModifiedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;
	
	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	p
		SET	p.IsActive	= CAST ( 0 AS BIT ),
			p.ModifiedDate	= @now,
			p.ModifiedBy	= @ModifiedBy
		FROM	dbo.AtulSubProcess p 
		WHERE	p.AtulSubProcessID = @AtulSubProcessID;
		
		UPDATE	audit.AtulSubProcess
		SET	EndDate		= @now
		WHERE	AtulSubProcessID = @AtulSubProcessID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessGetByID_sp
(
	@AtulSubProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulSubProcessID		AS AtulSubProcessID,
		sp.SubProcessDescription	AS SubProcessDescription,
		sp.SubProcessSummary		AS SubProcessSummary,
		sp.CreatedDate			AS CreatedDate,
		sp.CreatedBy			AS CreatedBy,
		sp.ModifiedDate			AS ModifiedDate,
		sp.ModifiedBy			AS ModifiedBy,
		sp.OwnedBy			AS OwnedBy,
		cu.DisplayName			AS CreatedByName,
		mu.DisplayName			AS ModifiedByName,
		ou.DisplayName			AS OwnedByName
	FROM	dbo.AtulSubProcess sp
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON sp.OwnedBy = ou.AtulUserID
	WHERE	sp.AtulSubProcessID = @AtulSubProcessID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessGetByProcessID_sp
(
	@AtulProcessID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	psp.AtulProcessID			AS AtulProcessID,
		psp.AtulProcessSubprocessID		AS AtulProcessSubprocessID,
		psp.NotificationIdentifier		AS NotificationIdentifier,
		psp.NotificationServiceProviderID	AS NotificationServiceProviderID,
		psp.ProcessSubprocessSortOrder		AS ProcessSubprocessSortOrder,
		psp.ResponsibilityOf			AS ProcessSubprocessResponsibilityOf,
		ru.DisplayName				AS ProcessSubprocessResponsibilityOfName,
		sp.AtulSubProcessID			AS AtulSubProcessID,
		sp.SubProcessDescription		AS SubProcessDescription,
		sp.SubProcessSummary			AS SubProcessSummary,
		sp.OwnedBy				AS SubProcessOwnedBy,
		ou.DisplayName				AS SubProcessOwnedByName
	FROM	dbo.AtulProcessSubprocess psp
	JOIN	dbo.AtulSubProcess sp ON psp.AtulSubProcessID = sp.AtulSubProcessID
				AND sp.IsActive = CAST (1 AS BIT)
	JOIN	dbo.AtulUser ru ON psp.ResponsibilityOf = ru.AtulUserID
	JOIN	dbo.AtulUser ou ON sp.OwnedBy = ou.AtulUserID
	WHERE	psp.AtulProcessID	= @AtulProcessID
	AND	psp.IsActive = CAST (1 AS BIT)
	ORDER BY psp.ProcessSubprocessSortOrder;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	sp.AtulSubProcessID		AS AtulSubProcessID,
		sp.SubProcessDescription	AS SubProcessDescription,
		sp.SubProcessSummary		AS SubProcessSummary,
		sp.CreatedDate			AS CreatedDate,
		sp.CreatedBy			AS CreatedBy,
		sp.ModifiedDate			AS ModifiedDate,
		sp.ModifiedBy			AS ModifiedBy,
		sp.OwnedBy			AS OwnedBy,
		cu.DisplayName			AS CreatedByName,
		mu.DisplayName			AS ModifiedByName,
		ou.DisplayName			AS OwnedByName
	FROM	dbo.AtulSubProcess sp
	JOIN	dbo.AtulUser cu ON sp.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON sp.ModifiedBy = mu.AtulUserID
	JOIN	dbo.AtulUser ou ON sp.OwnedBy = ou.AtulUserID
	WHERE	sp.IsActive	= CAST (1 AS BIT);
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessInsert_sp
(
	@SubProcessDescription	NVARCHAR(256),
	@SubProcessSummary	NVARCHAR(50),
	@CreatedBy		BIGINT,
	@OwnedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now			DATETIME,
		@AtulSubProcessID	BIGINT;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		INSERT	dbo.AtulSubProcess (
			SubProcessDescription,
			SubProcessSummary,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			OwnedBy,
			IsActive )
		SELECT	@SubProcessDescription,
			@SubProcessSummary,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@OwnedBy,
			CAST ( 1 AS BIT );

		SET	@AtulSubProcessID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulSubProcess (
			AtulSubProcessID,
			SubProcessDescription,
			SubProcessSummary,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate )
		SELECT	AtulSubProcessID,
			SubProcessDescription,
			SubProcessSummary,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now
		FROM	dbo.AtulSubProcess WITH (NOLOCK)
		WHERE	AtulSubProcessID = @AtulSubProcessID;
	COMMIT TRAN;

	SELECT	@AtulSubProcessID		AS AtulSubProcessID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_SubProcessUpdate_sp
(
	@AtulSubProcessID	BIGINT,
	@SubProcessDescription	NVARCHAR(256),
	@SubProcessSummary	NVARCHAR(50),
	@ModifiedBy		BIGINT,
	@OwnedBy		BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	sp
		SET	SubProcessDescription	= @SubProcessDescription,
			SubProcessSummary	= @SubProcessSummary,
			ModifiedDate		= @now,
			ModifiedBy		= @ModifiedBy,
			OwnedBy			= @OwnedBy
		FROM	dbo.AtulSubProcess sp
		WHERE	sp.AtulSubProcessID	= @AtulSubProcessID;

		UPDATE	pa
		SET	pa.EndDate		= @now
		FROM	audit.AtulSubProcess pa
		WHERE	pa.AtulSubProcessID	= @AtulSubProcessID
		AND	EndDate IS NULL;

		INSERT	audit.AtulSubProcess (
			AtulSubProcessID,
			SubProcessDescription,
			SubProcessSummary,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			StartDate )
		SELECT	AtulSubProcessID,
			SubProcessDescription,
			SubProcessSummary,
			CreatedBy,
			ModifiedBy,
			OwnedBy,
			@now
		FROM	dbo.AtulSubProcess WITH (NOLOCK)
		WHERE	AtulSubProcessID = @AtulSubProcessID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldDelete_sp
(
	@AtulUserDefinedFieldID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulUserDefinedField ag
		WHERE	ag.AtulUserDefinedFieldID	= @AtulUserDefinedFieldID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulUserDefinedField aga
		WHERE	aga.AtulUserDefinedFieldID	= @AtulUserDefinedFieldID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldGetByID_sp
(
	@AtulUserDefinedFieldID		BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedFieldID		AS AtulUserDefinedFieldID,
		df.UserDefinedFieldName			AS UserDefinedFieldName,
		df.UserDefinedFieldComment		AS UserDefinedFieldComment,
		df.UserDefinedFieldTypeID		AS UserDefinedFieldTypeID,
		df.UserDefinedFieldSortOrder		AS UserDefinedFieldSortOrder,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		df.ValidationRegExp			AS ValidationRegExp,
		df.InfoUrl				AS InfoUrl
	FROM	dbo.AtulUserDefinedField df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID
	WHERE	df.AtulUserDefinedFieldID = @AtulUserDefinedFieldID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedFieldID		AS AtulUserDefinedFieldID,
		df.UserDefinedFieldName			AS UserDefinedFieldName,
		df.UserDefinedFieldComment		AS UserDefinedFieldComment,
		df.UserDefinedFieldTypeID		AS UserDefinedFieldTypeID,
		df.UserDefinedFieldSortOrder		AS UserDefinedFieldSortOrder,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
		cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName,
		df.ValidationRegExp			AS ValidationRegExp,
		df.InfoUrl				AS InfoUrl
	FROM	dbo.AtulUserDefinedField df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID
	WHERE	df.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldInsert_sp
(
	@UserDefinedFieldName		NVARCHAR(50),
	@UserDefinedFieldComment	NVARCHAR(256),
	@UserDefinedFieldTypeID		INT,
	@UserDefinedFieldSortOrder	INT,
	@CreatedBy			BIGINT,
	@ValidationRegExp		NVARCHAR(255),
	@InfoUrl			NVARCHAR(1024)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulUserDefinedFieldID		BIGINT;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		INSERT	dbo.AtulUserDefinedField (
			UserDefinedFieldName,
			UserDefinedFieldComment,
			UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			ValidationRegExp,
			InfoUrl,
			IsActive )
		SELECT	@UserDefinedFieldName,
			@UserDefinedFieldComment,
			@UserDefinedFieldTypeID,
			@UserDefinedFieldSortOrder,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			@ValidationRegExp,
			@InfoUrl,
			CAST ( 1 AS BIT);		-- IsActive

		SET	@AtulUserDefinedFieldID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulUserDefinedField (
			AtulUserDefinedFieldID,
			UserDefinedFieldName,
			UserDefinedFieldComment,
			UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder,
			CreatedBy,
			ModifiedBy,
			ValidationRegExp,
			InfoUrl,
			StartDate )
		SELECT	AtulUserDefinedFieldID,
			UserDefinedFieldName,
			UserDefinedFieldComment,
			UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder,
			CreatedBy,
			ModifiedBy,
			ValidationRegExp,
			InfoUrl,
			@now
		FROM	dbo.AtulUserDefinedField WITH (NOLOCK)
		WHERE	AtulUserDefinedFieldID = @AtulUserDefinedFieldID;
	COMMIT TRAN;

	SELECT	@AtulUserDefinedFieldID		AS AtulUserDefinedFieldID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldTypeGetByID_sp
(
	@AtulUserDefinedFieldTypeID INT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedFieldTypeID		AS AtulUserDefinedFieldTypeID,
		df.UserDefinedFieldTypeName		AS UserDefinedFieldTypeName,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
	        cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulUserDefinedFieldType df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID
	WHERE	df.AtulUserDefinedFieldTypeID = @AtulUserDefinedFieldTypeID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldTypeGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedFieldTypeID		AS AtulUserDefinedFieldTypeID,
		df.UserDefinedFieldTypeName		AS UserDefinedFieldTypeName,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
	        cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulUserDefinedFieldType df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldTypeInsert_sp
(
	@UserDefinedFieldTypeName	NVARCHAR(50),
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulUserDefinedFieldTypeID	INT;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		INSERT	dbo.AtulUserDefinedFieldType (
			UserDefinedFieldTypeName,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			Modifiedby )
		SELECT	@UserDefinedFieldTypeName,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy;

		SET	@AtulUserDefinedFieldTypeID = SCOPE_IDENTITY();
		
	COMMIT TRAN;

	SELECT	@AtulUserDefinedFieldTypeID		AS AtulUserDefinedFieldTypeID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldTypeUpdate_sp
(
	@AtulUserDefinedFieldTypeID	INT,
	@UserDefinedFieldTypeName	NVARCHAR(50),
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	ft
		SET	UserDefinedFieldTypeName	= @UserDefinedFieldTypeName,
			ModifiedDate			= @now,
			Modifiedby			= @ModifiedBy
		FROM	dbo.AtulUserDefinedFieldType ft WITH (ROWLOCK)
		WHERE	ft.AtulUserDefinedFieldTypeID = @AtulUserDefinedFieldTypeID
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedFieldUpdate_sp
(
	@AtulUserDefinedFieldID		BIGINT,
	@UserDefinedFieldName		NVARCHAR(50),
	@UserDefinedFieldComment	NVARCHAR(256),
	@UserDefinedFieldTypeID		INT,
	@UserDefinedFieldSortOrder	INT,
	@ModifiedBy			BIGINT,
	@ValidationRegExp		NVARCHAR(255),
	@InfoUrl			NVARCHAR(1024)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	df
		SET	UserDefinedFieldName		= @UserDefinedFieldName,
			UserDefinedFieldComment		= @UserDefinedFieldComment,
			UserDefinedFieldTypeID		= @UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder	= @UserDefinedFieldSortOrder,
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy,
			ValidationRegExp		= @ValidationRegExp,
			InfoUrl				= @InfoUrl
		FROM	dbo.AtulUserDefinedField df WITH (ROWLOCK)
		WHERE	df.AtulUserDefinedFieldID = @AtulUserDefinedFieldID;

		UPDATE	adf
		SET	adf.EndDate			= @now
		FROM	audit.AtulUserDefinedField adf WITH (NOLOCK)
		WHERE	adf.AtulUserDefinedFieldID	= @AtulUserDefinedFieldID
		AND	adf.EndDate IS NULL;
		
		INSERT	audit.AtulUserDefinedField (
			AtulUserDefinedFieldID,
			UserDefinedFieldName,
			UserDefinedFieldComment,
			UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder,
			CreatedBy,
			ModifiedBy,
			ValidationRegExp,
			InfoUrl,
			StartDate )
		SELECT	AtulUserDefinedFieldID,
			UserDefinedFieldName,
			UserDefinedFieldComment,
			UserDefinedFieldTypeID,
			UserDefinedFieldSortOrder,
			CreatedBy,
			ModifiedBy,
			ValidationRegExp,
			InfoUrl,
			@now
		FROM	dbo.AtulUserDefinedField WITH (NOLOCK)
		WHERE	AtulUserDefinedFieldID = @AtulUserDefinedFieldID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedValueDelete_sp
(
	@AtulUserDefinedValueID		BIGINT,
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now	DATETIME;

	SET	@now	= GETUTCDATE();

	BEGIN TRAN;
		UPDATE	ag
		SET	IsActive			= CAST ( 0 AS BIT ),
			ModifiedDate			= @now,
			ModifiedBy			= @ModifiedBy
		FROM	dbo.AtulUserDefinedValue ag
		WHERE	ag.AtulUserDefinedValueID	= @AtulUserDefinedValueID;
		
		UPDATE	aga
		SET	EndDate				= @now
		FROM	audit.AtulUserDefinedValue aga
		WHERE	aga.AtulUserDefinedValueID	= @AtulUserDefinedValueID
		AND	EndDate IS NULL;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedValueGetByID_sp
(
	@AtulUserDefinedValueID		BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedValueID		AS AtulUserDefinedValueID,
		df.UserDefinedValue			AS UserDefinedValue,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
	        cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulUserDefinedValue df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID
	WHERE	df.AtulUserDefinedValueID = @AtulUserDefinedValueID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedValueGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	df.AtulUserDefinedValueID		AS AtulUserDefinedValueID,
		df.UserDefinedValue			AS UserDefinedValue,
		df.CreatedDate				AS CreatedDate,
		df.CreatedBy				AS CreatedBy,
	        cu.DisplayName				AS CreatedByName,
		df.ModifiedDate				AS ModifiedDate,
		df.ModifiedBy				AS ModifiedBy,
		mu.DisplayName				AS ModifiedByName
	FROM	dbo.AtulUserDefinedValue df
	JOIN	dbo.AtulUser cu ON df.CreatedBy = cu.AtulUserID
	JOIN	dbo.AtulUser mu ON df.ModifiedBy = mu.AtulUserID
	WHERE	df.IsActive = CAST ( 1 AS BIT );
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedValueInsert_sp
(
	@UserDefinedValue		NVARCHAR(255),
	@CreatedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME,
		@AtulUserDefinedValueID		BIGINT;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		INSERT	dbo.AtulUserDefinedValue (
			UserDefinedValue,
			CreatedDate,
			CreatedBy,
			ModifiedDate,
			ModifiedBy,
			IsActive )
		SELECT	@UserDefinedValue,
			@now,
			@CreatedBy,
			@now,
			@CreatedBy,
			CAST ( 1 AS BIT);		-- IsActive

		SET	@AtulUserDefinedValueID = SCOPE_IDENTITY();
		
		INSERT	audit.AtulUserDefinedValue (
			AtulUserDefinedValueID,
			UserDefinedValue,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulUserDefinedValueID,
			UserDefinedValue,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulUserDefinedValue WITH (NOLOCK)
		WHERE	AtulUserDefinedValueID = @AtulUserDefinedValueID;

	COMMIT TRAN;

	SELECT	@AtulUserDefinedValueID		AS AtulUserDefinedValueID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDefinedValueUpdate_sp
(
	@AtulUserDefinedValueID		BIGINT,
	@UserDefinedValue		NVARCHAR(255),
	@ModifiedBy			BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@now				DATETIME;

	SET	@now	= GETUTCDATE();
	
	BEGIN TRAN;
		UPDATE	adv
		SET	UserDefinedValue	= @UserDefinedValue,
			ModifiedDate		= @now,
			ModifiedBy		= @ModifiedBy
		FROM	dbo.AtulUserDefinedValue adv WITH (ROWLOCK)
		WHERE	adv.AtulUserDefinedValueID = @AtulUserDefinedValueID;

		UPDATE	aadv
		SET	EndDate			= @now
		FROM	audit.AtulUserDefinedValue aadv WITH (ROWLOCK)
		WHERE	aadv.AtulUserDefinedValueID = @AtulUserDefinedValueID;
		
		INSERT	audit.AtulUserDefinedValue (
			AtulUserDefinedValueID,
			UserDefinedValue,
			CreatedBy,
			ModifiedBy,
			StartDate )
		SELECT	AtulUserDefinedValueID,
			UserDefinedValue,
			CreatedBy,
			ModifiedBy,
			@now
		FROM	dbo.AtulUserDefinedValue WITH (NOLOCK)
		WHERE	AtulUserDefinedValueID = @AtulUserDefinedValueID;

	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserDelete_sp
(
	@AtulUserID	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	BEGIN TRAN;
		UPDATE	t
		SET	t.IsActive = CAST ( 0 AS BIT )
		FROM	dbo.AtulUser t 
		WHERE	t.AtulUserID = @AtulUserID;
	COMMIT TRAN;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	u.AtulUserID,
	        u.RemoteSystemLoginID,
	        u.DisplayName,
	        u.IsActive,
	        u.AtulUserTypeID,
	        u.Email,
	        ut.UserTypeName,
		rs.AtulRemoteSystemID,
		rs.RemoteSystem 
	FROM	dbo.AtulUser u
	JOIN	dbo.AtulUserType ut ON u.AtulUserTypeID = ut.AtulUserTypeID
	JOIN	dbo.AtulRemoteSystem rs ON u.AtulRemoteSystemID = rs.AtulRemoteSystemID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserGetbyLogin_sp
(
	@RemoteSystemLoginID	NVARCHAR(100),
	@AtulRemoteSystemID	BIGINT
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	u.AtulUserID,
	        u.RemoteSystemLoginID,
	        u.DisplayName,
	        u.IsActive,
	        u.AtulUserTypeID,
	        u.Email,
	        ut.UserTypeName,
		rs.AtulRemoteSystemID,
		rs.RemoteSystem 
	FROM	dbo.AtulUser u
	JOIN	dbo.AtulUserType ut ON u.AtulUserTypeID = ut.AtulUserTypeID
	JOIN	dbo.AtulRemoteSystem rs ON u.AtulRemoteSystemID = rs.AtulRemoteSystemID
	WHERE	u.RemoteSystemLoginID	= @RemoteSystemLoginID;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserInsert_sp
(
	@AtulRemoteSystemID	BIGINT,
	@AtulUserTypeID		BIGINT,
	@RemoteSystemLoginID	NVARCHAR(100),
	@DisplayName		NVARCHAR(150),
	@Email			NVARCHAR(150) = NULL
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	DECLARE	@active		BIT,
		@AtulUserID	BIGINT;
	
	SELECT	@AtulUserID		= a.AtulUserTypeID,
		@active			= a.IsActive
	FROM	dbo.AtulUser a WITH (NOLOCK)
	WHERE	a.AtulRemoteSystemID	= @AtulRemoteSystemID
	AND	a.RemoteSystemLoginID	= @RemoteSystemLoginID
	AND	a.AtulUserTypeID	= @AtulUserTypeID;
	
	IF @active = CAST ( 0 AS BIT )
	BEGIN;
	BEGIN TRAN;
		UPDATE	u
		SET	u.IsActive = CAST (1 AS BIT)
		FROM	dbo.AtulUser u
		WHERE	u.AtulUserID = @AtulUserID;
	COMMIT TRAN;
	END;
	
	IF @AtulUserID IS NULL
	BEGIN;
	BEGIN TRAN;
		INSERT	dbo.AtulUser (
			AtulRemoteSystemID,
			AtulUserTypeID,
			RemoteSystemLoginID,
			DisplayName,
			IsActive,
			Email )
		SELECT	@AtulRemoteSystemID,
			@AtulUserTypeID,
			@RemoteSystemLoginID,
			@DisplayName,
			CAST ( 1 AS BIT ),
			@Email;

		SET	@AtulUserID = SCOPE_IDENTITY();
	COMMIT TRAN;
	END;

	SELECT	@AtulUserID		AS AtulUserID;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF (XACT_STATE() = -1 ) OR @@TRANCOUNT > 0
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserTypeDelete_sp
(
	@AtulUserTypeID	BIGINT
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY
	
	BEGIN TRAN;
		UPDATE	t
		SET	t.IsActive = CAST ( 0 AS BIT )
		FROM	dbo.AtulUserType t 
		WHERE	t.AtulUserTypeID = @AtulUserTypeID;
	COMMIT TRAN;
		
	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserTypeGet_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	ut.AtulUserTypeID,
		ut.UserTypeName,
		ut.IsActive
	FROM	dbo.AtulUserType ut;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_UserTypeInsert_sp
(
	@UserTypeName	NVARCHAR(50)
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN;
	BEGIN TRY

	DECLARE	@AtulUserTypeID		BIGINT;

	SELECT	@AtulUserTypeID	= a.AtulUserTypeID
	FROM	dbo.AtulUserType a WITH (NOLOCK)
	WHERE	a.UserTypeName	= @UserTypeName;

	IF @AtulUserTypeID IS NULL
	BEGIN;
	BEGIN TRAN;
		INSERT	dbo.AtulUserType (
			UserTypeName )
		SELECT	@UserTypeName;

		SET	@AtulUserTypeID = SCOPE_IDENTITY();
	COMMIT TRAN;
	END;

	SELECT	@AtulUserTypeID		AS AtulUserTypeID;

	END TRY

	BEGIN CATCH;
		DECLARE	@ErrorNumber		INT,
			@ErrorProcedure		NVARCHAR(50),
			@dbName			SYSNAME,
			@ErrorLine		INT,
			@ErrorMessage		NVARCHAR(4000),
			@ErrorSeverity		INT,
			@ErrorState		INT,
			@ErrorReturnMessage	NVARCHAR(4000),
			@ErrorReturnSeverity	INT,
			@currentDateTime	SMALLDATETIME;

		SET @ErrorNumber		= ERROR_NUMBER();
		SET @ErrorProcedure		= ERROR_PROCEDURE();
		SET @dbName			= DB_NAME();
		SET @ErrorLine			= ERROR_LINE();
		SET @ErrorMessage		= ERROR_MESSAGE();
		SET @ErrorSeverity		= ERROR_SEVERITY();
		SET @ErrorState			= ERROR_STATE();
		SET @currentDateTime		= GETDATE();
		SET @ErrorReturnMessage		= CONVERT(VARCHAR, @currentDateTime) + ': an error has occurred in ' + @dbName + 
								  ' Error Number ' + CONVERT(VARCHAR,@ErrorNumber) +
								  ' Procedure ' + @ErrorProcedure +
								  ' Line ' + CONVERT(VARCHAR,@ErrorLine) +
								  ' Message ' + @ErrorMessage +
								  ' Severity ' + CONVERT(VARCHAR,@ErrorSeverity) +
								  ' State ' + CONVERT(VARCHAR,@ErrorState);

		RAISERROR (@ErrorReturnMessage, 15, -1) WITH NOWAIT;

		-- Test XACT_STATE:
		-- If 1, the transaction is committable.
		-- If -1, the transaction is uncommittable and should be rolled back.
		-- XACT_STATE = 0 means that there is no transaction and a commit or rollback operation would generate an error.
		-- Test whether the transaction is uncommittable.
		IF ( XACT_STATE() = -1) OR @@TRANCOUNT > 0 
		BEGIN;
			ROLLBACK TRANSACTION;
		END;
		
		RETURN -1;
	END CATCH;
END;
SET NOCOUNT OFF;
RETURN 0;
go

create PROCEDURE dbo.Atul_GroupGetAll_sp
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	DISTINCT
		grp.DisplayName						AS GroupName,
		grp.Email						AS GroupEmail,
		'grp:' + CAST(grp.AtulUserID AS VARCHAR(4000))		AS GroupID,
		sup.AtulUserID						AS SupNTLoginID,
		sup.DisplayName						AS SupName
	FROM	dbo.AtulUser grp
	LEFT JOIN dbo.AtulGroupSupervisor mtm ON grp.AtulUserID = mtm.AtulGroupID
	LEFT JOIN dbo.AtulUser sup ON mtm.AtulSupervisorID = sup.AtulUserID
				AND sup.AtulUserTypeID = 1
	WHERE	grp.AtulUserTypeID = 2
	AND	grp.IsActive = 0;
END;
SET NOCOUNT OFF;
RETURN	0;
go


create PROCEDURE dbo.Atul_GroupMemberGetByGroupName_sp
(
	@GroupName	VARCHAR(150)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	grp.DisplayName						AS GroupName
		, grp.Email						AS GroupEmail
		, 'grp:' + CAST(grp.AtulUserID AS VARCHAR(4000))	AS GroupID
 		, usr.AtulUserID					AS UserID
		, usr.RemoteSystemLoginID				AS NTLoginID
		, usr.DisplayName					AS UserName
		, sup.RemoteSystemLoginID				AS SupNTLoginID
 		, sup.DisplayName					AS SupName
	FROM    dbo.AtulUser grp
	LEFT JOIN dbo.AtulGroupMemeber mtm ON grp.AtulUserID = mtm.AtulGroupID
	LEFT JOIN dbo.AtulGroupSupervisor smtm ON grp.AtulUserID = smtm.AtulGroupID
	LEFT JOIN dbo.AtulUser usr ON mtm.AtulUserID = usr.AtulUserID
	LEFT JOIN dbo.AtulUser sup ON smtm.AtulSupervisorID = sup.AtulUserID
	WHERE	grp.AtulUserTypeID = 2
	AND	grp.DisplayName = @GroupName;

END;
SET NOCOUNT OFF;
RETURN	0;
go

create PROCEDURE dbo.Atul_GroupMembershipGetByADID_sp
(
	@NTLoginID	NVARCHAR(100)
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
	SELECT	DISTINCT
		grp.DisplayName					AS GroupName
		,grp.Email					AS GroupEmail
		,'grp:' + CAST(grp.AtulUserID AS VARCHAR(4000))	AS GroupID
		,sup.RemoteSystemLoginID			AS SupNTLoginID
		,sup.DisplayName				AS SupName
	FROM    dbo.AtulUser mbr
	JOIN	dbo.AtulGroupMemeber mtm ON mbr.AtulUserID = mtm.AtulUserID
	JOIN	dbo.AtulUser grp ON mtm.AtulGroupID = grp.AtulUserID
	JOIN	dbo.AtulGroupSupervisor smtm ON mtm.AtulGroupID = smtm.AtulGroupID
	JOIN	dbo.AtulUser sup ON smtm.AtulSupervisorID = sup.AtulUserID
	WHERE	mbr.RemoteSystemLoginID = @NTLoginID;
END;
SET NOCOUNT OFF;
RETURN	0;
go

create role execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupActivityUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderClassUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_RemoteSystemDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_DeadlineTypeInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessStatusInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_DeadlineTypeDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupActivityInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_RemoteSystemInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_DeadlineTypeGet_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_DeadlineTypeGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupActivityDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupActivityGet_sp to execprocs;
go

grant execute on object::dbo.Atul_GetInstanceProcessSubProcess_GetByID to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupActivityGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_GetCurrentInstanceSubProcess_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessGetDeleted_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariablesGetByScriptName_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcess_GetByID to execprocs;
go

grant execute on object::dbo.Atul_ActivityGetByActivityID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserTypeInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessGetByProcessIDSubProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_GetInstanceProcessActivities_GetByID to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityInteractionInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcessInteractionUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcessInteractionInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityInteractionUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcessInteractionDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityInteractionDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityInteractionGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityCompleteUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessGetNameValueByID_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldUpsert_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcessInteractionGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleUpdateVersion_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldGetByInstanceProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldGetByProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessSubProcessCompleteUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleDeleteByProcessId_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleGetByProcessId_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessGetByProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessGetByProcessSummary_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityGet_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_GetProviderInfoBySubProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderGetBySearch_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessGet_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityGetBy_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupPurposeDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariableInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupPurposeGet_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupPurposeGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariableDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariableUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessActivityUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariablesGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedValueInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ConfigVariablesGetByName_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupPurposeInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedValueDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedValueGet_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_RemoteSystemGet_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedValueGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessScheduleInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_SubProcessGetByProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldTypeGet_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivitiesGetBySubProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldTypeGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessActivityGetByProcessIDActivityID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldTypeUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldGetBySearch_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedValueUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_UserTypeGet_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_UserInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessStatusGet_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldStorageGetByProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderClassInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_UserGet_sp to execprocs;
go

grant execute on object::dbo.Atul_UserDefinedFieldTypeInsert_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivitySortOrderUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderClassDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_UserGetbyLogin_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderClassGet_sp to execprocs;
go

grant execute on object::dbo.Atul_ServiceProviderClassGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessUnDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_DeadlineTypeUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessUnDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_UserTypeDelete_sp to execprocs;
go

grant execute on object::dbo.Atul_ActivityGroupPurposeUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_FlexFieldGetByID_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessSubprocessSortOrderUpdate_sp to execprocs;
go

grant execute on object::dbo.Atul_ProcessGetDeleted_sp to execprocs;
go

grant execute on object::dbo.Atul_InstanceProcessGetByProcessID_sp to execprocs;
go

grant execute on object::dbo.Atul_GroupGetAll_sp to execprocs;
go

grant execute on object::dbo.Atul_GroupMemberGetByGroupName_sp to execprocs;
go

grant execute on object::dbo.Atul_GroupMembershipGetByADID_sp to execprocs;
go

set identity_insert dbo.AtulUserType on
go

INSERT INTO dbo.AtulUserType
  (AtulUserTypeID, UserTypeName, IsActive)
  VALUES (1, N'User', 1)
INSERT INTO dbo.AtulUserType
  (AtulUserTypeID, UserTypeName, IsActive)
  VALUES (2, N'Group', 1)
go

set identity_insert dbo.AtulUserType off
go

set identity_insert dbo.AtulRemoteSystem on
go

INSERT INTO dbo.AtulRemoteSystem
  (AtulRemoteSystemID, RemoteSystem, IsActive)
  VALUES (-1, N'AtulSystem', 0)
INSERT INTO dbo.AtulRemoteSystem
  (AtulRemoteSystemID, RemoteSystem, IsActive)
  VALUES (1, N'LDAP', 1)
go

set identity_insert dbo.AtulRemoteSystem off
go

set identity_insert dbo.AtulUser on
go

INSERT INTO dbo.AtulUser
  (AtulUserID, AtulRemoteSystemID, AtulUserTypeID, RemoteSystemLoginID, DisplayName, IsActive, Email)
  VALUES (-1, -1, 1, N'ATULADMIN', N'Atul System Account', 1, NULL)
INSERT INTO dbo.AtulUser
  (AtulUserID, AtulRemoteSystemID, AtulUserTypeID, RemoteSystemLoginID, DisplayName, IsActive, Email)
  VALUES (0, 1, 1, N'Atul', N'Atul System', 1, NULL)
go

set identity_insert dbo.AtulUser off
go

set identity_insert dbo.AtulProcessStatus on
go

INSERT INTO dbo.AtulProcessStatus
  (AtulProcessStatusID, ProcessStatus)
  VALUES (1, N'Open')
INSERT INTO dbo.AtulProcessStatus
  (AtulProcessStatusID, ProcessStatus)
  VALUES (2, N'Closed')
go

set identity_insert dbo.AtulProcessStatus off
go

set identity_insert dbo.AtulServiceProviderClass on
go

INSERT INTO dbo.AtulServiceProviderClass
  (AtulServiceProviderClassID, ServiceProviderClassName, ServiceProviderClassDescription, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, IsActive)
  VALUES (1, N'SUBJECT', N'Providers that supply information about the subject of a process', '2011-11-22 20:49:41.977', 0, '2011-11-22 20:49:41.977', 0, 1)
INSERT INTO dbo.AtulServiceProviderClass
  (AtulServiceProviderClassID, ServiceProviderClassName, ServiceProviderClassDescription, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, IsActive)
  VALUES (2, N'NOTIFICATION', N'Providers that handle notifications (tickets, email) in a process', '2011-11-22 20:50:38.747', 0, '2011-11-22 20:50:38.747', 0, 1)
INSERT INTO dbo.AtulServiceProviderClass
  (AtulServiceProviderClassID, ServiceProviderClassName, ServiceProviderClassDescription, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, IsActive)
  VALUES (3, N'AUTOMATION', N'Providers that handle automation in a process', '2011-11-22 20:52:34.990', 0, '2011-11-22 20:52:34.990', 0, 1)
go

set identity_insert dbo.AtulServiceProviderClass off
go


set identity_insert dbo.AtulDeadlineType on
go

INSERT INTO dbo.AtulDeadlineType
  (AtulDeadlineTypeID, DeadlineName, DeadlineDescription, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, IsActive)
  VALUES (1, N'Absolute', N'Deadline is absolute from the time the instance is created', '2011-11-16 15:02:19.483', 0, '2011-11-16 15:02:19.483', 0, 1)
INSERT INTO dbo.AtulDeadlineType
  (AtulDeadlineTypeID, DeadlineName, DeadlineDescription, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, IsActive)
  VALUES (2, N'Relative', N'Deadline is relative to start of subprocess', '2011-11-16 15:02:45.033', 0, '2011-11-16 15:02:45.033', 0, 1)
go

set identity_insert dbo.AtulDeadlineType off
go