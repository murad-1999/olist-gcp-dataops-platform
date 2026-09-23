{{ config(
    materialized='table',
    partition_by={
      "field": "order_purchase_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["order_id"]
) }}

WITH reviews AS (
    SELECT * FROM {{ ref('stg_olist_order_reviews') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp
    FROM {{ ref('stg_olist_orders') }}
)

SELECT
    CONCAT(r.review_id, '_', r.order_id) AS review_order_id,
    r.review_id,
    r.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp
FROM reviews r
INNER JOIN orders o ON r.order_id = o.order_id
