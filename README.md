SQL Retail Project:

A PostgreSQL retail database built to answer business questions with SQL

Tech stack:

- PostgreSQL 16
- Python (Faker, faker_commerce),
- git.

Schema:

There are several considerations that went into creating this schema when designing it, for example:

- The data is naturally related: Customers place orders, products belong to orders, orders shipped to addresses, products belong to categories. This type of data lends itself to being using in a relational database, where tables and joins go smoothly together
- Integrity is enforced by the rules of the database itself: keys and constraints prevent orphaned orders, invalid inputs or duplicated customers/orders
- SQL is an ideal tool for this analysis: The language's ability to use join, window functions and aggregations all help to answer this project’s business questions
- The project reflects real working environments: retail and e-commerce systems typically run on relational databases; this project is reflective of those requirements.
