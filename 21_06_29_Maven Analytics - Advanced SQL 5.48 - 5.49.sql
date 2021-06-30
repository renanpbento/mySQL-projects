-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 5: Analyzing Website Performance (Lesson 48 - 49)

-- Assignment: Analyzing conversion funnel in A/B tests (before November 10, 2012)

-- 1) Finding the starting point to frame the analysis
SELECT
    MIN(wp.website_pageview_id) AS first_pv
FROM website_pageviews wp
WHERE 
    pageview_url = '/billing-2';
-- 53550

-- 2) Visualizing the pages with orders
SELECT
    wp.website_session_id,
    wp.pageview_url AS billing_version_seen,
    o.order_id
FROM website_pageviews wp
LEFT JOIN orders o ON wp.website_session_id = o.website_session_id
WHERE
    wp.website_pageview_id >= 53550
    AND wp.created_at < '2012-11-10'
    AND wp.pageview_url IN('/billing','/billing-2');

-- 3) Wrapping step (2) as a subquery to reach the goal
SELECT
    billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    ROUND((COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id)*100),2) AS billing_order_rate
FROM(SELECT
        wp.website_session_id,
        wp.pageview_url AS billing_version_seen,
        o.order_id
    FROM website_pageviews wp
    LEFT JOIN orders o ON wp.website_session_id = o.website_session_id
    WHERE
        wp.website_pageview_id >= 53550
        AND wp.created_at < '2012-11-10'
        AND wp.pageview_url IN('/billing','/billing-2')
    ) AS billing_sessions_orders
GROUP BY
	billing_version_seen;
