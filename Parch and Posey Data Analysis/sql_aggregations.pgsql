-- nulls and aggregations: nulls are not values, but properties of the data, 
-- so when checking if a value is null, use IS NULL and not = NULL

-- when counting the number of records in a column using the COUNT function, 
-- null values are not included

SELECT COUNT(*) accounts_count
FROM accounts;

SELECT COUNT(primary_poc) primary_poc_count
FROM accounts;

-- SUM: sum function treats nulls as zero
-- 1. Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) sum_poster_qty
FROM orders;

-- 2. Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) sum_standard_qty
FROM orders;

--3. Find the total dollar amount of sales using the total_amt_usd in the orders table
SELECT SUM(total_amt_usd) sum_total_amt_usd
FROM orders;

-- 4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the 
-- orders table. This should give a dollar amount for each order in the table.
SELECT (standard_amt_usd + gloss_amt_usd) total_gloss_and_standard_amt_usd
FROM orders;

-- 5. Find the standard_amt_usd per unit of standard_qty paper. 
--    Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) average_price_standard
FROM orders;


-- MIN AND MAX: also ignores nulls like SUM and COUNT
-- 1. When was the earliest order ever placed? You only need to return the date.
SELECT(MIN(occurred_at)) earliest_order_date
FROM orders;

-- 2. Try performing the same query as in question 1 without using an aggregation function.
SELECT(occurred_at) earliest_order_date
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- 3. When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) latest_web_event_time
FROM web_events;

-- 4. Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at latest_web_event_time
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- 5. Find the mean (AVERAGE) amount spent per order on each paper type, 
-- as well as the mean amount of each paper type purchased per order. 
-- Your final answer should have 6 values - one for each paper type for the average 
-- number of sales, as well as the average amount.
SELECT AVG(standard_amt_usd) avg_standard_usd, AVG(poster_amt_usd) avg_poster_usd, 
    AVG(gloss_amt_usd) avg_gloss_usd, AVG(standard_qty) avg_standard_qty, 
    AVG(poster_qty) avg_poster_qty, AVG(gloss_qty) avg_gloss_qty
FROM orders;

-- Via the video, you might be interested in how to calculate the MEDIAN. 
-- Though this is more advanced than what we have covered so far try finding - 
-- what is the MEDIAN total_usd spent on all orders?

SELECT * 
FROM (
    SELECT total_amt_usd
    FROM orders
    ORDER BY total_amt_usd 
    LIMIT 
        (SELECT COUNT(*)/2+1 FROM orders)
)AS median_table
ORDER BY total_amt_usd DESC
LIMIT 2
;



-- GROUP BY

-- 1. Which account (by name) placed the earliest order?
--  Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

-- 2. Find the total sales in usd for each account. You should include two columns -
--  the total sales for each company's orders in usd and the company name.

SELECT a.name company_name, SUM(o.total_amt_usd) total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


-- 3. Via what channel did the most recent (latest) web_event occur, 
-- which account was associated with this web_event? Your query should return 
-- only three values - the date, channel, and account name.
SELECT w.channel, w.occurred_at, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY occurred_at DESC
LIMIT 1;


-- 4. Find the total number of times each type of channel from the web_events was used. 
-- Your final table should have two columns - the channel and the number of times the 
-- channel was used.
SELECT channel, COUNT(channel) frequency
FROM web_events
GROUP BY channel;

-- 5. Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

-- 6. What was the smallest order placed by each account in terms of total usd. 
-- Provide only two columns - the account name and the total usd. Order from smallest 
-- dollar amounts to largest.

SELECT a.name, MIN(o.total_amt_usd) min_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2