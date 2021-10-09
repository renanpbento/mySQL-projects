-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 9: Product Analysis

-- Lessons 72 - 73: Analyzing Product-Level Sales

/* Assignment: Can you please pull monthly trends to date for number of sales,
total revenue and total margin generated for the business?*/

SELECT
	YEAR(created_at) AS 'year',
    MONTH(created_at) AS 'month',
    COUNT(DISTINCT order_id) AS sales,
	ROUND(SUM(price_usd),2) AS 'total_revenue',
    ROUND(SUM(price_usd - cogs_usd),2) AS 'total_margin'
FROM orders
WHERE
	created_at < '2013-01-04'
GROUP BY
	month
ORDER BY
	1,2;