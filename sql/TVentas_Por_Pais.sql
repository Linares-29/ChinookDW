--Total de ventas por país
SELECT 
  dc.Country,
  SUM(fs.LineTotal) AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimCustomer dc ON dc.CustomerKey = fs.CustomerKey
GROUP BY dc.Country
ORDER BY TotalVentas DESC;

USE DW_Chinook;
GO

SELECT TOP 10 * FROM dw.DimCustomer;
SELECT COUNT(*) FROM dw.DimCustomer;

SELECT TOP 10 * FROM dw.DimArtist;
SELECT COUNT(*) FROM dw.DimArtist;

SELECT TOP 10 * FROM dw.DimGenre;
SELECT COUNT(*) FROM dw.DimGenre;
