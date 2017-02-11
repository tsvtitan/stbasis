-- $DEFINE DELIMITER GO

DROP TABLE [Order Details]
GO

CREATE TABLE [Order Details] (
  [OrderID] [int] NOT NULL ,
  [ProductID] [int] NOT NULL ,
  [UnitPrice] [money] NOT NULL ,
  [Quantity] [smallint] NOT NULL ,
  [Discount] [real] NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [Products]
GO

CREATE TABLE [Products] (
  [ProductID] [int] IDENTITY (1, 1) NOT NULL ,
  [ProductName] [nvarchar] (40) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [SupplierID] [int] NULL ,
  [CategoryID] [int] NULL ,
  [QuantityPerUnit] [nvarchar] (20) COLLATE Cyrillic_General_CI_AS NULL ,
  [UnitPrice] [money] NULL ,
  [UnitsInStock] [smallint] NULL ,
  [UnitsOnOrder] [smallint] NULL ,
  [ReorderLevel] [smallint] NULL ,
  [Discontinued] [bit] NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [Categories]
GO

CREATE TABLE [Categories] (
  [CategoryID] [int] IDENTITY (1, 1) NOT NULL ,
  [CategoryName] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [Description] [ntext] COLLATE Cyrillic_General_CI_AS NULL ,
  [Picture] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [Suppliers]
GO

CREATE TABLE [Suppliers] (
  [SupplierID] [int] IDENTITY (1, 1) NOT NULL ,
  [CompanyName] [nvarchar] (40) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [ContactName] [nvarchar] (30) COLLATE Cyrillic_General_CI_AS NULL ,
  [ContactTitle] [nvarchar] (30) COLLATE Cyrillic_General_CI_AS NULL ,
  [Address] [nvarchar] (60) COLLATE Cyrillic_General_CI_AS NULL ,
  [City] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [Region] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [PostalCode] [nvarchar] (10) COLLATE Cyrillic_General_CI_AS NULL ,
  [Country] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [Phone] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL ,
  [Fax] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL ,
  [HomePage] [ntext] COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [EmployeeTerritories]
GO

CREATE TABLE [EmployeeTerritories] (
  [EmployeeID] [int] NOT NULL ,
  [TerritoryID] [nvarchar] (20) COLLATE Cyrillic_General_CI_AS NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [Territories]
GO

CREATE TABLE [Territories] (
  [TerritoryID] [nvarchar] (20) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [TerritoryDescription] [nchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [RegionID] [int] NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [Region]
GO

CREATE TABLE [Region] (
  [RegionID] [int] NOT NULL ,
  [RegionDescription] [nchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [Orders]
GO

CREATE TABLE [Orders] (
  [OrderID] [int] IDENTITY (1, 1) NOT NULL ,
  [CustomerID] [nchar] (5) COLLATE Cyrillic_General_CI_AS NULL ,
  [EmployeeID] [int] NULL ,
  [OrderDate] [datetime] NULL ,
  [RequiredDate] [datetime] NULL ,
  [ShippedDate] [datetime] NULL ,
  [ShipVia] [int] NULL ,
  [Freight] [money] NULL ,
  [ShipName] [nvarchar] (40) COLLATE Cyrillic_General_CI_AS NULL ,
  [ShipAddress] [nvarchar] (60) COLLATE Cyrillic_General_CI_AS NULL ,
  [ShipCity] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [ShipRegion] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [ShipPostalCode] [nvarchar] (10) COLLATE Cyrillic_General_CI_AS NULL ,
  [ShipCountry] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
GO

DROP TABLE [Employees]
GO 

CREATE TABLE [Employees] (
  [EmployeeID] [int] IDENTITY (1, 1) NOT NULL ,
  [LastName] [nvarchar] (20) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [FirstName] [nvarchar] (10) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [Title] [nvarchar] (30) COLLATE Cyrillic_General_CI_AS NULL ,
  [TitleOfCourtesy] [nvarchar] (25) COLLATE Cyrillic_General_CI_AS NULL ,
  [BirthDate] [datetime] NULL ,
  [HireDate] [datetime] NULL ,
  [Address] [nvarchar] (60) COLLATE Cyrillic_General_CI_AS NULL ,
  [City] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [Region] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [PostalCode] [nvarchar] (10) COLLATE Cyrillic_General_CI_AS NULL ,
  [Country] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [HomePhone] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL ,
  [Extension] [nvarchar] (4) COLLATE Cyrillic_General_CI_AS NULL ,
  [Photo] [image] NULL ,
  [Notes] [ntext] COLLATE Cyrillic_General_CI_AS NULL ,
  [ReportsTo] [int] NULL ,
  [PhotoPath] [nvarchar] (255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [Shippers]
GO

CREATE TABLE [Shippers] (
  [ShipperID] [int] IDENTITY (1, 1) NOT NULL ,
  [CompanyName] [nvarchar] (40) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [Phone] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL 
) ON [PRIMARY]
GO

DROP TABLE [CustomerCustomerDemo]
GO

CREATE TABLE [CustomerCustomerDemo] (
  [CustomerID] [nchar] (5) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [CustomerTypeID] [nchar] (10) COLLATE Cyrillic_General_CI_AS NOT NULL
) ON [PRIMARY]
GO

DROP TABLE [CustomerDemographics]
GO

CREATE TABLE [CustomerDemographics] (
  [CustomerTypeID] [nchar] (10) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [CustomerDesc] [ntext] COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

DROP TABLE [Customers]
GO

CREATE TABLE [Customers] (
  [CustomerID] [nchar] (5) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [CompanyName] [nvarchar] (40) COLLATE Cyrillic_General_CI_AS NOT NULL ,
  [ContactName] [nvarchar] (30) COLLATE Cyrillic_General_CI_AS NULL ,
  [ContactTitle] [nvarchar] (30) COLLATE Cyrillic_General_CI_AS NULL ,
  [Address] [nvarchar] (60) COLLATE Cyrillic_General_CI_AS NULL ,
  [City] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [Region] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [PostalCode] [nvarchar] (10) COLLATE Cyrillic_General_CI_AS NULL ,
  [Country] [nvarchar] (15) COLLATE Cyrillic_General_CI_AS NULL ,
  [Phone] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL ,
  [Fax] [nvarchar] (24) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
GO 
