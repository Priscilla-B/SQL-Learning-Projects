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
    FROM orders)

