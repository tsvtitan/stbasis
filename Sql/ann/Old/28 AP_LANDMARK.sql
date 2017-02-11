
CREATE TABLE AP_LANDMARK
(
 AP_LANDMARK_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_LANDMARK
ADD PRIMARY KEY (AP_LANDMARK_ID)

CREATE GENERATOR GEN_AP_LANDMARK_ID;

CREATE TRIGGER AP_LANDMARK_BI0 FOR AP_LANDMARK
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_LANDMARK where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_LANDMARK_BU0 FOR AP_LANDMARK
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_LANDMARK
   where Upper(name)=Upper(new.name)and
         AP_LANDMARK.AP_LANDMARK_id<>New.AP_LANDMARK_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_LANDMARK
'Справочник ориентиров';

grant select, delete, insert, update, references on AP_LANDMARK to adminrole;
grant select on AP_LANDMARK to premises;


