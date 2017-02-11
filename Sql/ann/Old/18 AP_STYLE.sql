
CREATE TABLE AP_STYLE
(
 AP_STYLE_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_STYLE
ADD PRIMARY KEY (AP_STYLE_ID)

CREATE GENERATOR GEN_AP_STYLE_ID;

CREATE TRIGGER AP_STYLE_BI0 FOR AP_STYLE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_STYLE where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_STYLE_BU0 FOR AP_STYLE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_STYLE
   where Upper(name)=Upper(new.name)and
         AP_STYLE.AP_STYLE_id<>New.AP_STYLE_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_STYLE
'Справочник стилей';

grant select, delete, insert, update, references on AP_STYLE to adminrole;
grant select on AP_STYLE to premises;


