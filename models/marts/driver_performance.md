# Data Mart: Evaluation of tip percentage

## Description
Calculate the average tip percentage (tip_amount / total_amount) for each VendorID

## Model Location
`models/marts/driver_performance_AVG.sql`
`models/marts/driver_performance_pond.sql`

## Logic
- Also this mart is developed in two ways:
  - Calculates the simple average of the tip percentages per trip, giving the same weight to every ride regardless of its total amount.
  - Computes the ratio between the total tips and the total revenue, assigning higher weight to trips with higher total fares, more robust to outliers.
- By the way in this case, with this dataset the difference between the arithmetic and weighted averages is minimal:
  
  | VendorID | Arithmetic Avg (%) | Weighted Avg (%) |
  |----------|-----------------|----------------|
  | 2        | 12.04           | 12.35          |
  | 1        | 10.91           | 10.84          |

- This result is also evidentiated in a plot `analyses/driver_performance.png`
- Both versions use the staging model `stg_yellow_tripdata` as the source of cleaned and standardized data.

### Macro
- `filter_valid_trips(staging_model_ref)` is used to generate the aggregated base for both mart versions, calculating total trips and total revenue per pickup location.

## DBT Tests
- All columns are tested for **non-null values**.
- `avg_tip_percentage` is between 0 and 100
- `vendorid` is not null and must be one of [1, 2].

## How to Run
Compile and execute this mart:
```bash
dbt run --select driver_performance_AVG
dbt test --select driver_performance_AVG
dbt run --select driver_performance_pond
dbt test --select driver_performance_pond
