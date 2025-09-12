USE DW_Chinook;
GO

--Total de ventas por género musical
SELECT 
  dg.GenreName,
  SUM(fs.LineTotal) AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimGenre dg ON dg.GenreKey = fs.GenreKey
GROUP BY dg.GenreName
ORDER BY TotalVentas DESC;
