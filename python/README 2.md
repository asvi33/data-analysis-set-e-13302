<div align="center">

# -- ! Support Ticket Analysis (Pandas) ! --
### *Jupyter Notebook-Based Ticket Cleaning & SLA Breach Analysis*

[![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-DataFrames-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)
[![Matplotlib](https://img.shields.io/badge/Matplotlib-Visualization-11557C?style=for-the-badge&logo=plotly&logoColor=white)](https://matplotlib.org/)

<br/>

> *"Data doesn't lie — but it does need cleaning first."*

</div>

---

## 📋 Table of Contents

- [📌 Overview](#-overview)
- [🎯 Problem Statement](#-problem-statement)
- [✨ Key Features](#-key-features)
- [🏗️ Project Structure](#️-project-structure)
- [🔄 Project Workflow](#-project-workflow)
- [🧹 Part A — Data Preparation](#-part-a--data-preparation)
- [🔢 Part B — Breach Analysis](#-part-b--breach-analysis)
- [🛠️ Tech Stack](#️-tech-stack)
- [📈 Results & Insights](#-results--insights)
- [🏆 Advantages](#-advantages)
- [📄 License](#-license)
- [👤 Author](#-author)
- [🙏 Acknowledgements](#-acknowledgements)

---

## 📌 Overview

The **Support Ticket Analysis** notebook is a `pandas`-driven Jupyter workflow that loads a raw ticket CSV export, cleans it, and analyzes SLA (Service Level Agreement) breaches by **department** and **team**. It demonstrates core data-analysis skills: type coercion, de-duplication, merging reference data, group-by aggregation, and deriving KPI-style summary tables.

This project is designed to:
- Strengthen understanding of `pandas` DataFrame operations
- Practice type validation and de-duplication on real-world messy data
- Merge fact and lookup tables to enrich ticket records
- Aggregate breach rates by department and team using `groupby`

---

## 🎯 Problem Statement

> **Objective:** Build a notebook-based analysis pipeline to clean support-ticket data and surface SLA breach patterns.

You are given a CSV export of support tickets (`ticket.csv`) with ticket ID, month, team, channel, resolution hours, and satisfaction score. The notebook must validate data types, remove duplicate rows, merge in department information, and compute breach rates — both overall by department, and per team to identify the worst-performing team.

| 📂 Step | 📄 Type | 🔍 Description |
|---------|---------|-----------------|
| Load CSV | Data Ingestion | Reads raw ticket export into a DataFrame |
| Type Check | Validation | Confirms `resolution_hours` / `satisfaction` are numeric |
| De-duplicate | Cleaning | Drops exact duplicate rows |
| Merge | Enrichment | Joins ticket data with a team/department lookup |
| Group & Aggregate | Analysis | Computes breach counts and rates by department/team |

The goal is to demonstrate **practical pandas data-cleaning and aggregation skills** through a realistic support-ops dataset.

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| 📥 **CSV Ingestion** | Loads ticket data directly with `pd.read_csv` |
| ✅ **Type Coercion** | `pd.to_numeric(..., errors="raise")` enforces strict numeric columns |
| 🧹 **De-duplication** | `drop_duplicates()` with an `assert` check on the resulting row count |
| 🔗 **Merge-Based Enrichment** | Ticket data merged with department lookup for grouped analysis |
| 🔢 **Department Summary** | Total tickets, breached count, and SLA breach rate per department |
| 🏆 **Team-Level Ranking** | Identifies the team with the single highest breach rate |
| 📊 **Matplotlib Import** | Ready for chart-based visualization of results |

---

## 🏗️ Project Structure

```
📦 CustomerSupportanalysis/
│
├── 📄 Analysis.ipynb         ← Main Jupyter notebook (entry point)
├── 📄 ticket.csv             ← Raw ticket data (expected input)
│
└── 📄 README.md              ← Project documentation
```

---

## 🔄 Project Workflow

```
Load ticket.csv
      │
      ▼
┌─────────────────────────────┐
│   Validate Column Types      │  ← resolution_hours, satisfaction → numeric
└────────────┬─────────────────┘
             │
             ▼
┌─────────────────────────────┐
│   Drop Duplicate Rows        │  ← Before: 13 rows → After: 12 rows
└────────────┬─────────────────┘
             │
             ▼
┌─────────────────────────────┐
│  Merge with Team/Dept Lookup │  ← Produces `merged` DataFrame
└────────────┬─────────────────┘
             │
     ┌───────┴────────┐
     ▼                ▼
┌─────────────┐   ┌──────────────────┐
│ Department   │   │   Team-Level     │
│ Summary      │   │   Breach Rate    │
└──────┬──────┘   └────────┬─────────┘
       │                   │
       ▼                   ▼
┌─────────────────────────────┐
│   Display Summary Tables     │
└─────────────────────────────┘
```

---

## 🧹 Part A — Data Preparation

### 📝 1. Loading & Type Validation

> Raw CSV columns are coerced to numeric types so downstream aggregation is safe.

**Logic:**
```python
tickets = pd.read_csv("ticket.csv")

tickets["resolution_hours"] = pd.to_numeric(
    tickets["resolution_hours"], errors="raise"
)
tickets["satisfaction"] = pd.to_numeric(
    tickets["satisfaction"], errors="raise"
)
```

---

### 🧹 2. De-duplication

> Exact duplicate rows are dropped, with an assertion confirming the expected clean row count.

**Logic:**
```python
print("Before removing duplicates:", len(tickets))
tickets = tickets.drop_duplicates().copy()
print("After removing duplicates:", len(tickets))
assert len(tickets) == 12
```

**Output:**
```
Before removing duplicates: 13
After removing duplicates: 12
```

---

## 🔢 Part B — Breach Analysis

### 🏢 3. Department-Wise Summary

> Groups the merged, enriched dataset by department to compute total tickets, breached tickets, and breach rate.

**Logic:**
```python
department_summary = (
    merged.groupby("department")
    .agg(
        total_tickets=("ticket_id", "count"),
        breached_count=("breach_flag", "sum")
    )
    .reset_index()
)

department_summary["sla_breach_rate"] = (
    department_summary["breached_count"]
    / department_summary["total_tickets"] * 100
).round(2)
```

---

### 🏆 4. Team With Highest Breach Rate

> Groups by team to find which single team has the worst SLA breach rate.

**Logic:**
```python
team_summary = (
    merged.groupby("team_id")
    .agg(
        total_tickets=("ticket_id", "count"),
        breached_count=("breach_flag", "sum")
    )
    .reset_index()
)

team_summary["breach_rate"] = (
    team_summary["breached_count"]
    / team_summary["total_tickets"] * 100
).round(2)

highest_team = team_summary.loc[team_summary["breach_rate"].idxmax()]
```

**Key Concepts Used:**

| Concept | Detail |
|---------|--------|
| 🔗 `merge` | Joins ticket facts with team/department lookup |
| 🧮 `groupby().agg()` | Named aggregation for count & sum |
| ➗ Breach Rate | `breached_count / total_tickets * 100` |
| 🏆 `idxmax()` | Locates the row with the highest breach rate |

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| 🐍 **Python** | 3.8+ | Core programming language |
| 🐼 **pandas** | Latest | DataFrame loading, cleaning, and aggregation |
| 📊 **matplotlib** | Latest | Reserved for chart-based visualization |
| 📓 **Jupyter Notebook** | Latest | Interactive, cell-based analysis environment |
| 🗂️ **pathlib** | Built-in | File path handling |

---

## 📈 Results & Insights

- ✅ **1 Duplicate Removed** — 13 raw rows cleaned down to 12 verified unique tickets
- 🏢 **Department Breach Rates** — Technical departments show a notably higher SLA breach rate than Service
- 🏆 **Worst-Performing Team Identified** — team-level breach rate pinpoints the single highest-risk team
- 🔗 **Merge-Ready Pipeline** — cleaned ticket data merges cleanly with the team/department lookup
- ⚠️ **Type Safety Enforced** — strict numeric coercion prevents silent aggregation errors

---

## 🏆 Advantages

| Advantage | Detail |
|-----------|--------|
| 🎓 **Practical Skill Set** | Type validation, cleaning, merging, and group-by aggregation in one notebook |
| 🔄 **Reusable Logic** | Aggregation logic can be wrapped into functions for other datasets |
| 📚 **Educational** | Reinforces the standard "clean → merge → aggregate" pandas pattern |
| 🖥️ **Minimal Dependencies** | Only pandas, matplotlib, and pathlib required |
| ⚡ **Lightweight** | Single notebook, runnable in any Jupyter environment |
| 🧪 **Extensible** | Easy to add monthly trends, channel breakdowns, or satisfaction correlation |
| 🛡️ **Data Safety** | `errors="raise"` and `assert` checks catch bad data early |

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for full details.

```
MIT License — Free to use, modify, and distribute with attribution.
```

---

## 👤 Author

<div align="center">

### Ambaliya Asvi

[![GitHub](https://img.shields.io/badge/GitHub-yourhandle-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/)

> *"Every insight starts with a clean DataFrame — just like every program starts with a single import."*

**🎓 Role:** Data Analyst | Python & Pandas Enthusiast \
**📍 Location:** India\
**🛠️ Skills:** Python · Pandas · Data Cleaning · Aggregation · Jupyter Notebooks

</div>

---

## 🙏 Acknowledgements

Special thanks to the following resources and communities that made this project possible:

- 📚 [Pandas Official Docs](https://pandas.pydata.org/docs/) — Official pandas library reference
- 🔁 [Real Python — Pandas Tutorials](https://realpython.com/pandas-python-explore-dataset/) — In-depth data-analysis tutorials
- 📐 [GeeksForGeeks — GroupBy in Pandas](https://www.geeksforgeeks.org/python-pandas-groupby/) — Aggregation examples
- 🖥️ [Jupyter Documentation](https://docs.jupyter.org/) — Notebook environment reference
- 💬 [Stack Overflow Community](https://stackoverflow.com/) — Problem-solving support
- 📖 [Kaggle Learn — Pandas](https://www.kaggle.com/learn/pandas) — Pandas courses

---

<div align="center">

---

*Made with 🐍 and ☕ — Last updated: 27 May, 2026*

</div>
