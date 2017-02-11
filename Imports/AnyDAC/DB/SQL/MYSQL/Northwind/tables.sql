--  $DEFINE DELIMITER ;

DROP TABLE `Order Details`;

CREATE TABLE `Order Details` (
  `OrderID` int(11) NOT NULL default '0',
  `ProductID` int(11) NOT NULL default '0',
  `UnitPrice` decimal(19,4) NOT NULL default '0.0000',
  `Quantity` smallint(6) NOT NULL default '0',
  `Discount` float NOT NULL default '0',
  PRIMARY KEY  (`OrderID`,`ProductID`)
) TYPE=InnoDB;

DROP TABLE `Products`;

CREATE TABLE `Products` (
  `ProductID` int(11) NOT NULL auto_increment,
  `ProductName` varchar(40) NOT NULL default '',
  `SupplierID` int(11) default NULL,
  `CategoryID` int(11) default NULL,
  `QuantityPerUnit` varchar(20) default NULL,
  `UnitPrice` decimal(19,4) default NULL,
  `UnitsInStock` smallint(6) default NULL,
  `UnitsOnOrder` smallint(6) default NULL,
  `ReorderLevel` smallint(6) default NULL,
  `Discontinued` bit default 0,
  PRIMARY KEY  (`ProductID`)
) TYPE=InnoDB;

DROP TABLE `Categories`;

CREATE TABLE `Categories` (
  `CategoryID` int(11) NOT NULL auto_increment,
  `CategoryName` varchar(15) NOT NULL default '',
  `Description` mediumtext,
  `Picture` longblob,
  PRIMARY KEY  (`CategoryID`)
) TYPE=InnoDB;

DROP TABLE `Suppliers`;

CREATE TABLE `Suppliers` (
  `SupplierID` int(11) NOT NULL auto_increment,
  `CompanyName` varchar(40) NOT NULL default '',
  `ContactName` varchar(30) default NULL,
  `ContactTitle` varchar(30) default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `Phone` varchar(24) default NULL,
  `Fax` varchar(24) default NULL,
  `HomePage` mediumtext,
  PRIMARY KEY  (`SupplierID`)
) TYPE=InnoDB;

DROP TABLE `EmployeeTerritories`;

CREATE TABLE `EmployeeTerritories` (
  `EmployeeID` int(11) NOT NULL default '0',
  `TerritoryID` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`EmployeeID`,`TerritoryID`)
) TYPE=InnoDB;

DROP TABLE `Territories`;

CREATE TABLE `Territories` (
  `TerritoryID` varchar(20) NOT NULL default '',
  `TerritoryDescription` varchar(50) NOT NULL default '',
  `RegionID` int(11) NOT NULL default '0',
  PRIMARY KEY  (`TerritoryID`)
) TYPE=InnoDB;

DROP TABLE `Region`;

CREATE TABLE `Region` (
  `RegionID` int(11) NOT NULL auto_increment,
  `RegionDescription` char(50) NOT NULL default '',
  PRIMARY KEY  (`RegionID`)
) TYPE=InnoDB;

DROP TABLE `Orders`;

CREATE TABLE `Orders` (
  `OrderID` int(11) NOT NULL auto_increment,
  `CustomerID` varchar(5) default NULL,
  `EmployeeID` int(11) default NULL,
  `OrderDate` datetime default NULL,
  `RequiredDate` datetime default NULL,
  `ShippedDate` datetime default NULL,
  `ShipVia` int(11) default NULL,
  `Freight` decimal(19,4) default NULL,
  `ShipName` varchar(40) default NULL,
  `ShipAddress` varchar(60) default NULL,
  `ShipCity` varchar(15) default NULL,
  `ShipRegion` varchar(15) default NULL,
  `ShipPostalCode` varchar(10) default NULL,
  `ShipCountry` varchar(15) default NULL,
  PRIMARY KEY  (`OrderID`)
) TYPE=InnoDB;

DROP TABLE `Employees`;

CREATE TABLE `Employees` (
  `EmployeeID` int(11) NOT NULL auto_increment,
  `LastName` varchar(20) NOT NULL default '',
  `FirstName` varchar(10) NOT NULL default '',
  `Title` varchar(30) default NULL,
  `TitleOfCourtesy` varchar(25) default NULL,
  `BirthDate` datetime default NULL,
  `HireDate` datetime default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `HomePhone` varchar(24) default NULL,
  `Extension` varchar(4) default NULL,
  `Photo` longblob,
  `Notes` mediumtext,
  `ReportsTo` int(11) default NULL,
  `PhotoPath` varchar(255) default NULL,
  PRIMARY KEY  (`EmployeeID`)
) TYPE=InnoDB;

DROP TABLE `Shippers`;

CREATE TABLE `Shippers` (
  `ShipperID` int(11) NOT NULL auto_increment,
  `CompanyName` varchar(40) NOT NULL default '',
  `Phone` varchar(24) default NULL,
  PRIMARY KEY  (`ShipperID`)
) TYPE=InnoDB;

DROP TABLE `CustomerCustomerDemo`;

CREATE TABLE `CustomerCustomerDemo` (
  `CustomerID` varchar(5) NOT NULL default '',
  `CustomerTypeID` varchar(10) NOT NULL default '',
  PRIMARY KEY  (`CustomerID`,`CustomerTypeID`)
) TYPE=InnoDB;

DROP TABLE `CustomerDemographics`;

CREATE TABLE `CustomerDemographics` (
  `CustomerTypeID` varchar(10) NOT NULL default '',
  `CustomerDesc` mediumtext,
  PRIMARY KEY  (`CustomerTypeID`)
) TYPE=InnoDB;

DROP TABLE `Customers`;

CREATE TABLE `Customers` (
  `CustomerID` varchar(5) NOT NULL default '',
  `CompanyName` varchar(40) NOT NULL default '',
  `ContactName` varchar(30) default NULL,
  `ContactTitle` varchar(30) default NULL,
  `Address` varchar(60) default NULL,
  `City` varchar(15) default NULL,
  `Region` varchar(15) default NULL,
  `PostalCode` varchar(10) default NULL,
  `Country` varchar(15) default NULL,
  `Phone` varchar(24) default NULL,
  `Fax` varchar(24) default NULL,
  PRIMARY KEY  (`CustomerID`)
) TYPE=InnoDB;