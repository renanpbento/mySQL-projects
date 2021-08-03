-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 7: Analysis for Channel Portfolio Management

-- Lessons 59 - 60: Cross-Channel Bid Optimization
/* I'm wondering if bsearch nonbrand should have the same bids as gsearch. Could you
pull nonbrand conversion rates from session to order for gsearch and bsearch, and slice
the data by device type? */

SELECT
	ws.device_type,
	ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND((COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) * 100), 2) AS conv_rate
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at BETWEEN '2012-08-22' AND '2012-09-18'
    AND utm_campaign = 'nonbrand'
GROUP BY
	1, 2