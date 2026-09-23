{{ config(
    materialized='view'
) }}

WITH raw_products AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_products`
)

SELECT
    product_id,
    TRIM(product_category_name) AS product_category_name,
    CAST(product_name_lenght AS INT64) AS product_name_length,
    CAST(product_description_lenght AS INT64) AS product_description_length,
    CAST(product_photos_qty AS INT64) AS product_photos_quantity,
    CAST(product_weight_g AS INT64) AS product_weight_g,
    CAST(product_length_cm AS INT64) AS product_length_cm,
    CAST(product_height_cm AS INT64) AS product_height_cm,
    CAST(product_width_cm AS INT64) AS product_width_cm
FROM raw_products
WHERE product_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_name_length DESC) = 1
