--                ************ BASIC SQL JOIN *******
/* Joins allows data to be queried from more than one table at a time within a SELECT statement. 
We use the ON clause with JOINs to specify the join condition, which is a logical statement to combine
results from multiple tables.
*/

-- select all columns from orders table
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- returns same result as SELECT * FROM orders in this instance since this is just a basic join
-- and no column from the second table was returned

-- select account name from accounts table,  and dates orders occured from orders table
-- it matches records in accounts table to records in orders table if the ids are equal
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- pulls all columns from orders table the all columns from accounts table 
-- while matching records in accounts table to records in orders table if the ids are equal
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- pull standard_qty, gloss_qty, and poster_qty from the orders table, 
-- and the website and the primary_poc from the accounts table
SELECT o.standard_qty, o.gloss_qty, o.poster_qty, a.website, a.primary_poc
FROM orders o
JOIN accounts a
ON o.account_id = a.id;
-- used o and a as aliases for orders and accounts table respectively. 
-- could have replaced "orders o" with "orders as o". same logic for "accounts a"


-- Provide a table for all web_events associated with account name of Walmart. 
-- There should be three columns. Be sure to include the primary_poc, time of the event, 
-- and the channel for each event. Additionally, you might choose to add a fourth column to 
-- assure only Walmart events were chosen.
SELECT a.primary_poc, w.occurred_at, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';


-- Provide a table that provides the region for each sales_rep along with their 
-- associated accounts. Your final table should include three columns: 
-- the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.


SELECT r.name region, a.name account, 
	(o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id;      

-- *** All the joins above have been inner joins, and return results that are common in the tables
--     that are being joined   ***

-- When joining tables, you can add a logic to the ON clause. This reduces the results of the joining
-- table, before the join is even made

SELECT *
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
WHERE a.sales_rep_id = 321500;
-- this filters the query after the join logic has executed. As a result returns only 
-- rows where sales_rep_id is 321500 


SELECT *
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
	AND a.sales_rep_id = 321500;
	
-- here, the filter logic was added to the ON clause. This filters the accounts table before 
-- executing the join logic. Since this is a left join, the query returns all rows where sales_rep_id is
-- 321500 and then returns all other rows from orders tables. the rows of the columns from the
-- accounts table which does not meet the logic are filled with null values 


-- 1.Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for the Midwest region. Your final table should include three columns: the region name,
-- the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name sales_rep, a.name account
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;


-- 2. Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for accounts where the sales rep has a first name starting with S and in the 
-- Midwest region. Your final table should include three columns: the region name, the sales rep name, 
-- and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name region, s.name sales_rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
	AND s.name LIKE 'S%'
ORDER BY a.name;


-- 3.Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for accounts where the sales rep has a last name starting with K and in the Midwest 
-- region. Your final table should include three columns: the region name, the sales rep name, and the
-- account name. Sort the accounts alphabetically (A-Z) according to account name

SELECT r.name region, s.name sales_rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
	AND s.name LIKE  '% K%' -- this only works because this database records only first and last names for sales reps
ORDER BY a.name;

-- 4. Provide the name for each region for every order, as well as the account name and the unit price 
-- they paid (total_amt_usd/total) for the order. However, you should only provide the results if the 
-- standard order quantity exceeds 100. Your final table should have 3 columns: region name, 
-- account name, and unit price.

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100;


-- 5. Provide the name for each region for every order, as well as the account name and the unit price
-- they paid (total_amt_usd/total) for the order. However, you should only provide the results if the 
-- standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table 
-- should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first.
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100
	AND o.poster_qty > 50
ORDER BY 3;


-- 6. Provide the name for each region for every order, as well as the account name and the unit price 
-- they paid (total_amt_usd/total) for the order. However, you should only provide the results if the 
-- standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should 
-- have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful
-- (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100
	AND o.poster_qty > 50
ORDER BY 3 DESC;

-- What are the different channels used by account id 1001? Your final table should 
-- have only 2 columns: account name and the different channels. You can try SELECT DISTINCT 
-- to narrow down the results to only the unique values.

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;


-- Find all the orders that occurred in 2015. Your final table should have 4 columns: 
-- occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY 1 DESC
