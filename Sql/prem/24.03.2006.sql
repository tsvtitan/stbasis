
ALTER TABLE PMS_PREMISES
ADD DELIVERY GUIDENAMENULL

CREATE TABLE PMS_BUILDER
(
 PMS_BUILDER_ID INTEGER NOT NULL,
 NAME SHORTNAME,
 NOTE NOTE,
 SORTNUMBER SMALLINT
)

ALTER TABLE PMS_BUILDER
ADD PRIMARY KEY (PMS_BUILDER_ID)

CREATE GENERATOR GEN_PMS_BUILDER_ID;

CREATE TRIGGER PMS_BUILDER_BI0 FOR PMS_BUILDER
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PMS_BUILDER where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PMS_BUILDER_BU0 FOR PMS_BUILDER
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PMS_BUILDER
   where Upper(name)=Upper(new.name)and
         PMS_BUILDER.PMS_BUILDER_id<>New.PMS_BUILDER_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

grant select, delete, insert, update, references on PMS_BUILDER to adminrole;

grant select on PMS_BUILDER to premises;

ALTER TABLE PMS_PREMISES
ADD PMS_BUILDER_ID INTEGER

ALTER TABLE PMS_PREMISES
ADD foreign KEY (PMS_BUILDER_ID) references PMS_BUILDER (PMS_BUILDER_ID)



