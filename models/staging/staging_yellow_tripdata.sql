{{ config({"materialized": "table"}) }}

SELECT * FROM 'data/raw/yellow_tripdata_2025-08.parquet'
