{{ config(
    materialized='view'
) }}

WITH raw_customers AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_customers`
)

SELECT
    customer_id,
    customer_unique_id,
    CAST(customer_zip_code_prefix AS INT64) AS customer_zip_code_prefix,
    TRIM(customer_city) AS customer_city,
    UPPER(TRIM(customer_state)) AS customer_state
FROM raw_customers
WHERE customer_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_city) = 1
