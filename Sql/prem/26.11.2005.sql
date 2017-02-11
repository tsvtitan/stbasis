/* SERVER */

CREATE TABLE SYNC_OFFICE
(
 SYNC_OFFICE_ID INTEGER NOT NULL,
 NAME GUIDENAME NOT NULL,
 NOTE NOTE,
 KEYS NOTE
)

ALTER TABLE SYNC_OFFICE
ADD PRIMARY KEY (SYNC_OFFICE_ID)

CREATE GENERATOR GEN_SYNC_OFFICE_ID;

CREATE TRIGGER SYNC_OFFICE_BI0 FOR SYNC_OFFICE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   sync_office where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER SYNC_OFFICE_BU0 FOR SYNC_OFFICE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  sync_office
   where Upper(name)=Upper(new.name)and
         sync_office.sync_office_id<>New.sync_office_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

/*
CREATE TRIGGER SYNC_OFFICE_BD0 FOR SYNC_OFFICE
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from pms_premises
   where pms_premises.pms_phone_id=Old.pms_phone_id into ctn;
  if (ctn>0) then begin
     err='Вид телефона <'||old.name||'> используется в недвижимости..';
     execute procedure error(err);
  end
end*/

grant select, delete, insert, update, references on SYNC_OFFICE to adminrole;


CREATE TABLE SYNC_PACKAGE
(
 SYNC_PACKAGE_ID INTEGER NOT NULL,
 NAME GUIDENAME NOT NULL,
 NOTE NOTE
)

ALTER TABLE SYNC_PACKAGE
ADD PRIMARY KEY (SYNC_PACKAGE_ID)

CREATE GENERATOR GEN_SYNC_PACKAGE_ID;

CREATE TRIGGER SYNC_PACKAGE_BI0 FOR SYNC_PACKAGE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   SYNC_PACKAGE where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER SYNC_PACKAGE_BU0 FOR SYNC_PACKAGE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  SYNC_PACKAGE
   where Upper(name)=Upper(new.name)and
         SYNC_PACKAGE.sync_package_id<>New.sync_package_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

/*
CREATE TRIGGER SYNC_PACKAGE_BD0 FOR SYNC_PACKAGE
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from pms_premises
   where pms_premises.pms_phone_id=Old.pms_phone_id into ctn;
  if (ctn>0) then begin
     err='Вид телефона <'||old.name||'> используется в недвижимости..';
     execute procedure error(err);
  end
end*/

grant select, delete, insert, update, references on SYNC_PACKAGE to adminrole;

CREATE DOMAIN SQL AS
VARCHAR(2000) CHARACTER SET WIN1251
COLLATE PXW_CYRL

CREATE TABLE SYNC_OBJECT
(
 SYNC_OBJECT_ID INTEGER NOT NULL,
 SYNC_PACKAGE_ID INTEGER NOT NULL,
 NAME GUIDENAME NOT NULL,
 FIELDS_KEY NOTE NOT NULL,
 FIELDS_SYNC SQL NOT NULL,
 CONDITION SQL,
 SQL_BEFORE SQL,
 SQL_AFTER SQL
)

ALTER TABLE SYNC_OBJECT
ADD PRIMARY KEY (SYNC_OBJECT_ID)

ALTER TABLE SYNC_OBJECT
ADD FOREIGN KEY (SYNC_PACKAGE_ID) REFERENCES SYNC_PACKAGE (SYNC_PACKAGE_ID)

CREATE GENERATOR GEN_SYNC_OBJECT_ID;

/*DROP TRIGGER SYNC_OBJECT_BI0
CREATE TRIGGER SYNC_OBJECT_BI0 FOR SYNC_OBJECT
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   SYNC_OBJECT where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end*/

/*
DROP TRIGGER SYNC_OBJECT_BU0
CREATE TRIGGER SYNC_OBJECT_BU0 FOR SYNC_OBJECT
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  SYNC_OBJECT
   where Upper(name)=Upper(new.name)and
         SYNC_OBJECT.sync_object_id<>New.sync_object_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end*/

/*
CREATE TRIGGER SYNC_OBJECT_BD0 FOR SYNC_OBJECT
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from pms_premises
   where pms_premises.pms_phone_id=Old.pms_phone_id into ctn;
  if (ctn>0) then begin
     err='Вид телефона <'||old.name||'> используется в недвижимости..';
     execute procedure error(err);
  end
end*/

grant select, delete, insert, update, references on SYNC_OBJECT to adminrole;


CREATE TABLE SYNC_OFFICE_PACKAGE
(
 SYNC_OFFICE_ID INTEGER NOT NULL,
 SYNC_PACKAGE_ID INTEGER NOT NULL,
 PRIORITY SMALLINT NOT NULL,
 DIRECTION SMALLINT NOT NULL
)

ALTER TABLE SYNC_OFFICE_PACKAGE
ADD PRIMARY KEY (SYNC_OFFICE_ID,SYNC_PACKAGE_ID)

ALTER TABLE SYNC_OFFICE_PACKAGE
ADD FOREIGN KEY (SYNC_PACKAGE_ID) REFERENCES SYNC_PACKAGE (SYNC_PACKAGE_ID)

ALTER TABLE SYNC_OFFICE_PACKAGE
ADD FOREIGN KEY (SYNC_OFFICE_ID) REFERENCES SYNC_OFFICE (SYNC_OFFICE_ID)

grant select, delete, insert, update, references on SYNC_OFFICE_PACKAGE to adminrole;

/* CLIENT */

CREATE TABLE SYNC_CONNECTION
(
  SYNC_CONNECTION_ID INTEGER NOT NULL,
  CONNECTION_TYPE SMALLINT NOT NULL,
  USED SMALLINT NOT NULL,
  RETRY_COUNT INTEGER NOT NULL,
  DISPLAY_NAME GUIDENAME,
  SERVER_NAME GUIDENAME,
  SERVER_PORT INTEGER NOT NULL,
  OFFICE_NAME GUIDENAME,
  OFFICE_KEY NOTE,
  INET_AUTO SMALLINT,
  REMOTE_NAME GUIDENAMENULL,
  MODEM_USER_NAME GUIDENAMENULL,
  MODEM_USER_PASS NOTE,
  MODEM_DOMAIN GUIDENAMENULL,
  MODEM_PHONE GUIDENAMENULL,
  PROXY_NAME GUIDENAMENULL,
  PROXY_PORT INTEGER,
  PROXY_USER_NAME GUIDENAMENULL,
  PROXY_USER_PASS NOTE,
  PROXY_BY_PASS NOTE,
  PRIORITY SMALLINT
)

ALTER TABLE SYNC_CONNECTION
ADD PRIMARY KEY (SYNC_CONNECTION_ID)

CREATE GENERATOR GEN_SYNC_CONNECTION_ID;

CREATE TRIGGER SYNC_CONNECTION_BI0 FOR SYNC_CONNECTION
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   SYNC_CONNECTION where Upper(display_name)=Upper(new.display_name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.display_name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER SYNC_CONNECTION_BU0 FOR SYNC_CONNECTION
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  SYNC_CONNECTION
   where Upper(display_name)=Upper(new.display_name)and
         SYNC_CONNECTION.sync_connection_id<>New.sync_connection_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.display_name||'> уже существует..';
     execute procedure error(err);
  end
end

/*
CREATE TRIGGER SYNC_CONNECTION_BD0 FOR SYNC_CONNECTION
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from pms_premises
   where pms_premises.pms_phone_id=Old.pms_phone_id into ctn;
  if (ctn>0) then begin
     err='Вид телефона <'||old.name||'> используется в недвижимости..';
     execute procedure error(err);
  end
end*/

grant select, delete, insert, update, references on SYNC_CONNECTION to adminrole;

/* Необходимо удалить сначала первичный ключ */

ALTER TABLE PMS_PREMISES
ADD PRIMARY KEY (PMS_PREMISES_ID,PMS_AGENT_ID)

ALTER TABLE PMS_AGENT
ADD SYNC_OFFICE_ID INTEGER

UPDATE PMS_AGENT SET SYNC_OFFICE_ID=????

update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = 1
where (RDB$FIELD_NAME = 'SYNC_OFFICE_ID') and
(RDB$RELATION_NAME = 'PMS_AGENT')

ALTER TABLE PMS_AGENT
ADD FOREIGN KEY (SYNC_OFFICE_ID) REFERENCES SYNC_OFFICE (SYNC_OFFICE_ID)

/* Для интерфейса агентов необходимо очистить настройки*/

DECLARE EXTERNAL FUNCTION SYS_CREATEMAINID
RETURNS CSTRING(32)
ENTRY_POINT 'sys_CreateMainId' MODULE_NAME 'stbasisudf.dll';

ALTER TABLE PMS_PREMISES
ADD SYNC_ID VARCHAR(32)

UPDATE PMS_PREMISES
SET SYNC_ID=sys_createmainid()

update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = 1
where (RDB$FIELD_NAME = 'SYNC_ID') and
(RDB$RELATION_NAME = 'PMS_PREMISES')


