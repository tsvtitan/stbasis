
CREATE TABLE AP_FIELD_VIEW
(
 AP_FIELD_VIEW_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT,
 FIELDS VARCHAR(5000) CHARACTER SET WIN1251 NOT NULL COLLATE PXW_CYRL
)

ALTER TABLE AP_FIELD_VIEW
ADD PRIMARY KEY (AP_FIELD_VIEW_ID)

CREATE GENERATOR GEN_AP_FIELD_VIEW_ID;

CREATE TRIGGER AP_FIELD_VIEW_BI0 FOR AP_FIELD_VIEW
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_FIELD_VIEW where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_FIELD_VIEW_BU0 FOR AP_FIELD_VIEW
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_FIELD_VIEW
   where Upper(name)=Upper(new.name)and
         AP_FIELD_VIEW.AP_FIELD_VIEW_id<>New.AP_FIELD_VIEW_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_FIELD_VIEW
'Справочник представлений';

grant select, delete, insert, update, references on AP_FIELD_VIEW to adminrole;
grant select on AP_FIELD_VIEW to premises;


ALTER TABLE AP_FIELD_VIEW
ADD CONDITION VARCHAR(5000) CHARACTER SET WIN1251 COLLATE PXW_CYRL
