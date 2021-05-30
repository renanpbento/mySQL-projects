-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 5: Analyzing Website Performance (Lesson 32 - 37)

-- Example: Analyzing Top Website Pages & Entry Pages (Temporary Table Resource)
CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE 
	website_pageview_id < 1000
GROUP BY
	website_session_id;
    
SELECT
	website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT first_pageview.website_session_id) AS sessions_hitting_this_lander
FROM first_pageview
	LEFT JOIN website_pageviews ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY
	website_pageviews.pageview_url;

-- Assignment: Most-viewed website pages, ranked by session volume (until 2012-06-09, not included)

/* Breaking down the problem
To answer this question, it will be necessary to pull two sets of data:
	- Pageview Url (Website pages)
    - Sessions (Volume)*/

-- First Attempt: it looks like the "website_pageviews" Table has the required data
SELECT
	pageview_url AS website_page,
    COUNT(DISTINCT website_session_id) AS sessions_volume
FROM website_pageviews
WHERE
	created_at < '2012-06-09'
GROUP BY
	website_page
ORDER BY
	sessions_volume DESC;
-- Spot On Solution!

-- Assignment: Finding top entry pages, ranked by entry volume (until 2012-06-12, not included)

/* Breaking down the problem:
To answer this question, it will be necessary to pull two sets of data:
	- Landing Page (Website Pageview Id)
    - Sessions (Volume) */

-- First Attempt
-- (1) Creating a Temporary Table of first pageviews (entry session)
CREATE TEMPORARY TABLE entry_session
SELECT
	website_session_id,
    MIN(website_pageview_id) AS first_session
FROM website_pageviews
WHERE
	created_at < '2012-06-12'
GROUP BY
	website_session_id;

-- (2) Joining the Temporary Table to the "website_pageviews" to find entry sessions per landing page
SELECT
	website_pageviews.pageview_url AS landing_page,
    COUNT(DISTINCT entry_session.first_session) AS entry_volume
FROM entry_session
	LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = entry_session.first_session
GROUP BY
	landing_page
ORDER BY
	entry_volume DESC;
-- Spot On Solution!
