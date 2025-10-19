{{ config(materialized='view') }}

SELECT 
    distance_category,
    ROUND(AVG(trip_duration_minutes),2) AS average_trip_duration,
    ROUND(SUM(total_amount),2) AS total_revenue
FROM {{ ref('stg_yellow_tripdata') }}
GROUP BY distance_category
ORDER BY
    CASE distance_category
        WHEN 'short' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'long' THEN 3
    END
