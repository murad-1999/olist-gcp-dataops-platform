{{ config(
    materialized='view'
) }}

WITH raw_sellers AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_sellers`
)

SELECT
    seller_id,
    CAST(seller_zip_code_prefix AS INT64) AS seller_zip_code_prefix,
    LOWER(TRIM(seller_city)) AS seller_city,
    UPPER(TRIM(seller_state)) AS seller_state
FROM raw_sellers
WHERE seller_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY seller_city) = 1
