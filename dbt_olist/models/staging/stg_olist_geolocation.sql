{{ config(
    materialized='view'
) }}

WITH raw_geolocation AS (
    SELECT * FROM `{{ var('project_id', 'olist-dataops-73908') }}.olist_bronze.raw_geolocation`
)

SELECT
    CAST(geolocation_zip_code_prefix AS INT64) AS geolocation_zip_code_prefix,
    CAST(geolocation_lat AS FLOAT64) AS geolocation_lat,
    CAST(geolocation_lng AS FLOAT64) AS geolocation_lng,
    LOWER(TRIM(geolocation_city)) AS geolocation_city,
    UPPER(TRIM(geolocation_state)) AS geolocation_state
FROM raw_geolocation
WHERE geolocation_zip_code_prefix IS NOT NULL
