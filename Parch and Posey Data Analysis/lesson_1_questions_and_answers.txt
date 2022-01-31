-- Lesson 1 Questions
-- 1. write a query that displays all the data in the occurred_at, account_id, 
-- and channel columns of the web_events table, and limits the output to only the first 15 rows.

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;


-- 2. Write a query to return the 10 earliest orders in the orders table. 
-- Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- 3. Write a query to return the top 5 orders in terms of largest total_amt_usd. 
-- Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- 4. Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. 
-- Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- 5. Write a query that displays the order ID, account ID, and total dollar amount for 
-- all the orders, sorted first by the account ID (in ascending order), and then by the 
-- total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- 6. Now write a query that again displays order ID, account ID, and total dollar amount 
-- for each order, but this time sorted first by total dollar amount (in descending order), 
-- and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- 7. Compare the results of these two queries above. 
-- How are the results different when you switch the column you sort on first?

-- 8. Pull the first 5 rows and all columns from the orders table that have a 
-- dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT * 
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- 9. Pulls the first 10 rows and all columns from the orders table that have a 
-- total_amt_usd less than 500.
SELECT * 
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

-- 10. Filter the accounts table to include the company name, website, and the primary 
-- point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-- 11. Create a column that divides the standard_amt_usd by the standard_qty to find the 
-- unit price for standard paper for each order. Limit the results to the first 10 orders, 
-- and include the id and account_id fields.
SELECT id order_id, account_id, 
    (standard_amt_usd/standard_qty) unit_price
FROM orders
LIMIT 10;


-- 12. Write a query that finds the percentage of revenue that comes from poster paper for
--  each order. You will need to use only the columns that end with _usd. 
-- (Try to do this without using the total column.) Display the id and account_id fields also


-- 13. Use the accounts table to find
-- All the companies whose names start with 'C'.
-- All companies whose names contain the string 'one' somewhere in the name.
-- All companies whose names end with 's'.

-- 14. Use the accounts table to find the account name, primary_poc, 
-- and sales_rep_id for Walmart, Target, and Nordstrom.

-- 15. Use the web_events table to find all information regarding individuals who
--  were contacted via the channel of organic or adwords.

-- 16. Use the accounts table to find the account name, primary poc, and 
-- sales rep id for all stores except Walmart, Target, and Nordstrom.

-- 17. Use the web_events table to find all information regarding individuals 
-- who were contacted via any method except using organic or adwords methods.

-- 18. Use the accounts table to find:
-- All the companies whose names do not start with 'C'.
-- All companies whose names do not contain the string 'one' somewhere in the name.
-- All companies whose names do not end with 's'.

-- 19. Write a query that returns all the orders where the standard_qty is over 1000, 
-- the poster_qty is 0, and the gloss_qty is 0.

-- 20. Using the accounts table, find all the companies whose names do not start 
-- with 'C' and end with 's'.

-- 21. When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, 
-- or not? Figure out the answer to this important question by writing a query that displays the 
-- order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
-- Then look at your output to see if the BETWEEN operator included the begin and end values or not.

-- 22. Use the web_events table to find all information regarding individuals who were contacted 
-- via the organic or adwords channels, and started their account at any point in 2016, sorted 
-- from newest to oldest.

-- 23. Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. 
-- Only include the id field in the resulting table.

-- 24. Write a query that returns a list of orders where the standard_qty is zero and either 
-- the gloss_qty or poster_qty is over 1000.

-- 25. Find all the company names that start with a 'C' or 'W', and the primary contact 
-- contains 'ana' or 'Ana', but it doesn't contain 'eana'.



