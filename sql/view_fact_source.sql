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
