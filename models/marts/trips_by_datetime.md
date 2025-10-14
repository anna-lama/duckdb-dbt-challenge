# Data Mart: Trips by Time of Day

## Description
This first mart calculates the total_trips and total_revenue aggregates for 5 time slots.
Time slots used:
- **Morning**: 05:00 - 11:59
- **Afternoon**: 12:00 - 16:59
- **Evening**: 17:00 - 21:59
- **Night**: 22:00 - 04:59

## Model Location
`models/marts/trips_by_datetime.sql`

## Logic
- Uses `pickup_datetime` from the staging model `stg_yellow_tripdata`.
- Filters out trips with NULL pickup timestamps.
- Aggregates:
  - `total_trips`: count of trips per time slot.
  - `total_revenue`: sum of `total_amount` per time slot.

### Optional Macro
- `classify_time_of_day(pickup_datetime)` is used to standardize time slot classification.

## DBT Tests
- `time_of_day` is not null and belongs to the accepted values (`Morning`, `Afternoon`, `Evening`, `Night`).
- `total_trips` is positive.
- `total_revenue` is zero or greater.

## How to Run
Compile and execute this mart:
```bash
dbt run --select mrt_trips_by_time_of_day
