-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 4: Analyzing Traffic Sources (Lesson 25 - 31)

-- Example: Bid Optimization & Trend Analysis
SELECT
	primary_product_id,
    COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS count_single_item_orders,
	COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS count_two_item_orders
FROM orders
WHERE order_id BETWEEN 31000 AND 32000
GROUP BY 1;

-- (1) Assignment: Analyzing the weekly effect of a bid down in gsearch nonbrand volume
SELECT
    MIN(DATE(created_at)) AS week_started_at,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE
	utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    AND created_at < '2012-05-10'
GROUP BY
	YEAR(created_at),
    WEEK(created_at);

-- (2) Pulling conversion rates from sessions to order by device type
SELECT
	device_type,
	COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS cvr
FROM website_sessions
LEFT JOIN orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2012-05-11'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY
	device_type;

-- (3) Analyzing impact on volume of a bid through weekly trends for desktop and mobile
SELECT
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions
WHERE
	created_at < '2012-06-09'
	AND created_at > '2012-04-15'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at);
    





