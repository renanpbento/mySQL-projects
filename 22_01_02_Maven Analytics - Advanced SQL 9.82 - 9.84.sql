-- Maven Analytics - Advanced SQL: MySQL Data Analysis & Business Intelligence

SET GLOBAL max_allowed_packet=16M;

USE mavenfuzzyfactory;

-- Section 9: Product Analysis

-- Lessons 82 - 84: Corss-Selling Analysis

/* Assignment: Could you please compare the month before vs the month after the change?
I'd like to see CTR from the/cart page, Avg Prod per Oder, AOV and overall revenue per/cart page view.*/

CREATE TEMPORARY TABLE sessions_cart
SELECT
   CASE
	WHEN created_at < '2013-09-25' THEN 'A. Pre_Cross_Sell'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Cross_Sell'
        ELSE 'Error'
    END AS time_period,
    website_session_id AS cart_session_id,
    website_pageview_id AS cart_pageview_id
FROM 
    website_pageviews
WHERE
    created_at BETWEEN '2013-08-25' AND '2013-10-25'
    AND pageview_url = '/cart';

CREATE TEMPORARY TABLE cart_another_page
SELECT
    sessions_cart.time_period,
    sessions_cart.cart_session_id,
    MIN(website_pageviews.website_pageview_id) AS pv_cart
FROM 
    sessions_cart
LEFT JOIN 
    website_pageviews 
    ON website_pageviews.website_session_id = sessions_cart.cart_session_id
    AND website_pageviews.website_pageview_id > sessions_cart.cart_pageview_id
GROUP BY
    sessions_cart.time_period,
    sessions_cart.cart_session_id
HAVING
    MIN(website_pageviews.website_pageview_id) IS NOT NULL;


CREATE TEMPORARY TABLE pre_post_orders
SELECT
    time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
FROM 
    sessions_cart
INNER JOIN orders
    ON sessions_cart.cart_session_id = orders.website_session_id;
    
SELECT
    time_period,
    COUNT(DISTINCT cart_session_id) AS cart_sessions,
    SUM(clicked_another_page) AS clickthroughs,
    SUM(clicked_another_page)/COUNT(DISTINCT cart_session_id) AS cart_ctr,
    SUM(placed_order) AS orders_placed,
    SUM(items_purchased) AS prod_purchased,
    SUM(items_purchased)/SUM(placed_order) AS prod_per_order,
    SUM(price_usd) AS revenue,
    SUM(price_usd)/SUM(placed_order) AS aov,
    SUM(price_usd)/COUNT(DISTINCT cart_session_id) AS rev_cart_session
FROM(
	SELECT
	    sessions_cart.time_period,
	    sessions_cart.cart_session_id,
	    CASE 
	        WHEN cart_another_page IS NULL THEN 0 ELSE 1 END AS clicked_another_page,
	    CASE 
	        WHEN pre_post_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
	    pre_post_orders.items_purchased,
	    pre_post_orders.price_usd
	FROM 
	    sessions_cart
	LEFT JOIN cart_another_page
	    ON sessions_cart.cart_session_id = cart_another_page.cart_session_id
	LEFT JOIN pre_post_orders
	    ON sessions_cart.cart_session_id = pre_post_orders.cart_session_id
	ORDER BY
	    cart_session_id
) AS full_data
GROUP BY
    1;
