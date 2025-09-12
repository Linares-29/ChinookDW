USE DW_Chinook;
GO

USE DW_Chinook;
GO

--Total de ventas por país
SELECT 
  dc.Country,
  SUM(fs.LineTotal) AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimCustomer dc ON dc.CustomerKey = fs.CustomerKey
GROUP BY dc.Country
ORDER BY TotalVentas DESC;

-- Conteo y muestra de la tabla de hechos
USE DW_Chinook;
SELECT COUNT(*) AS FactSalesRows FROM dw.FactSales;
SELECT TOP 10 * FROM dw.FactSales ORDER BY FactSalesId;


USE DW_Chinook;
GO

SELECT TOP 10 * FROM dw.DimCustomer;
SELECT COUNT(*) FROM dw.DimCustomer;

SELECT TOP 10 * FROM dw.DimArtist;
SELECT COUNT(*) FROM dw.DimArtist;

SELECT TOP 10 * FROM dw.DimGenre;
SELECT COUNT(*) FROM dw.DimGenre;
