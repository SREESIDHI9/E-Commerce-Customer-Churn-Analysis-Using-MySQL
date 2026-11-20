# E-Commerce-Customer-Churn-Analysis-Using-MySQL
MySQL e-commerce customer churn analysis covering data cleaning, missing-value imputation, outlier removal, feature transformation, exploratory queries, distance segmentation, and return joins to identify churn drivers.
# E-Commerce Customer Churn Analysis Using MySQL

## Project Overview
This project analyzes customer behavior, purchase patterns, service complaints, and return records for an e-commerce platform using MySQL. The workflow covers raw data ingestion, missing-value imputation, outlier removal, category standardization, feature transformation, exploratory SQL querying, and relational joins with product return data to identify drivers of customer churn[cite: 4, 5, 6, 7, 8, 9, 10, 11].

## Objective
* Clean and standardize raw e-commerce customer records in MySQL by handling missing values, extreme distance outliers, and inconsistent category labels
* Transform raw flags and column names into clear analytical attributes (`ChurnStatus`, `ComplaintReceived`, `HoursSpentOnApp`, and `PreferredOrderCat`)
* Answer targeted business and retention questions using aggregations, conditional filtering, subqueries, `CASE` segmentation, and `INNER JOIN` queries across customer and return tables[cite: 5, 6, 7, 8, 9, 10]

## Dataset Description
* **Primary Table (`customer_churn`):** Contains 20 attributes per record in the SQL dump (`CustomerID`, `Churn`, `Tenure`, `PreferredLoginDevice`, `CityTier`, `WarehouseToHome`, `PreferredPaymentMode`, `Gender`, `HourSpendOnApp`, `NumberOfDeviceRegistered`, `PreferedOrderCat`, `SatisfactionScore`, `MaritalStatus`, `NumberOfAddress`, `Complain`, `OrderAmountHikeFromlastYear`, `CouponUsed`, `OrderCount`, `DaySinceLastOrder`, and `CashbackAmount`), spanning `CustomerID` 50001 to 55630 (16,890 inserted rows before outlier removal)
* **Secondary Table (`customer_returns`):** Contains 8 return transactions (`ReturnID` 1001–1008) linked via `CustomerID`, along with `ReturnDate` and `RefundAmount` (ranging from 1,740 to 3,250)
* **Data Quality & Missingness:** Prior to cleaning, nulls appeared in `Tenure`, `WarehouseToHome`, `HourSpendOnApp`, `OrderAmountHikeFromlastYear`, `CouponUsed`, `OrderCount`, and `DaySinceLastOrder`, alongside inconsistent labels such as `'Phone'` vs. `'Mobile Phone'`, `'Mobile'` vs. `'Mobile Phone'`, `'COD'` vs. `'Cash on Delivery'`, and `'CC'` vs. `'Credit Card'`[cite: 4, 5, 6, 7, 8, 9, 10, 11]

## Workflow
* **Database Setup & Ingestion:** Created the `ecomm` database and populated `customer_churn` via `MYSQL ASSIGN3 Data.sql`[cite: 11]
* **Data Cleaning (`MYSQL ASSIGN3 Data Cleaning.sql`):** Imputed rounded mean values for `WarehouseToHome`, `HourSpendOnApp`, `OrderAmountHikeFromlastYear`, and `DaySinceLastOrder`; imputed mode values for `Tenure`, `CouponUsed`, and `OrderCount`; removed records with `WarehouseToHome > 100` (leaving 16,884 rows); and standardized device, category, and payment labels[cite: 8]
* **Data Transformation (`MYSQL ASSIGN3 Data Transformation.sql`):** Renamed `PreferedOrderCat` to `PreferredOrderCat` and `HourSpendOnApp` to `HoursSpentOnApp`, created `ComplaintReceived` (`'Yes'`/`'No'`) and `ChurnStatus` (`'Churned'`/`'Active'`), and dropped redundant raw flag columns (`Churn` and `Complain`)[cite: 10]
* **Exploratory Analysis & Joins (`MYSQL ASSIGN3 Data Exploration & Analysis.sql`):** Executed summary counts, averages, percentages, `CASE`-based delivery distance buckets (`Very Close Distance`, `Close Distance`, `Moderate Distance`, `Far Distance`), subqueries on satisfaction and order volume, and an `INNER JOIN` between `customer_returns` and `customer_churn`[cite: 9]

## Key Findings
* **Churn & Retention Split:** In the cleaned table of 16,884 rows, 14,040 rows are `Active` and 2,844 are `Churned`, with churned records showing an average `Tenure` of 3.18 and a combined `CashbackAmount` of 456,090
* **Complaints & Churn:** **53.59%** of churned records have `ComplaintReceived = 'Yes'`, and customers who complained have an average `SatisfactionScore` of **3.0**
* **Category & Tier Patterns:** `CityTier` 1 holds the largest overall record count (10,998 vs. 5,160 in `CityTier` 3 and 726 in `CityTier` 2), whereas `CityTier` 3 accounts for more churned `Laptop & Accessory` records (450 vs. 180 in `CityTier` 1)
* **Payment, Coupons & Cashback:** `Debit Card` (5,868) and `Credit Card` (4,566) lead among active records; `UPI` users average **3.72** registered devices; `Male` records show higher total coupon usage (16,887 vs. 12,102 for `Female`); and `Others` (304.45), `Grocery` (266.24), and `Fashion` (210.40) record the top three average cashback amounts
* **Returns Overlap:** Joining `customer_returns` with churned customers who filed complaints surfaces return records for `CustomerID`s `50316` (`Fashion`, refund 2,000), `52321` (`Grocery`, refund 2,510), and `53749` (`Laptop & Accessory`, refund 1,740)[cite: 8, 9, 10, 11]

## Business & Policy Recommendations
* **Prioritize Early-Tenure & Complaint Resolution:** Because churned records average a tenure of 3.18 and over half (53.59%) involve complaints with a 3.0 average satisfaction score, establish fast-track complaint resolution and early onboarding check-ins for newer customers
* **Target Regional & Return Friction Points:** Investigate fulfillment, delivery distance (`Far Distance` vs. closer tiers), and product quality in `CityTier` 3—especially for `Laptop & Accessory` and refunded categories like `Fashion`, `Grocery`, and `Laptop & Accessory`—to reduce repeat complaints and churn
* **Refine Incentives & Payment Experience:** Align cashback and coupon campaigns with high-engagement categories and payment methods while keeping `Debit Card`, `Credit Card`, and `UPI` flows frictionless[cite: 8, 9, 10, 11]

## Tools Used, Tech Stack & Libraries
* **Database & Querying:** MySQL / MySQL Workbench, SQL (`DDL`, `DML`, aggregate functions, subqueries, `CASE`, `INNER JOIN`)
* **Documentation & Version Control:** Git, GitHub, Markdown (`README.md`)

## Repository Structure
```text
ecommerce-customer-churn-mysql/
├── README.md
├── sql/
│   ├── 01_data_setup.sql               # Database creation & customer_churn inserts (MYSQL ASSIGN3 Data.sql)
│   ├── 02_data_cleaning.sql            # Missing value imputation, outlier removal & standardization
│   ├── 03_data_transformation.sql      # Column renames, derived status columns & flag cleanup
│   └── 04_exploration_and_analysis.sql # Analytical queries, distance bucketing & customer_returns join
└── docs/
    └── assignment_brief.pdf            # Module-end assignment guidelines
```
[cite: 4, 5, 6, 7, 8, 9, 10, 11]

---

**Author:** Sree Sidhi
