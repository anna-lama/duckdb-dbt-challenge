import duckdb
import pandas as pd
import matplotlib.pyplot as plt

db_path = "data/db/yellow_tripdata.duckdb"

con = duckdb.connect(db_path)

df_avg = con.execute("""
SELECT vendor_id, avg_tip_percentage AS avg_percentage
FROM driver_performance_AVG
""").df()

df_pond = con.execute("""
SELECT vendor_id, avg_tip_percentage AS pond_percentage
FROM driver_performance_pond
""").df()

df_merge = pd.merge(df_avg, df_pond, on="vendor_id")

print("\nComparison between arithmetic and weighted averages:")
print(df_merge)

plt.figure(figsize=(6, 5))
x = range(len(df_merge))
width = 0.25

plt.bar([i - width/2 for i in x], df_merge["avg_percentage"], width=width, label="Arithmetic Avg")
plt.bar([i + width/2 for i in x], df_merge["pond_percentage"], width=width, label="Weighted Avg")


plt.xticks(x, df_merge["vendor_id"])
plt.xlabel("Vendor ID")
plt.ylabel("Average Tip Percentage (%)")
plt.title("Driver Performance: Arithmetic vs Weighted Average Tip Percentage")
plt.legend()
plt.tight_layout()

plt.show()