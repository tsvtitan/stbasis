-- $DEFINE DELIMITER ;

DROP TABLE `ADQA_all_types`;    

CREATE TABLE `ADQA_all_types` (
  `ttinyint` tinyint(4) default '0',
  `tbit` tinyint(1) default '0',
  `tbool` tinyint(1) default '0',
  `tsmallint` smallint(6) default '0',
  `tmediumint` mediumint(9) default '0',
  `tint` int(11) default '0',
  `tinteger` int(11) default '0',
  `tbigint` bigint(20) default '0',
  `treal` double default '0',
  `tdouble` double default '0',
  `tfloat` float default '0',
  `tdecimal` decimal(19,4) default '0',
  `tnumeric` decimal(10,0) default '0',
  `tchar` varchar(100) default '',
  `tvarchar` varchar(100) default '',
  `tdate` date default '0000-00-00',
  `ttime` time default '00:00:00',
  `tyear` year(4) default NULL,
  `ttimestamp` timestamp(14) NOT NULL,
  `tdatetime` datetime default '0000-00-00 00:00:00',
  `ttinyblob` tinyblob,
  `tblob` blob,
  `tmediumblob` mediumblob,
  `tlongblob` longblob,
  `ttinytext` tinytext,
  `ttext` text,
  `tmediumtext` mediumtext,
  `tlongtext` longtext
) TYPE=InnoDB;

DROP TABLE `ADQA_tabwithpk`;

CREATE TABLE `ADQA_tabwithpk` (
  `f1` int(11) NOT NULL default '0',
  CONSTRAINT `PK_tabwithpk` PRIMARY KEY  (`f1`)
) TYPE=InnoDB;

DROP TABLE `ADQA_numbers`;

CREATE TABLE `ADQA_numbers` (
  `dtByte` tinyint(3) unsigned default '0',
  `dtSByte` tinyint(3) default '0',
  `dtInt16` smallint(5) default '0',
  `dtInt32` int(10) default '0',
  `dtInt64` decimal(19,0) default '0',
  `dtUInt16` smallint(5) unsigned default '0',
  `dtUInt32` int(10) unsigned default '0',
  `dtUInt64` decimal(20,0) unsigned default '0',
  `dtDouble` double default '0',
  `dtCurrency` double default '0',
  `dtBCD` decimal(18,4) default '0.0000',
  `dtFmtBCD` decimal(18,4) default '0.0000'
) TYPE=InnoDB; 

DROP TABLE `ADQA_novalstable`;

CREATE TABLE `ADQA_novalstable` (
  `id` int(11) default '2000',
  `name` varchar(100) default 'hello'
) TYPE=InnoDB;

DROP TABLE `ADQA_transtable`;

CREATE TABLE `ADQA_transtable` (
  `id` int(11) NOT NULL default '2000',
  `name` varchar(100) default 'hello',
  CONSTRAINT `PK_transtable` PRIMARY KEY  (`id`)
) TYPE=InnoDB;

DROP TABLE `ADQA_map1`;

CREATE TABLE `ADQA_map1` (
  `id1` int(11) NOT NULL default '0',
  `name1` varchar(20) NOT NULL default '',
  CONSTRAINT `PK_map1` PRIMARY KEY  (`id1`)
) TYPE=InnoDB;

DROP TABLE `ADQA_map2`;

CREATE TABLE `ADQA_map2` (
  `id2` int(11) NOT NULL default '0',
  `name2` varchar(20) NOT NULL default ''
) TYPE=InnoDB;

DROP TABLE `ADQA_map3`;

CREATE TABLE `ADQA_map3` (
  `id3` int(11) NOT NULL default '0',
  `name3` varchar(20) NOT NULL default ''
) TYPE=InnoDB;

DROP TABLE `ADQA_map4`;

CREATE TABLE `ADQA_map4` (
  `id4` int(11) NOT NULL default '0',
  `name4` varchar(20) NOT NULL default ''
) TYPE=InnoDB; 

DROP TABLE `ADQA_locktable`;

CREATE TABLE `ADQA_locktable` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(100) NOT NULL default ''
) TYPE=InnoDB;

DROP TABLE `ADQA_batch_test`;

CREATE TABLE `ADQA_batch_test` (
  `tint` int(11) default '0',
  `tstring` varchar(100) default '',
  `tblob` blob
) TYPE=InnoDB; 

DROP TABLE `ADQA_maxlength`;

CREATE TABLE `ADQA_maxlength` (
  `str` varchar(255) default NULL,
  `memos` text,
  `widestr` text,
  `blobs` blob
) TYPE=InnoDB; 

DROP TABLE `ADQA_blob`;

CREATE TABLE `ADQA_blob` (
  `id` int(11) NOT NULL auto_increment,
  `blobdata` longblob,
  CONSTRAINT `PK_blob` PRIMARY KEY  (`id`)
) TYPE=InnoDB;

DROP TABLE `ADQA_details_autoinc`;

DROP TABLE `ADQA_master_autoinc`;

CREATE TABLE `ADQA_master_autoinc` (
  `id1` int(11) NOT NULL auto_increment,
  `name1` varchar(20) default '',
  CONSTRAINT `PK_master_autoinc` PRIMARY KEY  (`id1`)
) TYPE=InnoDB;

CREATE TABLE `ADQA_details_autoinc` (
  `id2` int(11) NOT NULL auto_increment,
  `fk_id1` int(11) NOT NULL default '0',
  `name2` varchar(20) NOT NULL default '',
  CONSTRAINT `PK_details_autoinc` PRIMARY KEY  (`id2`),
  KEY `I_detautoinc_fkid1` (`fk_id1`),
  CONSTRAINT `FK_detautoinc_mastautoinc`
  FOREIGN KEY (`fk_id1`)
  REFERENCES `ADQA_master_autoinc` (`id1`) ON DELETE CASCADE
) TYPE=InnoDB;

DROP TABLE `ADQA_identity_tab`;
 
CREATE TABLE `ADQA_identity_tab` (
  `auto` int(11) NOT NULL auto_increment,
  `descr` varchar(50) default NULL,
  CONSTRAINT `FK_identity_tab` PRIMARY KEY  (`auto`)
) TYPE=InnoDB;

DROP TABLE `ADQA_ascii_types`;

CREATE TABLE `ADQA_ascii_types` (
  `atString` varchar(5) default '',
  `atFloat` double default '0',
  `atNumber` tinyint(4) default '0',
  `atBool` tinyint(1) default '0',
  `atLongInt` int(11) default '0',
  `atDate` date default '0000-00-00',
  `atTime` time default '00:00:00',
  `atDateTime` datetime default '0000-00-00 00:00:00',
  `atBlob` blob,
  `atMemo` text
) TYPE=InnoDB; 

DROP TABLE `ADQA_db_types`;

CREATE TABLE `ADQA_db_types` (
  `ftString` varchar(100) default '',
  `ftSmallInt` smallint(6) default '0',
  `ftInteger` int(11) default '0',
  `ftWord` smallint(5) unsigned default '0',
  `ftBoolean` tinyint(1) default '0',
  `ftFloat` double default '0',
  `ftCurrency` decimal(19,4) default '0.0000',
  `ftBCD` decimal(19,4) default '0.0000',
  `ftDate` date default '0000-00-00',
  `ftTime` time default '00:00:00',
  `ftDateTime` datetime default '0000-00-00 00:00:00',
  `ftBytes` tinyblob,
  `ftBlob` blob,
  `ftMemo` text
) TYPE=InnoDB; 

DROP TABLE `ADQA_bcd`;

CREATE TABLE `ADQA_bcd` (
  `ftCurrency` decimal(19,4) default '0.0000',
  `ftBCD` decimal(19,4) default '0.0000',
  `ftFmtBCD` decimal(22,4) default '0.0000'
) TYPE=InnoDB;

DROP TABLE `ADQA_timestamp`;

CREATE TABLE `ADQA_timestamp` (
  `id` int (11) NOT NULL PRIMARY KEY auto_increment,
  `fnull` timestamp(14) 
) TYPE=InnoDB; 

DROP TABLE `ADQA_parambind`;

CREATE TABLE `ADQA_parambind` (
  `p1` varchar(50) default NULL,
  `p2` varchar(50) default NULL,
  `p3` varchar(50) default NULL,
  `p4` varchar(50) default NULL
) TYPE=InnoDB; 

DROP TABLE `ADQA_ForAsync`;

CREATE TABLE `ADQA_ForAsync` (
  `id` int NULL ,
  `name` varchar (20) NULL 
) TYPE=InnoDB; 