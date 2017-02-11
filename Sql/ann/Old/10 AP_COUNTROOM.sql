
CREATE TABLE AP_COUNTROOM
(
 AP_COUNTROOM_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_COUNTROOM
ADD PRIMARY KEY (AP_COUNTROOM_ID)

CREATE GENERATOR GEN_AP_COUNTROOM_ID;

CREATE TRIGGER AP_COUNTROOM_BI0 FOR AP_COUNTROOM
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_COUNTROOM where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_COUNTROOM_BU0 FOR AP_COUNTROOM
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_COUNTROOM
   where Upper(name)=Upper(new.name)and
         AP_COUNTROOM.AP_COUNTROOM_id<>New.AP_COUNTROOM_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_COUNTROOM
'Справочник количества комнат';

grant select, delete, insert, update, references on AP_COUNTROOM to adminrole;
grant select on AP_COUNTROOM to premises;


