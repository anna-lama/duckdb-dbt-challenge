WITH source AS (
    SELECT * FROM {{ source('raw', 'staging_yellow_tripdata') }}
),
cleaned AS (
    SELECT
        vendorid,
        
        -- Timestamp standardized
        tpep_pickup_datetime::TIMESTAMP as pickup_datetime,
        tpep_dropoff_datetime::TIMESTAMP as dropoff_datetime,
        
        -- Calculation of duration by macro
        {{ calculate_trip_duration('tpep_pickup_datetime', 'tpep_dropoff_datetime') }} as trip_duration_minutes,

        passenger_count,
        trip_distance,
        payment_type,
        fare_amount,
        tip_amount,
        tolls_amount,
        total_amount,
        
        -- Requested flag for prepaid data by macro
        {{ prepaid_payment_filter('payment_type') }} as is_prepaid,
        
        -- Requested flag for distance categorization
        CASE
            WHEN trip_distance <= 2 THEN 'short'
            WHEN trip_distance <= 10 THEN 'medium'
            ELSE 'long'
        END as distance_category,
        
        pulocationid,
        dolocationid,
        ratecodeid,
        store_and_fwd_flag,
        extra,
        mta_tax,
        improvement_surcharge,
        congestion_surcharge
        
    FROM source
    
    -- DATA CLEANING: remove implausible rows
    WHERE trip_distance > 0
      AND total_amount > 0
      AND fare_amount > 0
      AND passenger_count > 0
      AND passenger_count <= 6
      AND {{ calculate_trip_duration('tpep_pickup_datetime', 'tpep_dropoff_datetime') }} > 0
      AND {{ calculate_trip_duration('tpep_pickup_datetime', 'tpep_dropoff_datetime') }} < 720  
)

SELECT * FROM cleaned