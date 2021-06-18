-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 5: Analyzing Website Performance (Lesson 43 - 44)

-- Assignment: pulling the volume of paid search nonbrand traffic landing based on the A/B Test trended weekly since 1st June

-- 1) Finding the first website_pageview_id for relevant sessions
-- 2) Identifying the landing page of each sessions
-- 3) Counting pageviews for each session to identify "bounces"
-- 4) Summarizing by week (bounce rate, sessions to each lander)

CREATE TEMPORARY TABLE sessions_min_pv
SELECT
    ws.website_session_id,
    MIN(wp.website_pageview_id) AS first_pageview_id,
    COUNT(wp.website_pageview_id) AS count_pageviews
FROM website_sessions ws
LEFT JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
WHERE 
    ws.created_at BETWEEN '2012-06-02' AND '2012-08-30'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY
	ws.website_session_id;

CREATE TEMPORARY TABLE sessions_with_counts_lander
SELECT
    smp.website_session_id,
    smp.first_pageview_id,
    smp.count_pageviews,
    wp.pageview_url AS landing_page,
    wp.created_at AS sessions_created_at
FROM sessions_min_pv smp
LEFT JOIN website_pageviews wp ON smp.first_pageview_id = wp.website_pageview_id;

SELECT
    MIN(DATE(sessions_created_at)) AS week_start_date,
    ROUND((COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END)*1.0/COUNT(DISTINCT website_session_id))*100,2) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM sessions_with_counts_lander scl
GROUP BY
    YEARWEEK(sessions_created_at);
