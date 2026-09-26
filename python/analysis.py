import os
import pandas as pd
import matplotlib.pyplot as plt

os.makedirs("outputs/python", exist_ok=True)

tickets_df = pd.read_csv("data/raw/tickets.csv")
teams_df = pd.read_csv("data/raw/teams.csv")

assert pd.api.types.is_numeric_dtype(tickets_df['resolution_hours'])
assert pd.api.types.is_numeric_dtype(tickets_df['satisfaction'])

tickets_clean = tickets_df.drop_duplicates()
merged_df = pd.merge(tickets_clean, teams_df, on="team_id", how="left")

assert len(merged_df) == 12
assert merged_df['department'].isna().sum() == 0

merged_df['breach_flag'] = (merged_df['resolution_hours'] > 24).astype(int)

dept_summary = merged_df.groupby('department').agg(
    total_tickets=('ticket_id', 'count'),
    breached_count=('breach_flag', 'sum')
).reset_index()
dept_summary['sla_breach_rate(%)'] = round((dept_summary['breached_count'] / dept_summary['total_tickets']) * 100, 2)

print("--- Department Analysis Summary ---")
print(dept_summary.to_string(index=False))

month_order = ['Jan', 'Feb', 'Mar']
merged_df['month'] = pd.Categorical(merged_df['month'], categories=month_order, ordered=True)
monthly_avg = merged_df.groupby('month', observed=False)['resolution_hours'].mean()

plt.figure(figsize=(7, 4.5))
monthly_avg.plot(kind='bar', color='skyblue', edgecolor='black')
plt.title("Monthly Average Resolution Hours (Jan - Mar)", fontsize=12, fontweight='bold')
plt.xlabel("Month")
plt.ylabel("Avg Resolution Hours")
plt.tight_layout()

plt.savefig("outputs/python_chart.png", dpi=150)
merged_df.to_csv("outputs/clean_data.csv", index=False)
dept_summary.to_csv("outputs/python_summary.csv", index=False)
print("Pipeline executed successfully.")