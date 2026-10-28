# Pizza Runner --- SQL Portfolio Project

## Project Overview

This project uses the Pizza Runner dataset from the 8 Week SQL Challenge
to practise data cleaning and analysis with PostgreSQL. The dataset
represents a pizza delivery business and includes information about
customer orders, runners, pizza types, recipes, and toppings.

## Dataset

The project uses these tables:

-   `customer_orders` --- customer orders, including pizza selections,
    exclusions, and extras.
-   `runner_orders` --- runner assignments and delivery details,
    including pickup time, distance, duration, and cancellation
    information.
-   `pizza_names` --- pizza type names.
-   `pizza_recipes` --- standard topping IDs associated with each pizza
    type.
-   `pizza_toppings` --- topping IDs and their names.

## Data Cleaning

### `runner_orders`

-   Checked `order_id` and `runner_id`; both were already stored as
    integer values and did not require type changes.
-   Converted text values of `'null'` to actual SQL `NULL` values where
    applicable.
-   Converted `pickup_time` from text to a timestamp data type.
-   Removed text units from `distance`, renamed the column to
    `distance_km`, and converted it to `NUMERIC`.
-   Removed text units such as `minutes` or `mins` from `duration`,
    renamed the column to `duration_mins`, and converted it to
    `INTEGER`.
-   Converted blank strings and text values of `'null'` in
    `cancellation` to SQL `NULL`.

### `customer_orders`

-   Converted text values of `'null'` in `exclusions` and `extras` to
    actual SQL `NULL` values.

## Tools

-   PostgreSQL
-   SQL
