

CREATE TABLE AP_OPERATION
(
 AP_OPERATION_ID INTEGER NOT NULL,
 AP_FIELD_VIEW_ID INTEGER,
 PARENT_ID INTEGER,
 NAME GUIDENAME,
 FULLNAME NOTE,
 PRIORITY SMALLINT
)

ALTER TABLE AP_OPERATION
ADD PRIMARY KEY (AP_OPERATION_ID)

ALTER TABLE AP_OPERATION ADD
FOREIGN KEY (AP_FIELD_VIEW_ID) REFERENCES AP_FIELD_VIEW (AP_FIELD_VIEW_ID);

ALTER TABLE AP_OPERATION ADD
FOREIGN KEY (PARENT_ID) REFERENCES AP_OPERATION (AP_OPERATION_ID);

CREATE GENERATOR GEN_AP_OPERATION_ID;

CREATE TRIGGER AP_OPERATION_BI0 FOR AP_OPERATION
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from AP_OPERATION
   where Upper(name)=Upper(new.name)
     and parent_id=new.parent_id
   into ctn;
  if (ctn>0) then begin
   err='Наименование <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end

CREATE TRIGGER AP_OPERATION_BU0 FOR AP_OPERATION
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from  AP_OPERATION
   where Upper(name)=Upper(new.name)
     and parent_id=new.parent_id
     and AP_OPERATION.AP_OPERATION_id<>New.AP_OPERATION_id into ctn;
  if (ctn>0) then begin
     err='Наименование <'||new.name||'> уже существует..';
     execute procedure error(err);
  end
end

DESCRIBE TABLE AP_OPERATION
'Справочник операция с недвижимостью';

grant select, delete, insert, update, references on AP_OPERATION to adminrole;
grant select on AP_OPERATION to premises;

CREATE PROCEDURE CREATE_OPERATION_TREE (
    PARENT_ID INTEGER,
    INCVALUE INTEGER)
RETURNS (
    ap_operation_ID INTEGER,
    INC INTEGER)
AS
DECLARE VARIABLE ID INTEGER;
begin
  if (incvalue is null) then
   inc=0;
  else inc=incvalue;
  if (parent_id is not null) then begin
    for select ap_operation_id
          from ap_operation
         where parent_id=:parent_id
      order by priority
          into :id  do begin
      ap_operation_id=id;
      inc=inc+1;
      suspend;
      for select ap_operation_id, inc from CREATE_OPERATION_TREE(:id,:inc) into id,inc do begin
        ap_operation_id=id;
        inc=inc+1;
        suspend;
      end
    end
  end else begin
    for select ap_operation_id
          from ap_operation
         where parent_id is null
      order by priority
          into :id  do begin
      ap_operation_id=id;
      inc=inc+1;
      suspend;
      for select ap_operation_id, inc from CREATE_OPERATION_TREE(:id,:inc) into id,inc do begin
        ap_operation_id=id;
        inc=inc+1;
        suspend;
      end
    end
  end
end

grant execute on procedure CREATE_OPERATION_TREE to adminrole;
grant execute on procedure CREATE_OPERATION_TREE to premises;

