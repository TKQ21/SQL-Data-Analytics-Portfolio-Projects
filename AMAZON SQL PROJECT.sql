-- 🛒 AMAZON AFFILIATE DATA ANALYSIS SQL PROJECT
-- 🎯Project Objective

-- Is project ka goal hai Amazon Affiliate marketing data ko analyze karna aur business insights nikalna:

-- Most clicked products

-- Highest revenue generating products

-- Conversion rate analysis

-- User behavior insights

-- Category performance

-- Click → Purchase funnel

-- Affiliate marketing KPIs

-- 📊 Key Insights

-- Typical insights jo milte hain:

-- Some products receive high clicks but low conversions

-- Certain categories generate higher commissions

-- Top users generate majority of clicks

-- Conversion rate varies across traffic sources

-- 🧠 Skills Demonstrated

-- Is project me use hua:

-- SQL Data Cleaning

-- Aggregate Functions

-- Window Functions

-- Joins

-- Subqueries

-- KPI Analysis

-- Funnel Analysis

-- Business Analytics

##################################################################################################################################################
CREATE DATABASE amazon_affiliate_project;
USE amazon_affiliate_project;
############################################################# DATA CLEANING ######################################################################
###################################################### AMAZON PRODUCT CATALOG ####################################################################
DESCRIBE amazon_products_catalog;
-- 1️⃣ amazon_products_catalog – Data Types Fix
ALTER TABLE amazon_products_catalog MODIFY product_asin VARCHAR(20);
ALTER TABLE amazon_products_catalog MODIFY product_title VARCHAR(255);
ALTER TABLE amazon_products_catalog MODIFY brand VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY category VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY subcategory VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY price DECIMAL(10,2);
ALTER TABLE amazon_products_catalog MODIFY original_price DECIMAL(10,2);
ALTER TABLE amazon_products_catalog MODIFY discount_percentage INT;
ALTER TABLE amazon_products_catalog MODIFY rating DECIMAL(3,2);
ALTER TABLE amazon_products_catalog MODIFY review_count INT;
ALTER TABLE amazon_products_catalog MODIFY prime_eligible VARCHAR(10);
ALTER TABLE amazon_products_catalog MODIFY bestseller_rank INT;
ALTER TABLE amazon_products_catalog MODIFY release_date DATE;
ALTER TABLE amazon_products_catalog MODIFY dimensions VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY weight VARCHAR(50);
ALTER TABLE amazon_products_catalog MODIFY commission_rate DECIMAL(5,2);
ALTER TABLE amazon_products_catalog MODIFY affiliate_fee_structure VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY target_audience VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY seasonal_trend VARCHAR(100);
ALTER TABLE amazon_products_catalog MODIFY inventory_status VARCHAR(50);
ALTER TABLE amazon_products_catalog MODIFY color_options VARCHAR(50);
ALTER TABLE amazon_products_catalog MODIFY size_options VARCHAR(50);
ALTER TABLE amazon_products_catalog MODIFY product_description VARCHAR(200);
ALTER TABLE amazon_products_catalog MODIFY key_features VARCHAR(200);

########################################################## AMAZON AFFILIATE CLICKS ################################################################
DESCRIBE amazon_affiliate_clicks;
ALTER TABLE amazon_affiliate_clicks MODIFY click_id VARCHAR(50);
ALTER TABLE amazon_affiliate_clicks MODIFY user_id VARCHAR(50);
ALTER TABLE amazon_affiliate_clicks MODIFY session_id VARCHAR(50);
ALTER TABLE amazon_affiliate_clicks MODIFY timestamp DATETIME;
ALTER TABLE amazon_affiliate_clicks MODIFY product_asin VARCHAR(20);
ALTER TABLE amazon_affiliate_clicks MODIFY product_title VARCHAR(255);
ALTER TABLE amazon_affiliate_clicks MODIFY product_category VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY product_price DECIMAL(10,2);
ALTER TABLE amazon_affiliate_clicks MODIFY affiliate_link VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY source_page VARCHAR(50);
ALTER TABLE amazon_affiliate_clicks MODIFY user_agent VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY ip_address VARCHAR(45);
ALTER TABLE amazon_affiliate_clicks MODIFY country VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY device_type VARCHAR(50);
ALTER TABLE amazon_affiliate_clicks MODIFY click_position INT;
ALTER TABLE amazon_affiliate_clicks MODIFY page_scroll_depth DECIMAL(5,2);
ALTER TABLE amazon_affiliate_clicks MODIFY time_on_page_before_click INT;
ALTER TABLE amazon_affiliate_clicks MODIFY referrer_url VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY utm_source VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY utm_medium VARCHAR(100);
ALTER TABLE amazon_affiliate_clicks MODIFY utm_campaign VARCHAR(100);

########################################################## AMAZON AFFILIATE CONVERSIONS ###########################################################
DESCRIBE amazon_affiliate_conversions;
ALTER TABLE amazon_affiliate_conversions MODIFY conversion_id VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY click_id VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY user_id VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY order_id VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY timestamp DATETIME;
ALTER TABLE amazon_affiliate_conversions MODIFY product_asin VARCHAR(20);
ALTER TABLE amazon_affiliate_conversions MODIFY product_title VARCHAR(255);
ALTER TABLE amazon_affiliate_conversions MODIFY product_category VARCHAR(100);
ALTER TABLE amazon_affiliate_conversions MODIFY order_value DECIMAL(10,2);
ALTER TABLE amazon_affiliate_conversions MODIFY commission_rate DECIMAL(5,2);
ALTER TABLE amazon_affiliate_conversions MODIFY commission_earned DECIMAL(10,2);
ALTER TABLE amazon_affiliate_conversions MODIFY quantity_purchased INT;
ALTER TABLE amazon_affiliate_conversions MODIFY conversion_time_hours DECIMAL(6,2);
ALTER TABLE amazon_affiliate_conversions MODIFY customer_type VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY payment_method VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY shipping_method VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY order_status VARCHAR(50);
ALTER TABLE amazon_affiliate_conversions MODIFY return_status VARCHAR(10);
ALTER TABLE amazon_affiliate_conversions MODIFY customer_lifetime_value DECIMAL(10,2);
ALTER TABLE amazon_affiliate_conversions MODIFY previous_orders_count INT;

######################################################## USER BEHAVIOR ANALYTICS ##################################################################
DESCRIBE user_behavior_analytics;
ALTER TABLE user_behavior_analytics MODIFY session_id VARCHAR(50);
ALTER TABLE user_behavior_analytics MODIFY user_id VARCHAR(50);
ALTER TABLE user_behavior_analytics MODIFY timestamp DATETIME;
ALTER TABLE user_behavior_analytics MODIFY page_url VARCHAR(50);
ALTER TABLE user_behavior_analytics MODIFY page_title VARCHAR(255);
ALTER TABLE user_behavior_analytics MODIFY page_type VARCHAR(100);
ALTER TABLE user_behavior_analytics MODIFY time_on_page_seconds INT;
ALTER TABLE user_behavior_analytics MODIFY scroll_depth_percentage INT;
ALTER TABLE user_behavior_analytics MODIFY bounce_rate INT;
ALTER TABLE user_behavior_analytics MODIFY exit_rate INT;
ALTER TABLE user_behavior_analytics MODIFY page_views_in_session INT;
ALTER TABLE user_behavior_analytics MODIFY session_duration_minutes DECIMAL(6,2);
ALTER TABLE user_behavior_analytics MODIFY traffic_source VARCHAR(100);
ALTER TABLE user_behavior_analytics MODIFY device_type VARCHAR(50);
ALTER TABLE user_behavior_analytics MODIFY browser VARCHAR(100);
ALTER TABLE user_behavior_analytics MODIFY operating_system VARCHAR(100);
ALTER TABLE user_behavior_analytics MODIFY screen_resolution VARCHAR(50);
ALTER TABLE user_behavior_analytics MODIFY geographic_location VARCHAR(100);
ALTER TABLE user_behavior_analytics MODIFY new_vs_returning VARCHAR(20);
ALTER TABLE user_behavior_analytics MODIFY user_engagement_score DECIMAL(5,2);
ALTER TABLE user_behavior_analytics MODIFY conversion_funnel_stage VARCHAR(100);

-- Check Missing Values

SELECT *
FROM user_behavior_analytics
WHERE user_id IS NULL 
   OR session_id IS NULL;
   
-- Remove Duplicate Rows

DELETE t1
FROM amazon_affiliate_clicks t1
JOIN amazon_affiliate_clicks t2
ON t1.click_id = t2.click_id
AND t1.timestamp > t2.timestamp;

-- Find Duplicate Records

SELECT click_id, COUNT(*)
FROM amazon_affiliate_clicks
GROUP BY click_id
HAVING COUNT(*) > 1;

-- Replace Missing Values

UPDATE amazon_products_catalog
SET brand = 'Unknown'
WHERE brand IS NULL;

-- Remove Invalid Prices

DELETE FROM amazon_products_catalog
WHERE price <= 0;

-- Standardize Text Values

UPDATE amazon_products_catalog
SET brand = UPPER(brand);

-- Trim Extra Spaces

UPDATE amazon_products_catalog
SET product_title = TRIM(product_title);

-- Remove NULL Price Records

DELETE FROM amazon_products_catalog
WHERE price IS NULL;

-- Replace Missing Category

UPDATE amazon_products_catalog
SET category = 'Other'
WHERE category IS NULL;

-- Remove Duplicate Products

SELECT product_asin, COUNT(*)
FROM amazon_products_catalog
GROUP BY product_asin
HAVING COUNT(*) > 1;

########################################################### QUERIES ##############################################################################
-- Total Products
SELECT COUNT(*) 
FROM amazon_products_catalog;

-- List All Categories
SELECT DISTINCT category
FROM amazon_products_catalog;

-- Top 10 Expensive Products
SELECT product_title, price
FROM amazon_products_catalog
ORDER BY price DESC
LIMIT 10;

-- Total Clicks
SELECT COUNT(*)
FROM amazon_affiliate_clicks;

-- Total Conversions
SELECT COUNT(*)
FROM amazon_affiliate_conversions;

-- Most Clicked Products
SELECT product_asin, COUNT(*) AS total_clicks
FROM amazon_affiliate_clicks
GROUP BY product_asin
ORDER BY total_clicks DESC
LIMIT 10;

-- Revenue Generated
SELECT SUM(order_value) AS total_revenue
FROM amazon_affiliate_conversions;

-- Average Product Price
SELECT AVG(price)
FROM amazon_products_catalog;

-- Products with Highest Reviews
SELECT product_title, review_count
FROM amazon_products_catalog
ORDER BY review_count DESC
LIMIT 10;

-- Conversion Rate
SELECT 
COUNT(DISTINCT conversion_id) * 100.0 /
COUNT(DISTINCT click_id) AS conversion_rate
FROM amazon_affiliate_conversions;

-- Total Commission Earned
SELECT SUM(commission_earned) AS total_commission
FROM amazon_affiliate_conversions;

-- Average Product Rating
SELECT AVG(rating) AS avg_rating
FROM amazon_products_catalog;

-- Average Discount
SELECT AVG(discount_percentage)
FROM amazon_products_catalog;

################################################################ JOINS ###########################################################################
-- Clicks + Product Info
SELECT c.click_id, p.product_title, p.price
FROM amazon_affiliate_clicks c
JOIN amazon_products_catalog p
ON c.product_asin = p.product_asin;

-- Conversions with Product Details
SELECT 
a.order_id,
p.product_title,
a.order_value
FROM amazon_affiliate_conversions a
JOIN amazon_products_catalog p
ON a.product_asin = p.product_asin;

-- Top Revenue Products
SELECT 
product_asin,
SUM(order_value) AS revenue
FROM amazon_affiliate_conversions
GROUP BY product_asin
ORDER BY revenue DESC
LIMIT 10;

-- Category Wise Revenue
SELECT 
p.category,
SUM(c.order_value) AS revenue
FROM amazon_affiliate_conversions c
JOIN amazon_products_catalog p
ON c.product_asin = p.product_asin
GROUP BY p.category
ORDER BY revenue DESC;

-- Best Performing Traffic Source
SELECT 
traffic_source,
COUNT(*) AS sessions
FROM user_behavior_analytics
GROUP BY traffic_source
ORDER BY sessions DESC;

-- Device Wise Clicks
SELECT 
device_type,
COUNT(*) AS clicks
FROM amazon_affiliate_clicks
GROUP BY device_type;

-- Average Order Value
SELECT 
AVG(order_value) AS avg_order_value
FROM amazon_affiliate_conversions;

################################################################ WINDOW FUNCTIONS #################################################################
-- Rank Products by Revenue
SELECT 
product_asin,
SUM(order_value) AS revenue,
RANK() OVER(ORDER BY SUM(order_value) DESC) AS product_rank
FROM amazon_affiliate_conversions
GROUP BY product_asin;

-- Running Revenue Total
SELECT 
timestamp,
SUM(order_value) OVER(ORDER BY timestamp) AS running_revenue
FROM amazon_affiliate_conversions;


-- Conversion Rate by Traffic Source
SELECT 
u.traffic_source,
COUNT(DISTINCT c.conversion_id) /
COUNT(DISTINCT a.click_id) * 100 AS conversion_rate
FROM amazon_affiliate_clicks a
LEFT JOIN amazon_affiliate_conversions c
ON a.click_id = c.click_id
JOIN user_behavior_analytics u
ON a.session_id = u.session_id
GROUP BY u.traffic_source;

-- Most Profitable Categories
SELECT 
p.category,
SUM(c.commission_earned) AS total_commission
FROM amazon_affiliate_conversions c
JOIN amazon_products_catalog p
ON c.product_asin = p.product_asin
GROUP BY p.category
ORDER BY total_commission DESC;

-- Top 10 Products by Revenue
SELECT 
product_asin,
SUM(order_value) AS revenue
FROM amazon_affiliate_conversions
GROUP BY product_asin
ORDER BY revenue DESC
LIMIT 10;

-- Top Categories by Revenue
SELECT 
p.category,
SUM(c.order_value) AS revenue
FROM amazon_affiliate_conversions c
JOIN amazon_products_catalog p
ON c.product_asin = p.product_asin
GROUP BY p.category
ORDER BY revenue DESC;

-- Highest Commission Products
SELECT 
product_asin,
SUM(commission_earned) AS commission
FROM amazon_affiliate_conversions
GROUP BY product_asin
ORDER BY commission DESC
LIMIT 10;

-- Customer Behavior Analysis
   -- Returning vs New Users
SELECT 
new_vs_returning,
COUNT(*) AS users
FROM user_behavior_analytics
GROUP BY new_vs_returning;

-- Device Performance
SELECT 
device_type,
COUNT(*) AS sessions
FROM user_behavior_analytics
GROUP BY device_type;

-- Browser Usage
SELECT 
browser,
COUNT(*) AS users
FROM user_behavior_analytics
GROUP BY browser
ORDER BY users DESC;

-- Funnel Analysis
   -- Click → Conversion Funnel
SELECT
COUNT(DISTINCT a.click_id) AS total_clicks,
COUNT(DISTINCT c.conversion_id) AS total_conversions
FROM amazon_affiliate_clicks a
LEFT JOIN amazon_affiliate_conversions c
ON a.click_id = c.click_id;

-- Conversion Rate
SELECT 
COUNT(DISTINCT conversion_id) * 100.0 /
COUNT(DISTINCT click_id) AS conversion_rate
FROM amazon_affiliate_conversions;

-- Time Based Analysis
   -- Daily Revenue
SELECT 
DATE(timestamp) AS date,
SUM(order_value) AS revenue
FROM amazon_affiliate_conversions
GROUP BY DATE(timestamp)
ORDER BY date;

-- Monthly Revenue
SELECT 
MONTH(timestamp) AS month,
SUM(order_value) AS revenue
FROM amazon_affiliate_conversions
GROUP BY month;

-- Top Products Per Category
SELECT *
FROM (
SELECT 
p.category,
p.product_title,
SUM(c.order_value) AS revenue,
RANK() OVER(PARTITION BY p.category ORDER BY SUM(c.order_value) DESC) AS rank_num
FROM amazon_affiliate_conversions c
JOIN amazon_products_catalog p
ON c.product_asin = p.product_asin
GROUP BY p.category, p.product_title
) ranked
WHERE rank_num <= 3;

-- Customer Lifetime Value Ranking
SELECT 
user_id,
SUM(order_value) AS lifetime_value,
RANK() OVER(ORDER BY SUM(order_value) DESC) AS rank_num
FROM amazon_affiliate_conversions
GROUP BY user_id;

-- Performance Optimization Queries

CREATE INDEX idx_product_asin
ON amazon_products_catalog(product_asin);
CREATE INDEX idx_click_id
ON amazon_affiliate_clicks(click_id);
CREATE INDEX idx_conversion_click
ON amazon_affiliate_conversions(click_id);