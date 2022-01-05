# Parch and Posey Database Overview
The Parch and Posey Database is a hypothetical paper company's sales data of different types of paper(gloss, standard and poster). It has 5 tables:

1. accounts: contains information on various customer accounts such as their name, website, location, primary points of contact and assigned sales representative.
2. orders: contains information on all customer orders including the buyer, amount, date, quantity, etc
3. sales_reps: contains details on sales representatives such as their names and assigned regions
4. region: contains various sales regions
5. web_events: contains details on customer interaction with company website such as time, source, and channel of interacton.

## Entity Relationship Diagram for Database
![](imgs\erd.png)

- Columns which have the PK tag refers to columns being used as primary keys, which are unique identifiers for each row/record in the table.
- FK tags are for foreign keys which are primary keys in one table being referenced in other tables
- The lines connecting the tables in the ERD represent the one-to-many relationships that exist among the table records. The one side of the relationships are represented by the short vertical lines with the many side represented by the multiple diverging arrows(crow's foot).