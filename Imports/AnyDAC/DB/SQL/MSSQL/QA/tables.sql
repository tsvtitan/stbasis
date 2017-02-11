-- $DEFINE DELIMITER GO

DROP TABLE [ADQA_All_types]
GO

CREATE TABLE [ADQA_All_types] (
 [tbigint] [bigint] NULL ,
 [tbinary] [binary] (50) NULL ,
 [tbit] [bit] NULL ,
 [tchar] [char] (10) COLLATE Cyrillic_General_CI_AS NULL ,
 [tdatetime] [datetime] NULL ,
 [tfloat] [float] NULL ,
 [timage] [image] NULL ,
 [tint] [int] NULL ,
 [tmoney] [money] NULL ,
 [tnchar] [nchar] (10) COLLATE Cyrillic_General_CI_AS NULL ,
 [tntext] [ntext] COLLATE Cyrillic_General_CI_AS NULL ,
 [tnumeric] [numeric](18, 10) NULL ,
 [tnvarchar] [nvarchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [treal] [real] NULL ,
 [tsmalldatetime] [smalldatetime] NULL ,
 [tsmallint] [smallint] NULL ,
 [tsmallmoney] [smallmoney] NULL ,
 [tsql_variant] [sql_variant] NULL ,
 [ttext] [text] COLLATE Cyrillic_General_CI_AS NULL ,
 [ttimestamp] [timestamp] NULL ,
 [ttinyint] [tinyint] NULL ,
 [tuniqueidentifier] [uniqueidentifier] NULL ,
 [tvarbinary] [varbinary] (50) NULL ,
 [tvarchar] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_Numbers]
GO

CREATE TABLE [ADQA_Numbers] (
 [dtByte] [tinyint] NULL ,
 [dtSByte] [tinyint] NULL ,
 [dtInt16] [smallint] NULL ,
 [dtInt32] [int] NULL ,
 [dtInt64] [bigint] NULL ,
 [dtUInt16] [decimal](5, 0) NULL ,
 [dtUInt32] [decimal](10, 0) NULL ,
 [dtUInt64] [decimal](20, 0) NULL ,
 [dtDouble] [float] NULL ,
 [dtCurrency] [money] NULL ,
 [dtBCD] [decimal](28, 14) NULL ,
 [dtFmtBCD] [decimal](28, 14) NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_Identity_tab]
GO

CREATE TABLE [ADQA_Identity_tab] (
 [auto] [int] IDENTITY (1, 1) NOT NULL ,
 [descr] [nvarchar] (50) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_details_autoinc]
GO

CREATE TABLE [ADQA_details_autoinc] (
 [id2] [int] IDENTITY (1, 1) NOT NULL ,
 [fk_id1] [int] NOT NULL ,
 [name2] [varchar] (20) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
GO

DROP TABLE [ADQA_master_autoinc]
GO

CREATE TABLE [ADQA_master_autoinc] (
 [id1] [int] IDENTITY (1, 1) NOT NULL ,
 [name1] [varchar] (20) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [ADQA_master_autoinc] WITH NOCHECK ADD
  CONSTRAINT [PK_master_autoinc] PRIMARY KEY CLUSTERED
 (
  [id1]
 ) ON [PRIMARY] 
GO

ALTER TABLE [ADQA_details_autoinc] WITH NOCHECK ADD
  CONSTRAINT [PK_details_autoinc] PRIMARY KEY CLUSTERED
 (
  [id2]
 ) ON [PRIMARY] 
GO

ALTER TABLE [ADQA_details_autoinc] ADD 
 CONSTRAINT [FK_details_autoinc_master_autoinc] FOREIGN KEY 
 (
  [fk_id1]
 ) REFERENCES [ADQA_master_autoinc] (
  [id1]
 ) ON DELETE CASCADE ON UPDATE CASCADE 
GO

DROP TABLE [ADQA_TransTable]
GO

CREATE TABLE [ADQA_TransTable] (
 [id] [int] NOT NULL ,
 [name] [varchar] (100) COLLATE Cyrillic_General_CI_AS NULL 
) 
GO

ALTER TABLE [ADQA_TransTable] WITH NOCHECK ADD 
 CONSTRAINT [PK_TransTable] PRIMARY KEY CLUSTERED
 (
  [id]
 ) ON [PRIMARY] 
GO

ALTER TABLE [ADQA_TransTable] WITH NOCHECK ADD 
 CONSTRAINT [DF_TransTable_id] DEFAULT (2000) FOR [id],
 CONSTRAINT [DF_TransTable_name] DEFAULT ('hello') FOR [name]
GO

DROP TABLE [ADQA_NoValsTable]
GO

CREATE TABLE [ADQA_NoValsTable] (
 [id] [int] NULL,
 [name] [varchar] (100) COLLATE Cyrillic_General_CI_AS NULL 
)
GO

ALTER TABLE [ADQA_NoValsTable] WITH NOCHECK ADD 
 CONSTRAINT [DF_NoValsTable_id] DEFAULT (2000) FOR [id],
 CONSTRAINT [DF_NoValsTable_name] DEFAULT ('hello') FOR [name]
GO

DROP TABLE [ADQA_LockTable]
GO

CREATE TABLE [ADQA_LockTable] (
 [id] [int] NOT NULL ,
 [name] [varchar] (100) COLLATE Cyrillic_General_CI_AS NOT NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_TabWithPK]
GO

CREATE TABLE [ADQA_TabWithPK] (
 [f1] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [ADQA_TabWithPK] WITH NOCHECK ADD
  CONSTRAINT [PK_TabWithPK] PRIMARY KEY CLUSTERED
 (
  [f1]
 ) ON [PRIMARY] 
GO

DROP TABLE [ADQA_Batch_test]
GO

CREATE TABLE [ADQA_Batch_test] (
 [tint] [int] NULL ,
 [tstring] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [tblob] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_MaxLength]
GO

CREATE TABLE [ADQA_MaxLength] (
 [str] [char] (255) COLLATE Cyrillic_General_CI_AS NULL ,
 [blobs] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_MaxLengthNVarchar]
GO

CREATE TABLE [ADQA_MaxLengthNVarchar] (
 [widestr] [nvarchar] (4000) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_MaxLengthVarchar]
GO

CREATE TABLE [ADQA_MaxLengthVarchar] (
 [memos] [varchar] (8000) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY] 
GO

DROP TABLE [ADQA_Blob]
GO

CREATE TABLE [ADQA_Blob] (
 [id] [int] IDENTITY (1, 1) NOT NULL ,
 [blobdata] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_ForAsync]
GO

CREATE TABLE [ADQA_ForAsync] (
 [id] [int] NULL ,
 [name] [varchar] (20) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_All_types_NoUnicode]
GO

CREATE TABLE [ADQA_All_types_NoUnicode] (
 [tbigint] [bigint] NULL ,
 [tbinary] [binary] (50) NULL ,
 [tbit] [bit] NULL ,
 [tchar] [char] (10) COLLATE Cyrillic_General_CI_AS NULL ,
 [tdatetime] [datetime] NULL ,
 [tfloat] [float] NULL ,
 [timage] [image] NULL ,
 [tint] [int] NULL ,
 [tmoney] [money] NULL ,
 [tnumeric] [numeric](18, 10) NULL ,
 [treal] [real] NULL ,
 [tsmalldatetime] [smalldatetime] NULL ,
 [tsmallint] [smallint] NULL ,
 [tsmallmoney] [smallmoney] NULL ,
 [ttext] [text] COLLATE Cyrillic_General_CI_AS NULL ,
 [ttimestamp] [timestamp] NULL ,
 [ttinyint] [tinyint] NULL ,
 [tuniqueidentifier] [uniqueidentifier] NULL ,
 [tvarbinary] [varbinary] (50) NULL ,
 [tvarchar] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_Ascii_types]
GO

CREATE TABLE [ADQA_Ascii_types] (
 [atString] [varchar] (5) COLLATE Cyrillic_General_CI_AS NULL ,
 [atFloat] [float] NULL ,
 [atNumber] [smallint] NULL ,
 [atBool] [bit] NULL ,
 [atLongInt] [int] NULL ,
 [atDate] [datetime] NULL ,
 [atTime] [datetime] NULL ,
 [atDateTime] [datetime] NULL ,
 [atBlob] [image] NULL ,
 [atMemo] [text] COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_DB_types]
GO

CREATE TABLE [ADQA_DB_types] (
 [ftString] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [ftSmallInt] [smallint] NULL ,
 [ftInteger] [int] NULL ,
 [ftWord] [smallint] NULL ,
 [ftBoolean] [bit] NULL ,
 [ftFloat] [float] NULL ,
 [ftCurrency] [money] NULL ,
 [ftBCD] [decimal](19, 4) NULL ,
 [ftDate] [datetime] NULL ,
 [ftTime] [datetime] NULL ,
 [ftDateTime] [datetime] NULL ,
 [ftBytes] [varbinary] (50) NULL ,
 [ftBlob] [image] NULL ,
 [ftMemo] [text] COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [ADQA_Bcd]
GO

CREATE TABLE [ADQA_Bcd] (
 [ftCurrency] [money] NULL ,
 [ftBCD] [decimal](19, 4) NULL ,
 [ftFmtBCD] [decimal](22, 4) NULL
) ON [PRIMARY]
GO

DROP TABLE [ADQA_ParamBind]
GO

CREATE TABLE [ADQA_ParamBind] (
 [p1] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [p2] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [p3] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL ,
 [p4] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY]
GO

DROP TABLE [ADQA_map1]
GO

CREATE TABLE [ADQA_map1] (
  id1 int NOT NULL primary key,
  name1 varchar(20) NOT NULL default ''
)
GO

DROP TABLE [ADQA_map2]
GO

CREATE TABLE [ADQA_map2] (
  id2 int NOT NULL,
  name2 varchar(20) NOT NULL default ''
) 
GO

DROP TABLE [ADQA_map3]
GO

CREATE TABLE [ADQA_map3] (
   id3 int NOT NULL,
   name3 varchar(20) NOT NULL default ''
) 
GO

DROP TABLE [ADQA_map4]
GO

CREATE TABLE [ADQA_map4] (
    id4 int NOT NULL,
    name4 varchar(20) NOT NULL default ''
)
GO

-- AnyDAC Speed Tester

DROP TABLE ADQA_Products
GO

CREATE TABLE ADQA_Products (
       ProductID            INT PRIMARY KEY,
       ProductName          VARCHAR(100),
       FromDate             DATETIME,
       SupplierID           INT,
       CategoryID           INT,
       QuantityPerUnit      VARCHAR(20),
       UnitPrice            MONEY,
       UnitsInStock         INT,
       UnitsOnOrder         INT,
       OnDate               DATETIME
)
GO

DROP TABLE ADQA_Categories
GO

CREATE TABLE ADQA_Categories (
       CategoryID           INT PRIMARY KEY,
       CategoryName         VARCHAR(15),
       Description          TEXT
)
GO

DROP TABLE ADQA_OrderDetails
GO

CREATE TABLE ADQA_OrderDetails (
       OrderID              INT PRIMARY KEY,
       OnDate               DATETIME,
       ProductID            INT,
       UnitPrice            MONEY,
       Quantity             SMALLINT,
       Discount             REAL,
       Notes                VARCHAR(100)
)
GO
