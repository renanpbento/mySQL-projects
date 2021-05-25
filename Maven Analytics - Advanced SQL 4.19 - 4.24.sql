-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 4: Analyzing Traffic Sources (Lesson 19 - 24)

-- Example: Finding Top Traffic Sources
SELECT
	utm_content,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 1000 AND 2000
GROUP BY
	utm_content
ORDER BY sessions DESC; -- "sessions" have already been defined in the previous step of the query


-- (1) Assignment: Assessing the website sessions sources breakdown by UTM source, campaign and referring domain until (not including) April 12
SELECT
	utm_source,
    utm_campaign AS campaign,
    http_referer AS referring_domain,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY 
	utm_source,
    campaign,
    referring_domain
ORDER BY 
	sessions DESC;

-- (2) Assignment: Calculating the conversion rate from session to order (CVR)
SELECT
	COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS cvr,
    CASE 
		WHEN COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) < 0.04 THEN 'reduce'
		ELSE 'increase'  
	END AS bid
FROM website_sessions
LEFT JOIN orders ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-12'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY 
	cvr DESC;
