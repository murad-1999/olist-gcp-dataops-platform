{{ config(
    materialized='table',
    cluster_by=["customer_unique_id"]
) }}

WITH customers AS (
    SELECT * FROM {{ ref('stg_olist_customers') }}
)

SELECT
    customer_unique_id,
    ANY_VALUE(customer_city) AS customer_city,
    ANY_VALUE(customer_state) AS customer_state,
    ANY_VALUE(customer_zip_code_prefix) AS customer_zip_code_prefix,
    COUNT(DISTINCT customer_id) AS total_orders
FROM customers
GROUP BY customer_unique_id
