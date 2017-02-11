DROP TABLE PUBLISHING;

CREATE TABLE PUBLISHING (
    PUBLISHING_ID INTEGER NOT NULL,
    NAME guidename,
    NOTE NOTE);


ALTER TABLE PUBLISHING
ADD PRIMARY KEY (PUBLISHING_ID)

CREATE GENERATOR GEN_PUBLISHING_ID;

CREATE TRIGGER PUBLISHING_ID_BI0 FOR PUBLISHING
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PUBLISHING where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Издание <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PUBLISHING_BU0 FOR PUBLISHING
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PUBLISHING
   where Upper(name)=Upper(new.name)and
         PUBLISHING.PUBLISHING_id<>New.PUBLISHING_id into ctn;
  if (ctn>0) then begin
     err='Издание <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

update RDB$RELATIONS set RDB$DESCRIPTION ='Справочник изданий' where RDB$RELATION_NAME='PUBLISHING'

grant select, delete, insert, update, references on PUBLISHING to adminrole;
grant select on PUBLISHING to premises;

ALTER TABLE RELEASE
ADD PUBLISHING_ID INTEGER

INSERT INTO PUBLISHING (PUBLISHING_ID,NAME,NOTE)
VALUES (gen_id(GEN_PUBLISHING_ID,1),'Каталог Недвижимости','Каталог Недвижимости')


INSERT INTO PUBLISHING (PUBLISHING_ID,NAME,NOTE)
VALUES (gen_id(GEN_PUBLISHING_ID,1),'Купи-Продай Недвижимость','Купи-Продай Недвижимость')


Update release
set publishing_id=3

ALTER TABLE RELEASE
ADD foreign key (publishing_id) references publishing(publishing_id)


update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = 1
where (RDB$FIELD_NAME = 'PUBLISHING_ID') and
(RDB$RELATION_NAME = 'RELEASE')

ALTER TABLE AP_FIELD_VIEW
ADD VISIBLE INTEGER DEFAULT 1

UPDATE AP_FIELD_VIEW
SET VISIBLE=1

UPDATE AP_FIELD_VIEW
SET VISIBLE=0
WHERE AP_FIELD_VIEW_ID IN (9,10,11,15)


CREATE TABLE AP_DIRECTION (
    AP_DIRECTION_ID INTEGER NOT NULL,
    NAME GUIDENAME,
    FULLNAME NOTE,
    PRIORITY SMALLINT,
    VARIANT VARIANT,
    LINK NOTE,
    EXPORT NOTE);

ALTER TABLE AP_DIRECTION ADD PRIMARY KEY (AP_DIRECTION_ID);

CREATE GENERATOR GEN_AP_DIRECTION_ID;


CREATE TRIGGER AP_DIRECTION_BI0 FOR AP_DIRECTION
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_DIRECTION where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_DIRECTION_BU0 FOR AP_DIRECTION
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_DIRECTION
   where Upper(name)=Upper(new.name)and
         AP_DIRECTION.AP_DIRECTION_id<>New.AP_DIRECTION_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

update RDB$RELATIONS set RDB$DESCRIPTION = 'Справочник направлений' where RDB$RELATION_NAME='AP_DIRECTION'

grant select, delete, insert, update, references on AP_DIRECTION to adminrole;
grant select on AP_DIRECTION to premises;

ALTER TABLE AP_PREMISES
ADD AP_DIRECTION_ID INTEGER

ALTER TABLE AP_PREMISES
ADD foreign key (AP_DIRECTION_ID) references AP_DIRECTION(AP_DIRECTION_ID)


