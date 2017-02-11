/* Table: PMS_REGIONS_CORRESPOND */

SET SQL DIALECT 3;

SET NAMES WIN1251;



/****************************************************************************/
/*                                  Tables                                  */
/****************************************************************************/

CREATE TABLE PMS_DIRECTION_CORRESPOND (
    PMS_CITY_REGION_ID INTEGER NOT NULL,
    PMS_DIRECTION_ID INTEGER NOT NULL);





/****************************************************************************/
/*                            Primary Keys                                  */
/****************************************************************************/

ALTER TABLE PMS_DIRECTION_CORRESPOND ADD PRIMARY KEY (PMS_CITY_REGION_ID, PMS_DIRECTION_ID);


/****************************************************************************/
/*                               Foreign Keys                               */
/****************************************************************************/

ALTER TABLE PMS_DIRECTION_CORRESPOND ADD FOREIGN KEY (PMS_CITY_REGION_ID) REFERENCES PMS_CITY_REGION (PMS_CITY_REGION_ID);
ALTER TABLE PMS_DIRECTION_CORRESPOND ADD FOREIGN KEY (PMS_DIRECTION_ID) REFERENCES PMS_DIRECTION (PMS_DIRECTION_ID);

grant select, delete, insert, update on PMS_DIRECTION_CORRESPOND to adminrole;
grant select, delete, insert, update on PMS_DIRECTION_CORRESPOND to premises;
