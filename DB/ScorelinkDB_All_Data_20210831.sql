USE [Scorelink]
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTINFO_STATUS]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP PROCEDURE [dbo].[SP_DOCUMENTINFO_STATUS]
GO
ALTER TABLE [dbo].[OCRResult] DROP CONSTRAINT [FK_OCRResult_DocumentInfo]
GO
ALTER TABLE [dbo].[DocumentArea] DROP CONSTRAINT [FK_DocumentArea_DocumentDetail]
GO
ALTER TABLE [dbo].[SysConfig] DROP CONSTRAINT [DF_SysConfig_ConstOutputDouble]
GO
ALTER TABLE [dbo].[SysConfig] DROP CONSTRAINT [DF_SysConfig_ConstOutputInt]
GO
ALTER TABLE [dbo].[SummaryScore] DROP CONSTRAINT [DF_SummaryScore_SumAmount12]
GO
ALTER TABLE [dbo].[SummaryScore] DROP CONSTRAINT [DF_SummaryScore_SumAmount11]
GO
ALTER TABLE [dbo].[SummaryScore] DROP CONSTRAINT [DF_SummaryScore_SumAmount]
GO
ALTER TABLE [dbo].[Formula] DROP CONSTRAINT [DF_Formula_Active]
GO
ALTER TABLE [dbo].[Formula] DROP CONSTRAINT [DF_Formula_Formula]
GO
ALTER TABLE [dbo].[DocumentDetail] DROP CONSTRAINT [DF_DocumentDetail_Commited]
GO
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_Status]
GO
/****** Object:  Table [dbo].[User]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[User]
GO
/****** Object:  Table [dbo].[SysConfig]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[SysConfig]
GO
/****** Object:  Table [dbo].[SummaryScore]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[SummaryScore]
GO
/****** Object:  Table [dbo].[OnlineUser]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[OnlineUser]
GO
/****** Object:  Table [dbo].[OCRResult]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[OCRResult]
GO
/****** Object:  Table [dbo].[Formula]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[Formula]
GO
/****** Object:  Table [dbo].[DocumentInfo]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[DocumentInfo]
GO
/****** Object:  Table [dbo].[DocumentArea]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[DocumentArea]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[Company]
GO
/****** Object:  Table [dbo].[AccTitleDict]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[AccTitleDict]
GO
/****** Object:  Table [dbo].[AccountTitleGroup]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[AccountTitleGroup]
GO
/****** Object:  Table [dbo].[AccountTitle]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[AccountTitle]
GO
/****** Object:  UserDefinedFunction [dbo].[F_DocumentDetail]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP FUNCTION [dbo].[F_DocumentDetail]
GO
/****** Object:  Table [dbo].[StatementType]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[StatementType]
GO
/****** Object:  Table [dbo].[DocumentDetail]    Script Date: 8/31/2021 9:51:24 AM ******/
DROP TABLE [dbo].[DocumentDetail]
GO
/****** Object:  Table [dbo].[DocumentDetail]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentDetail](
	[DocDetId] [int] IDENTITY(1,1) NOT NULL,
	[DocId] [int] NOT NULL,
	[DocPageNo] [varchar](50) NOT NULL,
	[FootnoteNo] [varchar](50) NULL,
	[PageType] [varchar](2) NULL,
	[ScanStatus] [varchar](1) NULL,
	[PageFileName] [varchar](250) NULL,
	[PagePath] [varchar](500) NULL,
	[PageUrl] [varchar](500) NULL,
	[Selected] [varchar](1) NULL,
	[Commited] [varchar](1) NULL,
	[PatternNo] [varchar](2) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DocumentDetail] PRIMARY KEY CLUSTERED 
(
	[DocDetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatementType]    Script Date: 8/31/2021 9:51:24 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[F_DocumentDetail]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_DocumentDetail] (@DocID INT)
RETURNS TABLE
AS
RETURN
SELECT 
S.StatementId,
D.DocId,
S.StatementName,
D.FootnoteNo,
D.Commited,
(SELECT COUNT(*) FROM DocumentDetail WHERE PageType = S.StatementId AND DocId = D.DocId AND (ScanStatus <> 'Y' OR ScanStatus IS NULL)) AS NoScan,
STUFF((SELECT ',' + D.DocPageNo FROM DocumentDetail as D WHERE D.PageType = S.StatementId AND D.DocId = @DocID ORDER BY LEN(D.DocPageNo),D.DocPageNo FOR XML PATH('')),1,1,'') AS PageNo
FROM DocumentDetail as D
INNER JOIN StatementType as S ON D.PageType = S.StatementId 
WHERE D.DocId = @DocID
GROUP BY D.DocId,S.StatementId,S.StatementName,D.FootnoteNo,D.Commited
GO
/****** Object:  Table [dbo].[AccountTitle]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTitle](
	[AccTitleId] [int] IDENTITY(1,1) NOT NULL,
	[AccGroupId] [int] NULL,
	[AccTitleName] [varchar](2000) NULL,
	[AccTitleDesc] [varchar](max) NULL,
	[AccTitleLanguage] [varchar](50) NULL,
	[Active] [varchar](50) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_AccountTitle] PRIMARY KEY CLUSTERED 
(
	[AccTitleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountTitleGroup]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTitleGroup](
	[AccGroupId] [int] IDENTITY(1,1) NOT NULL,
	[AccGroupName] [varchar](50) NULL,
	[AccGroupDesc] [varchar](50) NULL,
	[AccGroupLanguage] [varchar](50) NULL,
	[Active] [varchar](50) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_AccountTitleGroup] PRIMARY KEY CLUSTERED 
(
	[AccGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccTitleDict]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccTitleDict](
	[AccNo] [int] IDENTITY(1,1) NOT NULL,
	[AccountTitle] [varchar](500) NULL,
	[Language] [varchar](50) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_StandardizedAcc] PRIMARY KEY CLUSTERED 
(
	[AccNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](50) NULL,
	[Domain] [varchar](50) NULL,
	[Address] [varchar](1000) NULL,
	[Telephone] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentArea]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentArea](
	[AreaId] [int] IDENTITY(1,1) NOT NULL,
	[AreaNo] [int] NOT NULL,
	[DocId] [int] NOT NULL,
	[DocDetId] [int] NOT NULL,
	[DocPageNo] [varchar](50) NULL,
	[PageType] [varchar](2) NULL,
	[AreaX] [varchar](50) NULL,
	[AreaY] [varchar](50) NULL,
	[AreaH] [varchar](50) NULL,
	[AreaW] [varchar](50) NULL,
	[AreaPath] [varchar](500) NULL,
	[AreaUrl] [varchar](500) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_DocumentArea] PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentInfo]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentInfo](
	[DocId] [int] IDENTITY(1,1) NOT NULL,
	[FileUID] [varchar](50) NULL,
	[FileName] [varchar](250) NULL,
	[FilePath] [varchar](500) NULL,
	[FileUrl] [varchar](500) NULL,
	[Language] [varchar](50) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_DocumentInfo] PRIMARY KEY CLUSTERED 
(
	[DocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Formula]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Formula](
	[FormulaId] [int] IDENTITY(1,1) NOT NULL,
	[FormulaName] [varchar](1000) NULL,
	[FormulaDesc] [varchar](max) NULL,
	[FormulaQuery] [varchar](max) NULL,
	[FormulaLanguage] [varchar](50) NULL,
	[StatementTypeId] [int] NULL,
	[Active] [varchar](50) NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Formula] PRIMARY KEY CLUSTERED 
(
	[FormulaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OCRResult]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OCRResult](
	[OCRId] [int] IDENTITY(1,1) NOT NULL,
	[DocId] [int] NOT NULL,
	[DocDetId] [int] NOT NULL,
	[RowNo] [varchar](50) NULL,
	[Footnote] [varchar](50) NULL,
	[AccountTitle] [varchar](500) NULL,
	[Amount] [varchar](50) NULL,
	[Modified] [varchar](1) NULL,
	[CreateBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_OCRResult_1] PRIMARY KEY CLUSTERED 
(
	[OCRId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OnlineUser]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnlineUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[SessionId] [varchar](100) NULL,
	[IPAddress] [varchar](100) NULL,
	[MACAddress] [varchar](100) NULL,
	[CPUNO] [varchar](100) NULL,
	[OnlineUpdate] [datetime] NULL,
 CONSTRAINT [PK_OnlineUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SummaryScore]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SummaryScore](
	[CreateBy] [varchar](50) NOT NULL,
	[AccGroupId] [int] NOT NULL,
	[SumAmount1] [numeric](18, 0) NULL,
	[SumAmount2] [numeric](18, 0) NULL,
	[SumAmount3] [numeric](18, 0) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_SummaryScore] PRIMARY KEY CLUSTERED 
(
	[CreateBy] ASC,
	[AccGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysConfig]    Script Date: 8/31/2021 9:51:24 AM ******/
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
/****** Object:  Table [dbo].[User]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Company] [int] NULL,
	[Address] [varchar](1000) NULL,
	[Telephone] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[Admin] [varchar](50) NULL,
	[RegisterDate] [datetime] NULL,
	[ExpireDate] [datetime] NULL,
	[UpdateBy] [varchar](50) NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AccountTitle] ON 

INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, 1, N'รวมหนี้สิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, 2, N'รวมส่วนของผู้ถือหุ้น', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, 3, N'กำไรสุทธิ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, 3, N'ขาดทุนสุทธิ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, 3, N'กำไร(ขาดทุน)สุทธิ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (6, 3, N'กำไรสุทธิสำหรับปี', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (7, 3, N'ขาดทุนสุทธิสำหรับปี', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (8, 3, N'กำไรสำหรับปี', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (9, 3, N'ขาดทุนสำหรับปี', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (10, 4, N'รวมรายได้', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (11, 5, N'ต้นทุนขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (12, 5, N'ต้นทุนการให้บริการ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (13, 5, N'ต้นทุนขายและต้นทุนการให้บริการ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (14, 5, N'ต้นทุนในการจัดจำหน่าย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (15, 6, N'ค่าใช้จ่ายในการขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (16, 6, N'ค่าใช้จ่ายในการบริหาร', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (17, 7, N'ค่าเสื่อมราคาและค่าตัดจำหน่าย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (18, 8, N'ค่าเสื่อมราคาและค่าตัดจำหน่าย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (19, 9, N'รวมสินทรัพย์หมุนเวียน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (20, 10, N'รวมหนี้สินหมุนเวียน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (21, 11, N'สินค้าคงเหลือ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (22, 12, N'ต้นทุนขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (23, 13, N'รายได้จากการขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (24, 14, N'กระแสเงินสดสุทธิได้มาจากการดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (25, 14, N'กระแสเงินสดสุทธิได้มาจากกิจกรรมดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (26, 14, N'กระแสเงินสดสุทธิใช้ไปในกิจกรรมดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (27, 14, N'กระแสเงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (28, 14, N'เงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (29, 14, N'เงินสดสุทธิได้มา (ใช้ไปใน) กิจกรรมดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (30, 15, N'กระแสเงินสดสุทธิใช้ไปในกิจกรรมลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (31, 15, N'กระแสเงินสดสุทธิได้มาจากกิจกรรมลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (32, 15, N'กระแสเงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (33, 15, N'เงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (34, 15, N'เงินสดสุทธิได้มา (ใช้ไปใน) กิจกรรมลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (35, 16, N'กระแสเงินสดสุทธิใช้ไปในกิจกรรมจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (36, 16, N'กระแสเงินสดสุทธิได้มาจากกิจกรรมจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (37, 16, N'กระแสเงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (38, 16, N'เงินสดสุทธิได้มาจาก (ใช้ไปใน) กิจกรรมจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (39, 16, N'เงินสดสุทธิได้มา (ใช้ไปใน) กิจกรรมจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (40, 18, N'Cash and cash equivalents', NULL, N'English', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), NULL, CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitle] ([AccTitleId], [AccGroupId], [AccTitleName], [AccTitleDesc], [AccTitleLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (41, 19, N'Current investments', NULL, N'English', N'Y', N'1', NULL, N'1', NULL)
SET IDENTITY_INSERT [dbo].[AccountTitle] OFF
SET IDENTITY_INSERT [dbo].[AccountTitleGroup] ON 

INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'หนี้สินรวม', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'ส่วนของผู้ถือหุ้น', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'กำไรสุทธิ / ขาดทุนสุทธิ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'ยอดขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, N'ต้นทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (6, N'ค่าใช้จ่ายในการขายและบริหาร', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (7, N'ค่าเสื่อมราคา', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (8, N'ค่าตัดจำหน่าย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (9, N'สินทรัพย์หมุนเวียน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (10, N'หนี้สินหมุนเวียน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (11, N'สินค้าคงเหลือ', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (12, N'ต้นทุนขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (13, N'รายได้จากการขาย', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (14, N'กระแสเงินสดสุทธิจากการดำเนินงาน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (15, N'กระแสเงินสดสุทธิจากการลงทุน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (16, N'กระแสเงินสดจากการจัดหาเงิน', NULL, N'Thai', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (18, N'Total liabilities', NULL, N'English', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (19, N'Equity', NULL, N'English', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (20, N'Net Profit / Net Loss', NULL, N'English', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
INSERT [dbo].[AccountTitleGroup] ([AccGroupId], [AccGroupName], [AccGroupDesc], [AccGroupLanguage], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (21, N'Sales', NULL, N'English', N'Y', N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-10T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[AccountTitleGroup] OFF
SET IDENTITY_INSERT [dbo].[AccTitleDict] ON 

INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'หนี้สินรวม', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'ส่วนของผู้ถือหุ้น', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'กำไรสุทธิ', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'ขาดทุนสุทธิ', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, N'ยอดขาย', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (6, N'ต้นทุน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (7, N'ค่าใช้จ่ายในการขายและบริหาร', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (8, N'ค่าเสื่อมราคา', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (9, N'ค่าตัดจำหน่าย', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (10, N'สินทรัพย์หมุนเวียน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (11, N'หนี้สินหมุนเวียน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (12, N'สินค้าคงเหลือ', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (13, N'ต้นทุนขาย', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (14, N'รายได้จากการขาย', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (15, N'กระแสเงินสดสุทธิ', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (16, N'กระแสเงินสดสุทธิจากการดำเนินงาน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (17, N'กระแสเงินสดสุทธิจากการลงทุน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
INSERT [dbo].[AccTitleDict] ([AccNo], [AccountTitle], [Language], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (18, N'กระแสเงินสดจากการจัดหาเงิน', N'Thai', N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime), N'1', CAST(N'2021-02-08T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[AccTitleDict] OFF
SET IDENTITY_INSERT [dbo].[Company] ON 

INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'MFEC Public Company Limited', N'mfec.co.th', N'mfec.co.th', N'0899999999', N'Y', N'Sys', NULL, N'1', CAST(N'2021-03-12T16:55:01.993' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'Kasikorn Bank', N'kbank.co.th', N'Kbank', N'123123132', N'Y', NULL, NULL, N'1', CAST(N'2021-03-12T15:56:10.363' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'Bank of Ayudhya', N'bay.co.th', N'Bank of Ayudhya', N'09078978345', N'Y', NULL, NULL, N'1', CAST(N'2021-03-12T16:15:05.600' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'Krungthai Bank', N'ktb.co.th', N'Krungthai Bank
1111
111
1', N'11223141242', N'Y', NULL, NULL, N'1', CAST(N'2021-03-12T15:57:07.897' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, N'Siam Commercial Bank', N'scb.co.th', N'Siam Commercial Bank', N'08984562234', N'Y', NULL, NULL, N'1', CAST(N'2021-03-12T16:42:39.180' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (6, N'Test', N'test.co.th', N'Test', N'0899999999', N'Y', NULL, CAST(N'2021-03-11T14:40:15.287' AS DateTime), N'1', CAST(N'2021-03-15T08:06:34.803' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (7, N'Test1', N'test1.co.th', N'Test', N'0899999555', N'Y', NULL, CAST(N'2021-03-11T14:50:01.523' AS DateTime), N'1', CAST(N'2021-03-15T09:57:48.650' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (8, N'Test2', N'test2.co.th', N'Test', N'0897557555', N'N', N'1', CAST(N'2021-03-11T14:53:25.203' AS DateTime), N'1', CAST(N'2021-03-12T16:41:08.267' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (9, N'Test3', N'test3.co.th', N'Test', N'11111111111', N'N', N'1', CAST(N'2021-03-11T19:25:11.610' AS DateTime), N'1', CAST(N'2021-03-12T16:41:12.737' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (10, N'Test4', N'test4.co.th', N'Test', N'444444444', N'Y', N'1', CAST(N'2021-03-11T22:30:09.620' AS DateTime), N'1', CAST(N'2021-03-23T10:51:12.640' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (11, N'Test5', N'test5.co.th', N'Test5', N'462165198', N'N', N'1', CAST(N'2021-03-12T16:31:43.320' AS DateTime), N'1', CAST(N'2021-03-12T16:41:59.607' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (12, N'test6', N'test6.co.th', N'Test', N'08956161326', N'Y', N'1', CAST(N'2021-03-15T09:44:20.063' AS DateTime), N'1', CAST(N'2021-03-15T09:44:20.063' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (13, N'Test7', N'test7@test.co.th', N'Test', N'2231231232', N'Y', N'1', CAST(N'2021-03-17T13:07:48.370' AS DateTime), N'1', CAST(N'2021-03-17T13:07:48.370' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (14, N'test8', N'test8.co.th', N'test', N'343424', N'Y', N'1', CAST(N'2021-03-17T13:12:41.733' AS DateTime), N'1', CAST(N'2021-03-17T13:12:41.740' AS DateTime))
INSERT [dbo].[Company] ([CompanyId], [CompanyName], [Domain], [Address], [Telephone], [Status], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (15, N'test9', N'test9.co.th', N'test', N'0897557555', N'N', N'1', CAST(N'2021-03-23T10:51:43.370' AS DateTime), N'1', CAST(N'2021-03-23T10:51:43.370' AS DateTime))
SET IDENTITY_INSERT [dbo].[Company] OFF
SET IDENTITY_INSERT [dbo].[DocumentArea] ON 

INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (13, 1, 8, 14, N'7', N'1', N'264', N'2226', N'6061', N'2457', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000100070001.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000100070001.tif', N'2', CAST(N'2020-10-22T11:29:23.000' AS DateTime), CAST(N'2020-10-22T11:29:23.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (14, 2, 8, 14, N'7', N'1', N'3053', N'2667', N'4509', N'242', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000100070002.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000100070002.tif', N'2', CAST(N'2020-10-22T11:29:38.000' AS DateTime), CAST(N'2020-10-22T11:29:38.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (15, 3, 8, 14, N'7', N'1', N'4419', N'2701', N'5740', N'671', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000100070003.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000100070003.tif', N'2', CAST(N'2020-10-22T11:29:44.000' AS DateTime), CAST(N'2020-10-22T11:29:44.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (16, 1, 8, 12, N'5', N'2', N'859', N'1598', N'6061', N'1344', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200050001.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200050001.tif', N'2', CAST(N'2020-10-22T02:12:47.000' AS DateTime), CAST(N'2020-10-22T02:12:47.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (17, 2, 8, 12, N'5', N'2', N'2237', N'1598', N'6061', N'242', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200050002.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200050002.tif', N'2', CAST(N'2020-10-22T02:13:01.000' AS DateTime), CAST(N'2020-10-22T02:13:01.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (18, 3, 8, 12, N'5', N'2', N'2733', N'1598', N'6061', N'859', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200050003.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200050003.tif', N'2', CAST(N'2020-10-22T02:13:08.000' AS DateTime), CAST(N'2020-10-22T02:13:08.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (19, 1, 8, 13, N'6', N'2', N'859', N'1598', N'6061', N'1344', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200060001.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200060001.tif', N'2', CAST(N'2020-10-22T02:13:45.000' AS DateTime), CAST(N'2020-10-22T02:13:45.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (20, 2, 8, 13, N'6', N'2', N'2237', N'1598', N'6061', N'242', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200060002.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200060002.tif', N'2', CAST(N'2020-10-22T02:13:53.000' AS DateTime), CAST(N'2020-10-22T02:13:53.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (21, 3, 8, 13, N'6', N'2', N'2733', N'1598', N'6061', N'859', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\c31928da-e466-4314-9558-9194a822fed4\AR0000200060003.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/AR0000200060003.tif', N'2', CAST(N'2020-10-22T02:14:01.000' AS DateTime), CAST(N'2020-10-22T02:14:01.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (73, 1, 16, 33, N'7', N'1', N'206', N'1893', N'4313', N'1918', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000100070001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000100070001.tif', N'2', CAST(N'2020-11-09T10:33:59.000' AS DateTime), CAST(N'2020-11-09T10:33:59.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (74, 2, 16, 33, N'7', N'1', N'2314', N'1984', N'3720', N'181', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000100070002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000100070002.tif', N'2', CAST(N'2020-11-09T10:34:03.000' AS DateTime), CAST(N'2020-11-09T10:34:03.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (75, 3, 16, 33, N'7', N'1', N'3306', N'2008', N'4255', N'496', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000100070003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000100070003.tif', N'2', CAST(N'2020-11-09T10:34:05.000' AS DateTime), CAST(N'2020-11-09T10:34:05.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (76, 4, 16, 33, N'7', N'1', N'3926', N'2025', N'4230', N'496', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000100070004.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000100070004.tif', N'2', CAST(N'2020-11-09T10:34:07.000' AS DateTime), CAST(N'2020-11-09T10:34:07.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (77, 1, 16, 36, N'5', N'2', N'248', N'1685', N'3056', N'1631', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200050001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200050001.tif', N'2', CAST(N'2020-11-09T10:35:50.000' AS DateTime), CAST(N'2020-11-09T10:35:50.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (78, 2, 16, 36, N'5', N'2', N'2963', N'1841', N'2790', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200050002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200050002.tif', N'2', CAST(N'2020-11-09T10:35:55.000' AS DateTime), CAST(N'2020-11-09T10:35:55.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (79, 3, 16, 36, N'5', N'2', N'3298', N'1822', N'2968', N'595', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200050003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200050003.tif', N'2', CAST(N'2020-11-09T10:35:58.000' AS DateTime), CAST(N'2020-11-09T10:35:58.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (80, 1, 16, 37, N'6', N'2', N'186', N'1592', N'4185', N'2313', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200060001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200060001.tif', N'2', CAST(N'2020-11-09T10:37:05.000' AS DateTime), CAST(N'2020-11-09T10:37:05.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (81, 2, 16, 37, N'6', N'2', N'2988', N'1667', N'3600', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200060002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200060002.tif', N'2', CAST(N'2020-11-09T10:37:09.000' AS DateTime), CAST(N'2020-11-09T10:37:09.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (82, 3, 16, 37, N'6', N'2', N'3311', N'1661', N'4214', N'582', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000200060003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000200060003.tif', N'2', CAST(N'2020-11-09T10:37:12.000' AS DateTime), CAST(N'2020-11-09T10:37:12.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (83, 1, 16, 34, N'10', N'3', N'180', N'1587', N'5020', N'2263', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300100001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300100001.tif', N'2', CAST(N'2020-11-09T10:40:38.000' AS DateTime), CAST(N'2020-11-09T10:40:38.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (84, 2, 16, 34, N'10', N'3', N'2585', N'1810', N'3600', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300100002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300100002.tif', N'2', CAST(N'2020-11-09T10:40:43.000' AS DateTime), CAST(N'2020-11-09T10:40:43.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (85, 3, 16, 34, N'10', N'3', N'2989', N'1773', N'4847', N'570', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300100003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300100003.tif', N'2', CAST(N'2020-11-09T10:40:47.000' AS DateTime), CAST(N'2020-11-09T10:40:47.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (86, 4, 16, 34, N'10', N'3', N'3646', N'1835', N'4785', N'476', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300100004.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300100004.tif', N'2', CAST(N'2020-11-09T10:40:49.000' AS DateTime), CAST(N'2020-11-09T10:40:49.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (87, 5, 16, 34, N'10', N'3', N'4160', N'1822', N'4803', N'533', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300100005.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300100005.tif', N'2', CAST(N'2020-11-09T10:40:52.000' AS DateTime), CAST(N'2020-11-09T10:40:52.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (88, 1, 16, 35, N'11', N'3', N'148', N'1593', N'4673', N'2319', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300110001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300110001.tif', N'2', CAST(N'2020-11-09T10:42:37.000' AS DateTime), CAST(N'2020-11-09T10:42:37.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (89, 2, 16, 35, N'11', N'3', N'2641', N'1767', N'2790', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300110002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300110002.tif', N'2', CAST(N'2020-11-09T10:42:41.000' AS DateTime), CAST(N'2020-11-09T10:42:41.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (90, 3, 16, 35, N'11', N'3', N'3081', N'1791', N'4512', N'471', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300110003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300110003.tif', N'2', CAST(N'2020-11-09T10:42:44.000' AS DateTime), CAST(N'2020-11-09T10:42:44.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (91, 4, 16, 35, N'11', N'3', N'3639', N'1785', N'4493', N'453', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300110004.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300110004.tif', N'2', CAST(N'2020-11-09T10:42:47.000' AS DateTime), CAST(N'2020-11-09T10:42:47.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (92, 5, 16, 35, N'11', N'3', N'4129', N'1785', N'4468', N'508', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\AR0000300110005.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/AR0000300110005.tif', N'2', CAST(N'2020-11-09T10:42:49.000' AS DateTime), CAST(N'2020-11-09T10:42:49.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (93, 1, 15, 38, N'11', N'1', N'569', N'1130', N'2208', N'1267', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100110001.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100110001.tif', N'2', CAST(N'2020-11-09T11:08:31.000' AS DateTime), CAST(N'2020-11-09T11:08:31.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (94, 2, 15, 38, N'11', N'1', N'2031', N'1215', N'2157', N'264', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100110002.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100110002.tif', N'2', CAST(N'2020-11-09T11:08:35.000' AS DateTime), CAST(N'2020-11-09T11:08:35.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (95, 3, 15, 38, N'11', N'1', N'3527', N'1309', N'2097', N'510', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100110003.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100110003.tif', N'2', CAST(N'2020-11-09T11:08:37.000' AS DateTime), CAST(N'2020-11-09T11:08:37.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (96, 4, 15, 38, N'11', N'1', N'4097', N'1275', N'2157', N'510', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100110004.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100110004.tif', N'2', CAST(N'2020-11-09T11:08:39.000' AS DateTime), CAST(N'2020-11-09T11:08:39.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (97, 1, 15, 39, N'12', N'1', N'552', N'1266', N'4562', N'1360', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100120001.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100120001.tif', N'2', CAST(N'2020-11-09T11:10:03.000' AS DateTime), CAST(N'2020-11-09T11:10:03.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (98, 2, 15, 39, N'12', N'1', N'1998', N'1317', N'4469', N'271', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100120002.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100120002.tif', N'2', CAST(N'2020-11-09T11:10:06.000' AS DateTime), CAST(N'2020-11-09T11:10:06.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (99, 3, 15, 39, N'12', N'1', N'3510', N'1419', N'4537', N'510', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100120003.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100120003.tif', N'2', CAST(N'2020-11-09T11:10:07.000' AS DateTime), CAST(N'2020-11-09T11:10:07.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (100, 4, 15, 39, N'12', N'1', N'4105', N'1462', N'4324', N'510', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\AR0000100120004.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/AR0000100120004.tif', N'2', CAST(N'2020-11-09T11:10:09.000' AS DateTime), CAST(N'2020-11-09T11:10:09.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (101, 1, 17, 40, N'11', N'1', N'497', N'924', N'2868', N'1301', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100110001.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100110001.tif', N'2', CAST(N'2020-11-09T11:34:25.000' AS DateTime), CAST(N'2020-11-09T11:34:25.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (102, 2, 17, 40, N'11', N'1', N'2014', N'1370', N'2127', N'268', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100110002.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100110002.tif', N'2', CAST(N'2020-11-09T11:34:28.000' AS DateTime), CAST(N'2020-11-09T11:34:28.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (103, 3, 17, 40, N'11', N'1', N'3557', N'1306', N'1968', N'491', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100110003.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100110003.tif', N'2', CAST(N'2020-11-09T11:34:30.000' AS DateTime), CAST(N'2020-11-09T11:34:30.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (104, 1, 17, 41, N'12', N'1', N'535', N'1109', N'4697', N'1364', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100120001.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100120001.tif', N'2', CAST(N'2020-11-09T11:37:01.000' AS DateTime), CAST(N'2020-11-09T11:37:01.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (105, 2, 17, 41, N'12', N'1', N'1969', N'1683', N'4206', N'293', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100120002.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100120002.tif', N'2', CAST(N'2020-11-09T11:37:03.000' AS DateTime), CAST(N'2020-11-09T11:37:03.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (106, 3, 17, 41, N'12', N'1', N'3512', N'1375', N'4398', N'542', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\AR0000100120003.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/AR0000100120003.tif', N'2', CAST(N'2020-11-09T11:37:04.000' AS DateTime), CAST(N'2020-11-09T11:37:04.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (107, 1, 18, 44, N'7', N'1', N'192', N'1884', N'4290', N'1778', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000100070001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000100070001.tif', N'2', CAST(N'2020-11-09T06:10:00.000' AS DateTime), CAST(N'2020-11-09T06:10:00.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (108, 2, 18, 44, N'7', N'1', N'2318', N'2783', N'2790', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000100070002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000100070002.tif', N'2', CAST(N'2020-11-09T06:10:04.000' AS DateTime), CAST(N'2020-11-09T06:10:04.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (109, 3, 18, 44, N'7', N'1', N'3354', N'2008', N'3837', N'483', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000100070003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000100070003.tif', N'2', CAST(N'2020-11-09T06:10:05.000' AS DateTime), CAST(N'2020-11-09T06:10:05.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (110, 1, 18, 42, N'5', N'2', N'206', N'1684', N'3116', N'1802', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200050001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200050001.tif', N'2', CAST(N'2020-11-09T11:59:15.000' AS DateTime), CAST(N'2020-11-09T11:59:15.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (111, 2, 18, 42, N'5', N'2', N'2967', N'1760', N'2726', N'181', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200050002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200050002.tif', N'2', CAST(N'2020-11-09T11:59:20.000' AS DateTime), CAST(N'2020-11-09T11:59:20.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (112, 3, 18, 42, N'5', N'2', N'3307', N'1678', N'3214', N'594', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200050003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200050003.tif', N'2', CAST(N'2020-11-09T11:59:23.000' AS DateTime), CAST(N'2020-11-09T11:59:23.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (113, 4, 18, 42, N'5', N'2', N'4009', N'1653', N'3247', N'496', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200050004.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200050004.tif', N'2', CAST(N'2020-11-09T11:59:26.000' AS DateTime), CAST(N'2020-11-09T11:59:26.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (114, 1, 18, 48, N'6', N'2', N'272', N'1578', N'4148', N'2307', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200060001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200060001.tif', N'2', CAST(N'2020-11-09T12:00:37.000' AS DateTime), CAST(N'2020-11-09T12:00:37.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (115, 2, 18, 48, N'6', N'2', N'2967', N'1769', N'3720', N'181', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200060002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200060002.tif', N'2', CAST(N'2020-11-09T12:00:41.000' AS DateTime), CAST(N'2020-11-09T12:00:41.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (116, 3, 18, 48, N'6', N'2', N'3324', N'1769', N'4024', N'544', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200060003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200060003.tif', N'2', CAST(N'2020-11-09T12:00:44.000' AS DateTime), CAST(N'2020-11-09T12:00:44.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (117, 4, 18, 48, N'6', N'2', N'3952', N'1694', N'4131', N'544', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000200060004.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000200060004.tif', N'2', CAST(N'2020-11-09T12:00:47.000' AS DateTime), CAST(N'2020-11-09T12:00:47.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (118, 1, 18, 46, N'10', N'3', N'112', N'1822', N'4778', N'2405', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300100001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300100001.tif', N'2', CAST(N'2020-11-09T12:03:13.000' AS DateTime), CAST(N'2020-11-09T12:03:13.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (119, 2, 18, 46, N'10', N'3', N'2653', N'1742', N'2790', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300100002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300100002.tif', N'2', CAST(N'2020-11-09T12:03:18.000' AS DateTime), CAST(N'2020-11-09T12:03:18.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (120, 3, 18, 46, N'10', N'3', N'3038', N'1767', N'4896', N'482', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300100003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300100003.tif', N'2', CAST(N'2020-11-09T12:03:21.000' AS DateTime), CAST(N'2020-11-09T12:03:21.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (121, 4, 18, 46, N'10', N'3', N'3615', N'1779', N'4865', N'489', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300100004.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300100004.tif', N'2', CAST(N'2020-11-09T12:03:25.000' AS DateTime), CAST(N'2020-11-09T12:03:25.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (122, 5, 18, 46, N'10', N'3', N'4179', N'1717', N'4940', N'489', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300100005.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300100005.tif', N'2', CAST(N'2020-11-09T12:03:29.000' AS DateTime), CAST(N'2020-11-09T12:03:29.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (123, 1, 18, 47, N'11', N'3', N'142', N'1860', N'4444', N'2282', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300110001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300110001.tif', N'2', CAST(N'2020-11-09T12:05:47.000' AS DateTime), CAST(N'2020-11-09T12:05:47.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (124, 2, 18, 47, N'11', N'3', N'2647', N'1977', N'2790', N'136', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300110002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300110002.tif', N'2', CAST(N'2020-11-09T12:05:51.000' AS DateTime), CAST(N'2020-11-09T12:05:51.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (125, 3, 18, 47, N'11', N'3', N'3063', N'1798', N'4543', N'458', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300110003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300110003.tif', N'2', CAST(N'2020-11-09T12:05:54.000' AS DateTime), CAST(N'2020-11-09T12:05:54.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (126, 4, 18, 47, N'11', N'3', N'3645', N'1841', N'4499', N'478', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300110004.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300110004.tif', N'2', CAST(N'2020-11-09T12:05:57.000' AS DateTime), CAST(N'2020-11-09T12:05:57.000' AS DateTime))
INSERT [dbo].[DocumentArea] ([AreaId], [AreaNo], [DocId], [DocDetId], [DocPageNo], [PageType], [AreaX], [AreaY], [AreaH], [AreaW], [AreaPath], [AreaUrl], [CreateBy], [CreateDate], [UpdateDate]) VALUES (127, 5, 18, 47, N'11', N'3', N'4166', N'1810', N'4487', N'558', N'C:\SRC\Scorelink\Scorelink.web\FileUploads\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\AR0000300110005.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/AR0000300110005.tif', N'2', CAST(N'2020-11-09T12:06:00.000' AS DateTime), CAST(N'2020-11-09T12:06:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[DocumentArea] OFF
SET IDENTITY_INSERT [dbo].[DocumentDetail] ON 

INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (12, 8, N'5', NULL, N'2', N'', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/SL00002.tif', NULL, N'N', N'3', N'2', CAST(N'2020-10-22T11:20:30.000' AS DateTime), CAST(N'2020-10-22T05:47:54.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (13, 8, N'6', NULL, N'2', N'', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/SL00002.tif', NULL, N'N', N'3', N'2', CAST(N'2020-10-22T11:20:34.000' AS DateTime), CAST(N'2020-10-22T05:47:54.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (14, 8, N'7', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/SL00001.tif', NULL, N'N', N'1', N'2', CAST(N'2020-10-22T11:20:40.000' AS DateTime), CAST(N'2020-10-22T11:29:44.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (15, 8, N'10', NULL, N'3', NULL, N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\c31928da-e466-4314-9558-9194a822fed4.pdf', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/c31928da-e466-4314-9558-9194a822fed4.pdf', NULL, N'N', NULL, N'2', CAST(N'2020-10-22T11:20:52.000' AS DateTime), CAST(N'2020-10-22T11:20:52.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (16, 8, N'11', NULL, N'3', NULL, N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\c31928da-e466-4314-9558-9194a822fed4.pdf', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/c31928da-e466-4314-9558-9194a822fed4.pdf', NULL, N'N', NULL, N'2', CAST(N'2020-10-22T11:20:56.000' AS DateTime), CAST(N'2020-10-22T11:20:56.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (33, 16, N'7', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/SL00001.tif', NULL, N'N', N'2', N'2', CAST(N'2020-11-09T10:17:46.000' AS DateTime), CAST(N'2020-11-09T10:34:07.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (34, 16, N'10', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\SL00003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/SL00003.tif', NULL, N'N', N'3', N'2', CAST(N'2020-11-09T10:18:02.000' AS DateTime), CAST(N'2020-11-09T10:40:52.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (35, 16, N'11', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\SL00003.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/SL00003.tif', NULL, N'N', N'3', N'2', CAST(N'2020-11-09T10:18:07.000' AS DateTime), CAST(N'2020-11-09T10:42:49.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (36, 16, N'5', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/SL00002.tif', NULL, N'N', N'1', N'2', CAST(N'2020-11-09T10:18:26.000' AS DateTime), CAST(N'2020-11-09T10:35:58.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (37, 16, N'6', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/SL00002.tif', NULL, N'N', N'1', N'2', CAST(N'2020-11-09T10:18:31.000' AS DateTime), CAST(N'2020-11-09T10:37:12.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (38, 15, N'11', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/SL00001.tif', NULL, N'N', N'2', N'2', CAST(N'2020-11-09T11:07:04.000' AS DateTime), CAST(N'2020-11-09T11:08:39.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (39, 15, N'12', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/SL00001.tif', NULL, N'N', N'2', N'2', CAST(N'2020-11-09T11:07:09.000' AS DateTime), CAST(N'2020-11-09T11:10:09.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (40, 17, N'11', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/SL00001.tif', NULL, N'N', N'1', N'2', CAST(N'2020-11-09T11:32:27.000' AS DateTime), CAST(N'2020-11-09T11:34:30.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (41, 17, N'12', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/SL00001.tif', NULL, N'N', N'1', N'2', CAST(N'2020-11-09T11:32:42.000' AS DateTime), CAST(N'2020-11-09T11:37:04.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (42, 18, N'5', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/SL00002.tif', NULL, N'N', N'2', N'2', CAST(N'2020-11-09T11:41:49.000' AS DateTime), CAST(N'2020-11-09T11:59:26.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (44, 18, N'7', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\SL00001.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/SL00001.tif', NULL, N'N', N'1', N'2', CAST(N'2020-11-09T11:42:07.000' AS DateTime), CAST(N'2020-11-09T06:10:05.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (46, 18, N'10', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\SL00003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/SL00003.tif', NULL, N'N', N'3', N'2', CAST(N'2020-11-09T11:42:31.000' AS DateTime), CAST(N'2020-11-09T12:03:29.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (47, 18, N'11', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\SL00003.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/SL00003.tif', NULL, N'N', N'3', N'2', CAST(N'2020-11-09T11:42:35.000' AS DateTime), CAST(N'2020-11-09T12:06:00.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (48, 18, N'6', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\SL00002.tif', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/SL00002.tif', NULL, N'N', N'2', N'2', CAST(N'2020-11-09T11:46:09.000' AS DateTime), CAST(N'2020-11-09T12:00:47.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1067, 21, N'1', NULL, N'2', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\dd583d52-ef85-4f60-bfe6-27692c59de90\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/dd583d52-ef85-4f60-bfe6-27692c59de90/SL00002.tif', N'Y', N'Y', N'1', N'1', CAST(N'2021-08-01T02:35:49.000' AS DateTime), CAST(N'2021-08-10T01:52:22.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1068, 21, N'2', NULL, N'2', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\dd583d52-ef85-4f60-bfe6-27692c59de90\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/dd583d52-ef85-4f60-bfe6-27692c59de90/SL00002.tif', N'Y', N'Y', N'1', N'1', CAST(N'2021-08-01T02:35:53.000' AS DateTime), CAST(N'2021-08-10T01:52:22.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1069, 21, N'3', NULL, N'2', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\dd583d52-ef85-4f60-bfe6-27692c59de90\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/dd583d52-ef85-4f60-bfe6-27692c59de90/SL00002.tif', N'Y', N'Y', N'1', N'1', CAST(N'2021-08-01T02:35:55.000' AS DateTime), CAST(N'2021-08-10T01:52:22.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1070, 950, N'8', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/SL00002.tif', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:02.000' AS DateTime), CAST(N'2021-08-25T01:05:24.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1071, 950, N'9', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/SL00002.tif', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:06.000' AS DateTime), CAST(N'2021-08-25T01:05:24.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1072, 950, N'10', NULL, N'2', N'Y', N'00002', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\SL00002.tif', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/SL00002.tif', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:10.000' AS DateTime), CAST(N'2021-08-25T01:05:24.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1073, 950, N'11', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:19.000' AS DateTime), CAST(N'2021-08-25T01:04:19.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1074, 950, N'12', NULL, N'1', N'Y', N'00001', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:22.000' AS DateTime), CAST(N'2021-08-25T01:04:22.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1076, 950, N'17', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:40.000' AS DateTime), CAST(N'2021-08-25T01:04:40.000' AS DateTime))
INSERT [dbo].[DocumentDetail] ([DocDetId], [DocId], [DocPageNo], [FootnoteNo], [PageType], [ScanStatus], [PageFileName], [PagePath], [PageUrl], [Selected], [Commited], [PatternNo], [CreateBy], [CreateDate], [UpdateDate]) VALUES (1077, 950, N'18', NULL, N'3', N'Y', N'00003', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'Y', N'Y', N'2', N'1', CAST(N'2021-08-25T01:04:44.000' AS DateTime), CAST(N'2021-08-25T01:04:44.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[DocumentDetail] OFF
SET IDENTITY_INSERT [dbo].[DocumentInfo] ON 

INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (8, N'c31928da-e466-4314-9558-9194a822fed4', N'งบการเงิน 2560.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\c31928da-e466-4314-9558-9194a822fed4\c31928da-e466-4314-9558-9194a822fed4.pdf', N'http://localhost:52483/FileUploads/00000002/c31928da-e466-4314-9558-9194a822fed4/c31928da-e466-4314-9558-9194a822fed4.pdf', N'Thai', N'2', CAST(N'2020-10-22T11:05:03.000' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (15, N'0f7ff0b8-b807-4ba9-a536-0890e3eae6bb', N'DooDayDream EN.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb\0f7ff0b8-b807-4ba9-a536-0890e3eae6bb.pdf', N'http://localhost:52483/FileUploads/00000002/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb/0f7ff0b8-b807-4ba9-a536-0890e3eae6bb.pdf', N'English', N'2', CAST(N'2020-11-09T10:16:54.000' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (16, N'47699df3-53b3-4a31-86e1-6ee8af12bfe2', N'งบการเงิน 2560.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\47699df3-53b3-4a31-86e1-6ee8af12bfe2\47699df3-53b3-4a31-86e1-6ee8af12bfe2.pdf', N'http://localhost:52483/FileUploads/00000002/47699df3-53b3-4a31-86e1-6ee8af12bfe2/47699df3-53b3-4a31-86e1-6ee8af12bfe2.pdf', N'English', N'2', CAST(N'2020-11-09T10:17:16.000' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (17, N'e66d513a-11d4-4e98-bf4b-59fefed285eb', N'DooDayDream EN.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\e66d513a-11d4-4e98-bf4b-59fefed285eb\e66d513a-11d4-4e98-bf4b-59fefed285eb.pdf', N'http://localhost:52483/FileUploads/00000002/e66d513a-11d4-4e98-bf4b-59fefed285eb/e66d513a-11d4-4e98-bf4b-59fefed285eb.pdf', N'Thai', N'2', CAST(N'2020-11-09T11:31:45.000' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (18, N'921a1aad-7d0f-4d45-bf4c-7fd82442e0a7', N'งบการเงิน 2560.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000002\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7\921a1aad-7d0f-4d45-bf4c-7fd82442e0a7.pdf', N'http://localhost:52483/FileUploads/00000002/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7/921a1aad-7d0f-4d45-bf4c-7fd82442e0a7.pdf', N'Thai', N'2', CAST(N'2020-11-09T11:40:52.000' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (21, N'dd583d52-ef85-4f60-bfe6-27692c59de90', N'MFEC FINANCIAL STATEMENTS.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\dd583d52-ef85-4f60-bfe6-27692c59de90\dd583d52-ef85-4f60-bfe6-27692c59de90.pdf', N'http://localhost:52483/FileUploads/00000001/dd583d52-ef85-4f60-bfe6-27692c59de90/dd583d52-ef85-4f60-bfe6-27692c59de90.pdf', N'Thai', N'1', CAST(N'2021-07-19T09:39:18.183' AS DateTime))
INSERT [dbo].[DocumentInfo] ([DocId], [FileUID], [FileName], [FilePath], [FileUrl], [Language], [CreateBy], [CreateDate]) VALUES (950, N'28fceeda-12b6-493e-b1da-7a6119d205fd', N'DooDayDream EN.pdf', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\00000001\28fceeda-12b6-493e-b1da-7a6119d205fd\28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'http://localhost:52483/FileUploads/00000001/28fceeda-12b6-493e-b1da-7a6119d205fd/28fceeda-12b6-493e-b1da-7a6119d205fd.pdf', N'English', N'1', CAST(N'2021-07-28T04:47:20.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[DocumentInfo] OFF
SET IDENTITY_INSERT [dbo].[Formula] ON 

INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (1, N'D/E  ratio', N'D/E  ratio คืออัตราส่วนหนี้สินต่อส่วนผู้ถือหุ้น = หนี้สินรวมหารส่วนของผู้ถือหุ้น [ถ้าค่านี้ > 3 ระบบควร Pop up เตือน] [ถ้าค่านี้ > 1 แปลว่า หนี้มากกว่าส่วนของผู้ถือหุ้น คือหนี้เยอะ มีความเสี่ยงกว่า, ถ้า = 1 แปลว่าหนี้เท่ากับส่วนของผู้ถือหุ้น,  ถ้า < 1 แปลว่าส่วนของผู้ถือหุ้นมากกว่านี้ สะท้อนว่าหนี้น้อยความเสี่ยงน้อย การวิเคราะห์ DE ก็ถือเป็นศิลปะแบบหนึ่ง โดยทั่วไปค่า DE ต่ำจะแปลว่าดีเพราะมีภาระหนี้สินต่ำ แต่ถ้าค่า DE สูง แปลว่าไม่ดี เพราะมีภาระหนี้สินสูง  ในธุรกิจทั่วไปควรมีค่า D/E Ratio ไม่เกิน 1.5-2 เท่า อย่างไรก็ตามธุรกิจบางประเภทอาจมีค่า D/E สูงเป็นธรรมชาติ เช่น ธนาคาร สินเชื่อ ประกัน ค้าปลีก ] ', N'SELECT CONVERT(VARCHAR,FORMAT(A,''#,##'')) Result
FROM (
SELECT CONVERT(DECIMAL,ISNULL(SumAmount1 / (SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 2),0),18) A 
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 1) TAB', N'Thai', 2, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (2, N'กำไร/ ขาดทุนสุทธิ', N'กำไร/ ขาดทุนสุทธิ = กำไรสุทธิ หรือ ขาดทุนสุทธิ จากงบกำไรขาดทุน [หากธุรกิจขาดทุนสุทธิติดต่อกัน 3 ปี ระบบควร Pop-up เตือน] [ถ้าหาก EBITDA ยังเป็นบวก ระบบควรแจ้งเตือนว่า เป็นการขาดทุนทางบัญชีเท่านั้นเนื่องจากค่าเสื่อมหรือค่าตัดจำหน่าย --> [ถ้าติดลบจากค่าเสื่อมราคา (Depreciation) ต้องดูนโยบายการตัดค่าเสื่อมว่าสมเหตุสมผลหรือไม่บางบริษัทใช้นโยบายตัดค่าเสื่อมเร็วเพื่อแสดง Net Income น้อยๆ จะได้ประหยัดภาษี, ถ้าติดลบจากค่าใช้จ่ายทางการเงินหรือดอกเบี้ย (Interest) เช่น บริษัทมีสัดส่วนหนี้สินต่อทุน (D/E) มากเกินไป ถ้ามีการปรับโครงสร้างหนี้ (Restructure) บริษัทก็จะเป็นสัญญานของการ Turnaround ได้]', N'SELECT ''[Y1=''+CONVERT(VARCHAR,FORMAT(A,''#,##''))+''] > [Y2=''+CONVERT(VARCHAR,FORMAT(B,''#,##''))+''] > [Y3=''+CONVERT(VARCHAR,FORMAT(C,''#,##''))+'']'' Result
FROM (
SELECT 
ISNULL(SumAmount1,0) A
,ISNULL(SumAmount2,0) B
,ISNULL(SumAmount3,0) C
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 3) TAB', N'Thai', 1, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (3, N'EBITDA', N'EBITDA กำไรที่แท้จริงของกิจการ  หรือก็คือกำไรก่อนหักค่าใช้จ่ายดอกเบี้ย, ภาษี, ค่าเสื่อมราคาและค่าตัดจำหน่าย = ยอดขาย - ต้นทุน - ค่าใช้จ่ายในการขายและบริหาร + ค่าเสื่อมราคา + ค่าตัดจำหน่าย  [หากธุรกิจมี EBITDA ติดลบ ระบบควร Pop-up เตือน]ประโยชน์ของ EBITDA ก็คือ ทำให้รู้ว่าเป็นกําไรจากการดําเนินงานจริงๆ โดยตัดค่าใช้จ่ายที่ไม่ใช่ค่าใช้จ่ายในการดําเนินงานปกติออก ทําให้เห็น “สถานะที่แท้จริง” ของการประกอบธุรกิจของบริษัท', N'SELECT CONVERT(VARCHAR,FORMAT(ISNULL(A-B-C+D+E,''''),''#,##'')) Result
FROM (
SELECT ISNULL(SumAmount1,0) A,
ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 5),0) B,
ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 6),0) C,
ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 7),0) D,
ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 8),0) E
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 4) TAB', N'Thai', 1, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (4, N'Current ratio', N'Current ratio คือ อัตราส่วนเงินทุนหมุนเวียน = สินทรัพย์หมุนเวียนหารหนี้สินหมุนเวียน [ถ้าน้อยกว่า 1 ระบบควร Pop up และแจ้งว่า สินทรัพย์หมุนเวียนและหนี้สินหมุนเวียน ส่วนใหญ่คืออะไร และกี่เปอร์เซ็นบอกเป็นลำดับ] โดยทั่วไปค่า Current ratio ควรมากกว่า 1 เนื่องจากหากเกิดกรณีบริษัทเกิดสภาพคล่องขึ้นมาในระยะสั้น บริษัทจะสามารถนำสินทรัพย์หมุนเวียนไปขาย หรือเปลี่ยนเป็นเงินสดได้อย่างรวดเร็ว เพื่อนำมาจัดการหนี้สินระยะสั้นโดยไม่ต้องกู้เงินเพิ่ม ดังนั้นหาก Current ratio มีค่าน้อยกว่า 1 แสดงว่าบริษัทมีความเสี่ยงที่จะขาดสภาพคล่องในระยะสั้น
*** ควรดู Quick ratio ประกอบด้วย ซึ่ง Quick ratio เป็นการตัดรายการสินค้าคงคลังออกจากการวิเคราะห์ เพื่อให้เห็นสภาพคล่องที่แท้จริงของบริษัททั้งนี้เนื่องจากสินค้าคงคลังเป็นรายการหลักที่มีมูลค่าในสินทรัพย์หมุนเวียนสูงที่สุด ซึ่งแปลว่าการที่ Current ratio สูงอาจจะมาจากสินค้าคงคลังที่เยอะ ซึ่งอาจจะมีทั้งค่าใช้จ่ายในการเก็บรักษา รวมถึงในกรณีที่อยากเปลี่ยนเป็นเงินสดอาจทำไม่ได้โดยทันที เพราะอาจจะมีเรื่องการตกรุ่นของสินค้าประกอบด้วย', N'SELECT CONVERT(VARCHAR,FORMAT(A,''#,##'')) Result
FROM (
SELECT CONVERT(DECIMAL,ISNULL(SumAmount1 / (SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 10),0),18) A 
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 9) TAB', N'Thai', 2, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (5, N'Quick ratio', N'Quick ratio คือ อัตราส่วนเงินทุนหมุนเวียนเร็ว = (สินทรัพย์หมุนเวียน - สินค้าคงเหลือ) หารหนี้สินหมุนเวียน [ถ้าน้อยกว่า 1 ระบบควร Pop up และแจ้งว่า สินทรัพย์หมุนเวียนและหนี้สินหมุนเวียน ส่วนใหญ่คืออะไรและกี่เปอร์เซ็น บอกเป็นลำดับ] เกณฑ์ในการพิจารณาเหมือนกับ Current ratio', N'SELECT CONVERT(VARCHAR,FORMAT((A - B) / C,''#,##'')) Result
FROM (
SELECT CONVERT(INT,ISNULL(SumAmount1,0),18) A,
CONVERT(INT,ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 11),0),18) B,
CONVERT(INT,ISNULL((SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 10),0),18) C
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 9) TAB', N'Thai', 2, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (6, N'ต้นทุนขายต่อยอดขาย', N'ต้นทุนขายต่อยอดขาย = (ต้นทุนขายหารรายได้จากการขาย)คูณ100  หากค่านี้เพิ่มขึ้นจากปีก่อน  ระบบควร Pop-up และแสดงตัวเลขให้เห็นว่าปีที่แล้วและปีนี้ต้นทุนขายคิดเป็นกี่ % ของยอดขาย ต้นทุนขายเพิ่มขึ้นจากอะไรบ้าง กี่เปอร์เซ็นต์ จากมากไปน้อย', N'SELECT CONVERT(VARCHAR,FORMAT(A,''#,##'')) Result
FROM (
SELECT CONVERT(DECIMAL,ISNULL(SumAmount1 - (SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''1'' AND AccGroupId = 13),0) / 100,18) A 
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 12) TAB', N'Thai', 1, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (7, N'ยอดขาย', N'ถ้ายอดขายลดลงเมื่อเทียบกับปีที่แล้ว ระบบควรแจ้งเตือนว่าเกิดจาก ต้นทุนขาย ค่าใช้จ่าย หรืออื่นๆ  กี่เปอร์เซ็นต์', N'SELECT ''[Y1=''+CONVERT(VARCHAR,FORMAT(A,''#,##''))+''] > [Y2=''+CONVERT(VARCHAR,FORMAT(B,''#,##''))+'']'' Result
FROM (
SELECT 
ISNULL(SumAmount1,0) A
,ISNULL(SumAmount2,0) B
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 13) TAB', N'Thai', 1, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (8, N'กระแสเงินสดสุทธิจากการดำเนินงาน [CFO]', N'กระแสเงินสดสุทธิจากการดำเนินงาน [CFO] หมายถึง กระแสเงินสดที่เกิดจากกิจกรรมหลักที่ก่อให้เกิดรายได้และค่าใช้จ่าย = หากค่าเป็น ลบ ระบบควร Pop up เตือน [CFO ควรมีค่าเป็นบวก แสดงให้เห็นว่าบริษัทมีสภาพคล่องเพียงพอและสามารถนำเงินไปลงทุน จ่ายดอกเบี้ย จ่ายเงินต้นและปันผลได้ทันที หรืออาจจะติดลบอ่อนๆได้ เพราะถ้ากระแสเงินสดจากการลงทุนติดลบ แสดงว่าบริษัทยังมีการลงทุนในสินทรัพย์ต่างๆอยู่ ซึ่งการที่ลงทุนในสินทรัพย์แสดงว่าบริษัทยังต้องการที่จะเติบโตอยู่ แต่อาจจะเริ่มขาดสภาพคล่องไปบ้าง]', N'SELECT ''[CFO=''+CONVERT(VARCHAR,FORMAT(A,''#,##''))+'']'' Result
FROM (
SELECT 
ISNULL(SumAmount1,0) A
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 14) TAB', N'Thai', 3, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (9, N'กระแสเงินสดสุทธิจากการลงทุน [CFI]', N'กระแสเงินสดสุทธิจากการลงทุน [CFI] หมายถึงการได้มาและขายสินทรัพย์ระยะยาวและเงินลงทุนอื่นๆ ที่ไม่กระทบการดำเนินงาน = หากค่าเป็น บวก ระบบควร Pop up เตือน [CFI ควรมีค่าเป็นลบ แสดงถึงบริษัทมีการลงทุนขยายกิจการอย่างต่อเนื่อง เพื่อให้แน่ใจว่าเงินทุกบาทที่นำไปซื้อเครื่องจักรอุปกรณ์ต่างๆ แล้ว ทำให้ธุรกิจเติบโตอย่างมั่นคง ให้ดูที่อัตราหมุนเวียนทรัพย์สิน และ ROA ซึ่งทั้งสองค่านี้ควรเติบโตอย่างสม่ำเสมอ สะท้อนว่าเงินที่ลงทุนไปนั้นสามารถสร้างรายได้และกำไรกลับมาได้อย่างมีประสิทธิภาพหากมีค่าเป็นบวกต้องพึงระวัง เพราะอาจหมายถึง บริษัทอาจกำลังขายสินทรัพย์บางอย่างออกไป เนื่องมาจากบริษัทกำลังประสบปัญหาบางอย่างหรือกำลังจะเปลี่ยนธุรกิจหลักของตัวเองก็เป็นไปได้]', N'SELECT ''[CFI=''+CONVERT(VARCHAR,FORMAT(A,''#,##''))+'']'' Result
FROM (
SELECT 
ISNULL(SumAmount1,0) A
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 15) TAB', N'Thai', 3, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (10, N'กระแสเงินสดจากการจัดหาเงิน [CFF]', N'กระแสเงินสดจากการจัดหาเงิน [CFF] = หากค่าเป็น บวก ระบบควร Pop up เตือน [CFF ควรมีค่าเป็นลบ ซึ่งสะท้อนว่าหลังบริษัทนำเงินสดไปใช้ทำอย่างอื่น เช่น ไปซื้อที่ดิน เครื่องจักร เป็นต้นก็ยังมีเงินเหลือ นำมาจ่ายหนี้เงินต้น หรือจ่ายปันผล ตรงกันข้ามถ้า “เป็นบวก” จะต้องไปดูให้ลึกๆ บริษัทเร่งระดมทุนมาจากไหน นำมาเพื่อเสริมสภาพคล่องหรือไม่ซึ่งในการประเมินว่าบริษัทจัดหาเงินได้อย่างเหมาะสม ส่วนหนี้สิน และ ROE ต้องมีความสม่ำเสมอ] ', N'SELECT ''[CFF=''+CONVERT(VARCHAR,FORMAT(A,''#,##''))+'']'' Result
FROM (
SELECT 
ISNULL(SumAmount1,0) A
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 16) TAB', N'Thai', 3, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Formula] ([FormulaId], [FormulaName], [FormulaDesc], [FormulaQuery], [FormulaLanguage], [StatementTypeId], [Active], [UpdateBy], [UpdateDate]) VALUES (11, N'D/E  ratio', N'', N'SELECT CONVERT(VARCHAR,FORMAT(A,''#,##'')) Result
FROM (
SELECT CONVERT(DECIMAL,ISNULL(SumAmount1 / (SELECT SumAmount1 FROM SummaryScore WHERE CreateBy = ''{0}'' AND AccGroupId = 19),0),18) A 
FROM SummaryScore 
WHERE CreateBy = ''{0}'' AND AccGroupId = 18) TAB', N'English', 2, N'Y', N'1', CAST(N'2021-08-02T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Formula] OFF
SET IDENTITY_INSERT [dbo].[StatementType] ON 

INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'Income Statement', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'Balance Sheet', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'Cash Flow', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
INSERT [dbo].[StatementType] ([StatementId], [StatementName], [Active], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'Footnotes', N'1', N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime), N'1', CAST(N'2020-06-11T09:41:34.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[StatementType] OFF
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 1, CAST(1733672 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:14.007' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 3, CAST(422330 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.793' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 4, CAST(29040 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.817' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 5, CAST(858398 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.827' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 6, CAST(8099 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.840' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 7, CAST(683134 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.870' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 8, CAST(5000 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.900' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 9, CAST(3839221 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.973' AS DateTime))
INSERT [dbo].[SummaryScore] ([CreateBy], [AccGroupId], [SumAmount1], [SumAmount2], [SumAmount3], [UpdateDate]) VALUES (N'1', 10, CAST(1457083 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(N'2021-08-30T09:58:13.987' AS DateTime))
SET IDENTITY_INSERT [dbo].[SysConfig] ON 

INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (1, N'TimeOut', N'', 15, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (2, N'LogPath', N'C:/SRC/Scorelink/Scorelink.web/Logs/', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (3, N'SLUserFlie', N'C:\\SRC\\Scorelink\\Scorelink.web\\FileUploads\\', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (4, N'LeadtoolsLIC', N'E:\\LEADTOOLS\\Support\\Common\\License\\', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (5, N'sUrl', N'http://localhost:52483', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
INSERT [dbo].[SysConfig] ([ConstId], [ConstName], [ConstOutputText], [ConstOutputInt], [ConstOutputDouble], [CreateBy], [CreateDate], [UpdateBy], [UpdateDate]) VALUES (6, N'Dict', N'C:\\SRC\\Scorelink\\Scorelink.web\\Dictionary\\', 0, CAST(0.00 AS Decimal(18, 2)), N'Sys', NULL, N'Sys', NULL)
SET IDENTITY_INSERT [dbo].[SysConfig] OFF
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (1, N'tanasit@mfec.co.th', N'Tanasit', N'Jarutnuntipat', N'MTkwMzIxMDQ=', N'tanasit@mfec.co.th', 1, N'Thailand
Test', N'0899272208', N'Y', N'Y', CAST(N'2020-02-18T00:00:00.000' AS DateTime), CAST(N'2020-02-18T00:00:00.000' AS DateTime), N'1', CAST(N'2021-03-23T16:34:47.013' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (2, N'yostawat@mfec.co.th', N'Yostawat', NULL, N'', N'yostawat@mfec.co.th', 2, NULL, NULL, N'N', N'N', CAST(N'2020-02-22T00:00:00.000' AS DateTime), CAST(N'2020-02-22T00:00:00.000' AS DateTime), N'1', CAST(N'2021-05-20T16:04:26.013' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (3, N'test@test.co.th', N'Test', N'Test', N'UEBzc3cwcmQ=', N'test@test.co.th', 3, N'Test', N'0897557555', N'N', N'N', CAST(N'2021-02-17T00:00:00.000' AS DateTime), CAST(N'2021-02-17T00:00:00.000' AS DateTime), N'1', CAST(N'2021-03-17T09:44:38.840' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (4, N'ttt@mfec.co.th', N'TTT', N'TTT', N'MQ==', N'ttt@mfec.co.th', 1, N'TTT', N'TTT', N'N', N'N', CAST(N'2021-02-17T00:00:00.000' AS DateTime), CAST(N'2021-02-17T00:00:00.000' AS DateTime), N'1', CAST(N'2021-03-17T18:10:12.920' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (5, N'a@mfec.co.th', N'a', N'a', N'YQ==', N'a@mfec.co.th', NULL, N'a', N'222222', N'N', N'N', CAST(N'2021-03-18T11:29:44.310' AS DateTime), CAST(N'2021-03-18T11:29:44.310' AS DateTime), N'System', CAST(N'2021-03-18T11:29:44.310' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (6, N's@mfec.co.th', N's', N's', N'cw==', N's@mfec.co.th', NULL, N's', N'11112222', N'N', N'N', CAST(N'2021-07-27T09:01:29.460' AS DateTime), CAST(N'2021-07-27T09:01:29.460' AS DateTime), N'System', CAST(N'2021-07-27T09:01:29.460' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (7, N't@mfec.co.th', N't', N't', N'dA==', N't@mfec.co.th', 2, N't', N'33333333', N'Y', N'Y', CAST(N'2021-02-27T00:00:00.000' AS DateTime), CAST(N'2021-02-27T00:00:00.000' AS DateTime), N'1', CAST(N'2021-07-27T09:43:45.117' AS DateTime))
INSERT [dbo].[User] ([UserId], [UserName], [Name], [Surname], [Password], [Email], [Company], [Address], [Telephone], [Status], [Admin], [RegisterDate], [ExpireDate], [UpdateBy], [UpdateDate]) VALUES (8, N'j@mfec.co.th', N'j', N'j', N'ag==', N'j@mfec.co.th', NULL, N'j', N'4444444', N'N', N'N', CAST(N'2018-12-31T00:00:00.000' AS DateTime), CAST(N'2021-12-01T00:00:00.000' AS DateTime), N'1', CAST(N'2021-08-02T10:00:16.480' AS DateTime))
SET IDENTITY_INSERT [dbo].[User] OFF
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_Status]  DEFAULT ('Y') FOR [Status]
GO
ALTER TABLE [dbo].[DocumentDetail] ADD  CONSTRAINT [DF_DocumentDetail_Commited]  DEFAULT ('N') FOR [Commited]
GO
ALTER TABLE [dbo].[Formula] ADD  CONSTRAINT [DF_Formula_Formula]  DEFAULT ('') FOR [FormulaQuery]
GO
ALTER TABLE [dbo].[Formula] ADD  CONSTRAINT [DF_Formula_Active]  DEFAULT (N'N') FOR [Active]
GO
ALTER TABLE [dbo].[SummaryScore] ADD  CONSTRAINT [DF_SummaryScore_SumAmount]  DEFAULT ((0)) FOR [SumAmount1]
GO
ALTER TABLE [dbo].[SummaryScore] ADD  CONSTRAINT [DF_SummaryScore_SumAmount11]  DEFAULT ((0)) FOR [SumAmount2]
GO
ALTER TABLE [dbo].[SummaryScore] ADD  CONSTRAINT [DF_SummaryScore_SumAmount12]  DEFAULT ((0)) FOR [SumAmount3]
GO
ALTER TABLE [dbo].[SysConfig] ADD  CONSTRAINT [DF_SysConfig_ConstOutputInt]  DEFAULT ((0)) FOR [ConstOutputInt]
GO
ALTER TABLE [dbo].[SysConfig] ADD  CONSTRAINT [DF_SysConfig_ConstOutputDouble]  DEFAULT ((0.00)) FOR [ConstOutputDouble]
GO
ALTER TABLE [dbo].[DocumentArea]  WITH CHECK ADD  CONSTRAINT [FK_DocumentArea_DocumentDetail] FOREIGN KEY([DocDetId])
REFERENCES [dbo].[DocumentDetail] ([DocDetId])
GO
ALTER TABLE [dbo].[DocumentArea] CHECK CONSTRAINT [FK_DocumentArea_DocumentDetail]
GO
ALTER TABLE [dbo].[OCRResult]  WITH CHECK ADD  CONSTRAINT [FK_OCRResult_DocumentInfo] FOREIGN KEY([DocId])
REFERENCES [dbo].[DocumentInfo] ([DocId])
GO
ALTER TABLE [dbo].[OCRResult] CHECK CONSTRAINT [FK_OCRResult_DocumentInfo]
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTINFO_STATUS]    Script Date: 8/31/2021 9:51:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tanasit Jarutnuntipat
-- Create date: 15/07/2021
-- Description:	SP_DOCUMENTINFO_STATUS
-- =============================================
CREATE PROCEDURE [dbo].[SP_DOCUMENTINFO_STATUS] 
	@CreateBy VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		A.DocId, 
		A.FileUID,
		A.FileName,
		A.FilePath,
		A.FileUrl,
		A.Language,
		A.CreateBy,
		A.CreateDate,
		(SELECT TOP 1 Commited FROM DocumentDetail WHERE DocId = A.DocId) AS Commited
	FROM DocumentInfo A
	WHERE A.CreateBy = @CreateBy
END
GO
