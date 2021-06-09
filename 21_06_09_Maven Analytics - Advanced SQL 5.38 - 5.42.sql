-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 5: Analyzing Website Performance (Lesson 38 - 42)

-- Assignment: Analyzing bounce rates in the homepage
/* "Can you pull bounce rates for traffic landing on the homepage? 
I would like to see three numbers: Sessions, Bounced Sessions and Bounce Rate"*/

-- (1) Finding the first website pageview for relevant sessions
CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_session_id,
    MIN(website_pageview_id) AS min_pageview
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY
	website_session_id;
    
-- (2) Identifying the landing page of each session and bounces
CREATE TEMPORARY TABLE sessions_home_landing_page
SELECT
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = first_pageviews.min_pageview
WHERE
	website_pageviews.pageview_url = '/home';

CREATE TEMPORARY TABLE bounced_sessions
SELECT
	sessions_home_landing_page.website_session_id,
    sessions_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_home_landing_page
	LEFT JOIN website_pageviews ON website_pageviews.website_session_id = sessions_home_landing_page.website_session_id
GROUP BY
	sessions_home_landing_page.website_session_id,
    sessions_home_landing_page.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;

-- (3) Calculating the Bounce Rate
SELECT
	COUNT(DISTINCT sessions_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    ROUND((COUNT(DISTINCT bounced_sessions.website_session_id) / COUNT(DISTINCT sessions_home_landing_page.website_session_id) * 100), 2) AS bounce_rate
FROM sessions_home_landing_page
	LEFT JOIN bounced_sessions ON sessions_home_landing_page.website_session_id = bounced_sessions.website_session_id;
    
-- Assignment: Analyzing landing page tests (A/B test)
/* Can you pull bounce rates for the two groups so we can evaluate the new page?
Make sure to just look at the time period where /lander-1 was getting traffic, so that it is a fair comparison.*/

-- (1) Determining the period of comparison between both pages
CREATE TEMPORARY TABLE first_landing_1
SELECT
	MIN(created_at) AS first_created,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE
	created_at < '2012-07-28'
	AND website_pageviews.pageview_url = '/lander-1';
    
SELECT * FROM first_landing_1;

-- Begin Date for comparison is 2012-06-19

-- (2) Building conditions to find the bounce rates from the A/B test
CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
	website_pageviews.website_session_id,
	MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2012-07-28'
    AND website_pageviews.website_pageview_id > 23504
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY
	website_pageviews.website_session_id;

CREATE TEMPORARY TABLE nonbrand_test_sessions
SELECT
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_test_pageviews
	LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN('/home', '/lander-1');

CREATE TEMPORARY TABLE nonbrand_test_bounced
SELECT
	nonbrand_test_sessions.website_session_id,
    nonbrand_test_sessions.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM nonbrand_test_sessions
LEFT JOIN website_pageviews ON nonbrand_test_sessions.website_session_id = website_pageviews.website_session_id
GROUP BY
	nonbrand_test_sessions.website_session_id,
    nonbrand_test_sessions.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;
    
SELECT
	nonbrand_test_sessions.landing_page,
    nonbrand_test_sessions.website_session_id,
    nonbrand_test_bounced.website_session_id AS bounced_website_session_id
FROM nonbrand_test_sessions
	LEFT JOIN nonbrand_test_bounced ON nonbrand_test_sessions.website_session_id = nonbrand_test_bounced.website_session_id
ORDER BY
	nonbrand_test_sessions.website_session_id;

-- (3) Final Step
SELECT
	nonbrand_test_sessions.landing_page,
    COUNT(DISTINCT nonbrand_test_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT nonbrand_test_bounced.website_session_id) AS bounced_sessions,
	(ROUND(COUNT(DISTINCT nonbrand_test_bounced.website_session_id) / COUNT(DISTINCT nonbrand_test_sessions.website_session_id), 2) * 100) AS bounce_rate
FROM nonbrand_test_sessions
	LEFT JOIN nonbrand_test_bounced ON nonbrand_test_sessions.website_session_id = nonbrand_test_bounced.website_session_id
GROUP BY
	nonbrand_test_sessions.landing_page;
