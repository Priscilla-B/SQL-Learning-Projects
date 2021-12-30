--                ************ BASIC SQL JOIN *******
/*
Joins allows data to be queried from more than one table at a time within a SELECT statement. 
We use the ON clause with JOINs to specify the join condition, which is a logical statement to combine
results from multiple tables.
*/

-- select all columns from orders table
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
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

