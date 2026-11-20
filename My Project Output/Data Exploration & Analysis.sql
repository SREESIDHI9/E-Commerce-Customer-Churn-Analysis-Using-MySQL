USE ECOMM;
SELECT * FROM customer_churn;

-- DATA EXPLORATION AND ANALYSIS...

-- No.of Churned and Active Customers.
SELECT ChurnStatus, COUNT(*) AS CustomerCount FROM customer_churn GROUP BY ChurnStatus;

-- Average Tenure and Total Cash Back Amount of Customers who Churned.
SELECT ROUND(AVG(Tenure), 2) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashbackAmount FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- % of Curned Customers who complained.
SELECT (COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS Percentage
FROM customer_churn WHERE ChurnStatus = 'Churned';

-- City Tier with Highest No.of Churned Customers - LAP&ACC.
SELECT CityTier, COUNT(*) AS ChurnedCustomerCount
FROM customer_churn WHERE ChurnStatus = 'Churned'
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier ORDER BY ChurnedCustomerCount DESC
LIMIT 1;

-- Most Preferred Mode of Payment by Active Customers.
SELECT PreferredPaymentMode, COUNT(*) AS CustomerCount FROM customer_churn WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode ORDER BY CustomerCount DESC
LIMIT 1;

-- total order amount hike from last year for customers who are single and prefer mobile phones for ordering.
SELECT SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn WHERE MaritalStatus = 'Single'
AND PreferredOrderCat = 'Mobile Phone';
  
-- average number of devices registered among customers who used UPI as their preferred payment mode.
SELECT ROUND(AVG(NumberOfDeviceRegistered), 2) AS AverageDevicesRegistered
FROM customer_churn WHERE PreferredPaymentMode = 'UPI';

-- city tier with the highest number of customers.
SELECT CityTier, COUNT(*) AS CustomerCount FROM customer_churn
GROUP BY CityTier ORDER BY CustomerCount DESC
LIMIT 1;

-- gender that utilized the highest number of coupons.
SELECT Gender, SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender ORDER BY TotalCouponsUsed DESC
Limit 1;

-- number of customers and the maximum hours spent on the app in each preferred order category.
SELECT PreferredOrderCat, COUNT(*) AS CustomerCount,
    MAX(HoursSpentOnApp) AS MaximumHoursSpentOnApp
FROM customer_churn
GROUP BY PreferredOrderCat;

-- total order count for customers who prefer using credit cards and have the maximum satisfaction score.
SELECT SUM(OrderCount) AS TotalOrderCount FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (
	SELECT MAX(SatisfactionScore)
      FROM customer_churn
  );

-- Average satisfaction score of customers who have complained.
SELECT ROUND(AVG(SatisfactionScore), 2) AS AverageSatisfactionScore
FROM customer_churn WHERE ComplaintReceived = 'Yes';

-- preferred order category among customers who used more than 5 coupons.
SELECT DISTINCT PreferredOrderCat FROM customer_churn WHERE CouponUsed > 5;

-- top 3 preferred order categories with the highest average cashback amount.
SELECT PreferredOrderCat, ROUND(AVG(CashbackAmount), 2) AS AverageCashbackAmount
FROM customer_churn
GROUP BY PreferredOrderCat ORDER BY AverageCashbackAmount DESC
LIMIT 3;

-- preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.
SELECT DISTINCT PreferredPaymentMode FROM customer_churn
WHERE Tenure = 10 AND OrderCount > 500;

-- Categorize customers based on their distance from the warehouse to home.
SELECT CustomerID, WarehouseToHome,
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory
FROM customer_churn;

-- List the customer’s order details who are married, live in City Tier-1, and their order counts are more than the average number of orders placed by all customers.
SELECT * FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (
      SELECT AVG(OrderCount)
      FROM customer_churn
  );
  
-- NEW TABLE.
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2));
    
    
    -- Inserting Values.
INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES(1001, 50022, '2023-01-01', 2130),
      (1002, 50316, '2023-01-23', 2000),
      (1003, 51099, '2023-02-14', 2290),
	  (1004, 52321, '2023-03-08', 2510),
	  (1005, 52928, '2023-03-20', 3000),
      (1006, 53749, '2023-04-17', 1740),
      (1007, 54206, '2023-04-21', 3250),
      (1008, 54838, '2023-04-30', 1990);
      
SELECT * FROM customer_returns;

-- Both Tables together.
SELECT
    r.ReturnID,
    r.CustomerID,
    r.ReturnDate,
    r.RefundAmount,
    c.Gender,
    c.Tenure,
    c.PreferredLoginDevice,
    c.CityTier,
    c.PreferredPaymentMode,
    c.PreferredOrderCat,
    c.SatisfactionScore,
    c.MaritalStatus,
    c.NumberOfAddress,
    c.OrderAmountHikeFromlastYear,
    c.CouponUsed,
    c.OrderCount,
    c.DaySinceLastOrder,
    c.CashbackAmount,
    c.ComplaintReceived,
    c.ChurnStatus
FROM customer_returns AS r
INNER JOIN customer_churn AS c
    ON r.CustomerID = c.CustomerID
WHERE c.ChurnStatus = 'Churned'
  AND c.ComplaintReceived = 'Yes';


