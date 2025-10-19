# Data Mart: Distance analysis 

## Description
This mart calculates the average trips duration and total_revenue aggregates by distance.
The distance classification used is:
- **short**: 0-2 miles
- **medium**: 2-5 miles
- **long**: >5 miles

## Model Location
`models/marts/distance_analysis.sql`

## Logic
- I used the data previously defined in the staging model: distance_category and trip_duration_minutes.
- Aggregates:
  - `trip_duration_minutes`: calculated as the average trip duration (in minutes) for each distance category
  - `total_revenue`: calculated as the sum of total_amount for all trips in the same distance category.
  - Results are ordered by distance segment (Short -> Medium -> Long).

## DBT Tests
- `distance_category` is not null and belongs to the accepted values (`short`, `medium`, `long`).
- `average_trip_duration` is positive.
- `total_revenue` is zero or greater.

## How to Run
Compile and execute this mart:
```bash
dbt run --select distance_analysis
dbt test --select distance_analysis
