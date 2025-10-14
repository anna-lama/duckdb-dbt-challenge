{% macro calculate_time_of_day(column) %}
CASE
    WHEN EXTRACT(hour FROM {{ column }}) BETWEEN 5 AND 11 THEN 'Morning'
    WHEN EXTRACT(hour FROM {{ column }}) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN EXTRACT(hour FROM {{ column }}) BETWEEN 17 AND 21 THEN 'Evening'
    ELSE 'Night'
END
{% endmacro %}
