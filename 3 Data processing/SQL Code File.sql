---1.Viewing the table
select * 
from `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1` 
limit 20;


------------------------------------------
---2. Checking date range
------------------------------------------

---Data collection start date: 2023-01-01
SELECT MIN(transaction_date) AS Start_date
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---Last date of data collection: 2023-06-30
SELECT MAX(transaction_date) AS End_date
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;
---Duration of data collection is 6 months 

------------------------------------------------------------------------
---3. Checking stores location and their names
------------------------------------------------------------------------
---There are 3 store location: Lower Manhattan, Hell's Kitchen and Astoria 
SELECT DISTINCT store_location
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---4.Checking products sold across at our stores:9 products categories
SELECT DISTINCT product_category
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- 5.Checking product type sold at our stores: 29 different product types
SELECT DISTINCT product_type
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- 6.Checking product detail sold at our stores: 80 different  product detail in our stores
SELECT DISTINCT product_detail
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---7.Identify the different product categories and products offered by the coffee shop
SELECT DISTINCT product_category As Category,
                product_detail AS Product_name 
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


-------------------------------------------------
---8 Checking products prices
-------------------------------------------------
--- Calculating minimum price: 0.8
SELECT MIN(unit_price) AS Cheapest_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Calculating maximum price:45
SELECT Max(unit_price) AS Expensive_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


--- Calculating average price:
SELECT avg(unit_price) AS Average_price
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---9.Checking for NULLS in various columns
SELECT*
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`
WHERE unit_price IS NULL
OR transaction_qty IS NULL
OR transaction_date IS NULL;


---10. Checking number of records, number of transactions, and number of store locations.
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_transaction,
       COUNT(DISTINCT store_id) AS number_of_stores,
       COUNT(DISTINCT product_id) AS number_of_products
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---11.Checking revenue
SELECT unit_price,
       transaction_qty,
       unit_price*transaction_qty AS Revenue
       FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


------------------------------------------------------
---12. Sales analysis
------------------------------------------------------
---Creating data set with day and month
SELECT transaction_id,
       transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) As Month_name,
       transaction_qty*unit_price AS revenue
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;


---13. Combine functions to get a clean data and enhanced data set
SELECT 
      transaction_id,
      transaction_date,
      transaction_time,
      transaction_qty,
      store_id,
      store_location,
      product_id,
      unit_price,
      product_category,
      product_type,
      product_detail,
---Adding columns to enhance the table for better insights
--- New column added 1: Day name
      Dayname(transaction_date) AS Day_name,
 ---New column added 2:Month name
      Monthname(transaction_date) As Month_name,
---New column added 3: Date of the month
      Dayofmonth(transaction_date) AS Date_of_month,
---New column added 4: determining weekday/weekends
CASE
    WHEN Dayname(transaction_date) IN ('Sun','sat') THEN 'weekend'
    ELSE  'weekday'
    END AS Day_classification,
---New column added 5:Time buckets
CASE
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '01.Rush Hour'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '02.Mid Morning'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03.Afternoon'
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '16:00:00' AND '18:00:00' THEN '04.Rush Hour'
        ELSE '05.Night'
END AS Time_classification,
---New column added 6: Spend buckets
CASE
        WHEN (transaction_qty) <=50 THEN '01.low spend'
        WHEN (transaction_qty) BETWEEN 51 AND 200 THEN '02.Medium spender'
        WHEN (transaction_qty) BETWEEN 51 AND 200 THEN '03.High spender'    
        ELSE '04. Premium spender'
END AS Spend_bucket,
---New column 7: Week bucket
CASE
        WHEN Day(transaction_date) BETWEEN 1 AND 7 THEN '01.Week 1'
        WHEN Day(transaction_date) BETWEEN 8 AND 14 THEN '02.Week 2'
        WHEN Day(transaction_date) BETWEEN 15 AND 21 THEN '03.Week 3'    
        ELSE '04. Week 4'
END AS Spend_bucket,
---New column added 8:Revenue
   transaction_qty*unit_price AS Revenue  
FROM `workspace`.`default`.`Bright_coffee_shop_analysis_case_study_1`;

