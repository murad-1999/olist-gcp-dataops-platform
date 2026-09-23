{{ config(
    materialized='view'
) }}

WITH raw_translation AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_product_category_name_translation`
)

SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english
FROM raw_translation
WHERE product_category_name IS NOT NULL
