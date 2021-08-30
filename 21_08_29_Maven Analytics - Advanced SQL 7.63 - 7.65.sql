-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 7: Analysis for Channel Portfolio Management

-- Lessons 63 - 65: Analyzing Direct, Brand-Driven Traffic

/* Assignment: Could you pull organic search, direct type in and paid
brand search sessions by month, and show those sessions as % of paid 
search nonbrand?*/

SELECT
	YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END) AS brand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) * 100 AS '%brand_nonbrand',
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END) AS direct,
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) * 100 AS '%direct_nonbrand',
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) AS direct,
    COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) * 100 AS '%organic_nonbrand'
FROM(
	SELECT
		website_session_id,
		created_at,
		CASE
			WHEN utm_source IS NULL AND http_referer IN('https://www.gsearch.com', 'https://www.bsearch.com') THEN 'organic_search'
			WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
			WHEN utm_campaign = 'brand' THEN 'paid_brand'
			WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
		END AS channel_group
	FROM website_sessions
	WHERE created_at < '2012-12-23') AS sessions_channel_group
GROUP BY 
	1, 2;

