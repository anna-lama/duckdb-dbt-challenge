-- depends_on: {{ ref('stg_yellow_tripdata') }}
{{ config(materialized='view') }}

WITH base AS (
    {{ aggregate_by_pulocation('stg_yellow_tripdata') }}
),
best_by_trips AS (
    SELECT
        pulocationid,
        ROUND(total_trips,2) as total_trips,
        ROUND(total_revenue,2) as total_revenue,
        'by_trips' AS ranking_type,
        ROW_NUMBER() OVER (ORDER BY total_trips DESC) AS rank
    FROM base
),
best_by_revenue AS (
    SELECT
        pulocationid,
        ROUND(total_trips,2) as total_trips,
        ROUND(total_revenue,2) as total_revenue,
        'by_revenue' AS ranking_type,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS rank
    FROM base
)
SELECT *
FROM (
    SELECT * FROM best_by_trips WHERE rank <= 5
    UNION ALL
    SELECT * FROM best_by_revenue WHERE rank <= 5
)
ORDER BY ranking_type, rank
