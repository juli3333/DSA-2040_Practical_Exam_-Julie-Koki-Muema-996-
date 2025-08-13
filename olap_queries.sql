
SELECT 
    c.Country,
    SUM(f.TotalSales) AS TotalSales
FROM SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
GROUP BY c.Country
ORDER BY TotalSales DESC;



SELECT 
    t.Year,
    t.Month,
    f.InvoiceNo,
    f.Description,
    f.Quantity,
    f.UnitPrice,
    f.TotalSales
FROM SalesFact f
JOIN CustomerDim c ON f.CustomerID = c.CustomerID
JOIN TimeDim t ON f.InvoiceDate = t.InvoiceDate
WHERE c.Country = 'United Kingdom'
ORDER BY t.Year, t.Month, f.InvoiceNo;



SELECT SUM(TotalSales) AS TotalSales_Electronics
FROM SalesFact f
WHERE f.Category = 'Electronics';


