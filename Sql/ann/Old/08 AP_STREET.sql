
CREATE TABLE AP_STREET
(
 AP_STREET_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_STREET
ADD PRIMARY KEY (AP_STREET_ID)

CREATE GENERATOR GEN_AP_STREET_ID;

CREATE TRIGGER AP_STREET_BI0 FOR AP_STREET
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_STREET where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_STREET_BU0 FOR AP_STREET
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_STREET
   where Upper(name)=Upper(new.name)and
         AP_STREET.AP_STREET_id<>New.AP_STREET_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_STREET
'Справочник улиц';

grant select, delete, insert, update, references on AP_STREET to adminrole;
grant select on AP_STREET to premises;


