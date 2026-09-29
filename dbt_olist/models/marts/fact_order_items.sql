{{ config(
    materialized='table',
    partition_by={
      "field": "order_purchase_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["product_id", "seller_id"]
) }}

WITH items AS (
    SELECT * FROM {{ ref('stg_olist_order_items') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    FROM {{ ref('stg_olist_orders') }}
)

SELECT
    CONCAT(i.order_id, '_', CAST(i.order_item_id AS STRING)) AS order_item_key,
    i.order_id,
    i.order_item_id AS order_item_sequence,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_status,
    i.product_id,
    i.seller_id,
    i.shipping_limit_date,
    i.price,
    i.freight_value,
    ROUND(i.price + i.freight_value, 2) AS total_item_value
FROM items i
INNER JOIN orders o ON i.order_id = o.order_id
