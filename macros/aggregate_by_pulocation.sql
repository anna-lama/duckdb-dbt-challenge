{% macro aggregate_by_pulocation(source_model) %}
SELECT
    pulocationid,
    COUNT(*) AS total_trips,
    SUM(COALESCE(total_amount,0)) AS total_revenue
FROM {{ ref(source_model) }}
WHERE pulocationid IS NOT NULL
GROUP BY pulocationid
{% endmacro %}