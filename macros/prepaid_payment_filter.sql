{% macro prepaid_payment_filter(payment_type) %}
    CASE 
        WHEN {{ payment_type }} = 2 THEN TRUE 
        ELSE FALSE 
    END
{% endmacro %}