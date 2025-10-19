import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Connessione al database
con = duckdb.connect("data/db/yellow_tripdata.duckdb")

df = con.execute("""
    SELECT *
    FROM best_pickup_location_v1
""").df()

df_revenue = df[df['ranking_type'] == 'by_revenue'].sort_values('rank')
df_trips = df[df['ranking_type'] == 'by_trips'].sort_values('rank')

fig, axes = plt.subplots(1, 2, figsize=(14,6))

x_trips = np.arange(len(df_trips))
axes[0].bar(x_trips, df_trips['rank'])
axes[0].set_xticks(x_trips)
axes[0].set_xticklabels(df_trips['PULocationID'])
axes[0].set_xlabel("Pickup Location ID")
axes[0].set_ylabel("Rank (1 = Top)")
axes[0].set_title("Top 5 Pickup Zones by Trips")

x_rev = np.arange(len(df_revenue))
axes[1].bar(x_rev, df_revenue['rank'], color='darkorange')
axes[1].set_xticks(x_rev)
axes[1].set_xticklabels(df_revenue['PULocationID'])
axes[1].set_xlabel("Pickup Location ID")
axes[1].set_ylabel("Rank")
axes[1].set_title("Top 5 Pickup Zones by Revenue")

plt.tight_layout()
plt.show()

con.close()
