USE Chinook;
GO
CREATE OR ALTER VIEW dbo.v_FactSalesSource AS
SELECT
  i.InvoiceId,
  il.InvoiceLineId,
  CAST(i.InvoiceDate AS DATE) AS InvoiceDate,
  i.CustomerId,
  t.TrackId, t.GenreId, al.ArtistId,
  il.Quantity,
  il.UnitPrice,
  CAST(il.Quantity*il.UnitPrice AS NUMERIC(12,2)) AS LineTotal
FROM InvoiceLine il
JOIN Invoice  i  ON i.InvoiceId  = il.InvoiceId
JOIN Track    t  ON t.TrackId    = il.TrackId
JOIN Album    al ON al.AlbumId   = t.AlbumId;


-- crea el esquema dw si hace falta
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw')
    EXEC('CREATE SCHEMA dw');

-- crea la staging
IF OBJECT_ID('dw.stg_DimCustomer') IS NULL
CREATE TABLE dw.stg_DimCustomer(
  CustomerId INT,
  FirstName  NVARCHAR(40),
  LastName   NVARCHAR(20),
  Company    NVARCHAR(80),
  City       NVARCHAR(40),
  State      NVARCHAR(40),
  Country    NVARCHAR(40),
  Email      NVARCHAR(60)
);

SELECT * FROM sys.tables WHERE name = 'stg_DimCustomer';



SELECT DB_NAME() AS DB;
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name = 'stg_DimCustomer';

USE DW_Chinook;
-- staging para DimArtist
IF OBJECT_ID('dw.stg_DimArtist') IS NULL
CREATE TABLE dw.stg_DimArtist(
  ArtistId   INT,
  ArtistName NVARCHAR(120)
);

-- dimensión final
IF OBJECT_ID('dw.DimArtist') IS NULL
CREATE TABLE dw.DimArtist(
  ArtistKey   INT IDENTITY(1,1) PRIMARY KEY,
  ArtistId_NK INT NOT NULL UNIQUE,
  ArtistName  NVARCHAR(120) NOT NULL
);

SELECT COUNT(*) FROM dw.DimArtist;
SELECT TOP 5 * FROM dw.DimArtist;

USE DW_Chinook;

-- staging
IF OBJECT_ID('dw.stg_DimGenre') IS NULL
CREATE TABLE dw.stg_DimGenre(
  GenreId   INT,
  GenreName NVARCHAR(120)
);

-- dimensión final
IF OBJECT_ID('dw.DimGenre') IS NULL
CREATE TABLE dw.DimGenre(
  GenreKey   INT IDENTITY(1,1) PRIMARY KEY,
  GenreId_NK INT NOT NULL UNIQUE,
  GenreName  NVARCHAR(120) NOT NULL
);

SELECT COUNT(*) FROM dw.DimGenre;
SELECT TOP 5 * FROM dw.DimGenre;

SELECT COUNT(*) FROM dw.DimDate;
SELECT TOP 5 * FROM dw.DimDate;

USE DW_Chinook;
IF OBJECT_ID('dw.FactSales') IS NULL
CREATE TABLE dw.FactSales(
  FactSalesId      BIGINT IDENTITY(1,1) PRIMARY KEY,
  DateKey          INT NOT NULL,
  CustomerKey      INT NOT NULL,
  ArtistKey        INT NOT NULL,
  GenreKey         INT NOT NULL,
  InvoiceId_DD     INT NOT NULL,
  InvoiceLineId_DD INT NOT NULL,
  Quantity         INT NOT NULL,
  UnitPrice        NUMERIC(10,2) NOT NULL,
  LineTotal        NUMERIC(12,2) NOT NULL,
  CONSTRAINT FK_Fact_Date   FOREIGN KEY (DateKey)     REFERENCES dw.DimDate(DateKey),
  CONSTRAINT FK_Fact_Cust   FOREIGN KEY (CustomerKey) REFERENCES dw.DimCustomer(CustomerKey),
  CONSTRAINT FK_Fact_Artist FOREIGN KEY (ArtistKey)   REFERENCES dw.DimArtist(ArtistKey),
  CONSTRAINT FK_Fact_Genre  FOREIGN KEY (GenreKey)    REFERENCES dw.DimGenre(GenreKey)
);

SELECT COUNT(*) FROM dw.FactSales;
SELECT TOP 10 * FROM dw.FactSales ORDER BY FactSalesId;

