## 🎬 NETFLIX DATA ANALYSIS SQL PROJECT
-- Project Objective

-- Is project ka goal hai Netflix dataset ko analyze karna aur following insights nikalna:

-- Movies vs TV Shows distribution

-- Most popular genres

-- Top directors and actors

-- Country wise content production

-- Netflix content growth trend

-- Genre popularity trend

-- Actor-director collaboration

-- Content KPIs
###################################################################################################################################################

--  KEY INSIGHTS

-- • Netflix library dominated by movies compared to TV shows
-- • Content production rapidly increased after 2015
-- • USA and India are among the largest content producers
-- • Drama and International movies are the most common genres
-- • Some actors appear in multiple Netflix productions

-- 9️⃣ SKILLS DEMONSTRATED

-- Project me use hua:

-- SQL Data Cleaning

-- String Functions

-- Aggregate Functions

-- Window Functions

-- Recursive CTE

-- Data Transformation

-- KPI Analysis

-- Business Insights
####################################################################################################################################################
CREATE DATABASE netflix_project;
USE netflix_project;

################################################################ DATA CLEANING ###################################################################
-- Check NULL values
SELECT
COUNT(*) total_rows,
COUNT(title) title_count,
COUNT(director) director_count,
COUNT(country) country_count,
COUNT(date_added) date_count
FROM netflix_titles;

-- Replace empty values
set sql_safe_updates=0;
UPDATE netflix_titles
SET director = 'Unknown'
WHERE director IS NULL OR director = '';

UPDATE netflix_titles
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

-- Convert date_added to DATE
ALTER TABLE netflix_titles
ADD COLUMN date_added_new DATE;

UPDATE netflix_titles
SET date_added_new = STR_TO_DATE(date_added,'%M %d, %Y');

-- Extract movie duration
ALTER TABLE netflix_titles
ADD COLUMN duration_minutes INT;
UPDATE netflix_titles
SET duration_minutes =
CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED)
WHERE type='Movie';

################################################################ EXPLORATORY DATA ANALYSIS ########################################################
--  Movies vs TV Shows
SELECT type,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY type;

-- Content added per year
SELECT
YEAR(date_added_new) year_added,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY year_added
ORDER BY year_added;

-- Top countries producing content
SELECT
country,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;

-- Which actor appears in most movies


WITH RECURSIVE actor_split AS (

SELECT
show_id,
TRIM(SUBSTRING_INDEX(cast,',',1)) actor,
SUBSTRING(cast,LENGTH(SUBSTRING_INDEX(cast,',',1))+2) remaining
FROM netflix_titles
WHERE type='Movie'

UNION ALL

SELECT
show_id,
TRIM(SUBSTRING_INDEX(remaining,',',1)),
SUBSTRING(remaining,LENGTH(SUBSTRING_INDEX(remaining,',',1))+2)
FROM actor_split
WHERE remaining<>''

)

SELECT
actor,
COUNT(*) movie_count
FROM actor_split
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

-- Which country produces most Netflix content
SELECT
country,
COUNT(*) total_content
FROM netflix_titles
GROUP BY country
ORDER BY total_content DESC
LIMIT 10;

-- Trend of Netflix content over years
SELECT
release_year,
COUNT(*) total_content
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- Top genres on Netflix
SELECT
listed_in genre,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY genre
ORDER BY total_titles DESC
LIMIT 10;

-- Longest movie duration
SELECT
title,
duration_minutes
FROM netflix_titles
WHERE type='Movie'
ORDER BY duration_minutes DESC
LIMIT 10;

-- Average movie duration by country
SELECT
country,
AVG(duration_minutes) avg_duration
FROM netflix_titles
WHERE type='Movie'
GROUP BY country
ORDER BY avg_duration DESC
LIMIT 10;

--  Directors with most movies
SELECT
director,
COUNT(*) total_movies
FROM netflix_titles
WHERE type='Movie'
GROUP BY director
ORDER BY total_movies DESC
LIMIT 10;

-- Actor + Director collaboration frequency
SELECT
director,
cast,
COUNT(*) collaboration_count
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director, cast
ORDER BY collaboration_count DESC
LIMIT 10;

-- Netflix content growth rate per year
SELECT
release_year,
COUNT(*) total_titles,
LAG(COUNT(*)) OVER(ORDER BY release_year) prev_year,
ROUND(
((COUNT(*) - LAG(COUNT(*)) OVER(ORDER BY release_year))
/ LAG(COUNT(*)) OVER(ORDER BY release_year))*100,2
) growth_rate
FROM netflix_titles
GROUP BY release_year;

-- Genre popularity trend
SELECT
release_year,
listed_in genre,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY release_year,genre
ORDER BY release_year;

############################################################### BUSINESS KPIs ####################################################################

-- Total Netflix titles
SELECT COUNT(*) total_titles
FROM netflix_titles;

-- Total Movies
SELECT COUNT(*) total_movies
FROM netflix_titles
WHERE type='Movie';

-- Avg Movie Duration
SELECT AVG(duration_minutes)
FROM netflix_titles
WHERE type='Movie';

-- Content Growth
SELECT
release_year,
COUNT(*)
FROM netflix_titles
GROUP BY release_year;

-- Total TV Shows
SELECT COUNT(*) total_tvshows
FROM netflix_titles
WHERE type='TV Show';

-- Movies percentage
SELECT
ROUND(
SUM(CASE WHEN type='Movie' THEN 1 ELSE 0 END)
/ COUNT(*) * 100,2
) movie_percentage
FROM netflix_titles;

-- INDEX CREATE
CREATE INDEX idx_release_year
ON netflix_titles(release_year);

CREATE INDEX idx_title
ON netflix_titles(title(100));

CREATE INDEX idx_country
ON netflix_titles(country(100));


CREATE INDEX idx_type
ON netflix_titles(type(100));

-- Movies longer than average
SELECT title,duration_minutes
FROM netflix_titles
WHERE duration_minutes >
(
SELECT AVG(duration_minutes)
FROM netflix_titles
WHERE type='Movie'
);

-- Countries producing above average content
SELECT country,COUNT(*)
FROM netflix_titles
GROUP BY country
HAVING COUNT(*) >
(
SELECT AVG(content_count)
FROM
(
SELECT COUNT(*) content_count
FROM netflix_titles
GROUP BY country
) t
);


-- SCHEMA JOIN 
-- Country Dimension
CREATE TABLE dim_country (
country_id INT AUTO_INCREMENT PRIMARY KEY,
country_name VARCHAR(100)
);

-- Genre Dimension
CREATE TABLE dim_genre (
genre_id INT AUTO_INCREMENT PRIMARY KEY,
genre_name VARCHAR(100)
);

-- Director Dimension
CREATE TABLE dim_director (
director_id INT AUTO_INCREMENT PRIMARY KEY,
director_name VARCHAR(150)
);

-- Rating Dimension
CREATE TABLE dim_rating (
rating_id INT AUTO_INCREMENT PRIMARY KEY,
rating_name VARCHAR(20)
);

-- Fact Table
CREATE TABLE fact_content (
content_id VARCHAR(10) PRIMARY KEY,
title VARCHAR(255),
type VARCHAR(20),
release_year INT,
country_id INT,
genre_id INT,
director_id INT,
rating_id INT
);
INSERT INTO fact_content
(content_id,title,type,release_year)
SELECT
show_id,
title,
type,
release_year
FROM netflix_titles;
SELECT * FROM fact_content LIMIT 10;

SELECT
    f.content_id,
    f.title,
    f.type,
    f.release_year,
    c.country_name,
    g.genre_name,
    d.director_name,
    r.rating_name
FROM fact_content f
LEFT JOIN dim_country c
    ON f.country_id = c.country_id
LEFT JOIN dim_genre g
    ON f.genre_id = g.genre_id
LEFT JOIN dim_director d
    ON f.director_id = d.director_id
LEFT JOIN dim_rating r
    ON f.rating_id = r.rating_id
ORDER BY f.release_year DESC;


       -- Why LEFT JOIN?
	   -- Because kuch rows me director ya country missing ho sakta hai.

-- TOP ACTORS (Recursive CTE)

WITH RECURSIVE actor_split AS (

SELECT
show_id,
TRIM(SUBSTRING_INDEX(cast, ',', 1)) AS actor,
SUBSTRING(cast, LENGTH(SUBSTRING_INDEX(cast, ',', 1)) + 2) AS remaining
FROM netflix_titles
WHERE cast IS NOT NULL

UNION ALL

SELECT
show_id,
TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
FROM actor_split
WHERE remaining <> ''

)

SELECT
actor,
COUNT(*) AS total_movies
FROM actor_split
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;

-- DIRECTOR POPULARITY
SELECT
director,
COUNT(*) AS total_titles
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;


--  CONTENT GROWTH RATE
SELECT
release_year,
COUNT(*) AS total_content,
LAG(COUNT(*)) OVER (ORDER BY release_year) AS previous_year,

ROUND(
(COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY release_year))
/
LAG(COUNT(*)) OVER (ORDER BY release_year) * 100
,2) AS growth_rate
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;


-- ACTOR COLLABORATION NETWORK

      -- Actors jo same movie me kaam karte hain.
SELECT
t1.title,
t1.cast AS actor1,
t2.cast AS actor2
FROM netflix_titles t1
JOIN netflix_titles t2
ON t1.show_id = t2.show_id
WHERE t1.cast <> t2.cast
LIMIT 20;

-- COUNTRY PRODUCTION RANKING
SELECT
country,
COUNT(*) AS total_titles,
RANK() OVER(ORDER BY COUNT(*) DESC) AS country_rank
FROM netflix_titles
GROUP BY country;

###################################################### IMDb + Netflix COMBINED ANALYSIS ##########################################################

CREATE TABLE imdb_movies (
movie_id INT,
title VARCHAR(255),
imdb_rating FLOAT,
votes INT,
release_year INT
);
INSERT INTO imdb_movies VALUES
(10,'Dick Johnson Is Dead',7.5,15000,2020),
(11,'Blood & Water',7.2,12000,2020),
(12,'Ganglands',7.0,8000,2021),
(13,'Jailbirds New Orleans',6.5,5000,2021),
(14,'Kota Factory',9.0,90000,2019);

-- NETFLIX + IMDb JOIN
SELECT
n.title,
n.release_year,
i.imdb_rating,
i.votes
FROM netflix_titles n
JOIN imdb_movies i
ON n.title = i.title;


-- BEST RATED NETFLIX MOVIES
SELECT
n.title,
n.release_year,
i.imdb_rating
FROM netflix_titles n
JOIN imdb_movies i
ON n.title = i.title
ORDER BY i.imdb_rating DESC
LIMIT 10;

 -- GENRE VS IMDb RATING
SELECT
n.listed_in,
AVG(i.imdb_rating) AS avg_rating
FROM netflix_titles n
JOIN imdb_movies i
ON n.title = i.title
GROUP BY n.listed_in
ORDER BY avg_rating DESC;

--  TOP COUNTRIES WITH HIGHEST RATED MOVIES
SELECT
n.country,
AVG(i.imdb_rating) AS avg_rating
FROM netflix_titles n
JOIN imdb_movies i
ON n.title = i.title
GROUP BY n.country
ORDER BY avg_rating DESC
LIMIT 10;

-- MOST POPULAR ACTORS (IMDb Votes)
SELECT
n.cast,
SUM(i.votes) AS total_votes
FROM netflix_titles n
JOIN imdb_movies i
ON n.title = i.title
GROUP BY n.cast
ORDER BY total_votes DESC
LIMIT 10;

-- Best rated Netflix movies
SELECT
n.title,
n.release_year,
i.imdb_rating
FROM netflix_titles n
JOIN imdb_movies i
ON LOWER(n.title) = LOWER(i.title)
ORDER BY i.imdb_rating DESC
LIMIT 10;

-- Genre vs IMDb rating
SELECT
n.listed_in,
AVG(i.imdb_rating) AS avg_rating
FROM netflix_titles n
JOIN imdb_movies i
ON LOWER(n.title) = LOWER(i.title)
GROUP BY n.listed_in
ORDER BY avg_rating DESC;

-- Country vs rating
SELECT
n.country,
AVG(i.imdb_rating) AS avg_rating
FROM netflix_titles n
JOIN imdb_movies i
ON LOWER(n.title) = LOWER(i.title)
GROUP BY n.country
ORDER BY avg_rating DESC
LIMIT 10;

-- Netflix Content Age
SELECT
release_year,
COUNT(*) total_titles,
AVG(YEAR(CURDATE()) - release_year) avg_content_age
FROM netflix_titles
GROUP BY release_year;

-- Top Genres Per Year
SELECT *
FROM
(
SELECT
release_year,
listed_in,
COUNT(*) total_titles,
RANK() OVER(PARTITION BY release_year ORDER BY COUNT(*) DESC) rnk
FROM netflix_titles
GROUP BY release_year, listed_in
) t
WHERE rnk = 1;

-- Which rating category dominates Netflix
SELECT
rating,
COUNT(*) total_titles
FROM netflix_titles
GROUP BY rating
ORDER BY total_titles DESC;

################################################################## Netflix + TMDB ################################################################
CREATE TABLE tmdb_movies (
    tmdb_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    release_year INT,
    popularity DECIMAL(10,2),
    budget BIGINT,
    revenue BIGINT,
    runtime INT,
    original_language VARCHAR(10)
);
INSERT INTO tmdb_movies
(title, release_year, popularity, budget, revenue, runtime, original_language)
VALUES
('Dick Johnson Is Dead', 2020, 70.2, 5000000, 15000000, 90, 'en'),
('Blood & Water', 2020, 65.5, 2000000, 8000000, 50, 'en'),
('Ganglands', 2021, 60.4, 3000000, 9000000, 45, 'fr'),
('Jailbirds New Orleans', 2021, 55.2, 1000000, 4000000, 40, 'en'),
('Kota Factory', 2019, 85.7, 1500000, 10000000, 45, 'hi');

-- NETFLIX + TMDB JOIN
SELECT
n.title,
n.type,
n.release_year,
t.popularity,
t.budget,
t.revenue
FROM netflix_titles n
LEFT JOIN tmdb_movies t
ON LOWER(TRIM(n.title)) = LOWER(TRIM(t.title))
ORDER BY t.popularity DESC;

-- TOP POPULAR MOVIES
SELECT
title,
popularity
FROM tmdb_movies
ORDER BY popularity DESC
LIMIT 10;

-- MOST PROFITABLE MOVIES
SELECT
title,
budget,
revenue,
(revenue - budget) AS profit
FROM tmdb_movies
ORDER BY profit DESC;
