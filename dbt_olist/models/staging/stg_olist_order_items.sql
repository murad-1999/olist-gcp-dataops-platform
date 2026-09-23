{{ config(
    materialized='view'
) }}

WITH raw_order_items AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_order_items`
)

SELECT
    order_id,
    CAST(order_item_id AS INT64) AS order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
    CAST(price AS FLOAT64) AS price,
    CAST(freight_value AS FLOAT64) AS freight_value
FROM raw_order_items
WHERE order_id IS NOT NULL 
  AND order_item_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id, order_item_id ORDER BY shipping_limit_date DESC) = 1
