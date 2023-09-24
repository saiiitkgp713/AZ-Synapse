DROP EXTERNAL TABLE Customers
DROP EXTERNAL TABLE Categories
DROP EXTERNAL TABLE Employees
DROP EXTERNAL TABLE OrderDetails
DROP EXTERNAL TABLE Orders
DROP EXTERNAL TABLE Products
DROP EXTERNAL TABLE Shippers
DROP EXTERNAL TABLE Suppliers

DROP EXTERNAL DATA SOURCE northwind
DROP EXTERNAL FILE FORMAT csvFileformat

--ALTER DATABASE appdb 
  --  COLLATE Latin1_General_100_BIN2_UTF8 


--- Creating External Data Source for our data source (referring container)
CREATE EXTERNAL DATA SOURCE northwind 
WITH
(
    LOCATION = 'https://adeses2rg1strg1.blob.core.windows.net/northwind/'
    ----,    CREDENTIAL = -needed a scoped credential for access
)

--- Creating an external file format
CREATE EXTERNAL FILE FORMAT csvFileformat 
WITH
(
	FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',        
        STRING_DELIMITER = '0x22',     ---- For String columns enclosed in "" and have a comma in them
        ENCODING = 'UTF8',
        FIRST_ROW = 2
    )
)


-----Directly querying csv files from adlsgen2, for container : northwind
SELECT TOP 100 *
FROM
	OPENROWSET(
		BULK 'https://adeses2rg1strg1.blob.core.windows.net/northwind/suppliers.csv',
		FORMAT = 'csv',
		HEADER_ROW = TRUE,
		PARSER_VERSION = '2.0'
	) AS shippers



-----------------------------------------------------------------
---- creating Categories external table
CREATE EXTERNAL TABLE Categories
(
    [CategoryID] INT,
    [CategoryName] VARCHAR(200),
    [Description] VARCHAR(200)
)
WITH 
(
    LOCATION = 'categories.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Categories


-----------------------------------------------------------------
---- creating Customers external table
CREATE EXTERNAL TABLE Customers
(
    [CustomerID] INT,
    [CustomerName] VARCHAR(50),
    [ContactName] VARCHAR(50),
    [Address] VARCHAR(50),
    [City] VARCHAR(50),
    [PostalCode] VARCHAR(20),
    [Country] VARCHAR(20)
)
WITH 
(
    LOCATION = 'customers.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Customers


--------------------------------------------------------------
---- creating Employees external table
CREATE EXTERNAL TABLE Employees
(
    [EmployeeID] INT,
    [LastName] VARCHAR(50),
    [FirstName] VARCHAR(50),
    [BirthDate] DATETIME,
    [Photo] VARCHAR(20),
    [Notes] VARCHAR(MAX)
)
WITH 
(
    LOCATION = 'employees.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Employees


--------------------------------------------------------------
---- creating OrderDetails external table
CREATE EXTERNAL TABLE OrderDetails
(
    [OrderDetailID] INT,
    [OrderID] INT,
    [ProductID] INT,
    [Quantity] INT
)
WITH 
(
    LOCATION = 'orderdetails.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM OrderDetails



--------------------------------------------------------------
---- creating orders external table
CREATE EXTERNAL TABLE Orders
(
    [OrderID] INT,
    [CustomerID] INT,
    [EmployeeID] INT,
    [OrderDate] DATETIME,
    [ShipperID] INT
)
WITH 
(
    LOCATION = 'orders.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Orders


--------------------------------------------------------------
---- creating Products external table
CREATE EXTERNAL TABLE Products
(
    [ProductID] INT,
    [ProductName] VARCHAR(50),
    [SupplierID] INTEGER,
    [CategoryID] INTEGER,
    [Unit] VARCHAR(25),
    [Price] NUMERIC
)
WITH 
(
    LOCATION = 'products.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Products


--------------------------------------------------------------
---- creating Shippers external table
CREATE EXTERNAL TABLE Shippers
(
    [ShipperID] INT,
    [SHipperName] VARCHAR(25),
    [Phone] VARCHAR(15)
)
WITH 
(
    LOCATION = 'shippers.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Shippers



--------------------------------------------------------------
---- creating Suppliers external table
CREATE EXTERNAL TABLE Suppliers
(
    [SupplierID] INT,
    [SupplierName] VARCHAR(50),
    [ContactName] VARCHAR(50),
    [Address] VARCHAR(50),
    [City] VARCHAR(20),
    [PostalCode] VARCHAR(10),
    [Country] VARCHAR(15),
    [Phone] VARCHAR(15)
)
WITH 
(
    LOCATION = 'suppliers.csv',
    DATA_SOURCE = northwind,
    FILE_FORMAT = csvFileformat
)
SELECT TOP 5 * FROM Suppliers
