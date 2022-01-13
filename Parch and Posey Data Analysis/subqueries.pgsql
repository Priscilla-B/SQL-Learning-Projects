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
