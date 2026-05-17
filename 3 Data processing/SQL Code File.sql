--- Viewing the table
select * 
from `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1` 
limit 20;


------------------------------------------
--- Checking date range
------------------------------------------

---Data collection start date: 2023-01-01
SELECT MIN(transaction_date) AS Start_date
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---Last date of data collection: 2023-06-30
SELECT MAX(transaction_date) AS End_date
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;
---Duration of data collection is 6 months 

------------------------------------------------------------------------
--- Checking stores location and their names
------------------------------------------------------------------------
---There are 3 store location: Lower Manhattan, Hell's Kitchen and Astoria 
SELECT DISTINCT store_location
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Checking products sold across at our stores:9 products categories
SELECT DISTINCT product_category
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Checking product type sold at our stores: 29 different product types
SELECT DISTINCT product_type
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Checking product detail sold at our stores: 80 different  product detail in our stores
SELECT DISTINCT product_detail
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Identify the different product categories and products offered by the coffee shop
SELECT DISTINCT product_category As Category,
                product_detail AS Product_name 
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


-------------------------------------------------
--- Checking products prices
-------------------------------------------------
--- Calculating minimum price: 0.8
SELECT MIN(unit_price) AS Cheapest_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Calculating maximum price:45
SELECT Max(unit_price) AS Expensive_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Calculating average price: 3.38
SELECT avg(unit_price) AS Average_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Checking for NULLS in various columns
SELECT*
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`
WHERE unit_price IS NULL
OR transaction_qty IS NULL
OR transaction_date IS NULL;


--- Checking number of records, number of transactions, and number of store locations.
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_transaction,
       COUNT(DISTINCT store_id) AS number_of_stores,
       COUNT(DISTINCT product_id) AS number_of_products
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Checking revenue
SELECT unit_price,
       transaction_qty,
       unit_price*transaction_qty AS Revenue
       FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


------------------------------------------------------
--- Sales analysis
------------------------------------------------------
---Creating data set with day and month
SELECT transaction_id,
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) As Month_name,
       Dayofmonth(transaction_date) AS Date_of_month,
       transaction_qty*unit_price AS revenue
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;

SELECT 
      transaction_id,
      transaction_date,
      transaction_qty,
      store_id,
      store_location,
      product_id,
      unit_price,
      product_category,
      product_type,
      product_detail,
---Adding columns to enhance the table for better insights
----Converting timestamp
 date_format(transaction_time, 'HH:mm:ss') AS RecordTime,

--- New column added 1: Day name
      Dayname(transaction_date) AS Day_name,
 ---New column added 2:Month name
      Monthname(transaction_date) As Month_name,
---New column added 3: Date of the month
      Dayofmonth(transaction_date) AS Date_of_month,
---New column added 4: determining weekday/weekends
CASE
    WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'weekend'
    ELSE  'weekday'
    END AS Day_classification,
---New column added 5:Time buckets
CASE
        WHEN date_format(RecordTime,'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '01.Rush Hour'
        WHEN date_format(RecordTime,'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '02.Mid Morning'
        WHEN date_format(RecordTime,'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03.Afternoon'
        WHEN date_format(RecordTime,'HH:mm:ss') BETWEEN '16:00:00' AND '18:00:00' THEN '04.Evening'
        ELSE '05.Night'
END AS Time_classification,
---New column added 6: Spend buckets
CASE
        WHEN (transaction_qty) <=1 THEN '01.Low spender'
        WHEN (transaction_qty) BETWEEN 2 AND 3 THEN '02.Medium spender'
        WHEN (transaction_qty) BETWEEN 4 AND 6 THEN '03.High spender'
        ELSE '04. Premium spender'
END AS Spend_bucket,

---New column 7: Week bucket
CASE
        WHEN Day(transaction_date) BETWEEN 1 AND 7 THEN '01.Week 1'
        WHEN Day(transaction_date) BETWEEN 8 AND 14 THEN '02.Week 2'
        WHEN Day(transaction_date) BETWEEN 15 AND 21 THEN '03.Week 3'    
        ELSE '04.Week 4'
END AS Week_bucket,
---New column added 8:Revenue
   transaction_qty*unit_price AS Revenue

FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;
