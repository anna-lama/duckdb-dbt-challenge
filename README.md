# NYC Taxi – DBT & DuckDB Data Modeling Challenge

## Overview
This project implements a complete data modeling workflow using **DBT** and **DuckDB**, based on the **New York City Yellow Taxi dataset**.  

---

## Project Structure

```
duckdb-dbt-challenge/
├── data/
│   │── db/
│   │   └── yellow_tripdata.duckdb
│   └── raw/
│       └── yellow_tripdata_2025-08.parquet
├── models/
│   ├── staging/                  
│   │   ├── source.yml
│   │   ├── stg_yellow_tripdata.sql
│   │   └── stg_yellow_tripdata.yml
│   └── marts/                          
│       ├── trips_by_time_of_day.sql
│       ├── best_pickup_location_v1.sql
│       ├── best_pickup_location_v2.sql
│       ├── driver_performance_avg.sql
│       ├── driver_performance_pond.sql
│       └── distance_analysis.sql
├── macros/  
│       ├── aggregate_by_pulocation.sql
│       ├── calculate_time_of_day.sql
│       ├── calculate_trip_duration.sql
│       ├── filter_valid_trips.sql
│       └── prepaid_payment_filter.sql
├── analyses/  
│       ├── driver_performance.py
│       ├── driver_performance.png
│       ├── pickup_locations_v1.py
│       ├── pickup_locations_v1.png
│       ├── pickup_locations_v2.py
│       └── pickup_locations_v2.png                        
└── tests/    
        ├── test_total_amount_concistency.sql
        └── test_datetime.sql                       
```
---

For each data mart, I created a complete set of files including:
 - an **SQL model** defining the transformations,
 - a **YML file** containing tests and metadata,
 - a **dedicated md file** explaining the business logic choices.

## Data Flow

1. **Raw data**:  
   The input dataset (`yellow_tripdata_2025-08.parquet`) is loaded into DuckDB.

2. **Staging model – `stg_yellow_tripdata`**:  
   Cleans, standardizes, and enriches raw data:
   - Standardized timestamps.  
   - Derived fields: `trip_duration_minutes`, `distance_category`, `time_of_day`.  
   - Removes invalid records (negative distances, zero fares, etc.).

3. **Data Marts**:  
   Analytical layers built on top of the staging model:
   | Mart requested | Mart | Purpose |
   |------|------|----------|
   |A. Trips by Time of Day | **`trips_by_time_of_day`** | Total trips & revenue per time slot (morning, afternoon, evening, night). |
   |B. Top 5 Pickup Zones | **`best_pickup_location_v1`** | Top 5 pickup zones ranked separately by trips and revenue. |
   |B. Top 5 Pickup Zones | **`best_pickup_location_v2`** | Top 5 pickup zones with unified ranking combining trips and revenue. |
   |C. Driver/Rate Performance| **`driver_performance_avg`** | Average tip percentage (arithmetic mean) by `VendorID`. |
   |C. Driver/Rate Performance| **`driver_performance_pond`** | Weighted average tip percentage by `VendorID`. |
   |D. Distance Analysis| **`distance_analysis`** | Average trip duration & total revenue per distance category. |

4. **Data Visualization**:
    Under `analyses/`, you can find example Python scripts that:
    - Load mart tables from DuckDB using `duckdb` and `pandas`.
    - Generate comparison bar charts using `matplotlib` (e.g., top pickup zones, driver performance).

    Each script generates a plot that is already saved as a PNG file in the same folder to visualize the results of a specific data mart. These are the correspondences between data marts and scripts.
    - `driver_performance.py` → `driver_performance_avg` and `driver_performance_pond`  
    - `pickup_locations_v1.py` → `best_pickup_location_v1`  
    - `pickup_locations_v2.py` → `best_pickup_location_v2`  

    Example:
    ```bash
    uv run python analysis/pickup_locations_v2.py
    ```

---

## How to Run

1. **Environment setup**  
   ```bash
   uv venv
   source .venv/bin/activate
   uv sync
   ```

2. **Prepare data**  
   ```bash
   wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-08.parquet -P data/raw
   ```

3. **Run DBT models**  
   ```bash
   uv run dbt run
   uv run dbt test
   ```

--

