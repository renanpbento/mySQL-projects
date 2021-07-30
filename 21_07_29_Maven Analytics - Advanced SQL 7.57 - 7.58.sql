-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 7: Analysis for Channel Portfolio Management

-- Lessons 57 - 58: Comparing Channel Characteristics
/* I'd like to learn more about the bsearch nonbrand campaign. Could you please pull
the percentage of traffic coming on Mobile and compare to gsearch? */

SELECT
    utm_source,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    ROUND((COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT website_session_id) * 100), 2) AS pct_mobile
FROM website_sessions
WHERE
    created_at BETWEEN '2012-08-23' AND '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY
    utm_source;
    
-- The analysis pointed to a significant difference in percentage of mobile sessions between bsearch and gsearch.
