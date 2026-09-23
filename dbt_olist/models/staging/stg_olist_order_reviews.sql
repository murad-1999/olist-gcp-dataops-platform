{{ config(
    materialized='view'
) }}

WITH raw_order_reviews AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_order_reviews`
)

SELECT
    review_id,
    order_id,
    CAST(review_score AS INT64) AS review_score,
    TRIM(review_comment_title) AS review_comment_title,
    TRIM(review_comment_message) AS review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS review_creation_date,
    CAST(review_answer_timestamp AS TIMESTAMP) AS review_answer_timestamp
FROM raw_order_reviews
WHERE review_id IS NOT NULL
  AND order_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY review_id, order_id ORDER BY review_answer_timestamp DESC) = 1
