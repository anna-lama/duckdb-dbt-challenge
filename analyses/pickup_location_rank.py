import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

conn = duckdb.connect("data/db/yellow_tripdata.duckdb")

query = "SELECT pulocationid as loc_id, trip_rank, revenue_rank, total_score FROM best_pickup_location_v2;"

df = conn.execute(query).fetchdf()

print(df)

conn.close()

locations = df.apply(lambda row: f"{row['loc_id']}({row['total_score']})", axis=1)

x = np.arange(len(locations))  # posizioni dei gruppi
width = 0.35  # larghezza delle barre

fig, ax = plt.subplots(figsize=(8,5))
ax.bar(x - width/2, df["trip_rank"], width, label="Trip rank")
ax.bar(x + width/2, df["revenue_rank"], width, label="Revenue rank")

ax.set_xlabel("Pickup Location id (total_rank)")
ax.set_ylabel("Ranks")
ax.set_title("Rank of Pickup Location by trips and revenue")
ax.set_xticks(x)
ax.set_xticklabels(locations)
ax.legend()
ax.grid(axis="y", linestyle="--", alpha=0.6)

plt.tight_layout()
plt.show()