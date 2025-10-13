SELECT 
    pickup_datetime,
    dropoff_datetime
FROM {{ ref('stg_yellow_tripdata') }}
WHERE dropoff_datetime <= pickup_datetime