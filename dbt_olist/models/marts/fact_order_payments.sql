{{ config(
    materialized='table',
    partition_by={
      "field": "order_purchase_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["order_id"]
) }}

WITH payments AS (
    SELECT * FROM {{ ref('stg_olist_order_payments') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp
    FROM {{ ref('stg_olist_orders') }}
)

SELECT
    CONCAT(p.order_id, '_', CAST(p.payment_sequential AS STRING)) AS payment_id,
    p.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM payments p
INNER JOIN orders o ON p.order_id = o.order_id
