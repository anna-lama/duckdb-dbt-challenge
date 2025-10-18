-- depends_on: {{ ref('stg_yellow_tripdata') }}
{{ config(materialized='view') }}

WITH base AS (
    {{ aggregate_by_pulocation('stg_yellow_tripdata') }}
),
ranked_zones AS (
    SELECT
        pulocationid,
        total_trips,
        total_revenue,
        RANK() OVER (ORDER BY total_trips DESC) AS trip_rank,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM base
)
SELECT 
    pulocationid,
    total_trips,
    ROUND(total_revenue, 2) as total_revenue,
    trip_rank,
    revenue_rank,
    (trip_rank + revenue_rank) as total_score
FROM ranked_zones
ORDER BY total_score
LIMIT 5



