alter table pms_premises
add pms_city_region_id integer

CREATE TABLE PMS_CITY_REGION (
    PMS_CITY_REGION_ID INTEGER NOT NULL,
    NAME GUIDENAME,
    SORTNUMBER INTEGER NOT NULL);


ALTER TABLE PMS_CITY_REGION ADD PRIMARY KEY (PMS_CITY_REGION_ID);

ALTER TABLE pms_premises
ADD foreign KEY (PMS_CITY_REGION_ID) references PMS_CITY_REGION(PMS_CITY_REGION_id)

grant select, delete, insert, update on PMS_CITY_REGION to adminrole

grant select, delete, insert, update on PMS_CITY_REGION to premises


alter table pms_advertisment
add typeoperation integer

update RDB$RELATION_FIELDS set
RDB$FIELD_SOURCE = 'GUIDENAME'
where (RDB$FIELD_NAME = 'NAME') and
(RDB$RELATION_NAME = 'PMS_ADVERTISMENT')

alter table sync_office
add CONTACT NOTE

/* backup restore */



