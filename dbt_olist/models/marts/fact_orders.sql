{{ config(
    materialized='table',
    partition_by={
      "field": "order_purchase_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["customer_id"]
) }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_olist_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_olist_customers') }}
),

order_items_agg AS (
    SELECT
        order_id,
        COUNT(order_item_id) AS total_items,
        COUNT(DISTINCT seller_id) AS total_sellers,
        ROUND(SUM(price), 2) AS total_order_items_value,
        ROUND(SUM(freight_value), 2) AS total_freight_value
    FROM {{ ref('stg_olist_order_items') }}
    GROUP BY order_id
),

order_payments_agg AS (
    SELECT
        order_id,
        ROUND(SUM(payment_value), 2) AS total_payment_value,
        MAX(payment_installments) AS max_payment_installments
    FROM {{ ref('stg_olist_order_payments') }}
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    COALESCE(i.total_items, 0) AS total_items,
    COALESCE(i.total_sellers, 0) AS total_sellers,
    COALESCE(i.total_order_items_value, 0.0) AS total_order_items_value,
    COALESCE(i.total_freight_value, 0.0) AS total_freight_value,
    COALESCE(p.total_payment_value, 0.0) AS total_payment_value,
    COALESCE(p.max_payment_installments, 1) AS max_payment_installments
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items_agg i ON o.order_id = i.order_id
LEFT JOIN order_payments_agg p ON o.order_id = p.order_id
