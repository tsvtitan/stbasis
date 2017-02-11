
CREATE TABLE AP_PLANNING
(
 AP_PLANNING_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_PLANNING
ADD PRIMARY KEY (AP_PLANNING_ID)

CREATE GENERATOR GEN_AP_PLANNING_ID;

CREATE TRIGGER AP_PLANNING_BI0 FOR AP_PLANNING
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_PLANNING where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_PLANNING_BU0 FOR AP_PLANNING
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_PLANNING
   where Upper(name)=Upper(new.name)and
         AP_PLANNING.AP_PLANNING_id<>New.AP_PLANNING_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_PLANNING
'Справочник планировок';

grant select, delete, insert, update, references on AP_PLANNING to adminrole;
grant select on AP_PLANNING to premises;


