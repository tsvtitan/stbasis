alter table pms_builder
add phones varchar(1000)

CREATE TABLE PMS_INVESTOR
(
 PMS_INVESTOR_ID INTEGER NOT NULL,
 NAME SHORTNAME,
 NOTE NOTE,
 SORTNUMBER SMALLINT,
 PHONES VARCHAR(1000)
)

ALTER TABLE PMS_INVESTOR
ADD PRIMARY KEY (PMS_INVESTOR_ID)

CREATE GENERATOR GEN_PMS_INVESTOR_ID;

CREATE TRIGGER PMS_INVESTOR_BI0 FOR PMS_INVESTOR
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PMS_INVESTOR where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PMS_INVESTOR_BU0 FOR PMS_INVESTOR
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PMS_INVESTOR
   where Upper(name)=Upper(new.name)and
         PMS_INVESTOR.PMS_INVESTOR_id<>New.PMS_INVESTOR_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

grant select, delete, insert, update, references on PMS_INVESTOR to adminrole;

grant select on PMS_INVESTOR to premises;
