
CREATE TABLE AP_TOWN
(
 AP_TOWN_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_TOWN
ADD PRIMARY KEY (AP_TOWN_ID)

CREATE GENERATOR GEN_AP_TOWN_ID;

CREATE TRIGGER AP_TOWN_BI0 FOR AP_TOWN
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_TOWN where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_TOWN_BU0 FOR AP_TOWN
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_TOWN
   where Upper(name)=Upper(new.name)and
         AP_TOWN.AP_TOWN_id<>New.AP_TOWN_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_TOWN
'Справочник городов';

grant select, delete, insert, update, references on AP_TOWN to adminrole;
grant select on AP_TOWN to premises;


