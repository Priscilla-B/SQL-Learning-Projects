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
ORDER BY 2;


-- ** GROUP BY and ORDER BY can be used with multiple columns in the same query
-- the order in the ORDER BY and GROUP BY determines which columns are ordered
-- or grouped first. You can order DESC for any column in your ORDER BY


-- **QUESTIONS: GROUP BY PART 2 ** 

-- 1. For each account, determine the average amount of each type of paper they 
-- purchased across their orders. Your result should have four columns - one for the 
-- account name and one for the average quantity purchased for each of the paper 
-- types for each account.

SELECT a.name account_name, AVG(o.standard_qty) avg_standard_qty, 
    AVG(o.poster_qty) avg_poster_qty, AVG(o.gloss_qty) avg_gloss_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- 2. For each account, determine the average amount spent per order on each paper type. 
-- Your result should have four columns - one for the account name and one for the average 
-- amount spent on each paper type.

SELECT a.name account_name, AVG(o.standard_amt_usd) avg_standard_amt, 
    AVG(o.poster_amt_usd) avg_poster_amt, AVG(o.gloss_amt_usd) avg_gloss_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- 3. Determine the number of times a particular channel was used in the web_events table 
-- for each sales rep. Your final table should have three columns - the name of the sales rep, 
-- the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT s.name sales_rep, w.channel, COUNT(channel) as no_occurrences
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY s.name, w.channel
ORDER BY 3 DESC;

-- 4. Determine the number of times a particular channel was used in the web_events 
-- table for each region. Your final table should have three columns - the region name, 
-- the channel, and the number of occurrences. Order your table with the highest number 
-- of occurrences first.

SELECT r.name region, w.channel, COUNT(w.channel) num_occurences
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1, 2
ORDER BY 3 DESC;


-- DISTINCT
-- QUESTIONS
-- 1. Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT r.name region, a.name account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT r.name region, a.name account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;
-- both queries return same number of results. hence no accounts are
-- associated with more than one region

-- 2. have any sales reps worked on more than one account?
SELECT s.name sales_rep, a.name accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id;
-- returns 351 rows

SELECT DISTINCT s.id,  s.name
FROM sales_reps s;
-- returns 50 rows



-- HAVING: used to filter on agregate columns in place of the WHERE clause

-- QUESTIONS
-- 1. How many of the sales reps have more than 5 accounts that they manage?
SELECT COUNT(*)
FROM (
    SELECT s.id sales_rep, COUNT(a.name) num_accounts
    FROM sales_reps s
    JOIN accounts a
    ON s.id = a.sales_rep_id
    GROUP BY s.id
    HAVING COUNT(a.name) > 5
) sales_rep_accounts;

-- 2. How many accounts have more than 20 orders?

SELECT COUNT(*)
FROM (
    SELECT a.id account, COUNT(o.id) num_orders
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id
    HAVING COUNT(o.id) > 20
) accounts_orders;

-- 3. Which account has the most orders?

SELECT a.name account, COUNT(o.id) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2 DESC
LIMIT 1;

-- 4. How many accounts spent more than 30,000 usd total across all orders?

SELECT COUNT(*)
FROM (
    SELECT a.id account, SUM(total_amt_usd) sum_order_amt
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id
    HAVING SUM(total_amt_usd) > 30000
) account_orders;

-- 5. How many accounts spent less than 1,000 usd total across all orders?

SELECT COUNT(*)
FROM (
    SELECT a.id account, SUM(total_amt_usd) sum_order_amt
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id
    HAVING SUM(total_amt_usd) < 1000
) account_orders;

-- 6. Which account has spent the most with us?
SELECT a.id, a.name account, SUM(total_amt_usd) sum_order_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id
ORDER BY 3 DESC
LIMIT 1;

-- 7. Which account has spent the least with us?
SELECT a.id, a.name account, SUM(total_amt_usd) sum_order_amt
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id
ORDER BY 3 
LIMIT 1;

-- 8. Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT COUNT(*)
FROM(
    SELECT a.id, a.name, COUNT(w.channel)
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    WHERE w.channel = 'facebook'
    GROUP BY a.id
    HAVING COUNT(w.channel) > 6
) accounts_channels;

-- 9. Which account used facebook most as a channel?
SELECT a.id, a.name, COUNT(w.channel) num_channel_usage
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id
ORDER BY COUNT(w.channel) DESC
LIMIT 1;

-- 10. Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(w.channel) num_channel_usage
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, w.channel
ORDER BY COUNT(w.channel) DESC
LIMIT 10; -- all top 10 are direct channels


-- DATE FUNCTIONS
-- grouping by dates in sql is not always very helpful as dates are usually
-- stored to a very granular level(as low as miliseconds)
-- databases usually store dates from the least granular to most granular part of the
-- date: YYYY MM DD. It makes sure ordering is the same if their ordered as dates(in 
-- chronological order) or as text(in alphabetical order)
-- date functions helps to groupby dates by enabling us to truncate or select parts
-- of a date for our analysis
-- the DATE_TRUNC function helps us to truncate a date to a given date part

SELECT DATE_TRUNC('day', occurred_at), SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY 1
ORDER BY 1;

-- this truncates dates to day by setting time to 00:00:00 for each date
-- 1 here represents the date_trunc column since it's the first column in the select statement

-- use DATE_PART to pull out a given part of a date
SELECT DATE_PART('dow', occurred_at) AS day_of_week,
    SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- this show how many quantities were ordered at each day of the week
-- dow stands for day of week


-- QUESTIONS
-- 1. Find the sales in terms of total dollars for all orders in each year, ordered 
-- from greatest to least. Do you notice any trends in the yearly sales totals?
-- Are all months evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at)  year_of_sale,
    SUM(total_amt_usd) total_sales_amt
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- sales generally increased as years increased

-- checking how many months of sales are present in each year
SELECT DATE_PART('year', occurred_at) sale_year, 
    DATE_PART('month', occurred_at) sale_month
FROM orders
GROUP BY 1, 2
ORDER BY 1;
-- each year has 12 months of sales except 2013 and 2017 which have one month of sale each


-- 2. Which month did Parch & Posey have the greatest sales in terms of 
-- total dollars? 
SELECT DATE_PART('month', occurred_at) month_of_sale,
    SUM(total_amt_usd) total_sales_amount
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- December is the month with the highest sales
-- not all months are equally represented in dataset. December has more orders

-- 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
-- Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) year_of_sale,
    COUNT(*) num_of_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 4. Which month did Parch & Posey have the greatest sales in terms of total 
-- number of orders? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) month_of_sale,
    COUNT(*) num_of_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 5. In which month of which year did Walmart spend the most on 
-- gloss paper in terms of dollars?
SELECT DATE_PART('year', o.occurred_at) year_of_sale, 
    DATE_PART('month', o.occurred_at) month_of_sale,
    SUM(o.gloss_amt_usd) sum_gloss_amt
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;
-- may 2016



-- CASE STATEMENTS
-- the CASE statement always goes in the SELECT clause
-- case must include the following statements: WHEN, THEN, and END. 
-- there's an optional ELSE statement at the end that catches("takes care of") any other
-- conditions that were not met in the previous CASES
-- CASE statements must finish with the word END
-- between the WHEN and THEN statements, you can make any conditional statement using
-- any conditional operators like WHERE and can string multiple conditions together using
-- AND and OR. can include multiple WHEN and ELSE


-- EXAMPLE
SELECT  id, account_id, occurred_at, channel,
    CASE WHEN channel = 'facebook'  OR channel = 'direct' THEN 'yes' ELSE 'no' END AS is_facebook_or_direct
FROM web_events
ORDER BY occurred_at;
-- returns yes if a channel  is facebook or direct. otherwise, return no

SELECT account_id, occurred_at, total, 
    CASE WHEN total > 500 THEN 'Over 500'
         WHEN total > 300 THEN '300 - 500'
         WHEN total > 100 THEN '100 - 300'
         ELSE '100 or under' END total_group
FROM orders;

-- You can use CASE statements to catch zero division errors
SELECT account_id, 
    CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
    ELSE standard_amt_usd/standard_qty END unit_price
FROM orders;


-- CASE and aggregations
-- group the results of a case statement with an aggregation
SELECT CASE WHEN total > 500 THEN 'Over 500'
            ELSE '500 or under' END total_group,
        COUNT(*) num_of_orders
FROM orders
GROUP BY 1;



-- QUESTIONS

-- 1. Write a query to display for each order, the account ID, total amount of the order, 
-- and the level of the order - ???Large??? or ???Small??? - depending on if the order is $3000 or more, 
-- or smaller than $3000.
SELECT account_id, total_amt_usd, 
    CASE WHEN total_amt_usd >= 3000 THEN 'Large'
         ELSE 'Small' END order_size
FROM orders;

-- 2. Write a query to display the number of orders in each of three categories, based on the 
-- total number of items in each order. The three categories are: 'At Least 2000', 'Between 
-- 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >= 2000 THEN 'At least 2000'
            WHEN total >= 1000 THEN 'Between 1000 and 2000'
            ELSE 'Less than 1000' END quantity_level,
        COUNT(*)
FROM orders
GROUP BY 1;

-- 3. We would like to understand 3 different branches of customers based on the amount 
-- associated with their purchases. The top branch includes anyone with a Lifetime Value 
-- (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 
-- and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that 
-- includes the level associated with each account. You should provide the account name, 
-- the total sales of all orders for the customer, and the level. Order with the top 
-- spending customers listed first.

SELECT account, total_order_amt, 
    CASE WHEN total_order_amt > 200000 THEN 'top branch'
         WHEN total_order_amt >= 100000 THEN 'middle branch'
         ELSE 'lowest branch' END customer_branches
FROM(
    SELECT a.name account, SUM(o.total_amt_usd) total_order_amt
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC) customer_order_amt;

-- alternative solution
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

-- 4. We would now like to perform a similar calculation to the first, but we want to obtain the 
-- total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous 
-- question. Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY a.name
ORDER BY 2 DESC;


-- 5. We would like to identify top performing sales reps, which are sales reps associated with more
-- than 200 orders. Create a table with the sales rep name, the total number of orders, and a column 
-- with top or not depending on if they have more than 200 orders. Place the top sales people first in 
-- your final table.
SELECT s.name sales_rep, COUNT(*) num_orders,
    CASE WHEN COUNT(*) > 200 THEN 'top'
         ELSE 'not' END sales_rep_category
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


-- 6. The previous didn't account for the middle, nor the dollar amount associated with the sales. 
-- Management decides they want to see these characteristics represented as well. We would like to 
-- identify top performing sales reps, which are sales reps associated with more than 200 orders or 
-- more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 
-- in sales. Create a table with the sales rep name, the total number of orders, total sales across 
-- all orders, and a column with top, middle, or low depending on this criteria. Place the top sales
-- people based on dollar amount of sales first in your final table.
SELECT s.name sales_rep, COUNT(*) num_orders, SUM(total_amt_usd) total_sales_amt,
    CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top'
         WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle'
         ELSE 'not' END sales_rep_category
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;









