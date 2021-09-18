-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 8: Analyzing Business Patterns and Seasonality

-- Lessons 69 - 70: Analyzing Business Patterns

/* Assignment: We're considering adding live chat support to the website to improve
our customer experience. Could you analyze the average website session volume, by
hour and day and bay weekday, so taht we can staff appropriately.*/

SELECT
    hour,
    ROUND(AVG(CASE WHEN weekday = 0 THEN website_sessions ELSE NULL END), 1) AS monday,
    ROUND(AVG(CASE WHEN weekday = 1 THEN website_sessions ELSE NULL END), 1) AS tuesday,
    ROUND(AVG(CASE WHEN weekday = 2 THEN website_sessions ELSE NULL END), 1) AS wednesday,
    ROUND(AVG(CASE WHEN weekday = 3 THEN website_sessions ELSE NULL END), 1) AS thursday,
    ROUND(AVG(CASE WHEN weekday = 4 THEN website_sessions ELSE NULL END), 1) AS friday,
    ROUND(AVG(CASE WHEN weekday = 5 THEN website_sessions ELSE NULL END), 1) AS saturday,
    ROUND(AVG(CASE WHEN weekday = 6 THEN website_sessions ELSE NULL END), 1) AS sunday
FROM (
	SELECT
	    DATE(created_at) AS created_date,
	    WEEKDAY(created_at)	AS weekday,
	    HOUR(created_at) AS hour,
	    COUNT(DISTINCT website_session_id) AS website_sessions
	FROM website_sessions
	WHERE
	    created_at BETWEEN '2012-09-15' AND '2012-11-15'
	GROUP BY
		1, 2, 3
	) AS daily_hr_sessions
GROUP BY 1
ORDER BY 1;
