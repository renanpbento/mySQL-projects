-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 7: Analysis for Channel Portfolio Management

-- Lessons 54 - 56: Analyzing Channel Portfolios
/* Analyzing a portfolio of marketing channels is about bidding efficiently and 
using data to maximize the effectiveness of your marketing budget.

Assignment: With gsearch doing well and the site performing better, we launched a
second paid search channel, bsearch, around Aug-22.
Can you pull weekly trended sessions volume since then and compare to gsearch nonbrand
so I can get a sense for how important this will be for the business?*/

-- Solution


SELECT
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100),2) AS gsearch_share,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions,
    ROUND((COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) * 100),2) AS bsearch_share,
    ROUND(COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END),0) AS gsearch_bsearch_ratio
FROM website_sessions
WHERE
    created_at BETWEEN '2012-08-23' AND '2012-11-28'
    AND utm_campaign = 'nonbrand'
GROUP BY
    YEARWEEK(created_at);

/* Analyzing the data, bsearch can be considered a relevant channel as it gets roughly 
a third of gsearch traffic and approximately 25% of total sessions. There is no sign of
a weekly rampant growth rate in bsearch, but it is important to keep an eye on this channel.*/
	
