-- STANDARDS
---- SQL Server version: 2014 and higher
---- All names are Pascal Case, and the only time we can have two uppercase characters are for prefixes and new words (IX_..., ANewWord)
---- Multi-tenant? No
---- Tables
------ Use singular names.  Correct: Report  Incorrect: Reports
---- Columns
------ Last column has a comma at the end so any column can be easily added/removed without worrying about the ending comma
------ All tables must have [Id], [CreatedBy], [ModifiedBy], [CreatedDate], [ModifiedDate]
---- Constraints
------ Primary Key: All tables must have [Id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [PK_TableName] PRIMARY KEY CLUSTERED,
------ Defaults
-------- All columns with NOT NULL must have a default value
-------- All constraints are named DF_Name_colName
------ Indexes
-------- All indexes are defined immediately following the table creation
-------- All indexes are named IX_tlbName_col1, IX_tlbName_col1_col2, IX_tlbName_col1_col2_col3

/* clean-up */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Employee]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Employee]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[User]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[User]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Site]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Site]
GO


/* create tables */

CREATE TABLE [dbo].[Site] (
	[Id] [int] IDENTITY(1 ,1) NOT NULL CONSTRAINT [PK_Site] PRIMARY KEY CLUSTERED ,
	[Name] [nvarchar] (128) NULL ,
	[AccountNumber] [nvarchar] (128) NULL ,
	[Comments] [nvarchar] (max) NULL ,
	[CreatedBy] [int] NULL ,
	[ModifiedBy] [int] NULL ,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Site_CreatedDate]  DEFAULT (getdate()) ,
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_Site_ModifiedDate]  DEFAULT (getdate()) ,
) ON [PRIMARY]
GO

-- Users contains one record for each individual Windows user login
-- Name = unique identifier / login ID / user name
-- LastName = last (family) name / surname
-- MiddleInitials = middle initials
-- FirstName = first (given) name
-- Email = email address
-- UserState = 1 for Active, 0 for Inactive
CREATE TABLE [dbo].[User] (
	[Id] [int] IDENTITY(1 ,1) NOT NULL CONSTRAINT [PK_User] PRIMARY KEY  CLUSTERED ,
	[Name] [nvarchar] (128) NOT NULL ,
    [ActiveDirectoryName] [nvarchar] (64) NULL ,
	[LastName] [nvarchar] (64) NOT NULL ,
	[MiddleInitials] [nvarchar] (16) NULL ,
	[FirstName] [nvarchar] (64) NOT NULL ,
	[SiteId] [int] NULL CONSTRAINT [FK_User_SiteId] REFERENCES [Site]([Id]),
	[Address1] [nvarchar] (128) NULL ,
	[Address2] [nvarchar] (128) NULL ,
	[City] [nvarchar] (64) NULL ,
	[StateOrRegion] [nvarchar] (64) NULL ,
	[PostalCode] [nvarchar] (16) NULL ,
	[PhoneNumber] [nvarchar] (32) NULL ,
	[Email] [nvarchar](255) NULL,
	[Comments] [nvarchar] (max) NULL ,
	[CreatedBy] [int] NULL ,
	[ModifiedBy] [int] NULL ,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_User_CreatedDate] DEFAULT (GetDate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_User_ModifiedDate] DEFAULT (GetDate()),
	[UserState] [smallint] NOT NULL CONSTRAINT [DF_User_State] DEFAULT (1),
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[User] 
	ADD CONSTRAINT [IX_User_Name] UNIQUE NONCLUSTERED
	(
		[Name]
	) WITH FILLFACTOR = 90 ON [PRIMARY]
GO
ALTER TABLE [dbo].[User] 
	ADD CONSTRAINT [IX_User_FullName] UNIQUE NONCLUSTERED
	(
		[FirstName],
		[MiddleInitials],
		[LastName]
	) WITH FILLFACTOR = 90 ON [PRIMARY]
GO

-- UserId = An employee does not have to be a user
CREATE TABLE [dbo].[Employee] (
	[Id] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED,
	[UserId] int NULL CONSTRAINT [FK_Employee_UserId] REFERENCES [User]([Id]),
	[Notes] [nvarchar] (max) NULL ,
	[HiredDate] [datetime] NULL ,
	[EmployeeNumber] [nvarchar] (32) NULL ,
	[EmpType] [nvarchar] (3) NULL ,
	[Comments] [nvarchar] (max) NULL ,
	[CreatedBy] [int] NULL ,
	[ModifiedBy] [int] NULL ,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Employee_CreatedDate] DEFAULT (GetDate()),
	[ModifiedDate] [datetime] NULL CONSTRAINT [DF_Employee_ModifiedDate] DEFAULT (GetDate()),
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE  INDEX [IX_Employee_UserId] ON [dbo].[Employee]([UserId]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO
CREATE  INDEX [IX_Employee_HiredDate] ON [dbo].[Employee]([HiredDate]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO