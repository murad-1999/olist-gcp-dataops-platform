{{ config(
    materialized='table'
) }}

WITH customers AS (
    SELECT * FROM {{ ref('stg_olist_customers') }}
)

SELECT
    customer_unique_id,
    MAX(customer_city) AS primary_city,
    MAX(customer_state) AS primary_state,
    COUNT(DISTINCT customer_id) AS total_orders
FROM customers
GROUP BY 1
