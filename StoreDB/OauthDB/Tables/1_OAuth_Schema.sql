use OAuth
GO
/****** Object:  Table [dbo].[ClientProperties]    Script Date: 3/29/2018 10:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientProperties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[Key] [nvarchar](250) COLLATE Latin1_General_CI_AS NOT NULL,
	[Value] [nvarchar](2000) COLLATE Latin1_General_CI_AS NOT NULL,
 CONSTRAINT [PK_ClientProperties] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
