{{ config(
    materialized='view'
) }}

WITH raw_order_payments AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_order_payments`
)

SELECT
    order_id,
    CAST(payment_sequential AS INT64) AS payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    CAST(payment_installments AS INT64) AS payment_installments,
    CAST(payment_value AS FLOAT64) AS payment_value
FROM raw_order_payments
WHERE order_id IS NOT NULL
  AND payment_sequential IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id, payment_sequential ORDER BY payment_value DESC) = 1
