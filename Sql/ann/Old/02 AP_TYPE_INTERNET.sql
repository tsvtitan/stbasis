
CREATE TABLE AP_TYPE_INTERNET
(
 AP_TYPE_INTERNET_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_TYPE_INTERNET
ADD PRIMARY KEY (AP_TYPE_INTERNET_ID)

CREATE GENERATOR GEN_AP_TYPE_INTERNET_ID;

CREATE TRIGGER AP_TYPE_INTERNET_BI0 FOR AP_TYPE_INTERNET
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_TYPE_INTERNET where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_TYPE_INTERNET_BU0 FOR AP_TYPE_INTERNET
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_TYPE_INTERNET
   where Upper(name)=Upper(new.name)and
         AP_TYPE_INTERNET.AP_TYPE_INTERNET_id<>New.AP_TYPE_INTERNET_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_TYPE_INTERNET
'Справочник видов интернета';

grant select, delete, insert, update, references on AP_TYPE_INTERNET to adminrole;
grant select on AP_TYPE_INTERNET to premises;


