create database MICROSOFT_SUBSCRIPTION_ANALYTICS_PROJECT;
use MICROSOFT_SUBSCRIPTION_ANALYTICS_PROJECT;
-- 📊 Business Insights Sections
######################################################## Product Insights ########################################################

-- Highest rated Microsoft product

-- Most returned product

-- Best selling category

######################################################## Customer Insights ########################################################

-- Top spending customers

-- Customer lifetime value

-- Country wise revenue

######################################################## Logistics Insights ########################################################

-- Fastest shipping company

-- Average delivery time

######################################################## Inventory Insights ########################################################

-- Low stock products

-- Warehouse performance

-- Increase Recursion
SET SESSION cte_max_recursion_depth = 60000;

######################################################### 🖥️ Products Table #######################################################################
CREATE TABLE microsoft_products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2),
launch_year INT,
rating DECIMAL(3,2),
review_count INT
);

INSERT INTO microsoft_products
(product_id, product_name, category, price, launch_year, rating, review_count)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 120
)

SELECT 
n,

CONCAT(
ELT(FLOOR(1+RAND()*6),
'Surface Laptop','Surface Pro','Xbox','Windows License','Office 365','Azure Subscription'),
' Model ',n
),

ELT(FLOOR(1+RAND()*5),
'Laptop','Gaming','Software','Cloud','Productivity'),

ROUND(100 + RAND()*3000,2),

FLOOR(2018 + RAND()*7),

ROUND(3.5 + RAND()*1.5,1),

FLOOR(1000 + RAND()*20000)

FROM seq;
################################################################# Customers Table #################################################################
CREATE TABLE microsoft_customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
country VARCHAR(50),
age INT,
signup_date DATE
);

INSERT INTO microsoft_customers
(customer_id, customer_name, country, age, signup_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<12000
)

SELECT
n,
CONCAT('MS_User_',n),

ELT(FLOOR(1+RAND()*6),
'USA','India','UK','Germany','Canada','Australia'),

FLOOR(18 + RAND()*50),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1200) DAY)

FROM seq;

############################################################ 🧾 Orders Table ######################################################################
CREATE TABLE microsoft_orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES microsoft_customers(customer_id)
);

INSERT INTO microsoft_orders
(order_id, customer_id, order_date, total_amount)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<60000
)

SELECT
n,

FLOOR(1 + RAND()*12000),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),

ROUND(100 + RAND()*3000,2)

FROM seq;

############################################################### 🛒 Order Items #####################################################################
CREATE TABLE microsoft_order_items (
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES microsoft_orders(order_id),
FOREIGN KEY (product_id) REFERENCES microsoft_products(product_id)
);

INSERT INTO microsoft_order_items
(order_id, product_id, quantity, price)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<50000
)

SELECT
FLOOR(1 + RAND()*60000),
FLOOR(1 + RAND()*120),
FLOOR(1 + RAND()*3),
ROUND(100 + RAND()*2500,2)

FROM seq;

################################################################# 🌐 Website Sessions ###############################################################
CREATE TABLE microsoft_website_sessions (
session_id INT PRIMARY KEY,
customer_id INT,
device VARCHAR(50),
traffic_source VARCHAR(50),
session_duration INT,
pages_viewed INT
);

INSERT INTO microsoft_website_sessions
(session_id, customer_id, device, traffic_source, session_duration, pages_viewed)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<60000
)

SELECT
n,
FLOOR(1 + RAND()*12000),

ELT(FLOOR(1+RAND()*3),
'Desktop','Mobile','Tablet'),

ELT(FLOOR(1+RAND()*4),
'Organic','Ads','Direct','Social'),

FLOOR(30 + RAND()*800),

FLOOR(1 + RAND()*12)

FROM seq;

 ################################################################⭐ Product Reviews ################################################################
CREATE TABLE microsoft_product_reviews (
review_id INT PRIMARY KEY,
product_id INT,
customer_id INT,
rating INT,
review_text TEXT,
review_date DATE
);

INSERT INTO microsoft_product_reviews
(review_id,product_id,customer_id,rating,review_text,review_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<12000
)

SELECT
n,
FLOOR(1+RAND()*120),
FLOOR(1+RAND()*12000),
FLOOR(1+RAND()*5),

ELT(FLOOR(1+RAND()*5),
'Great Microsoft product',
'Excellent software',
'Average experience',
'Not satisfied',
'Very useful tool'),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*365) DAY)

FROM seq;

######################################################### ↩️ Returns ###############################################################################
CREATE TABLE microsoft_returns (
return_id INT PRIMARY KEY,
order_id INT,
product_id INT,
return_reason VARCHAR(100),
return_date DATE
);

INSERT INTO microsoft_returns
(return_id,order_id,product_id,return_reason,return_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<3000
)

SELECT
n,
FLOOR(1+RAND()*60000),
FLOOR(1+RAND()*120),

ELT(FLOOR(1+RAND()*4),
'Defective',
'Wrong item',
'Customer cancelled',
'Damaged'),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*200) DAY)

FROM seq;

################################################################# 📦 Inventory #####################################################################
CREATE TABLE microsoft_inventory (
inventory_id INT PRIMARY KEY,
product_id INT,
stock_quantity INT,
warehouse_location VARCHAR(50),
last_updated DATE
);

INSERT INTO microsoft_inventory
(inventory_id,product_id,stock_quantity,warehouse_location,last_updated)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<120
)

SELECT
n,
n,
FLOOR(50+RAND()*600),

ELT(FLOOR(1+RAND()*4),
'USA Warehouse',
'India Warehouse',
'Germany Warehouse',
'Singapore Warehouse'),

CURDATE()

FROM seq;

############################################################## 🚚 Shipments #######################################################################
CREATE TABLE microsoft_shipments (
shipment_id INT PRIMARY KEY,
order_id INT,
shipment_date DATE,
delivery_date DATE,
shipping_company VARCHAR(100),
shipping_cost DECIMAL(10,2)
);

INSERT INTO microsoft_shipments
(shipment_id,order_id,shipment_date,delivery_date,shipping_company,shipping_cost)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<12000
)

SELECT
n,
FLOOR(1+RAND()*60000),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*365) DAY),

DATE_ADD(CURDATE(),INTERVAL FLOOR(RAND()*7) DAY),

ELT(FLOOR(1+RAND()*4),
'FedEx','DHL','UPS','BlueDart'),

ROUND(5+RAND()*60,2)

FROM seq;

####################################################### DATA QUALITY CHECK #######################################################################
-- Check NULL values
SELECT *
FROM microsoft_products
WHERE product_name IS NULL
OR category IS NULL
OR price IS NULL;

-- Check invalid prices
SELECT *
FROM microsoft_products
WHERE price <= 0;

-- Check duplicate customers
SELECT customer_name,COUNT(*)
FROM microsoft_customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- Orders without customer
SELECT *
FROM microsoft_orders
WHERE customer_id NOT IN
(SELECT customer_id FROM microsoft_customers);

-- Fix NULL ratings
UPDATE microsoft_products
SET rating = 4.0
WHERE rating IS NULL;

-- Replace missing review text
UPDATE microsoft_product_reviews
SET review_text = 'No review given'
WHERE review_text IS NULL;

-- Remove duplicate customers
set sql_safe_updates=0;
DELETE c1
FROM microsoft_customers c1
JOIN microsoft_customers c2
ON c1.customer_name = c2.customer_name
AND c1.customer_id > c2.customer_id;

-- Fix negative prices
UPDATE microsoft_products
SET price = ABS(price)
WHERE price < 0;
################################################################## ️⃣ EXPLORATORY DATA ANALYSIS #####################################################
-- Total Microsoft customers
SELECT COUNT(*) total_customers
FROM microsoft_customers;

-- Total orders
SELECT COUNT(*) total_orders
FROM microsoft_orders;

-- Total revenue
SELECT SUM(total_amount) total_revenue
FROM microsoft_orders;

-- Average product price
SELECT AVG(price) avg_price
FROM microsoft_products;

############################################################ ️⃣ PRODUCT INSIGHTS ####################################################################
-- Best selling Microsoft products
SELECT
p.product_name,
SUM(oi.quantity) total_sales
FROM microsoft_order_items oi
JOIN microsoft_products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Best selling category
SELECT
p.category,
SUM(oi.quantity) sales
FROM microsoft_order_items oi
JOIN microsoft_products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY sales DESC;

-- Highest rated Microsoft products
SELECT
product_name,
rating
FROM microsoft_products
ORDER BY rating DESC
LIMIT 10;

-- Most returned products
SELECT
p.product_name,
COUNT(r.return_id) returns_count
FROM microsoft_returns r
JOIN microsoft_products p
ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY returns_count DESC;

############################################################ ️⃣ CUSTOMER INSIGHTS ####################################################################
-- Top spending customers
SELECT
c.customer_name,
SUM(o.total_amount) total_spent
FROM microsoft_orders o
JOIN microsoft_customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 20;

-- Customer lifetime value
SELECT
customer_id,
SUM(total_amount) lifetime_value
FROM microsoft_orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;

-- Country wise revenue
SELECT
c.country,
SUM(o.total_amount) revenue
FROM microsoft_orders o
JOIN microsoft_customers c
ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;

########################################################### ️⃣ WEBSITE ANALYTICS ###################################################################
-- Traffic source performance
SELECT
traffic_source,
COUNT(*) sessions
FROM microsoft_website_sessions
GROUP BY traffic_source
ORDER BY sessions DESC;

-- Device usage
SELECT
device,
COUNT(*) users
FROM microsoft_website_sessions
GROUP BY device;

-- Average session time
SELECT
AVG(session_duration) avg_session_duration
FROM microsoft_website_sessions;

######################################################  ️⃣ LOGISTICS INSIGHTS #######################################################################
-- Fastest shipping company
SELECT
shipping_company,
AVG(DATEDIFF(delivery_date,shipment_date)) delivery_time
FROM microsoft_shipments
GROUP BY shipping_company
ORDER BY delivery_time;

-- Shipping cost analysis
SELECT
shipping_company,
AVG(shipping_cost) avg_cost
FROM microsoft_shipments
GROUP BY shipping_company;

############################################################# ️⃣ INVENTORY INSIGHTS ##################################################################
-- Low stock products
SELECT
p.product_name,
i.stock_quantity
FROM microsoft_inventory i
JOIN microsoft_products p
ON i.product_id = p.product_id
WHERE stock_quantity < 100;

-- Warehouse inventory distribution
SELECT
warehouse_location,
SUM(stock_quantity) total_stock
FROM microsoft_inventory
GROUP BY warehouse_location;

##################################################  ️⃣ ADVANCED SQL (WINDOW FUNCTIONS) #############################################################
-- Rank products by revenue
SELECT
product_id,
SUM(quantity * price) revenue,
RANK() OVER(ORDER BY SUM(quantity*price) DESC) revenue_rank
FROM microsoft_order_items
GROUP BY product_id;

-- Running revenue
SELECT
order_date,
SUM(total_amount) revenue,
SUM(SUM(total_amount)) OVER(ORDER BY order_date) running_revenue
FROM microsoft_orders
GROUP BY order_date;

-- Top 3 products per category
SELECT *
FROM (

SELECT
p.category,
p.product_name,
SUM(oi.quantity) sales,
RANK() OVER(PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) rnk

FROM microsoft_order_items oi
JOIN microsoft_products p
ON oi.product_id = p.product_id

GROUP BY p.category,p.product_name

) ranked

WHERE rnk <= 3;

############################################################# ️⃣ DASHBOARD METRICS ################################################################

-- Total revenue
SELECT SUM(total_amount)
FROM microsoft_orders;

-- Total products sold
SELECT SUM(quantity)
FROM microsoft_order_items;

-- Total website sessions
SELECT COUNT(*)
FROM microsoft_website_sessions;

-- Best Selling Microsoft Products
SELECT
p.product_name,
SUM(oi.quantity) total_sales
FROM microsoft_order_items oi
JOIN microsoft_products p
ON oi.product_id=p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top Spending Customers
SELECT
customer_id,
SUM(total_amount) spending
FROM microsoft_orders
GROUP BY customer_id
ORDER BY spending DESC
LIMIT 20;

-- Monthly Revenue
SELECT
DATE_FORMAT(order_date,'%Y-%m') month,
SUM(total_amount) revenue
FROM microsoft_orders
GROUP BY month
ORDER BY month;

-- Shipping Performance
SELECT
shipping_company,
AVG(DATEDIFF(delivery_date,shipment_date)) avg_delivery_days
FROM microsoft_shipments
GROUP BY shipping_company;