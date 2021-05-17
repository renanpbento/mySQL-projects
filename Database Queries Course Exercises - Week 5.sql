-- Introduction to Database Queries (Week 5)

-- Lab 1: Write an INSERT statement that adds the row "category_name: Brass" to the Categories table:
INSERT 
	INTO categories 
    (category_name)
	VALUES('Brass');
    
-- Checking the answer
SELECT *
FROM categories;

-- Lab 2: Write an UPDATE statement that modifies the drums category in the Categories table. This statement should change the category_name column to “Woodwinds”, and it should use the category_id to identify the row.
UPDATE categories
	SET category_name = 'Woodwinds'
	WHERE category_id = 3;
    
-- Checking the answer
SELECT *
FROM categories;

-- Lab 3: Write a DELETE statement that deletes the Keyboards category in the Categories table. This statement should use the category_id column to identify the row.
DELETE 
	FROM categories
	WHERE category_id = 4;
    
-- Checking the answer
SELECT *
FROM categories;

-- Lab 4: Write an INSERT statement that adds this row to the Products table...
INSERT 
	INTO products 
    (product_id,
    category_id,
    product_code,
    product_name,
    description,
    list_price,
    discount_percent,
    date_added)
	VALUES 
    (DEFAULT,
    4,
    'dgx_640',
    'Yamaha DGX 640 88-Key Digital Piano',
    'Long description to come',
    '799.99',
    '0',
    NOW());
    
-- Checking the answer
SELECT *
FROM products;

-- Lab 5: Write an UPDATE statement that modifies the 'Fender Stratocaster' product. This statement should change the discount_percent column from 30% to 35%.
UPDATE products
	SET discount_percent = 35.00
	WHERE product_id = 1;
    
-- Checking the answer
SELECT *
FROM products;

-- Lab 6: Write an INSERT statement that adds this row to the Customers table...
INSERT 
	INTO customers 
    (email_address,
    password,
    first_name,
    last_name)
	VALUES 
    ('rick@raven.com',
    ' ',
    'Rick',
    'Raven');
    
-- Checking the answer
SELECT *
FROM customers;

-- Lab 7: Write an UPDATE statement that modifies the Customers table. Change the first_name column to “Al” for the customer with an email address of 'allan.sherwood@yahoo.com'
UPDATE customers
	SET first_name = 'Al'
	WHERE customer_id = 1;
    
-- Checking the answer
SELECT *
FROM customers;
