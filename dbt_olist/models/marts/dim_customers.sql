{{ config(
    materialized='table',
    cluster_by=["customer_id"]
) }}

WITH customers AS (
    SELECT * FROM {{ ref('stg_olist_customers') }}
)

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM customers
