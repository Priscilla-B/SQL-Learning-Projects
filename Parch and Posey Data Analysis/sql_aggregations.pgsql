-- nulls and aggregations: nulls are not values, but properties of the data, 
-- so when checking if a value is null, use IS NULL and not = NULL

-- when counting the number of records in a column using the COUNT function, 
-- null values are not included

SELECT COUNT(*) accounts_count
FROM accounts;

SELECT COUNT(primary_poc) primary_poc_count
FROM accounts