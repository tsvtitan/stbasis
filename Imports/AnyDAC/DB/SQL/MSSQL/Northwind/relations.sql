-- $DEFINE DELIMITER GO
ALTER TABLE [Categories] WITH NOCHECK ADD
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
 (
  [CategoryID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Customers] WITH NOCHECK ADD 
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
 (
  [CustomerID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Employees] WITH NOCHECK ADD 
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
 (
  [EmployeeID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Order Details] WITH NOCHECK ADD 
 CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED 
 (
  [OrderID],
  [ProductID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Orders] WITH NOCHECK ADD 
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
 (
  [OrderID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Products] WITH NOCHECK ADD 
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
 (
  [ProductID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Shippers] WITH NOCHECK ADD 
 CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED 
 (
  [ShipperID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Suppliers] WITH NOCHECK ADD 
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
 (
  [SupplierID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [CustomerCustomerDemo] WITH NOCHECK ADD 
 CONSTRAINT [PK_CustomerCustomerDemo] PRIMARY KEY NONCLUSTERED 
 (
  [CustomerID],
  [CustomerTypeID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [CustomerDemographics] WITH NOCHECK ADD 
 CONSTRAINT [PK_CustomerDemographics] PRIMARY KEY NONCLUSTERED 
 (
  [CustomerTypeID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [EmployeeTerritories] WITH NOCHECK ADD 
 CONSTRAINT [PK_EmployeeTerritories] PRIMARY KEY NONCLUSTERED 
 (
  [EmployeeID],
  [TerritoryID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Employees] WITH NOCHECK ADD 
 CONSTRAINT [CK_Birthdate] CHECK ([BirthDate] < getdate())
GO

ALTER TABLE [Order Details] WITH NOCHECK ADD 
 CONSTRAINT [DF_Order_Details_UnitPrice] DEFAULT (0) FOR [UnitPrice],
 CONSTRAINT [DF_Order_Details_Quantity] DEFAULT (1) FOR [Quantity],
 CONSTRAINT [DF_Order_Details_Discount] DEFAULT (0) FOR [Discount],
 CONSTRAINT [CK_Discount] CHECK ([Discount] >= 0 and [Discount] <= 1),
 CONSTRAINT [CK_Quantity] CHECK ([Quantity] > 0),
 CONSTRAINT [CK_UnitPrice] CHECK ([UnitPrice] >= 0)
GO

ALTER TABLE [Orders] WITH NOCHECK ADD 
 CONSTRAINT [DF_Orders_Freight] DEFAULT (0) FOR [Freight]
GO

ALTER TABLE [Products] WITH NOCHECK ADD 
 CONSTRAINT [DF_Products_UnitPrice] DEFAULT (0) FOR [UnitPrice],
 CONSTRAINT [DF_Products_UnitsInStock] DEFAULT (0) FOR [UnitsInStock],
 CONSTRAINT [DF_Products_UnitsOnOrder] DEFAULT (0) FOR [UnitsOnOrder],
 CONSTRAINT [DF_Products_ReorderLevel] DEFAULT (0) FOR [ReorderLevel],
 CONSTRAINT [DF_Products_Discontinued] DEFAULT (0) FOR [Discontinued],
 CONSTRAINT [CK_Products_UnitPrice] CHECK ([UnitPrice] >= 0),
 CONSTRAINT [CK_ReorderLevel] CHECK ([ReorderLevel] >= 0),
 CONSTRAINT [CK_UnitsInStock] CHECK ([UnitsInStock] >= 0),
 CONSTRAINT [CK_UnitsOnOrder] CHECK ([UnitsOnOrder] >= 0)
GO

ALTER TABLE [Region] WITH NOCHECK ADD 
 CONSTRAINT [PK_Region] PRIMARY KEY NONCLUSTERED 
 (
  [RegionID]
 ) ON [PRIMARY] 
GO

ALTER TABLE [Territories] WITH NOCHECK ADD 
 CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED 
 (
  [TerritoryID]
 ) ON [PRIMARY] 
GO

CREATE INDEX [I_Categories_CategoryName] ON [Categories]([CategoryName]) ON [PRIMARY]
GO

CREATE INDEX [I_Customers_City] ON [Customers]([City]) ON [PRIMARY]
GO

CREATE INDEX [I_Customers_CompanyName] ON [Customers]([CompanyName]) ON [PRIMARY]
GO

CREATE INDEX [I_Customers_PostalCode] ON [Customers]([PostalCode]) ON [PRIMARY]
GO

CREATE INDEX [I_Customers_Region] ON [Customers]([Region]) ON [PRIMARY]
GO

CREATE INDEX [I_Employees_LastName] ON [Employees]([LastName]) ON [PRIMARY]
GO

CREATE INDEX [I_Employees_PostalCode] ON [Employees]([PostalCode]) ON [PRIMARY]
GO

CREATE INDEX [I_OrderDetails_OrderID] ON [Order Details]([OrderID]) ON [PRIMARY]
GO

CREATE INDEX [I_OrderDetails_ProductID] ON [Order Details]([ProductID]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_CustomerID] ON [Orders]([CustomerID]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_EmployeeID] ON [Orders]([EmployeeID]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_OrderDate] ON [Orders]([OrderDate]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_ShippedDate] ON [Orders]([ShippedDate]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_ShipVia] ON [Orders]([ShipVia]) ON [PRIMARY]
GO

CREATE INDEX [I_Orders_ShipPostalCode] ON [Orders]([ShipPostalCode]) ON [PRIMARY]
GO

CREATE INDEX [I_Products_CategoryID] ON [Products]([CategoryID]) ON [PRIMARY]
GO

CREATE INDEX [I_Products_ProductName] ON [Products]([ProductName]) ON [PRIMARY]
GO

CREATE INDEX [I_Products_SupplierID] ON [Products]([SupplierID]) ON [PRIMARY]
GO

CREATE INDEX [I_Suppliers_CompanyName] ON [Suppliers]([CompanyName]) ON [PRIMARY]
GO

CREATE INDEX [I_Suppliers_PostalCode] ON [Suppliers]([PostalCode]) ON [PRIMARY]
GO

ALTER TABLE [CustomerCustomerDemo] ADD 
 CONSTRAINT [FK_CustomerCustomerDemo_CustomerDemographics] FOREIGN KEY
 (
  [CustomerTypeID]
 ) REFERENCES [CustomerDemographics] (
  [CustomerTypeID]
 ),
 CONSTRAINT [FK_CustomerCustomerDemo_Customers] FOREIGN KEY 
 (
  [CustomerID]
 ) REFERENCES [Customers] (
  [CustomerID]
 )
GO

ALTER TABLE [EmployeeTerritories] ADD 
 CONSTRAINT [FK_EmployeeTerritories_Employees] FOREIGN KEY
 (
  [EmployeeID]
 ) REFERENCES [Employees] (
  [EmployeeID]
 ),
 CONSTRAINT [FK_EmployeeTerritories_Territories] FOREIGN KEY 
 (
  [TerritoryID]
 ) REFERENCES [Territories] (
  [TerritoryID]
 )
GO

ALTER TABLE [Employees] ADD 
 CONSTRAINT [FK_Employees_Employees] FOREIGN KEY 
 (
  [ReportsTo]
 ) REFERENCES [Employees] (
  [EmployeeID]
 )
GO

ALTER TABLE [Order Details] ADD 
 CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY 
 (
  [OrderID]
 ) REFERENCES [Orders] (
  [OrderID]
 ),
 CONSTRAINT [FK_Order_Details_Products] FOREIGN KEY 
 (
  [ProductID]
 ) REFERENCES [Products] (
  [ProductID]
 )
GO

ALTER TABLE [Orders] ADD 
 CONSTRAINT [FK_Orders_Customers] FOREIGN KEY 
 (
  [CustomerID]
 ) REFERENCES [Customers] (
  [CustomerID]
 ),
 CONSTRAINT [FK_Orders_Employees] FOREIGN KEY 
 (
  [EmployeeID]
 ) REFERENCES [Employees] (
  [EmployeeID]
 ),
 CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY 
 (
  [ShipVia]
 ) REFERENCES [Shippers] (
  [ShipperID]
 )
GO

ALTER TABLE [Products] ADD 
 CONSTRAINT [FK_Products_Categories] FOREIGN KEY 
 (
  [CategoryID]
 ) REFERENCES [Categories] (
  [CategoryID]
 ),
 CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY 
 (
  [SupplierID]
 ) REFERENCES [Suppliers] (
  [SupplierID]
 )
GO

ALTER TABLE [Territories] ADD 
 CONSTRAINT [FK_Territories_Region] FOREIGN KEY 
 (
  [RegionID]
 ) REFERENCES [Region] (
  [RegionID]
 )
GO
