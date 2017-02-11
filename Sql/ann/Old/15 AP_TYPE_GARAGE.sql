
CREATE TABLE AP_TYPE_GARAGE
(
 AP_TYPE_GARAGE_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_TYPE_GARAGE
ADD PRIMARY KEY (AP_TYPE_GARAGE_ID)

CREATE GENERATOR GEN_AP_TYPE_GARAGE_ID;

CREATE TRIGGER AP_TYPE_GARAGE_BI0 FOR AP_TYPE_GARAGE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_TYPE_GARAGE where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_TYPE_GARAGE_BU0 FOR AP_TYPE_GARAGE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_TYPE_GARAGE
   where Upper(name)=Upper(new.name)and
         AP_TYPE_GARAGE.AP_TYPE_GARAGE_id<>New.AP_TYPE_GARAGE_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_TYPE_GARAGE
'Справочник типов гаража';

grant select, delete, insert, update, references on AP_TYPE_GARAGE to adminrole;
grant select on AP_TYPE_GARAGE to premises;


