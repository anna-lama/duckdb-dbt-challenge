{{ config(materialized='view') }}

WITH time_classified AS (
    SELECT
        pickup_datetime,
        COALESCE(total_amount, 0.0) AS total_amount,
        {{ calculate_time_of_day('pickup_datetime') }} AS time_of_day

    FROM {{ ref('stg_yellow_tripdata') }}
    WHERE pickup_datetime IS NOT NULL
)

SELECT
    time_of_day,
    COUNT(*)                 AS total_trips,
    ROUND(SUM(total_amount), 2)        AS total_revenue
FROM time_classified
GROUP BY time_of_day

