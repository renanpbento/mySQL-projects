-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 8: Analyzing Business Patterns and Seasonality

-- Lessons 66 - 68: Analyzing Seasonality

/* Assignment: As we continue to grow, we should take a look at 2012's monthly and
weekly volume patterns, to see if we can find any seasonal trends we should plan for
in 2013. If you can pull session and order volume, that would be excellent.*/

SELECT
	YEAR(ws.created_at) AS 'year',
    WEEK(ws.created_at) AS 'week',
    MIN(DATE(ws.created_at)) AS 'week_start',
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at < '2013-01-01'
GROUP BY
	1, 2;