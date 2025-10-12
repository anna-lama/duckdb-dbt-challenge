{% macro calculate_trip_duration(pickup_col, dropoff_col, unit='minute') %}
    DATEDIFF(
        '{{ unit }}', 
        {{ pickup_col }}::TIMESTAMP, 
        {{ dropoff_col }}::TIMESTAMP
    )
{% endmacro %}