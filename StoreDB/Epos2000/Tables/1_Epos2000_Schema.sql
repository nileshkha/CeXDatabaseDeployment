USE [master]
GO

/****** CREATE DATABASE ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Epos2000')
BEGIN
	CREATE DATABASE [Epos2000]
		ON  PRIMARY 
		( 
			NAME = N'Epos2000', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Epos2000.mdf' , 
			SIZE = 1048576KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB )
		LOG ON 
		( 
			NAME = N'Epos2000_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Epos2000_log.ldf' , 
			SIZE = 1048576KB , MAXSIZE = 2048GB , FILEGROWTH = 10%
		)
		COLLATE Latin1_General_CI_AS
END

GO
ALTER DATABASE [Epos2000] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Epos2000] SET AUTO_UPDATE_STATISTICS OFF
GO
ALTER AUTHORIZATION ON DATABASE::[Epos2000] TO [sa]
GO

/****** END OF CREATE DATABASE ******/


/****CREATE APPLICATION DEPENDENT LOGINS & USERS*******/
USE [master]
GO

--Logins script
IF NOT EXISTS (SELECT * FROM sys.syslogins WHERE name = N'eposv2')
	CREATE LOGIN [Eposv2] WITH PASSWORD=N'<>', DEFAULT_DATABASE=[epos2000], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

IF NOT EXISTS (SELECT * FROM sys.syslogins WHERE name = N'boffice')
	CREATE LOGIN [boffice] WITH PASSWORD=N'<>', DEFAULT_DATABASE=[epos2000], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

IF NOT EXISTS (SELECT * FROM sys.syslogins WHERE name = N'reader')
	CREATE LOGIN [reader] WITH PASSWORD=N'<>', DEFAULT_DATABASE=[epos2000], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

IF NOT EXISTS (SELECT * FROM sys.syslogins WHERE name = N'repl_usr')
	CREATE LOGIN [repl_usr] WITH PASSWORD=N'<>', DEFAULT_DATABASE=[epos2000], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--Users script
USE [Epos2000]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'reader')
	CREATE USER [reader] FOR LOGIN [reader] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT TO [reader] AS [dbo]
	ALTER ROLE [db_datareader] ADD MEMBER [reader]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'eposv2')
	CREATE USER [eposv2] FOR LOGIN [eposv2] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT TO [eposv2] AS [dbo]

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'boffice')
	CREATE USER [boffice] FOR LOGIN [boffice] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT TO [boffice] AS [dbo]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'repl_usr')
	CREATE USER [repl_usr] FOR LOGIN [repl_usr] WITH DEFAULT_SCHEMA=[dbo]
	ALTER ROLE [db_datareader] ADD MEMBER [repl_usr]
	ALTER ROLE [db_datawriter] ADD MEMBER [repl_usr]
	GRANT CONNECT TO [repl_usr] AS [dbo]
GO

/****END OF APPLICATION DEPENDENT LOGINS & USERS SCRIPT*******/


/*****SCRIPT TO CREATE TABLES ON Epos2000********************/

USE [Epos2000]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Attribute](
	[AttributeID] [int] IDENTITY(1,1) NOT NULL,
	[StructureID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[LongValue] [int] NULL,
	[StringValue] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[DoubleValue] [float] NULL,
	[DateValue] [datetime] NULL,
	[BooleanValue] [bit] NOT NULL,
 CONSTRAINT [PK___1__47] PRIMARY KEY NONCLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Attribute] TO  SCHEMA OWNER 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Attribute]') AND name = N'IX_Attrib_StructureID')
CREATE CLUSTERED INDEX [IX_Attrib_StructureID] ON [dbo].[Attribute]
(
	[StructureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeStructure]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AttributeStructure](
	[StructureID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[Priority] [smallint] NOT NULL,
	[DataType] [tinyint] NOT NULL,
	[ShowOnWWW] [bit] NOT NULL,
	[Compulsory] [bit] NOT NULL,
 CONSTRAINT [PK_AttributeStructure_1__47] PRIMARY KEY CLUSTERED 
(
	[StructureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[AttributeStructure] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeStructureCategory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AttributeStructureCategory](
	[AttribStructCatID] [int] IDENTITY(1,1) NOT NULL,
	[AttributeStructureID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_AttributeStructureCate2__31] PRIMARY KEY CLUSTERED 
(
	[AttribStructCatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[AttributeStructureCategory] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditEntryTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditEntryTypes](
	[EntryType] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](64) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_AuditEntryTypes] PRIMARY KEY NONCLUSTERED 
(
	[EntryType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_AuditEntryTypes] UNIQUE NONCLUSTERED 
(
	[EntryType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[AuditEntryTypes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].AuditTrail') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].AuditTrail(
	[EntryID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[EntryType] [int] NULL,
	[EntryDate] [datetime] NULL,
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[StaffID] [int] NULL,
	[Text] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[SuperID] [int] NULL,
	[OrderID] [int] NULL,
	[Branch_ID] [int] NOT NULL,
	[box_id] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Quantity] [int] NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_AUditTrail] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].AuditTrail TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[banking]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[banking](
	[z_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[staff_ID] [int] NOT NULL,
	[banking_date] [datetime] NOT NULL,
	[BranchID] [int] NOT NULL,
	[Currency] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Date_From] [datetime] NOT NULL,
	[Date_to] [datetime] NOT NULL,
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[Closed] [bit] NOT NULL CONSTRAINT [DF_banking_Closed_1__23]  DEFAULT ((0)),
	[Master_Closed] [bit] NOT NULL CONSTRAINT [DF_banking_Master_Closed_3__23]  DEFAULT ((0)),
	[Master_Banking] [bit] NOT NULL CONSTRAINT [DF_banking_Master_Banking2__23]  DEFAULT ((0)),
	[Master_Zid] [int] NULL,
	[Comment] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_banking_branchID_zid] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[z_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[banking] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_Branches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_Branches](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[BankingBrancheID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BankingDate] [datetime] NOT NULL,
	[StaffID] [int] NOT NULL,
	[Safe_ZID] [int] NULL,
	[Note] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Closed] [bit] NOT NULL,
	[Approved] [bit] NOT NULL,
	[ApproveDate] [datetime] NULL,
	[ApprovedBy] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Banking_branches_BranchKey_BankingBrancheID] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[BankingBrancheID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_Branches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_Data]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_Data](
	[z_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OpenBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Banking_Data_OpenBagSeal]  DEFAULT (' '),
	[ExpectedOpenBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Banking_Data_ExpOpenBagSeal]  DEFAULT (' '),
	[CloseBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Banking_Data_CloseBagSeal]  DEFAULT (' '),
	[BagSealNote] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Banking_Data_BagSealNote]  DEFAULT (' '),
	[OpenStaff] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Banking_Data_OpenStaff]  DEFAULT (' '),
 CONSTRAINT [PK_Banking_Data_BranchKey_z_id] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[z_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_Data] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_LineComment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_LineComment](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[EntryID] [int] NOT NULL,
	[ExpectedValue] [money] NULL,
	[Comment] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_Banking_LineComment_BranchKey_EntryID] PRIMARY KEY CLUSTERED 
(
	[Branchkey] ASC,
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_LineComment] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_lines]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_lines](
	[EntryID] [int] NOT NULL,
	[z_id] [int] NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Type] [int] NULL,
	[Currency] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[CurrencyAmount] [money] NULL,
	[ClearingAMount] [money] NULL,
	[Denomination] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PrintOut] [bit] NOT NULL,
 CONSTRAINT [PK_Banking_Lines_BranchKey_EntryID] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_lines] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_linetypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_linetypes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[CountPositive] [bit] NOT NULL CONSTRAINT [DF_Banking_lin_CountPositi]  DEFAULT ((1)),
	[CountNegative] [bit] NOT NULL CONSTRAINT [DF_Banking_lin_CountNegati]  DEFAULT ((0)),
	[DefaultFormOrder] [int] NULL CONSTRAINT [DF_Banking_lin_DefaultForm]  DEFAULT ((0)),
	[ExpandDenominations] [bit] NOT NULL CONSTRAINT [DF_Banking_lin_ExpandDenom]  DEFAULT ((1)),
	[BalancePaymentMethod] [int] NULL,
	[CarryForwardFrom] [int] NULL,
	[Till Banking] [bit] NOT NULL CONSTRAINT [DF_Banking_lin_Till Bankin]  DEFAULT ((0)),
	[Safe Banking] [bit] NOT NULL CONSTRAINT [DF_Banking_lin_Safe Bankin]  DEFAULT ((0)),
 CONSTRAINT [IX_Banking_linetypes] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_linetypes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banking_PDQ]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Banking_PDQ](
	[BankingPDQID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[BankingBranchID] [int] NOT NULL,
	[PDQNumber] [int] NOT NULL,
	[Sale] [money] NOT NULL,
	[Refund] [money] NOT NULL,
 CONSTRAINT [PK_Banking_PDQ_BranchKey_EntryID] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[BankingPDQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Banking_PDQ] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BoxAlias]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BoxAlias](
	[Alias] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_BoxAlias_Alias_3__14]  DEFAULT (' '),
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_BoxAlias_BoxID_4__14]  DEFAULT (' '),
 CONSTRAINT [PK_BoxAlias_1__13] PRIMARY KEY CLUSTERED 
(
	[Alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BoxAlias] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[boxes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[boxes](
	[box_id] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[box_name] [nvarchar](74) COLLATE Latin1_General_CI_AS NULL,
	[box_category] [nvarchar](25) COLLATE Latin1_General_CI_AS NULL,
	[discontinued] [bit] NOT NULL CONSTRAINT [DF_boxes_discontinued_2__18]  DEFAULT ((0)),
	[no_box] [bit] NOT NULL CONSTRAINT [DF_boxes_no_box_6__18]  DEFAULT ((0)),
	[no_inst] [bit] NOT NULL CONSTRAINT [DF_boxes_no_inst_7__18]  DEFAULT ((0)),
	[new] [bit] NOT NULL CONSTRAINT [DF_boxes_new_5__18]  DEFAULT ((0)),
	[origin] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[stock_date] [datetime] NULL,
	[Stockable] [bit] NOT NULL CONSTRAINT [DF_boxes_Stockable_9__18]  DEFAULT ((1)),
	[In_SNReq] [bit] NOT NULL CONSTRAINT [DF_boxes_In_SNReq_3__18]  DEFAULT ((0)),
	[Out_SNReq] [bit] NOT NULL CONSTRAINT [DF_boxes_Out_SNReq_8__18]  DEFAULT ((0)),
	[Box_Deleted] [bit] NOT NULL CONSTRAINT [DF_boxes_Box_Deleted_1__18]  DEFAULT ((0)),
	[TemporaryID] [bit] NOT NULL CONSTRAINT [DF_boxes_TemporaryID_10__18]  DEFAULT ((0)),
	[BoxBarCode] [char](8) COLLATE Latin1_General_CI_AS NULL,
	[zerovat] [bit] NOT NULL CONSTRAINT [DF_boxes_zerovat_11__18]  DEFAULT ((0)),
	[OperatingCompany] [char](4) COLLATE Latin1_General_CI_AS NULL,
	[Last_change_branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Boxes_Last_change_branchkey]  DEFAULT ('  '),
	[CatCode] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[manCode] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[ManProdCode] [char](3) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_boxes_1__16] PRIMARY KEY NONCLUSTERED 
(
	[box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[boxes] TO  SCHEMA OWNER 
GO

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[boxes]') AND name = N'ix_boxID')
CREATE UNIQUE CLUSTERED INDEX [ix_boxID] ON [dbo].[boxes]
(
	[box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BoxPrice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BoxPrice](
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[SellPrice] [money] NOT NULL,
	[CashBuyPrice] [money] NOT NULL,
	[ExchangePrice] [money] NOT NULL,
	[ElasticityID] [int] NOT NULL,
	[UnitCostPrice] [money] NOT NULL,
	[LastUpdatedCostPrice] [datetime] NOT NULL,
 CONSTRAINT [PK_BoxPrice_BoxID] PRIMARY KEY CLUSTERED 
(
	[BoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BoxPrice] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BoxPriceChange]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BoxPriceChange](
	[BPCID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[SellPrice] [money] NULL,
	[CashBuyPrice] [money] NULL,
	[ExchangePrice] [money] NULL,
	[ElasticityID] [int] NULL,
	[Status] [int] NULL,
	[Immediate] [bit] NOT NULL CONSTRAINT [DF_BoxPriceCh_Immediate_1__19]  DEFAULT ((0)),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_BoxPriceCh_CreateDate_1__19]  DEFAULT (getdate()),
 CONSTRAINT [PK_BoxPriceChange_1__19] PRIMARY KEY CLUSTERED 
(
	[BPCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BoxPriceChange] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BoxPriceChangePrinted]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BoxPriceChangePrinted](
	[BPCID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_BoxPriceChangePrinted] PRIMARY KEY CLUSTERED 
(
	[BPCID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BoxPriceChangePrinted] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BoxStock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BoxStock](
	[LocationID] [int] NOT NULL,
	[Boxid] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[ReorderLevel] [int] NULL,
	[LastUpdatedQuantity] [datetime] NULL,
 CONSTRAINT [PK_boxStock] PRIMARY KEY NONCLUSTERED 
(
	[LocationID] ASC,
	[Boxid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BoxStock] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[branchCategoryShortKeys]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[branchCategoryShortKeys](
	[CategoryID] [int] NOT NULL,
	[Branchid] [int] NOT NULL,
	[ShortKey] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_branchCategoryShortKeys] PRIMARY KEY NONCLUSTERED 
(
	[CategoryID] ASC,
	[Branchid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[branchCategoryShortKeys] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Branches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Branches](
	[BranchID] [int] NOT NULL,
	[Creator_BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Branches_Creator_BranchKey]  DEFAULT ('  '),
	[BranchName] [varchar](52) COLLATE Latin1_General_CI_AS NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Branches_Branchkey]  DEFAULT ('  '),
	[Abbrev] [char](8) COLLATE Latin1_General_CI_AS NULL,
	[SaleAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_SaleAllowed]  DEFAULT ((1)),
	[StockInAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_StockInAllowed]  DEFAULT ((1)),
	[StockOutAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_StockOutAllowed]  DEFAULT ((1)),
	[BuyAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_BuyAllowed]  DEFAULT ((1)),
	[ExchangeAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_ExhchangeAllowed]  DEFAULT ((1)),
	[MOAllowed] [bit] NOT NULL CONSTRAINT [DF_Branches_MOAllowed]  DEFAULT ((0)),
	[RepairCentre] [bit] NOT NULL CONSTRAINT [DF_Branches_RepairCentre]  DEFAULT ((0)),
	[address_1] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Branches_address_1]  DEFAULT (' '),
	[address_2] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[city] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[county] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[post_code] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[tel_no] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[fax_no] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[vat_no] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Must_Enter_Heard] [bit] NOT NULL CONSTRAINT [DF_Branches_Must_Enter_Heard]  DEFAULT ((0)),
	[a4_printer_name] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[a4_printer_port] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[a4_printer_driver] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OperatingCompany] [char](4) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Branches_OperatingCompany]  DEFAULT ('    '),
	[ServerName] [char](32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Branches_ServerName_1__17]  DEFAULT (' '),
	[Repair_Branch] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Branches_Repair_Branch]  DEFAULT ('  '),
	[RMA_Branch] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Branches_RMA_Branch]  DEFAULT ('  '),
	[SqMeters] [int] NULL,
	[ZM] [int] NULL,
	[AM] [int] NULL,
	[EmailAddresses] [varchar](255) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF__Branches__EmailA__0FD74C44]  DEFAULT (''),
 CONSTRAINT [PK_Branches_1__14] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_UNIQ_BRANCHES_BK] UNIQUE NONCLUSTERED 
(
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Branches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BranchPrinter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BranchPrinter](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Name] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[PrinterPath] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[PrinterTypeID] [int] NOT NULL,
	[LabelPrinterTypeID] [int] NULL,
	[IsDefault] [bit] NOT NULL DEFAULT ((0)),
	[ReceiptPrinterTypeID] [int] NULL CONSTRAINT [DF__BranchPri__Receipt]  DEFAULT ((0))
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BranchPrinter] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BranchSetting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BranchSetting](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[HiveKey] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Registry_HiveKey]  DEFAULT ('Hive Key Empty'),
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Registry_BranchKey]  DEFAULT ('  '),
	[SubKey] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Registry_SubKey]  DEFAULT ('SubKey Empty'),
	[Value] [varchar](250) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Registry_Value]  DEFAULT ('Value Empty'),
 CONSTRAINT [PK_Registry_1__21] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[BranchSetting] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CapacityModifier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CapacityModifier](
	[CapModID] [int] NOT NULL,
	[LocationID] [int] NOT NULL CONSTRAINT [DF__CapacityM__Locat__60DC6639]  DEFAULT ((0)),
	[SCID] [int] NOT NULL CONSTRAINT [DF__CapacityMo__SCID__61D08A72]  DEFAULT ((0)),
	[StockMult] [real] NOT NULL CONSTRAINT [DF__CapacityM__Stock__62C4AEAB]  DEFAULT ((0)),
	[StockBuffer] [int] NOT NULL,
 CONSTRAINT [PK_CapacityMod] PRIMARY KEY CLUSTERED 
(
	[CapModID] ASC,
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[CapacityModifier] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CardDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CardDetails](
	[CustomerID] [int] NOT NULL,
	[Customer_BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[CardID] [int] NOT NULL,
	[CardDetailsID] [int] NOT NULL,
	[Cancelled] [bit] NOT NULL,
	[CreditBalance] [money] NOT NULL,
 CONSTRAINT [PK_CardDetails] PRIMARY KEY CLUSTERED 
(
	[CardDetailsID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CardDetails] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[category]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[category](
	[category_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Category_Branchkey]  DEFAULT ('  '),
	[category_type] [int] NULL,
	[box_category] [nvarchar](25) COLLATE Latin1_General_CI_AS NULL,
	[box_is_order_id] [int] NULL,
	[read_only] [int] NULL,
	[always_2labels] [int] NULL,
	[show_price_on_label] [int] NULL CONSTRAINT [DF_category_show_price_]  DEFAULT ((1)),
	[Abbrev] [char](2) COLLATE Latin1_General_CI_AS NULL,
	[IN_SNReq] [bit] NOT NULL CONSTRAINT [DF_category_IN_SNReq]  DEFAULT ((0)),
	[Out_SNReq] [bit] NOT NULL CONSTRAINT [DF_category_Out_SNReq]  DEFAULT ((0)),
	[Xfer_SNReq] [bit] NOT NULL CONSTRAINT [DF_category_Xfer_SNReq]  DEFAULT ((0)),
	[ElasticityID] [int] NULL,
	[SCID] [int] NULL,
	[OCID] [int] NULL,
	[FullMemberIn] [int] NULL,
	[FullMemberOut] [int] NULL,
	[ReqTvLicense] [int] NULL,
	[WebSaleAllowed] [tinyint] NULL,
	[WebShowSellPrice] [tinyint] NULL,
	[WebBuyAllowed] [tinyint] NULL,
	[WebShowBuyPrice] [tinyint] NULL,
	[LogTesterName] [tinyint] NULL,
	[NeedBuyPriceRefresh] [tinyint] NULL,
 CONSTRAINT [PK_category_categoryID_branchkey] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UX_Category_BoxCat] UNIQUE NONCLUSTERED 
(
	[box_category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[category] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CategoryDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CategoryDetail](
	[CategoryID] [int] NOT NULL,
	[FriendlyName] [varchar](64) COLLATE Latin1_General_CI_AS NOT NULL,
	[IsNew] [bit] NOT NULL,
	[ShowOnWWW] [bit] NOT NULL,
 CONSTRAINT [PK___1__75] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CategoryDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CategoryModifiers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CategoryModifiers](
	[CategoryModifierID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CategoryModifiers_Branchkey]  DEFAULT ('  '),
	[CategoryID] [int] NULL,
	[CategoryBranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CategoryModifiers_CustBranchkey]  DEFAULT ('  '),
	[Description] [char](32) COLLATE Latin1_General_CI_AS NULL,
	[ActionType] [int] NULL,
	[Value] [numeric](18, 2) NULL,
	[Abbrev] [char](5) COLLATE Latin1_General_CI_AS NULL,
	[print2ndLabel] [bit] NOT NULL CONSTRAINT [DF_CategoryModifiers_2ndLabel]  DEFAULT ((0)),
 CONSTRAINT [PK_CategoryModifiers_ModifierID_branchkey] PRIMARY KEY CLUSTERED 
(
	[CategoryModifierID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CategoryModifiers] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Charity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Charity](
	[CharityID] [int] NOT NULL CONSTRAINT [DF_Charity_CharityID_5__18]  DEFAULT ((0)),
	[CharityName] [varchar](45) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_CharityName_6__18]  DEFAULT (' '),
	[DisplayOrder] [int] NOT NULL CONSTRAINT [DF_Charity_DisplayOrder_7__18]  DEFAULT ((0)),
	[SortCode] [int] NOT NULL CONSTRAINT [DF_Charity_SortCode_10__18]  DEFAULT ((0)),
	[AccountNumber] [int] NOT NULL CONSTRAINT [DF_Charity_AccountNumber_3__18]  DEFAULT ((0)),
	[AccountName] [varchar](250) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_AccountName_2__18]  DEFAULT (' '),
	[RollNumber] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_RollNumber_9__18]  DEFAULT (' '),
	[Active] [bit] NOT NULL CONSTRAINT [DF_Charity_Active_4__18]  DEFAULT ((0)),
	[OptInClause] [varchar](254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_OptInClause_8__18]  DEFAULT (' '),
	[ThanksClause] [varchar](254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_ThanksClause_11__18]  DEFAULT (' '),
	[URL] [varchar](254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Charity_URL_12__18]  DEFAULT (' '),
 CONSTRAINT [PK_Charity_1__18] PRIMARY KEY CLUSTERED 
(
	[CharityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Charity] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CheckList](
	[chkListID] [int] NOT NULL,
	[Box_id] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_CheckList_2__204] PRIMARY KEY CLUSTERED 
(
	[chkListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CheckList] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckListDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CheckListDetails](
	[chklistID] [int] NOT NULL,
	[chkitemID] [int] NOT NULL,
	[priority] [int] NOT NULL,
 CONSTRAINT [PK_CheckListDetails_1__204] PRIMARY KEY CLUSTERED 
(
	[chkitemID] ASC,
	[chklistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[CheckListDetails] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckListItems]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CheckListItems](
	[chkitemID] [int] NOT NULL,
	[action] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[type] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_CheckListItems_1__204] PRIMARY KEY CLUSTERED 
(
	[chkitemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CheckListItems] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cheques]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cheques](
	[order_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[customer_id] [int] NOT NULL,
	[Customer_BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[cheque_no] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[cheque_void] [int] NULL,
	[void_reason] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_cheques] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[cheques] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClauseLines]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClauseLines](
	[ClauseID] [varchar](4) COLLATE Latin1_General_CI_AS NOT NULL,
	[LineNumber] [int] NOT NULL CONSTRAINT [DF_ClauseLines_LineNumber]  DEFAULT ((1)),
	[LineText] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_ClauseLines] PRIMARY KEY NONCLUSTERED 
(
	[ClauseID] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_ClauseLines] UNIQUE NONCLUSTERED 
(
	[ClauseID] ASC,
	[LineNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ClauseLines] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clauses]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Clauses](
	[ClauseID] [varchar](4) COLLATE Latin1_General_CI_AS NOT NULL,
	[ClauseDescription] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Clauses] PRIMARY KEY NONCLUSTERED 
(
	[ClauseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_Clauses] UNIQUE NONCLUSTERED 
(
	[ClauseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Clauses] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](40) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [bit] NOT NULL,
	[DefaultSelect] [bit] NOT NULL CONSTRAINT [DF_Country_Default]  DEFAULT ((0)),
 CONSTRAINT [PK_Country_1__12] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Country] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CountyStates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CountyStates](
	[CountyStateName] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[CountyStateCode] [varchar](3) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CountyStates] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[credit_cards]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[credit_cards](
	[customer_id] [int] NULL,
	[card_no] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[card_type] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[expiry_date] [datetime] NULL,
	[issue_no] [int] NULL,
	[authorisation_no] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[amount] [int] NULL,
	[start_date] [datetime] NULL,
 CONSTRAINT [IX_credit_cards] UNIQUE NONCLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[credit_cards] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreditCardTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreditCardTypes](
	[CardID] [int] IDENTITY(1,1) NOT NULL,
	[CardName] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_CreditCardTypes] PRIMARY KEY NONCLUSTERED 
(
	[CardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_CreditCardTypes] UNIQUE NONCLUSTERED 
(
	[CardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CreditCardTypes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[currencies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[currencies](
	[currencyID] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[CurrencyName] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExchangeRate] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_currencies_1__13] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_currencies] UNIQUE NONCLUSTERED 
(
	[currencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[currencies] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CurrencyDenominations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CurrencyDenominations](
	[CurrencyID] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Denomination] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Value] [numeric](18, 3) NULL,
	[Sequence] [int] NOT NULL CONSTRAINT [DF_CurrencyDen_Sequence]  DEFAULT ((0)),
 CONSTRAINT [PK_CurrencyDenominations] PRIMARY KEY NONCLUSTERED 
(
	[CurrencyID] ASC,
	[Denomination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CurrencyDenominations] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Customer](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_Branchkey]  DEFAULT ('  '),
	[AccountID] [int] NOT NULL CONSTRAINT [DF_Customer_AccountID_4__25]  DEFAULT ((0)),
	[Title] [varchar](15) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_Title_32__25]  DEFAULT (' '),
	[Firstname] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_Firstname_14__25]  DEFAULT (' '),
	[LastName] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_LastName_25__25]  DEFAULT (' '),
	[DateOfBirth] [datetime] NOT NULL CONSTRAINT [DF_Customer_DateOfBirth_10__25]  DEFAULT ('1 jan 1900'),
	[Organisation] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Building] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Street1] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street2] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street3] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street4] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street5] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Town] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[County] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[AddressVerified] [bit] NOT NULL CONSTRAINT [DF_Customer_AddressVerifi8__25]  DEFAULT ((0)),
	[AddressManual] [bit] NOT NULL CONSTRAINT [DF_Customer_AddressManual6__25]  DEFAULT ((0)),
	[Email] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PhoneHome] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[PhoneWork] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[PhoneMobile] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[SnailMailOk] [bit] NOT NULL CONSTRAINT [DF_Customer_SnailMailOk_27__25]  DEFAULT ((0)),
	[EmailOk] [bit] NOT NULL CONSTRAINT [DF_Customer_EmailOk_12__25]  DEFAULT ((0)),
	[SMSOk] [bit] NOT NULL CONSTRAINT [DF_Customer_SMSOk_26__25]  DEFAULT ((0)),
	[SubscriptionDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_Subscription31__25]  DEFAULT ('1 jan 1900'),
	[SubscribedBy] [int] NOT NULL CONSTRAINT [DF_Customer_SubscribedBy30__25]  DEFAULT ((0)),
	[ExchangeOnly] [bit] NOT NULL CONSTRAINT [DF_Customer_ExchangeOnly13__25]  DEFAULT ((0)),
	[DateOfLastContact] [datetime] NOT NULL CONSTRAINT [DF_Customer_DateOfLastCo11__25]  DEFAULT ('1 jan 1900'),
	[AddressRefreshDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_AddressRefres7__25]  DEFAULT ('1 jan 1900'),
	[ID1Type] [int] NOT NULL CONSTRAINT [DF_Customer_ID1Type_18__25]  DEFAULT ((0)),
	[ID1Mod] [int] NOT NULL CONSTRAINT [DF_Customer_ID1Mod_17__25]  DEFAULT ((0)),
	[ID1Data] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_ID1Data_16__25]  DEFAULT (' '),
	[ID2Type] [int] NOT NULL CONSTRAINT [DF_Customer_ID2Type_21__25]  DEFAULT ((0)),
	[ID2Mod] [int] NOT NULL CONSTRAINT [DF_Customer_ID2Mod_20__25]  DEFAULT ((0)),
	[ID2Data] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_ID2Data_19__25]  DEFAULT (' '),
	[AccountActive] [bit] NOT NULL CONSTRAINT [DF_Customer_AccountActive1__25]  DEFAULT ((1)),
	[AccountClosed] [bit] NOT NULL CONSTRAINT [DF_Customer_AccountClosed3__25]  DEFAULT ((0)),
	[AccountBanned] [bit] NOT NULL CONSTRAINT [DF_Customer_AccountBanned2__25]  DEFAULT ((0)),
	[AccountWatched] [bit] NOT NULL CONSTRAINT [DF_Customer_AccountWatche5__25]  DEFAULT ((0)),
	[StatusBy] [int] NOT NULL CONSTRAINT [DF_Customer_StatusBy_28__25]  DEFAULT ((0)),
	[StatusDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_StatusDate_29__25]  DEFAULT ('1 jan 1900'),
	[LastChangedBy] [int] NOT NULL CONSTRAINT [DF_Customer_LastChangedB23__25]  DEFAULT ((0)),
	[LastChangedWhen] [datetime] NOT NULL CONSTRAINT [DF_Customer_LastChangedW24__25]  DEFAULT ('1 jan 1900'),
	[Dodgy1] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Dodgy2] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[HeardFrom] [int] NULL,
	[LastChangeBranchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Customer_LastChangeBranchkey]  DEFAULT ('  '),
	[GuardianApproval] [bit] NOT NULL CONSTRAINT [DF_Customer_GuardianAppr15__25]  DEFAULT ((0)),
	[TotalBuy] [money] NOT NULL CONSTRAINT [DF_Customer_TotalBuy_33__25]  DEFAULT ((0)),
	[TotalSell] [money] NOT NULL CONSTRAINT [DF_Customer_TotalSell_35__25]  DEFAULT ((0)),
	[TotalRefund] [money] NOT NULL CONSTRAINT [DF_Customer_TotalRefund_34__25]  DEFAULT ((0)),
	[TotalTranactions] [int] NOT NULL CONSTRAINT [DF_Customer_TotalTranact36__25]  DEFAULT ((0)),
 CONSTRAINT [PK_Branchkey_AccountID_Customer] PRIMARY KEY CLUSTERED 
(
	[Branchkey] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Customer] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerCard]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomerCard](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[AccountID] [int] NOT NULL,
	[CardNumber] [int] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[IssuedBy] [int] NOT NULL,
	[CancelledDate] [datetime] NULL,
	[CancelledBy] [int] NULL,
	[CancelNote] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Cancelled] [bit] NOT NULL,
	[LastChangeBranchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_CustomerCard] PRIMARY KEY NONCLUSTERED 
(
	[CardNumber] ASC,
	[IssueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CustomerCard] TO  SCHEMA OWNER 
GO

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomerCard]') AND name = N'ncl_Branchkey_AccountID_CustomerCard')
CREATE CLUSTERED INDEX [ncl_Branchkey_AccountID_CustomerCard] ON [dbo].[CustomerCard]
(
	[Branchkey] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerIDMod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomerIDMod](
	[IDModID] [int] IDENTITY(1,1) NOT NULL,
	[IDModText] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[IDModSet] [int] NOT NULL,
	[IDModInUse] [bit] NOT NULL,
	[DefaultSelect] [bit] NOT NULL CONSTRAINT [DF_CustomerIDMod_DefaultSelect]  DEFAULT ((0)),
	[NameShown] [bit] NOT NULL DEFAULT ((0)),
	[AddressShown] [bit] NOT NULL DEFAULT ((0)),
	[SignatureShown] [bit] NOT NULL DEFAULT ((0)),
	[PhotoShown] [bit] NOT NULL DEFAULT ((0)),
	[GovernmentIssued] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_CustomerIDMod] PRIMARY KEY NONCLUSTERED 
(
	[IDModID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CustomerIDMod] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerIDType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomerIDType](
	[IDTypeID] [int] IDENTITY(1,1) NOT NULL,
	[IDType] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[UseModSet] [int] NOT NULL,
	[UseCountry] [int] NOT NULL,
	[TypeInUse] [int] NOT NULL,
 CONSTRAINT [PK_CustomerIDType] PRIMARY KEY NONCLUSTERED 
(
	[IDTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[CustomerIDType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBQueue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DBQueue](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[QueueId] [int] NOT NULL,
	[QueueTypeId] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_DBQueue_CreatedOn]  DEFAULT (getdate()),
	[LastReadOn] [datetime] NULL,
	[LockExpiresOn] [datetime] NULL,
	[Attempts] [int] NOT NULL CONSTRAINT [DF_DBQueue_Attempts]  DEFAULT ((0)),
	[DetailRecordCount] [int] NOT NULL CONSTRAINT [DF_DBQueue_DetailRecordCount]  DEFAULT ((0)),
	[StaffID] [int] NOT NULL,
	[ClientWorkstation] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	CONSTRAINT [PK_BranchKey_QueueId_DBQueue] PRIMARY KEY CLUSTERED 
	(
		[BranchKey] ASC,
		[QueueId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[DBQueue] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBQueueDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DBQueueDetail](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[QueueDetailId] [int] NOT NULL,
	[QueueId] [int] NOT NULL,
	[KeyName] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Value] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	CONSTRAINT [PK_DBQueueDetail_BranchKey_QueueDetailId] PRIMARY KEY CLUSTERED 
	(
		[BranchKey] ASC,
		[QueueDetailId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

END
GO

GO
ALTER AUTHORIZATION ON [dbo].[DBQueueDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DBQueueType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DBQueueType](
	[QueueTypeId] [int] NOT NULL,
	[QueueName] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_DBQueueType_QueueName]  DEFAULT (''),
	[LockDuration] [int] NOT NULL CONSTRAINT [DF_DBQueueType_LockDuration]  DEFAULT ((0)),
	[DelayDuration] [int] NULL,
	[AttemptsCount] [int] NULL,
 CONSTRAINT [PK_DBQueueType] PRIMARY KEY CLUSTERED 
(
	[QueueTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[DBQueueType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Elasticity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Elasticity](
	[ElasticityID] [int] NOT NULL,
	[BuyPerc] [money] NOT NULL,
	[ExchangePerc] [money] NOT NULL,
	[Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Elasticity_1__21] PRIMARY KEY CLUSTERED 
(
	[ElasticityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Elasticity] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Errors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Errors](
	[Error_ID] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NULL,
	[Branch] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Workstation] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ErrNo] [int] NULL,
	[ErrDescription] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Operator] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Source] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Severity] [int] NULL,
	[Response] [int] NULL,
	[Comment] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Version] [varchar](12) COLLATE Latin1_General_CI_AS NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Errors] PRIMARY KEY CLUSTERED 
(
	[Error_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Errors] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FloorLimits]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FloorLimits](
	[BranchID] [int] NOT NULL,
	[CashBuyLimit] [money] NOT NULL,
	[ExchangeLimit] [money] NOT NULL,
	[BuyLimitsActive] [int] NOT NULL,
	[DrawerFloorLimit] [money] NOT NULL,
	[DrawerCeilingLimit] [money] NOT NULL,
	[DrawerLimitsActive] [int] NOT NULL,
 CONSTRAINT [PK_Floorlimit_01] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[FloorLimits] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[hear]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[hear](
	[hear_id] [int] NOT NULL,
	[hear_place] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[BranchID] [int] NULL,
 CONSTRAINT [PK__hear__hear_id__2EBAFAC0] PRIMARY KEY CLUSTERED 
(
	[hear_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[hear] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Holding_BranchPrices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Holding_BranchPrices](
	[HBPID] [int] IDENTITY(1,1) NOT NULL,
	[BranchID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[SellPrice] [money] NULL,
	[CashBuyPrice] [money] NULL,
	[ExchangePrice] [money] NULL,
	[ElasticityID] [int] NULL,
	[Status] [int] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_Holding_Br_CreateDate_1__20]  DEFAULT (getdate()),
 CONSTRAINT [PK_Holding_BranchPrices_1__20] PRIMARY KEY CLUSTERED 
(
	[HBPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Holding_BranchPrices] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InternalOrders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InternalOrders](
	[OrderID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[RequesterID] [int] NOT NULL,
	[AuthoriserID] [int] NULL,
	[RecipientID] [int] NOT NULL,
	[Notes] [varchar](60) COLLATE Latin1_General_CI_AS NOT NULL,
	[EntryID] [int] NOT NULL,
	[DestinationBranchID] [int] NOT NULL,
	[DestinationLocationType] [int] NULL,
 CONSTRAINT [PK_BranchKey_EntryID_InternalOrders] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[InternalOrders] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LabelPrinterType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LabelPrinterType](
	[LabelPrinterTypeID] [int] NOT NULL,
	[Description] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
	[XOffset] [int] NULL,
	[YOffset] [int] NULL,
 CONSTRAINT [PK_LabelPrinterType] PRIMARY KEY CLUSTERED 
(
	[LabelPrinterTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[LabelPrinterType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationBranches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LocationBranches](
	[LocationID] [int] NOT NULL,
	[BranchID] [int] NOT NULL,
	[LocationType] [int] NOT NULL,
 CONSTRAINT [PK_LocationBranches] PRIMARY KEY NONCLUSTERED 
(
	[LocationID] ASC,
	[BranchID] ASC,
	[LocationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_LocationBranches] UNIQUE NONCLUSTERED 
(
	[LocationID] ASC,
	[BranchID] ASC,
	[LocationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[LocationBranches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[locations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[locations](
	[Location_id] [int] NOT NULL,
	[Location_name] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_locations_2__33] PRIMARY KEY CLUSTERED 
(
	[Location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[locations] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LocationTypes](
	[ID] [int] NOT NULL,
	[Description] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_LocationTypes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_LocationTypes] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[LocationTypes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Lock](
	[LockID] [int] IDENTITY(1,1) NOT NULL,
	[AppName] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[JobName] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[LockedBy] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[LockedAt] [datetime] NOT NULL,
	[Workstation] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[CanDelete] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK___4__15] PRIMARY KEY CLUSTERED 
(
	[LockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Lock] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[login_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[login_info](
	[login_code] [int] NOT NULL,
	[login_data] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Branchid] [int] NOT NULL,
 CONSTRAINT [PK__login_inf__login__66FF53E3] PRIMARY KEY CLUSTERED 
(
	[login_code] ASC,
	[Branchid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[login_info] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManProducts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ManProducts](
	[ManProdCode] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[ManCode] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[ProductLine] [varchar](32) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ManProducts] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Manufacturers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Manufacturers](
	[Mancode] [char](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[Manufacturer] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_Manufacturers] PRIMARY KEY NONCLUSTERED 
(
	[Mancode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Manufacturers] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MobilePhone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MobilePhone](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[MobileID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IMEI] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[SecurityCode] [varchar](12) COLLATE Latin1_General_CI_AS NULL,
	[BuyinOrderID] [int] NOT NULL,
	[DiscountedNote] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Boxid] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Network] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_BranchKey_MobileID_MobilePhone] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[MobileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[MobilePhone] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MobilePhoneNetwork]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MobilePhoneNetwork](
	[NetworkID] [int] IDENTITY(1,1) NOT NULL,
	[NetworkName] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_MobilePhon_NetworkName7__18]  DEFAULT (' '),
	[CategoryModifierID] [int] NOT NULL CONSTRAINT [DF_MobilePhon_CategoryMod5__18]  DEFAULT ((0)),
	[DisplayOrder] [int] NOT NULL CONSTRAINT [DF_MobilePhon_DisplayOrde6__18]  DEFAULT ((0)),
 CONSTRAINT [PK___4__18] PRIMARY KEY CLUSTERED 
(
	[NetworkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[MobilePhoneNetwork] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[numbers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[numbers](
	[number_type] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[number_number] [int] NOT NULL,
	[previous_number] [int] NOT NULL,
	[increment_size] [int] NOT NULL,
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[numbers] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperatingCompany]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OperatingCompany](
	[OCID] [int] IDENTITY(1,1) NOT NULL,
	[RegName] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[RegCountry] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[RegNumber] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[ShortName] [varchar](6) COLLATE Latin1_General_CI_AS NULL,
	[UmbrellaCompany] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CompanyEmailAddress] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK___1__17] PRIMARY KEY CLUSTERED 
(
	[OCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OperatingCompany] TO  SCHEMA OWNER 
GO

ALTER TABLE OperatingCompany ADD CONSTRAINT unq_regname_operatingcompany UNIQUE(Regname)
GO

ALTER TABLE dbo.OperatingCompany ALTER COLUMN OCID ADD NOT FOR REPLICATION

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[order_details](
	[Order_details_ID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[order_id] [int] NOT NULL,
	[box_id] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[quantity] [int] NULL,
	[price] [money] NULL,
	[TxType] [int] NOT NULL,
	[type] [int] NULL,
	[discount] [money] NULL,
	[ItemSN] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Refunded] [int] NOT NULL,
	[Picked_Up] [bit] NOT NULL,
	[Accepted] [bit] NOT NULL,
	[TrackNo] [int] NULL,
 CONSTRAINT [PK_OrderdetailID_Branchkey_orderDetails] PRIMARY KEY CLUSTERED 
(
	[Order_details_ID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[order_details] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[order_notes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[order_notes](
	[OrderNoteID] [int] NOT NULL,
	[order_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Note_Date] [datetime] NULL,
	[Staff_id] [int] NULL,
	[Text] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_OrderNoteID_BranchKey_order_notes] PRIMARY KEY CLUSTERED 
(
	[OrderNoteID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[order_notes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderCharityElement]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderCharityElement](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_OrderCharityElement_Branchkey]  DEFAULT ('  '),
	[OrderID] [int] NOT NULL CONSTRAINT [DF_OrderChari_OrderID_8__16]  DEFAULT ((0)),
	[CharityID] [int] NOT NULL CONSTRAINT [DF_OrderChari_CharityID_2__16]  DEFAULT ((0)),
	[DonationAmount] [money] NOT NULL CONSTRAINT [DF_OrderChari_DonationAmo3__16]  DEFAULT ((0)),
	[DonationPercentage] [int] NOT NULL CONSTRAINT [DF_OrderChari_DonationPer4__16]  DEFAULT ((0)),
	[GiftAid] [bit] NOT NULL CONSTRAINT [DF_OrderChari_GiftAid_6__16]  DEFAULT ((0)),
	[OptIn] [bit] NOT NULL CONSTRAINT [DF_OrderChari_OptIn_7__16]  DEFAULT ((0)),
	[DonationSent] [bit] NOT NULL CONSTRAINT [DF_OrderChari_DonationSen5__16]  DEFAULT ((0)),
 CONSTRAINT [PK_OrderID_Branchkey_OrderCharityElement] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[Branchkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderCharityElement] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetailCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDetailCategories](
	[ODMID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Order_details_ID] [int] NOT NULL,
	[CategoryModifierID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[Box_id] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_ODMID_Branchkey_OrderDetailCategories] PRIMARY KEY CLUSTERED 
(
	[ODMID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderDetailCategories] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetailIdentifier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDetailIdentifier](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrderDetailsId] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderId] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Value] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_OrderDetailIdentifier_OrderDetailsId_Branchkey] PRIMARY KEY CLUSTERED 
(
	[OrderDetailsId] ASC,
	[BranchKey] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderDetailIdentifier] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetailIdentifierType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderDetailIdentifierType](
	[Id] [int] NOT NULL,
	[Name] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderDetailIdentifierType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderPaymentElements]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderPaymentElements](
	[OPEID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[orderid] [int] NULL,
	[PaymentMethodID] [int] NULL,
	[CurrencyID] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[ClearingAmount] [money] NULL,
	[CurrencyAmount] [money] NULL,
	[Redeemed] [bit] NOT NULL,
 CONSTRAINT [PK_OPEID_Branchkey_OrderPaymentElements] PRIMARY KEY CLUSTERED 
(
	[OPEID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderPaymentElements] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderPaymentTaxRate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderPaymentTaxRate](
	[OPEID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[TaxRate] [decimal](6, 4) NOT NULL,
 CONSTRAINT [PK_OrderPaymentTR_O_BK] PRIMARY KEY CLUSTERED 
(
	[OPEID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderPaymentTaxRate] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[orders](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[order_id] [int] NOT NULL,
	[customer_id] [int] NOT NULL,
	[Customer_BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[staff_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL,
	[processed] [bit] NOT NULL,
	[CashOrExchange] [bit] NOT NULL,
	[HardwareOrGames] [int] NOT NULL,
	[branch_id] [int] NOT NULL,
	[terminal] [varchar](15) COLLATE Latin1_General_CI_AS NOT NULL,
	[HEardID] [int] NULL,
	[Order_Type] [int] NOT NULL,
	[heardtext] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PlatformID] [int] NULL,
 CONSTRAINT [PK_order_id_branchkey_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[orders] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderTypes](
	[ID] [int] NOT NULL,
	[Description] [char](15) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_OrderTypes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_OrderTypes] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[OrderTypes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Origins]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Origins](
	[OriginID] [int] IDENTITY(1,1) NOT NULL,
	[Origin] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Abbrev] [char](1) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Origins] PRIMARY KEY NONCLUSTERED 
(
	[OriginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_Origins] UNIQUE NONCLUSTERED 
(
	[OriginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Origins] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentGroup](
	[GroupRecordID] [int] NOT NULL,
	[LongName] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[ShortName] [varchar](12) COLLATE Latin1_General_CI_AS NOT NULL,
	[Accountable] [bit] NOT NULL,
	[CanSum] [bit] NOT NULL,
 CONSTRAINT [PK___2__18] PRIMARY KEY CLUSTERED 
(
	[GroupRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_PayGrp_LongName] UNIQUE NONCLUSTERED 
(
	[LongName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_PayGrp_ShortName] UNIQUE NONCLUSTERED 
(
	[ShortName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PaymentGroup] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentMethods]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentMethods](
	[PaymentMethodID] [int] IDENTITY(1,1) NOT NULL,
	[paymentMethod] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[PaymentIn] [bit] NOT NULL CONSTRAINT [DF_PaymentMethods_PaymentIn]  DEFAULT ((1)),
	[GroupRecordID] [int] NULL,
	[PublicName] [nvarchar](30) COLLATE Latin1_General_CI_AS NULL,
	[ReceiptName] [nvarchar](30) COLLATE Latin1_General_CI_AS NULL,
	[ReceiptSequence] [int] NULL,
 CONSTRAINT [PK_PaymentMethods] PRIMARY KEY NONCLUSTERED 
(
	[PaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_PaymentMethods] UNIQUE NONCLUSTERED 
(
	[PaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PaymentMethods] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PendingPriceChanges]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PendingPriceChanges](
	[ID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Branchid] [int] NULL,
	[Box_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[SellPrice] [money] NULL,
	[CashBuyPrice] [money] NULL,
	[ExchangePrice] [money] NULL,
	[EntryDate] [datetime] NULL,
	[ReleaseDate] [datetime] NULL,
	[Staff_ID] [int] NULL,
	[RepriceDate] [datetime] NULL,
	[RepriceOldSell] [money] NULL,
	[RepriceOldExch] [money] NULL,
	[RepriceOldBuy] [money] NULL,
	[RepriceComplete] [bit] NOT NULL,
 CONSTRAINT [PK_PendingPriceChanges] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PendingPriceChanges] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Permissions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Permissions](
	[PermissionText] [varchar](64) COLLATE Latin1_General_CI_AS NOT NULL,
	[PermissionLevel] [int] NULL,
 CONSTRAINT [PK_Permissions] PRIMARY KEY NONCLUSTERED 
(
	[PermissionText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [prmIdx] UNIQUE CLUSTERED 
(
	[PermissionText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Permissions] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Platform]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Platform](
	[ID] [int] NOT NULL,
	[Name] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_platform] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Platform] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlatformOrderTypePaymentMethod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PlatformOrderTypePaymentMethod](
	[PlatformID] [int] NOT NULL,
	[OrderType] [int] NOT NULL,
	[PaymentMethodID] [int] NOT NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [UQ_PlatformOrderTypePaymentMethod] UNIQUE NONCLUSTERED 
(
	[PlatformID] ASC,
	[OrderType] ASC,
	[PaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[PlatformOrderTypePaymentMethod] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlatformTextKeyMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PlatformTextKeyMapping](
	[PlatformId] [int] NOT NULL,
	[TextKey] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_PlatformTextKeyMapping] PRIMARY KEY CLUSTERED 
(
	[PlatformId] ASC,
	[TextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PlatformTextKeyMapping] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PODeliveries]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PODeliveries](
	[EntryID] [int] NOT NULL,
	[POID] [int] NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NULL,
	[DestinationBranchID] [int] NULL,
	[Completed] [bit] NOT NULL,
	[Discrepancy] [bit] NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PODeliveries] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PODeliveryDiscrepancies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PODeliveryDiscrepancies](
	[EntryID] [int] NOT NULL,
	[BranchKEy] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[PODeliveryID] [int] NULL,
	[Order_details_ID] [int] NULL,
	[Boxid] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Expected] [int] NULL,
	[Actual] [int] NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PODeliveryDiscrepancies] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceDiffs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PriceDiffs](
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[BoxPriceSellPrice] [money] NOT NULL,
	[BranchPricesSellPrice] [money] NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PriceDiffs] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrinterType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PrinterType](
	[PrinterTypeID] [int] NOT NULL,
	[PrinterTypeDesc] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_PrinterType] PRIMARY KEY CLUSTERED 
(
	[PrinterTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PrinterType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductLine]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductLine](
	[ProductLineID] [int] NOT NULL,
	[LineName] [varchar](64) COLLATE Latin1_General_CI_AS NOT NULL,
	[SuperCatID] [int] NOT NULL,
 CONSTRAINT [PK___2__75] PRIMARY KEY CLUSTERED 
(
	[ProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ProductLine] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductlineCat]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductlineCat](
	[ProductLineCatID] [int] NOT NULL,
	[ProductLineID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK__4__75] PRIMARY KEY CLUSTERED 
(
	[ProductLineCatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[ProductlineCat] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurchaseOrderDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PurchaseOrderDetails](
	[EntryID] [int] NOT NULL,
	[POID] [int] NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Boxid] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Quantity] [int] NULL,
	[ClearingCurrencyPrice] [money] NULL,
	[TaxRate] [numeric](18, 4) NULL,
	[CurrencyID] [char](4) COLLATE Latin1_General_CI_AS NULL,
	[OriginalCurrencyPrice] [money] NULL,
	[Completed] [bit] NOT NULL,
	[BranchID] [int] NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PurchaseOrderDetails] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PurchaseOrders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PurchaseOrders](
	[PurchaseOrderID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[PODate] [datetime] NULL,
	[PONumber] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Buyer_StaffID] [int] NULL,
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[SupplierID] [int] NULL,
	[DueDate] [datetime] NULL,
	[SupplierRef] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[SignedOff] [bit] NOT NULL,
	[Payed] [bit] NOT NULL,
	[Notes] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
	[PayDue] [datetime] NULL,
	[PayTerms] [char](4) COLLATE Latin1_General_CI_AS NULL,
	[DaystoPay] [int] NULL,
 CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY CLUSTERED 
(
	[PurchaseOrderID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[PurchaseOrders] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reasons]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Reasons](
	[ReasonId] [int] IDENTITY(1,1) NOT NULL,
	[ReasonTypeId] [int] NOT NULL,
	[ReasonDescription] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_Reasons] PRIMARY KEY CLUSTERED 
(
	[ReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Reasons] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReasonType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReasonType](
	[ReasonTypeId] [int] NOT NULL,
	[ReasonTypeDescription] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_ReasonType] PRIMARY KEY CLUSTERED 
(
	[ReasonTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ReasonType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceiptPrinterType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReceiptPrinterType](
	[ReceiptPrinterTypeID] [int] NOT NULL,
	[Description] [varchar](64) COLLATE Latin1_General_CI_AS NULL,
	[XOffset] [int] NULL DEFAULT ((0)),
	[YOffset] [int] NULL DEFAULT ((0)),
 CONSTRAINT [PK_ReceiptPrinterType] PRIMARY KEY CLUSTERED 
(
	[ReceiptPrinterTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ReceiptPrinterType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefundDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RefundDetails](
	[OrderID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Order_details_ID] [int] NOT NULL,
	[RefundToSuggest] [smallint] NOT NULL,
	[RefundToActual] [smallint] NOT NULL,
 CONSTRAINT [PK_OrdDetailID_Branchkey_RefundDetails] PRIMARY KEY CLUSTERED 
(
	[Order_details_ID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[RefundDetails] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefundReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RefundReason](
	[RefundReasonID] [int] IDENTITY(1,1) NOT NULL,
	[Reason] [varchar](60) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Explain] [bit] NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[RefundReason] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Refunds]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Refunds](
	[OrderID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Refunds_branchkey]  DEFAULT ('  '),
	[AuthorisedbyID] [int] NOT NULL,
	[Explanation] [varchar](60) COLLATE Latin1_General_CI_AS NOT NULL,
	[OriginalOrderID] [int] NOT NULL,
	[OriginalBranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_Refunds_OriginalBranchKey]  DEFAULT ('  '),
	[ReasonID] [int] NULL,
 CONSTRAINT [PK_OrderID_Branchkey_Refunds] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Refunds] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reserves]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[reserves](
	[ReserveID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[box_id] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NULL,
	[Quantity] [int] NULL,
	[Reserve_Date] [datetime] NULL,
	[Satisfied] [bit] NOT NULL,
 CONSTRAINT [PK_reserves] PRIMARY KEY CLUSTERED 
(
	[ReserveID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[reserves] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResourceTranslation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ResourceTranslation](
	[LanguageId] [int] NOT NULL,
	[TextKey] [varchar](100) COLLATE Latin1_General_CI_AS NOT NULL,
	[TranslationText] [nvarchar](3950) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_ResourceTranslation] PRIMARY KEY CLUSTERED 
(
	[LanguageId] ASC,
	[TextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[ResourceTranslation] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RMABranches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RMABranches](
	[BranchId] [int] NOT NULL,
	[RMABranchId] [int] NOT NULL,
 CONSTRAINT [PK_RMABranches] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC,
	[RMABranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[RMABranches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RMAReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RMAReason](
	[RMAReasonID] [int] IDENTITY(1,1) NOT NULL,
	[ReasonForRMA] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[InUse] [tinyint] NULL DEFAULT ((1)),
 CONSTRAINT [pk_RMAReasonID] PRIMARY KEY CLUSTERED 
(
	[RMAReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[RMAReason] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RMAReasonCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RMAReasonCode](
	[CodeLetter] [varchar](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[Reason] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [PK_RMAReasonCode_1__18] PRIMARY KEY CLUSTERED 
(
	[CodeLetter] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[RMAReasonCode] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RMAStoresBranches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RMAStoresBranches](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[RMABranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_RMAStoresBranches] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[RMABranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[RMAStoresBranches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rounder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Rounder](
	[SCID] [int] NOT NULL,
	[PreInc] [bit] NOT NULL,
	[Threshold] [money] NOT NULL,
	[LowDelta] [money] NOT NULL,
	[LowRndUp] [bit] NOT NULL,
	[LowRndDown] [bit] NOT NULL,
	[LowRndNear] [bit] NOT NULL,
	[HighDelta] [money] NOT NULL,
	[HighRndUp] [bit] NOT NULL,
	[HighRndDown] [bit] NOT NULL,
	[HighRndNear] [bit] NOT NULL,
 CONSTRAINT [PK_Rounder_1__18] PRIMARY KEY CLUSTERED 
(
	[SCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[Rounder] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Setting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Setting](
	[SettingID] [int] IDENTITY(1,1) NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Setting] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Value] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK___4__17] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Setting] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SoftwareVersion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SoftwareVersion](
	[VersionIndex] [int] IDENTITY(1,1) NOT NULL,
	[BranchID] [int] NOT NULL,
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[EposVersion] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpgradeDate] [datetime] NOT NULL,
 CONSTRAINT [PK___1__14] PRIMARY KEY CLUSTERED 
(
	[VersionIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SoftwareVersion] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[staff]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[staff](
	[staff_id] [int] NOT NULL,
	[staff] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[staff_email_name] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[home_branchID] [int] NULL,
	[security_level] [int] NULL,
	[TagNumber] [varchar](6) COLLATE Latin1_General_CI_AS NULL,
	[initials] [char](2) COLLATE Latin1_General_CI_AS NULL,
	[FullName] [varchar](48) COLLATE Latin1_General_CI_AS NULL,
	[Staff_number] [varchar](12) COLLATE Latin1_General_CI_AS NULL,
	[Entrydate] [datetime] NULL,
	[Leaverdate] [datetime] NULL,
	[DateOfBirth] [datetime] NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK__staff__staff_id__4B57396E] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ_Staff_TagNumber] UNIQUE NONCLUSTERED 
(
	[TagNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[staff] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StaffBranches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StaffBranches](
	[BranchId] [int] NOT NULL,
	[StaffId] [int] NOT NULL,
 CONSTRAINT [PK_StaffBranches] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC,
	[StaffId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[StaffBranches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stinc_old]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Stinc_old](
	[StincID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BranchKey] [varchar](2) COLLATE Latin1_General_CI_AS NOT NULL,
	[Category_id] [int] NOT NULL,
	[WeekNum] [int] NOT NULL,
	[WeekStartDate] [datetime] NOT NULL,
	[WeekEndDate] [datetime] NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[CashIn] [money] NOT NULL,
	[CashOut] [money] NOT NULL,
	[TI] [money] NOT NULL,
	[SUCCESS] [bit] NOT NULL,
 CONSTRAINT [PK_Stinc_1__16] PRIMARY KEY CLUSTERED 
(
	[StincID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Stinc_old] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockInRMADetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockInRMADetail](
	[OrderDetailsId] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderId] [int] NOT NULL,
	[StockedIn] [char](1) COLLATE Latin1_General_CI_AS NULL,
	[ReasonId] [int] NULL,
	[Reason] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[InitialStockInDate] [datetime] NULL,
 CONSTRAINT [PK_StockInRMADetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailsId] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockInRMADetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockLevel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockLevel](
	[CategoryID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[MinStock] [int] NOT NULL,
	[OptStock] [int] NOT NULL,
	[MaxStock] [int] NOT NULL,
	[Capacity] [int] NOT NULL CONSTRAINT [DF__StockLeve__Capac__7FF5EA36]  DEFAULT ((0)),
	[StockHolding] [int] NOT NULL CONSTRAINT [DF__StockLeve__Stock__00EA0E6F]  DEFAULT ((0)),
	[LastSARSrun] [datetime] NOT NULL,
	[Active] [bit] NOT NULL CONSTRAINT [DF_StockLevel_Active]  DEFAULT ((0)),
	[Overstock] [int] NULL,
	[SARSdirty] [int] NULL CONSTRAINT [DF_StockLevel_SARSdirty_1__17]  DEFAULT ((0)),
 CONSTRAINT [PK_StockLevel] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC,
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
ALTER AUTHORIZATION ON [dbo].[StockLevel] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockRMADetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockRMADetail](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_StockRMADetail_BranchKey]  DEFAULT ('  '),
	[OrderDetailID] [int] NOT NULL CONSTRAINT [DF_StockRMADetail_OrderID]  DEFAULT ((0)),
	[Reason] [varchar](60) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_StockRMADetail_Reason]  DEFAULT (' '),
	[ReasonCode] [varchar](1) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_StockRMADetail_ReasonCode]  DEFAULT (' '),
	[RMAReasonID] [int] NULL,
 CONSTRAINT [PK_OrderDetailID_Branchkey_StockRMADetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockRMADetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockTransfer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockTransfer](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[SuperTag] [int] NOT NULL,
	[StockTransferTypeID] [int] NOT NULL,
	[SourceBranchID] [int] NOT NULL,
	[DestinationBranchID] [int] NOT NULL,
	[StockTransferMethodID] [int] NOT NULL,
	[CrateNumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PONumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[TrackingNumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_StockTransfer_test_schema]  DEFAULT (''),
 CONSTRAINT [PK_Branchkey_OrderID_StockTransfer] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockTransfer] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockTransferMethod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockTransferMethod](
	[StockTransferMethodID] [int] NOT NULL,
	[Description] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [bit] NOT NULL CONSTRAINT [DF_StockTransferMethod_InUse]  DEFAULT ((1)),
 CONSTRAINT [PK_StockTransferMethod_1__17] PRIMARY KEY CLUSTERED 
(
	[StockTransferMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockTransferMethod] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockTransferStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockTransferStatus](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[StockOutBranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[StockOutOrderID] [int] NOT NULL,
	[ManualEntry] [tinyint] NOT NULL,
	[WrongCompany] [tinyint] NULL,
	[WrongBranch] [tinyint] NULL,
 CONSTRAINT [PK_StockTransferStatus] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockTransferStatus] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockTransferType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockTransferType](
	[StockTransferTypeID] [int] NOT NULL,
	[Description] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[IsOut] [bit] NOT NULL CONSTRAINT [DF_StockTransferType_IsOut]  DEFAULT ((0)),
	[IsIn] [bit] NOT NULL CONSTRAINT [DF_StockTransferType_IsIn]  DEFAULT ((0)),
	[ReportAsOut] [bit] NOT NULL CONSTRAINT [DF__stocktran__Repor__0A14514D]  DEFAULT ((0)),
 CONSTRAINT [PK_StockTransferType_1__17] PRIMARY KEY CLUSTERED 
(
	[StockTransferTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockTransferType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockUpdate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockUpdate](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[StockUpdateID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[StaffID] [int] NOT NULL,
	[SuperTag] [int] NOT NULL,
	[StockUpdateTypeID] [int] NOT NULL,
	[Notes] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_StockUpdate_Notes]  DEFAULT (' '),
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_StockUpdateID_StockUpdate] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[StockUpdateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockUpdate] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockUpdateDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockUpdateDetails](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[StockUpdateID] [int] NOT NULL,
	[StockUpdateDetailID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[IntemSN] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[FromQty] [int] NOT NULL,
	[ToQty] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
 CONSTRAINT [PK_StockUpdateDetails] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[StockUpdateDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockUpdateDetails] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockUpdateType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockUpdateType](
	[StockUpdateTypeID] [int] NOT NULL,
	[Description] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[IsShrinkage] [bit] NOT NULL,
	[InUse] [bit] NOT NULL CONSTRAINT [DF_StockUpdateType_InUse]  DEFAULT ((1)),
	[AutoRun] [bit] NOT NULL CONSTRAINT [DF_StockUpdateType_AutoRun]  DEFAULT ((0)),
 CONSTRAINT [PK_StokUpdateType_1__17] PRIMARY KEY CLUSTERED 
(
	[StockUpdateTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockUpdateType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockVariance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StockVariance](
	[ID] [int] NOT NULL,
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Box_ID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Location_ID] [int] NOT NULL,
	[FromQty] [int] NULL,
	[ToQty] [int] NOT NULL,
	[PriceChange] [money] NULL,
	[Staff_ID] [int] NULL,
	[Entry_Date] [datetime] NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StockVariance] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StreetTypeCodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StreetTypeCodes](
	[StreetTypeName] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[StreetTypeCode] [varchar](4) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[StreetTypeCodes] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxContainer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxContainer](
	[ContainerTypeID] [int] NOT NULL,
	[ContainerType] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK___7__18] PRIMARY KEY CLUSTERED 
(
	[ContainerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxContainer] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxDiffInOut]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxDiffInOut](
	[BranchkeyOut] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderIDOut] [int] NOT NULL,
	[BranchkeyIn] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderIDIn] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Quantity_Requested] [int] NOT NULL,
	[Quantity_Received] [int] NOT NULL,
	[Transfer_Diff_Reason] [int] NOT NULL,
	[Notes] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_STxDiffInOut] PRIMARY KEY CLUSTERED 
(
	[BranchkeyOut] ASC,
	[OrderIDOut] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxDiffInOut] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxDiffReq]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxDiffReq](
	[STxRDID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Quantity_Requested] [int] NOT NULL,
	[Quantity_Received] [int] NOT NULL,
	[Transfer_Diff_Reason] [int] NOT NULL,
	[Notes] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_STxDiffReq_1__15] PRIMARY KEY CLUSTERED 
(
	[STxRDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxDiffReq] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxOrder](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[STxTID] [int] NOT NULL,
	[STxSID] [int] NOT NULL,
	[SourceLocID] [int] NOT NULL,
	[DestLocID] [int] NOT NULL,
 CONSTRAINT [PK_STxOrder] PRIMARY KEY CLUSTERED 
(
	[Branchkey] ASC,
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxOrder] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxRequest](
	[STxRID] [int] NOT NULL,
	[RequestType] [int] NOT NULL,
	[SourceLocationID] [int] NOT NULL,
	[DestinationLocationID] [int] NOT NULL,
	[UseHubID] [int] NOT NULL,
	[DateGenerated] [datetime] NOT NULL,
	[GeneratedBy] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[GeneratedOnPC] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[DateToDispatch] [datetime] NOT NULL,
	[sTxStatus] [int] NOT NULL,
	[Processed] [bit] NOT NULL,
 CONSTRAINT [PK___1__15] PRIMARY KEY CLUSTERED 
(
	[STxRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO


ALTER AUTHORIZATION ON [dbo].[STxRequest] TO  SCHEMA OWNER 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxRequestDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxRequestDetail](
	[STxRDID] [int] NOT NULL,
	[STxRID] [int] NOT NULL,
	[SourceLocationID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[QuantityRequested] [int] NOT NULL,
 CONSTRAINT [PK___2__15] PRIMARY KEY CLUSTERED 
(
	[STxRDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxRequestDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxRequestStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxRequestStatus](
	[STxRSID] [int] NOT NULL,
	[RequestStatus] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_STxRequestStatus_2__20] PRIMARY KEY CLUSTERED 
(
	[STxRSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxRequestStatus] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxRequestType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxRequestType](
	[ID] [int] NOT NULL,
	[TransferType] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK___3__15] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxRequestType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxStockIN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxStockIN](
	[STxStockInID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[STxTransferID] [int] NOT NULL,
	[STxTransferSourceLocationID] [int] NOT NULL,
	[DateStockedIn] [datetime] NOT NULL,
	[StockedInBy] [int] NOT NULL,
	[StockedInPC] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[Processed] [bit] NOT NULL,
 CONSTRAINT [PK_STxStockIN_1__17] PRIMARY KEY CLUSTERED 
(
	[STxStockInID] ASC,
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxStockIN] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxStockINDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxStockINDetail](
	[STxStockINDetailID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[QuantityExpected] [int] NOT NULL,
	[QuantityReceived] [int] NOT NULL,
 CONSTRAINT [PK_STxStockINDetail_1__17] PRIMARY KEY CLUSTERED 
(
	[STxStockINDetailID] ASC,
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxStockINDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxTransit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxTransit](
	[STxTID] [int] NOT NULL,
	[STxRID] [int] NOT NULL,
	[Processed] [int] NOT NULL,
	[UseHubID] [int] NOT NULL,
	[ReceivedHub] [bit] NOT NULL,
	[ReceivedStore] [bit] NOT NULL,
	[STxTransitStatusID] [int] NOT NULL,
	[SourceLocationID] [int] NOT NULL,
	[DestinationLocationID] [int] NOT NULL,
	[ContainerType] [int] NOT NULL,
	[ContainerNumber] [int] NOT NULL,
	[SealNumber] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[DateDispatched] [datetime] NOT NULL,
	[DispatchedBy] [int] NOT NULL,
	[DispatchedOnPC] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_STxTransit_1__17] PRIMARY KEY CLUSTERED 
(
	[STxTID] ASC,
	[SourceLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxTransit] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxTransitDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxTransitDetail](
	[STxTDID] [int] NOT NULL,
	[STxTID] [int] NOT NULL,
	[SourceLocationID] [int] NOT NULL,
	[DestinationLocationID] [int] NOT NULL,
	[BoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[ItemSN] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[QuantityRequested] [int] NOT NULL,
	[QuantitySent] [int] NOT NULL,
	[DiffReasonID] [int] NOT NULL,
 CONSTRAINT [PK_STxTransitDetail_1__17] PRIMARY KEY CLUSTERED 
(
	[STxTDID] ASC,
	[SourceLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxTransitDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STxTransitStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STxTransitStatus](
	[STxTSID] [int] NOT NULL,
	[TransitStatus] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[Active] [int] NOT NULL,
 CONSTRAINT [PK___6__18] PRIMARY KEY CLUSTERED 
(
	[STxTSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[STxTransitStatus] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SummaryDailySales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SummaryDailySales](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[Box_id] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[box_name] [varchar](74) COLLATE Latin1_General_CI_AS NULL,
	[Origin] [char](12) COLLATE Latin1_General_CI_AS NULL,
	[box_category] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[TotalSales] [int] NULL,
	[Unit] [int] NULL,
	[UnitPrice] [money] NULL,
	[ConvertDate] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[sortdate] [char](8) COLLATE Latin1_General_CI_AS NULL,
	[age] [int] NULL,
	[Refreshdate] [datetime] NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SummaryDailySales] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SummaryWeeklySales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SummaryWeeklySales](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[Box_id] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[Box_name] [varchar](74) COLLATE Latin1_General_CI_AS NULL,
	[Origin] [char](20) COLLATE Latin1_General_CI_AS NULL,
	[Box_category] [char](25) COLLATE Latin1_General_CI_AS NULL,
	[TotalSales] [money] NULL,
	[Unit] [int] NULL,
	[UnitPrice] [money] NULL,
	[WeekNo] [int] NULL,
	[Age] [int] NULL,
	[Refreshdate] [datetime] NULL
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SummaryWeeklySales] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SuperCat]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SuperCat](
	[SCID] [int] NOT NULL,
	[Name] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[FriendlyName] [varchar](254) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[Active] [bit] NULL DEFAULT ((1)),
	[ShowOnWWW] [bit] NULL DEFAULT ((0)),
	[DisplayOrder] [int] NULL,
	[LastModified] [datetime] NULL DEFAULT (getdate()),
 CONSTRAINT [PK_SuperCat_1_17] PRIMARY KEY CLUSTERED 
(
	[SCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SuperCat] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SupplierInfo](
	[SupplierID] [int] IDENTITY(1,1) NOT NULL,
	[companyname] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[Address_1] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[Address_2] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[Address_3] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PostCode] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[County] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Country] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[CurrencyID] [char](3) COLLATE Latin1_General_CI_AS NULL,
	[Main_Phone] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Main_Fax] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Direct_Phone] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Other_Phone] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Main_Contact] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Accounts_Contact] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Other_Contacts] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Notes] [varchar](124) COLLATE Latin1_General_CI_AS NULL,
	[DutyRate] [numeric](18, 4) NULL,
	[DefaultCarriage] [money] NULL,
	[PaymentTerms] [char](4) COLLATE Latin1_General_CI_AS NULL,
	[TermsDuration] [int] NULL,
	[AccountNo] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[CreditLImit] [money] NULL,
	[AccountBalance] [money] NULL,
 CONSTRAINT [PK_SupplierInfo] PRIMARY KEY NONCLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_SupplierInfo] UNIQUE NONCLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SupplierInfo] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupportedLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SupportedLanguage](
	[LanguageId] [int] NOT NULL,
	[LanguageName] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [bit] NOT NULL,
 CONSTRAINT [PK_SupportedLanguage] PRIMARY KEY CLUSTERED 
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[SupportedLanguage] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[titles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[titles](
	[title_id] [int] NOT NULL,
	[title] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_titles_1__10] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[titles] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionTypes](
	[ID] [int] NOT NULL,
	[Description] [char](10) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_TransactionTypes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_TransactionTypes] UNIQUE NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[TransactionTypes] TO  SCHEMA OWNER 
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransitDelta]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransitDelta](
	[TDID] [int] NOT NULL,
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[Box_id] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[Delta] [int] NOT NULL,
	[Applied] [int] NULL,
 CONSTRAINT [PK_TransitDelta] PRIMARY KEY CLUSTERED 
(
	[TDID] ASC,
	[Branchkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[TransitDelta] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[unboxed_counter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[unboxed_counter](
	[unboxed_id] [int] NOT NULL,
	[unboxed_used] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[BranchID] [int] NOT NULL,
 CONSTRAINT [PK_unboxed_counter] PRIMARY KEY NONCLUSTERED 
(
	[unboxed_id] ASC,
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[unboxed_counter] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[staff_id] [int] NOT NULL,
	[Title] [varchar](16) COLLATE Latin1_General_CI_AS NOT NULL,
	[Firstname] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Sex] [char](1) COLLATE Latin1_General_CI_AS NOT NULL,
	[Email] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Password] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL,
	[JobTitle] [varchar](300) COLLATE Latin1_General_CI_AS NULL,
	[JobType] [int] NULL,
	[WorkPhone] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[WorkExtension] [varchar](10) NULL,
	[MobilePhone] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[VoipPhone] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SpeedDial] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ReportsTo] [int] NOT NULL,
	[active] [bit] NOT NULL CONSTRAINT [DF_CMS_Staff_active]  DEFAULT ((1)),
	[isActing] [bit] NOT NULL CONSTRAINT [DF_Users_isActing]  DEFAULT ((0)),
	[payType] [int] NULL,
	[MustChangePasword] [bit] NOT NULL CONSTRAINT [DF_Users_MustChangePasword]  DEFAULT ((0)),
	[LastLogin] [datetime] NULL,
	[Username] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[DateOfBirth] [datetime] NULL,
 CONSTRAINT [PK_CMS_Staff] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Users] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Voucher]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Voucher](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[VType] [int] NOT NULL,
	[Value] [money] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[Redeemed] [bit] NOT NULL CONSTRAINT [DF_Voucher_Redeeed_2__23]  DEFAULT ((0)),
	[Cancelled] [bit] NOT NULL CONSTRAINT [DF_Voucher_Cancelled_1__23]  DEFAULT ((0)),
	[RBranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NULL,
	[ROrderID] [int] NULL,
 CONSTRAINT [PK_Voucher] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Voucher] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherFailure]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherFailure](
	[VFType] [int] NOT NULL,
	[Reason] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_VoucherFailure_1__23] PRIMARY KEY CLUSTERED 
(
	[VFType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherFailure] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherLocalLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherLocalLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[VoucherID] [int] NOT NULL,
	[RedeemOrderID] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[EntryType] [int] NOT NULL,
	[Note] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
 CONSTRAINT [PK_VoucherLocalLog_1__16] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherLocalLog] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherLocalLogType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherLocalLogType](
	[EntryType] [int] NOT NULL,
	[TypeText] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK___2__16] PRIMARY KEY CLUSTERED 
(
	[EntryType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherLocalLogType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherNote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherNote](
	[NoteID] [int] IDENTITY(1,1) NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[VNType] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Text] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_VoucherNote] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherNote] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherNoteType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherNoteType](
	[VNType] [int] NOT NULL,
	[NoteType] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_VoucherNoteType_4__23] PRIMARY KEY CLUSTERED 
(
	[VNType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherNoteType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherOverride]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherOverride](
	[VoID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OrderID] [int] NOT NULL,
	[VoucherBranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[VoucherOrderID] [int] NOT NULL,
	[VoucherAmount] [money] NOT NULL,
	[VFType] [int] NOT NULL,
	[Error] [int] NULL,
	[Text] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_VoucherOverride] PRIMARY KEY CLUSTERED 
(
	[VoID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherOverride] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoucherType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoucherType](
	[VType] [int] NOT NULL,
	[VoucherType] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_VoucherType_3__23] PRIMARY KEY CLUSTERED 
(
	[VType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[VoucherType] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrder](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[WorkOrderID] [int] NOT NULL,
	[WorkOrderStatusID] [int] NOT NULL,
	[BuyInOrderID] [int] NULL,
	[NoteToTester] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[TesterStaffID] [int] NOT NULL DEFAULT ((0)),
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_WorkOrders] PRIMARY KEY CLUSTERED 
(
	[WorkOrderID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrder] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrderDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrderDetail](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[WorkOrderDetailID] [int] NOT NULL,
	[WorkOrderID] [int] NOT NULL,
	[TestBoxID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[ActualBoxID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[ItemSN] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Tested] [bit] NOT NULL,
	[TestOK] [bit] NOT NULL,
	[NoteToTester] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[TestersNote] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ReturnReasonID] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_WorkOrderDetail] PRIMARY KEY CLUSTERED 
(
	[WorkOrderDetailID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrderDetail] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrderDetailTestResult]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrderDetailTestResult](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[WorkOrderDetailID] [int] NOT NULL,
	[ChklistID] [int] NOT NULL,
	[ChkitemID] [int] NOT NULL,
	[Completed] [bit] NOT NULL,
	[Pass] [bit] NOT NULL,
	[TestersNote] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_WorkOrderDetailTestResult] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[WorkOrderDetailID] ASC,
	[ChklistID] ASC,
	[ChkitemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrderDetailTestResult] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrderReturnReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrderReturnReason](
	[ReturnReasonID] [int] NOT NULL,
	[Reason] [varchar](60) COLLATE Latin1_General_CI_AS NOT NULL,
	[InUse] [int] NOT NULL DEFAULT ((1))
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrderReturnReason] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkORders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkORders](
	[WorkOrderID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[AuthorisedBy] [int] NULL,
	[Explanation] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Completed] [bit] NOT NULL,
	[TestOK] [bit] NOT NULL,
 CONSTRAINT [PK__WorkORders] PRIMARY KEY CLUSTERED 
(
	[WorkOrderID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkORders] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrderStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrderStatus](
	[WorkOrderStatusID] [int] NOT NULL,
	[WorkOrderStatus] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_WorkOrderStatus] PRIMARY KEY CLUSTERED 
(
	[WorkOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrderStatus] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkOrderStatusHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkOrderStatusHistory](
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[WorkOrderStatusHistoryID] [int] NOT NULL,
	[WorkOrderID] [int] NOT NULL,
	[WorkOrderStatusID] [int] NOT NULL,
	[StatusDate] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkOrderStatusHistory] PRIMARY KEY CLUSTERED 
(
	[WorkOrderStatusHistoryID] ASC,
	[BranchKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkOrderStatusHistory] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WorkstationBranches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WorkstationBranches](
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[BranchID] [int] NOT NULL,
	[DefaultBranch] [bit] NOT NULL CONSTRAINT [DF_WorkstationBranches_Default]  DEFAULT ((1)),
 CONSTRAINT [PK_WorkstationBranches] PRIMARY KEY NONCLUSTERED 
(
	[WorkstationID] ASC,
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[WorkstationBranches] TO  SCHEMA OWNER 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workstations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Workstations](
	[WorkstationID] [varchar](25) COLLATE Latin1_General_CI_AS NOT NULL,
	[ReceiptPrinter] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LabelPrinter] [char](50) COLLATE Latin1_General_CI_AS NULL,
	[LabelPath] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_Workstations] PRIMARY KEY NONCLUSTERED 
(
	[WorkstationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO

GO
ALTER AUTHORIZATION ON [dbo].[Workstations] TO  SCHEMA OWNER 
GO

GO

/*******************END OF SCRIPT TO CREATE TABLES ON Epos2000********************/

/********************SCRIPT TO CREATE DEFAULT AND FOREIGN KEY CONSTRATINTS****************/

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Attribute_BooleanValue2__47]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Attribute] ADD  CONSTRAINT [DF_Attribute_BooleanValue2__47]  DEFAULT ((0)) FOR [BooleanValue]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_AttribStruct_SWWW]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AttributeStructure] ADD  CONSTRAINT [DF_AttribStruct_SWWW]  DEFAULT ((1)) FOR [ShowOnWWW]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_AttributeS_Compulsory_1__75]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AttributeStructure] ADD  CONSTRAINT [DF_AttributeS_Compulsory_1__75]  DEFAULT ((0)) FOR [Compulsory]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Lock__BranchKey__29ACF837]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Lock] ADD  DEFAULT ('') FOR [BranchKey]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Manufacturers_Manufacturer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Manufacturers] ADD  CONSTRAINT [DF_Manufacturers_Manufacturer]  DEFAULT (' ') FOR [Manufacturer]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_order_notes_Branchkey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[order_notes] ADD  CONSTRAINT [DF_order_notes_Branchkey]  DEFAULT ('  ') FOR [BranchKey]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__OrderPaym__TaxRa__618671AF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OrderPaymentTaxRate] ADD  CONSTRAINT [DF__OrderPaym__TaxRa__618671AF]  DEFAULT ((0)) FOR [TaxRate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Branchkey_PendingPriceChanges]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PendingPriceChanges] ADD  CONSTRAINT [DF_Branchkey_PendingPriceChanges]  DEFAULT ('  ') FOR [BranchKey]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PendingPric_RepriceComp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PendingPriceChanges] ADD  CONSTRAINT [DF_PendingPric_RepriceComp]  DEFAULT ((0)) FOR [RepriceComplete]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PurchaseOrders_BranchKey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PurchaseOrders] ADD  CONSTRAINT [DF_PurchaseOrders_BranchKey]  DEFAULT ('  ') FOR [BranchKey]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PurchaseOrders_Completed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PurchaseOrders] ADD  CONSTRAINT [DF_PurchaseOrders_Completed]  DEFAULT ((0)) FOR [SignedOff]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PurchaseOrders_Payed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PurchaseOrders] ADD  CONSTRAINT [DF_PurchaseOrders_Payed]  DEFAULT ((0)) FOR [Payed]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxContain_ContainerT10__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxContainer] ADD  CONSTRAINT [DF_STxContain_ContainerT10__18]  DEFAULT ((0)) FOR [ContainerTypeID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxContain_ContainerTy9__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxContainer] ADD  CONSTRAINT [DF_STxContain_ContainerTy9__18]  DEFAULT (' ') FOR [ContainerType]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxContain_Active_8__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxContainer] ADD  CONSTRAINT [DF_STxContain_Active_8__18]  DEFAULT ((0)) FOR [Active]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_Branchkey]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_Branchkey]  DEFAULT ('  ') FOR [Branchkey]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_OrderID_6__25]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_OrderID_6__25]  DEFAULT ((0)) FOR [OrderID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_STxTID_8__25]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_STxTID_8__25]  DEFAULT ((0)) FOR [STxTID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_STxSID_7__25]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_STxSID_7__25]  DEFAULT ((0)) FOR [STxSID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_SourceLocID_2__25]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_SourceLocID_2__25]  DEFAULT ((0)) FOR [SourceLocID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxOrder_DestLocID_1__25]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxOrder] ADD  CONSTRAINT [DF_STxOrder_DestLocID_1__25]  DEFAULT ((0)) FOR [DestLocID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_STxTID_13__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_STxTID_13__18]  DEFAULT ((0)) FOR [STxTID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Processed_11__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_Processed_11__18]  DEFAULT ((0)) FOR [Processed]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Recevd_5__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_Recevd_5__18]  DEFAULT ((0)) FOR [ReceivedHub]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Recevd_4__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_Recevd_4__18]  DEFAULT ((0)) FOR [ReceivedStore]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTrast_STxTrSta_13__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTrast_STxTrSta_13__18]  DEFAULT ((0)) FOR [STxTransitStatusID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_SourceLoca12__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_SourceLoca12__18]  DEFAULT ((0)) FOR [SourceLocationID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Destinatio10__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_Destinatio10__18]  DEFAULT ((0)) FOR [DestinationLocationID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_ContainerTy8__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_ContainerTy8__18]  DEFAULT ((0)) FOR [ContainerType]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_ContainerNu7__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_ContainerNu7__18]  DEFAULT ((0)) FOR [ContainerNumber]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_SealNumber_1__17]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransit] ADD  CONSTRAINT [DF_STxTransit_SealNumber_1__17]  DEFAULT (' ') FOR [SealNumber]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_STxTDID_7__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_STxTDID_7__18]  DEFAULT ((0)) FOR [STxTDID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_STxTID_9__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_STxTID_9__18]  DEFAULT ((0)) FOR [STxTID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_SourceLocat6__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_SourceLocat6__18]  DEFAULT ((0)) FOR [SourceLocationID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_DestinLocat6__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_DestinLocat6__18]  DEFAULT ((0)) FOR [DestinationLocationID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_BoxID_1__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_BoxID_1__18]  DEFAULT (' ') FOR [BoxID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_ItemSN_2__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_ItemSN_2__18]  DEFAULT (' ') FOR [ItemSN]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Quantity_3__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitDetail] ADD  CONSTRAINT [DF_STxTransit_Quantity_3__18]  DEFAULT ((0)) FOR [QuantityRequested]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_STxTSID_8__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitStatus] ADD  CONSTRAINT [DF_STxTransit_STxTSID_8__18]  DEFAULT ((0)) FOR [STxTSID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_TransitStat9__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitStatus] ADD  CONSTRAINT [DF_STxTransit_TransitStat9__18]  DEFAULT (' ') FOR [TransitStatus]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_STxTransit_Active_7__18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[STxTransitStatus] ADD  CONSTRAINT [DF_STxTransit_Active_7__18]  DEFAULT ((0)) FOR [Active]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_LabelPrnType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter]  WITH CHECK ADD  CONSTRAINT [FK_BranchPrn_LabelPrnType] FOREIGN KEY([LabelPrinterTypeID])
REFERENCES [dbo].[LabelPrinterType] ([LabelPrinterTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_LabelPrnType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter] CHECK CONSTRAINT [FK_BranchPrn_LabelPrnType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_PrinterType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter]  WITH CHECK ADD  CONSTRAINT [FK_BranchPrn_PrinterType] FOREIGN KEY([PrinterTypeID])
REFERENCES [dbo].[PrinterType] ([PrinterTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_PrinterType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter] CHECK CONSTRAINT [FK_BranchPrn_PrinterType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_ReceiptPrnType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter]  WITH CHECK ADD  CONSTRAINT [FK_BranchPrn_ReceiptPrnType] FOREIGN KEY([ReceiptPrinterTypeID])
REFERENCES [dbo].[ReceiptPrinterType] ([ReceiptPrinterTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BranchPrn_ReceiptPrnType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BranchPrinter]'))
ALTER TABLE [dbo].[BranchPrinter] CHECK CONSTRAINT [FK_BranchPrn_ReceiptPrnType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Category_Elasticity]') AND parent_object_id = OBJECT_ID(N'[dbo].[category]'))
ALTER TABLE [dbo].[category]  WITH NOCHECK ADD  CONSTRAINT [FK_Category_Elasticity] FOREIGN KEY([ElasticityID])
REFERENCES [dbo].[Elasticity] ([ElasticityID])
NOT FOR REPLICATION 
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Category_Elasticity]') AND parent_object_id = OBJECT_ID(N'[dbo].[category]'))
ALTER TABLE [dbo].[category] CHECK CONSTRAINT [FK_Category_Elasticity]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Category_OpCompany]') AND parent_object_id = OBJECT_ID(N'[dbo].[category]'))
ALTER TABLE [dbo].[category]  WITH NOCHECK ADD  CONSTRAINT [FK_Category_OpCompany] FOREIGN KEY([OCID])
REFERENCES [dbo].[OperatingCompany] ([OCID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Category_OpCompany]') AND parent_object_id = OBJECT_ID(N'[dbo].[category]'))
ALTER TABLE [dbo].[category] CHECK CONSTRAINT [FK_Category_OpCompany]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Category_SuperCat]') AND parent_object_id = OBJECT_ID(N'[dbo].[category]'))
ALTER TABLE [dbo].[category] CHECK CONSTRAINT [FK_Category_SuperCat]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClauseLines_Clauses]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClauseLines]'))
ALTER TABLE [dbo].[ClauseLines]  WITH NOCHECK ADD  CONSTRAINT [FK_ClauseLines_Clauses] FOREIGN KEY([ClauseID])
REFERENCES [dbo].[Clauses] ([ClauseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClauseLines_Clauses]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClauseLines]'))
ALTER TABLE [dbo].[ClauseLines] CHECK CONSTRAINT [FK_ClauseLines_Clauses]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DBQueueDetail_DBQueue]') AND parent_object_id = OBJECT_ID(N'[dbo].[DBQueueDetail]'))
ALTER TABLE [dbo].[DBQueueDetail]  WITH CHECK ADD  CONSTRAINT [FK_DBQueueDetail_DBQueue] FOREIGN KEY([BranchKey], [QueueId])
REFERENCES [dbo].[DBQueue] ([BranchKey], [QueueId]) ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DBQueueDetail_DBQueue]') AND parent_object_id = OBJECT_ID(N'[dbo].[DBQueueDetail]'))
ALTER TABLE [dbo].[DBQueueDetail] CHECK CONSTRAINT [FK_DBQueueDetail_DBQueue]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LocationBra_LocationTyp]') AND parent_object_id = OBJECT_ID(N'[dbo].[LocationBranches]'))
ALTER TABLE [dbo].[LocationBranches]  WITH NOCHECK ADD  CONSTRAINT [FK_LocationBra_LocationTyp] FOREIGN KEY([LocationType])
REFERENCES [dbo].[LocationTypes] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LocationBra_LocationTyp]') AND parent_object_id = OBJECT_ID(N'[dbo].[LocationBranches]'))
ALTER TABLE [dbo].[LocationBranches] CHECK CONSTRAINT [FK_LocationBra_LocationTyp]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_PlatformId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PlatformTextKeyMapping]'))
ALTER TABLE [dbo].[PlatformTextKeyMapping]  WITH CHECK ADD  CONSTRAINT [fk_PlatformId] FOREIGN KEY([PlatformId])
REFERENCES [dbo].[Platform] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_PlatformId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PlatformTextKeyMapping]'))
ALTER TABLE [dbo].[PlatformTextKeyMapping] CHECK CONSTRAINT [fk_PlatformId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_LanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceTranslation]'))
ALTER TABLE [dbo].[ResourceTranslation]  WITH CHECK ADD  CONSTRAINT [fk_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[SupportedLanguage] ([LanguageId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_LanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ResourceTranslation]'))
ALTER TABLE [dbo].[ResourceTranslation] CHECK CONSTRAINT [fk_LanguageId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockInRMADetail_Reasons1]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockInRMADetail]'))
ALTER TABLE [dbo].[StockInRMADetail]  WITH CHECK ADD  CONSTRAINT [FK_StockInRMADetail_Reasons1] FOREIGN KEY([ReasonId])
REFERENCES [dbo].[Reasons] ([ReasonId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockInRMADetail_Reasons1]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockInRMADetail]'))
ALTER TABLE [dbo].[StockInRMADetail] CHECK CONSTRAINT [FK_StockInRMADetail_Reasons1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReasonID]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockRMADetail]'))
ALTER TABLE [dbo].[StockRMADetail]  WITH NOCHECK ADD  CONSTRAINT [fk_ReasonID] FOREIGN KEY([RMAReasonID])
REFERENCES [dbo].[RMAReason] ([RMAReasonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ReasonID]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockRMADetail]'))
ALTER TABLE [dbo].[StockRMADetail] CHECK CONSTRAINT [fk_ReasonID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockTransfer_Method]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockTransfer]'))
ALTER TABLE [dbo].[StockTransfer]  WITH CHECK ADD  CONSTRAINT [FK_StockTransfer_Method] FOREIGN KEY([StockTransferMethodID])
REFERENCES [dbo].[StockTransferMethod] ([StockTransferMethodID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockTransfer_Method]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockTransfer]'))
ALTER TABLE [dbo].[StockTransfer] CHECK CONSTRAINT [FK_StockTransfer_Method]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockUpdate_StockUpdateDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockUpdateDetails]'))
ALTER TABLE [dbo].[StockUpdateDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockUpdate_StockUpdateDetails] FOREIGN KEY([BranchKey], [StockUpdateID])
REFERENCES [dbo].[StockUpdate] ([BranchKey], [StockUpdateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_StockUpdate_StockUpdateDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[StockUpdateDetails]'))
ALTER TABLE [dbo].[StockUpdateDetails] CHECK CONSTRAINT [FK_StockUpdate_StockUpdateDetails]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VoucherNote_BK_OI]') AND parent_object_id = OBJECT_ID(N'[dbo].[VoucherNote]'))
ALTER TABLE [dbo].[VoucherNote]  WITH CHECK ADD  CONSTRAINT [FK_VoucherNote_BK_OI] FOREIGN KEY([BranchKey], [OrderID])
REFERENCES [dbo].[Voucher] ([BranchKey], [OrderID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VoucherNote_BK_OI]') AND parent_object_id = OBJECT_ID(N'[dbo].[VoucherNote]'))
ALTER TABLE [dbo].[VoucherNote] CHECK CONSTRAINT [FK_VoucherNote_BK_OI]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderDetail_WorkOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetail]'))
ALTER TABLE [dbo].[WorkOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_WorkOrderDetail_WorkOrder] FOREIGN KEY([WorkOrderID], [BranchKey])
REFERENCES [dbo].[WorkOrder] ([WorkOrderID], [BranchKey])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderDetail_WorkOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetail]'))
ALTER TABLE [dbo].[WorkOrderDetail] CHECK CONSTRAINT [FK_WorkOrderDetail_WorkOrder]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChecklistDetail_WorkOrderDetailTestResult]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetailTestResult]'))
ALTER TABLE [dbo].[WorkOrderDetailTestResult]  WITH NOCHECK ADD  CONSTRAINT [FK_ChecklistDetail_WorkOrderDetailTestResult] FOREIGN KEY([ChkitemID], [ChklistID])
REFERENCES [dbo].[CheckListDetails] ([chkitemID], [chklistID])
ON UPDATE CASCADE
ON DELETE CASCADE
NOT FOR REPLICATION 
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChecklistDetail_WorkOrderDetailTestResult]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetailTestResult]'))
ALTER TABLE [dbo].[WorkOrderDetailTestResult] CHECK CONSTRAINT [FK_ChecklistDetail_WorkOrderDetailTestResult]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderDetailTestResult_WorkOrderDetail]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetailTestResult]'))
ALTER TABLE [dbo].[WorkOrderDetailTestResult]  WITH CHECK ADD  CONSTRAINT [FK_WorkOrderDetailTestResult_WorkOrderDetail] FOREIGN KEY([WorkOrderDetailID], [BranchKey])
REFERENCES [dbo].[WorkOrderDetail] ([WorkOrderDetailID], [BranchKey])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderDetailTestResult_WorkOrderDetail]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderDetailTestResult]'))
ALTER TABLE [dbo].[WorkOrderDetailTestResult] CHECK CONSTRAINT [FK_WorkOrderDetailTestResult_WorkOrderDetail]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderStatusHistory_WorkOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderStatusHistory]'))
ALTER TABLE [dbo].[WorkOrderStatusHistory]  WITH CHECK ADD  CONSTRAINT [FK_WorkOrderStatusHistory_WorkOrder] FOREIGN KEY([WorkOrderID], [BranchKey])
REFERENCES [dbo].[WorkOrder] ([WorkOrderID], [BranchKey])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderStatusHistory_WorkOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderStatusHistory]'))
ALTER TABLE [dbo].[WorkOrderStatusHistory] CHECK CONSTRAINT [FK_WorkOrderStatusHistory_WorkOrder]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderStatusHistory_WorkOrderStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderStatusHistory]'))
ALTER TABLE [dbo].[WorkOrderStatusHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkOrderStatusHistory_WorkOrderStatus] FOREIGN KEY([WorkOrderStatusID])
REFERENCES [dbo].[WorkOrderStatus] ([WorkOrderStatusID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkOrderStatusHistory_WorkOrderStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[WorkOrderStatusHistory]'))
ALTER TABLE [dbo].[WorkOrderStatusHistory] CHECK CONSTRAINT [FK_WorkOrderStatusHistory_WorkOrderStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/********************END OF SCRIPT TO CREATE DEFAULT AND FOREIGN KEY CONSTRATINTS****************/

/********************SCRIPT TO CREATE TRIGGERS*************************/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Del_BoxPriceChangePrinted]'))
EXEC dbo.sp_executesql @statement = N'
--============================================================
-- After Delete trigger on BoxPriceChange table

CREATE TRIGGER [dbo].[Del_BoxPriceChangePrinted] ON [dbo].[BoxPriceChange]
FOR Delete AS
IF EXISTS(select BPCID from deleted )
BEGIN
	DELETE BoxPriceChangePrinted
	FROM BoxPriceChangePrinted INNER JOIN deleted 
	on (BoxPriceChangePrinted.BPCID=deleted.BPCID)
	WHERE (BoxPriceChangePrinted.BPCID =  deleted.BPCID) 
	END' 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Del_OrderPaymentTaxRate]'))
EXEC dbo.sp_executesql @statement = N'
/****** Object:  Trigger dbo.Del_OrderPaymentTaxRate    Script Date: 21/09/2012 08:36:31 ******/
CREATE TRIGGER [dbo].[Del_OrderPaymentTaxRate] ON [dbo].[OrderPaymentElements] 
FOR Delete AS 
IF EXISTS(select * from deleted where PaymentMethodID= 27)
BEGIN 
	DELETE OrderPaymentTaxRate 
	FROM OrderPaymentTaxRate INNER JOIN deleted 
	on (OrderPaymentTaxRate.OPEID=deleted.OPEID and OrderPaymentTaxRate.BranchKey = deleted.BranchKey) 
	WHERE (OrderPaymentTaxRate.OPEID = deleted.OPEID and OrderPaymentTaxRate.BranchKey = deleted.BranchKey) and 
	deleted.PaymentMethodID= 27
END ' 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Ins_OrderPaymentTaxRate]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[Ins_OrderPaymentTaxRate] ON [dbo].[OrderPaymentElements]
FOR insert AS
IF EXISTS(select PaymentMethodID from inserted WHERE PaymentMethodID = 27)
BEGIN

	Declare @opeid int, @BR varchar(6),@TaxRate decimal(6,4)
	select @opeid=OPEID,@BR=BranchKey from INSERTED
	select @TaxRate=convert(decimal(6,4),Value) from branchsetting where SubKey =''Sales Tax Percent'' and BranchKey =@BR
	insert into OrderPaymentTaxRate values(@opeid,@BR,@TaxRate) 

END' 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[Upd_OrderPaymentTaxRate]'))
EXEC dbo.sp_executesql @statement = N'
--UPDATE TRIGGER MODIFED TO CAPTURE THE SALES TAX FOR THE BRANCHKEY OF THE ORDER
CREATE TRIGGER [dbo].[Upd_OrderPaymentTaxRate] ON [dbo].[OrderPaymentElements] 
FOR Update AS 
IF EXISTS(select * from inserted where PaymentMethodID= 27)
BEGIN 
	UPDATE OrderPaymentTaxRate 
	set TaxRate=(select convert(decimal(6,4),Value) from branchsetting 
	where SubKey =''Sales Tax Percent'' and BranchKey = inserted.BranchKey)
	FROM inserted 
	WHERE (OrderPaymentTaxRate.OPEID = inserted.OPEID and OrderPaymentTaxRate.BranchKey = inserted.BranchKey) 
	and inserted.PaymentMethodID= 27
END ' 
GO


/*********************END OF TRIGGER CREATION SCRIPT*******************/

/********************SCRIPT TO CREATE INDEXES************************************/

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Attribute]') AND name = N'IX_Attrib_BoxID')
CREATE NONCLUSTERED INDEX [IX_Attrib_BoxID] ON [dbo].[Attribute]
(
	[BoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AUditTrail]') AND name = N'ix_auditentry')
CREATE NONCLUSTERED INDEX [ix_auditentry] ON [dbo].[AUditTrail]
(
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[boxes]') AND name = N'iX_box_category_BoxDel_boxname_boxID')
CREATE NONCLUSTERED INDEX [iX_box_category_BoxDel_boxname_boxID] ON [dbo].[boxes]
(
	[box_category] ASC,
	[discontinued] ASC,
	[Box_Deleted] ASC,
	[box_name] ASC,
	[box_id] ASC
)
INCLUDE ( 	[new],
	[origin],
	[Stockable],
	[In_SNReq],
	[Out_SNReq]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BoxPriceChange]') AND name = N'IX_BPC_CrDate')
CREATE NONCLUSTERED INDEX [IX_BPC_CrDate] ON [dbo].[BoxPriceChange]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Branches]') AND name = N'IX_Branches_OC')
CREATE NONCLUSTERED INDEX [IX_Branches_OC] ON [dbo].[Branches]
(
	[OperatingCompany] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Branches]') AND name = N'IX_FLX_A4_PRINTER_PORT')
CREATE UNIQUE NONCLUSTERED INDEX [IX_FLX_A4_PRINTER_PORT] ON [dbo].[Branches]
(
	[a4_printer_port] ASC
)
WHERE ([a4_Printer_Port] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckList]') AND name = N'IX_Checklist_BoxID')
CREATE NONCLUSTERED INDEX [IX_Checklist_BoxID] ON [dbo].[CheckList]
(
	[Box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND name = N'IX_Customer_Email')
CREATE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND name = N'IX_Custy_Postcode')
CREATE NONCLUSTERED INDEX [IX_Custy_Postcode] ON [dbo].[Customer]
(
	[Postcode] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND name = N'IX_Firstname_Lastname')
CREATE NONCLUSTERED INDEX [IX_Firstname_Lastname] ON [dbo].[Customer]
(
	[Firstname] ASC,
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND name = N'IX_Lastname_Firstname')
CREATE NONCLUSTERED INDEX [IX_Lastname_Firstname] ON [dbo].[Customer]
(
	[LastName] ASC,
	[Firstname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND name = N'IX_Phone_number')
CREATE NONCLUSTERED INDEX [IX_Phone_number] ON [dbo].[Customer]
(
	[PhoneMobile] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Holding_BranchPrices]') AND name = N'ix_HBP_BoxID')
CREATE NONCLUSTERED INDEX [ix_HBP_BoxID] ON [dbo].[Holding_BranchPrices]
(
	[BoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Holding_BranchPrices]') AND name = N'ix_HBP_CreateDate')
CREATE NONCLUSTERED INDEX [ix_HBP_CreateDate] ON [dbo].[Holding_BranchPrices]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[LocationBranches]') AND name = N'IX_LocationBranches_1')
CREATE NONCLUSTERED INDEX [IX_LocationBranches_1] ON [dbo].[LocationBranches]
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[LocationBranches]') AND name = N'IX_LocationBranches_2')
CREATE NONCLUSTERED INDEX [IX_LocationBranches_2] ON [dbo].[LocationBranches]
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[LocationBranches]') AND name = N'IX_LocationBranches_3')
CREATE NONCLUSTERED INDEX [IX_LocationBranches_3] ON [dbo].[LocationBranches]
(
	[LocationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND name = N'ix_boxid')
CREATE NONCLUSTERED INDEX [ix_boxid] ON [dbo].[order_details]
(
	[box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND name = N'IX_Orderdetails_ItemSN')
CREATE NONCLUSTERED INDEX [IX_Orderdetails_ItemSN] ON [dbo].[order_details]
(
	[ItemSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[order_details]') AND name = N'ix_orderid')
CREATE NONCLUSTERED INDEX [ix_orderid] ON [dbo].[order_details]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[order_notes]') AND name = N'IX_order_notes')
CREATE NONCLUSTERED INDEX [IX_order_notes] ON [dbo].[order_notes]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OrderPaymentElements]') AND name = N'IX_OPE_OID')
CREATE NONCLUSTERED INDEX [IX_OPE_OID] ON [dbo].[OrderPaymentElements]
(
	[orderid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND name = N'ix_branchid')
CREATE NONCLUSTERED INDEX [ix_branchid] ON [dbo].[orders]
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND name = N'ix_Orders_Date')
CREATE NONCLUSTERED INDEX [ix_Orders_Date] ON [dbo].[orders]
(
	[order_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[orders]') AND name = N'ix_Orders_staffid')
CREATE NONCLUSTERED INDEX [ix_Orders_staffid] ON [dbo].[orders]
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProductLine]') AND name = N'IX_ProdLine_SCID')
CREATE NONCLUSTERED INDEX [IX_ProdLine_SCID] ON [dbo].[ProductLine]
(
	[SuperCatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProductlineCat]') AND name = N'IX_ProdCat_CatID')
CREATE NONCLUSTERED INDEX [IX_ProdCat_CatID] ON [dbo].[ProductlineCat]
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProductlineCat]') AND name = N'IX_ProdCat_ProdID')
CREATE NONCLUSTERED INDEX [IX_ProdCat_ProdID] ON [dbo].[ProductlineCat]
(
	[ProductLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[StockTransferStatus]') AND name = N'IX_StockTransferStatus')
CREATE NONCLUSTERED INDEX [IX_StockTransferStatus] ON [dbo].[StockTransferStatus]
(
	[StockOutBranchKey] ASC,
	[StockOutOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SummaryDailySales]') AND name = N'ix_boxid')
CREATE NONCLUSTERED INDEX [ix_boxid] ON [dbo].[SummaryDailySales]
(
	[Box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SummaryDailySales]') AND name = N'ix_category')
CREATE NONCLUSTERED INDEX [ix_category] ON [dbo].[SummaryDailySales]
(
	[box_category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SummaryWeeklySales]') AND name = N'ix_boxid')
CREATE NONCLUSTERED INDEX [ix_boxid] ON [dbo].[SummaryWeeklySales]
(
	[Box_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SummaryWeeklySales]') AND name = N'ix_category')
CREATE NONCLUSTERED INDEX [ix_category] ON [dbo].[SummaryWeeklySales]
(
	[Box_category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WorkstationBranches]') AND name = N'IX_WorkstationBranches')
CREATE NONCLUSTERED INDEX [IX_WorkstationBranches] ON [dbo].[WorkstationBranches]
(
	[WorkstationID] ASC,
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

/********************END OF SCRIPT TO CREATE INDEXES***************************/


/********************SCRIPT TO CREATE VIEWS**************************************/

USE [Epos2000]
GO

/****** Object:  View [dbo].[BoxQuantities] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[BoxQuantities]
as
select  a.LocationID as LocationID,a.Boxid  as Boxid,
case when BoxStock.QuantityOnHand IS null then a.QuantityOnhand else BoxStock.QuantityOnHand END as QuantityOnhand,
case when BoxStock.ReorderLevel IS NULL then a.ReorderLevel else BoxStock.ReorderLevel End as ReorderLevel
from	(select StockLevel.LocationID  as LocationID, boxes.box_id as Boxid ,0  as QuantityOnhand,StockLevel.OptStock as ReorderLevel
		from StockLevel  inner join category on StockLevel.CategoryID=category.category_id 
		inner join dbo.boxes on category.box_category=boxes.box_category) a
	Left outer join dbo.BoxStock on 
		(a.Boxid =BoxStock.Boxid and a.LocationID=BoxStock.LocationID)


GO

/****** Object:  View [dbo].[VWStockAllLocations]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  View dbo.VWStockAllLocations  ******/
/*
SRH 1999-02-04.
Returns summary stock levels for an item by location.
Can return apparent duplicate rows if the branch has two different prices.
*/
CREATE VIEW [dbo].[VWStockAllLocations] as
SELECT Distinct BQ.Boxid, BQ.locationId, L.Location_name, LB.branchid, BQ.QuantityOnHand  
FROM 
(  (boxquantities as BQ 
FULL OUTER JOIN locations AS L ON (BQ.locationid = L.location_Id))
LEFT OUTER JOIN locationbranches as LB ON (LB.locationid = BQ.locationid))


GO

/****** Object:  View [dbo].[vwItemStockLevel]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwItemStockLevel] AS 
select locations.location_id,
		locations.location_name,boxquantities.quantityonhand, boxquantities.boxid 
from locations left outer join boxquantities on locations.location_id = boxquantities.locationid



GO

/****** Object:  View [dbo].[vwLocationStockSummary]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwLocationStockSummary] AS
select distinct locations.location_name, locations.location_id as locationid, boxes.new, boxes.origin, boxes.Stockable, box_id, box_category, quantityonhand, box_name
from locations, boxquantities, boxes where 
boxes.box_id = boxquantities.boxid
and locations.location_id = boxquantities.locationid

GO

/****** Object:  View [dbo].[vwReportStockLevel]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwReportStockLevel] AS
Select locationbranches.branchid, locationbranches.locationtype, locations.location_name, boxes.box_name, boxes.box_category, boxes.origin, boxquantities.locationid, 
boxquantities.boxid, boxquantities.quantityonhand, boxquantities.reorderlevel
from locationbranches, boxquantities , boxes, locations
where locationbranches.locationid = boxquantities.locationid
and boxes.box_id = boxquantities.boxid
and locations.location_id = locationbranches.locationid


GO

/****** Object:  View [dbo].[vwXLStockLevels]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLStockLevels] AS
select boxes.box_id, boxes.box_name, boxes.box_category, boxes.origin, boxquantities.quantityonhand, boxquantities.reorderlevel, locations.location_name
from boxes, boxquantities, locations
where boxes.box_id = boxquantities.boxid
and boxquantities.locationid = locations.location_id


GO

/****** Object:  View [dbo].[vwAllowedModifiers]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAllowedModifiers] AS 
select category.box_Category, categorymodifiers.* 
from category, categorymodifiers where category.category_id = categorymodifiers.categoryid

GO

/****** Object:  View [dbo].[vwAPAttendance]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAPAttendance] AS
Select O.staff_id, O.Branchkey,  S.Fullname, convert(char(12), O.Order_date, 103) as TradingDate, convert(char(12), O.Order_date, 112) as SortDate, 
'First' = Convert(varchar(12), Min(O.Order_Date),108),
'Last' = convert(char(12),Max(O.Order_Date),108), Totals = Count(O.Staff_ID) 
from staff as S JOIN orders as O on
(s.staff_id = O.staff_id) 
Group by O.staff_id, O.Branchkey, S.FullName, convert(char(12), O.Order_date, 103), convert(char(12), O.Order_date, 112)


GO

/****** Object:  View [dbo].[vwAPRefundReasons]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAPRefundReasons] AS
Select orders.order_id, orders.branchkey, orders.order_date, orders.staff_id, boxes.box_name, boxes.box_category, refunds.explanation,  refunds.authorisedbyID, 
refunds.originalorderid, refunds.originalbranchkey, staff.staff 
from 
(orders inner join refunds on orders.order_id = refunds.orderid and orders.branchkey = refunds.branchkey
left outer join staff on orders.staff_id = staff.staff_id)
inner join order_details on orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey
inner join boxes on order_details.box_id = boxes.box_id
where orders.order_type = 4 and orders.processed = 1



GO

/****** Object:  View [dbo].[vwAPRefundTypes]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAPRefundTypes] AS
Select staff.staff, orders.order_id, orders.staff_id, orders.branchkey, orders.order_date, orderpaymentelements.clearingamount, paymentmethods.paymentmethod 
from orders inner join orderpaymentelements
on orders.order_id = orderpaymentelements.orderid and orders.branchkey = orderpaymentelements.branchkey
inner join paymentmethods on orderpaymentelements.paymentmethodid = paymentmethods.paymentmethodid
inner join staff on orders.staff_id = staff.staff_id
where orders.order_type = 4 and orders.processed = 1



GO

/****** Object:  View [dbo].[vwAuditTrailReport]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAuditTrailReport] AS
select
AuditTrail.BranchKey,
AuditTrail.Branch_ID,
AuditEntryTypes.EntryType,
AuditEntryTypes.Description,
AuditTrail.EntryDate,
AuditTrail.box_id,
staff.staff,
s1.staff as AuthorizedBy,
staff.staff_id,
AuditTrail.Text          
from AuditEntryTypes 
inner join AuditTrail on AuditEntryTypes.EntryType=AuditTrail.EntryType
inner join staff on staff.staff_id=AuditTrail.StaffID
left join staff s1 on AuditTrail.SuperID=s1.staff_id



GO

/****** Object:  View [dbo].[vwBranchShortKeys]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwBranchShortKeys] AS
Select branchcategoryshortkeys.shortkey,branchcategoryshortkeys.branchid, category.box_category 
from branchCategoryShortkeys, category where category.category_id = branchcategoryshortkeys.categoryid


GO

/****** Object:  View [dbo].[vwItemHistory]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwItemHistory] AS
Select orders.*, 
order_details.order_details_id, order_details.box_id, order_details.quantity,
order_details.price, order_details.txtype, order_details.itemsn, order_details.refunded,
order_details.accepted, order_details.picked_up, order_details.trackno,
ordertypes.description as ordertype, 
transactiontypes.description as transactiontype, 
branches.abbrev
from orders, orderTypes, order_details, TransactionTYpes, branches
where orders.order_id = order_details.order_id
and orders.branchkey = order_details.branchkey
and orders.order_type = ordertypes.id
and order_details.txtype = transactiontypes.id
and orders.branch_id = branches.branchid
and orders.processed = 1


GO

/****** Object:  View [dbo].[vwNewOrderItemList]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwNewOrderItemList] AS
Select orders.order_type, Orders.Order_ID, Orders.branchkey, orders.branchkey + convert(char(8), orders.order_id) as CompOrder, ordertypes.description, 
transactiontypes.description as transtype, Orders.order_date,orders.processed, orders.staff_id, orders.branch_id, Order_details.box_id, boxes.box_name, staff.staff 
from order_details, orders, ordertypes, transactiontypes, boxes, staff 
where orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey 
and orders.order_type = ordertypes.id 
and order_details.box_id = boxes.box_id 
and order_details.txtype = transactiontypes.id
and staff.staff_id = orders.staff_id


GO

/****** Object:  View [dbo].[vwNewPurchaseOrderReports]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwNewPurchaseOrderReports] AS
select PODeliveries.EntryID, PODeliveries.POID, PODeliveries.OrderID, PODeliveries.DestinationBranchid, PODeliveries.Discrepancy, 
Order_details.Order_Details_ID, Order_details.Order_ID, Order_details.Quantity, Order_details.Price, Order_details.TxType, Order_details.Type, Order_details.Discount, Order_details.ItemSN, 
Order_details.Refunded, Order_details.Picked_up,Order_details.Accepted,Order_details.TrackNo,boxes.Box_id,box_category,boxes.box_name,boxes.origin,
branches.branchid,branchname,branches.abbrev,branches.address_1,branches.address_2,branches.city,branches.county,branches.post_code,
purchaseorders.notes,purchaseorders.supplierid,purchaseorders.supplierref,purchaseorders.ponumber,purchaseorders.podate, purchaseorders.duedate,
supplierinfo.companyname,supplierinfo.address_1 as supplieraddress1,supplierinfo.address_2 as supplieraddress2,supplierinfo.address_3 as supplieraddress3,
supplierinfo.postcode as supplierpostcode,supplierinfo.county as suppliercounty,supplierinfo.country as suppliercountry,supplierinfo.currencyid as suppliercurrencyid,
purchaseorderdetails.originalcurrencyprice
from PODeliveries, Order_details, boxes, branches, supplierinfo, purchaseorders, purchaseorderdetails
where PODeliveries.orderid = order_details.order_id
and boxes.box_id = order_details.box_id
and podeliveries.destinationbranchid = branches.branchid
and purchaseorders.purchaseorderid = PODeliveries.POID
and supplierinfo.supplierid = purchaseorders.supplierid
and purchaseorderdetails.branchid = podeliveries.destinationbranchid 
and purchaseorderdetails.poid = podeliveries.poid

GO

/****** Object:  View [dbo].[vwOrderItemList]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwOrderItemList] AS
	Select orders.order_type, Ordertypes.description as description, Orders.Order_ID, Orders.order_date,orders.processed, orders.staff_id, 
	orders.branch_id, 'Processed' as 'Done', Order_details.box_id, boxes.box_name, staff.staff 
	from order_details, orders, Ordertypes, boxes, staff 
	where orders.order_id = order_details.order_id and orders.order_type = ordertypes.id and order_details.box_id = boxes.box_id and staff.staff_id = orders.staff_id and orders.processed = 1
		union 
	Select orders.order_type, Ordertypes.description as description, Orders.Order_ID, Orders.order_date, orders.processed, orders.staff_id, 
	orders.branch_id,'Unprocessed' as 'Done', Order_details.box_id, boxes.box_name, staff.staff 
	from order_details, orders, Ordertypes, boxes, staff
	where orders.order_id = order_details.order_id and orders.order_type = ordertypes.id and order_details.box_id = boxes.box_id and staff.staff_id = orders.staff_id and orders.processed = 0


GO

/****** Object:  View [dbo].[vwOrderItems]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwOrderItems] AS
select order_details.*, boxes.box_name ,boxes.new, boxes.box_category, boxes.origin  from order_details, boxes where order_details.box_id = boxes.box_id


GO

/****** Object:  View [dbo].[vwPaymentElements]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPaymentElements] 
AS 
select orders.order_id, orderpaymentelements.*, paymentmethods.paymentmethod 
from orders, orderpaymentelements, paymentmethods 
where orders.order_id = orderpaymentelements.orderid and orders.branchkey = orderpaymentelements.branchkey 
and orderpaymentelements.paymentmethodid = paymentmethods.paymentmethodid and paymentmethods.paymentin = 1

GO

/****** Object:  View [dbo].[vwPODeliveryAddress]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPODeliveryAddress] AS
select podeliveries.entryid, podeliveries.orderid, podeliveries.poid, podeliveries.destinationbranchid, podeliveries.discrepancy, podeliveries.completed, 
branches.branchid, branches.branchname, branches.abbrev  
FROM podeliveries, branches where podeliveries.destinationbranchid = branches.branchid


GO

/****** Object:  View [dbo].[vwPOItemSummary]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwPOItemSummary] AS
select PODeliveries.destinationBranchID, PODeliveries.orderid, podeliveries.branchkey, podeliveries.POID, PODeliveries.discrepancy, PODeliveries.completed, 
PurchaseOrderDetails.boxid, PurchaseorderDetails.CurrencyID, PurchaseOrderdetails.OriginalCurrencyPrice, PurchaseOrderDEtails.clearingcurrencyprice, purchaseORderdetails.taxrate, 
Order_details.Accepted, Order_details.order_details_id, order_details.quantity, 
branches.abbrev,
boxes.origin, boxes.box_category
from PODeliveries, PurchaseOrderDetails, Order_details, branches, boxes
where PODeliveries.POID = PurchaseORderDetails.POID
and PODeliveries.orderID = order_details.order_id
and PurchaseOrderDetails.boxid = order_details.box_id
and branches.branchid = PODeliveries.destinationBranchid
and boxes.box_id = order_details.box_id



GO

/****** Object:  View [dbo].[vwPurchaseOrderStatus]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/****** Object:  View dbo.vwPurchaseOrderStatus    Script Date: 03/06/2001 18:06:15 ******/
CREATE VIEW [dbo].[vwPurchaseOrderStatus] AS
select PurchaseOrders.*, PODeliveries.ENtryID, PODeliveries.POID, PODeliveries.OrderID, PODeliveries.DestinationBranchID, PODeliveries.Completed, PODeliveries.discrepancy, orders.Order_ID, staff.staff,
branches.branchname, branches.abbrev, branches.address_1, supplierinfo.companyname
from purchaseorders, podeliveries, orders, staff, branches, supplierinfo
where purchaseorders.PurchaseOrderID = PODeliveries.POID
and PODeliveries.orderid = orders.order_id
and staff.staff_id = purchaseorders.buyer_staffid
and branches.branchid = PODeliveries.destinationbranchid
and purchaseorders.supplierid = supplierinfo.supplierid



GO

/****** Object:  View [dbo].[vwreferencedCategoryCount]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/****** Object:  View dbo.vwreferencedCategoryCount    Script Date: 03/06/2001 18:06:15 ******/
CREATE VIEW [dbo].[vwreferencedCategoryCount] AS
select Box_category, count(box_id) as BoxCatCount from boxes group by box_category


GO

/****** Object:  View [dbo].[vwReferencedCategoryList]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwReferencedCategoryList] AS
select distinct box_category from boxes

GO

/****** Object:  View [dbo].[vwRefundElements]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwRefundElements] AS 
select orders.order_id, orders.branchkey as OrderBranchKey, orderpaymentelements.*, paymentmethods.paymentmethod 
from orders, orderpaymentelements, paymentmethods 
where orders.order_id = orderpaymentelements.orderid and orderpaymentelements.paymentmethodid = paymentmethods.paymentmethodid and paymentmethods.paymentin = 0


GO

/****** Object:  View [dbo].[vwReserveInfo]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwReserveInfo] AS 
Select reserves.*, orders.order_date, branches.branchid, branches.branchname, branches.abbrev, staff.staff 
from reserves, orders, branches, staff 
where reserves.orderid = orders.order_id 
and orders.staff_id = staff.staff_id
and orders.branch_id = branches.branchid 


GO

/****** Object:  View [dbo].[vwSalesbyCat]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSalesbyCat] AS
select convert(varchar, datepart(yy, orders.order_date)) + '/' + convert(varchar,datepart(mm, orders.order_Date)) + '/' + convert(varchar, datepart(dd, orders.order_date)) as OrderDate, 
boxes.box_category, convert(integer, boxes.new) as BoxNew, sum(quantity * price) as TotalSales, Orders.branch_id as Branchid from order_details, orders, boxes
where orders.order_id = order_details.order_id
and order_details.box_id = boxes.box_id
and orders.order_type = 1
and order_details.txtype = 1
group by convert(varchar, datepart(yy, orders.order_date)) + '/' + convert(varchar,datepart(mm, orders.order_Date)) + '/' + convert(varchar, datepart(dd, orders.order_date)),
boxes.box_category, convert(integer, boxes.new), Orders.branch_id


GO

/****** Object:  View [dbo].[vwSalesbyDay]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSalesbyDay] AS
Select  boxes.box_id, boxes.box_name, convert(integer, boxes.discontinued) as iDiscon, convert(integer, boxes.new) as inew, boxes.origin, boxes.box_category, 
datediff(dd,orders.order_Date, getdate()) as age,   order_details.txtype, sum(order_details.quantity) as numbersold
from boxes left outer join (order_details inner join orders on orders.order_id = order_details.order_id) on boxes.box_id = order_details.box_id
and (order_details.txtype = 1 or order_details.txtype is null)
group by boxes.box_id, boxes.box_name,  convert(integer, boxes.discontinued) , convert(integer, boxes.new) ,  boxes.origin, boxes.box_category,order_details.txtype, datediff(dd, orders.order_date,getdate())


GO

/****** Object:  View [dbo].[vwSteveTest]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSteveTest] AS
select min(orders.order_date) as earliest, boxes.box_category, convert(integer, boxes.new) as BoxNew, sum(quantity * price) as TotalSales, Orders.branch_id as Branchid 
from order_details, orders, boxes
where orders.order_id = order_details.order_id
and order_details.box_id = boxes.box_id
and orders.order_type = 1and order_details.txtype = 1
group by boxes.box_category, convert(integer, boxes.new), Orders.branch_id


GO

/****** Object:  View [dbo].[vwWorkstationBranch]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwWorkstationBranch] AS 
SELECT workstationbranches.workstationID,workstationbranches.defaultbranch, branches.*, locations.location_ID, locations.location_name, locationbranches.locationtype 
from WorkstationBranches, branches, locationbranches, locations
where WorkstationBranches.branchid = branches.branchid and locationbranches.branchid = branches.branchid and locationbranches.locationid = locations.location_id


GO

/****** Object:  View [dbo].[vwxlBoxHistory]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwxlBoxHistory] AS
SELECT boxes.box_id, boxes.box_name, boxes.box_category, boxes.origin, convert(int, boxes.new) as IsNew, Convert (int, boxes.discontinued) as IsDiscontinued, 
Sum(order_details.quantity) AS totalMovements, Max(orders.order_Date) as LastMovement
FROM (boxes LEFT OUTER JOIN order_details ON boxes.box_id = order_details.box_id) 
left outer join orders on (orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey)
GROUP BY boxes.box_id, boxes.box_name, boxes.box_category,  boxes.origin, convert(int, boxes.new), Convert (int, boxes.discontinued)


GO

/****** Object:  View [dbo].[vwXLDailySales]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLDailySales] AS
select orders.branchkey, transactiontypes.description, order_details.box_id, boxes.box_name, boxes.origin, boxes.box_Category, sum(order_details.price) as TotalSales, 
sum(order_details.quantity) as Unit,
sum(order_details.price) / sum(order_details.quantity) as UnitPrice, 
convert(char(12), orders.order_date, 103)
as convertdate,
convert(char(8), orders.order_date, 112) as SortDate ,
datediff(dd, orders.order_Date, getdate()) as Age,
Getdate() as RefreshDate
from orders, order_details, transactiontypes, boxes 
where orders.order_id = order_details.order_id 
and orders.branchkey = order_details.branchkey
and order_details.txtype = transactiontypes.id
and order_details.box_id = boxes.box_id  
and orders.processed = 1
group by 
convert(char(12),  orders.order_date, 103),
convert(char(8),  orders.order_date, 112),
datediff(dd, orders.order_Date, getdate()),
boxes.box_Category,
boxes.box_name,
boxes.origin,
orders.branchkey, transactiontypes.description, order_details.box_id



GO

/****** Object:  View [dbo].[vwXLDailyTotals]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLDailyTotals] AS
select orders.branchkey, transactiontypes.description,  sum(order_details.price) as TotalSales, sum(order_details.quantity) as Units, count(order_details.order_id) as transactions,
convert(char(12), orders.order_date, 103)
as convertdate,
convert(char(8), orders.order_date, 112) as SortDate ,
datediff(dd, orders.order_Date, getdate()) as Age
from orders, order_details, transactiontypes, boxes 
where orders.order_id = order_details.order_id 
and orders.branchkey = order_details.branchkey
and order_details.txtype = transactiontypes.id
and order_details.box_id = boxes.box_id  
and orders.processed = 1
group by 
convert(char(12),  orders.order_date, 103),
convert(char(8),  orders.order_date, 112),
datediff(dd, orders.order_Date, getdate()),
orders.branchkey, transactiontypes.description


GO

/****** Object:  View [dbo].[vwXLMonthlySales]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLMonthlySales] AS
select orders.branchkey, transactiontypes.description, order_details.box_id, boxes.box_name, boxes.origin, boxes.box_Category, sum(order_details.price) as TotalSales, 
sum(order_details.quantity) as Unit,
sum(order_details.price) / sum(order_details.quantity) as UnitPrice, 
convert(char(4), orders.order_date, 7) + convert(char(4), orders.order_date, 112)
as convertdate,
convert(char(6), orders.order_date, 112) as SortDate 
from orders, order_details, transactiontypes, boxes 
where orders.order_id = order_details.order_id 
and orders.branchkey = order_details.branchkey
and order_details.txtype = transactiontypes.id
and order_details.box_id = boxes.box_id  
and orders.processed = 1
group by 
convert(char(4),  orders.order_date, 7) + convert(char(4), orders.order_date, 112),
convert(char(6),  orders.order_date, 112),
boxes.box_Category,boxes.box_name,
boxes.origin,
orders.branchkey, transactiontypes.description, order_details.box_id


GO

/****** Object:  View [dbo].[vwXLOrderDetail]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLOrderDetail] AS
Select orders.order_type, Orders.Order_ID, Orders.branchkey, orders.branchkey + convert(char(8), orders.order_id) as CompOrder, ordertypes.description, 
transactiontypes.description as transtype, Orders.order_date,orders.processed, orders.staff_id, orders.branch_id, Order_details.box_id, Order_details.price, Order_details.quantity, 
boxes.box_name, staff.staff 
from order_details, orders, ordertypes, transactiontypes, boxes, staff 
where orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey 
and orders.order_type = ordertypes.id 
and order_details.box_id = boxes.box_id 
and order_details.txtype = transactiontypes.id
and staff.staff_id = orders.staff_id
and orders.processed = 1



GO

/****** Object:  View [dbo].[vwxltradedboxes]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwxltradedboxes] AS
select boxes.box_id, convert(int,boxes.box_deleted) as box_deleted, boxes.box_name, boxes.box_category, boxes.origin, convert(int, boxes.new) as IsNew, 
convert(int, boxes.discontinued) as IsDiscontinued,  sum(order_details.quantity) as tradecount from 
boxes left outer join order_details on boxes.box_id = order_details.box_id
group by boxes.box_id, box_name, box_category, convert(int, box_deleted), boxes.origin, convert(int, boxes.new), convert(int, boxes.discontinued)
having sum(order_details.quantity) is not null


GO

/****** Object:  View [dbo].[vwXLTransfers]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLTransfers] AS
Select orders.branchkey, orders.order_id, order_details.box_id, order_details.quantity, boxes.box_name, boxes.origin, boxes.box_category,  orders.order_date, 
internalorders.notes, branches.abbrev as DestBranch
from orders, order_details, internalorders, branches, boxes
where orders.order_id = internalorders.orderid and orders.branchkey = internalorders.branchkey
and internalorders.destinationbranchid = branches.branchid and orders.order_id = order_details.order_id
and order_details.box_id = boxes.box_id
and orders.order_type = 2


GO

/****** Object:  View [dbo].[vwxluntradedboxes]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwxluntradedboxes] AS
select boxes.box_id, boxes.box_name, convert (int, boxes.box_deleted) as box_deleted, boxes.box_category, boxes.origin, convert(int, boxes.new) as IsNew, 
convert(int, boxes.discontinued) as IsDiscontinued,  sum(order_details.quantity) as tradecount from 
boxes left outer join order_details on boxes.box_id = order_details.box_id
group by boxes.box_id, box_name, box_category, boxes.origin, convert(int, boxes.new), convert(int, box_deleted), convert(int, boxes.discontinued)
having sum(order_details.quantity) is null



GO

/****** Object:  View [dbo].[vwXLWeeklySales]    Script Date: 9/14/2016 8:31:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwXLWeeklySales] AS
select orders.branchkey, transactiontypes.description, order_details.box_id, boxes.box_name, boxes.origin, boxes.box_Category, sum(order_details.price) as TotalSales, 
sum(order_details.quantity) as Unit,
sum(order_details.price) / sum(order_details.quantity) as UnitPrice, 
datepart(wk, orders.order_date)as weekno,
datediff(wk, orders.order_date, getdate()) as age,
getdate() as refreshdate
from orders, order_details, transactiontypes, boxes 
where orders.order_id = order_details.order_id
and orders.branchkey = order_details.branchkey 
and order_details.txtype = transactiontypes.id
and order_details.box_id = boxes.box_id  
and orders.processed = 1
group by 
datepart(wk, orders.order_date),
boxes.box_Category,
boxes.box_name,
boxes.origin,
orders.branchkey, transactiontypes.description, order_details.box_id, datediff(wk, orders.order_date, getdate())


GO

/********************END OF SCRIPT TO CREATE VIEWS**************************************/

/********************SCRIPT TO STORED PROCEDURES****************************************/

USE [Epos2000]
GO

/****** Object:  StoredProcedure [dbo].[sp_AddAudit]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AddAudit] @Branchkey char(2), @entrytype integer, @WorkstationID varchar(25), @staffid integer, @text varchar(128), @superid integer, 
@orderid integer, @branch_id integer, @box_id char(20), @quantity integer AS

declare @nextEntry Integer

begin transaction
select @Nextentry = max(entryid) + 1 from audittrail where branchkey = @branchkey
if @nextentry is null begin
insert into audittrail (entryid, branchkey, entrytype,entrydate,workstationid,staffid,text,superid,orderid, branch_id,box_id,quantity) values (1,@branchkey, @entrytype, getdate(), @workstationid,@staffid,@text,@superid,@orderid,@branch_id,@box_id,@quantity)
end
else begin
insert into audittrail (entryid, branchkey, entrytype,entrydate,workstationid,staffid,text,superid,orderid, branch_id,box_id,quantity) values (@Nextentry,@branchkey, @entrytype, getdate(), @workstationid,@staffid,@text,@superid,@orderid,@branch_id,@box_id,@quantity)
end
commit transaction


GO

/****** Object:  StoredProcedure [dbo].[sp_AddCat]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_AddCat] @Branchkey  char(2), @box_Category  varchar(25), @always_2labels bit, @show_price_on_label bit, @abbrev char(2), @in_snreq bit, @out_snreq bit  AS

declare @NextCatID integer

select @NextCatid = max(category_id) + 1 from category
insert into category (category_id, branchkey, category_type, box_category, box_is_order_id, read_only, always_2labels, show_price_on_label, abbrev, in_snreq, out_snreq) values (@NextCatid, @branchkey, 0, @box_category, 0,0,@always_2labels, @show_price_on_label, @abbrev, @in_snreq, @out_snreq)


GO

/****** Object:  StoredProcedure [dbo].[sp_AddOrderDetail]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_AddOrderDetail]  @NewOrderDetailID int out, @Order_details_ID int, @Branchkey char(2), @Order_ID int, @Box_id Varchar(20), @Quantity int, 
@Price money, @txtype int, @type int, @discount real, @itemsn varchar(15),  @refunded int, @picked_Up bit, @accepted bit, @trackno int  AS

declare @NextOrderDetailID Integer

if @Order_details_ID = -1 
	begin 
		begin transaction
		update numbers set number_number = number_number + 1 where number_type = 'ORDERDET' and branchkey = @branchkey
		select @NextOrderDetailID = number_number from numbers where number_type = 'ORDERDET' and branchkey = @branchkey 
	/*	Select @NextOrderDetailID = max(order_details_id) from order_details where branchkey = @branchkey */
		insert into Order_DEtails (Order_details_id,     Branchkey,  Order_ID,  box_id,  Quantity,  Price,  Txtype,  Type,  Discount,  ItemSN,  Refunded,  Picked_up,  accepted,  Trackno) values 
                                          (@nextorderdetailid+1, @branchkey, @order_id, @box_id, @Quantity, @Price, @txtype, @Type, @discount, @ItemSN, @Refunded, @picked_up, @Accepted, @Trackno)
		commit transaction		
		Select @NewOrderDetailID = @NextOrderDetailID + 1
	end
else
	begin
		insert into Order_DEtails (Order_details_id, Branchkey, Order_ID, box_id, Quantity, Price, Txtype, Type, Discount, ItemSN, Refunded, Picked_up, accepted, Trackno) values (@order_details_id, @branchkey, @order_id, @box_id, @Quantity, @Price, @txtype, @Type, @discount, @ItemSN, @Refunded, @picked_up, @Accepted, @Trackno)
		select @NewOrderDetailid = max(Order_Details_ID) from Order_Details where branchkey = @branchkey
		update numbers set number_number = @NewOrderDetailID + 1 where number_type = 'ORDERDET' and branchkey = @branchkey
	end


GO

/****** Object:  StoredProcedure [dbo].[sp_AddOrderPaymentElement]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_AddOrderPaymentElement]  @NewOrderID int out, @Opeid int, @Branchkey char(2), @OrderID int, @paymentmethodid int, @currencyid char(3), @ClearingAmount money, @CurrencyAmount money, @redeemed bit AS

declare @NextOpeID Integer

if @Opeid = -1 
	begin 
		begin transaction
		update numbers set number_number = number_number + 1 where number_type = 'ORDERPAY' and branchkey = @branchkey
		select @NextOpeID = number_number from numbers where number_type = 'ORDERPAY' and branchkey = @branchkey
		insert into OrderPaymentElements (OPEID, Branchkey, OrderID, Paymentmethodid, Currencyid, currencyamount, clearingamount, redeemed) values (@nextopeid+1, @branchkey, @orderid, @Paymentmethodid, @currencyid, @clearingamount, @currencyamount, @redeemed)
		commit transaction		
		Select @NewOrderID = @NextOpeID
	end
else
	begin
		insert into OrderPaymentElements (OPEID, Branchkey, OrderID, Paymentmethodid, Currencyid, currencyamount, clearingamount, redeemed) values (@opeid, @branchkey, @orderid, @Paymentmethodid, @currencyid, @clearingamount, @currencyamount, @redeemed)
		select @NewOrderid = max(opeid) from OrderPaymentElements where branchkey = @branchkey
	end


GO

/****** Object:  StoredProcedure [dbo].[sp_boxAddUpdate]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_boxAddUpdate] @box_id varchar(20), @box_name varchar(40), @box_category varchar(25), @discontinued bit,  @new bit, @origin varchar(20), @stock_date datetime, @stockable bit, @in_snreq bit, @out_snreq bit, @box_deleted bit, @temporaryID bit, @boxbarcode char(8), @mancode char(3), @manprodcode char(3), @zerovat bit, @operatingCompany char(4), @last_change_branchkey char(2)

AS
/*
sp to create a box if it doesnt exist, else update it
*/

if (select count(*) from boxes where box_id = @box_id) = 0 
    begin
	insert into boxes (box_id, box_name, box_category, discontinued, no_box, no_inst, new, origin, stock_date, stockable, in_snreq, out_snreq, box_deleted, temporaryid, boxbarcode, catcode, mancode, manprodcode, zerovat, operatingcompany, last_change_branchkey)
	values(@box_id, @box_name, @box_category, @discontinued, 0, 0, @new, @origin, @stock_Date, @stockable, @in_snreq, @out_snreq, @box_deleted, @temporaryid, @boxbarcode, '   ', @mancode, @manprodcode, @zerovat, @operatingCompany, @last_change_branchkey)
	print 'Box added with origin '
    end
else
    begin     /* Box exists - update it */
	update boxes set box_name = @box_name,
	box_category = @box_category,
	discontinued = @discontinued,
	New = @new,
	Origin = @origin,
	stock_date = @stock_Date, 
	stockable = @stockable, 
	in_snreq = @in_snreq, 
	out_snreq = @out_snreq, 
	box_deleted = @box_deleted, 
	temporaryid = @temporaryid, 
	boxbarcode = @boxbarcode, 
	mancode = @mancode,
	Manprodcode = @manprodcode,
	zerovat = @zerovat, 
	operatingcompany = @operatingcompany, 
	last_change_branchkey = @last_change_branchkey
	where box_id = @box_id
    print 'Box exists'
    end

/* Call sp to make sure box_category and catcode are in line */  
  exec sp_setcatcode @box_id


GO

/****** Object:  StoredProcedure [dbo].[sp_boxinsert]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_boxinsert] @box_id varchar(20), @box_name varchar(40), @box_category varchar(25), @discontinued bit, @no_box bit, @no_inst bit, @new bit, @origin varchar(20), 
@stock_date datetime, @stockable bit, @in_snreq bit, @out_snreq bit, @box_deleted bit, @temporaryID bit, @boxbarcode char(8), @zerovat bit, @operatingCompany char(4), @last_change_branchkey char(2)

AS

if (select count(*) from boxes where box_id = @box_id) = 0 
    begin
	insert into boxes (box_id, box_name, box_category, discontinued, no_box, no_inst, new, origin, stock_date, stockable, in_snreq, out_snreq, box_deleted, temporaryid, boxbarcode, zerovat, operatingcompany, last_change_branchkey)
	values(@box_id, @box_name, @box_category, @discontinued, @no_box, @no_inst, @new, @origin, @stock_Date, @stockable, @in_snreq, @out_snreq, @box_deleted, @temporaryid, @boxbarcode, @zerovat, @operatingCompany, @last_change_branchkey)
	print 'Box added'
    end

else
    print 'Box exists'


GO

/****** Object:  StoredProcedure [dbo].[sp_changeboxid]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_changeboxid    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_changeboxid    Script Date: 03/06/2001 18:14:17 ******/
CREATE PROCEDURE [dbo].[sp_changeboxid] @oldbox varchar(20), @newbox varchar(20) AS
declare @box_name varchar(40)
declare @temporaryID  bit
declare @box_category varchar(25)
declare @origin varchar(20)
declare @discontinued bit
declare @no_box bit
declare @no_inst  bit
declare @new bit
declare @stock_Date datetime
declare @stockable bit
declare @in_snreq bit
declare @out_snreq bit
declare @box_deleted  bit
Select @box_name = box_name, 
	@temporaryID = temporaryID,
	@box_category = box_category,
 	@origin = origin,
	@discontinued = discontinued,
 	@no_box  = no_box,
 	@no_inst  = no_inst,
	@new =  new,
 	@stock_Date = stock_date,
 	@stockable = stockable,
 	@in_snreq = in_snreq,
 	@out_snreq = out_snreq,
 	@box_deleted  = box_deleted
	from boxes where box_id = @oldbox
insert into boxes (box_id, box_name, temporaryID, box_category, origin, discontinued,
	no_box, no_inst, new, stock_date, stockable, in_snreq, out_snreq, box_deleted)
	values
	(@newbox, @box_name, @temporaryID, @box_category, @origin, @discontinued,
	@no_box, @no_inst, @new, @stock_date, @stockable, @in_snreq, @out_snreq, @box_deleted)
update boxquantities set boxid = @newbox where boxid = @oldbox
update branchprices set boxid = @newbox where boxid = @oldbox
update order_details set box_id = @newbox where box_id = @oldbox
update purchaseorderdetails set boxid = @newbox where boxid = @oldbox
delete from boxes where box_id = @oldbox


GO

/****** Object:  StoredProcedure [dbo].[sp_delorder]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_delorder    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_delorder    Script Date: 03/06/2001 18:14:18 ******/
CREATE PROCEDURE [dbo].[sp_delorder] @OrderID Integer, @branchkey char(2) AS
if (Select count(*) from orders where Order_ID = @orderid ) = 0 
	print 'order does not exist'
else
	begin
		delete from PODeliveries  where orderid = @orderid and branchkey = @branchkey
		delete from orderpaymentelements where orderid = @orderid and branchkey = @branchkey
		delete from order_details where order_id = @orderid and branchkey = @branchkey
		delete from refunds where orderid = @orderid and branchkey = @branchkey
		delete from workorders where orderid = @orderid and branchkey = @branchkey
		delete from internalorders where orderid = @orderid and branchkey = @branchkey
		delete from orders where order_id = @orderid and branchkey = @branchkey
		print 'Order Deleted'
	end


GO

/****** Object:  StoredProcedure [dbo].[sp_LinesAffected]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_LinesAffected    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_LinesAffected    Script Date: 20/09/06 12:32:40 ******/
CREATE PROCEDURE [dbo].[sp_LinesAffected] 
AS
SELECT @@rowcount as Rows


GO

/****** Object:  StoredProcedure [dbo].[sp_ModCat]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_ModCat    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_ModCat    Script Date: 03/06/2001 18:14:17 ******/
CREATE PROCEDURE [dbo].[sp_ModCat] @result integer out, @Branchkey  char(2), @box_Category  varchar(25), @always_2labels bit, @show_price_on_label bit, @abbrev char(2), @in_snreq bit, @out_snreq bit  AS

declare @CatID integer

select @result = count(*) from category where box_category = @box_Category
if @result = 1 begin
	select @Catid = category_id from category where box_category = @box_category
	update category set branchkey = @branchkey, category_type = 0, box_category = @box_category, box_is_order_id = 0, read_only = 1, always_2labels = @always_2labels, show_price_on_label = @show_price_on_label, abbrev = @abbrev, in_snreq = @in_snreq, out_snreq = out_snreq where category_id = @catid
end


GO

/****** Object:  StoredProcedure [dbo].[sp_PODelStatus]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_PODelStatus    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_PODelStatus    Script Date: 03/06/2001 18:14:17 ******/
CREATE PROCEDURE [dbo].[sp_PODelStatus] @OrderID Integer AS
if (Select count(*) from order_details where Order_ID = @orderid and accepted = 0) > 0 
	print 'Its not done'
else
	begin
		update PODeliveries set completed = 1 where orderid = @orderid
		update orders set processed = 1 where order_id = @orderid
		print 'Order Updated'
	end


GO

/****** Object:  StoredProcedure [dbo].[sp_replboxinsert]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_replboxinsert    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_replboxinsert    Script Date: 03/06/2001 18:14:18 ******/
CREATE PROCEDURE [dbo].[sp_replboxinsert] @box_id varchar(20), @box_name varchar(40), @box_category varchar(25), @discontinued bit, @no_box bit, @no_inst bit, @new bit, @origin varchar(20), @stock_date datetime, @stockable bit, @in_snreq bit, @out_snreq bit, @box_deleted bit, @temporaryID bit, @boxbarcode char(8), @zerovat bit, @operatingCompany char(4), @last_change_branchkey char(2), @CatCode char(3), @ManCode char(3), @ManprodCode char(3)

AS

if (select count(*) from boxes where box_id = @box_id) = 0 
    begin
	insert into boxes (box_id, box_name, box_category, discontinued, no_box, no_inst, new, origin, stock_date, stockable, in_snreq, out_snreq, box_deleted, temporaryid, boxbarcode, zerovat, operatingcompany, last_change_branchkey, CatCode, ManCode, ManProdCode)
	values(@box_id, @box_name, @box_category, @discontinued, @no_box, @no_inst, @new, @origin, @stock_Date, @stockable, @in_snreq, @out_snreq, @box_deleted, @temporaryid, @boxbarcode, @zerovat, @operatingCompany, @last_change_branchkey, @CatCode, @ManCode, @ManProdCode)
	print 'Box added'
    end

else
    print 'Box exists'


GO

/****** Object:  StoredProcedure [dbo].[sp_replBranchPricesUpd]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_replBranchPricesUpd    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_replBranchPricesUpd    Script Date: 23/07/2003 12:05:09 ******/
Create Procedure [dbo].[sp_replBranchPricesUpd] @BranchID int, @BoxID varchar(20), @Sellrice money, @CashBuyPrice money, @ExchangePrice money, @ElasticityID int, @PKBranchID int, @PKBoxID varchar(20)
AS
/*
 __________________________________________________________________
  Author:          Jaco Eygelaar
  Enhancement Req.
  And Bug Reports: support@cex.co.uk

  Built/Tested On: SQL 6.5

  Purpose:         To place replicated updates from Branchprices
		   into the holding_BranchPrices table

  Syntax:          No arguments required.

  Assumptions And
  Limitations:     * Does not handle low environment errors.

  Last Update:     2003-06-27
 __________________________________________________________________

*/
Insert into Holding_BranchPrices (BranchID,
					BoxID, 
					SellPrice, 
					CashBuyPrice, 
					ExchangePrice, 
					ElasticityID, 
					Status)
Values (@BranchID, 
	@BoxID, 
	@Sellrice, 
	@CashBuyPrice, 
	@ExchangePrice, 
	@ElasticityID, 
	0)


GO

/****** Object:  StoredProcedure [dbo].[sp_SetCatCode]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_SetCatCode    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_SetCatCode    Script Date: 03/06/2001 18:14:17 ******/
CREATE PROCEDURE [dbo].[sp_SetCatCode] @box_id char(20) AS
/* 
DUMMY PRocedure.  When man/prod/cat codes implemented in front-end, will change to 
get te cat code corresponding to the boxes box_category and put in catcode field
*/


GO

/****** Object:  StoredProcedure [dbo].[sp_SummaryDailyCatSales]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_SummaryDailyCatSales    Script Date: 03/06/2001 18:14:18 ******/
CREATE PROCEDURE [dbo].[sp_SummaryDailyCatSales] @Catname char(20) AS
delete from Summarydailysales where box_category = @Catname
insert into Summarydailysales select * from vwxldailysales where box_category = @catname and age < 32


GO

/****** Object:  StoredProcedure [dbo].[sp_SummaryWeeklyCatSales]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.sp_SummaryWeeklyCatSales    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_SummaryWeeklyCatSales    Script Date: 03/06/2001 18:14:18 ******/
CREATE PROCEDURE [dbo].[sp_SummaryWeeklyCatSales] @Catname char(20) AS
delete from SummaryWeeklysales where box_category = @Catname
insert into SummaryWeeklySales select * from vwxlweeklysales where box_category = @catname and age < 32


GO

/****** Object:  StoredProcedure [dbo].[sp_TXStatus]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_TXStatus    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_TXStatus    Script Date: 03/06/2001 18:14:17 ******/
CREATE PROCEDURE [dbo].[sp_TXStatus] @OrderID Integer, @BranchKey char(2)  AS
if (Select count(*) from order_details where Order_ID = @orderid and accepted = 0 and branchkey = @BranchKey) > 0 
	print 'Its not done'
else
	begin
		update orders set processed = 1 where order_id = @orderid and BranchKey = @Branchkey
		print 'Order Updated'
	end


GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateBranchPrices]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.sp_UpdateBranchPrices    Script Date: 01/10/2012 10:12:11 ******/
/****** Object:  Stored Procedure dbo.sp_UpdateBranchPrices    Script Date: 23/07/2003 12:05:09 ******/
CREATE PROCEDURE [dbo].[sp_UpdateBranchPrices]
AS
/*
 __________________________________________________________________
  Author:          Jaco Eygelaar

  Enhancement Req.
  And Bug Reports: support@cex.co.uk

  Built/Tested On: SQL 6.5

  Purpose:         Parse the Holding_BranchPrice table and apply 
		   all outstading updates to BranchPrice

  Syntax:          No arguments required.

  Assumptions And
  Limitations:     * Does not handle low environment errors.

  Version:	   1.4
  Last Update:     2005-03-07

  Changelog:	   1.1 - Sets labels as purged if sellprice is
		   unchanged
		   1.2 - Delete all status = 5 at the end
		   1.3 - Pulled the Purging and deleting of expired
			 entries into the stored procedure from 
			 EPOS		   1.4 - Moved Removal of Dupes to the start to 
			 fix problem with multiple price updates
 __________________________________________________________________

*/

/* We mark all duplicated entries a purged */
UPDATE	dbo.Holding_BranchPrices
SET	Status = (Status | 4)
WHERE	(HBPID NOT IN
	(SELECT	MAX(dbo.Holding_BranchPrices.HBPID) AS SubID
	FROM	dbo.Holding_BranchPrices INNER JOIN dbo.boxes ON 
			dbo.Holding_BranchPrices.BoxID = dbo.boxes.box_id 
		INNER JOIN dbo.category ON 
			dbo.boxes.box_category = dbo.category.box_category
	GROUP BY	dbo.Holding_BranchPrices.BoxID, 
			dbo.category.show_price_on_label, 
			dbo.boxes.box_name
	HAVING	(dbo.category.show_price_on_label = 1)))


/* Declare and open the CURSOR */
DECLARE @BranchID int
DECLARE @BoxID varchar(20)
DECLARE @SellPrice money
DECLARE @CashBuyPrice money
DECLARE @ExchangePrice money
DECLARE @ElasticityID int
DECLARE BranchPrices_Cursor CURSOR FOR 
	select BranchID, BoxID, SellPrice, CashBuyPrice, ExchangePrice, ElasticityID
	from holding_branchPrices
	where status = 0
	order by HBPID asc

OPEN BranchPrices_Cursor
	FETCH NEXT FROM BranchPrices_Cursor INTO @BranchID, @BoxID, @SellPrice, @CashBuyPrice, @ExchangePrice, @ElasticityID
	WHILE @@FETCH_STATUS = 0	BEGIN
		BEGIN TRAN
			/* We mark unchanged SellPrices prices as  Purged to prevent the Label*/
			IF (Select SellPrice from BranchPrices where BoxID = @BoxID and BranchID = @BranchID) = @SellPrice
			BEGIN
				UPDATE holding_BranchPrices
				SET status = status |4				WHERE CURRENT OF BranchPrices_Cursor
			END
			
			/* We apply the HBP data to BP */
			UPDATE BranchPrices SET SellPrice = @SellPrice, 
						CashBuyPrice = @CashBuyPrice, 
						ExchangePrice = @ExchangePrice, 
						ElasticityID = @ElasticityID 
			WHERE (BranchID = @BranchID and BoxID = @BoxID)
			
			/*Set the status to Updated*/
			UPDATE holding_BranchPrices
			SET status = status |1
			WHERE CURRENT OF BranchPrices_Cursor
		COMMIT TRAN
		FETCH NEXT FROM BranchPrices_Cursor INTO @BranchID, @BoxID, @SellPrice, @CashBuyPrice, @ExchangePrice, @ElasticityID
	END

DEALLOCATE BranchPrices_Cursor

/* We remove expired entries thats been printed */
DELETE FROM dbo.Holding_BranchPrices
WHERE (CreateDate < DATEADD(dd, - 4, GETDATE())) and status &1 = 1


/* We remove all purged entries */
DELETE	FROM holding_branchprices
WHERE	status &4 = 4


GO

/****** Object:  StoredProcedure [dbo].[WeeklyIncome]    Script Date: 14/09/2016 07:35:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[WeeklyIncome]
	@@backdate DateTime = NULL
AS
/*  
	Weekly Income is Perform On every Saturday 02:00:00 AM (on Shop server)
	and it will actually collect Last Week total income. from last saturday to Friday
*/
/*
	WeeklyIncome is store procedure for calculate TotalIncome.
	It take date as parameter. [optional]
	What it Does:
		-If Date parameter given then Find Last week Start Date and End Date. If no Date given then today's date assigned. 
		- Create tmpStinc Table in tempDB. 
		- Perform STINC Logically and collect Data in tmpStinc Table
		- Copy Data from tmpStinc Table to STINC table 
		- Drop tmpSTinc table. 
		- Version  1.1.0.0 - release Date: 07 Octomeber 2009
		- 
	
*/

DECLARE @branchKey  char(2)
DECLARE @order_id int 

DECLARE @Payorder_id int
DECLARE @order_Date    datetime
DECLARE @box_id varchar(20)
DECLARE @qty int
DECLARE @price money
DECLARE @category_id int
/* Variables to be use  */
DECLARE @vstr varchar(55)
DECLARE @orderValue money
DECLARE @OrderSales money
DECLARE @OrderBuyin Money
DECLARE @ClearingAmt money
DECLARE @Contribution Money
DECLARE @txType int
DECLARE @PaymentID int
DECLARE @OrderRows int 
DECLARE @PaymentRows int
DECLARE @tmpCount int
DECLARE @OrderRecCount int
DECLARE @OrderLoopCount int
DECLARE @TotalRec int
DECLARE @BrKey char(2)
/*  -- today's date  */
DECLARE @performDate Datetime 
DECLARE @LastUpdate DateTime 
DECLARE @ToDate Datetime
DECLARE @FromDate DateTime
DECLARE @CashIn Money
DECLARE @CashOut Money
DECLARE @TI Money
DECLARE @toDay varchar(15)
/*  
TO DEAL WITH DATE CONVERTION  
*/
DECLARE @stDat char(12) 
DECLARE @h int
DECLARE @m int
DECLARE @s int
DECLARE @ms int
DECLARE @EndDate Datetime
DECLARE @checkFirst int
DECLARE @getStartDay int
DECLARE @startDate DateTime 
DECLARE @Successed bit
DECLARE @SpecialCase int 
DECLARE @PositiveBuyIn Money
DECLARE @WeekNumber Int
-- Put error Control 
DECLARE @errNum INT 
DECLARE @TTI char(255)



	/****** Object:  Table dbo.tmpStinc    Script Date: 14/04/2008 11:19:11 AM ******/
	CREATE TABLE tempDB.dbo.tmpStinc (
 	StincID int IDENTITY (1, 1) NOT NULL ,
	BranchKey varchar (2) NULL ,
	Category_id int NULL ,
	WeekNum int NULL ,
	WeekStartDate datetime NULL ,
	WeekEndDate datetime NULL ,
	LastUpdate datetime NULL ,
	CashIn money NULL ,
	CashOut money NULL ,
	TI money NULL ,
	SUCCESS bit NOT NULL 
	)

SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 

SET NOCOUNT ON

IF @@backDate = NULL 
BEGIN
/* 
 -- Get Today's Date 
 */
SELECT @performDate = GetDate()
SELECT @toDay = DateName(weekday,@performDate)
SELECT @WeekNumber  = DATEPART(WEEK,@performDate) 
END 
ELSE
BEGIN
	IF @@backDate <> NULL
	BEGIN
		SELECT @performDate = @@backDate
		SELECT @toDay = DateName(weekday,@performDate)
		SELECT @WeekNumber  = DATEPART(WEEK,@performDate) 
	END
END 


/* -- Get Branchkey from settings Table */ 
SELECT @BrKey = BranchKey 
	From epos2000.dbo.BranchSetting Where SettingId = 1

/*  --Error Control --*/
SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 

/* -- start day for last week  */
SELECT @startDate =
	CASE
		WHEN @Today = 'Sunday' THEN DATEADD(day,-8,@performDate)
		WHEN @Today = 'Monday' THEN DATEADD(day,-9,@performDate)
		WHEN @Today = 'Tuesday' THEN DATEADD(day,-10,@performDate) 		
		WHEN @Today = 'Wednesday' THEN DATEADD(day,-11,@performDate)
		WHEN @Today = 'Thursday' THEN DATEADD(day,-12,@performDate)
		WHEN @Today = 'Friday' THEN DATEADD(day,-13,@performDate)
		WHEN @Today = 'Saturday' THEN DATEADD(day,-7,@performDate)
	END 

/* -- here Convert Start Date and St Date Into Appropriate Conversions 
	To remove Time Part from Date  and set it back to 00:00:00 */
SELECT @stDat = CONVERT(CHAR(12),@startDate,106) 
SELECT @startDate = CONVERT(datetime,@stDat, 106)
SELECT @EndDate = DateAdd(day,6,CONVERT(DATETIME,@stDat,106))
/*  -- SET ENDDATE'S TIME FOR 23:59:59 */ 
SELECT @h = Convert(int,DATEPART(hour,@EndDate),106)
SELECT @m = Convert(int,DATEPART(minute,@EndDate),106)
SELECT @s = Convert(int,DATEPART(second,@EndDate),106)
SELECT @ms = Convert(int,DATEPART(millisecond,@EndDate),106)
/* -- */ 
SELECT @EndDate = DATEADD(hour, 23- @h,@EndDate)
SELECT @EndDate = DATEADD(minute, 59- @m, @EndDate)
SELECT @EndDate = DATEADD(second, 59- @s, @EndDate)
SELECT @EndDate = DATEADD(millisecond, 990 - @ms, @EndDate) 
SELECT @FromDate = @StartDate
SELECT @ToDate = @EndDate
SELECT @FromDate As FromDate, @ToDate as Todate


/* Trap Errors */
SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 
 /*
    Below Query Retrive All Order of perticular Day in Temporary Table called '#orderLine1'
   */
BEGIN Tran P1
/*
 Create a temporary table for Cursor to use.
	Following query retrieves all order details line of given date ranges and perticular 
	transation type where 
	--  TxType 1 = Sales, TxType 3 = BuyIn, TxType 6 = Refunds

*/
SELECT orders.order_id, 
	orders.order_date, 
	orders.Order_Type, 
	orders.processed, 
	orders.BranchKey, 
	order_details.box_id, 
	order_details.price, 
	order_details.quantity, 
	order_details.TxType, 
	boxes.box_category, 
	category.category_id 
INTO #orderLine1
FROM epos2000.dbo.boxes boxes, 
	epos2000.dbo.category category, 
	epos2000.dbo.order_details order_details, 
	epos2000.dbo.orders orders
WHERE boxes.box_id = order_details.box_id 
	AND order_details.BranchKey = orders.BranchKey 
	AND order_details.order_id = orders.order_id 
	AND boxes.box_category = category.box_category 
	AND (orders.order_date>=@fromDate) 
	AND (orders.order_date<= @toDate) 
	AND (orders.BranchKey = @BrKey) 
	AND (orders.processed = 1) 
	AND (order_details.txtype IN (1,3,6) )
ORDER BY orders.order_id , order_details.box_id	

-- SELECT * INTO #orderLine1 FROM Orderline1 Order by Order_id, box_id 
/* 
-- removed from above == AND (order_details.TxType=1) 
*/
COMMIT TRAN P1

SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 
/*
	Query Retrive All Payment Lines of Particular Day in Temporary Table Called '#PaymentLine'
	Description
*/
BEGIN Tran P2
SELECT orders.order_id, 
	orders.order_date, 
	orders.Order_Type, 
	orders.processed, 
	orders.branch_id, 
	orders.BranchKey, 
	OrderPaymentElements.PaymentMethodID, 
	OrderPaymentElements.ClearingAmount
INTO #PaymentLine1
FROM epos2000.dbo.OrderPaymentElements OrderPaymentElements, 
	epos2000.dbo.orders orders 
WHERE orders.order_id = OrderPaymentElements.orderid 
	AND (orders.order_date>=@fromDate) 
	AND (orders.order_date <= @Todate) 
	AND (orders.BranchKey = @BrKey) 
	AND (orders.processed = 1) 
ORDER BY orders.order_id,OrderPaymentElements.PaymentMethodID
------------------ Modified.

-- SELECT * INTO #PaymentLine1 From Paymentline1 
-- Order by order_id, PaymentMethodId

COMMIT TRAN P2

/* Trap Errors */
SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 
	
/* 
-- declare the cursor for Orders
*/
DECLARE order1 CURSOR FOR
	SELECT order_id, box_id,category_id,quantity,price,txtype 
		FROM #orderLine1
	ORDER BY Order_id, Box_id
	

/* 
-- Find Total Number of Records to Evaluate
 */
SELECT @TotalRec = Count(*) FROM #orderLine1

SELECT "Total Records " = Convert(varchar(20),@TotalRec)


SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 

/*
-- Set First Record is already  Opened
*/

SELECT @OrderLoopCount = 1 
/* 
-- add One more for last record must go in while loop.
*/
SELECT @OrderRecCount = @TotalRec + 1 

-- Open a cursor and fetch all the records
-- by default when you open a cursor first record fetched automatically

OPEN order1

SELECT @errNum = @@ERROR IF @errNum <> 0 GOTO Failed 
/* 
-- start the main processing loop.
*/
FETCH order1 INTO @order_id, 		
	@box_id, @category_id, @qty, @price,@txtype

--- Do we have any records from order details if yes then go to loop	
IF @OrderRecCount > 0 
BEGIN
	-- Loop through all records
	WHILE @OrderLoopCount <> @OrderRecCount
	BEGIN
		-- Select @tti = 'Order Loop Count = ' + convert(varchar(20),@OrderLoopCount)
		-- PRINT @TTI
		IF @category_id <> 12 
		BEGIN
			/*
			-- This is where you perform your detailed row-by-row  processing.
			*/
			SELECT @Contribution = 0
			SELECT @OrderValue = 0
			SELECT @OrderBuyIn = 0
			SELECT @OrderSales = 0
			SELECT @CashIn = 0

			SELECT @CashOut = 0  	
			SELECT @TI = 0
			
			-- This added later when we found serious bug in liverpool street
			SELECT @ClearingAmt = 0
			
			-- Debuging purpose
			-- select @tti = Convert(varchar(20),@OrderLoopCount)
			

			SELECT @SpecialCase  = 0 
			
			/*
			** For Every Order We need to Get No of Rows of 
			** its payment Lines
			*/
			
			SELECT @PaymentRows = Count(*) FROM #PaymentLine1 WHERE order_id = @order_id
			-- select @tti = 'No of payment Rows ' + CONVERT(VarChar(50), @PaymentRows)
			-- Print @tti
			
			--  Total of Order Sales
			SELECT @OrderSales = Sum(Price) from #orderLine1 
				WHERE order_id =@order_id and txtype = 1 AND category_id <> 12 
			
			/* -- Total of Order BuyIN */
			SELECT @OrderBuyIn = Sum(price) from #orderLine1
				WHERE order_id = @order_id AND category_id <> 12 AND txType In (3,6)
			
			IF @OrderSales IS NULL
			BEGIN
				SELECT @OrderSales = 0
			END
			
			IF @OrderBuyIN IS NULL
			BEGIN
				SELECT @OrderBuyIn = 0
			END


			IF @OrderSales =  0 	
			BEGIN
			 /* -- HERE @OrderBuyIn always in minus so to prevent negative effect further. */
				SELECT @OrderValue = @OrderSales + @OrderBuyIn 
			END
			ELSE
			BEGIN
				IF @OrderBuyIn = 0 
				BEGIN
					SELECT @OrderValue = @OrderSales - @OrderBuyIn 
				END 		
				ELSE
				BEGIN
					/* -- here Special Case TO Consider */
					SELECT @PositiveBuyIn = 0 - @OrderBuyIn
					IF @PositiveBuyIn > @OrderSales
					BEGIN
						/* -- Buy and Sales both in order but Buy In is Greater  BUY IN has always first Priority. */
						SELECT @OrderValue = 0 - @OrderBuyIn
						SELECT @SpecialCase = 1
					END
					IF @PositiveBuyIn < @OrderSales
					BEGIN
						/* -- Buy and Sales both but Sales Value greater  */
						SELECT @OrderValue = @OrderSales
						SELECT @SpecialCase = 2 
					END
				END 
			END
			
			IF @PaymentRows > 0 AND @OrderValue <> 0 
			BEGIN
				SELECT @tmpCount = 0
				/* first check Category in tmpStinc Table  if not exist then add it */
				IF NOT EXISTS ( SELECT CATEGORY_ID FROM tempdb.dbo.tmpSTINC 
					WHERE  category_id = @category_id AND weekStartDate = @FromDate)
				BEGIN
					BEGIN TRAN STI1 			
						INSERT INTO tempdb.dbo.tmpSTINC 
						(Branchkey,category_id,weekStartDate,WeekEndDate,cashIn,cashOut,TI,SUCCESS,weekNum,LastUpdate) 
						VALUES(@brkey,@category_id,@fromDate,@ToDate,0,0,0,1,@WeekNumber, @performDate)
					COMMIT TRAN STI1
				END 

				SELECT @ti = ti
					FROM tempdb.dbo.tmpStinc WHERE category_id = @category_id AND WeekStartDate = @FromDate
				
				-- This is for testing rpl 07102009
				-- IF @category_id = 885 
				-- BEGIN 
				--	SELECT 'Category 885 Ti At One ' = Convert(varchar(20), @ti) , 'Order Id ' = Convert(varchar(20),@order_id)
				-- END 
				-- £££££££££££££££££ Please Remove above lines later rpl 07102009
				/*
					PaymentID  1 =  Cash (IN)
					PaymentID 2 = Card (IN)
					PaymentID 4 = Cheque  (IN)
					PaymentID 8 = Cash Out (Out) 
					PaymentID 10 = Card Refund  (Out)
				*/
				/* PaymentMethodID  = 1*/
				/* Calculate Total Income and update to tmpStinc table*/
				SELECT @PayOrder_id = Order_id, @PaymentId = paymentMethodId, @ClearingAmt = ClearingAmount 
					from #PaymentLine1 where order_id = @order_id and paymentMethodID = 1
				IF @PaymentId IS NULL
				BEGIN
					SELECT @PaymentID = 0
				END 
				
				IF (@PaymentId = 1)
				BEGIN
					SELECT @contribution = ((@ClearingAmt) * (@Price)) / (@OrderValue)
					/* -- CASH IN */
					IF (@PaymentId = 1)  OR (@PaymentId = 2) OR (@PaymentId = 4) 
					BEGIN 
						/* -- Sales  */
						IF @txtype = 1 
						BEGIN
							IF @SpecialCase = 0 
							BEGIN
								SELECT @ti = @ti + @contribution
								-- Debuging purpose
								-- select @tti = 'Payment Id 1,2,4 and Cash In tx Type is 1- Sales and Special case Normal Total Income = ' + Convert(varchar(20),@ti)
								-----
								SELECT @CashIn = @Contribution
							END 
							IF @SpecialCase = 1 /* -- Buy In */
							BEGIN
								/*
								--  For Sales Contribution Which is Cash, Card or Cheque is ignored
								In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
								and Must Ignored in txType 3.
								*/
								SELECT @TI =  @ti + @Contribution 
									-- Debuging purpose
									-- select @tti = 'Payment Id 1,2,4 and Cash In Tx Type is 1 - Sales nd Speical Case Buy In Total Income = ' + Convert(varchar(20),@ti)
								SELECT @CashIn = 0
							END
							IF @SpecialCase = 2 /* -- Sales  */
							BEGIN
								SELECT @TI = @TI + @Contribution 
									-- Debuging purpose
									-- select @tti = 'Payment Id 1,2,4 and Case In Tx Type is 1 - Sales and Special Case is 2 Sales total Income = ' + Convert(varchar(20),@ti)
									-- PRINT  @tti
									-----
								SELECT @CashIn = @Contribution
								END
							END
							/* -- BuyIn & Refunds */ 
							IF @txtype = 3 OR @txType = 6 
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @TI = @TI + @Contribution 
									-- Debuging purpose
									-- select @tti = 'Payment Id 1,2,4 and Case In txType 3 or 6 and Speical Case is 0 Normal total Income =  ' + Convert(varchar(20),@ti)
									SELECT @CashIn = @Contribution
								END
								IF @SpecialCase = 1 /* -- BuyIN  */
								BEGIN
									/*
									In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
									and Must Ignored in txType 3.
									*/
									SELECT @ti = @ti + 0
									-- Debuging purpose
									-- select @tti = 'Payment Id 1,2,4 and Case In Txtype 3 or 6 and special Case is 1 Buy In Total Income =' + Convert(varchar(20),@ti)
									SELECT @CashIn = 0
								END
								IF @SpecialCase = 2 /* -- Sales */
								BEGIN
									SELECT @ti = @ti + 0  /* -- Sales is greater so buyIn should be Ignored. */
									-- SELECT @TTI = 'Payment Id 1,2,4 and Case In txtype 3 or 6 and Special Case is 2 Sales Total Income =' + CONVERT(VARCHAR(12),@TI)
									-- SELECT @CashIn = 0
								END 

							END
							
							UPDATE tempdb.dbo.tmpSTINC
							SET 
							ti = @ti , 
							LastUpdate = GetDate() 
							WHERE category_id = @category_id AND weekStartDate = @FromDate

							SELECT @CashOut = 0
						END 	
					END
					
					SELECT @PayOrder_id = Order_id, @PaymentId = paymentMethodId, @ClearingAmt = ClearingAmount 
						from #PaymentLine1 where order_id = @order_id and paymentMethodID = 2
					IF @PaymentId IS NULL
					BEGIN
						SELECT @PaymentID = 0
					END 

					IF (@PaymentId = 2)
					BEGIN
						SELECT @contribution = ((@ClearingAmt) * (@Price)) / (@OrderValue)
						/* -- CASH IN */
						IF (@PaymentId = 1)  OR (@PaymentId = 2) OR (@PaymentId = 4) 
						BEGIN 
							/* -- Sales  */
							IF @txtype = 1 
							BEGIN
								IF @SpecialCase = 0 
								BEGIN
									SELECT @ti = @ti + @contribution
									SELECT @CashIn = @Contribution
								END 
								IF @SpecialCase = 1 /* -- Buy In */
								BEGIN
								/*
								--  For Sales Contribution Which is Cash, Card or Cheque is ignored
								In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
								and Must Ignored in txType 3.
								*/
									SELECT @TI =  @ti + @Contribution 
									SELECT @CashIn = 0
								END
								IF @SpecialCase = 2 /* -- Sales  */
								BEGIN
									SELECT @TI = @TI + @Contribution 
									SELECT @CashIn = @Contribution
								END
							END

							/* -- BuyIn & Refunds */ 
							IF @txtype = 3 OR @txType = 6 
							BEGIN
								IF @SpecialCase = 0
								BEGIN

									SELECT @TI = @TI + @Contribution 
									SELECT @CashIn = @Contribution
								END
								IF @SpecialCase = 1 /* -- BuyIN  */
								BEGIN
									/*
									In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
									and Must Ignored in txType 3.
									*/
									SELECT @ti = @ti + 0
									SELECT @CashIn = 0
								END
								IF @SpecialCase = 2 /* -- Sales */
								BEGIN
									SELECT @ti = @ti + 0  /* -- Sales is greater so buyIn should be Ignored. */
								END 
							END
							
							UPDATE tempdb.dbo.tmpSTINC
							SET 
							ti = @ti , 
							LastUpdate = GetDate() 
							WHERE category_id = @category_id AND weekStartDate = @FromDate

							SELECT @CashOut = 0
						END 	
						
					END	
							
					SELECT @PayOrder_id = Order_id, @PaymentId = paymentMethodId, @ClearingAmt = ClearingAmount 
						from #PaymentLine1 where order_id = @order_id and paymentMethodID = 4
					IF @PaymentId IS NULL
					BEGIN
						SELECT @PaymentID = 0
					END 

					IF (@PaymentId = 4)
					BEGIN
						SELECT @contribution = ((@ClearingAmt) * (@Price)) / (@OrderValue)
						/* -- CASH IN */
						IF (@PaymentId = 1)  OR (@PaymentId = 2) OR (@PaymentId = 4) 
						BEGIN 
							/* -- Sales  */
							IF @txtype = 1 
							BEGIN
								IF @SpecialCase = 0 
								BEGIN
									SELECT @ti = @ti + @contribution
									SELECT @CashIn = @Contribution
								END 
								IF @SpecialCase = 1 /* -- Buy In */
								BEGIN
								/*
								--  For Sales Contribution Which is Cash, Card or Cheque is ignored
								In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
								and Must Ignored in txType 3.
								*/
									SELECT @TI =  @ti + @Contribution 
									SELECT @CashIn = 0
								END
								IF @SpecialCase = 2 /* -- Sales  */
								BEGIN
									SELECT @TI = @TI + @Contribution 
									SELECT @CashIn = @Contribution
								END
							END
							/* -- BuyIn & Refunds */ 
							IF @txtype = 3 OR @txType = 6 
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @TI = @TI + @Contribution 
									SELECT @CashIn = @Contribution
								END
								IF @SpecialCase = 1 /* -- BuyIN  */
								BEGIN
									/*
									In any Special Cases Cash Received In any term (Cash, Card, Cheque) Must categoried In txType 1 Only.
									and Must Ignored in txType 3.
									*/
									SELECT @ti = @ti + 0
									SELECT @CashIn = 0
								END
								IF @SpecialCase = 2 /* -- Sales */
								BEGIN
									SELECT @ti = @ti + 0  /* -- Sales is greater so buyIn should be Ignored. */
								END 
							END
							
							UPDATE tempdb.dbo.tmpSTINC
							SET 
							ti = @ti , 
							LastUpdate = GetDate() 
							WHERE category_id = @category_id AND weekStartDate = @FromDate
							SELECT @CashOut = 0
						END 	
					END	
					
                    SELECT @PayOrder_id = Order_id, @PaymentId = paymentMethodId, @ClearingAmt = ClearingAmount 
						from #PaymentLine1 where order_id = @order_id and paymentMethodID = 8
					
					
					IF @PaymentId IS NULL
					BEGIN
						SELECT @PaymentId = 0
					END 

					IF (@PaymentId = 8) 
					BEGIN
						SELECT @contribution = ((@ClearingAmt) * (@Price)) / (@OrderValue)
						
						/* -- CASH OUT */ 
						IF (@PaymentId = 8) Or (@PaymentId = 10) 
						BEGIN
							IF @contribution > 0
							BEGIN
								SELECT @Contribution = 0 - @Contribution
							END

							IF @txType = 1
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @ti = @ti + @Contribution
									SELECT @CashOut = @Contribution
								END
								IF @SpecialCase = 1
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti +  0 /* -- Buy iN Ignored */
									SELECT @CashOut = 0
								END
								IF @SpecialCase = 2
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Or 6 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @tI = @Ti + 0 
									SELECT @CashOut = @Contribution
								END
							END
							
							IF @txType = 3 OR @TxType = 6 
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @ti = @ti + @Contribution 
									SELECT @CashOut = @Contribution
								END
								
								
								IF @SpecialCase = 1
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Or 6 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti + @Contribution /* -- Buy iN Consider */
									SELECT @CashOut = @Contribution
									
								END
								
								
								
								IF @SpecialCase = 2
								BEGIN
									/*
										In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Only.
										and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti + @Contribution 
									SELECT @CashOut = @Contribution

								END
							
							END
							UPDATE tempdb.dbo.tmpSTINC
							SET ti = @ti,
								LastUpdate = GetDate()
								WHERE category_id = @category_id AND weekStartDate = @FromDate
							
							SELECT @CashIn = 0

						END
					END

					SELECT @PayOrder_id = Order_id, @PaymentId = paymentMethodId, @ClearingAmt = ClearingAmount 
						from #PaymentLine1 where order_id = @order_id and paymentMethodID = 10
					IF @PaymentId IS NULL
					BEGIN
						SELECT @PaymentID = 0
					END 
								
					IF (@PaymentId = 10)
					BEGIN
						SELECT @contribution = ((@ClearingAmt) * (@Price)) / (@OrderValue)
						/* -- CASH OUT */ 
						IF (@PaymentId = 8) Or (@PaymentId = 10) 
						BEGIN
							IF @contribution > 0
							BEGIN
								SELECT @Contribution = 0 - @Contribution
							END
							IF @txType = 1
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @ti = @ti + @Contribution
									SELECT @CashOut = @Contribution
								END
								IF @SpecialCase = 1
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti +  0 /* -- Buy iN Ignored */
									SELECT @CashOut = 0
								END
								IF @SpecialCase = 2
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Or 6 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @tI = @Ti + 0 
									SELECT @CashOut = @Contribution
								END
							END
							IF @txType = 3 OR @TxType = 6 
							BEGIN
								IF @SpecialCase = 0
								BEGIN
									SELECT @ti = @ti + @Contribution 
									-- SELECT @TTI = 'payment ID 8 or 10 (Cash Out) and txtype 3 OR 6 ,speical case 0 total Income = '  + convert(varchar(12),@ti)
									-- PRINT @TTI
									SELECT @CashOut = @Contribution
								END
								IF @SpecialCase = 1
								BEGIN
									/*
									In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Or 6 Only.
									and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti + @Contribution /* -- Buy iN Consider */
									SELECT @CashOut = @Contribution
								END
								IF @SpecialCase = 2
								BEGIN
									/*
										In any Special Cases Cash Paid In any term (Cash, Card, Cheque) Must categoried In txType 3 Only.
										and Must Ignored in txType 1.
									*/
									SELECT @ti = @ti + @Contribution 
									SELECT @CashOut = @Contribution
								END
							END
							UPDATE tempdb.dbo.tmpSTINC
							SET ti = @ti,
								LastUpdate = GetDate()
								WHERE category_id = @category_id AND weekStartDate = @FromDate
								
							SELECT @CashIn = 0
						END
					END
				END   
			----- category Id is not 12
		END
		/* 
		 -- Here we Prevent EOF for Records 
		*/
		IF @TotalRec >= (@OrderRecCount - 1)
		BEGIN
			FETCH NEXT FROM order1 INTO @order_id, 		
				@box_id, @category_id, @qty, @price,@txtype
				/*
				-- Increment loop Count	
				*/
			SELECT @OrderLoopCount =  @OrderLoopCount + 1
		END
	END 
END 


CLOSE order1

UPDATE tempdb.dbo.tmpSTINC 
	SET SUCCESS = 1
WHERE weekStartDate = @FromDate
	

DEALLOCATE order1


DROP TABLE #orderLine1
DROP TABLE #PaymentLine1

INSERT INTO epos2000.dbo.STINC 
 (Branchkey,category_id,weekStartDate,WeekEndDate,cashIn,cashOut,TI,SUCCESS,weekNum,LastUpdate)

 (SELECT BRANCHKEY, category_id, weekStartDate, WeekEndDate, CashIN, CashOut, TI,Success, WeekNum, LastUpdate
	from tempdb.dbo.tmpSTinc)

SELECT GETDATE()

SELECT @errNum = @@error IF @errNum = 0 GOTO Successed

Failed:
    BEGIN
		PRINT 'weekly Income Failed'
    END 

IF @errNum <> 0 GOTO finish  	

Successed:
 BEGIN
	PRINT 'SUCCESSFULLY DONE'	
End	
finish:
/****** Object:  Table dbo.tmpStinc    Script Date: 14/04/2008 11:19:11 AM ******/
drop table tempDB.dbo.tmpStinc
CHECKPOINT
RETURN


GO

/********************END OF SCRIPT TO CREATE STORED PROCEDURES****************************************/

/**********************SCRIPT TO GRANT OBJECT LEVEL PERMISSION TO USERS******************************/

--Boffice

GRANT DELETE ON [dbo].[Attribute] TO [boffice]
GO
GRANT INSERT ON [dbo].[Attribute] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Attribute] TO [boffice]
GO
GRANT SELECT ON [dbo].[Attribute] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Attribute] TO [boffice]
GO
GRANT DELETE ON [dbo].[AttributeStructure] TO [boffice]
GO
GRANT INSERT ON [dbo].[AttributeStructure] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[AttributeStructure] TO [boffice]
GO
GRANT SELECT ON [dbo].[AttributeStructure] TO [boffice]
GO
GRANT UPDATE ON [dbo].[AttributeStructure] TO [boffice]
GO
GRANT DELETE ON [dbo].[AttributeStructureCategory] TO [boffice]
GO
GRANT INSERT ON [dbo].[AttributeStructureCategory] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[AttributeStructureCategory] TO [boffice]
GO
GRANT SELECT ON [dbo].[AttributeStructureCategory] TO [boffice]
GO
GRANT UPDATE ON [dbo].[AttributeStructureCategory] TO [boffice]
GO
GRANT DELETE ON [dbo].[AuditEntryTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[AuditEntryTypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[AuditEntryTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[AuditEntryTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[AuditEntryTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[AUditTrail] TO [boffice]
GO
GRANT INSERT ON [dbo].[AUditTrail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[AUditTrail] TO [boffice]
GO
GRANT SELECT ON [dbo].[AUditTrail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[AUditTrail] TO [boffice]
GO
GRANT DELETE ON [dbo].[banking] TO [boffice]
GO
GRANT INSERT ON [dbo].[banking] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[banking] TO [boffice]
GO
GRANT SELECT ON [dbo].[banking] TO [boffice]
GO
GRANT UPDATE ON [dbo].[banking] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_Branches] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_Branches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_Branches] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_Branches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Banking_Branches] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_Data] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_Data] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_Data] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_Data] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Banking_Data] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_LineComment] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_LineComment] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_LineComment] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_LineComment] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Banking_LineComment] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_lines] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_lines] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_lines] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_lines] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Banking_lines] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_linetypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_linetypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_linetypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_linetypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[Banking_PDQ] TO [boffice]
GO
GRANT INSERT ON [dbo].[Banking_PDQ] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Banking_PDQ] TO [boffice]
GO
GRANT SELECT ON [dbo].[Banking_PDQ] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Banking_PDQ] TO [boffice]
GO
GRANT DELETE ON [dbo].[BoxAlias] TO [boffice]
GO
GRANT INSERT ON [dbo].[BoxAlias] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxAlias] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxAlias] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BoxAlias] TO [boffice]
GO
GRANT DELETE ON [dbo].[boxes] TO [boffice]
GO
GRANT INSERT ON [dbo].[boxes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[boxes] TO [boffice]
GO
GRANT SELECT ON [dbo].[boxes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[boxes] TO [boffice]
GO
GRANT DELETE ON [dbo].[BoxPrice] TO [boffice]
GO
GRANT INSERT ON [dbo].[BoxPrice] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxPrice] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxPrice] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BoxPrice] TO [boffice]
GO
GRANT DELETE ON [dbo].[BoxPriceChange] TO [boffice]
GO
GRANT INSERT ON [dbo].[BoxPriceChange] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxPriceChange] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxPriceChange] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BoxPriceChange] TO [boffice]
GO
GRANT DELETE ON [dbo].[BoxPriceChangePrinted] TO [boffice]
GO
GRANT INSERT ON [dbo].[BoxPriceChangePrinted] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxPriceChangePrinted] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxPriceChangePrinted] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BoxPriceChangePrinted] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxQuantities] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxQuantities] TO [boffice]
GO
GRANT DELETE ON [dbo].[BoxStock] TO [boffice]
GO
GRANT INSERT ON [dbo].[BoxStock] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BoxStock] TO [boffice]
GO
GRANT SELECT ON [dbo].[BoxStock] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BoxStock] TO [boffice]
GO
GRANT DELETE ON [dbo].[branchCategoryShortKeys] TO [boffice]
GO
GRANT INSERT ON [dbo].[branchCategoryShortKeys] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[branchCategoryShortKeys] TO [boffice]
GO
GRANT SELECT ON [dbo].[branchCategoryShortKeys] TO [boffice]
GO
GRANT UPDATE ON [dbo].[branchCategoryShortKeys] TO [boffice]
GO
GRANT DELETE ON [dbo].[Branches] TO [boffice]
GO
GRANT INSERT ON [dbo].[Branches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Branches] TO [boffice]
GO
GRANT SELECT ON [dbo].[Branches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Branches] TO [boffice]
GO
GRANT DELETE ON [dbo].[BranchSetting] TO [boffice]
GO
GRANT INSERT ON [dbo].[BranchSetting] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[BranchSetting] TO [boffice]
GO
GRANT SELECT ON [dbo].[BranchSetting] TO [boffice]
GO
GRANT UPDATE ON [dbo].[BranchSetting] TO [boffice]
GO
GRANT DELETE ON [dbo].[CapacityModifier] TO [boffice]
GO
GRANT INSERT ON [dbo].[CapacityModifier] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CapacityModifier] TO [boffice]
GO
GRANT SELECT ON [dbo].[CapacityModifier] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CapacityModifier] TO [boffice]
GO
GRANT DELETE ON [dbo].[CardDetails] TO [boffice]
GO
GRANT INSERT ON [dbo].[CardDetails] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CardDetails] TO [boffice]
GO
GRANT SELECT ON [dbo].[CardDetails] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CardDetails] TO [boffice]
GO
GRANT DELETE ON [dbo].[category] TO [boffice]
GO
GRANT INSERT ON [dbo].[category] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[category] TO [boffice]
GO
GRANT SELECT ON [dbo].[category] TO [boffice]
GO
GRANT UPDATE ON [dbo].[category] TO [boffice]
GO
GRANT DELETE ON [dbo].[CategoryDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[CategoryDetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CategoryDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[CategoryDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CategoryDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[CategoryModifiers] TO [boffice]
GO
GRANT INSERT ON [dbo].[CategoryModifiers] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CategoryModifiers] TO [boffice]
GO
GRANT SELECT ON [dbo].[CategoryModifiers] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CategoryModifiers] TO [boffice]
GO
GRANT DELETE ON [dbo].[Charity] TO [boffice]
GO
GRANT INSERT ON [dbo].[Charity] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Charity] TO [boffice]
GO
GRANT SELECT ON [dbo].[Charity] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Charity] TO [boffice]
GO
GRANT DELETE ON [dbo].[CheckList] TO [boffice]
GO
GRANT INSERT ON [dbo].[CheckList] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CheckList] TO [boffice]
GO
GRANT SELECT ON [dbo].[CheckList] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CheckList] TO [boffice]
GO
GRANT DELETE ON [dbo].[CheckListDetails] TO [boffice]
GO
GRANT INSERT ON [dbo].[CheckListDetails] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CheckListDetails] TO [boffice]
GO
GRANT SELECT ON [dbo].[CheckListDetails] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CheckListDetails] TO [boffice]
GO
GRANT DELETE ON [dbo].[CheckListItems] TO [boffice]
GO
GRANT INSERT ON [dbo].[CheckListItems] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CheckListItems] TO [boffice]
GO
GRANT SELECT ON [dbo].[CheckListItems] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CheckListItems] TO [boffice]
GO
GRANT DELETE ON [dbo].[cheques] TO [boffice]
GO
GRANT INSERT ON [dbo].[cheques] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[cheques] TO [boffice]
GO
GRANT SELECT ON [dbo].[cheques] TO [boffice]
GO
GRANT UPDATE ON [dbo].[cheques] TO [boffice]
GO
GRANT DELETE ON [dbo].[ClauseLines] TO [boffice]
GO
GRANT INSERT ON [dbo].[ClauseLines] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[ClauseLines] TO [boffice]
GO
GRANT SELECT ON [dbo].[ClauseLines] TO [boffice]
GO
GRANT UPDATE ON [dbo].[ClauseLines] TO [boffice]
GO
GRANT DELETE ON [dbo].[Clauses] TO [boffice]
GO
GRANT INSERT ON [dbo].[Clauses] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Clauses] TO [boffice]
GO
GRANT SELECT ON [dbo].[Clauses] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Clauses] TO [boffice]
GO
GRANT DELETE ON [dbo].[Country] TO [boffice]
GO
GRANT INSERT ON [dbo].[Country] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Country] TO [boffice]
GO
GRANT SELECT ON [dbo].[Country] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Country] TO [boffice]
GO
GRANT DELETE ON [dbo].[CountyStates] TO [boffice]
GO
GRANT INSERT ON [dbo].[CountyStates] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CountyStates] TO [boffice]
GO
GRANT SELECT ON [dbo].[CountyStates] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CountyStates] TO [boffice]
GO
GRANT DELETE ON [dbo].[credit_cards] TO [boffice]
GO
GRANT INSERT ON [dbo].[credit_cards] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[credit_cards] TO [boffice]
GO
GRANT SELECT ON [dbo].[credit_cards] TO [boffice]
GO
GRANT UPDATE ON [dbo].[credit_cards] TO [boffice]
GO
GRANT DELETE ON [dbo].[CreditCardTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[CreditCardTypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CreditCardTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[CreditCardTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CreditCardTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[currencies] TO [boffice]
GO
GRANT INSERT ON [dbo].[currencies] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[currencies] TO [boffice]
GO
GRANT SELECT ON [dbo].[currencies] TO [boffice]
GO
GRANT UPDATE ON [dbo].[currencies] TO [boffice]
GO
GRANT DELETE ON [dbo].[CurrencyDenominations] TO [boffice]
GO
GRANT INSERT ON [dbo].[CurrencyDenominations] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CurrencyDenominations] TO [boffice]
GO
GRANT SELECT ON [dbo].[CurrencyDenominations] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CurrencyDenominations] TO [boffice]
GO
GRANT DELETE ON [dbo].[Customer] TO [boffice]
GO
GRANT INSERT ON [dbo].[Customer] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Customer] TO [boffice]
GO
GRANT SELECT ON [dbo].[Customer] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Customer] TO [boffice]
GO
GRANT DELETE ON [dbo].[CustomerCard] TO [boffice]
GO
GRANT INSERT ON [dbo].[CustomerCard] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CustomerCard] TO [boffice]
GO
GRANT SELECT ON [dbo].[CustomerCard] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CustomerCard] TO [boffice]
GO
GRANT DELETE ON [dbo].[CustomerIDMod] TO [boffice]
GO
GRANT INSERT ON [dbo].[CustomerIDMod] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CustomerIDMod] TO [boffice]
GO
GRANT SELECT ON [dbo].[CustomerIDMod] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CustomerIDMod] TO [boffice]
GO
GRANT DELETE ON [dbo].[CustomerIDType] TO [boffice]
GO
GRANT INSERT ON [dbo].[CustomerIDType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[CustomerIDType] TO [boffice]
GO
GRANT SELECT ON [dbo].[CustomerIDType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[CustomerIDType] TO [boffice]
GO
GRANT DELETE ON [dbo].[DBQueue] TO [boffice]
GO
GRANT INSERT ON [dbo].[DBQueue] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[DBQueue] TO [boffice]
GO
GRANT SELECT ON [dbo].[DBQueue] TO [boffice]
GO
GRANT UPDATE ON [dbo].[DBQueue] TO [boffice]
GO
GRANT DELETE ON [dbo].[DBQueueDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[DBQueueDetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[DBQueueDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[DBQueueDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[DBQueueDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[DBQueueType] TO [boffice]
GO
GRANT INSERT ON [dbo].[DBQueueType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[DBQueueType] TO [boffice]
GO
GRANT SELECT ON [dbo].[DBQueueType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[DBQueueType] TO [boffice]
GO
GRANT DELETE ON [dbo].[Elasticity] TO [boffice]
GO
GRANT INSERT ON [dbo].[Elasticity] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Elasticity] TO [boffice]
GO
GRANT SELECT ON [dbo].[Elasticity] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Elasticity] TO [boffice]
GO
GRANT DELETE ON [dbo].[Errors] TO [boffice]
GO
GRANT INSERT ON [dbo].[Errors] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Errors] TO [boffice]
GO
GRANT SELECT ON [dbo].[Errors] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Errors] TO [boffice]
GO
GRANT DELETE ON [dbo].[FloorLimits] TO [boffice]
GO
GRANT INSERT ON [dbo].[FloorLimits] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[FloorLimits] TO [boffice]
GO
GRANT SELECT ON [dbo].[FloorLimits] TO [boffice]
GO
GRANT UPDATE ON [dbo].[FloorLimits] TO [boffice]
GO
GRANT DELETE ON [dbo].[hear] TO [boffice]
GO
GRANT INSERT ON [dbo].[hear] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[hear] TO [boffice]
GO
GRANT SELECT ON [dbo].[hear] TO [boffice]
GO
GRANT UPDATE ON [dbo].[hear] TO [boffice]
GO
GRANT DELETE ON [dbo].[Holding_BranchPrices] TO [boffice]
GO
GRANT INSERT ON [dbo].[Holding_BranchPrices] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Holding_BranchPrices] TO [boffice]
GO
GRANT SELECT ON [dbo].[Holding_BranchPrices] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Holding_BranchPrices] TO [boffice]
GO
GRANT DELETE ON [dbo].[InternalOrders] TO [boffice]
GO
GRANT INSERT ON [dbo].[InternalOrders] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[InternalOrders] TO [boffice]
GO
GRANT SELECT ON [dbo].[InternalOrders] TO [boffice]
GO
GRANT UPDATE ON [dbo].[InternalOrders] TO [boffice]
GO
GRANT DELETE ON [dbo].[LabelPrinterType] TO [boffice]
GO
GRANT INSERT ON [dbo].[LabelPrinterType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[LabelPrinterType] TO [boffice]
GO
GRANT SELECT ON [dbo].[LabelPrinterType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[LabelPrinterType] TO [boffice]
GO
GRANT DELETE ON [dbo].[LocationBranches] TO [boffice]
GO
GRANT INSERT ON [dbo].[LocationBranches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[LocationBranches] TO [boffice]
GO
GRANT SELECT ON [dbo].[LocationBranches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[LocationBranches] TO [boffice]
GO
GRANT DELETE ON [dbo].[locations] TO [boffice]
GO
GRANT INSERT ON [dbo].[locations] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[locations] TO [boffice]
GO
GRANT SELECT ON [dbo].[locations] TO [boffice]
GO
GRANT UPDATE ON [dbo].[locations] TO [boffice]
GO
GRANT DELETE ON [dbo].[LocationTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[LocationTypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[LocationTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[LocationTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[LocationTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[Lock] TO [boffice]
GO
GRANT INSERT ON [dbo].[Lock] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Lock] TO [boffice]
GO
GRANT SELECT ON [dbo].[Lock] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Lock] TO [boffice]
GO
GRANT DELETE ON [dbo].[login_info] TO [boffice]
GO
GRANT INSERT ON [dbo].[login_info] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[login_info] TO [boffice]
GO
GRANT SELECT ON [dbo].[login_info] TO [boffice]
GO
GRANT UPDATE ON [dbo].[login_info] TO [boffice]
GO
GRANT DELETE ON [dbo].[ManProducts] TO [boffice]
GO
GRANT INSERT ON [dbo].[ManProducts] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[ManProducts] TO [boffice]
GO
GRANT SELECT ON [dbo].[ManProducts] TO [boffice]
GO
GRANT UPDATE ON [dbo].[ManProducts] TO [boffice]
GO
GRANT DELETE ON [dbo].[Manufacturers] TO [boffice]
GO
GRANT INSERT ON [dbo].[Manufacturers] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Manufacturers] TO [boffice]
GO
GRANT SELECT ON [dbo].[Manufacturers] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Manufacturers] TO [boffice]
GO
GRANT DELETE ON [dbo].[MobilePhone] TO [boffice]
GO
GRANT INSERT ON [dbo].[MobilePhone] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[MobilePhone] TO [boffice]
GO
GRANT SELECT ON [dbo].[MobilePhone] TO [boffice]
GO
GRANT UPDATE ON [dbo].[MobilePhone] TO [boffice]
GO
GRANT DELETE ON [dbo].[MobilePhoneNetwork] TO [boffice]
GO
GRANT INSERT ON [dbo].[MobilePhoneNetwork] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[MobilePhoneNetwork] TO [boffice]
GO
GRANT SELECT ON [dbo].[MobilePhoneNetwork] TO [boffice]
GO
GRANT UPDATE ON [dbo].[MobilePhoneNetwork] TO [boffice]
GO
GRANT DELETE ON [dbo].[numbers] TO [boffice]
GO
GRANT INSERT ON [dbo].[numbers] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[numbers] TO [boffice]
GO
GRANT SELECT ON [dbo].[numbers] TO [boffice]
GO
GRANT UPDATE ON [dbo].[numbers] TO [boffice]
GO
GRANT DELETE ON [dbo].[OperatingCompany] TO [boffice]
GO
GRANT INSERT ON [dbo].[OperatingCompany] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OperatingCompany] TO [boffice]
GO
GRANT SELECT ON [dbo].[OperatingCompany] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OperatingCompany] TO [boffice]
GO
GRANT DELETE ON [dbo].[order_details] TO [boffice]
GO
GRANT INSERT ON [dbo].[order_details] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[order_details] TO [boffice]
GO
GRANT SELECT ON [dbo].[order_details] TO [boffice]
GO
GRANT UPDATE ON [dbo].[order_details] TO [boffice]
GO
GRANT DELETE ON [dbo].[order_notes] TO [boffice]
GO
GRANT INSERT ON [dbo].[order_notes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[order_notes] TO [boffice]
GO
GRANT SELECT ON [dbo].[order_notes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[order_notes] TO [boffice]
GO
GRANT DELETE ON [dbo].[OrderCharityElement] TO [boffice]
GO
GRANT INSERT ON [dbo].[OrderCharityElement] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderCharityElement] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderCharityElement] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OrderCharityElement] TO [boffice]
GO
GRANT DELETE ON [dbo].[OrderDetailCategories] TO [boffice]
GO
GRANT INSERT ON [dbo].[OrderDetailCategories] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderDetailCategories] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderDetailCategories] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OrderDetailCategories] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifier] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifier] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifierType] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifierType] TO [boffice]
GO
GRANT DELETE ON [dbo].[OrderPaymentElements] TO [boffice]
GO
GRANT INSERT ON [dbo].[OrderPaymentElements] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderPaymentElements] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderPaymentElements] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OrderPaymentElements] TO [boffice]
GO
GRANT DELETE ON [dbo].[OrderPaymentTaxRate] TO [boffice]
GO
GRANT INSERT ON [dbo].[OrderPaymentTaxRate] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderPaymentTaxRate] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderPaymentTaxRate] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OrderPaymentTaxRate] TO [boffice]
GO
GRANT DELETE ON [dbo].[orders] TO [boffice]
GO
GRANT INSERT ON [dbo].[orders] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[orders] TO [boffice]
GO
GRANT SELECT ON [dbo].[orders] TO [boffice]
GO
GRANT UPDATE ON [dbo].[orders] TO [boffice]
GO
GRANT DELETE ON [dbo].[OrderTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[OrderTypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[OrderTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[Origins] TO [boffice]
GO
GRANT INSERT ON [dbo].[Origins] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Origins] TO [boffice]
GO
GRANT SELECT ON [dbo].[Origins] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Origins] TO [boffice]
GO
GRANT DELETE ON [dbo].[PaymentGroup] TO [boffice]
GO
GRANT INSERT ON [dbo].[PaymentGroup] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PaymentGroup] TO [boffice]
GO
GRANT SELECT ON [dbo].[PaymentGroup] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PaymentGroup] TO [boffice]
GO
GRANT DELETE ON [dbo].[PaymentMethods] TO [boffice]
GO
GRANT INSERT ON [dbo].[PaymentMethods] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PaymentMethods] TO [boffice]
GO
GRANT SELECT ON [dbo].[PaymentMethods] TO [boffice]
GO
GRANT DELETE ON [dbo].[PendingPriceChanges] TO [boffice]
GO
GRANT INSERT ON [dbo].[PendingPriceChanges] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PendingPriceChanges] TO [boffice]
GO
GRANT SELECT ON [dbo].[PendingPriceChanges] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PendingPriceChanges] TO [boffice]
GO
GRANT DELETE ON [dbo].[Permissions] TO [boffice]
GO
GRANT INSERT ON [dbo].[Permissions] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Permissions] TO [boffice]
GO
GRANT SELECT ON [dbo].[Permissions] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Permissions] TO [boffice]
GO
GRANT DELETE ON [dbo].[PODeliveries] TO [boffice]
GO
GRANT INSERT ON [dbo].[PODeliveries] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PODeliveries] TO [boffice]
GO
GRANT SELECT ON [dbo].[PODeliveries] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PODeliveries] TO [boffice]
GO
GRANT DELETE ON [dbo].[PODeliveryDiscrepancies] TO [boffice]
GO
GRANT INSERT ON [dbo].[PODeliveryDiscrepancies] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PODeliveryDiscrepancies] TO [boffice]
GO
GRANT SELECT ON [dbo].[PODeliveryDiscrepancies] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PODeliveryDiscrepancies] TO [boffice]
GO
GRANT DELETE ON [dbo].[ProductLine] TO [boffice]
GO
GRANT INSERT ON [dbo].[ProductLine] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[ProductLine] TO [boffice]
GO
GRANT SELECT ON [dbo].[ProductLine] TO [boffice]
GO
GRANT UPDATE ON [dbo].[ProductLine] TO [boffice]
GO
GRANT DELETE ON [dbo].[ProductlineCat] TO [boffice]
GO
GRANT INSERT ON [dbo].[ProductlineCat] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[ProductlineCat] TO [boffice]
GO
GRANT SELECT ON [dbo].[ProductlineCat] TO [boffice]
GO
GRANT UPDATE ON [dbo].[ProductlineCat] TO [boffice]
GO
GRANT DELETE ON [dbo].[PurchaseOrderDetails] TO [boffice]
GO
GRANT INSERT ON [dbo].[PurchaseOrderDetails] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PurchaseOrderDetails] TO [boffice]
GO
GRANT SELECT ON [dbo].[PurchaseOrderDetails] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PurchaseOrderDetails] TO [boffice]
GO
GRANT DELETE ON [dbo].[PurchaseOrders] TO [boffice]
GO
GRANT INSERT ON [dbo].[PurchaseOrders] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[PurchaseOrders] TO [boffice]
GO
GRANT SELECT ON [dbo].[PurchaseOrders] TO [boffice]
GO
GRANT UPDATE ON [dbo].[PurchaseOrders] TO [boffice]
GO
GRANT DELETE ON [dbo].[Reasons] TO [boffice]
GO
GRANT INSERT ON [dbo].[Reasons] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Reasons] TO [boffice]
GO
GRANT SELECT ON [dbo].[Reasons] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Reasons] TO [boffice]
GO
GRANT DELETE ON [dbo].[ReasonType] TO [boffice]
GO
GRANT INSERT ON [dbo].[ReasonType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[ReasonType] TO [boffice]
GO
GRANT SELECT ON [dbo].[ReasonType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[ReasonType] TO [boffice]
GO
GRANT DELETE ON [dbo].[RefundDetails] TO [boffice]
GO
GRANT INSERT ON [dbo].[RefundDetails] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RefundDetails] TO [boffice]
GO
GRANT SELECT ON [dbo].[RefundDetails] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RefundDetails] TO [boffice]
GO
GRANT DELETE ON [dbo].[RefundReason] TO [boffice]
GO
GRANT INSERT ON [dbo].[RefundReason] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RefundReason] TO [boffice]
GO
GRANT SELECT ON [dbo].[RefundReason] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RefundReason] TO [boffice]
GO
GRANT DELETE ON [dbo].[Refunds] TO [boffice]
GO
GRANT INSERT ON [dbo].[Refunds] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Refunds] TO [boffice]
GO
GRANT SELECT ON [dbo].[Refunds] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Refunds] TO [boffice]
GO
GRANT DELETE ON [dbo].[reserves] TO [boffice]
GO
GRANT INSERT ON [dbo].[reserves] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[reserves] TO [boffice]
GO
GRANT SELECT ON [dbo].[reserves] TO [boffice]
GO
GRANT UPDATE ON [dbo].[reserves] TO [boffice]
GO
GRANT DELETE ON [dbo].[RMABranches] TO [boffice]
GO
GRANT INSERT ON [dbo].[RMABranches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RMABranches] TO [boffice]
GO
GRANT SELECT ON [dbo].[RMABranches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RMABranches] TO [boffice]
GO
GRANT DELETE ON [dbo].[RMAReason] TO [boffice]
GO
GRANT INSERT ON [dbo].[RMAReason] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RMAReason] TO [boffice]
GO
GRANT SELECT ON [dbo].[RMAReason] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RMAReason] TO [boffice]
GO
GRANT DELETE ON [dbo].[RMAReasonCode] TO [boffice]
GO
GRANT INSERT ON [dbo].[RMAReasonCode] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RMAReasonCode] TO [boffice]
GO
GRANT SELECT ON [dbo].[RMAReasonCode] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RMAReasonCode] TO [boffice]
GO
GRANT DELETE ON [dbo].[RMAStoresBranches] TO [boffice]
GO
GRANT INSERT ON [dbo].[RMAStoresBranches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[RMAStoresBranches] TO [boffice]
GO
GRANT SELECT ON [dbo].[RMAStoresBranches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[RMAStoresBranches] TO [boffice]
GO
GRANT DELETE ON [dbo].[Rounder] TO [boffice]
GO
GRANT INSERT ON [dbo].[Rounder] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Rounder] TO [boffice]
GO
GRANT SELECT ON [dbo].[Rounder] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Rounder] TO [boffice]
GO
GRANT DELETE ON [dbo].[Setting] TO [boffice]
GO
GRANT INSERT ON [dbo].[Setting] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Setting] TO [boffice]
GO
GRANT SELECT ON [dbo].[Setting] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Setting] TO [boffice]
GO
GRANT DELETE ON [dbo].[SoftwareVersion] TO [boffice]
GO
GRANT INSERT ON [dbo].[SoftwareVersion] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[SoftwareVersion] TO [boffice]
GO
GRANT SELECT ON [dbo].[SoftwareVersion] TO [boffice]
GO
GRANT UPDATE ON [dbo].[SoftwareVersion] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_AddAudit] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_AddCat] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_AddOrderDetail] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_AddOrderPaymentElement] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_boxAddUpdate] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_boxinsert] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_changeboxid] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_delorder] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_LinesAffected] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_ModCat] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_PODelStatus] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_replboxinsert] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_replBranchPricesUpd] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_SetCatCode] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_SummaryDailyCatSales] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_SummaryWeeklyCatSales] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_TXStatus] TO [boffice]
GO
GRANT EXECUTE ON [dbo].[sp_UpdateBranchPrices] TO [boffice]
GO
GRANT DELETE ON [dbo].[staff] TO [boffice]
GO
GRANT INSERT ON [dbo].[staff] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[staff] TO [boffice]
GO
GRANT SELECT ON [dbo].[staff] TO [boffice]
GO
GRANT UPDATE ON [dbo].[staff] TO [boffice]
GO
GRANT DELETE ON [dbo].[StaffBranches] TO [boffice]
GO
GRANT INSERT ON [dbo].[StaffBranches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StaffBranches] TO [boffice]
GO
GRANT SELECT ON [dbo].[StaffBranches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StaffBranches] TO [boffice]
GO
GRANT DELETE ON [dbo].[Stinc_old] TO [boffice]
GO
GRANT INSERT ON [dbo].[Stinc_old] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Stinc_old] TO [boffice]
GO
GRANT SELECT ON [dbo].[Stinc_old] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Stinc_old] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockInRMADetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockInRMADetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockInRMADetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockInRMADetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockInRMADetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockLevel] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockLevel] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockLevel] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockLevel] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockLevel] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockRMADetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockRMADetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockRMADetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockRMADetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockRMADetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockTransfer] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockTransfer] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockTransfer] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockTransfer] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockTransfer] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockTransferMethod] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockTransferMethod] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockTransferMethod] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockTransferMethod] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockTransferMethod] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockTransferStatus] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockTransferStatus] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockTransferStatus] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockTransferStatus] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockTransferStatus] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockTransferType] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockTransferType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockTransferType] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockTransferType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockTransferType] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockUpdate] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockUpdate] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockUpdate] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockUpdate] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockUpdate] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockUpdateDetails] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockUpdateDetails] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockUpdateDetails] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockUpdateDetails] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockUpdateDetails] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockUpdateType] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockUpdateType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockUpdateType] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockUpdateType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockUpdateType] TO [boffice]
GO
GRANT DELETE ON [dbo].[StockVariance] TO [boffice]
GO
GRANT INSERT ON [dbo].[StockVariance] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StockVariance] TO [boffice]
GO
GRANT SELECT ON [dbo].[StockVariance] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StockVariance] TO [boffice]
GO
GRANT DELETE ON [dbo].[StreetTypeCodes] TO [boffice]
GO
GRANT INSERT ON [dbo].[StreetTypeCodes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[StreetTypeCodes] TO [boffice]
GO
GRANT SELECT ON [dbo].[StreetTypeCodes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[StreetTypeCodes] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxContainer] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxContainer] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxContainer] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxContainer] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxContainer] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxDiffInOut] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxDiffInOut] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxDiffInOut] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxDiffInOut] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxDiffInOut] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxDiffReq] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxDiffReq] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxDiffReq] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxDiffReq] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxDiffReq] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxOrder] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxOrder] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxOrder] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxOrder] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxOrder] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxRequest] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxRequest] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxRequest] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxRequest] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxRequest] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxRequestDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxRequestDetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxRequestDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxRequestDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxRequestDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxRequestStatus] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxRequestStatus] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxRequestStatus] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxRequestStatus] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxRequestStatus] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxRequestType] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxRequestType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxRequestType] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxRequestType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxRequestType] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxStockIN] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxStockIN] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxStockIN] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxStockIN] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxStockIN] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxStockINDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxStockINDetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxStockINDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxStockINDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxStockINDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxTransit] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxTransit] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxTransit] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxTransit] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxTransit] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxTransitDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxTransitDetail] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxTransitDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxTransitDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxTransitDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[STxTransitStatus] TO [boffice]
GO
GRANT INSERT ON [dbo].[STxTransitStatus] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[STxTransitStatus] TO [boffice]
GO
GRANT SELECT ON [dbo].[STxTransitStatus] TO [boffice]
GO
GRANT UPDATE ON [dbo].[STxTransitStatus] TO [boffice]
GO
GRANT DELETE ON [dbo].[SummaryDailySales] TO [boffice]
GO
GRANT INSERT ON [dbo].[SummaryDailySales] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[SummaryDailySales] TO [boffice]
GO
GRANT SELECT ON [dbo].[SummaryDailySales] TO [boffice]
GO
GRANT UPDATE ON [dbo].[SummaryDailySales] TO [boffice]
GO
GRANT DELETE ON [dbo].[SummaryWeeklySales] TO [boffice]
GO
GRANT INSERT ON [dbo].[SummaryWeeklySales] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[SummaryWeeklySales] TO [boffice]
GO
GRANT SELECT ON [dbo].[SummaryWeeklySales] TO [boffice]
GO
GRANT UPDATE ON [dbo].[SummaryWeeklySales] TO [boffice]
GO
GRANT DELETE ON [dbo].[SuperCat] TO [boffice]
GO
GRANT INSERT ON [dbo].[SuperCat] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[SuperCat] TO [boffice]
GO
GRANT SELECT ON [dbo].[SuperCat] TO [boffice]
GO
GRANT UPDATE ON [dbo].[SuperCat] TO [boffice]
GO
GRANT DELETE ON [dbo].[SupplierInfo] TO [boffice]
GO
GRANT INSERT ON [dbo].[SupplierInfo] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[SupplierInfo] TO [boffice]
GO
GRANT SELECT ON [dbo].[SupplierInfo] TO [boffice]
GO
GRANT UPDATE ON [dbo].[SupplierInfo] TO [boffice]
GO
GRANT DELETE ON [dbo].[titles] TO [boffice]
GO
GRANT INSERT ON [dbo].[titles] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[titles] TO [boffice]
GO
GRANT SELECT ON [dbo].[titles] TO [boffice]
GO
GRANT UPDATE ON [dbo].[titles] TO [boffice]
GO
GRANT DELETE ON [dbo].[TransactionTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[TransactionTypes] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[TransactionTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[TransactionTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[TransactionTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[TransitDelta] TO [boffice]
GO
GRANT INSERT ON [dbo].[TransitDelta] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[TransitDelta] TO [boffice]
GO
GRANT SELECT ON [dbo].[TransitDelta] TO [boffice]
GO
GRANT UPDATE ON [dbo].[TransitDelta] TO [boffice]
GO
GRANT DELETE ON [dbo].[unboxed_counter] TO [boffice]
GO
GRANT INSERT ON [dbo].[unboxed_counter] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[unboxed_counter] TO [boffice]
GO
GRANT SELECT ON [dbo].[unboxed_counter] TO [boffice]
GO
GRANT UPDATE ON [dbo].[unboxed_counter] TO [boffice]
GO
GRANT DELETE ON [dbo].[Users] TO [boffice]
GO
GRANT INSERT ON [dbo].[Users] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Users] TO [boffice]
GO
GRANT SELECT ON [dbo].[Users] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Users] TO [boffice]
GO
GRANT DELETE ON [dbo].[Voucher] TO [boffice]
GO
GRANT INSERT ON [dbo].[Voucher] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Voucher] TO [boffice]
GO
GRANT SELECT ON [dbo].[Voucher] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Voucher] TO [boffice]
GO
GRANT DELETE ON [dbo].[VoucherFailure] TO [boffice]
GO
GRANT INSERT ON [dbo].[VoucherFailure] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[VoucherFailure] TO [boffice]
GO
GRANT SELECT ON [dbo].[VoucherFailure] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VoucherFailure] TO [boffice]
GO
GRANT DELETE ON [dbo].[VoucherNote] TO [boffice]
GO
GRANT INSERT ON [dbo].[VoucherNote] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[VoucherNote] TO [boffice]
GO
GRANT SELECT ON [dbo].[VoucherNote] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VoucherNote] TO [boffice]
GO
GRANT DELETE ON [dbo].[VoucherNoteType] TO [boffice]
GO
GRANT INSERT ON [dbo].[VoucherNoteType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[VoucherNoteType] TO [boffice]
GO
GRANT SELECT ON [dbo].[VoucherNoteType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VoucherNoteType] TO [boffice]
GO
GRANT DELETE ON [dbo].[VoucherOverride] TO [boffice]
GO
GRANT INSERT ON [dbo].[VoucherOverride] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[VoucherOverride] TO [boffice]
GO
GRANT SELECT ON [dbo].[VoucherOverride] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VoucherOverride] TO [boffice]
GO
GRANT DELETE ON [dbo].[VoucherType] TO [boffice]
GO
GRANT INSERT ON [dbo].[VoucherType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[VoucherType] TO [boffice]
GO
GRANT SELECT ON [dbo].[VoucherType] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VoucherType] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwAllowedModifiers] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwAllowedModifiers] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwAllowedModifiers] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwAllowedModifiers] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwAPAttendance] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwAPAttendance] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwAPAttendance] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwAPAttendance] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwAPRefundReasons] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwAPRefundReasons] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwAPRefundReasons] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwAPRefundReasons] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwAPRefundTypes] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwAPRefundTypes] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwAPRefundTypes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwAPRefundTypes] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwAuditTrailReport] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwAuditTrailReport] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwAuditTrailReport] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwAuditTrailReport] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwBranchShortKeys] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwBranchShortKeys] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwBranchShortKeys] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwBranchShortKeys] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwItemHistory] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwItemHistory] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwItemHistory] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwItemHistory] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwItemStockLevel] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwItemStockLevel] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwItemStockLevel] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwItemStockLevel] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwLocationStockSummary] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwLocationStockSummary] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwLocationStockSummary] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwLocationStockSummary] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwNewOrderItemList] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwNewOrderItemList] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwNewOrderItemList] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwNewOrderItemList] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwNewPurchaseOrderReports] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwNewPurchaseOrderReports] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwNewPurchaseOrderReports] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwNewPurchaseOrderReports] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwOrderItemList] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwOrderItemList] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwOrderItemList] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwOrderItemList] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwOrderItems] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwOrderItems] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwOrderItems] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwOrderItems] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwPaymentElements] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwPaymentElements] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwPaymentElements] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwPaymentElements] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwPODeliveryAddress] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwPODeliveryAddress] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwPODeliveryAddress] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwPODeliveryAddress] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwPOItemSummary] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwPOItemSummary] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwPOItemSummary] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwPOItemSummary] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwPurchaseOrderStatus] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwPurchaseOrderStatus] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwPurchaseOrderStatus] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwPurchaseOrderStatus] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwreferencedCategoryCount] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwreferencedCategoryCount] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwreferencedCategoryCount] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwreferencedCategoryCount] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwReferencedCategoryList] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwReferencedCategoryList] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwReferencedCategoryList] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwReferencedCategoryList] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwRefundElements] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwRefundElements] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwRefundElements] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwRefundElements] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwReportStockLevel] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwReportStockLevel] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwReportStockLevel] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwReportStockLevel] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwReserveInfo] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwReserveInfo] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwReserveInfo] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwReserveInfo] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwSalesbyCat] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwSalesbyCat] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwSalesbyCat] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwSalesbyCat] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwSalesbyDay] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwSalesbyDay] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwSalesbyDay] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwSalesbyDay] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwSteveTest] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwSteveTest] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwSteveTest] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwSteveTest] TO [boffice]
GO
GRANT DELETE ON [dbo].[VWStockAllLocations] TO [boffice]
GO
GRANT INSERT ON [dbo].[VWStockAllLocations] TO [boffice]
GO
GRANT SELECT ON [dbo].[VWStockAllLocations] TO [boffice]
GO
GRANT UPDATE ON [dbo].[VWStockAllLocations] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwWorkstationBranch] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwWorkstationBranch] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwWorkstationBranch] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwWorkstationBranch] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwxlBoxHistory] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwxlBoxHistory] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwxlBoxHistory] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwxlBoxHistory] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLDailySales] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLDailySales] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLDailySales] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLDailySales] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLDailyTotals] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLDailyTotals] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLDailyTotals] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLDailyTotals] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLMonthlySales] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLMonthlySales] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLMonthlySales] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLMonthlySales] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLOrderDetail] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLOrderDetail] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLOrderDetail] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLOrderDetail] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLStockLevels] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLStockLevels] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLStockLevels] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLStockLevels] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwxltradedboxes] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwxltradedboxes] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwxltradedboxes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwxltradedboxes] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLTransfers] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLTransfers] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLTransfers] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLTransfers] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwxluntradedboxes] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwxluntradedboxes] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwxluntradedboxes] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwxluntradedboxes] TO [boffice]
GO
GRANT DELETE ON [dbo].[vwXLWeeklySales] TO [boffice]
GO
GRANT INSERT ON [dbo].[vwXLWeeklySales] TO [boffice]
GO
GRANT SELECT ON [dbo].[vwXLWeeklySales] TO [boffice]
GO
GRANT UPDATE ON [dbo].[vwXLWeeklySales] TO [boffice]
GO
GRANT DELETE ON [dbo].[WorkOrderReturnReason] TO [boffice]
GO
GRANT INSERT ON [dbo].[WorkOrderReturnReason] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[WorkOrderReturnReason] TO [boffice]
GO
GRANT SELECT ON [dbo].[WorkOrderReturnReason] TO [boffice]
GO
GRANT UPDATE ON [dbo].[WorkOrderReturnReason] TO [boffice]
GO
GRANT DELETE ON [dbo].[WorkORders] TO [boffice]
GO
GRANT INSERT ON [dbo].[WorkORders] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[WorkORders] TO [boffice]
GO
GRANT SELECT ON [dbo].[WorkORders] TO [boffice]
GO
GRANT UPDATE ON [dbo].[WorkORders] TO [boffice]
GO
GRANT DELETE ON [dbo].[WorkstationBranches] TO [boffice]
GO
GRANT INSERT ON [dbo].[WorkstationBranches] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[WorkstationBranches] TO [boffice]
GO
GRANT SELECT ON [dbo].[WorkstationBranches] TO [boffice]
GO
GRANT UPDATE ON [dbo].[WorkstationBranches] TO [boffice]
GO
GRANT DELETE ON [dbo].[Workstations] TO [boffice]
GO
GRANT INSERT ON [dbo].[Workstations] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[Workstations] TO [boffice]
GO
GRANT SELECT ON [dbo].[Workstations] TO [boffice]
GO
GRANT UPDATE ON [dbo].[Workstations] TO [boffice]
GO

--eposv2

GRANT DELETE ON [dbo].[Attribute] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Attribute] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Attribute] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Attribute] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Attribute] TO [eposv2]
GO
GRANT DELETE ON [dbo].[AttributeStructure] TO [eposv2]
GO
GRANT INSERT ON [dbo].[AttributeStructure] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[AttributeStructure] TO [eposv2]
GO
GRANT SELECT ON [dbo].[AttributeStructure] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[AttributeStructure] TO [eposv2]
GO
GRANT DELETE ON [dbo].[AttributeStructureCategory] TO [eposv2]
GO
GRANT INSERT ON [dbo].[AttributeStructureCategory] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[AttributeStructureCategory] TO [eposv2]
GO
GRANT SELECT ON [dbo].[AttributeStructureCategory] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[AttributeStructureCategory] TO [eposv2]
GO
GRANT DELETE ON [dbo].[AuditEntryTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[AuditEntryTypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[AuditEntryTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[AuditEntryTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[AuditEntryTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[AUditTrail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[AUditTrail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[AUditTrail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[AUditTrail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[AUditTrail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[banking] TO [eposv2]
GO
GRANT INSERT ON [dbo].[banking] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[banking] TO [eposv2]
GO
GRANT SELECT ON [dbo].[banking] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[banking] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_Branches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_Branches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_Branches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_Branches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Banking_Branches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_Data] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_Data] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_Data] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_Data] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Banking_Data] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_LineComment] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_LineComment] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_LineComment] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_LineComment] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Banking_LineComment] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_lines] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_lines] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_lines] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_lines] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Banking_lines] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_linetypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_linetypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_linetypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_linetypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Banking_PDQ] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Banking_PDQ] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Banking_PDQ] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Banking_PDQ] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Banking_PDQ] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BoxAlias] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BoxAlias] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxAlias] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxAlias] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BoxAlias] TO [eposv2]
GO
GRANT DELETE ON [dbo].[boxes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[boxes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[boxes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[boxes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[boxes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BoxPrice] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BoxPrice] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxPrice] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxPrice] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BoxPrice] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BoxPriceChange] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BoxPriceChange] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxPriceChange] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxPriceChange] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BoxPriceChange] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BoxPriceChangePrinted] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BoxPriceChangePrinted] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxPriceChangePrinted] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxPriceChangePrinted] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BoxPriceChangePrinted] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxQuantities] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxQuantities] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BoxStock] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BoxStock] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BoxStock] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BoxStock] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BoxStock] TO [eposv2]
GO
GRANT DELETE ON [dbo].[branchCategoryShortKeys] TO [eposv2]
GO
GRANT INSERT ON [dbo].[branchCategoryShortKeys] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[branchCategoryShortKeys] TO [eposv2]
GO
GRANT SELECT ON [dbo].[branchCategoryShortKeys] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[branchCategoryShortKeys] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Branches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Branches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Branches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Branches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Branches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BranchPrinter] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BranchPrinter] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BranchPrinter] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BranchPrinter] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BranchPrinter] TO [eposv2]
GO
GRANT DELETE ON [dbo].[BranchSetting] TO [eposv2]
GO
GRANT INSERT ON [dbo].[BranchSetting] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[BranchSetting] TO [eposv2]
GO
GRANT SELECT ON [dbo].[BranchSetting] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[BranchSetting] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CapacityModifier] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CapacityModifier] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CapacityModifier] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CapacityModifier] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CapacityModifier] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CardDetails] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CardDetails] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CardDetails] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CardDetails] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CardDetails] TO [eposv2]
GO
GRANT DELETE ON [dbo].[category] TO [eposv2]
GO
GRANT INSERT ON [dbo].[category] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[category] TO [eposv2]
GO
GRANT SELECT ON [dbo].[category] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[category] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CategoryDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CategoryDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CategoryDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CategoryDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CategoryDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CategoryModifiers] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CategoryModifiers] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CategoryModifiers] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CategoryModifiers] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CategoryModifiers] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Charity] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Charity] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Charity] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Charity] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Charity] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CheckList] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CheckList] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CheckList] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CheckList] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CheckList] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CheckListDetails] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CheckListDetails] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CheckListDetails] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CheckListDetails] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CheckListDetails] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CheckListItems] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CheckListItems] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CheckListItems] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CheckListItems] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CheckListItems] TO [eposv2]
GO
GRANT DELETE ON [dbo].[cheques] TO [eposv2]
GO
GRANT INSERT ON [dbo].[cheques] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[cheques] TO [eposv2]
GO
GRANT SELECT ON [dbo].[cheques] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[cheques] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ClauseLines] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ClauseLines] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ClauseLines] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ClauseLines] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ClauseLines] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Clauses] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Clauses] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Clauses] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Clauses] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Clauses] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Country] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Country] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Country] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Country] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Country] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CountyStates] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CountyStates] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CountyStates] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CountyStates] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CountyStates] TO [eposv2]
GO
GRANT DELETE ON [dbo].[credit_cards] TO [eposv2]
GO
GRANT INSERT ON [dbo].[credit_cards] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[credit_cards] TO [eposv2]
GO
GRANT SELECT ON [dbo].[credit_cards] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[credit_cards] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CreditCardTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CreditCardTypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CreditCardTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CreditCardTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CreditCardTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[currencies] TO [eposv2]
GO
GRANT INSERT ON [dbo].[currencies] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[currencies] TO [eposv2]
GO
GRANT SELECT ON [dbo].[currencies] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[currencies] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CurrencyDenominations] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CurrencyDenominations] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CurrencyDenominations] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CurrencyDenominations] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CurrencyDenominations] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Customer] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Customer] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Customer] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Customer] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Customer] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CustomerCard] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CustomerCard] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CustomerCard] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CustomerCard] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CustomerCard] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CustomerIDMod] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CustomerIDMod] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CustomerIDMod] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CustomerIDMod] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CustomerIDMod] TO [eposv2]
GO
GRANT DELETE ON [dbo].[CustomerIDType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[CustomerIDType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[CustomerIDType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[CustomerIDType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[CustomerIDType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[DBQueue] TO [eposv2]
GO
GRANT INSERT ON [dbo].[DBQueue] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[DBQueue] TO [eposv2]
GO
GRANT SELECT ON [dbo].[DBQueue] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[DBQueue] TO [eposv2]
GO
GRANT DELETE ON [dbo].[DBQueueDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[DBQueueDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[DBQueueDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[DBQueueDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[DBQueueDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[DBQueueType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[DBQueueType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[DBQueueType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[DBQueueType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[DBQueueType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Elasticity] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Elasticity] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Elasticity] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Elasticity] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Elasticity] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Errors] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Errors] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Errors] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Errors] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Errors] TO [eposv2]
GO
GRANT DELETE ON [dbo].[FloorLimits] TO [eposv2]
GO
GRANT INSERT ON [dbo].[FloorLimits] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[FloorLimits] TO [eposv2]
GO
GRANT SELECT ON [dbo].[FloorLimits] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[FloorLimits] TO [eposv2]
GO
GRANT DELETE ON [dbo].[hear] TO [eposv2]
GO
GRANT INSERT ON [dbo].[hear] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[hear] TO [eposv2]
GO
GRANT SELECT ON [dbo].[hear] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[hear] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Holding_BranchPrices] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Holding_BranchPrices] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Holding_BranchPrices] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Holding_BranchPrices] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Holding_BranchPrices] TO [eposv2]
GO
GRANT DELETE ON [dbo].[InternalOrders] TO [eposv2]
GO
GRANT INSERT ON [dbo].[InternalOrders] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[InternalOrders] TO [eposv2]
GO
GRANT SELECT ON [dbo].[InternalOrders] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[InternalOrders] TO [eposv2]
GO
GRANT DELETE ON [dbo].[LabelPrinterType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[LabelPrinterType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[LabelPrinterType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[LabelPrinterType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[LabelPrinterType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[LocationBranches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[LocationBranches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[LocationBranches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[LocationBranches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[LocationBranches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[locations] TO [eposv2]
GO
GRANT INSERT ON [dbo].[locations] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[locations] TO [eposv2]
GO
GRANT SELECT ON [dbo].[locations] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[locations] TO [eposv2]
GO
GRANT DELETE ON [dbo].[LocationTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[LocationTypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[LocationTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[LocationTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[LocationTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Lock] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Lock] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Lock] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Lock] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Lock] TO [eposv2]
GO
GRANT DELETE ON [dbo].[login_info] TO [eposv2]
GO
GRANT INSERT ON [dbo].[login_info] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[login_info] TO [eposv2]
GO
GRANT SELECT ON [dbo].[login_info] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[login_info] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ManProducts] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ManProducts] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ManProducts] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ManProducts] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ManProducts] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Manufacturers] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Manufacturers] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Manufacturers] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Manufacturers] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Manufacturers] TO [eposv2]
GO
GRANT DELETE ON [dbo].[MobilePhone] TO [eposv2]
GO
GRANT INSERT ON [dbo].[MobilePhone] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[MobilePhone] TO [eposv2]
GO
GRANT SELECT ON [dbo].[MobilePhone] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[MobilePhone] TO [eposv2]
GO
GRANT DELETE ON [dbo].[MobilePhoneNetwork] TO [eposv2]
GO
GRANT INSERT ON [dbo].[MobilePhoneNetwork] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[MobilePhoneNetwork] TO [eposv2]
GO
GRANT SELECT ON [dbo].[MobilePhoneNetwork] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[MobilePhoneNetwork] TO [eposv2]
GO
GRANT DELETE ON [dbo].[numbers] TO [eposv2]
GO
GRANT INSERT ON [dbo].[numbers] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[numbers] TO [eposv2]
GO
GRANT SELECT ON [dbo].[numbers] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[numbers] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OperatingCompany] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OperatingCompany] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OperatingCompany] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OperatingCompany] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OperatingCompany] TO [eposv2]
GO
GRANT DELETE ON [dbo].[order_details] TO [eposv2]
GO
GRANT INSERT ON [dbo].[order_details] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[order_details] TO [eposv2]
GO
GRANT SELECT ON [dbo].[order_details] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[order_details] TO [eposv2]
GO
GRANT DELETE ON [dbo].[order_notes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[order_notes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[order_notes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[order_notes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[order_notes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderCharityElement] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderCharityElement] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderCharityElement] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderCharityElement] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderCharityElement] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderDetailCategories] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderDetailCategories] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderDetailCategories] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderDetailCategories] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderDetailCategories] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderDetailIdentifier] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderDetailIdentifier] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifier] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifier] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderDetailIdentifier] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderPaymentElements] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderPaymentElements] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderPaymentElements] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderPaymentElements] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderPaymentElements] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderPaymentTaxRate] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderPaymentTaxRate] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderPaymentTaxRate] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderPaymentTaxRate] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderPaymentTaxRate] TO [eposv2]
GO
GRANT DELETE ON [dbo].[orders] TO [eposv2]
GO
GRANT INSERT ON [dbo].[orders] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[orders] TO [eposv2]
GO
GRANT SELECT ON [dbo].[orders] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[orders] TO [eposv2]
GO
GRANT DELETE ON [dbo].[OrderTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[OrderTypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[OrderTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Origins] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Origins] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Origins] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Origins] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Origins] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PaymentGroup] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PaymentGroup] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PaymentGroup] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PaymentGroup] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PaymentGroup] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PaymentMethods] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PaymentMethods] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PaymentMethods] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PaymentMethods] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PendingPriceChanges] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PendingPriceChanges] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PendingPriceChanges] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PendingPriceChanges] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PendingPriceChanges] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Permissions] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Permissions] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Permissions] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Permissions] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Permissions] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Platform] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Platform] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Platform] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Platform] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Platform] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PlatformOrderTypePaymentMethod] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PlatformOrderTypePaymentMethod] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PlatformOrderTypePaymentMethod] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PlatformOrderTypePaymentMethod] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PlatformOrderTypePaymentMethod] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PlatformTextKeyMapping] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PlatformTextKeyMapping] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PlatformTextKeyMapping] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PlatformTextKeyMapping] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PlatformTextKeyMapping] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PODeliveries] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PODeliveries] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PODeliveries] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PODeliveries] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PODeliveries] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PODeliveryDiscrepancies] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PODeliveryDiscrepancies] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PODeliveryDiscrepancies] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PODeliveryDiscrepancies] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PODeliveryDiscrepancies] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PrinterType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PrinterType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PrinterType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PrinterType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PrinterType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ProductLine] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ProductLine] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ProductLine] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ProductLine] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ProductLine] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ProductlineCat] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ProductlineCat] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ProductlineCat] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ProductlineCat] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ProductlineCat] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PurchaseOrderDetails] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PurchaseOrderDetails] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PurchaseOrderDetails] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PurchaseOrderDetails] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PurchaseOrderDetails] TO [eposv2]
GO
GRANT DELETE ON [dbo].[PurchaseOrders] TO [eposv2]
GO
GRANT INSERT ON [dbo].[PurchaseOrders] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[PurchaseOrders] TO [eposv2]
GO
GRANT SELECT ON [dbo].[PurchaseOrders] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[PurchaseOrders] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Reasons] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Reasons] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Reasons] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Reasons] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Reasons] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ReasonType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ReasonType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ReasonType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ReasonType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ReasonType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ReceiptPrinterType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ReceiptPrinterType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ReceiptPrinterType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ReceiptPrinterType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ReceiptPrinterType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RefundDetails] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RefundDetails] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RefundDetails] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RefundDetails] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RefundDetails] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RefundReason] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RefundReason] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RefundReason] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RefundReason] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RefundReason] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Refunds] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Refunds] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Refunds] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Refunds] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Refunds] TO [eposv2]
GO
GRANT DELETE ON [dbo].[reserves] TO [eposv2]
GO
GRANT INSERT ON [dbo].[reserves] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[reserves] TO [eposv2]
GO
GRANT SELECT ON [dbo].[reserves] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[reserves] TO [eposv2]
GO
GRANT DELETE ON [dbo].[ResourceTranslation] TO [eposv2]
GO
GRANT INSERT ON [dbo].[ResourceTranslation] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[ResourceTranslation] TO [eposv2]
GO
GRANT SELECT ON [dbo].[ResourceTranslation] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[ResourceTranslation] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RMABranches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RMABranches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RMABranches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RMABranches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RMABranches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RMAReason] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RMAReason] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RMAReason] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RMAReason] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RMAReason] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RMAReasonCode] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RMAReasonCode] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RMAReasonCode] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RMAReasonCode] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RMAReasonCode] TO [eposv2]
GO
GRANT DELETE ON [dbo].[RMAStoresBranches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[RMAStoresBranches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[RMAStoresBranches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[RMAStoresBranches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[RMAStoresBranches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Rounder] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Rounder] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Rounder] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Rounder] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Rounder] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Setting] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Setting] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Setting] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Setting] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Setting] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SoftwareVersion] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SoftwareVersion] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SoftwareVersion] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SoftwareVersion] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SoftwareVersion] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_AddAudit] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_AddCat] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_AddOrderDetail] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_AddOrderPaymentElement] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_boxAddUpdate] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_boxinsert] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_changeboxid] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_delorder] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_LinesAffected] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_ModCat] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_PODelStatus] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_replboxinsert] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_replBranchPricesUpd] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_SetCatCode] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_SummaryDailyCatSales] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_SummaryWeeklyCatSales] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_TXStatus] TO [eposv2]
GO
GRANT EXECUTE ON [dbo].[sp_UpdateBranchPrices] TO [eposv2]
GO
GRANT DELETE ON [dbo].[staff] TO [eposv2]
GO
GRANT INSERT ON [dbo].[staff] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[staff] TO [eposv2]
GO
GRANT SELECT ON [dbo].[staff] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[staff] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StaffBranches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StaffBranches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StaffBranches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StaffBranches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StaffBranches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Stinc_old] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Stinc_old] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Stinc_old] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Stinc_old] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Stinc_old] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockInRMADetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockInRMADetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockInRMADetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockInRMADetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockInRMADetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockLevel] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockLevel] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockLevel] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockLevel] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockLevel] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockRMADetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockRMADetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockRMADetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockRMADetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockRMADetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockTransfer] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockTransfer] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockTransfer] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockTransfer] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockTransfer] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockTransferMethod] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockTransferMethod] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockTransferMethod] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockTransferMethod] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockTransferMethod] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockTransferStatus] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockTransferStatus] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockTransferStatus] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockTransferStatus] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockTransferStatus] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockTransferType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockTransferType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockTransferType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockTransferType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockTransferType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockUpdate] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockUpdate] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockUpdate] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockUpdate] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockUpdate] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockUpdateDetails] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockUpdateDetails] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockUpdateDetails] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockUpdateDetails] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockUpdateDetails] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockUpdateType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockUpdateType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockUpdateType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockUpdateType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockUpdateType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StockVariance] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StockVariance] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StockVariance] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StockVariance] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StockVariance] TO [eposv2]
GO
GRANT DELETE ON [dbo].[StreetTypeCodes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[StreetTypeCodes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[StreetTypeCodes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[StreetTypeCodes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[StreetTypeCodes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxContainer] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxContainer] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxContainer] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxContainer] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxContainer] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxDiffInOut] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxDiffInOut] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxDiffInOut] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxDiffInOut] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxDiffInOut] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxDiffReq] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxDiffReq] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxDiffReq] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxDiffReq] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxDiffReq] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxOrder] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxOrder] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxOrder] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxOrder] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxOrder] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxRequest] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxRequest] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxRequest] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxRequest] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxRequest] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxRequestDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxRequestDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxRequestDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxRequestDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxRequestDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxRequestStatus] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxRequestStatus] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxRequestStatus] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxRequestStatus] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxRequestStatus] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxRequestType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxRequestType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxRequestType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxRequestType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxRequestType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxStockIN] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxStockIN] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxStockIN] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxStockIN] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxStockIN] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxStockINDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxStockINDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxStockINDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxStockINDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxStockINDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxTransit] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxTransit] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxTransit] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxTransit] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxTransit] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxTransitDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxTransitDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxTransitDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxTransitDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxTransitDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[STxTransitStatus] TO [eposv2]
GO
GRANT INSERT ON [dbo].[STxTransitStatus] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[STxTransitStatus] TO [eposv2]
GO
GRANT SELECT ON [dbo].[STxTransitStatus] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[STxTransitStatus] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SummaryDailySales] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SummaryDailySales] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SummaryDailySales] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SummaryDailySales] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SummaryDailySales] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SummaryWeeklySales] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SummaryWeeklySales] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SummaryWeeklySales] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SummaryWeeklySales] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SummaryWeeklySales] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SuperCat] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SuperCat] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SuperCat] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SuperCat] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SuperCat] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SupplierInfo] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SupplierInfo] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SupplierInfo] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SupplierInfo] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SupplierInfo] TO [eposv2]
GO
GRANT DELETE ON [dbo].[SupportedLanguage] TO [eposv2]
GO
GRANT INSERT ON [dbo].[SupportedLanguage] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[SupportedLanguage] TO [eposv2]
GO
GRANT SELECT ON [dbo].[SupportedLanguage] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[SupportedLanguage] TO [eposv2]
GO
GRANT DELETE ON [dbo].[titles] TO [eposv2]
GO
GRANT INSERT ON [dbo].[titles] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[titles] TO [eposv2]
GO
GRANT SELECT ON [dbo].[titles] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[titles] TO [eposv2]
GO
GRANT DELETE ON [dbo].[TransactionTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[TransactionTypes] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[TransactionTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[TransactionTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[TransactionTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[TransitDelta] TO [eposv2]
GO
GRANT INSERT ON [dbo].[TransitDelta] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[TransitDelta] TO [eposv2]
GO
GRANT SELECT ON [dbo].[TransitDelta] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[TransitDelta] TO [eposv2]
GO
GRANT DELETE ON [dbo].[unboxed_counter] TO [eposv2]
GO
GRANT INSERT ON [dbo].[unboxed_counter] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[unboxed_counter] TO [eposv2]
GO
GRANT SELECT ON [dbo].[unboxed_counter] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[unboxed_counter] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Users] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Users] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Users] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Users] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Users] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Voucher] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Voucher] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Voucher] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Voucher] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Voucher] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherFailure] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherFailure] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherFailure] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherFailure] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherFailure] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherLocalLog] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherLocalLog] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherLocalLog] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherLocalLog] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherLocalLog] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherLocalLogType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherLocalLogType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherLocalLogType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherLocalLogType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherLocalLogType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherNote] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherNote] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherNote] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherNote] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherNote] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherNoteType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherNoteType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherNoteType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherNoteType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherNoteType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherOverride] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherOverride] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherOverride] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherOverride] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherOverride] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VoucherType] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VoucherType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[VoucherType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VoucherType] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VoucherType] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwAllowedModifiers] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwAllowedModifiers] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwAllowedModifiers] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwAllowedModifiers] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwAPAttendance] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwAPAttendance] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwAPAttendance] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwAPAttendance] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwAPRefundReasons] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwAPRefundReasons] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwAPRefundReasons] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwAPRefundReasons] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwAPRefundTypes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwAPRefundTypes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwAPRefundTypes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwAPRefundTypes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwAuditTrailReport] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwAuditTrailReport] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwAuditTrailReport] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwAuditTrailReport] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwBranchShortKeys] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwBranchShortKeys] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwBranchShortKeys] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwBranchShortKeys] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwItemHistory] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwItemHistory] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwItemHistory] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwItemHistory] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwItemStockLevel] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwItemStockLevel] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwItemStockLevel] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwItemStockLevel] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwLocationStockSummary] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwLocationStockSummary] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwLocationStockSummary] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwLocationStockSummary] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwNewOrderItemList] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwNewOrderItemList] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwNewOrderItemList] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwNewOrderItemList] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwNewPurchaseOrderReports] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwNewPurchaseOrderReports] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwNewPurchaseOrderReports] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwNewPurchaseOrderReports] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwOrderItemList] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwOrderItemList] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwOrderItemList] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwOrderItemList] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwOrderItems] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwOrderItems] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwOrderItems] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwOrderItems] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwPaymentElements] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwPaymentElements] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwPaymentElements] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwPaymentElements] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwPODeliveryAddress] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwPODeliveryAddress] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwPODeliveryAddress] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwPODeliveryAddress] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwPOItemSummary] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwPOItemSummary] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwPOItemSummary] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwPOItemSummary] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwPurchaseOrderStatus] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwPurchaseOrderStatus] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwPurchaseOrderStatus] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwPurchaseOrderStatus] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwreferencedCategoryCount] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwreferencedCategoryCount] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwreferencedCategoryCount] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwreferencedCategoryCount] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwReferencedCategoryList] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwReferencedCategoryList] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwReferencedCategoryList] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwReferencedCategoryList] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwRefundElements] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwRefundElements] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwRefundElements] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwRefundElements] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwReportStockLevel] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwReportStockLevel] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwReportStockLevel] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwReportStockLevel] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwReserveInfo] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwReserveInfo] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwReserveInfo] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwReserveInfo] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwSalesbyCat] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwSalesbyCat] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwSalesbyCat] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwSalesbyCat] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwSalesbyDay] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwSalesbyDay] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwSalesbyDay] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwSalesbyDay] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwSteveTest] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwSteveTest] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwSteveTest] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwSteveTest] TO [eposv2]
GO
GRANT DELETE ON [dbo].[VWStockAllLocations] TO [eposv2]
GO
GRANT INSERT ON [dbo].[VWStockAllLocations] TO [eposv2]
GO
GRANT SELECT ON [dbo].[VWStockAllLocations] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[VWStockAllLocations] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwWorkstationBranch] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwWorkstationBranch] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwWorkstationBranch] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwWorkstationBranch] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwxlBoxHistory] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwxlBoxHistory] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwxlBoxHistory] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwxlBoxHistory] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLDailySales] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLDailySales] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLDailySales] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLDailySales] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLDailyTotals] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLDailyTotals] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLDailyTotals] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLDailyTotals] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLMonthlySales] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLMonthlySales] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLMonthlySales] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLMonthlySales] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLOrderDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLOrderDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLOrderDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLOrderDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLStockLevels] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLStockLevels] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLStockLevels] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLStockLevels] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwxltradedboxes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwxltradedboxes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwxltradedboxes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwxltradedboxes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLTransfers] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLTransfers] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLTransfers] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLTransfers] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwxluntradedboxes] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwxluntradedboxes] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwxluntradedboxes] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwxluntradedboxes] TO [eposv2]
GO
GRANT DELETE ON [dbo].[vwXLWeeklySales] TO [eposv2]
GO
GRANT INSERT ON [dbo].[vwXLWeeklySales] TO [eposv2]
GO
GRANT SELECT ON [dbo].[vwXLWeeklySales] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[vwXLWeeklySales] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrder] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrder] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrder] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrder] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrder] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrderDetail] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrderDetail] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrderDetail] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrderDetail] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrderDetail] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrderDetailTestResult] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrderDetailTestResult] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrderDetailTestResult] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrderDetailTestResult] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrderDetailTestResult] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrderReturnReason] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrderReturnReason] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrderReturnReason] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrderReturnReason] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrderReturnReason] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkORders] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkORders] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkORders] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkORders] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkORders] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrderStatus] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrderStatus] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrderStatus] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrderStatus] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrderStatus] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkOrderStatusHistory] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkOrderStatusHistory] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkOrderStatusHistory] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkOrderStatusHistory] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkOrderStatusHistory] TO [eposv2]
GO
GRANT DELETE ON [dbo].[WorkstationBranches] TO [eposv2]
GO
GRANT INSERT ON [dbo].[WorkstationBranches] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[WorkstationBranches] TO [eposv2]
GO
GRANT SELECT ON [dbo].[WorkstationBranches] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[WorkstationBranches] TO [eposv2]
GO
GRANT DELETE ON [dbo].[Workstations] TO [eposv2]
GO
GRANT INSERT ON [dbo].[Workstations] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[Workstations] TO [eposv2]
GO
GRANT SELECT ON [dbo].[Workstations] TO [eposv2]
GO
GRANT UPDATE ON [dbo].[Workstations] TO [eposv2]
GO

--reader

DENY SELECT ON [dbo].[Voucher] TO [reader]
GO
DENY SELECT ON [dbo].[VoucherNote] TO [reader]
GO

/**********************SCRIPT TO GRANT OBJECT LEVEL PERMISSION TO USERS******************************/

/***************************************DB CASES AND ITS CORRESPONDING SCRIPTS*********************************/

/********
DBCASE :- (DB-1269)
EXECUTED DATE :- (2016-09-19)
DESCRIPTION :- (Adding Unique key constraint on branches and numbers table to avoid duplicate data Issue)
*********/
GO

use Epos2000

GO

ALTER TABLE dbo.BranchSetting ADD CONSTRAINT UNIQ_Bkey_Hkey_Skey UNIQUE NONCLUSTERED
(
    BranchKey,HiveKey,Subkey
)

go


ALTER TABLE dbo.numbers ADD CONSTRAINT UNIQ_Bkey_type UNIQUE NONCLUSTERED
(
    number_type,BranchKey
)

GO

/********
DBCASE :- DB-1727
EXECUTED DATE :- (2016-10-25)
DESCRIPTION :- (Increase the size of column Value in BranchSetting table to nvarchar(1024))
				Changes related to Epos realease v10.6
*********/

GO

USE [Epos2000]
GO

IF EXISTS(SELECT D.name FROM sys.columns AS C
JOIN sys.default_constraints AS D ON C.column_id = D.parent_column_id WHERE D.name = 'DF_Registry_Value' and object_name(c.object_id) = 'Branchsetting')
BEGIN

	ALTER TABLE [dbo].[BranchSetting] DROP CONSTRAINT [DF_Registry_Value]

	ALTER TABLE BranchSetting ALTER COLUMN Value nvarchar(1024) Null

	ALTER TABLE [dbo].[BranchSetting] ADD  CONSTRAINT [DF_Registry_Value]  DEFAULT ('Value Empty') FOR [Value]

END
ELSE
BEGIN

	ALTER TABLE BranchSetting ALTER COLUMN Value nvarchar(1024) Null

END

/********
DBCASE :- DB-1837
EXECUTED DATE :- (2016-11-30)
DESCRIPTION :- New View "BoxPriceCalculated" National, Store and Web
	These view will be used mainly to get actual cashbuyprice and exchangeprice values an alternative to BoxPrice table
*********/

GO

/****** Object:  UserDefinedFunction [dbo].[fn_round_to_even]    Script Date: 12/2/2016 10:41:53 AM ******/
USE [Epos2000]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[fn_round_to_even](@Val Decimal(32,16), @Digits Int)
Returns Decimal(32,0)
AS
Begin
    Return Case When Abs(@Val - Round(@Val, @Digits, 1)) * Power(10, @Digits+1) = 5
    			AND NOT Cast(Round(ABS(@Val)*POWER(10, @Digits),0,1) as Int)%2=1
                Then Round(@Val, @Digits, 1)
                Else Round(@Val, @Digits)
                End
End

GO

GO

/****** Object:  UserDefinedFunction [dbo].[fn_getbox_cash_exchange_price]    Script Date: 12/2/2016 10:41:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fn_getbox_cash_exchange_price]
(
	@sell_price money,
    @elasticityID int,
    @is_new tinyint,
    @is_discontinued tinyint,
    @minimumbuyprice money,
    @price_type smallint /*1-CashBuyPrice,2-ExchangePrice*/
)
RETURNS MONEY
/*
Created By : Nilesh Khakharia
Created Date : 2016-12-01
Description : These function is created to calculate CashBuyPrice and ExchangePrice (Rounder Function)
	based on box sellprice and elasticityID. These function is referenced in BoxPriceCalculated view.
*/
AS
BEGIN
	DECLARE @v_price MONEY
	DECLARE @v_elasticity  MONEY 
	DECLARE @v_wrk_price MONEY
        DECLARE @v_preInc bit
    	DECLARE @v_threshold MONEY
    	DECLARE @v_delta MONEY
	DECLARE @v_rndUp MONEY
	DECLARE @v_rndDown  MONEY
	DECLARE @v_rndNear  MONEY
	DECLARE @v_multiplier  MONEY
	
	IF @is_new = 1
		RETURN 0.00
    
    	IF @is_discontinued = 1
		RETURN 0.00;
	
    	SET @v_price = 0.00
    
	(SELECT @v_preInc = PreInc,@v_threshold = threshold FROM rounder);

	/*If Price_Type is 1 Cash Price is calculated, if 2 Exchange Prie is calculated*/
	IF @price_type = 1
		(SELECT @v_elasticity = BuyPerc FROM elasticity WHERE ElasticityID = @elasticityID);
	ELSE IF @price_type = 2 
		(SELECT @v_elasticity = ExchangePerc FROM elasticity WHERE ElasticityID = @elasticityID);
	

	/* Rounder Calculation Logic*/
    IF @v_preInc = 1
      SET @v_wrk_price = CEILING((@sell_price));
	ELSE
	  SET @v_wrk_price = @sell_price;
	
   
	SET @v_wrk_price = (@v_wrk_price * @v_elasticity) / 100;
	
    /*Get Value from rounder table*/
	IF @v_wrk_price > @v_threshold  
		(SELECT @v_delta = HighDelta,@v_rndUp = HighRndUp,@v_rndDown = HighRndDown,@v_rndNear = HighRndNear,@v_multiplier = (1/HighDelta) FROM rounder);
	ELSE
		(SELECT @v_delta = LowDelta,@v_rndUp = LowRndUp,@v_rndDown = LowRndDown,@v_rndNear = LowRndNear,@v_multiplier = (1/LowDelta) FROM rounder);

    
	IF @v_rndUp= 1
		SET @v_price = FLOOR(((@v_wrk_price + @v_delta - 0.01) * @v_multiplier)) / @v_multiplier;
	ELSE IF @v_rndDown = 1
		SET @v_price = FLOOR((@v_wrk_price * @v_multiplier)) / @v_multiplier;
	ELSE
		SET @v_price = dbo.fn_round_to_even((@v_wrk_price * @v_multiplier),0) / @v_multiplier;

	IF @v_price = 0
      SET @v_price = @minimumbuyprice;
	
	RETURN @v_price;
END

GO

CREATE VIEW [dbo].[boxpricecalculated] AS
/*
Created By : Nilesh Khakharia
Created Date : 2016-12-01
Description : These view is an alternative to boxprice table and contains the 
	calculcated cashbuyprice and exchangeprice. It uses the custom function fn_getbox_cash_exchange_price
    for price calculation.	
*/
SELECT  BoxID,
	Box_name,
	Box_Category,
	SellPrice,
	(CASE WHEN CashBuyPrice <> 0 and (new = 0 and discontinued =0) THEN CashBuyPrice ELSE 
		dbo.fn_getbox_cash_exchange_price(sellPrice,ElasticityID,new,discontinued,T.value,1) END) as CashBuyPrice,
	(CASE WHEN ExchangePrice <> 0 and (new = 0 and discontinued =0) THEN ExchangePrice ELSE
		dbo.fn_getbox_cash_exchange_price(sellPrice,ElasticityID,new,discontinued,T.value,2) END) as ExchangePrice,
	new,
        discontinued,
        ElasticityID,
        UnitCostPrice,
        LastUpdatedCostPrice
FROM boxprice bp
inner join boxes b on b.box_id = bp.BoxID
inner join (select TOP 1 0 as ID,value from BranchSetting where subkey= 'Minimum Buyin Price' and HiveKey = 'International' ) as T on T.ID= 0 

GO

GRANT SELECT ON [dbo].[boxpricecalculated] to reader,boffice,eposv2
GO
GRANT EXEC ON [dbo].[fn_getbox_cash_exchange_price] to reader,boffice,eposv2

GO

/********
DBCASE :- DB-1878
EXECUTED DATE :- (2016-12-19)
DESCRIPTION :- New table RefundOrderTransferred in National and Store
*********/

CREATE TABLE [dbo].[RefundOrderTransferred](
	[RefundBranchKey] [varchar](6) NOT NULL,
	[RefundOrderId] [int] NOT NULL,
	[TransferBranchKey] [varchar](6) NOT NULL,
	[TransferOrderId] [int] NOT NULL,
	[CreatedDatetime] [datetime] NULL,
 CONSTRAINT [PK_RefundOrderTransferred] PRIMARY KEY CLUSTERED 
(
	[RefundBranchKey] ASC,
	[RefundOrderId] ASC
)
) ON [PRIMARY]

GO


GRANT SELECT,INSERT ON dbo.RefundOrderTransferred TO eposv2;  

GO  

/********
DBCASE :- DB-2119
EXECUTED DATE :- (2017-04-04)
DESCRIPTION :- BranchPrinter Name Column Data length Changes
*********/
ALTER TABLE dbo.BranchPrinter ALTER COLUMN Branchkey varchar(6) not null;
ALTER TABLE dbo.BranchPrinter ALTER COLUMN Name varchar(50) not null;

GO

/********
DBCASE :- DB-1609
EXECUTED DATE :- (2017-04-04)
DESCRIPTION :- Adding Primary key to Branchprinter Table
*********/

ALTER TABLE dbo.BranchPrinter ADD CONSTRAINT PK_BranchPrinter PRIMARY KEY (BranchKey,Name)

/********
DBCASE :- DB-2340
EXECUTED DATE :- (2017-05-22)
DESCRIPTION :- Add branchesonline table on stores
*********/

GO

CREATE TABLE [dbo].[branchesonline](
	[BranchID] [int] NOT NULL,
	[URL] [varchar](50) NOT NULL,
	[EcomAllowed] [tinyint] NOT NULL,
	[EcomTaskInbox] [varchar](255) NOT NULL,
	[Latitude] [varchar](25) NULL,
	[Longitude] [varchar](25) NULL,
	[region] [int] NULL,
	[ShowOnStorePage] [tinyint] NULL,
	[PublicName] [varchar](255) NOT NULL,
	[branchIP] [varchar](100) NULL,
	[MSTimeZoneID] [varchar](45) NULL CONSTRAINT [DF_branchesonline_MSTimeZoneID]  DEFAULT (NULL),
	[LocalSubnet] [varchar](100) NULL CONSTRAINT [DF_branchesonline_LocalSubnet]  DEFAULT (NULL),
	[BranchHostName] [varchar](255) NULL,
	CONSTRAINT [PK_branchesonline] PRIMARY KEY CLUSTERED 
	(
		[BranchID] ASC
	)
) ON [PRIMARY]

GO

GRANT REFERENCES , SELECT , INSERT , DELETE , UPDATE ON branchesonline TO eposv2 
GO 
GRANT REFERENCES , SELECT ON branchesonline TO reader 
GO

/********
DBCASE :- DB-2574
EXECUTED DATE :- (2017-07-25)
DESCRIPTION :-  add a new column in the Orders table i.e. 'InvoiceNumber'
*********/

ALTER TABLE orders ADD InvoiceNumber varchar(50) null;

GO
/********
DBCASE :- DB-2579
EXECUTED DATE :- (2017-07-25)
DESCRIPTION :- add a new column in the CategoryDetail table i.e. 'TaxCodeA' And 'TaxCodeB'
*********/

ALTER TABLE CategoryDetail
ADD TaxCodeA numeric(8) null,
TaxCodeB numeric(8) null

GO

/********
DBCASE :- DB-2535
EXECUTED DATE :- (2017-07-31)
DESCRIPTION :- Add CharacterLimit Column to CustomerIDType table on Store and National DB
*********/
ALTER TABLE CustomerIDType ADD CharacterLimit TINYINT NULL
GO

/********
DBCASE :- DB-2582
EXECUTED DATE :- (2017-08-04)
DESCRIPTION :- Voucher Chaukeedaar database changes
*********/
ALTER TABLE Voucher ADD IssueDate DATETIME NULL
GO
CREATE NONCLUSTERED INDEX ncl_issuedate_voucher
ON dbo.Voucher(IssueDate)

/********
DBCASE :- DB-2730
EXECUTED DATE :- (2017-08-22)
DESCRIPTION :- Voucher Chaukeedaar database changes
*********/

GO
ALTER TABLE dbo.PaymentMethods ALTER column ReceiptName nvarchar(50) null

GO

/********
DBCASE :- DB-2626
EXECUTED DATE :- (2017-08-30)
DESCRIPTION :- New Branches field "ShelfLengthMeters"
*********/

GO
ALTER TABLE Branches ADD ShelfLength INT DEFAULT NULL

GO

/***Alter view on both National and Store ****/

CREATE VIEW [dbo].[vwWorkstationBranch]  
AS  
SELECT workstationbranches.workstationID, 
workstationbranches.defaultbranch, branches.*,  
locations.location_ID, locations.location_name, locationbranches.locationtype from 
 WorkstationBranches, branches, locationbranches, locations 
where WorkstationBranches.branchid = branches.branchid and locationbranches.branchid = branches.branchid  
and locationbranches.locationid = locations.location_id

go


/********
DBCASE :- DB-2739
EXECUTED DATE :- (2017-08-30)
DESCRIPTION :- Add new columns in boxes table
*********/
-----------------------------------------------------------------------------------------------------------------
-- Script to be run to add new column 'WebSaleAllowed' 
-----------------------------------------------------------------------------------------------------------------
GO 
ALTER TABLE boxes
ADD WebSaleAllowed bit NOT NULL DEFAULT 'false';

GO

-----------------------------------------------------------------------------------------------------------------
-- Script to be run to add new column 'WebBuyAllowed' 
-----------------------------------------------------------------------------------------------------------------
GO 
ALTER TABLE boxes
ADD WebBuyAllowed bit NOT NULL DEFAULT 'false';

GO

-----------------------------------------------------------------------------------------------------------------
-- Script to be run to add new column 'BuyAllowed' 
-----------------------------------------------------------------------------------------------------------------
GO 
ALTER TABLE boxes
ADD BuyAllowed bit NOT NULL DEFAULT 'false';

GO

-----------------------------------------------------------------------------------------------------------------
-- Script to be run to add new column 'SaleAllowed' 
-----------------------------------------------------------------------------------------------------------------
GO 
ALTER TABLE boxes
ADD SaleAllowed bit NOT NULL DEFAULT 'false';

GO

-----------------------------------------------------------------------------------------------------------------
-- Script to be run to add new column 'NeedBuyPriceRefresh' 
-----------------------------------------------------------------------------------------------------------------
GO 
ALTER TABLE boxes
ADD NeedBuyPriceRefresh bit NOT NULL DEFAULT 'false';

GO

/********
DBCASE :- DB-3031
EXECUTED DATE :- (2017-10-17)
DESCRIPTION :- Add unique constraint on Banking table
*********/

ALTER TABLE banking 
 ADD CONSTRAINT UNQ_banking UNIQUE(branchKey, banking_date, workstationID)

GO

/********
DBCASE :- DB-1973
EXECUTED DATE :- (2017-12-08)
DESCRIPTION :- Errors table schema changes to enable replication
*********/

CREATE FUNCTION fn_errors_BranchKey()   
RETURNS  varchar(20)
AS
BEGIN
DECLARE @branchkey varchar(20)
     if(SELECT count(distinct BranchKey) FROM epos2000.dbo.BranchSetting)<>1
	SET @branchkey = (SELECT @@servername)
ELSE
	SET @branchkey = (SELECT TOP 1 BranchKey FROM epos2000.dbo.BranchSetting)

	RETURN @branchkey
End

GO

ALTER TABLE [Errors] ADD BranchKey varchar(20) not null CONSTRAINT DF_errors_hostname DEFAULT dbo.fn_errors_BranchKey()
GO
ALTER TABLE [Errors] DROP CONSTRAINT PK_Errors
GO
ALTER TABLE [Errors] ADD CONSTRAINT PK_errors_id_BranchKey PRIMARY KEY (error_id,BranchKey);

GO
GRANT EXECUTE ON fn_errors_BranchKey to public

/********
DBCASE :- DB-2607
EXECUTED DATE :- 
DESCRIPTION :- SARS SQL version
*********/

GO

CREATE TABLE dbo.SARSLog
(
	ID int identity(1,1),
	SARSRunDate datetime,
	LocationID int,
	CategoryID int,
	LogMessage nvarchar(512)
)

GO

CREATE PROC [dbo].[Stock_Advertisement_Requirement_System]
/****
CREATED BY : NILESH KHAKHARIA
CREATED DATE : 2017-06-01
LAST MODIFIED BY :
LAST MODIFIED DATE :
DESCRIPTION : THESE PROC IS REPLACEMENT FOR SARS APPLICATION
EXECUTION DATE : EXEC [dbo].[Stock_Advertisement_Requirement_System]
****/
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @LocationID int
	DECLARE @Branchkey varchar(6)
	DECLARE @SarsMode varchar(6)
	DECLARE @MaxSeqID int
	DECLARE @MinSeqID int
	DECLARE @BoxMaxSeqID int
	DECLARE @BoxMinSeqID int
	DECLARE @CatID int
	DECLARE @OverStock int
	DECLARE @LargestStock int
	DECLARE @TotalStock int
	DECLARE @CatAdvertise int
	DECLARE @EffCapacity int
	DECLARE @BoxID varchar(20)
	DECLARE @Stock int
	DECLARE @NewReorderLevel int
	DECLARE @BoxCategory nvarchar(128)
	DECLARE @CatProcessedCnt int = 0
	DECLARE @MinLevel int
	DECLARE @MaxLevel int
	DECLARE @OptLevel int
	DECLARE @CatReq int
	DECLARE @SkipCurrentLocation int
	
	CREATE TABLE #CatList
	(
		SeqID int IDENTITY(1,1),
		CategoryID int,
		Box_Category nvarchar(25) COLLATE DATABASE_DEFAULT,
		[minstock] [int] NULL,
		[OptStock] [int] NULL,
		[MaxStock] [int] NULL,
		[StockCapacity] [int] NULL,
		[Active] [bit] NULL,
		[Overstock] [int] NULL,
		[SARSdirty] [int] NULL,
		TotalStock int,
		Capacitymodifier real,
		CapacityBuffer int,
		EffCapacity int,
		CatRequest int,
		CatAdvertise int
	)	

	CREATE TABLE #CatBoxStock
	(
		BoxID varchar(20) COLLATE DATABASE_DEFAULT,
		Box_Category nvarchar(25) COLLATE DATABASE_DEFAULT,
		CategoryID int,
		Stock int,
		OldReorderLevel int,	
		NewReorderLevel int
	)
	
	SET @SarsMode = ''

    BEGIN TRY

		/****Initial Cursor to get all branchkey & LocationID for the store (require for Multi-Tenant Stores)****/
		DECLARE branchList CURSOR FOR
		SELECT LocationID, Branchkey 
		FROM dbo.Branches B
		INNER JOIN dbo.LocationBranches LB 
		ON B.BranchID = LB.BranchID
		WHERE ServerName = @@SERVERNAME 
		AND LocationType = 1

		OPEN branchList;

		FETCH NEXT FROM branchList INTO @LocationID, @Branchkey

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			SET @SkipCurrentLocation = 0;
			
			--GET SARS MODE
			SELECT @SarsMode = UPPER(value) 
			FROM BranchSetting 
			WHERE 
				Subkey = 'SARS Mode' 
				AND BranchKey = @Branchkey

			IF ISNULL(@SarsMode,'') = ''
			BEGIN
				SET @SarsMode = 'FULL'
				
				INSERT INTO dbo.BranchSetting (HiveKey,BranchKey, SubKey, Value) VALUES('SARS', @Branchkey, 'SARS Mode','Full');
				
				INSERT INTO dbo.SARSLog(SARSRunDate,LogMessage) values(getdate(),'Setting missing for SARS Mode in branch ' + @Branchkey + '. "Full" inserted');
			END
			 
			INSERT INTO dbo.SARSLog(SARSRunDate,LocationID) values(getdate(),@LocationID);
			
			IF @SarsMode = 'UPDATE' OR @SarsMode = 'FULL'
			BEGIN
				--Add Missing Category in StockLevel Table
				INSERT INTO dbo.StockLevel(CategoryID, LocationID, MinStock,OptStock, MaxStock, Capacity,StockHolding, LastSARSrun, Active, Overstock, SARSdirty)
				SELECT DISTINCT Cat.category_id,@LocationID, '0', '1', '20','0','0', getdate(), '0', '0', '0' 
				FROM dbo.category Cat 
				LEFT JOIN dbo.StockLevel SL 
					ON Cat.category_id = SL.CategoryID
					AND SL.LocationID = @LocationID
				WHERE SL.CategoryID IS NULL 
		
			END			
				
			IF @SarsMode = 'ABOUT'
			BEGIN
			
				INSERT INTO dbo.SARSLog(SARSRunDate,LocationID,LogMessage) values(getdate(),@LocationID, 'About mode: Stock Advertisment and Request System.');
			
			END
			ELSE IF @SarsMode = 'UPDATE'
			BEGIN
				
				INSERT INTO dbo.SARSLog(SARSRunDate,LocationID,LogMessage) values(getdate(),@LocationID, 'Update mode: Only dirty categories will be processed.');
				
				INSERT INTO #CatList(CategoryID,box_category, MinStock, MaxStock, OptStock, Overstock,SARSdirty,StockCapacity,Active,Capacitymodifier,
				Capacitybuffer,EffCapacity)
				SELECT 
				C.category_id, C.box_category, 
				CASE WHEN SL.CategoryID IS NULL THEN 0 ELSE ISNULL(SL.MinStock,0) END , 
				CASE WHEN SL.CategoryID IS NULL THEN 20 ELSE ISNULL(SL.MaxStock,0) END , 
				CASE WHEN SL.CategoryID IS NULL THEN 1 ELSE ISNULL(SL.OptStock,0) END , 
				ISNULL(SL.Overstock,0), 
				SL.SARSdirty, ISNULL(SL.Capacity,0), SL.Active,
				ISNULL(CM.StockMult,1), ISNULL(CM.StockBuffer,0),
				Round((ISNULL(SL.Capacity,0) * ISNULL(CM.StockMult,1)) - 0.0000000000001,0,0) + CAST((Round((ISNULL(SL.Capacity,0) * ISNULL(CM.StockMult,1))  - 0.0000000000001,0,0) * ISNULL(CM.StockBuffer,0)/100) AS Int)
				FROM dbo.Category C
				INNER JOIN dbo.StockLevel SL 
					ON C.category_id = SL.CategoryID
					AND SL.LocationID = @LocationID
				LEFT JOIN dbo.CapacityModifier CM 
					ON CM.SCID = C.SCID 
					AND CM.LocationID = @LocationID
				WHERE 
					SL.SARSdirty = 1 
				ORDER BY 
					C.category_id
			END
			ELSE IF @SarsMode = 'FULL'
			BEGIN
			
				INSERT INTO dbo.SARSLog(SARSRunDate,LocationID, LogMessage) values(getdate(),@LocationID, 'Full mode: All categories will be processed');

				INSERT INTO #CatList(CategoryID,box_category,
				MinStock,
				MaxStock,
				OptStock,
				Overstock,
				SARSdirty,StockCapacity,Active,Capacitymodifier,
				Capacitybuffer,EffCapacity)
				SELECT 
				C.category_id, C.box_category, 
				CASE WHEN SL.CategoryID IS NULL THEN 0 ELSE ISNULL(SL.MinStock,0) END , 
				CASE WHEN SL.CategoryID IS NULL THEN 20 ELSE ISNULL(SL.MaxStock,0) END , 
				CASE WHEN SL.CategoryID IS NULL THEN 1 ELSE ISNULL(SL.OptStock,0) END , 
				ISNULL(SL.Overstock,0), 
				SL.SARSdirty, ISNULL(SL.Capacity,0), SL.Active,
				ISNULL(CM.StockMult,1), ISNULL(CM.StockBuffer,0),
				Round((ISNULL(SL.Capacity,0) * ISNULL(CM.StockMult,1)) - 0.0000000000001,0,0) + CAST((Round((ISNULL(SL.Capacity,0) * ISNULL(CM.StockMult,1)) - 0.0000000000001,0,0) * ISNULL(CM.StockBuffer,0)/100) AS Int)
				FROM dbo.Category C
				LEFT OUTER JOIN dbo.StockLevel SL 
					ON C.category_id = SL.CategoryID
					AND SL.LocationID = @LocationID
				LEFT OUTER JOIN dbo.CapacityModifier CM 
					ON CM.SCID = C.SCID 
					AND CM.LocationID = @LocationID
				ORDER BY C.category_id
			END
			ELSE
			BEGIN
				
				INSERT INTO dbo.SARSLog(SARSRunDate,LocationID, LogMessage) 
				VALUES(getdate(),@LocationID, 'Unknown parameter for mode '  + @SarsMode + ', (Use "About", "Update" or "Full".)');
				
				SET @SkipCurrentLocation = 1;
			
			END
			
			UPDATE #CatList SET EffCapacity = (CASE WHEN (EffCapacity < 0) THEN 0 ELSE EffCapacity END)
			
			IF @SkipCurrentLocation = 0 
			BEGIN 
				IF NOT EXISTS(SELECT 1 FROM #CatList)
				BEGIN
				
					INSERT INTO dbo.SARSLog(SARSRunDate,LocationID,LogMessage) 
					VALUES(getdate(),@LocationID, 'List of categories to process for LocationID is empty. No work to do.');
				
				END
				
				SELECT @MinSeqID = MIN(SeqID),@MaxSeqID = MAX(SeqID) 
				FROM #CatList

				WHILE @MinSeqID <= @MaxSeqID
				BEGIN

					SELECT @CatID = CategoryID,
						@EffCapacity = ISNULL(EffCapacity,0),
						@TotalStock = ISNULL(TotalStock,0),
						@CatAdvertise = ISNULL(CatAdvertise,0),
						@BoxCategory = Box_Category,
						@MinLevel = minstock,
						@MaxLevel = MaxStock,
						@OptLevel = OptStock
					FROM #CatList 
					WHERE SeqID = @MinSeqID 
					
					INSERT INTO #CatBoxStock(BoxID,CategoryID,Box_Category,OldReorderLevel,NewReorderLevel,Stock)
					SELECT    
						B.box_id, 
						C.Category_ID,
						B.Box_Category,
						BS.ReorderLevel, 
						0,
						(CASE WHEN BS.QuantityOnHand < 0 THEN 0 ELSE BS.QuantityOnHand END)
					FROM boxes B
					INNER JOIN category C 
						ON B.box_category = C.box_category
					INNER JOIN BoxStock BS 
						ON  B.box_id = BS.Boxid
						AND BS.LocationID = @LocationID
					WHERE 
						C.Category_Id = @CatID
						AND (B.Stockable = 1) 
						 
					OPTION(RECOMPILE)
				

					/****Calculate NewReorderLevel & Category Request or Advestise ****/
					DECLARE CalcNewReorderLevel CURSOR FOR
					SELECT BoxID,ISNULL(Stock,0),NewReorderLevel 
					FROM #CatBoxStock 
					WHERE CategoryID = @CatID 
					ORDER BY BoxID;

					OPEN CalcNewReorderLevel;

					FETCH NEXT FROM CalcNewReorderLevel INTO @BoxID,@Stock,@NewReorderLevel

					WHILE @@FETCH_STATUS = 0
					BEGIN
						--Need to request more stock
						IF @Stock < @MinLevel
						BEGIN
							UPDATE #CatBoxStock 
							SET NewReorderLevel = @OptLevel-@Stock 
							WHERE BoxID = @BoxID 
							AND CategoryID = @CatID;
							
							SET @CatReq = @CatReq + (@OptLevel-@Stock);
						END
						
						--Need to advertise some stock
						IF @Stock > @MaxLevel
						BEGIN
							UPDATE #CatBoxStock 
							SET NewReorderLevel = @OptLevel-@Stock  
							WHERE BoxID = @BoxID 
							AND CategoryID = @CatID;
							
							SET @CatAdvertise = @CatAdvertise + (@OptLevel-@Stock);
						END

						FETCH NEXT FROM CalcNewReorderLevel INTO @BoxID,@Stock,@NewReorderLevel
					END

					CLOSE CalcNewReorderLevel;
					DEALLOCATE CalcNewReorderLevel;
					
					--Calculate Total Available Stock in the category
					SET @TotalStock = (SELECT SUM(Stock) FROM #CatBoxStock WHERE CategoryID = @CatID )

					UPDATE #CatList SET CatRequest = @CatReq, CatAdvertise = @CatAdvertise, TotalStock = @TotalStock WHERE SeqID = @MinSeqID

					--All the boxes in this cat have had reorder levels calculated. Check for overstock
					IF (@TotalStock + @CatAdvertise) > @EffCapacity
					BEGIN
						
						SET @OverStock = @TotalStock + @CatAdvertise  - @EffCapacity;

						IF @OverStock > 0
						BEGIN
							INSERT INTO dbo.SARSLog(SARSRunDate,LocationID,CategoryID,LogMessage) values
							(getdate(),@LocationID,@CatID,('Category "' + @BoxCategory + '" is overstocked by ' + Cast(@OverStock as varchar(20)) + ' units. Corrective measures taken.'));
						END				

						--Remove all box requests		
						IF @OverStock > 0 
						BEGIN
							UPDATE #CatBoxStock 
							SET NewReorderLevel = 0 
							WHERE 
								NewReorderLevel > 0 
								AND CategoryID = @CatID;
						END
			 
						--find the largest box stock level after adjusting for advertisments
						SELECT @LargestStock = MAX(Stock + NewReorderLevel) 
						FROM #CatBoxStock 
						WHERE CategoryID = @CatID;

						WHILE @OverStock > 0
						BEGIN
											
							DECLARE BoxListCrsr CURSOR FOR
							SELECT BoxID,ISNULL(Stock,0),ISNULL(NewReorderLevel,0) 
							FROM #CatBoxStock 
							WHERE CategoryID = @CatID
							ORDER BY BoxID

							OPEN BoxListCrsr;

							FETCH NEXT FROM BoxListCrsr INTO @BoxID,@Stock,@NewReorderLevel

							WHILE @@FETCH_STATUS = 0
							BEGIN
								
								IF @Stock + @NewReorderLevel = @LargestStock
								BEGIN
								
									IF @OverStock > 0
									BEGIN
										SET @NewReorderLevel = @NewReorderLevel - 1
										SET @OverStock = @OverStock - 1
									END

								END

								UPDATE #CatBoxStock SET NewReorderLevel = @NewReorderLevel WHERE BoxID = @BoxID AND CategoryID = @CatID

								FETCH NEXT FROM BoxListCrsr INTO @BoxID,@Stock,@NewReorderLevel
							END
							
							CLOSE BoxListCrsr;
							DEALLOCATE BoxListCrsr;
							
							SET @CatProcessedCnt = @CatProcessedCnt + 1;
							
							SET @LargestStock = @LargestStock - 1

						END -- END OverStock Processing For Box level
					
					END -- END IF OverStocked
					
					UPDATE B1 
					SET B1.ReorderLevel = B2.NewReorderLevel
					FROM dbo.BoxStock B1
					INNER JOIN #CatBoxStock B2 
						ON B1.Boxid = B2.BoxID
					WHERE 
						B1.LocationID = @LocationID 
						AND B1.ReorderLevel <> B2.NewReorderLevel
	
					UPDATE S1 SET StockHolding = ISNULL(TotalStock,0)
					FROM dbo.StockLevel S1
					LEFT JOIN #CatList C1 
						ON S1.CategoryID = C1.CategoryID
						AND S1.LocationID = @LocationID 
					WHERE 
						 S1.CategoryID = @CatID
					
					SET @CatProcessedCnt = @CatProcessedCnt + 1;
					
					SET @MinSeqID = @MinSeqID + 1
					
					TRUNCATE TABLE #CatBoxStock;
				
				END --END FOR EACH CATEGORY

				UPDATE dbo.StockLevel 
				SET LastSARSrun = GETDATE(),SARSdirty = 0 
				WHERE LocationID = @LocationID

				INSERT INTO dbo.SARSLog(SARSRunDate,LocationID,LogMessage) 
				VALUES(getdate(),@LocationID,'Categories Processed : ' + Cast(@CatProcessedCnt as varchar(20)));
			END -- END Not Skipped Location
				
			SET @CatProcessedCnt = 0;
			
			FETCH NEXT FROM branchList INTO @LocationID,@Branchkey

			TRUNCATE TABLE #CatList;
			
		END --END Location

		CLOSE branchList;
		DEALLOCATE branchList;
		
		DROP TABLE #CatList;
		DROP TABLE #CatBoxStock

	END TRY
	BEGIN CATCH
		
		IF (SELECT OBJECT_ID('#CatList')) IS NOT NULL
			DROP TABLE #CatList;
		IF (SELECT OBJECT_ID('#CatBoxStock')) IS NOT NULL
			DROP TABLE #CatBoxStock;
			
		CLOSE branchList;
		DEALLOCATE branchList;

		CLOSE BoxListCrsr;
		DEALLOCATE BoxListCrsr;

		DECLARE @ErrorNumber INT = ERROR_NUMBER();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();
 
		PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
		
	END CATCH

	SET NOCOUNT OFF
END

GO

/********
DBCASE :- DB-1326
EXECUTED DATE :- (2018-04-24)
DESCRIPTION :- Request to increase addresses column size for branches table
*********/


ALTER TABLE Branches
alter column [address_1] [varchar](60) NULL 
go
ALTER TABLE Branches
alter column [address_2] [varchar](60) NULL 
GO

/********
DBCASE :- DB-3018
EXECUTED DATE :- (2018-05-03)
DESCRIPTION :- Create kiwiservices on live All National and Stores
*********/

DISABLE TRIGGER [DenyDDLOperation] ON ALL SERVER

GO
USE [master]
GO
CREATE LOGIN [kiwiservices] WITH PASSWORD=N'<password>', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [Epos2000]
GO
CREATE USER [kiwiservices] FOR LOGIN [kiwiservices]
GO
USE [Epos2000]
GO
ALTER ROLE [db_datareader] ADD MEMBER [kiwiservices]
GO
USE [Epos2000]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [kiwiservices]
GO

ENABLE TRIGGER [DenyDDLOperation] ON ALL SERVER
GO
/********
DBCASE :- DB-3985
EXECUTED DATE :- (2018-05-18)
DESCRIPTION :- Create DB script to add new tables CustomerAttributeType and 
CustomerAttribute on store and national database
*********/
/**** create table CustomerAttributeType ****/
CREATE TABLE [dbo].[CustomerAttributeType] (
[ID] [int] NOT NULL,
[Name] [varchar] (20) NOT NULL,
[Active] [bit] NOT NULL,


PRIMARY KEY CLUSTERED
(
	[ID] ASC
)

) ON [PRIMARY]

/**** create table CustomerAttribute ****/

CREATE TABLE [dbo].[CustomerAttribute](
	[BranchKey] [varchar](6) NOT NULL,
	[AccountID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[Value] [varchar](250) NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[AccountID] ASC,
	[TypeID] ASC
)

) ON [PRIMARY]

ALTER TABLE [dbo].[CustomerAttribute]  WITH CHECK ADD FOREIGN KEY([TypeID])
REFERENCES [dbo].[CustomerAttributeType] ([ID]);

/**** grant permission ****/

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.CustomerAttribute TO kiwiservices;  
GO

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.CustomerAttributeType TO kiwiservices;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.CustomerAttribute TO eposv2;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.CustomerAttributeType TO eposv2;  
GO 

/********
DBCASE :- DB-3298
EXECUTED DATE :- (2018-06-11)
DESCRIPTION :- Drop Unused Columns from Charity table
*********/


/****AccountNumber****/
DECLARE @ConstraintName nvarchar(200)

SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS 
WHERE PARENT_OBJECT_ID = OBJECT_ID('CHARITY') 
	AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'AccountNumber' AND object_id = OBJECT_ID(N'CHARITY'))

IF @ConstraintName IS NOT NULL
	EXEC('ALTER TABLE CHARITY DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('CHARITY') AND name='AccountNumber')
	EXEC('ALTER TABLE CHARITY DROP COLUMN AccountNumber')
GO

/****AccountName****/
DECLARE @ConstraintName nvarchar(200)

SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS 
WHERE PARENT_OBJECT_ID = OBJECT_ID('CHARITY') 
	AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'AccountName' AND object_id = OBJECT_ID(N'CHARITY'))

IF @ConstraintName IS NOT NULL
	EXEC('ALTER TABLE CHARITY DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('CHARITY') AND name='AccountName')
	EXEC('ALTER TABLE CHARITY DROP COLUMN AccountName')
GO


/****RollNumber****/
DECLARE @ConstraintName nvarchar(200)

SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS 
WHERE PARENT_OBJECT_ID = OBJECT_ID('CHARITY') 
	AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'RollNumber' AND object_id = OBJECT_ID(N'CHARITY'))

IF @ConstraintName IS NOT NULL
	EXEC('ALTER TABLE CHARITY DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('CHARITY') AND name='RollNumber')
	EXEC('ALTER TABLE CHARITY DROP COLUMN RollNumber')
GO


/****SortCode****/
DECLARE @ConstraintName nvarchar(200)

SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS 
WHERE PARENT_OBJECT_ID = OBJECT_ID('CHARITY') 
	AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns WHERE NAME = N'SortCode' AND object_id = OBJECT_ID(N'CHARITY'))

IF @ConstraintName IS NOT NULL
	EXEC('ALTER TABLE CHARITY DROP CONSTRAINT ' + @ConstraintName)
IF EXISTS (SELECT * FROM syscolumns WHERE id=object_id('CHARITY') AND name='SortCode')
	EXEC('ALTER TABLE CHARITY DROP COLUMN SortCode')
GO

/***
	Stored Procedure to Insert / update branchsetting
***/

/********
DBCASE :- DB-3660
EXECUTED DATE :- (2018-06-19)
DESCRIPTION :- Add ReceivedAs Column to StockTransfertype table
*********/

ALTER TABLE StockTransferType ADD ReceivedAs INT NOT NULL DEFAULT 0; 

/********
DBCASE :- DB-1336
EXECUTED DATE :- (2018-06-19)
DESCRIPTION :- Create a new column called Description in BranchSetting table
*********/
ALTER TABLE BranchSetting
	ADD [Description] varchar(200)
	
/********
DBCASE :- DB-3548
EXECUTED DATE :- (2018-06-20)
DESCRIPTION :- Increase length of AuditTrail.Text column
*********/

alter table [dbo].[AuditTrail] ALTER COLUMN text varchar(1000)
GO
Alter Table [Errors] Alter Column [ErrDescription] varchar(1000) 

/********
DBCASE :- DB-3549
EXECUTED DATE :- (2018-06-20)
DESCRIPTION :- Increase length of Errors.ErrDescription column
*********/

GO
USE [Epos2000]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertUpdate_Branchsetting]    Script Date: 8/22/2018 11:27:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[usp_InsertUpdate_Branchsetting]
(
	@Hivekey varchar(50),
	@Subkey varchar(50),
	@Value nvarchar(2000),
	@Description varchar(200),
	@IsNational char(1) = 'N'	--Optional
)
AS
--TEST CASE : 
--For Natioal --> EXEC dbo.usp_InsertUpdate_Branchsetting @Hivekey = 'Store',@Subkey = 'Test',@Value = '1',@Description = 'TEST Desc',@IsNational='Y'
--For Store --> EXEC dbo.usp_InsertUpdate_Branchsetting @Hivekey = 'Store',@Subkey = 'Test',@Value = '1',@Description = 'TEST Desc',@IsNational='N'
--CREATED DATE :
--DESCRIPTION : This procedure is created to Insert New Branchsetting 
--	or Update existing. It takes care of Single & Multi-tenant store
BEGIN
	SET NOCOUNT ON
		
	DECLARE @MinID smallint
	DECLARE @MaxID smallint
	DECLARE @Branchkey varchar(6)
	
	DECLARE @StoreBranchkeys TABLE
	(
		ID int identity(1,1),
		Branchkey varchar(6)
	)

	IF @IsNational = 'Y'
		INSERT INTO @StoreBranchkeys SELECT 'HQ'
	ELSE
	BEGIN	
		INSERT INTO @StoreBranchkeys
		SELECT DISTINCT Branchkey FROM dbo.Branchsetting 
		WHERE Branchkey <> 'HQ' AND ISNULL(Branchkey,'') <> '' AND LEN(Branchkey) > 1

		IF(SELECT COUNT(1) FROM @StoreBranchkeys) = 0
		BEGIN
			INSERT INTO @StoreBranchkeys
			SELECT Branchkey FROM dbo.Branches WHERE ServerName = @@SERVERNAME
		END
	END

	SELECT @MinID = MIN(ID),@MaxID = MAX(ID) FROM @StoreBranchkeys

	WHILE @MinID <= @MaxID
	BEGIN

		SELECT @Branchkey = Branchkey FROM @StoreBranchkeys WHERE ID = @MinID

		IF EXISTS(SELECT 1 FROM dbo.BranchSetting WHERE Branchkey = @Branchkey AND HiveKey = @Hivekey AND SubKey = @Subkey)
			UPDATE dbo.BranchSetting 
				SET Value = @Value, [Description] = @Description 
			WHERE Branchkey = @Branchkey AND HiveKey = @Hivekey AND SubKey = @Subkey
		ELSE
			INSERT INTO dbo.BranchSetting(HiveKey,BranchKey,SubKey,Value,[Description]) 
				values(@HiveKey,@BranchKey,@SubKey,@Value,@Description)
		
		
		SET @MinID = @MinID + 1
	END

	SELECT * FROM dbo.BranchSetting WHERE HiveKey = @Hivekey AND SubKey = @Subkey

	SET NOCOUNT OFF
END





GO
/********
DBCASE :- DB-4307
EXECUTED DATE :- (2018-07-05)
DESCRIPTION :- Script to alter schema of OperatingCompany table to add new columns for address fields on store and National DB and INTRA DB
*********/
GO

ALTER TABLE OperatingCompany ADD 
Address_1 VARCHAR(60),
Address_2 VARCHAR(60),
City VARCHAR(30),
County VARCHAR(30),
Post_Code VARCHAR(15)
GO



/********
DBCASE :- DB-4362
EXECUTED DATE :- (2018-07-25)
DESCRIPTION :- Create new table SAFTInternalReceieptCodes in Store DB
*********/

CREATE TABLE [dbo].[SAFTInternalReceiptCodes](
	[Id] [int] NOT NULL,
	[InternalCode] [varchar](5) NOT NULL,
	[Series] [varchar](8) NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)

) ON [PRIMARY]

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.SAFTInternalReceiptCodes TO eposv2 
GO 

/********
DBCASE :- DB-4402
EXECUTED DATE :- (2018-08-13)
DESCRIPTION :- Create new table orderAttribute and orderAttributeType in Store DB and NAtional Db 
also set the replication from store to national for orderAttribute table.
*********/

USE [Epos2000]

GO

CREATE TABLE [dbo].[OrderAttributeType](
[TypeId] [int] NOT NULL,
[Name] [varchar] (20) NOT NULL,
[Active] [bit] NOT NULL,

PRIMARY KEY CLUSTERED
(
	[TypeId] ASC
) 
) ON [PRIMARY]

-- script to be exected on all store and national MSSQL databse
-- script to create table orderAttribute

USE [Epos2000]

GO

CREATE TABLE [dbo].[OrderAttribute] (
  [BranchKey] [varchar](6) NOT NULL,
  [OrderId] [int] NOT NULL,
  [TypeId] [int] NOT NULL,
  [Value] [varchar] (255) NOT NULL

PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[OrderId] ASC,
	[TypeID] ASC
)

) ON [PRIMARY]

ALTER TABLE [dbo].[OrderAttribute] WITH CHECK ADD FOREIGN KEY([TypeId])
REFERENCES [dbo].[OrderAttributeType] ([TypeId])

/* permission script */

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.orderattribute TO kiwiservices;

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.orderattributetype TO kiwiservices;

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.orderattribute TO eposv2;  

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.orderattributetype TO eposv2;  
	       
/********
DBCASE :- DB-4542
EXECUTED DATE :- (2018-08-23)
DESCRIPTION :- Increase the size of column Value in BranchSetting table to nvarchar(2000)
*********/
	       
Alter Table BranchSetting Alter Column Value nvarchar(2000) Null
GO
/********
DBCASE :- DB-4546
EXECUTED DATE :- (2018-08-23)
DESCRIPTION :- Add new column NextResetDate to Numbers table
*********/
ALTER TABLE numbers ADD NextResetDate DATE	       
GO	       

/********
DBCASE :- PII Poject Schema Changes
EXECUTED DATE :- (2018-08-23)
DESCRIPTION :- Script for all new tables introduced in PII project
*********/

CREATE TABLE [dbo].[Banking_Data_enc](
	[z_id] [int] NOT NULL,
	[BranchKey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[OpenBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__Banking_Data_OpenBagSeal]  DEFAULT (' '),
	[ExpectedOpenBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF__Banking_Data_ExpOpenBagSeal]  DEFAULT (' '),
	[CloseBagSeal] [varchar](32) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__Banking_Data_CloseBagSeal]  DEFAULT (' '),
	[BagSealNote] [varchar](255) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__Banking_Data_BagSealNote]  DEFAULT (' '),
	[OpenStaff] [varchar](125) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__Banking_Data_OpenStaff]  DEFAULT (' '),
 CONSTRAINT [PK_Banking_Data_BranchKey_zid] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[z_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT DELETE ON [dbo].[Banking_Data_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[Banking_Data_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[Banking_Data_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[Banking_Data_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[Banking_Data_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[Banking_Data_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[Banking_Data_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[Banking_Data_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[Banking_Data_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[Banking_Data_enc] TO [eposv2] AS [dbo]
GO

CREATE TABLE [dbo].[DBQueueDetail_enc](
	[BranchKey] [varchar](6) NOT NULL,
	[QueueDetailId] [int] NOT NULL,
	[QueueId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DBQueueDetail_enc] ADD [KeyName] [varchar](255) NULL
ALTER TABLE [dbo].[DBQueueDetail_enc] ADD [Value] [varchar](1275) NULL
 CONSTRAINT [PK_DBQueueDetail_enc_BranchKey_QueueDetailId] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[QueueDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]

GO
GRANT DELETE ON [dbo].[DBQueueDetail_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[DBQueueDetail_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[DBQueueDetail_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[DBQueueDetail_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[DBQueueDetail_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[DBQueueDetail_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[DBQueueDetail_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[DBQueueDetail_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[DBQueueDetail_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[DBQueueDetail_enc] TO [eposv2] AS [dbo]
GO
ALTER TABLE [dbo].[DBQueueDetail_enc]  WITH CHECK ADD  CONSTRAINT [FK_DBQueueDetail_enc_DBQueue] FOREIGN KEY([BranchKey], [QueueId])
REFERENCES [dbo].[DBQueue] ([BranchKey], [QueueId])
GO
ALTER TABLE [dbo].[DBQueueDetail_enc] CHECK CONSTRAINT [FK_DBQueueDetail_enc_DBQueue]
GO

CREATE TABLE [dbo].[MobilePhone_enc](
	[BranchKey] [varchar](6) NOT NULL,
	[MobileID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IMEI] [varchar](50) NOT NULL,
	[SecurityCode] [varchar](60) NULL,
	[BuyinOrderID] [int] NOT NULL,
	[DiscountedNote] [varchar](255) NULL,
	[Boxid] [varchar](20) NOT NULL,
	[Network] [varchar](20) NOT NULL,
 CONSTRAINT [PK_BranchKey_MobileID_MobilePhone_enc] PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[MobileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT DELETE ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT ALTER ON [dbo].[MobilePhone_enc] TO [boffice] AS [dbo]
GO
GRANT ALTER ON [dbo].[MobilePhone_enc] TO [eposv2] AS [dbo]
GO
GRANT ALTER ON [dbo].[MobilePhone] TO [boffice] AS [dbo]
GO
GRANT ALTER ON [dbo].[MobilePhone] TO [eposv2] AS [dbo]
GO


CREATE TABLE [dbo].[OperatingCompany_enc](
	[OCID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RegName] [varchar](255) NULL,
	[RegCountry] [varchar](32) NULL,
	[RegNumber] [varchar](32) NULL,
	[ShortName] [varchar](6) NULL,
	[UmbrellaCompany] [varchar](255) NULL,
	[CompanyEmailAddress] [varchar](500) NULL,
    [Address_1] VARCHAR(60),
	[Address_2] VARCHAR(60),
	[City] VARCHAR(30),
	[County] VARCHAR(30),
	[Post_Code] VARCHAR(15)
 CONSTRAINT [PK_OperatingCompany_enc] PRIMARY KEY CLUSTERED 
(
	[OCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [unq_regname_operatingcompany_enc] UNIQUE NONCLUSTERED 
(
	[RegName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT DELETE ON [dbo].[OperatingCompany_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[OperatingCompany_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[OperatingCompany_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[OperatingCompany_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[OperatingCompany_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[OperatingCompany_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[OperatingCompany_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[OperatingCompany_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[OperatingCompany_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[OperatingCompany_enc] TO [eposv2] AS [dbo]
GO
GRANT DELETE ON [dbo].[OperatingCompany_enc] TO [kiwiservices] AS [dbo]
GO
GRANT INSERT ON [dbo].[OperatingCompany_enc] TO [kiwiservices] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[OperatingCompany_enc] TO [kiwiservices] AS [dbo]
GO
GRANT SELECT ON [dbo].[OperatingCompany_enc] TO [kiwiservices] AS [dbo]
GO
GRANT UPDATE ON [dbo].[OperatingCompany_enc] TO [kiwiservices] AS [dbo]
GO

CREATE TABLE [dbo].[staff_enc](
	[staff_id] [int] NOT NULL,
	[staff] [varchar](125) NULL,
	[staff_email_name] [varchar](125) NULL,
	[home_branchID] [int] NULL,
	[security_level] [int] NULL,
	[TagNumber] [varchar](6) NULL,
	[initials] [char](2) NULL,
	[FullName] [varchar](240) NULL,
	[Staff_number] [varchar](12) NULL,
	[Entrydate] [datetime] NULL,
	[Leaverdate] [datetime] NULL,
	[DateOfBirth] [varchar](255) NULL,
	[PlatformID] [int] NULL,
	[VersionNumber] [varchar](20) NULL,
 CONSTRAINT [PK_staff_staff_id] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ__Staff_TagNumber] UNIQUE NONCLUSTERED 
(
	[TagNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT DELETE ON [dbo].[staff_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[staff_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[staff_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[staff_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[staff_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[staff_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[staff_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[staff_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[staff_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[staff_enc] TO [eposv2] AS [dbo]
GO

CREATE TABLE [dbo].[Users_enc](
	[staff_id] [int] NOT NULL,
	[Title] [varchar](16) NOT NULL,
	[Firstname] [varchar](250) NOT NULL,
	[Surname] [varchar](250) NOT NULL,
	[Sex] [char](1) NOT NULL,
	[Email] [varchar](1275) NOT NULL,
	[Password] [varchar](32) NOT NULL,
	[JobTitle] [varchar](300) NULL,
	[JobType] [int] NULL,
	[WorkPhone] [varchar](125) NULL,
	[WorkExtension] [varchar](50) NULL,
	[MobilePhone] [varchar](125) NULL,
	[VoipPhone] [varchar](512) NULL,
	[SpeedDial] [varchar](250) NULL,
	[ReportsTo] [int] NOT NULL,
	[active] [bit] NOT NULL CONSTRAINT [DF__Staff_active]  DEFAULT ((1)),
	[isActing] [bit] NOT NULL CONSTRAINT [DF__Users_isActing]  DEFAULT ((0)),
	[payType] [int] NULL,
	[MustChangePasword] [bit] NOT NULL CONSTRAINT [DF__Users_MustChangePasword]  DEFAULT ((0)),
	[LastLogin] [datetime] NULL,
	[Username] [varchar](250) NOT NULL,
	[DateOfBirth] [varchar](255) NULL,
 CONSTRAINT [PK_Staff_StaffID] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT DELETE ON [dbo].[Users_enc] TO [boffice] AS [dbo]
GO
GRANT INSERT ON [dbo].[Users_enc] TO [boffice] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[Users_enc] TO [boffice] AS [dbo]
GO
GRANT SELECT ON [dbo].[Users_enc] TO [boffice] AS [dbo]
GO
GRANT UPDATE ON [dbo].[Users_enc] TO [boffice] AS [dbo]
GO
GRANT DELETE ON [dbo].[Users_enc] TO [eposv2] AS [dbo]
GO
GRANT INSERT ON [dbo].[Users_enc] TO [eposv2] AS [dbo]
GO
GRANT REFERENCES ON [dbo].[Users_enc] TO [eposv2] AS [dbo]
GO
GRANT SELECT ON [dbo].[Users_enc] TO [eposv2] AS [dbo]
GO
GRANT UPDATE ON [dbo].[Users_enc] TO [eposv2] AS [dbo]
GO

CREATE VIEW [dbo].[vwAPAttendance_enc] AS
Select O.staff_id, O.Branchkey,  S.Fullname, convert(char(12), O.Order_date, 103) as TradingDate, convert(char(12), O.Order_date, 112) as SortDate, 'First' = Convert(varchar(12), Min(O.Order_Date),108),
'Last' = convert(char(12),Max(O.Order_Date),108), Totals = Count(O.Staff_ID) 
from staff_enc as S JOIN orders as O on
(s.staff_id = O.staff_id) 
Group by O.staff_id, O.Branchkey, S.FullName, convert(char(12), O.Order_date, 103), convert(char(12), O.Order_date, 112)

GO

GRANT SELECT ON [dbo].[vwAPAttendance_enc] TO eposv2
GRANT SELECT ON [dbo].[vwAPAttendance_enc] TO boffice

GO


CREATE VIEW [dbo].[vwAPRefundReasons_enc] AS
Select orders.order_id, orders.branchkey, orders.order_date, orders.staff_id, boxes.box_name, boxes.box_category, refunds.explanation,  refunds.authorisedbyID, refunds.originalorderid, refunds.originalbranchkey, staff_enc.staff 
from 
(orders inner join refunds on orders.order_id = refunds.orderid and orders.branchkey = refunds.branchkey
left outer join staff_enc on orders.staff_id = staff_enc.staff_id)
inner join order_details on orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey
inner join boxes on order_details.box_id = boxes.box_id
where orders.order_type = 4 and orders.processed = 1

GO

GRANT SELECT ON [dbo].[vwAPRefundReasons_enc] TO eposv2
GRANT SELECT ON [dbo].[vwAPRefundReasons_enc] TO boffice

GO

CREATE VIEW [dbo].[vwAPRefundTypes_enc] AS
Select staff_enc.staff, orders.order_id, orders.staff_id, orders.branchkey, orders.order_date, orderpaymentelements.clearingamount, paymentmethods.paymentmethod 
from orders inner join orderpaymentelements
on orders.order_id = orderpaymentelements.orderid and orders.branchkey = orderpaymentelements.branchkey
inner join paymentmethods on orderpaymentelements.paymentmethodid = paymentmethods.paymentmethodid
inner join staff_enc on orders.staff_id = staff_enc.staff_id
where orders.order_type = 4 and orders.processed = 1

GO

GRANT SELECT ON [dbo].[vwAPRefundTypes_enc] TO eposv2
GRANT SELECT ON [dbo].[vwAPRefundTypes_enc] TO boffice

GO


CREATE
VIEW [dbo].[vwAuditTrailReport_enc] AS

select
AuditTrail.BranchKey,
AuditTrail.Branch_ID,
AuditEntryTypes.EntryType,
AuditEntryTypes.Description,
AuditTrail.EntryDate,
AuditTrail.box_id,
staff_enc.staff,
s1.staff as AuthorizedBy,
staff_enc.staff_id,
AuditTrail.Text          
from AuditEntryTypes 
inner join AuditTrail on AuditEntryTypes.EntryType=AuditTrail.EntryType
inner join staff_enc on staff_enc.staff_id=AuditTrail.StaffID
left join staff_enc s1 on AuditTrail.SuperID=s1.staff_id

GO

GRANT SELECT ON [dbo].[vwAuditTrailReport_enc] TO eposv2
GRANT SELECT ON [dbo].[vwAuditTrailReport_enc] TO boffice

GO

CREATE VIEW [dbo].[vwNewOrderItemList_enc] AS
Select orders.order_type, Orders.Order_ID, Orders.branchkey, orders.branchkey + convert(char(8), orders.order_id) as CompOrder, ordertypes.description, transactiontypes.description as transtype, 
Orders.order_date,orders.processed, orders.staff_id, orders.branch_id, Order_details.box_id, boxes.box_name, staff_enc.staff 
from order_details, orders, ordertypes, transactiontypes, boxes, staff_enc 
where orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey 
and orders.order_type = ordertypes.id 
and order_details.box_id = boxes.box_id 
and order_details.txtype = transactiontypes.id
and staff_enc.staff_id = orders.staff_id

GO

GRANT SELECT ON [dbo].[vwNewOrderItemList_enc] TO eposv2
GRANT SELECT ON [dbo].[vwNewOrderItemList_enc] TO boffice

GO

CREATE VIEW [dbo].[vwPurchaseOrderStatus_enc] AS
select PurchaseOrders.*, PODeliveries.ENtryID, PODeliveries.POID, PODeliveries.OrderID, 
PODeliveries.DestinationBranchID, PODeliveries.Completed, PODeliveries.discrepancy, orders.Order_ID, staff_enc.staff,
branches.branchname, branches.abbrev, branches.address_1, supplierinfo.companyname
from purchaseorders, podeliveries, orders, staff_enc, branches, supplierinfo
where purchaseorders.PurchaseOrderID = PODeliveries.POID
and PODeliveries.orderid = orders.order_id
and staff_enc.staff_id = purchaseorders.buyer_staffid
and branches.branchid = PODeliveries.destinationbranchid
and purchaseorders.supplierid = supplierinfo.supplierid

GO

GRANT SELECT ON [dbo].[vwPurchaseOrderStatus_enc] TO eposv2
GRANT SELECT ON [dbo].[vwPurchaseOrderStatus_enc] TO boffice

GO

CREATE VIEW [dbo].[vwReserveInfo_enc] AS 
Select reserves.*, orders.order_date, branches.branchid, branches.branchname, branches.abbrev, staff_enc.staff 
from reserves, orders, branches, staff_enc 
where reserves.orderid = orders.order_id 
and orders.staff_id = staff_enc.staff_id
and orders.branch_id = branches.branchid 

GO

GRANT SELECT ON [dbo].[vwReserveInfo_enc] TO eposv2
GRANT SELECT ON [dbo].[vwReserveInfo_enc] TO boffice

GO

CREATE VIEW [dbo].[vwXLOrderDetail_enc] AS
Select orders.order_type, Orders.Order_ID, Orders.branchkey, orders.branchkey + convert(char(8), orders.order_id) as CompOrder, ordertypes.description, transactiontypes.description as transtype, Orders.order_date,orders.processed, orders.staff_id, 
orders.branch_id, Order_details.box_id, Order_details.price, Order_details.quantity, boxes.box_name, staff_enc.staff 
from order_details, orders, ordertypes, transactiontypes, boxes, staff_enc 
where orders.order_id = order_details.order_id and orders.branchkey = order_details.branchkey 
and orders.order_type = ordertypes.id 
and order_details.box_id = boxes.box_id 
and order_details.txtype = transactiontypes.id
and staff_enc.staff_id = orders.staff_id
and orders.processed = 1

GO

GRANT SELECT ON [dbo].[vwXLOrderDetail_enc] TO eposv2
GRANT SELECT ON [dbo].[vwXLOrderDetail_enc] TO boffice

GO

/********
DBCASE :- DB-4505
EXECUTED DATE :- (2018-09-25)
DESCRIPTION :- Increase size of Notes field in Customer table
*********/
USE Epos2000;
ALTER TABLE epos2000.dbo.Customer ALTER COLUMN Notes VARCHAR(400);
go
/********
DBCASE :- DB-4629
EXECUTED DATE :- (2018-09-25)
DESCRIPTION :- Add a new column ID1IssuedBy into Customer table
*********/
		       
USE Epos2000;
ALTER TABLE epos2000.dbo.Customer ADD ID1IssuedBy VARCHAR(50);
go
		       
/********
EXECUTED DATE :- (2018-10-30)
DESCRIPTION :- Grant permission to users
*********/
GRANT REFERENCES ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifierType] TO [eposv2]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifierType] TO [boffice]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifierType] TO [boffice]
GO
GRANT REFERENCES ON [dbo].[OrderDetailIdentifierType] TO [kiwiservices]
GO
GRANT SELECT ON [dbo].[OrderDetailIdentifierType] TO [kiwiservices]
GO

/********
DBCASE :- DB-4869
EXECUTED DATE :- (2018-12-05)
DESCRIPTION :- Add a new column ID1IssuedBy into Customer table
*********/		       
USE Epos2000;

ALTER TABLE WorkOrderDetail ADD TesterStaffId int;
		       
/********
DBCASE :- DB-4840
EXECUTED DATE :- (2019-01-17)
DESCRIPTION :- DB schema changes for SAF-T sales tax (Add new Tables, Alter Table countystates 
& Insert data into OrderDetailIdentifierType
*********/
USE [Epos2000]
GO
ALTER TABLE CountyStates ALTER COLUMN CountyStateCode VARCHAR(10) NOT NULL;
ALTER TABLE CountyStates ADD PRIMARY KEY(CountyStateCode);

USE [Epos2000]
GO

CREATE TABLE [dbo].[BranchAttributeType] (
[TypeId] [int] NOT NULL,
[Name] [varchar](50) NOT NULL,
[Active] [bit] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)

) ON [PRIMARY]

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.BranchAttributeType TO eposv2;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.BranchAttributeType TO kiwiservices;  
GO


USE [Epos2000]
GO

CREATE TABLE [dbo].[SalesTaxAttributeType] (
[TypeId] [int] NOT NULL,
[Name] [varchar](50) NOT NULL,
[Active] [bit] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)

) ON [PRIMARY]

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.SalesTaxAttributeType TO eposv2;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.SalesTaxAttributeType TO kiwiservices;  
GO


USE [Epos2000]
GO

CREATE TABLE [dbo].[BranchAttribute](
[BranchId] [int] NOT NULL,
[TypeId] [int] NOT NULL,
[Value] [varchar](50) NOT NULL
CONSTRAINT [PK_BranchAttribute] PRIMARY KEY CLUSTERED 
(
[BranchId] ASC,
[TypeId] ASC
)ON [PRIMARY]);

ALTER TABLE [dbo].[BranchAttribute]  WITH CHECK ADD FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branches] ([BranchId]);
ALTER TABLE [dbo].[BranchAttribute]  WITH CHECK ADD FOREIGN KEY([TypeId])
REFERENCES [dbo].[BranchAttributeType] ([TypeId]);
GO


GRANT SELECT,insert,update,delete,references ON epos2000.dbo.BranchAttribute TO eposv2;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.BranchAttribute TO kiwiservices;  
GO


USE [Epos2000]
GO

CREATE TABLE [dbo].[SalesTaxAttribute](
[CountyStateCode] [varchar](10) NOT NULL,
[TypeId] [int] NOT NULL,
[Value] [varchar](50) NOT NULL
CONSTRAINT [PK_SalesTaxAttribute] PRIMARY KEY CLUSTERED 
(
[CountyStateCode] ASC,
[TypeId] ASC
)ON [PRIMARY]);

ALTER TABLE [dbo].[SalesTaxAttribute]  WITH CHECK ADD FOREIGN KEY([CountyStateCode])
REFERENCES [dbo].[CountyStates] ([CountyStateCode]);
ALTER TABLE [dbo].[SalesTaxAttribute]  WITH CHECK ADD FOREIGN KEY([TypeId])
REFERENCES [dbo].[SalesTaxAttributeType] ([TypeId]);
GO

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.SalesTaxAttribute TO eposv2;  
GO 

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.SalesTaxAttribute TO kiwiservices;  
GO
/********
DBCASE :- DB-5085
EXECUTED DATE :- (2019-01-29)
DESCRIPTION :- Modify table OrderAttributeType - Change 'Name' column size in Store and National
*********/

ALTER TABLE OrderAttributeType
ALTER COLUMN Name VARCHAR(50)
Go
     
/********
DBCASE :- DB-5061
EXECUTED DATE :- (2019-01-31)
DESCRIPTION :- Update the composite key for OrderDetailIdentifier table in Store and National DB	
*********/
     
Go 
     
ALTER TABLE OrderDetailIdentifier
DROP CONSTRAINT PK_OrderDetailIdentifier_OrderDetailsId_Branchkey;
Go
     
ALTER TABLE OrderDetailIdentifier
ADD CONSTRAINT PK_OrderDetailIdentifier_OrderDetailsId_Branchkey PRIMARY KEY (OrderDetailsId, BranchKey, Type);

Go
     
     
/********
DBCASE :- DB-4946
EXECUTED DATE :- (2019-02-06)
DESCRIPTION :- Create two tables WorkstationActive and WorkstationAudit for Mepos banking related changes	
*********/
     
CREATE Table WorkstationAudit(
AuditID INT Identity(1,1)  NOT FOR REPLICATION NOT NULL,
WorkstationID VARCHAR(25) NOT NULL ,
DateTimeJoined DateTime NOT NULL,
StaffID INT NOT NULL,
DateTimeRemoved DateTime,
RemovedBy INT,
BranchKey VARCHAR(6) NOT NULL,
PlatformID INT NOT NULL Primary key (AuditID,BranchKey)
);
     
 go
     
CREATE Table WorkstationActive(
WorkstationID Varchar(25) NOT NULL,
StaffID INT NOT NULL,
DateTimeJoined DateTime NOT NULL,
BranchKey VARCHAR(6) NOT NULL,
PlatformID INT NOT NULL Primary key (WorkstationID,StaffID)
);
     
go
        GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to eposv2
	GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to boffice
	GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to kiwiservices
	
	GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationAudit to eposv2
	GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationAudit to boffice
	GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationAudit to kiwiservices
     go
 
/********
DBCASE :- 
EXECUTED DATE :- 
DESCRIPTION :- 	
*********/
     
/********
DBCASE :- DB-4810
EXECUTED DATE :- (2019-04-01)
DESCRIPTION :- Alter National and Store Category table to add BuyAllowed and SaleAllowed field	
*********/
     
ALTER TABLE category
ADD
BuyAllowed BIT NOT NULL DEFAULT 1;

go

ALTER TABLE category
ADD
SaleAllowed BIT NOT NULL DEFAULT 1;

go
     
     
/**********
DBCASE :- DB-5331
EXECUTED DATE :- (2019-04-15)
DESCRIPTION :- Add columns in lock table.
***********/

Alter table lock
ADD StaffId int

go

Alter table lock
ADD PlatformId int

go
     
     
/**********
DBCASE :- DB-5334 and DB-5392  
EXECUTED DATE :- (2019-05-13)
DESCRIPTION :- 1-Add PlatformId column to workstations - Store & National.
               2-Alter table WorkstationActive to add BranchKey to composite primary key
***********/
     
ALTER TABLE Workstations ADD PlatformID int not null Default 1 Constraint FK_Workstations FOREIGN KEY(PlatformID) REFERENCES Platform(ID);
go
 
ALTER TABLE WorkstationActive ADD CONSTRAINT PK_Workst_Staff_BranchKey PRIMARY KEY (WorkstationID,StaffID,BranchKey)
go

GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to eposv2
GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to boffice
GRANT SELECT, INSERT, UPDATE, DELETE on WorkstationActive to kiwiservices
  
go

/**********
DBCASE :- DB-5380  
EXECUTED DATE :- (2019-06-12)
DESCRIPTION :- Schema change for Lock table to change AppName, Lockedby columns to accept null values.
***********/

ALTER TABLE Lock ALTER COLUMN AppName VARCHAR(25) NULL;
ALTER TABLE Lock ALTER COLUMN Lockedby VARCHAR(25) NULL;

go

/**********
DBCASE :- DB-4849
EXECUTED DATE :- (2019-06-12)
DESCRIPTION :- Remove dodgy1 and dodgy2 column from Customer .
***********/


ALTER TABLE customer DROP COLUMN dodgy1;
GO
ALTER TABLE customer DROP COLUMN dodgy2;
GO

/**********
DBCASE :- DB-5589
EXECUTED DATE :- (2019-06-19)
DESCRIPTION :- Create new master table IdentifierType
***********/

CREATE TABLE [dbo].[IdentifierType] (
[TypeId] TINYINT NOT NULL,
[Name] VARCHAR (20) NOT NULL,
PRIMARY KEY ([TypeId])
)
GO

/**********
DBCASE :- DB-5562,DB-5613
EXECUTED DATE :- (2019-06-19)
DESCRIPTION :- Add two default columns InIdentifierIMEIDefault and InIdentifierMACAddress in Category table & Add foreign key 
reference for category table to IdentifierType table.
***********/

/* Add columns to category table */
ALTER TABLE category
ADD InIdentifierIMEIDefault tinyint NOT NULL DEFAULT 0,
	InIdentifierMACAddressDefault tinyint NOT NULL DEFAULT 0
GO

/* DB-5613 */
ALTER TABLE category ADD showOnWebHotProducts BIT NOT NULL DEFAULT 0
GO

/* Add foreign key reference for category.InIdentifierIMEIDefault to IdentifierType.TypeId */
ALTER TABLE category WITH CHECK ADD FOREIGN KEY(InIdentifierIMEIDefault)
REFERENCES IdentifierType (TypeId)
GO

/* Add foreign key reference for category.InIdentifierMACAddressDefault to IdentifierType.TypeId */
ALTER TABLE category WITH CHECK ADD FOREIGN KEY(InIdentifierMACAddressDefault)
REFERENCES IdentifierType (TypeId)
GO

/**********
DBCASE :- DB-4054
EXECUTED DATE :- (2019-08-05)
DESCRIPTION :- Centralized Customer script
***********/

CREATE TABLE [dbo].[Customer_Cache](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_Branchkey]  DEFAULT ('  '),
	[AccountID] [int] NOT NULL CONSTRAINT [DF_CustomerCache_AccountID]  DEFAULT ((0)),
	[Title] [varchar](15) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_Title]  DEFAULT (' '),
	[Firstname] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_Firstname]  DEFAULT (' '),
	[LastName] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_LastName]  DEFAULT (' '),
	[DateOfBirth] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_DateOfBirth]  DEFAULT ('1 jan 1900'),
	[Organisation] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Building] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Street1] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street2] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street3] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street4] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street5] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Town] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[County] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[AddressVerified] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AddressVerifi8]  DEFAULT ((0)),
	[AddressManual] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AddressManual6]  DEFAULT ((0)),
	[Email] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PhoneHome] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[PhoneWork] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[PhoneMobile] [varchar](25) COLLATE Latin1_General_CI_AS NULL,
	[SnailMailOk] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_SnailMailOk_27]  DEFAULT ((0)),
	[EmailOk] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_EmailOk_12]  DEFAULT ((0)),
	[SMSOk] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_SMSOk_26]  DEFAULT ((0)),
	[SubscriptionDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_Subscription31]  DEFAULT ('1 jan 1900'),
	[SubscribedBy] [int] NOT NULL CONSTRAINT [DF_CustomerCache_SubscribedBy30]  DEFAULT ((0)),
	[ExchangeOnly] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_ExchangeOnly13]  DEFAULT ((0)),
	[DateOfLastContact] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_DateOfLastCo11]  DEFAULT ('1 jan 1900'),
	[AddressRefreshDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_AddressRefres7]  DEFAULT ('1 jan 1900'),
	[ID1Type] [int] NOT NULL CONSTRAINT [DF_CustomerCache_ID1Type_18]  DEFAULT ((0)),
	[ID1Mod] [int] NOT NULL CONSTRAINT [DF_CustomerCache_ID1Mod_17]  DEFAULT ((0)),
	[ID1Data] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_ID1Data]  DEFAULT (' '),
	[ID1IssuedBy] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[ID2Type] [int] NOT NULL CONSTRAINT [DF_CustomerCache_ID2Type_21]  DEFAULT ((0)),
	[ID2Mod] [int] NOT NULL CONSTRAINT [DF_CustomerCache_ID2Mod_20]  DEFAULT ((0)),
	[ID2Data] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_ID2Data]  DEFAULT (' '),
	[AccountActive] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AccountActive1]  DEFAULT ((1)),
	[AccountClosed] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AccountClosed3]  DEFAULT ((0)),
	[AccountBanned] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AccountBanned2]  DEFAULT ((0)),
	[AccountWatched] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_AccountWatche5]  DEFAULT ((0)),
	[StatusBy] [int] NOT NULL CONSTRAINT [DF_CustomerCache_StatusBy_28]  DEFAULT ((0)),
	[StatusDate] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_StatusDate_29]  DEFAULT ('1 jan 1900'),
	[LastChangedBy] [int] NOT NULL CONSTRAINT [DF_CustomerCache_LastChangedB23]  DEFAULT ((0)),
	[LastChangedWhen] [datetime] NOT NULL CONSTRAINT [DF_CustomerCache_LastChangedW24]  DEFAULT ('1 jan 1900'),
	[Notes] [varchar](400) COLLATE Latin1_General_CI_AS NULL,
	[HeardFrom] [int] NULL,
	[LastChangeBranchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CustomerCache_LastChangeBranchkey]  DEFAULT ('  '),
	[GuardianApproval] [bit] NOT NULL CONSTRAINT [DF_CustomerCache_GuardianAppr15]  DEFAULT ((0)),
	[TotalBuy] [money] NOT NULL CONSTRAINT [DF_CustomerCache_TotalBuy_33]  DEFAULT ((0)),
	[TotalSell] [money] NOT NULL CONSTRAINT [DF_CustomerCache_TotalSell_35]  DEFAULT ((0)),
	[TotalRefund] [money] NOT NULL CONSTRAINT [DF_CustomerCache_TotalRefund_34]  DEFAULT ((0)),
	[TotalTranactions] [int] NOT NULL CONSTRAINT [DF_CustomerCache_TotalTranact36]  DEFAULT ((0)),
 CONSTRAINT [PK_Branchkey_AccountID_CustomerCache_Cache] PRIMARY KEY CLUSTERED 
(
	[Branchkey] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE NONCLUSTERED INDEX [NCL_Email_CustomerCache] ON [dbo].[Customer_Cache]
(
	[Email] ASC
)WITH (FILLFACTOR = 90) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [NCL_Postcode_Customer_Cache] ON [dbo].[Customer_Cache]
(
	[Postcode] ASC
)WITH (FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCL_Firstname_Lastname_CustomerCache] ON [dbo].[Customer_Cache]
(
	[Firstname] ASC,
	[LastName] ASC
)WITH (FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCL_Lastname_Firstname_CustomerCache] ON [dbo].[Customer_Cache]
(
	[LastName] ASC,
	[Firstname] ASC
)WITH (FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCL_Phone_number_CustomerCache] ON [dbo].[Customer_Cache]
(
	[PhoneMobile] ASC
)WITH (FILLFACTOR = 90) ON [PRIMARY]
GO


GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [Customer_Cache] TO eposv2
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [Customer_Cache] TO boffice
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [Customer_Cache] TO kiwiservices
GO

GRANT SELECT,REFERENCES ON [Customer_Cache] TO Devreader
GO

GRANT SELECT,REFERENCES ON [Customer_Cache] TO QAReader
GO

CREATE TABLE [dbo].[CustomerCard_Cache](
	[Branchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	[AccountID] [int] NOT NULL,
	[CardNumber] [int] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[IssuedBy] [int] NOT NULL,
	[CancelledDate] [datetime] NULL,
	[CancelledBy] [int] NULL,
	[CancelNote] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Cancelled] [bit] NOT NULL,
	[LastChangeBranchkey] [varchar](6) COLLATE Latin1_General_CI_AS NOT NULL,
	CONSTRAINT [PK_CustomerCard_Cache] PRIMARY KEY NONCLUSTERED 
	(
		[CardNumber] ASC,
		[IssueDate] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE CLUSTERED INDEX [NCL_Branchkey_AccountID_CustomerCard_Cache] ON [dbo].[CustomerCard_Cache]
(
	[Branchkey] ASC,
	[AccountID] ASC
) ON [PRIMARY]
GO


GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerCard_Cache] TO eposv2
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerCard_Cache] TO boffice
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerCard_Cache] TO kiwiservices
GO

GRANT SELECT,REFERENCES ON [CustomerCard_Cache] TO Devreader
GO

GRANT SELECT,REFERENCES ON [CustomerCard_Cache] TO QAReader
GO

CREATE TABLE [dbo].[CustomerAttribute_Cache](
	[BranchKey] [varchar](6) NOT NULL,
	[AccountID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[Value] [varchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL DEFAULT GETDATE()		--New Column Introduced for Replication Requirement (Store to National)
PRIMARY KEY CLUSTERED 
(
	[BranchKey] ASC,
	[AccountID] ASC,
	[TypeID] ASC
)

) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerAttribute_Cache]  WITH CHECK ADD FOREIGN KEY([TypeID])
REFERENCES [dbo].[CustomerAttributeType]([ID])


GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerAttribute_Cache] TO eposv2
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerAttribute_Cache] TO boffice
GO

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES ON [CustomerAttribute_Cache] TO kiwiservices
GO

GRANT SELECT,REFERENCES ON [CustomerAttribute_Cache] TO Devreader
GO

GRANT SELECT,REFERENCES ON [CustomerAttribute_Cache] TO QAReader

GO

-- Create table to log  the count of  daily deleted customer_cache

CREATE TABLE CustomercacheLog
(
		id int identity(1,1),
		CustomerDeleted int,
		CustomerCardDeleted int,
		CustomerAttributeDeleted int,
		AddedDate datetime,
		ErrorLog varchar(max)
)
GO
-- create the procedure to delete the customer from customrcache

CREATE PROCEDURE spDeleteCustomercache
AS
BEGIN

	DECLARE @NumberofDays int
	SET @NumberofDays = (select value from BranchSetting where subkey='Customer Cache Retention Period' and HiveKey='Database')

	DECLARE @CustomerAttributeCount INT
	DECLARE @CustomercardCount INT
	DECLARE @CustomerCount INT

	BEGIN TRY
			BEGIN TRANSACTION T1;

				DELETE CA from CustomerAttribute_cache CA
				INNER JOIN Customer_cache C on C.Branchkey =CA.branchkey and C.AccountID=CA.Accountid
				where  DateOfLastContact <GETDATE()-@NumberofDays  
							
				SELECT @CustomerAttributeCount = @@ROWCOUNT

				DELETE CC from Customercard_cache CC
				INNER JOIN Customer_cache C on C.Branchkey =CC.branchkey and C.AccountID=CC.Accountid
				where  DateOfLastContact <GETDATE()-@NumberofDays 
							
				select  @CustomercardCount = @@ROWCOUNT

				DELETE from customer_cache 
				where DateOfLastContact <GETDATE()-@NumberofDays  
							
				select @CustomerCount = @@ROWCOUNT
							
			COMMIT TRANSACTION T1

		INSERT  INTO CustomercacheLog(CustomerDeleted,CustomerCardDeleted,CustomerAttributeDeleted,AddedDate,ErrorLog)
		SELECT @CustomerCount,@CustomercardCount,@CustomerAttributeCount,getdate(),NULL
	END TRY

BEGIN CATCH  
	
			if @@TRANCOUNT>0
				ROLLBACK TRANSACTION T1

			DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
			SELECT @ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)

			INSERT  INTO CustomercacheLog(CustomerDeleted,CustomerCardDeleted,CustomerAttributeDeleted,AddedDate,ErrorLog)
			select @CustomerCount,@CustomercardCount,@CustomerAttributeCount,getdate(),@ErrMsg

END CATCH
END

GO

/**********
EXECUTED DATE :- (2019-08-20)
DESCRIPTION :- Centralized Customer script - Add new column in CustomerAttribute table
***********/

ALTER TABLE CustomerAttribute ADD CreatedDatetime DATETIME NOT NULL DEFAULT GETDATE()

GO

/**********
EXECUTED DATE :- (2019-10-04)
DESCRIPTION :- Add new column RefundSubsetReasonID to Refunds table
CASE :-        DB-6160
***********/

GO


Alter table Refunds Add RefundSubsetReasonID int Null;

GO



/**********
EXECUTED DATE :- (2019-10-04)
DESCRIPTION :- Add new table RefundReasonSubset 
CASE :-        DB-6162
***********/

CREATE TABLE [dbo].[RefundReasonSubset](
	[RefundSubsetReasonID] [int] IDENTITY(1,1) NOT NULL,
	[RefundReasonID] [int] NOT NULL,
	[SubsetReason] [varchar](60) NOT NULL,
	[InUse] [bit] NOT NULL DEFAULT 0
) ON [PRIMARY]

go

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.RefundReasonSubset TO kiwiservices;  
GO

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.RefundReasonSubset TO eposv2;  
GO

/**********
EXECUTED DATE :- (2020-01-22)
DESCRIPTION :- Add PlatformId column in StaffBranches table on RMA store 
CASE :-        DB-6490
***********/ 
ALTER TABLE staffbranches ADD PlatformID INT NULL;

/**********
EXECUTED DATE :- (2020-01-30)
DESCRIPTION :- Create new table FiscalPrinterType 
CASE :-        DB-6464
***********/ 
CREATE TABLE FiscalPrinterType (
	FiscalPrinterTypeID int NOT NULL,
	Description varchar(64) NULL,
	XOffset int NULL,
	YOffset int NULL,

PRIMARY KEY CLUSTERED
(
	FiscalPrinterTypeID ASC
) 
) ON [PRIMARY]

GRANT SELECT,insert,update,delete,references ON epos2000.dbo.FiscalPrinterType TO kiwiservices;  
GO
GRANT SELECT,insert,update,delete,references ON epos2000.dbo.FiscalPrinterType TO eposv2;  
GO 

/**********
EXECUTED DATE :- (2020-07-03)
DESCRIPTION :- Add DropAndGoAllowed column in BranchesOnline 
CASE :-        DB-7398
***********/ 
ALTER TABLE BranchesOnline ADD DropAndGoAllowed BIT NOT NULL DEFAULT 0


/**********
EXECUTED DATE :- (2020-11-10)
DESCRIPTION :- Add New StockHistory Columns (FirstStockInDate ,LastSoldDate , LastStockDate) to Boxes tables 
CASE :-        DB-8074
***********/ 

ALTER TABLE dbo.Boxes ADD FirstStockInDate datetime, LastSoldDate datetime,LastStockDate datetime

/**********
EXECUTED DATE :- (2020-11-10)
DESCRIPTION :- Add PriceHistory Columns (FirstPrice ,PreviousPrice , PriceLastChanged) to BoxPrice with Trigger updating the price history
CASE :-        DB-7988
***********/ 

ALTER TABLE dbo.BoxPrice ADD FirstPrice money, PreviousPrice money,PriceLastChanged datetime;

/**********
EXECUTED DATE :- (2021-01-13)
DESCRIPTION :- Add PublicName Columns to WorkOrderStatus 
CASE :-        DB-8283
***********/ 

Alter table WorkOrderStatus 
Add PublicName nvarchar(100) Null;

/**********
EXECUTED DATE :- (2021-01-13)
DESCRIPTION :- Add StaffID Columns to WorkOrderStatusHistory 
CASE :-        DB-8284
***********/ 

ALTER TABLE WorkOrderStatusHistory ADD StaffID int NULL;

/**********
EXECUTED DATE :- (2021-01-13)
DESCRIPTION :- Add StaffID Columns to Country  
CASE :-        DB-8404
***********/ 

Alter Table Country Add Countrycode varchar(2),Portalvisible bit Not Null Default 'False';

/**********
EXECUTED DATE :- (2021-01-13)
DESCRIPTION :- Add FirstPrice, PreviousPrice, PriceLastChanged Columns to BoxPrice  
CASE :-        DB-7988
***********/ 

ALTER TABLE dbo.BoxPrice ADD FirstPrice money, PreviousPrice money,PriceLastChanged datetime;

/**********
EXECUTED DATE :- (2021-01-13)
DESCRIPTION :- Add FirstStockInDate, LastSoldDate, LastStockDate Columns to Boxes  
CASE :-        DB-8074
***********/ 

ALTER TABLE dbo.Boxes ADD FirstStockInDate datetime, LastSoldDate datetime,LastStockDate datetime

/**********
EXECUTED DATE :- (2021-02-25)
DESCRIPTION :- Add InUseEcom Column in Refundreasonsubset table
CASE :-        DB-8814
***********/ 

USE Epos2000;
ALTER TABLE RefundReasonSubset ADD InUseEcom BIT NOT NULL DEFAULT 0;

/**********
EXECUTED DATE :- (2021-04-12)
DESCRIPTION :-   Increasing Staff Tag History's 'IssuerNTName' column length to sync it with staff FullName.
		 Increasing length from 32 to 48 to sync it with Staff.FullName also Increasing length from 
		 160 to 240 to sync it with Staff_enc.FullName
CASE :-        DB-9186
***********/ 

USE epos2000;

ALTER TABLE StaffTagHistory ALTER COLUMN IssuerNTName VARCHAR(48);
go

ALTER TABLE StaffTagHistory_enc ALTER COLUMN IssuerNTName VARCHAR(240);
go

