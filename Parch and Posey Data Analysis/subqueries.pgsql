-- subqueries enable querying from the results of another query
-- this allows you build more transformations into your query, organize work more easily
-- and make your queries run faster.
-- also known as inner queries or nested queries

-- Example + quiz
SELECT channel, AVG(event_count) avg_event_count
FROM 
(SELECT DATE_TRUNC('Day', occurred_at) day_,
    channel, COUNT(*) event_count
    FROM web_events
GROUP BY 1, 2
ORDER BY 1) sub
GROUP BY 1
ORDER BY 2 DESC;
-- this query shows average number of events each day per channel
-- inner query provides the number of events each day per channel
-- outer query then averages these results to get the average number of events each day per channel
-- Inner query runs first. Once it's complete the outer query runs across the result 
-- set given by the inner query
-- you can select the inner query and run it separately to view the results and also debug errors

-- On which day-channel pair did the most events occur.
SELECT DATE_TRUNC('Day', occurred_at) day_,
    channel, COUNT(*) event_count
    FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC;

-- subquery formatting
-- best practice is to indent subquery within outer query to make it easier to read

-- more on subqueries
-- subqueries can be used in several places within a query
-- it can be used anywhere you'd use a table, a column name or even an individual value
-- they are especially useful in conditional logic - in conjunction with the WHERE or JOIN clauses or 
-- or in the WHEN portion of a CASE statement

-- Example: selecting orders that occurred in the first month of sales
SELECT * 
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
    (SELECT DATE_TRUNC('month', MIN(occurred_at))
    FROM orders)
ORDER BY occurred_at;
-- the subquery works with the WHERE logic because the inner query provides only one result
-- this is the case for all other logic functions, except IN, which can work with inner
-- queries that return more than one result
-- you should not include an alias when you include a subquery in a conditional statement since the 
-- subquery returns only one result, except subquery returns multiple result(when used with IN)

-- QUIZ
-- The average amount of standard paper sold on the first month that any order was placed 
-- in the orders table (in terms of quantity).
SELECT AVG(standard_qty) avg_std,
    AVG(gloss_qty) avg_gloss, AVG(poster_qty) avg_poster, SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
    (SELECT DATE_TRUNC('month', MIN(occurred_at))
    FROM orders);

-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT s.name sales_rep, r.name region, SUM(total_amt_usd) sales
    FROM sales_reps s
    JOIN region r
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 3 DESC;
-- this query gives names of sales reps, their region and the total amount sold

SELECT region, MAX(sales)
FROM (
    SELECT s.name sales_rep, r.name region, SUM(total_amt_usd) sales
    FROM sales_reps s
    JOIN region r
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ) sub
GROUP BY 1;
-- this query shows the largest amount of sales in each region

-- joining the two queries above will help identify the sales reps associated with these sales amounts
SELECT q1.sales_rep, q1.region, q1.sales
FROM (
    SELECT s.name sales_rep, r.name region, SUM(total_amt_usd) sales
    FROM sales_reps s
    JOIN region r
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
) q1
JOIN (
    SELECT region, MAX(sales) sales
    FROM (
        SELECT s.name sales_rep, r.name region, SUM(total_amt_usd) sales
        FROM sales_reps s
        JOIN region r
        ON r.id = s.region_id
        JOIN accounts a
        ON s.id = a.sales_rep_id
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1, 2
        ) sub
    GROUP BY 1) q2
ON q1.sales = q2.sales
ORDER BY sales DESC;

-- 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) 
-- orders were placed?

SELECT r.name region, COUNT(*) order_count, sum(total_amt_usd) total_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;

-- using a subquery
SELECT t1.region, t1.order_count, t1.total_sales
FROM (
    SELECT r.name region, COUNT(*) order_count, sum(total_amt_usd) total_sales
    FROM region r
    JOIN sales_reps s
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ) t1
JOIN(
    SELECT MAX(total_sales) max_sales
    FROM (
        SELECT r.name region, COUNT(*) order_count, sum(total_amt_usd) total_sales
        FROM region r
        JOIN sales_reps s
        ON r.id = s.region_id
        JOIN accounts a
        ON s.id = a.sales_rep_id
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1
        )sub
    )t2
ON t1.total_sales = t2.max_sales;

-- alternatively
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);


-- 3. How many accounts had more total purchases than the account name which has 
-- bought the most standard_qty paper throughout their lifetime as a customer?

-- first find account names and the amount of standard paper bought
SELECT a.name account_name, SUM(o.standard_qty) total_std_qty, SUM(total) total_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1;

-- then find max qty bought
SELECT SUM(o.standard_qty) total_std_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 1 DESC
LIMIT 1;

-- then count num of accounts from first query with total_std_qty > max
SELECT COUNT(*)
FROM (
    SELECT a.name account_name, SUM(o.standard_qty) total_std_qty, SUM(total) total_qty
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
) t1
WHERE t1.total_qty > (
    SELECT SUM(o.standard_qty) total_std_qty
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY 1 DESC
    LIMIT 1
    );

-- 4. For the customer that spent the most (in total over their lifetime as a customer) 
-- total_amt_usd, how many web_events did they have for each channel?

-- first find customer with highest total amount spent
SELECT a.name customer
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1;

-- then select the requires columns on the condition that the customer name 
-- meets the criteria in the above query
SELECT w.channel, COUNT(w.channel) num_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING a.name = (
    SELECT a.name customer
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY SUM(o.total_amt_usd) DESC
    LIMIT 1
);
-- note: you can use a column name in a groupby or order by without having to select it


-- 5. What is the lifetime average amount spent in terms of total_amt_usd 
-- for the top 10 total spending accounts?

-- first find top 10 spending accounts
SELECT a.name customer, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 10;

-- then find the average of the amounts they've spent
SELECT AVG(sub.total_spent) avg_lifetime_spend
FROM (
    SELECT a.name customer, SUM(o.total_amt_usd) total_spent
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    GROUP BY a.name
    ORDER BY SUM(o.total_amt_usd) DESC
    LIMIT 10
)sub;


-- 6. What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders.

-- first find avg amt spent on all orders
SELECT AVG(total_amt_usd) avg_spent_all
FROM orders;

-- then find companies that spent more than avg amount
SELECT a.name, AVG(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING AVG(o.total_amt_usd) > (
    SELECT AVG(total_amt_usd) avg_spent_all
    FROM orders
);
    

-- then find the average of what they spent

SELECT AVG(total_spent)
FROM (
    SELECT a.name, AVG(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.name
    HAVING AVG(o.total_amt_usd) > (
        SELECT AVG(total_amt_usd) avg_spent_all
        FROM orders
        )
)sub;

-- WITH: COMMON TABLE EXPRESSIONS(CTE)
-- The WITH statement is often called a CTE
-- It serves the exact purpose as subqueries, but are more common in practice
-- as they are cleaner and easier for a future reader to follow
-- CTEs work like functions in programming. At the top of your file, before you start
-- writing any queries, you can write all the inner queries you'll be using and name them 
-- with the WITH statement.
-- From there, if you need to use any of the inner queries in another query, you reference
-- them by the defined name
-- this makes it easier to read and follow through subqueries.

-- Example: You need to find the average number of events for each channel per day.
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;


-- QUIZZES
-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

WITH region_max_amt AS(
    SELECT r.name region, MAX(o.total_amt_usd) max_amt
    FROM sales_reps s
    JOIN region r
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY r.name)

SELECT s.name sales_rep, r_.region, r_.max_amt
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
JOIN region_max_amt r_
ON o.total_amt_usd = r_.max_amt;


-- For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH region_sales AS(
    SELECT r.name region, SUM(o.total_amt_usd) total_sales
    FROM region r
    JOIN sales_reps s
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY r.name
)

SELECT rs.region, COUNT(*)
FROM region_sales rs
JOIN region r
ON r.name = rs.region
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY rs.region
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1

