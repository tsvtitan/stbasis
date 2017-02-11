
CREATE TABLE AP_BUILDER
(
 AP_BUILDER_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_BUILDER
ADD PRIMARY KEY (AP_BUILDER_ID)

CREATE GENERATOR GEN_AP_BUILDER_ID;

CREATE TRIGGER AP_BUILDER_BI0 FOR AP_BUILDER
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_BUILDER where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_BUILDER_BU0 FOR AP_BUILDER
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_BUILDER
   where Upper(name)=Upper(new.name)and
         AP_BUILDER.AP_BUILDER_id<>New.AP_BUILDER_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_BUILDER
'Справочник застройщиков';

grant select, delete, insert, update, references on AP_BUILDER to adminrole;
grant select on AP_BUILDER to premises;


