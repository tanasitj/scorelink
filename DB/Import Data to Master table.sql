USE [Scorelink]
GO
ALTER TABLE [dbo].[SysConfig] DROP CONSTRAINT [DF_SysConfig_ConstOutputDouble]
GO
ALTER TABLE [dbo].[SysConfig] DROP CONSTRAINT [DF_SysConfig_ConstOutputInt]
GO
/****** Object:  Table [dbo].[SysConfig]    Script Date: 19/08/2020 19:44:51 ******/
DROP TABLE [dbo].[SysConfig]
GO
/****** Object:  Table [dbo].[StatementType]    Script Date: 19/08/2020 19:44:51 ******/
DROP TABLE [dbo].[StatementType]
GO
/****** Object:  Table [dbo].[StatementType]    Script Date: 19/08/2020 19:44:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatementType](
	[StatementId] [int] IDENTITY(1,1) NOT NULL,
	[StatementName] [varchar](50) NULL,
	[Active] [varchar](1) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_StatementType] PRIMARY KEY CLUSTERED 
(
	[StatementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysConfig]    Script Date: 19/08/2020 19:44:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysConfig](
	[ConstId] [int] IDENTITY(1,1) NOT NULL,
	[ConstName] [varchar](50) NULL,
	[ConstOutputText] [varchar](1000) NULL,
	[ConstOutputInt] [int] NULL,
	[ConstOutputDouble] [decimal](18, 2) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_SysConstance] PRIMARY KEY CLUSTERED 
(
	[ConstId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[StatementType] ON 

INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'Income Statement', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'Balance Sheet', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'Cash Flow', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'Footnotes', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[StatementType] OFF
SET IDENTITY_INSERT [dbo].[SysConfig] ON 

INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'TimeOut', N'', 1, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'LogPath', N'C:/SRC/Scorelink/Scorelink.web/Logs/', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'SLUserFlie', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'LeadtoolsLIC', N'C:\\LEADTOOLS 20\\Support\\Common\\License\\', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, N'sUrl', N'http://localhost:52483', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
SET IDENTITY_INSERT [dbo].[SysConfig] OFF
ALTER TABLE [dbo].[SysConfig] ADD  CONSTRAINT [DF_SysConfig_ConstOutputInt]  DEFAULT ((0)) FOR [ConstOutputInt]
GO
ALTER TABLE [dbo].[SysConfig] ADD  CONSTRAINT [DF_SysConfig_ConstOutputDouble]  DEFAULT ((0.00)) FOR [ConstOutputDouble]
GO
