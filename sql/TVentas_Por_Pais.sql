-- 4) Total de ventas por país
SELECT 
  dc.Country,
  SUM(fs.LineTotal) AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimCustomer dc ON dc.CustomerKey = fs.CustomerKey
GROUP BY dc.Country
ORDER BY TotalVentas DESC;
