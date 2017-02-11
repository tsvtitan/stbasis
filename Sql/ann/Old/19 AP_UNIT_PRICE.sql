
CREATE TABLE AP_UNIT_PRICE
(
 AP_UNIT_PRICE_ID INTEGER NOT NULL,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_UNIT_PRICE
ADD PRIMARY KEY (AP_UNIT_PRICE_ID)

CREATE GENERATOR GEN_AP_UNIT_PRICE_ID;

CREATE TRIGGER AP_UNIT_PRICE_BI0 FOR AP_UNIT_PRICE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   AP_UNIT_PRICE where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_UNIT_PRICE_BU0 FOR AP_UNIT_PRICE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_UNIT_PRICE
   where Upper(name)=Upper(new.name)and
         AP_UNIT_PRICE.AP_UNIT_PRICE_id<>New.AP_UNIT_PRICE_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_UNIT_PRICE
'Справочник единиц измерения цены';

grant select, delete, insert, update, references on AP_UNIT_PRICE to adminrole;
grant select on AP_UNIT_PRICE to premises;


