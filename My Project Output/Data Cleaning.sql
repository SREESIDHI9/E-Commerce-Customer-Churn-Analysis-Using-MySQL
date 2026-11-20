use ecomm;
SELECT * FROM customer_churn;
DESCRIBE customer_churn;
SELECT * FROM customer_churn LIMIT 10;
SELECT COUNT(*) AS TotalCustomers FROM customer_churn;

-- DATA CLEANING...
SELECT
    SUM(WarehouseToHome IS NULL) AS Missing_WarehouseToHome,
    SUM(HourSpendOnApp IS NULL) AS Missing_HourSpendOnApp,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS Missing_OrderAmountHike,
    SUM(DaySinceLastOrder IS NULL) AS Missing_DaySinceLastOrder
FROM customer_churn;

UPDATE customer_churn
SET WarehouseToHome = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(WarehouseToHome)) AS mean_value
        FROM customer_churn WHERE WarehouseToHome IS NOT NULL
    ) AS temp
)
WHERE WarehouseToHome IS NULL;

UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(HourSpendOnApp)) AS mean_value
        FROM customer_churn WHERE HourSpendOnApp IS NOT NULL
    ) AS temp
)
WHERE HourSpendOnApp IS NULL;

UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) AS mean_value
        FROM customer_churn WHERE OrderAmountHikeFromlastYear IS NOT NULL
    ) AS temp
)
WHERE OrderAmountHikeFromlastYear IS NULL;

UPDATE customer_churn
SET DaySinceLastOrder = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(DaySinceLastOrder)) AS mean_value
        FROM customer_churn WHERE DaySinceLastOrder IS NOT NULL
    ) AS temp
)
WHERE DaySinceLastOrder IS NULL;

UPDATE customer_churn
SET Tenure = (
    SELECT mode_value
    FROM (
        SELECT Tenure AS mode_value FROM customer_churn
        WHERE Tenure IS NOT NULL
        GROUP BY Tenure
        ORDER BY COUNT(*) DESC, Tenure
        LIMIT 1
    ) AS temp
)
WHERE Tenure IS NULL;

UPDATE customer_churn
SET CouponUsed = (
    SELECT mode_value
    FROM (
        SELECT CouponUsed AS mode_value FROM customer_churn
        WHERE CouponUsed IS NOT NULL
        GROUP BY CouponUsed
        ORDER BY COUNT(*) DESC, CouponUsed
        LIMIT 1
    ) AS temp
)
WHERE CouponUsed IS NULL;

UPDATE customer_churn
SET OrderCount = (
    SELECT mode_value
    FROM (
        SELECT OrderCount AS mode_value FROM customer_churn
        WHERE OrderCount IS NOT NULL
        GROUP BY OrderCount
        ORDER BY COUNT(*) DESC, OrderCount
        LIMIT 1
    ) AS temp
)
WHERE OrderCount IS NULL;

SELECT * FROM customer_churn WHERE WarehouseToHome > 100;
DELETE FROM customer_churn WHERE WarehouseToHome > 100;

-- INCONSISTENCIES

UPDATE customer_churn SET PreferredLoginDevice = 'Mobile Phone' WHERE PreferredLoginDevice = 'Phone';
UPDATE customer_churn SET PreferedOrderCat = 'Mobile Phone' WHERE PreferedOrderCat = 'Mobile';

UPDATE customer_churn SET PreferredPaymentMode = 'Cash on Delivery' WHERE PreferredPaymentMode = 'COD';
UPDATE customer_churn SET PreferredPaymentMode = 'Credit Card' WHERE PreferredPaymentMode = 'CC';









