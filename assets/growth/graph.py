import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("cloc-history.csv", parse_dates=["date"])

pivot = (
    df.pivot_table(
        index="date",
        columns="language",
        values="code",
        aggfunc="sum",
    )
    .sort_index()
    .fillna(0)
)

exclude = ["SUM"]

pivot_filtered = pivot.drop(columns=exclude, errors="ignore")

pivot_filtered.plot(figsize=(12, 6))
plt.ylabel("Lines of code")
plt.xlabel("Date")
plt.title("Lines of code per language over time")
plt.tight_layout()
plt.show()
