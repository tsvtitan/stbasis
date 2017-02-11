/* Типы проводок - AccountType*/

CREATE TRIGGER ACCOUNTTYPE_BI0 FOR ACCOUNTTYPE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   accounttype where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Такой тип проводки <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

CREATE TRIGGER ACCOUNTTYPE_BU0 FOR ACCOUNTTYPE
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from accounttype
   where Upper(name)=Upper(new.name)and
         accounttype.accounttype_id<>New.accounttype_id into ctn;
  if (ctn>0) then begin
   err='Такой тип проводки <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

CREATE TRIGGER ACCOUNTTYPE_BD0 FOR ACCOUNTTYPE
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from stoperation_accounttype
   where stoperation_accounttype.accounttype_id =Old.accounttype_id into ctn;
  if (ctn>0) then begin
     err='Проводки этого типа <'||old.name||'> используется в типовых операциях...';
     execute procedure error(err);
  end
end;


/* country*/
CREATE TRIGGER COUNTRY_BI0 FOR COUNTRY
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from country where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then
  begin
   err='Страна с таким названием <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end


create TRIGGER DEPART_BD0
ACTIVE BEFORE DELETE POSITION 0
as
begin
  delete from depart where depart.parent_id =
    OLD.depart_id;
end;

CREATE TRIGGER TYPEDOC_BU0 FOR TYPEDOC
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from typedoc
   where Upper(name)=Upper(new.name)and
         typedoc.typedoc_id<>New.typedoc_id into ctn;
  if (ctn>0) then begin
   err='Такой тип документа <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

CREATE TRIGGER TYPEDOC_BD0 FOR TYPEDOC
ACTIVE BEFORE DELETE POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from docum
   where docum.typedoc_id =Old.typedoc_id into ctn;
  if (ctn>0) then begin
     err='Тип документа <'||old.name||'> используется в документах..';
     execute procedure error(err);
  end
end;

CREATE TRIGGER TYPELEAVE_BI0 FOR TYPELEAVE
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from
   typeLeave where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Такое тип отпусков <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

CREATE TRIGGER TYPEPAY_BI0 FOR TYPEPAY
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from typepay where Upper(name)=Upper(new.name) into ctn;
  if (ctn>0) then begin
   err='Такое тип доплаты <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

as
 declare variable ctn integer;
 declare variable err varchar(200);
begin
  select count(*) from experiencepercent
   where Upper(name)=Upper(new.name)and
         experiencepercent.typepay_id<>New.typepay_id
         into ctn;
  if (ctn>0) then begin
   err='Такой тип доплаты <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end;

Create TRIGGER TYPEPAY_BU0
ACTIVE BEFORE UPDATE POSITION 0
as
 declare variable ctn integer;
 declare variable err  varchar(200);
begin
  select count(*) from typepay
   where Upper(name)=Upper(new.name)and
         typepay.typepay_id<>New.typepay_id into ctn;
  if (ctn>0) then begin
   err='Такой вид доплаты <'||new.name||'> уже существует..';
   execute procedure error(err);
  end
end