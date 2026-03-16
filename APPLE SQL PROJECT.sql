create database APPLE_SALES_ANALYTICS_PROJECT;
use APPLE_SALES_ANALYTICS_PROJECT;

######################################################## Product Insights #########################################################################

-- Highest rated Apple product

-- Most returned product

-- Best selling category

######################################################## Customer Insights ########################################################################

-- Top spending customers

-- Customer lifetime value

-- Country wise revenue

######################################################### Logistics Insights #######################################################################

-- Fastest shipping company

-- Average delivery time

########################################################### Inventory Insights #####################################################################

-- Low stock products

-- Warehouse performance

################################################################## DATA INSERTED ###################################################################
SET SESSION cte_max_recursion_depth = 60000;
#################################################################### Products #####################################################################
CREATE TABLE apple_products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2),
launch_year INT,
rating DECIMAL(3,2),
review_count INT
);
-- Generate 100 Apple Products
INSERT INTO apple_products
(product_id, product_name, category, price, launch_year, rating, review_count)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 100
)

SELECT 
n,
CONCAT(
ELT(FLOOR(1+RAND()*6),
'iPhone','MacBook','iPad','Apple Watch','AirPods','Apple TV'),
' Model ',n
),

ELT(FLOOR(1+RAND()*5),
'Smartphone',
'Laptop',
'Tablet',
'Wearable',
'Audio'
),

ROUND(200 + RAND()*2000,2),

FLOOR(2019 + RAND()*6),

ROUND(3.5 + RAND()*1.5,1),

FLOOR(1000 + RAND()*20000)

FROM seq;


################################################################## Customers #####################################################################
CREATE TABLE apple_customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
country VARCHAR(50),
age INT,
signup_date DATE
);

INSERT INTO apple_customers
(customer_id, customer_name, country, age, signup_date)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 10000
)

SELECT
n,
CONCAT('Customer_',n),

ELT(FLOOR(1+RAND()*6),
'India','USA','UK','Canada','Germany','Australia'),

FLOOR(18 + RAND()*50),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1000) DAY)

FROM seq;

################################################################# Orders #########################################################################
CREATE TABLE apple_orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES apple_customers(customer_id)
);

INSERT INTO apple_orders
(order_id, customer_id, order_date, total_amount)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 50000
)

SELECT
n,

FLOOR(1 + RAND()*10000),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),

ROUND(200 + RAND()*2500,2)

FROM seq;

##################################################### Order Items #################################################################################
CREATE TABLE apple_order_items (
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
price DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES apple_orders(order_id),
FOREIGN KEY (product_id) REFERENCES apple_products(product_id)
);

INSERT INTO apple_order_items
(order_id, product_id, quantity, price)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 40000
)

SELECT

FLOOR(1 + RAND()*10000),

FLOOR(1 + RAND()*100),

FLOOR(1 + RAND()*3),

ROUND(200 + RAND()*2000,2)

FROM seq;

##############################################################  Website Sessions  #################################################################
CREATE TABLE apple_website_sessions (
session_id INT PRIMARY KEY,
customer_id INT,
device VARCHAR(50),
traffic_source VARCHAR(50),
session_duration INT,
pages_viewed INT
);

INSERT INTO apple_website_sessions
(session_id, customer_id, device, traffic_source, session_duration, pages_viewed)

WITH RECURSIVE seq AS (
SELECT 1 AS n
UNION ALL
SELECT n+1 FROM seq WHERE n < 50000
)

SELECT

n,

FLOOR(1 + RAND()*10000),

ELT(FLOOR(1+RAND()*3),
'Mobile','Desktop','Tablet'),

ELT(FLOOR(1+RAND()*4),
'Organic','Ads','Social','Direct'),

FLOOR(30 + RAND()*600),

FLOOR(1 + RAND()*10)

FROM seq;

########################################################## Product Reviews Table ##################################################################
CREATE TABLE apple_product_reviews (
review_id INT PRIMARY KEY,
product_id INT,
customer_id INT,
rating INT,
review_text TEXT,
review_date DATE,
FOREIGN KEY (product_id) REFERENCES apple_products(product_id),
FOREIGN KEY (customer_id) REFERENCES apple_customers(customer_id)
);

INSERT INTO apple_product_reviews
(review_id,product_id,customer_id,rating,review_text,review_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<10000
)

SELECT
n,
FLOOR(1+RAND()*100),
FLOOR(1+RAND()*10000),
FLOOR(1+RAND()*5),

ELT(FLOOR(1+RAND()*5),
'Great product',
'Very satisfied',
'Average quality',
'Not worth price',
'Excellent Apple device'),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*365) DAY)

FROM seq;

#############################################################  Returns Table  #####################################################################
CREATE TABLE apple_returns (
return_id INT PRIMARY KEY,
order_id INT,
product_id INT,
return_reason VARCHAR(100),
return_date DATE,
FOREIGN KEY (order_id) REFERENCES apple_orders(order_id)
);

INSERT INTO apple_returns
(return_id,order_id,product_id,return_reason,return_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<2000
)

SELECT
n,
FLOOR(1+RAND()*10000),
FLOOR(1+RAND()*100),

ELT(FLOOR(1+RAND()*4),
'Defective product',
'Wrong item',
'Customer changed mind',
'Damaged during shipping'),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*200) DAY)

FROM seq;

######################################################### Inventory Table #########################################################################
CREATE TABLE apple_inventory (
inventory_id INT PRIMARY KEY,
product_id INT,
stock_quantity INT,
warehouse_location VARCHAR(50),
last_updated DATE,
FOREIGN KEY (product_id) REFERENCES apple_products(product_id)
);

INSERT INTO apple_inventory
(inventory_id,product_id,stock_quantity,warehouse_location,last_updated)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<100
)

SELECT
n,
n,
FLOOR(50+RAND()*500),

ELT(FLOOR(1+RAND()*4),
'USA Warehouse',
'India Warehouse',
'Germany Warehouse',
'Singapore Warehouse'),

CURDATE()

FROM seq;

############################################################  Shipments Table  ####################################################################
CREATE TABLE apple_shipments (
shipment_id INT PRIMARY KEY,
order_id INT,
shipment_date DATE,
delivery_date DATE,
shipping_company VARCHAR(100),
shipping_cost DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES apple_orders(order_id)
);
INSERT INTO apple_shipments
(shipment_id,order_id,shipment_date,delivery_date,shipping_company,shipping_cost)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n<10000
)

SELECT
n,
FLOOR(1+RAND()*10000),

DATE_SUB(CURDATE(),INTERVAL FLOOR(RAND()*365) DAY),

DATE_ADD(CURDATE(),INTERVAL FLOOR(RAND()*7) DAY),

ELT(FLOOR(1+RAND()*4),
'FedEx','DHL','UPS','BlueDart'),

ROUND(5+RAND()*50,2)

FROM seq;

####################################################  Data Cleaning Queries ######################################################################
-- Missing Ratings
SELECT *
FROM apple_product_reviews
WHERE rating IS NULL;

-- Fix Missing Ratings
set sql_safe_updates=0;
UPDATE apple_product_reviews
SET rating = 3
WHERE rating IS NULL;

-- Remove Duplicate Reviews
SELECT product_id, customer_id, COUNT(*)
FROM apple_product_reviews
GROUP BY product_id, customer_id
HAVING COUNT(*)>1;

######################################################## Advanced Analytical Queries  ##############################################################
-- Top Rated Apple Products
SELECT
p.product_name,
AVG(r.rating) avg_rating
FROM apple_product_reviews r
JOIN apple_products p
ON r.product_id=p.product_id
GROUP BY p.product_name
ORDER BY avg_rating DESC;

-- Return Rate by Product
SELECT
p.product_name,
COUNT(r.return_id) returns
FROM apple_returns r
JOIN apple_products p
ON r.product_id=p.product_id
GROUP BY p.product_name
ORDER BY returns DESC;

-- Inventory Low Stock Alert
SELECT
p.product_name,
i.stock_quantity
FROM apple_inventory i
JOIN apple_products p
ON i.product_id=p.product_id
WHERE i.stock_quantity < 100;

-- Shipping Performance
SELECT
shipping_company,
AVG(DATEDIFF(delivery_date,shipment_date)) avg_delivery_days
FROM apple_shipments
GROUP BY shipping_company;

-- Top Customers by Spending
SELECT
customer_id,
SUM(total_amount) total_spent,
RANK() OVER(ORDER BY SUM(total_amount) DESC) ranking
FROM apple_orders
GROUP BY customer_id;

####################################################### PRODUCT INSIGHTS QUERIES ###################################################################
-- Best Selling Apple Products
SELECT
p.product_name,
SUM(oi.quantity) total_sold
FROM apple_order_items oi
JOIN apple_products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- Best Selling Category
SELECT
p.category,
SUM(oi.quantity) total_sales
FROM apple_order_items oi
JOIN apple_products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- Highest Revenue Products
SELECT
p.product_name,
SUM(oi.quantity * oi.price) revenue
FROM apple_order_items oi
JOIN apple_products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

############################################################### CUSTOMER ANALYTICS #################################################################
-- Customer Lifetime Value (CLV)
SELECT
c.customer_id,
c.customer_name,
SUM(o.total_amount) lifetime_value
FROM apple_customers c
JOIN apple_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY lifetime_value DESC
LIMIT 20;

-- Most Active Customers
SELECT
customer_id,
COUNT(order_id) total_orders
FROM apple_orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 20;

-- Country Wise Customers
SELECT
country,
COUNT(*) total_customers
FROM apple_customers
GROUP BY country
ORDER BY total_customers DESC;

############################################################# SALES ANALYTICS #####################################################################
-- Monthly Revenue Trend
SELECT
DATE_FORMAT(order_date,'%Y-%m') month,
SUM(total_amount) revenue
FROM apple_orders
GROUP BY month
ORDER BY month;

-- Average Order Value
SELECT
AVG(total_amount) avg_order_value
FROM apple_orders;

-- Daily Orders
SELECT
order_date,
COUNT(order_id) total_orders
FROM apple_orders
GROUP BY order_date
ORDER BY order_date;

########################################################### WEBSITE ANALYTICS ####################################################################
-- Traffic Source Performance
SELECT
traffic_source,
COUNT(*) sessions
FROM apple_website_sessions
GROUP BY traffic_source
ORDER BY sessions DESC;

-- Device Usage
SELECT
device,
COUNT(*) total_sessions
FROM apple_website_sessions
GROUP BY device;

-- Average Session Duration
SELECT
AVG(session_duration) avg_session_time
FROM apple_website_sessions;

######################################################## LOGISTICS ANALYSIS ######################################################################
-- Late Deliveries
SELECT
shipment_id,
DATEDIFF(delivery_date,shipment_date) delivery_days
FROM apple_shipments
WHERE DATEDIFF(delivery_date,shipment_date) > 5;

-- Shipping Cost by Company
SELECT
shipping_company,
AVG(shipping_cost) avg_shipping_cost
FROM apple_shipments
GROUP BY shipping_company;

############################################### ADVANCED SQL (WINDOW FUNCTIONS) ###################################################################
-- Revenue Ranking of Products
SELECT
product_id,
SUM(quantity * price) revenue,
RANK() OVER(ORDER BY SUM(quantity*price) DESC) revenue_rank
FROM apple_order_items
GROUP BY product_id;

-- Running Revenue
SELECT
order_date,
SUM(total_amount) revenue,
SUM(SUM(total_amount)) OVER(ORDER BY order_date) running_total
FROM apple_orders
GROUP BY order_date;

############################################################### DATA QUALITY CHECK ###############################################################
-- Duplicate Customers
SELECT
customer_name,
COUNT(*)
FROM apple_customers
GROUP BY customer_name
HAVING COUNT(*) > 1;

-- Products Without Orders
SELECT
p.product_name
FROM apple_products p
LEFT JOIN apple_order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Orders Without Shipment
SELECT
o.order_id
FROM apple_orders o
LEFT JOIN apple_shipments s
ON o.order_id = s.order_id
WHERE s.order_id IS NULL;

######################################################### BUSINESS DASHBOARD QUERIES ##############################################################

-- Total Revenue
SELECT SUM(total_amount) total_revenue
FROM apple_orders;

-- Total Customers
SELECT COUNT(*) total_customers
FROM apple_customers;
-- Total Orders
SELECT COUNT(*) total_orders
FROM apple_orders;

-- Total Products Sold
SELECT SUM(quantity) total_products_sold
FROM apple_order_items;