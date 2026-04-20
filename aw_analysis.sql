USE AdventureWorksSales;
TRUNCATE TABLE sales;







USE AdventureWorksSales;
TRUNCATE TABLE sales;

BULK INSERT sales
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_sales_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    MAXERRORS = 9999,
    TABLOCK
);

SELECT COUNT(*) FROM sales;
SELECT TOP 3 ProductName, ProductPrice, Revenue FROM sales;







USE AdventureWorksSales;
TRUNCATE TABLE products;

BULK INSERT products
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_products_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);

SELECT 'customers' as table_name, COUNT(*) as row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'territories', COUNT(*) FROM territories
UNION ALL SELECT 'returns', COUNT(*) FROM returns;









USE AdventureWorksSales;

-- Find rows that can't convert to float
SELECT TOP 5 Revenue, ProductPrice, OrderQuantity
FROM sales
WHERE ISNUMERIC(Revenue) = 0;

USE AdventureWorksSales;

SELECT TOP 5 Revenue, ProductPrice, OrderQuantity
FROM sales
WHERE Revenue NOT LIKE '%[0-9]%';


USE AdventureWorksSales;

-- Find exact rows that fail float conversion
SELECT TOP 5 Revenue, LEN(Revenue) as length, 
ASCII(LEFT(Revenue, 1)) as first_char_ascii
FROM sales
WHERE TRY_CAST(Revenue AS FLOAT) IS NULL;


USE AdventureWorksSales;

SELECT TOP 5 
    Revenue,
    LEN(Revenue) as length,
    ASCII(LEFT(Revenue, 1)) as char1,
    ASCII(SUBSTRING(Revenue, 2, 1)) as char2,
    SUBSTRING(Revenue, 2, LEN(Revenue)) as without_first_char
FROM sales
WHERE TRY_CAST(Revenue AS FLOAT) IS NULL;


USE AdventureWorksSales;
TRUNCATE TABLE sales;

BULK INSERT sales
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_sales_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    MAXERRORS = 9999,
    TABLOCK
);

-- Test conversion
SELECT 
    COUNT(DISTINCT OrderNumber) as total_orders,
    SUM(CAST(OrderQuantity AS INT)) as total_quantity,
    ROUND(SUM(CAST(Revenue AS FLOAT)), 2) as total_revenue
FROM sales
WHERE TRY_CAST(Revenue AS FLOAT) IS NOT NULL;

SELECT COUNT(*) FROM sales;
SELECT TOP 3 OrderNumber, Revenue, ProductPrice FROM sales;


USE AdventureWorksSales;
TRUNCATE TABLE sales;

BULK INSERT sales
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_sales_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    MAXERRORS = 9999,
    TABLOCK
);

SELECT COUNT(*) FROM sales;
SELECT TOP 3 ProductName, ProductPrice, Revenue FROM sales;


USE AdventureWorksSales;
TRUNCATE TABLE customers;
TRUNCATE TABLE products;
TRUNCATE TABLE territories;
TRUNCATE TABLE returns;

BULK INSERT customers
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_customers_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);

BULK INSERT products
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_products_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);

BULK INSERT territories
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_territories_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);

BULK INSERT returns
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_returns_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);

SELECT 'sales' as table_name, COUNT(*) as row_count FROM sales
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'territories', COUNT(*) FROM territories
UNION ALL SELECT 'returns', COUNT(*) FROM returns;






USE AdventureWorksSales;

-- Q1: Total revenue, orders and quantity sold
SELECT 
    COUNT(DISTINCT OrderNumber) as total_orders,
    SUM(CAST(OrderQuantity AS INT)) as total_quantity,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue
FROM sales;

-- Q2: Revenue by year
SELECT 
    OrderYear,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as yearly_revenue,
    COUNT(DISTINCT OrderNumber) as total_orders
FROM sales
GROUP BY OrderYear
ORDER BY OrderYear;

-- Q3: Revenue by region
SELECT 
    Region,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue,
    COUNT(DISTINCT OrderNumber) as total_orders
FROM sales
GROUP BY Region
ORDER BY total_revenue DESC;

-- Q4: Top 10 products by revenue
SELECT TOP 10
    ProductName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue,
    SUM(CAST(OrderQuantity AS INT)) as units_sold
FROM sales
GROUP BY ProductName
ORDER BY total_revenue DESC;

-- Q5: Revenue by month (seasonality)
SELECT 
    OrderMonth,
    OrderMonthName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as monthly_revenue
FROM sales
GROUP BY OrderMonth, OrderMonthName
ORDER BY OrderMonth;

-- Q6: Top 10 customers by revenue
SELECT TOP 10
    s.CustomerKey,
    c.FirstName + ' ' + c.LastName as CustomerName,
    c.Occupation,
    c.AnnualIncome,
    ROUND(SUM(TRY_CAST(s.Revenue AS FLOAT)), 2) as total_spent
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY s.CustomerKey, c.FirstName, c.LastName, c.Occupation, c.AnnualIncome
ORDER BY total_spent DESC;

-- Q7: Revenue by customer occupation
SELECT 
    c.Occupation,
    ROUND(SUM(TRY_CAST(s.Revenue AS FLOAT)), 2) as total_revenue,
    COUNT(DISTINCT s.CustomerKey) as total_customers
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Occupation
ORDER BY total_revenue DESC;



USE AdventureWorksSales;

-- Fix newline in returns table
UPDATE returns SET ReturnQuantity = REPLACE(REPLACE(ReturnQuantity, CHAR(13), ''), CHAR(10), '');
UPDATE sales SET OrderQuantity = REPLACE(REPLACE(OrderQuantity, CHAR(13), ''), CHAR(10), '');

-- Now run Q8, Q9, Q10
-- Q8: Return rate by product
SELECT TOP 10
    p.ProductName,
    SUM(CAST(r.ReturnQuantity AS INT)) as total_returns,
    SUM(CAST(s.OrderQuantity AS INT)) as total_sold,
    ROUND(SUM(CAST(r.ReturnQuantity AS INT)) * 100.0 /
          NULLIF(SUM(CAST(s.OrderQuantity AS INT)), 0), 2) as return_rate
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
LEFT JOIN returns r ON s.ProductKey = r.ProductKey
GROUP BY p.ProductName
HAVING SUM(CAST(s.OrderQuantity AS INT)) > 100
ORDER BY return_rate DESC;

-- Q9: Revenue by quarter
SELECT 
    OrderYear,
    OrderQuarter,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as quarterly_revenue
FROM sales
GROUP BY OrderYear, OrderQuarter
ORDER BY OrderYear, OrderQuarter;

-- Q10: Running total revenue by month
SELECT 
    OrderYear,
    OrderMonth,
    OrderMonthName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as monthly_revenue,
    ROUND(SUM(SUM(TRY_CAST(Revenue AS FLOAT))) OVER(
        PARTITION BY OrderYear
        ORDER BY OrderMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) as yearly_running_total
FROM sales
GROUP BY OrderYear, OrderMonth, OrderMonthName
ORDER BY OrderYear, OrderMonth;



USE AdventureWorksSales;

-- Strip the hidden character from Revenue and ProductPrice
UPDATE sales 
SET Revenue = SUBSTRING(Revenue, 2, LEN(Revenue))
WHERE LEN(Revenue) > LEN(CAST(CAST(Revenue AS NVARCHAR(50)) AS NVARCHAR(50))) 
   OR TRY_CAST(Revenue AS FLOAT) IS NULL;

-- Check if fixed
SELECT TOP 3 Revenue, LEN(Revenue), TRY_CAST(Revenue AS FLOAT) as float_test
FROM sales;




USE AdventureWorksSales;
TRUNCATE TABLE sales;

BULK INSERT sales
FROM 'C:\Users\Aryan\Desktop\Quick Access\vscode docs\other projects or codes\Capstone — AdventureWorks Sales Analytics\data\aw_sales_final.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    MAXERRORS = 9999,
    TABLOCK
);

SELECT TOP 3 Revenue, LEN(Revenue), TRY_CAST(Revenue AS FLOAT) as float_test
FROM sales;




USE AdventureWorksSales;

-- Instead of CAST, use a direct update to fix the column
-- First check what's actually there character by character
SELECT TOP 1
    Revenue,
    LEN(Revenue),
    UNICODE(LEFT(Revenue, 1)) as first_char,
    UNICODE(RIGHT(Revenue, 1)) as last_char
FROM sales;

USE AdventureWorksSales;

-- Remove carriage return from Revenue and ProductPrice
UPDATE sales SET Revenue = REPLACE(Revenue, CHAR(13), '');
UPDATE sales SET ProductPrice = REPLACE(ProductPrice, CHAR(13), '');
UPDATE sales SET OrderQuantity = REPLACE(OrderQuantity, CHAR(13), '');

-- Verify fix
SELECT TOP 3 
    Revenue, 
    LEN(Revenue) as len,
    TRY_CAST(Revenue AS FLOAT) as float_test
FROM sales;






USE AdventureWorksSales;

-- Q1: Total revenue, orders and quantity sold
SELECT 
    COUNT(DISTINCT OrderNumber) as total_orders,
    SUM(CAST(OrderQuantity AS INT)) as total_quantity,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue
FROM sales;

-- Q2: Revenue by year
SELECT 
    OrderYear,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as yearly_revenue,
    COUNT(DISTINCT OrderNumber) as total_orders
FROM sales
GROUP BY OrderYear
ORDER BY OrderYear;

-- Q3: Revenue by region
SELECT 
    Region,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue,
    COUNT(DISTINCT OrderNumber) as total_orders
FROM sales
GROUP BY Region
ORDER BY total_revenue DESC;

-- Q4: Top 10 products by revenue
SELECT TOP 10
    ProductName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as total_revenue,
    SUM(CAST(OrderQuantity AS INT)) as units_sold
FROM sales
GROUP BY ProductName
ORDER BY total_revenue DESC;

-- Q5: Revenue by month
SELECT 
    OrderMonth,
    OrderMonthName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as monthly_revenue
FROM sales
GROUP BY OrderMonth, OrderMonthName
ORDER BY OrderMonth;

-- Q6: Top 10 customers by revenue
SELECT TOP 10
    s.CustomerKey,
    c.FirstName + ' ' + c.LastName as CustomerName,
    c.Occupation,
    c.AnnualIncome,
    ROUND(SUM(TRY_CAST(s.Revenue AS FLOAT)), 2) as total_spent
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY s.CustomerKey, c.FirstName, c.LastName, c.Occupation, c.AnnualIncome
ORDER BY total_spent DESC;

-- Q7: Revenue by customer occupation
SELECT 
    c.Occupation,
    ROUND(SUM(TRY_CAST(s.Revenue AS FLOAT)), 2) as total_revenue,
    COUNT(DISTINCT s.CustomerKey) as total_customers
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Occupation
ORDER BY total_revenue DESC;

-- Q8: Return rate by product
SELECT TOP 10
    p.ProductName,
    SUM(CAST(r.ReturnQuantity AS INT)) as total_returns,
    SUM(CAST(s.OrderQuantity AS INT)) as total_sold,
    ROUND(SUM(CAST(r.ReturnQuantity AS INT)) * 100.0 /
          NULLIF(SUM(CAST(s.OrderQuantity AS INT)), 0), 2) as return_rate
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
LEFT JOIN returns r ON s.ProductKey = r.ProductKey
GROUP BY p.ProductName
HAVING SUM(CAST(s.OrderQuantity AS INT)) > 100
ORDER BY return_rate DESC;

-- Q9: Revenue by quarter
SELECT 
    OrderYear,
    OrderQuarter,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as quarterly_revenue
FROM sales
GROUP BY OrderYear, OrderQuarter
ORDER BY OrderYear, OrderQuarter;

-- Q10: Running total revenue by month
SELECT 
    OrderYear,
    OrderMonth,
    OrderMonthName,
    ROUND(SUM(TRY_CAST(Revenue AS FLOAT)), 2) as monthly_revenue,
    ROUND(SUM(SUM(TRY_CAST(Revenue AS FLOAT))) OVER(
        PARTITION BY OrderYear
        ORDER BY OrderMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) as yearly_running_total
FROM sales
GROUP BY OrderYear, OrderMonth, OrderMonthName
ORDER BY OrderYear, OrderMonth;