{% macro filter_valid_trips(source_model) %}
    SELECT
        vendorid,
        tip_amount,
        total_amount
    FROM {{ ref(source_model) }}
    WHERE total_amount > 0
      AND tip_amount IS NOT NULL
      AND tip_amount >= 0
{% endmacro %}