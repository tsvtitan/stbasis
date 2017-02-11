
ALTER TABLE PMS_PREMISES
ADD NN GUIDENAMENULL

ALTER TABLE PMS_PREMISES
ADD GROUNDAREA NUMERIC(15,2)

CREATE TABLE PMS_WATER
(
 PMS_WATER_ID INTEGER NOT NULL,
 NAME SHORTNAME,
 NOTE NOTE,
 SORTNUMBER SMALLINT
)

ALTER TABLE PMS_WATER
ADD PRIMARY KEY (PMS_WATER_ID)

CREATE GENERATOR GEN_PMS_WATER_ID;

CREATE TRIGGER PMS_WATER_BI0 FOR PMS_WATER
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PMS_WATER where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PMS_WATER_BU0 FOR PMS_WATER
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PMS_WATER
   where Upper(name)=Upper(new.name)and
         PMS_WATER.PMS_WATER_id<>New.PMS_WATER_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

grant select, delete, insert, update, references on PMS_WATER to adminrole;

ALTER TABLE PMS_PREMISES
ADD PMS_WATER_ID INTEGER

ALTER TABLE PMS_PREMISES
ADD foreign KEY (PMS_WATER_ID) references PMS_WATER (PMS_WATER_ID)


CREATE TABLE PMS_HEAT
(
 PMS_HEAT_ID INTEGER NOT NULL,
 NAME SHORTNAME,
 NOTE NOTE,
 SORTNUMBER SMALLINT
)

ALTER TABLE PMS_HEAT
ADD PRIMARY KEY (PMS_HEAT_ID)

CREATE GENERATOR GEN_PMS_HEAT_ID;

CREATE TRIGGER PMS_HEAT_BI0 FOR PMS_HEAT
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PMS_HEAT where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PMS_HEAT_BU0 FOR PMS_HEAT
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PMS_HEAT
   where Upper(name)=Upper(new.name)and
         PMS_HEAT.PMS_HEAT_id<>New.PMS_HEAT_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

grant select, delete, insert, update, references on PMS_HEAT to adminrole;

ALTER TABLE PMS_PREMISES
ADD PMS_HEAT_ID INTEGER

ALTER TABLE PMS_PREMISES
ADD foreign KEY (PMS_HEAT_ID) references PMS_HEAT (PMS_HEAT_ID)

update RDB$RELATION_FIELDS set
RDB$FIELD_SOURCE = 'SHORTNAME'
where (RDB$FIELD_NAME = 'FLOOR') and
(RDB$RELATION_NAME = 'PMS_PREMISES')

