
ALTER TABLE PMS_PREMISES
ADD CLIENTINFO SHORTNAME
COLLATE PXW_CYRL ;

CREATE GENERATOR CHECK_PREMISES;
SET GENERATOR CHECK_PREMISES TO 0;

SET TERM ^ ;

ALTER TRIGGER PMS_PREMISES_BI0
ACTIVE BEFORE INSERT POSITION 0
as
 declare variable ctn integer;
 declare variable flag integer;
 declare variable err varchar(200);
begin
 select gen_id(check_premises,0) from dual into flag;
 if (flag>0) then begin
   ctn=0;
   if ((new.housenumber is not null) and
      (new.apartmentnumber is not null)) then begin
    select count(*) from pms_premises
     where pms_region_id=new.pms_region_id and pms_street_id=new.pms_street_id
       and housenumber=new.housenumber and apartmentnumber=new.apartmentnumber
      into ctn;
   end
   if ((new.housenumber is null) and
      (new.apartmentnumber is null)) then begin
    select count(*) from pms_premises
     where pms_region_id=new.pms_region_id and pms_street_id=new.pms_street_id
       and housenumber is null and apartmentnumber is null
      into ctn;
   end
   if ((new.housenumber is not null) and
      (new.apartmentnumber is null)) then begin
    select count(*) from pms_premises
     where pms_region_id=new.pms_region_id and pms_street_id=new.pms_street_id
       and housenumber=new.housenumber and apartmentnumber is null
      into ctn;
   end
   if ((new.housenumber is null) and
      (new.apartmentnumber is not null)) then begin
    select count(*) from pms_premises
     where pms_region_id=new.pms_region_id and pms_street_id=new.pms_street_id
       and housenumber is null and apartmentnumber=new.apartmentnumber
      into ctn;
   end
   if (ctn>0) then begin
     err='Существует дубль предложения.';
     execute procedure error(err);
   end
 end
end

^

SET TERM ; ^



