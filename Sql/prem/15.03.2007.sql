CREATE TABLE PMS_REGIONS_CORRESPOND (
    PMS_CITY_REGION_ID INTEGER NOT NULL,
    PMS_REGION_ID INTEGER NOT NULL);


ALTER TABLE pms_regions_correspond ADD PRIMARY KEY (PMS_CITY_REGION_ID,PMS_REGION_ID);

alter table pms_regions_correspond
add foreign key (PMS_CITY_REGION_ID) references PMS_CITY_REGION (PMS_CITY_REGION_ID);

alter table pms_regions_correspond
add foreign key (PMS_REGION_ID) references PMS_REGION (PMS_REGION_ID);


grant select, delete, insert, update on PMS_REGIONS_CORRESPOND to adminrole;
grant select, delete, insert, update on PMS_REGIONS_CORRESPOND to premises;
