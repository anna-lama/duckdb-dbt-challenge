{{ config(materialized='view') }}

WITH valid_trips AS (
    {{filter_valid_trips('stg_yellow_tripdata')}}
)

SELECT
    vendorid as vendor_id,
    ROUND(SUM(tip_amount) * 100.0 / SUM(total_amount), 2) AS avg_tip_percentage
FROM valid_trips
GROUP BY vendorid
ORDER BY avg_tip_percentage DESC
