USE [Scorelink]
GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTINFO_STATUS]    Script Date: 8/2/2021 9:12:17 AM ******/
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
ALTER TABLE [dbo].[DocumentDetail] DROP CONSTRAINT [DF_DocumentDetail_Commited]
GO
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_Status]
GO
/****** Object:  Table [dbo].[User]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[User]
GO
/****** Object:  Table [dbo].[SysConfig]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[SysConfig]
GO
/****** Object:  Table [dbo].[OnlineUser]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[OnlineUser]
GO
/****** Object:  Table [dbo].[OCRResult]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[OCRResult]
GO
/****** Object:  Table [dbo].[DocumentInfo]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[DocumentInfo]
GO
/****** Object:  Table [dbo].[DocumentArea]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[DocumentArea]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[Company]
GO
/****** Object:  Table [dbo].[AccTitleDict]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[AccTitleDict]
GO
/****** Object:  UserDefinedFunction [dbo].[F_DocumentDetail]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP FUNCTION [dbo].[F_DocumentDetail]
GO
/****** Object:  Table [dbo].[StatementType]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[StatementType]
GO
/****** Object:  Table [dbo].[DocumentDetail]    Script Date: 8/2/2021 9:12:17 AM ******/
DROP TABLE [dbo].[DocumentDetail]
GO
/****** Object:  Table [dbo].[DocumentDetail]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[StatementType]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[F_DocumentDetail]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[AccTitleDict]    Script Date: 8/2/2021 9:12:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccTitleDict](
	[AccNo] [int] IDENTITY(1,1) NOT NULL,
	[AccountTitle] [varchar](500) NULL,
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
/****** Object:  Table [dbo].[Company]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[DocumentArea]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[DocumentInfo]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[OCRResult]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[OnlineUser]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[SysConfig]    Script Date: 8/2/2021 9:12:17 AM ******/
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
/****** Object:  Table [dbo].[User]    Script Date: 8/2/2021 9:12:17 AM ******/
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
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_Status]  DEFAULT ('Y') FOR [Status]
GO
ALTER TABLE [dbo].[DocumentDetail] ADD  CONSTRAINT [DF_DocumentDetail_Commited]  DEFAULT ('N') FOR [Commited]
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
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTINFO_STATUS]    Script Date: 8/2/2021 9:12:17 AM ******/
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
