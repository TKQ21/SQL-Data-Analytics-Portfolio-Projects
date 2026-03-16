CREATE DATABASE GOOGLE_MARKETING_ANALYTICS_PROJECT;
USE GOOGLE_MARKETING_ANALYTICS_PROJECT;
######################################################## Total Insights Used (8 Major Insights) ###################################################
-- 1️⃣ Campaign Performance Insight

-- Queries:

-- Total campaigns

-- Active campaigns

-- Campaign budget distribution

-- 📌 Business Insight

-- Kaun se campaigns chal rahe hain

-- Kis channel par kitna budget spend ho raha hai

-- 2️⃣ Ad Click Performance Insight

-- Queries:

-- Total clicks

-- Clicks by campaign

-- Average CPC (Cost per click)

-- 📌 Business Insight

-- Kaun se ads sabse zyada traffic la rahe hain

-- Average advertising cost kya hai

-- 3️⃣ Conversion Performance Insight

-- Queries:

-- Total conversions

-- Conversion rate

-- Conversion count per campaign

-- 📌 Business Insight

-- Kitne clicks purchase me convert ho rahe hain

-- 4️⃣ Revenue Insight

-- Queries:

-- Total revenue

-- Revenue by campaign

-- Revenue by marketing channel

-- 📌 Business Insight

-- Kaun sa campaign sabse zyada revenue generate kar raha hai

-- 5️⃣ ROI / Profit Insight

-- Queries:

-- Cost vs revenue

-- Campaign profit

-- Top ROI campaigns

-- 📌 Business Insight

-- Marketing me paisa lagane ke baad actual profit kitna hua

-- 6️⃣ User Demographic Insight

-- Queries:

-- Users by country

-- Users by device

-- 📌 Business Insight

-- Kaun se countries aur devices se traffic aa raha hai

-- 7️⃣ Website Engagement Insight

-- Queries:

-- Traffic source analysis

-- Average session duration

-- Average pages viewed

-- 📌 Business Insight

-- Users website par kitna engage ho rahe hain

-- 8️⃣ Time Trend Insight

-- Queries:

-- Daily clicks trend

-- Daily revenue trend

-- 📌 Business Insight

-- Time ke saath marketing performance kaise change ho rahi hai

-- ⚙️ Recursion Limit
SET SESSION cte_max_recursion_depth = 60000;

############################################################ 📢 Campaigns Table ##################################################################
CREATE TABLE google_campaigns (
campaign_id INT PRIMARY KEY,
campaign_name VARCHAR(100),
channel VARCHAR(50),
budget DECIMAL(12,2),
start_date DATE,
end_date DATE
);

INSERT INTO google_campaigns
(campaign_id,campaign_name,channel,budget,start_date,end_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n < 100
)

SELECT
n,

CONCAT(
ELT(FLOOR(1+RAND()*5),
'Search Campaign',
'YouTube Ads',
'Display Ads',
'Shopping Ads',
'App Install Ads'
),
' ',n
),

ELT(FLOOR(1+RAND()*4),
'Search','YouTube','Display','Shopping'),

ROUND(1000 + RAND()*50000,2),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),

DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*60) DAY)

FROM seq;

############################################################## 👥 Users Table #####################################################################
CREATE TABLE google_users (
user_id INT PRIMARY KEY,
country VARCHAR(50),
device VARCHAR(50),
signup_date DATE
);

INSERT INTO google_users
(user_id,country,device,signup_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n < 50000
)

SELECT
n,

ELT(FLOOR(1+RAND()*6),
'USA','India','UK','Germany','Canada','Australia'),

ELT(FLOOR(1+RAND()*3),
'Mobile','Desktop','Tablet'),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1000) DAY)

FROM seq;

################################################################ 🖱 Ad Clicks Table ###############################################################
CREATE TABLE google_ad_clicks (
click_id INT PRIMARY KEY,
campaign_id INT,
user_id INT,
click_date DATE,
cost DECIMAL(8,2)
);

INSERT INTO google_ad_clicks
(click_id,campaign_id,user_id,click_date,cost)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n < 60000
)

SELECT
n,

FLOOR(1 + RAND()*100),

FLOOR(1 + RAND()*50000),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),

ROUND(0.2 + RAND()*5,2)

FROM seq;

######################################################### 💰 Conversions Table ####################################################################
CREATE TABLE google_conversions (
conversion_id INT PRIMARY KEY,
click_id INT,
revenue DECIMAL(10,2),
conversion_date DATE
);

INSERT INTO google_conversions
(conversion_id,click_id,revenue,conversion_date)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n < 20000
)

SELECT
n,

FLOOR(1 + RAND()*80000),

ROUND(10 + RAND()*500,2),

DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY)

FROM seq;

############################################################ 🌐 Website Sessions ##################################################################
CREATE TABLE google_sessions (
session_id INT PRIMARY KEY,
user_id INT,
traffic_source VARCHAR(50),
session_duration INT,
pages_viewed INT
);

INSERT INTO google_sessions
(session_id,user_id,traffic_source,session_duration,pages_viewed)

WITH RECURSIVE seq AS (
SELECT 1 n
UNION ALL
SELECT n+1 FROM seq WHERE n < 60000
)

SELECT
n,

FLOOR(1 + RAND()*50000),

ELT(FLOOR(1+RAND()*4),
'Organic','Paid Ads','Social','Direct'),

FLOOR(30 + RAND()*600),

FLOOR(1 + RAND()*10)

FROM seq;

############################################################ 🧹 Data Cleaning Queries ###############################################################
-- Check NULL values
SELECT *
FROM google_ad_clicks
WHERE cost IS NULL;

-- Fix Missing Revenue
UPDATE google_conversions
SET revenue = 0
WHERE revenue IS NULL;

-- Remove Duplicate Clicks
SELECT click_id, COUNT(*)
FROM google_ad_clicks
GROUP BY click_id
HAVING COUNT(*) > 1;

################################################### 📊 Marketing Analytics Queries ###############################################################
-- Campaign Performance
SELECT
campaign_id,
COUNT(click_id) total_clicks
FROM google_ad_clicks
GROUP BY campaign_id
ORDER BY total_clicks DESC;

-- Conversion Rate
SELECT
COUNT(conversion_id) /
(SELECT COUNT(click_id) FROM google_ad_clicks) AS conversion_rate
FROM google_conversions;

-- Revenue by Campaign
SELECT
c.campaign_name,
SUM(conv.revenue) revenue
FROM google_conversions conv
JOIN google_ad_clicks cl
ON conv.click_id = cl.click_id
JOIN google_campaigns c
ON cl.campaign_id = c.campaign_id
GROUP BY c.campaign_name
ORDER BY revenue DESC;

-- Cost vs Revenue (ROI)
SELECT
c.campaign_name,
SUM(cl.cost) total_cost,
SUM(conv.revenue) total_revenue,
SUM(conv.revenue) - SUM(cl.cost) profit
FROM google_campaigns c
JOIN google_ad_clicks cl
ON c.campaign_id = cl.campaign_id
LEFT JOIN google_conversions conv
ON cl.click_id = conv.click_id
GROUP BY c.campaign_name
ORDER BY profit DESC;

-- Top campaigns by ROI
SELECT *
FROM (

SELECT
c.campaign_name,
SUM(conv.revenue) - SUM(cl.cost) roi,
RANK() OVER(ORDER BY SUM(conv.revenue) - SUM(cl.cost) DESC) rnk

FROM google_campaigns c
JOIN google_ad_clicks cl
ON c.campaign_id = cl.campaign_id
LEFT JOIN google_conversions conv
ON cl.click_id = conv.click_id

GROUP BY c.campaign_name

) ranked

WHERE rnk <= 10;

################################################################# 📈 Dashboard Metrics ############################################################
-- Total Clicks
SELECT COUNT(*) FROM google_ad_clicks;

-- Total Conversions
SELECT COUNT(*) FROM google_conversions;

-- Total Revenue
SELECT SUM(revenue) FROM google_conversions;

-- Total Campaigns
SELECT COUNT(*) FROM google_campaigns;