
CREATE TABLE AP_REGION
(
 AP_REGION_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_REGION
ADD PRIMARY KEY (AP_REGION_ID)

CREATE GENERATOR GEN_AP_REGION_ID;

CREATE TRIGGER AP_REGION_BI0 FOR AP_REGION
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_REGION where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_REGION_BU0 FOR AP_REGION
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_REGION
   where Upper(name)=Upper(new.name)and
         AP_REGION.AP_REGION_id<>New.AP_REGION_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_REGION
'Справочник районов';

grant select, delete, insert, update, references on AP_REGION to adminrole;
grant select on AP_REGION to premises;


