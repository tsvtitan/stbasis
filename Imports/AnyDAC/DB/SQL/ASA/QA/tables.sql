-- $DEFINE DELIMITER ;

DROP TABLE "ADQA_All_types";

CREATE TABLE "ADQA_All_types" (
 tbigint bigint NULL ,
 tubigint unsigned bigint NULL ,
 tbinary binary (50) NULL ,
 tbit bit NULL ,
 tchar char (10) NULL ,
 tdate date NULL ,
 ttime time NULL ,
 tdecimal decimal(19,4) NULL,
 tdouble double NULL ,
 tfloat float(20) NULL ,
 tlongbinary long binary NULL ,
 tint int NULL ,
 tuint unsigned int NULL ,
 tnumeric numeric(18, 10) NULL ,
 treal real NULL ,
 tsmallint smallint NULL ,
 tusmallint unsigned smallint NULL ,
 tlongvarchar long varchar NULL ,
 ttimestamp timestamp NULL ,
 ttinyint tinyint NULL ,
 tvarbinary varbinary (50) NULL ,
 tvarchar varchar (50) NULL
);


DROP TABLE "ADQA_Numbers";

CREATE TABLE "ADQA_Numbers" (
 dtByte tinyint NULL ,
 dtSByte tinyint NULL ,
 dtInt16 smallint NULL ,
 dtInt32 int NULL ,
 dtInt64 bigint NULL ,
 dtUInt16 unsigned smallint NULL ,
 dtUInt32 unsigned int NULL ,
 dtUInt64 unsigned bigint NULL ,
 dtDouble double NULL ,
 dtCurrency numeric (19,4) NULL ,
 dtBCD decimal(28, 14) NULL ,
 dtFmtBCD decimal(28, 14) NULL 
);


DROP TABLE "ADQA_Identity_tab";

CREATE TABLE "ADQA_Identity_tab" (
 auto int IDENTITY NOT NULL ,
 descr varchar (50) NULL 
); 

DROP TABLE "ADQA_details_autoinc";

CREATE TABLE "ADQA_details_autoinc" (
 id2 int IDENTITY NOT NULL ,
 fk_id1 int NOT NULL ,
 name2 varchar (20) NULL
);

DROP TABLE "ADQA_master_autoinc";

CREATE TABLE "ADQA_master_autoinc" (
 id1 int IDENTITY NOT NULL ,
 name1 varchar (20) NULL
);

ALTER TABLE "ADQA_master_autoinc" ADD
  CONSTRAINT "PK_master_autoinc" PRIMARY KEY
 (
  id1
 ); 


ALTER TABLE "ADQA_details_autoinc" ADD
  CONSTRAINT "PK_details_autoinc" PRIMARY KEY 
 (
  id2
 ); 


ALTER TABLE "ADQA_details_autoinc" ADD 
 CONSTRAINT "FK_details_autoinc_master_autoinc" FOREIGN KEY 
 (
  fk_id1
 ) REFERENCES "ADQA_master_autoinc" (
  id1
 ) ON DELETE CASCADE ON UPDATE CASCADE; 


DROP TABLE "ADQA_TransTable";

CREATE TABLE "ADQA_TransTable" (
 id int NOT NULL ,
 name varchar (100) NULL 
);

ALTER TABLE "ADQA_TransTable" ADD 
 CONSTRAINT "PK_TransTable" PRIMARY KEY 
 (
  id
 ); 

DROP TABLE "ADQA_NoValsTable";

CREATE TABLE "ADQA_NoValsTable" (
 id int NULL default 2000,
 name varchar (100) NULL default 'hello'
);

DROP TABLE "ADQA_LockTable";

CREATE TABLE "ADQA_LockTable" (
 id int NOT NULL ,
 name varchar (100) NOT NULL 
);

DROP TABLE "ADQA_TabWithPK";

CREATE TABLE "ADQA_TabWithPK" (
 f1 int NOT NULL 
);

ALTER TABLE "ADQA_TabWithPK" ADD
  CONSTRAINT "PK_TabWithPK" PRIMARY KEY 
 (
  f1
 ); 

DROP TABLE "ADQA_Batch_test";

CREATE TABLE "ADQA_Batch_test" (
 tint int NULL ,
 tstring varchar (50) NULL ,
 tblob image NULL 
);

DROP TABLE "ADQA_MaxLength";

CREATE TABLE "ADQA_MaxLength" (
 str char (255) NULL , 
 memos long varchar NULL ,
 widestr long varchar NULL,
 blobs image NULL 
);

DROP TABLE "ADQA_Blob";

CREATE TABLE "ADQA_Blob" (
 id int IDENTITY NOT NULL,
 blobdata image NULL 
);

DROP TABLE "ADQA_ForAsync";

CREATE TABLE "ADQA_ForAsync" (
 id int NULL ,
 name varchar (20) NULL 
);

DROP TABLE "ADQA_Ascii_types";

CREATE TABLE "ADQA_Ascii_types" (
 atString varchar (5) NULL ,
 atFloat double NULL ,
 atNumber smallint NULL ,
 atBool bit NULL ,
 atLongInt int NULL ,
 atDate date NULL ,
 atTime time NULL ,
 atDateTime timestamp NULL ,
 atBlob image NULL ,
 atMemo text NULL 
);

DROP TABLE "ADQA_DB_types";

CREATE TABLE "ADQA_DB_types" (
 ftString varchar (50) NULL ,
 ftSmallInt smallint NULL ,
 ftInteger int NULL ,
 ftWord smallint NULL ,
 ftBoolean bit NULL ,
 ftFloat double NULL ,
 ftCurrency numeric (19,4) NULL ,
 ftBCD decimal(19, 4) NULL ,
 ftDate date NULL ,
 ftTime time NULL ,
 ftDateTime timestamp NULL ,
 ftBytes varbinary (50) NULL ,
 ftBlob image NULL ,
 ftMemo text NULL 
);

DROP TABLE "ADQA_Bcd";

CREATE TABLE "ADQA_Bcd" (
 ftCurrency numeric (19,4) NULL ,
 ftBCD decimal(19, 4) NULL ,
 ftFmtBCD decimal(22, 4) NULL
);

DROP TABLE "ADQA_ParamBind";

CREATE TABLE "ADQA_ParamBind" (
 p1 varchar (50) NULL ,
 p2 varchar (50) NULL ,
 p3 varchar (50) NULL ,
 p4 varchar (50) NULL 
);

DROP TABLE "ADQA_map1";

CREATE TABLE "ADQA_map1" (
  id1 int NOT NULL primary key,
  name1 varchar(20) NOT NULL default ''
);

DROP TABLE "ADQA_map2";

CREATE TABLE "ADQA_map2" (
  id2 int NOT NULL,
  name2 varchar(20) NOT NULL default ''
);

DROP TABLE "ADQA_map3";

CREATE TABLE "ADQA_map3" (
   id3 int NOT NULL,
   name3 varchar(20) NOT NULL default ''
);

DROP TABLE "ADQA_map4";

CREATE TABLE "ADQA_map4" (
    id4 int NOT NULL,
    name4 varchar(20) NOT NULL default ''
);