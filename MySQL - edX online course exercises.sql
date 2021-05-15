-- edX Course: Database Queries
use my_guitar_shop;

-- Week 3 - Lab 1
SELECT
    product_code,
    product_name,
    list_price,
    discount_percent
FROM products
    ORDER BY list_price DESC;

-- Week 3 - Lab 2
SELECT
    first_name,
    last_name,
    CONCAT(last_name, ',', ' ', first_name) AS full_name
FROM customers
    WHERE last_name >= 'M%'
    ORDER BY last_name ASC;

-- Week 3 - Lab 3
SELECT
    product_name,
    list_price,
    date_added
FROM products
    WHERE list_price > 500 AND list_price < 2000
    ORDER BY date_added DESC;
    
-- Week 3 - Lab 4
SELECT
    product_name,
    list_price,
    discount_percent,
    ROUND(list_price * (discount_percent/100),2) AS discount_amount,
    ROUND(list_price*(1 - discount_percent/100),2) AS discount_price
FROM products
    ORDER BY discount_price DESC
LIMIT 5;

-- Week 3 - Lab 5
SELECT
    item_id,
    item_price,
    discount_amount,
    quantity,
    (quantity * item_price) AS price_total,
    (discount_amount * quantity) AS discount_total,
    (quantity * (item_price - discount_amount)) AS item_total
FROM order_items
    WHERE (quantity * (item_price - discount_amount)) > 500
    ORDER BY (quantity * (item_price - discount_amount)) DESC;
    
-- Week 3 - Lab 6
SELECT
    order_id,
    order_date,
    ship_date
FROM orders
    WHERE ship_date IS NULL
    ORDER BY order_id DESC;

-- Week 3 - Lab 7
SELECT 
    100 AS price,
    0.07 AS tax_rate,
    100 * 0.07 AS tax_amount,
    100 + 0.07 * 100 AS total;
    
-- ---------------------------------
-- Week 4 - Lab 1
SELECT
    category_name,
    product_name,
    list_price
FROM categories
    LEFT JOIN products ON categories.category_id = products.category_id
    ORDER BY category_name, product_name ASC;

-- Week 4 - Lab 2
SELECT
    first_name,
    last_name,
    line1,
    city,
    state,
    zip_code
FROM customers
    LEFT JOIN addresses ON customers.customer_id = addresses.customer_id
    ORDER BY zip_code ASC;
	
-- Week 4 - Lab 3
SELECT
    first_name,
    last_name,
    line1,
    city,
    state,
    zip_code
FROM customers
    LEFT JOIN addresses ON customers.customer_id = addresses.customer_id
    WHERE address_id = shipping_address_id
    ORDER BY zip_code ASC;

-- Week 4 - Lab 4
SELECT
    last_name,
    first_name,
    order_date,
    product_name,
    item_price,
    discount_amount,
    quantity
FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id
    LEFT JOIN order_items ON orders.order_id = order_items.order_id
    LEFT JOIN products ON order_items.product_id = products.product_id
    WHERE product_name IS NOT NULL
    ORDER BY last_name, order_date, product_name;
    
-- Week 4 - Lab 5
SELECT
    order_id,
    order_date,
CASE
    WHEN ship_date IS NULL THEN 'NOT SHIPPED'
    ELSE 'SHIPPED'
END AS ship_status
FROM orders
ORDER BY order_date;
