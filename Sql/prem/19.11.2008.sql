
drop view pms_premises_phone3
drop view pms_premises_phone2
drop view pms_premises_phone1

create view pms_premises_phone1 (pms_premises_id, phone1,pos1,contact1,contact)
as
select pms_premises_id,
       (cast (substrex(contact,1,sys_ansipos(',',contact)-1) as varchar(100))) as phone1,
       sys_ansipos(',',contact) as pos1,
       (cast (rtrim(ltrim(substrex(contact,sys_ansipos(',',contact)+1,strlen(contact)))) as varchar(250))) as contact1,
       contact
  from pms_premises


create view pms_premises_phone2 (pms_premises_id,phone1,pos1,contact1,phone2,pos2,contact2,contact)
as
select pms_premises_id,
       phone1, pos1, contact1,
       (cast (substrex(contact1,1,sys_ansipos(',',contact1)-1) as varchar(100))) as phone2,
       sys_ansipos(',',contact1) as pos2,
       (cast (rtrim(ltrim(substrex(contact1,sys_ansipos(',',contact1)+1,strlen(contact1)))) as varchar(250))) as contact2,
       contact
  from pms_premises_phone1


create view pms_premises_phone3 (pms_premises_id,phone1,pos1,contact1,phone2,pos2,contact2,phone3,pos3,contact3,contact)
as
select pms_premises_id,
       phone1, pos1, contact1,
       phone2, pos2, contact2,
       (cast (substrex(contact2,1,sys_ansipos(',',contact2)-1) as varchar(100))) as phone3,
       sys_ansipos(',',contact2) as pos3,
       (cast (rtrim(ltrim(substrex(contact2,sys_ansipos(',',contact2)+1,strlen(contact2)))) as varchar(250))) as contact3,
       contact
  from pms_premises_phone2


create view pms_premises_phone4 (pms_premises_id,phone1,phone2,phone3,phone4)
as
select pms_premises_id,
       phone1, phone2, phone3, contact3
  from pms_premises_phone3
