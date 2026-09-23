{{ config(
    materialized='table',
    cluster_by=["geolocation_zip_code_prefix"]
) }}

WITH raw_geo AS (
    SELECT * FROM {{ ref('stg_olist_geolocation') }}
)

SELECT
    geolocation_zip_code_prefix,
    ROUND(AVG(geolocation_lat), 6) AS geolocation_lat,
    ROUND(AVG(geolocation_lng), 6) AS geolocation_lng,
    ANY_VALUE(geolocation_city) AS geolocation_city,
    ANY_VALUE(geolocation_state) AS geolocation_state
FROM raw_geo
GROUP BY geolocation_zip_code_prefix
