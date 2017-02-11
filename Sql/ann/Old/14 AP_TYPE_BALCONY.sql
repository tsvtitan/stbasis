
CREATE TABLE AP_TYPE_BALCONY
(
 AP_TYPE_BALCONY_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_TYPE_BALCONY
ADD PRIMARY KEY (AP_TYPE_BALCONY_ID)

CREATE GENERATOR GEN_AP_TYPE_BALCONY_ID;

CREATE TRIGGER AP_TYPE_BALCONY_BI0 FOR AP_TYPE_BALCONY
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_TYPE_BALCONY where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_TYPE_BALCONY_BU0 FOR AP_TYPE_BALCONY
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_TYPE_BALCONY
   where Upper(name)=Upper(new.name)and
         AP_TYPE_BALCONY.AP_TYPE_BALCONY_id<>New.AP_TYPE_BALCONY_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_TYPE_BALCONY
'Справочник видов балкона';

grant select, delete, insert, update, references on AP_TYPE_BALCONY to adminrole;
grant select on AP_TYPE_BALCONY to premises;


