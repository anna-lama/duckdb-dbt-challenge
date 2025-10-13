# Staging Model Tests

## 1. Pickup/Dropoff Datetime Consistency

**Test Query:**

```sql
SELECT 
    pickup_datetime,
    dropoff_datetime
FROM {{ ref('stg_yellow_tripdata') }}
WHERE dropoff_datetime <= pickup_datetime
```

**Purpose:**
This test checks for **logical inconsistencies in trip timestamps**.
It ensures that the `dropoff_datetime` always occurs **after the `pickup_datetime`**, which is a fundamental sanity check for trip records.
The test is actually unnecessary because the condition was set during the cleaning phase of the staging model.


## 2. Total Amount Consistency

**Test Query:**

```sql
SELECT *
FROM {{ ref('stg_yellow_tripdata') }}
WHERE ABS(
      COALESCE(fare_amount,0) +
      COALESCE(extra,0) +
      COALESCE(mta_tax,0) +
      COALESCE(tip_amount,0) +
      COALESCE(tolls_amount,0) +
      COALESCE(improvement_surcharge,0) +
      COALESCE(congestion_surcharge,0) +
      COALESCE(airport_fee,0) +
      COALESCE(cbd_congestion_fee,0)
      - COALESCE(total_amount,0)
) > 0.01
```

**Purpose:**
This test verifies the **consistency of payment data**.
It checks that the sum of all fare components (`fare_amount`, `taxes`, `tolls`, `surcharges`, `fees`) matches the reported `total_amount`, allowing for a small rounding tolerance (`0.01`).
Rows failing this test indicate **inaccurate or inconsistent total charges**, but I don't know if it's right to exclude these lines.

