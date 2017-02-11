
CREATE TABLE AP_AGENCY
(
 AP_AGENCY_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PHONES NOTE,
 ADDRESS NOTE,
 SITE NOTE,
 EMAIL NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_AGENCY
ADD PRIMARY KEY (AP_AGENCY_ID)

CREATE GENERATOR GEN_AP_AGENCY_ID;

CREATE TRIGGER AP_AGENCY_BI0 FOR AP_AGENCY
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_AGENCY where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_AGENCY_BU0 FOR AP_AGENCY
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_AGENCY
   where Upper(name)=Upper(new.name)and
         AP_AGENCY.AP_AGENCY_id<>New.AP_AGENCY_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_AGENCY
'Справочник агенств';

grant select, delete, insert, update, references on AP_AGENCY to adminrole;
grant select on AP_AGENCY to premises;


