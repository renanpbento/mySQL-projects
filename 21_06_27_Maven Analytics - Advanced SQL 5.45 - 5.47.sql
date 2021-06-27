-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 5: Analyzing Website Performance (Lesson 45 - 47)

-- Assignment: Building Conversion Funnels
/* I'd like to understand where we lose our gsearch visitors between the new/lander-1
page and placing an order. Can you build us a full conversion funnel, analyzing how many
customers make it to each step?
Start with /lander-1 and build the funnel all the way to our thank you page. Please use
data since 08-05.*/

-- 1) Identifying the relevant sessions for the funnel analysis
SELECT
	pageview_url
FROM website_pageviews
GROUP BY
pageview_url;
-- Pages to be used in the analysis: /products, /the-original-mr-fuzzy, /cart, /shipping, /billing, /thank-you-for-your-order.

-- 2) Identifying each page as the specific funnel step (This going to be a subquery further ahead)
SELECT
	ws.website_session_id,
    wp.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
	CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
	CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_pageviews wp
LEFT JOIN website_sessions ws
	ON wp.website_session_id = ws.website_session_id
WHERE
	ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
    AND ws.created_at > '2012-08-05' 
    AND ws.created_at < '2012-09-05'
ORDER BY
	ws.website_session_id,
    wp.created_at;

-- 3) Assessing how far a client went in the conversion funnel (Temporary table creatd from this query)
CREATE TEMPORARY TABLE session_level_made_it
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
	MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it 
FROM(SELECT
		ws.website_session_id,
		wp.pageview_url,
		CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
		CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
		CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
		CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
		CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
		CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
	FROM website_pageviews wp
	LEFT JOIN website_sessions ws
		ON wp.website_session_id = ws.website_session_id
	WHERE
		ws.utm_source = 'gsearch'
		AND ws.utm_campaign = 'nonbrand'
		AND ws.created_at > '2012-08-05' 
		AND ws.created_at < '2012-09-05'
	ORDER BY
		ws.website_session_id,
		wp.created_at
) AS pageview_level
GROUP BY 
	website_session_id;

-- 4) Calculating conversion rates in the funnel
SELECT
	ROUND(COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT website_session_id) * 100,2) AS to_products,
	ROUND(COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) * 100,2) AS to_mrfuzzy,    
	ROUND(COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) * 100,2) AS to_cart,
	ROUND(COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) * 100,2) AS to_shipping,
	ROUND(COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) * 100,2) AS to_billing,    
	ROUND(COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) * 100,2) AS to_thankyou
FROM session_level_made_it;