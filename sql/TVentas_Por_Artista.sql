-- Total de ventas por artista
SELECT 
  da.ArtistName,
  SUM(fs.LineTotal) AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimArtist da ON da.ArtistKey = fs.ArtistKey
GROUP BY da.ArtistName
ORDER BY TotalVentas DESC;
