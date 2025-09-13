CREATE DATABASE DW_Chinook;
GO
USE DW_Chinook;
GO

-- STAGING que faltan
IF OBJECT_ID('dw.stg_Invoice') IS NULL
CREATE TABLE dw.stg_Invoice(
  InvoiceId INT, CustomerId INT, InvoiceDate DATETIME,
  BillingAddress NVARCHAR(120), BillingCity NVARCHAR(80),
  BillingState NVARCHAR(80), BillingCountry NVARCHAR(80),
  BillingPostalCode NVARCHAR(20), Total DECIMAL(12,2)
);

IF OBJECT_ID('dw.stg_InvoiceLine') IS NULL
CREATE TABLE dw.stg_InvoiceLine(
  InvoiceLineId INT, InvoiceId INT, TrackId INT,
  UnitPrice DECIMAL(10,2), Quantity INT
);

IF OBJECT_ID('dw.stg_Track') IS NULL
CREATE TABLE dw.stg_Track(
  TrackId INT, Name NVARCHAR(200), AlbumId INT NULL,
  MediaTypeId INT, GenreId INT NULL, Composer NVARCHAR(220) NULL,
  Milliseconds INT, Bytes INT NULL, UnitPrice DECIMAL(10,2)
);

IF OBJECT_ID('dw.stg_Album') IS NULL
CREATE TABLE dw.stg_Album(AlbumId INT, Title NVARCHAR(160), ArtistId INT);

IF OBJECT_ID('dw.stg_MediaType') IS NULL
CREATE TABLE dw.stg_MediaType(MediaTypeId INT, Name NVARCHAR(120));

CREATE SCHEMA dw;  -- “carpeta lógica” para tablas del DW
GO

-- DimDate
CREATE TABLE dw.DimDate(
  DateKey INT PRIMARY KEY, [Date] DATE NOT NULL,
  [Year] INT, [Quarter] TINYINT, [Month] TINYINT, [MonthName] VARCHAR(12),
  [Day] TINYINT, [Week] TINYINT
);

-- DimCustomer
CREATE TABLE dw.DimCustomer(
  CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
  CustomerId_NK INT NOT NULL UNIQUE,
  FirstName NVARCHAR(40), LastName NVARCHAR(20),
  Company NVARCHAR(80), City NVARCHAR(40), State NVARCHAR(40),
  Country NVARCHAR(40), Email NVARCHAR(60)
);

-- DimArtist
CREATE TABLE dw.DimArtist(
  ArtistKey INT IDENTITY(1,1) PRIMARY KEY,
  ArtistId_NK INT NOT NULL UNIQUE,
  ArtistName NVARCHAR(120) NOT NULL
);

-- DimGenre
CREATE TABLE dw.DimGenre(
  GenreKey INT IDENTITY(1,1) PRIMARY KEY,
  GenreId_NK INT NOT NULL UNIQUE,
  GenreName NVARCHAR(120) NOT NULL
);

-- DimTrack
CREATE TABLE dw.DimTrack(
  TrackKey INT IDENTITY(1,1) PRIMARY KEY,
  TrackId_NK INT NOT NULL UNIQUE,
  TrackName NVARCHAR(200) NOT NULL,
  AlbumId_NK INT NULL, MediaTypeId_NK INT NULL,
  Milliseconds INT NULL, Bytes INT NULL, UnitPriceSrc NUMERIC(10,2) NULL
);

-- FactSales
CREATE TABLE dw.FactSales(
  FactSalesId BIGINT IDENTITY(1,1) PRIMARY KEY,
  DateKey INT NOT NULL,
  CustomerKey INT NOT NULL,
  ArtistKey INT NOT NULL,
  GenreKey INT NOT NULL,
  TrackKey INT NULL,
  InvoiceId_DD INT NOT NULL,
  InvoiceLineId_DD INT NOT NULL,
  Quantity INT NOT NULL,
  UnitPrice NUMERIC(10,2) NOT NULL,
  LineTotal NUMERIC(12,2) NOT NULL,
  CONSTRAINT FK_Fact_Date   FOREIGN KEY (DateKey)    REFERENCES dw.DimDate(DateKey),
  CONSTRAINT FK_Fact_Cust   FOREIGN KEY (CustomerKey)REFERENCES dw.DimCustomer(CustomerKey),
  CONSTRAINT FK_Fact_Artist FOREIGN KEY (ArtistKey)  REFERENCES dw.DimArtist(ArtistKey),
  CONSTRAINT FK_Fact_Genre  FOREIGN KEY (GenreKey)   REFERENCES dw.DimGenre(GenreKey),
  CONSTRAINT FK_Fact_Track  FOREIGN KEY (TrackKey)   REFERENCES dw.DimTrack(TrackKey)
);

CREATE INDEX IX_FactSales_Date   ON dw.FactSales(DateKey);
CREATE INDEX IX_FactSales_Cust   ON dw.FactSales(CustomerKey);
CREATE INDEX IX_FactSales_Artist ON dw.FactSales(ArtistKey);
CREATE INDEX IX_FactSales_Genre  ON dw.FactSales(GenreKey);


TRUNCATE TABLE dw.stg_Invoice;
INSERT INTO dw.stg_Invoice
(InvoiceId,CustomerId,InvoiceDate,BillingAddress,BillingCity,BillingState,BillingCountry,BillingPostalCode,Total)
SELECT InvoiceId,CustomerId,InvoiceDate,BillingAddress,BillingCity,BillingState,BillingCountry,BillingPostalCode,Total
FROM   Chinook.dbo.Invoice;

TRUNCATE TABLE dw.stg_InvoiceLine;
INSERT INTO dw.stg_InvoiceLine (InvoiceLineId,InvoiceId,TrackId,UnitPrice,Quantity)
SELECT InvoiceLineId,InvoiceId,TrackId,UnitPrice,Quantity
FROM   Chinook.dbo.InvoiceLine;

TRUNCATE TABLE dw.stg_Track;
INSERT INTO dw.stg_Track (TrackId,Name,AlbumId,MediaTypeId,GenreId,Composer,Milliseconds,Bytes,UnitPrice)
SELECT TrackId,Name,AlbumId,MediaTypeId,GenreId,Composer,Milliseconds,Bytes,UnitPrice
FROM   Chinook.dbo.Track;

TRUNCATE TABLE dw.stg_Album;
INSERT INTO dw.stg_Album (AlbumId,Title,ArtistId)
SELECT AlbumId,Title,ArtistId
FROM   Chinook.dbo.Album;

TRUNCATE TABLE dw.stg_MediaType;
INSERT INTO dw.stg_MediaType (MediaTypeId,Name)
SELECT MediaTypeId,Name
FROM   Chinook.dbo.MediaType;

-- Validación rápida
SELECT 'stg_Invoice'     AS tbl, COUNT(*) c FROM dw.stg_Invoice     UNION ALL
SELECT 'stg_InvoiceLine' AS tbl, COUNT(*) c FROM dw.stg_InvoiceLine UNION ALL
SELECT 'stg_Track'       AS tbl, COUNT(*) c FROM dw.stg_Track       UNION ALL
SELECT 'stg_Album'       AS tbl, COUNT(*) c FROM dw.stg_Album       UNION ALL
SELECT 'stg_MediaType'   AS tbl, COUNT(*) c FROM dw.stg_MediaType;
