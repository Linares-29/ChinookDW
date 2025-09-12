-- Total de ventas por cliente
SELECT 
  dc.CustomerId_NK   AS CustomerId,
  dc.FirstName + ' ' + dc.LastName AS Cliente,
  SUM(fs.LineTotal)  AS TotalVentas
FROM dw.FactSales fs
JOIN dw.DimCustomer dc ON dc.CustomerKey = fs.CustomerKey
GROUP BY dc.CustomerId_NK, dc.FirstName, dc.LastName
ORDER BY TotalVentas DESC;

