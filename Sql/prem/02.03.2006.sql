
CREATE TABLE PMS_STYLE
(
 PMS_STYLE_ID INTEGER NOT NULL,
 NAME SHORTNAME,
 NOTE NOTE,
 STYLE NOTE,
 SORTNUMBER SMALLINT
)

ALTER TABLE PMS_STYLE
ADD PRIMARY KEY (PMS_STYLE_ID)

CREATE GENERATOR GEN_PMS_STYLE_ID;

CREATE TRIGGER PMS_STYLE_BI0 FOR PMS_STYLE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   PMS_STYLE where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER PMS_STYLE_BU0 FOR PMS_STYLE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  PMS_STYLE
   where Upper(name)=Upper(new.name)and
         PMS_STYLE.PMS_STYLE_id<>New.PMS_STYLE_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

grant select, delete, insert, update, references on PMS_STYLE to adminrole;

ALTER TABLE PMS_PREMISES
ADD PMS_STYLE_ID INTEGER

ALTER TABLE PMS_PREMISES
ADD foreign KEY (PMS_STYLE_ID) references PMS_STYLE (PMS_STYLE_ID)



