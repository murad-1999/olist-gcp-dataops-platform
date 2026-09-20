{{ config(
    materialized='table',
    partition_by={
      "field": "order_purchase_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    }
) }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_olist_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_olist_customers') }}
)

SELECT
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    o.order_purchase_timestamp,
    c.customer_city,
    c.customer_state
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
