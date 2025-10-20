# Data Mart: Top 5 pickup zones

## Description
The second mart identifies the top 5 pickup zones (PULocationID) with:
- The highest number of trips.
- The highest total revenue.

## Model Location
- `models/marts/best_pickup_location_v1.sql`
- `models/marts/best_pickup_location_v2.sql`

## Logic
- The second mart is developed in two ways:
  - The first produces two separate rankings for pickup locations with the highest number of trips and those with the highest earnings.
  - The second creates a ranking based on the sum of the scores obtained from the two categories.
- Both versions use the staging model `stg_yellow_tripdata` as the source of cleaned and standardized data.

### Macro
- `aggregate_by_pulocation(staging_model_ref)` is used to generate the aggregated base for both mart versions, calculating total trips and total revenue per pickup location.

## DBT Tests
- All columns are tested for **non-null values**.
- `total_trips` is greater than 0, `total_revenue` is >= 0.
- `ranking_type` accepts only `'by_trips'` or `'by_revenue'` in Version 1.
- `rank` is within 1–5.

## How to Run
Compile and execute this mart:
```bash
dbt run --select best_pickup_location_v1
dbt test --select best_pickup_location_v1
dbt run --select best_pickup_location_v2
dbt test --select best_pickup_location_v2
