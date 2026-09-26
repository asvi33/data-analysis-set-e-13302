<div align="center">

# -- ! Ticket SLA Analysis Dashboard ! --
### *Excel-Based Support Ticket Cleaning, SLA Breach Detection & Dashboard Reporting*

[![Excel](https://img.shields.io/badge/Excel-Workbook-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)
[![Formulas](https://img.shields.io/badge/Formulas-XLOOKUP%20%7C%20COUNTIFS-FF6F00?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)
[![PivotTable](https://img.shields.io/badge/PivotTable-Summary%20Reporting-4CAF50?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)
[![Dashboard](https://img.shields.io/badge/Dashboard-KPI%20Cards-9C27B0?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)

<br/>

> *"A clean sheet tells a clear story — one formula at a time."*

</div>

---

## 📋 Table of Contents

- [📌 Overview](#-overview)
- [🎯 Problem Statement](#-problem-statement)
- [✨ Key Features](#-key-features)
- [🏗️ Project Structure](#️-project-structure)
- [🔄 Project Workflow](#-project-workflow)
- [🧹 Part A — Data Cleaning](#-part-a--data-cleaning)
- [📊 Part B — Dashboard & Reporting](#-part-b--dashboard--reporting)
- [🛠️ Tech Stack](#️-tech-stack)
- [📈 Results & Insights](#-results--insights)
- [🏆 Advantages](#-advantages)
- [📄 License](#-license)
- [👤 Author](#-author)
- [🙏 Acknowledgements](#-acknowledgements)

---

## 📌 Overview

The **Ticket SLA Analysis Dashboard** is a multi-sheet Excel workbook that takes a raw support-ticket export and turns it into a clean, department-tagged dataset with automated **SLA breach detection**, a **PivotTable summary**, and a **KPI dashboard**. It demonstrates practical spreadsheet skills used in real support/operations reporting: lookup-based enrichment, conditional flags, and roll-up metrics.

This project is designed to:
- Practice cleaning raw exported data (duplicate rows, row counts before/after)
- Apply `XLOOKUP` to enrich ticket data with department information
- Flag SLA breaches using conditional logic (`IF`)
- Summarize breach rates by channel and department with `COUNTIFS` / `PivotTable`
- Present headline KPIs on a single dashboard sheet

---

## 🎯 Problem Statement

> **Objective:** Build a spreadsheet workflow that ingests raw ticket data and produces a reliable SLA breach report.

You are given a raw export of support tickets containing ticket ID, month, team, channel, resolution hours, and satisfaction score. Some rows are duplicated. The workbook must clean the data, attach each ticket's department via a lookup table, flag any ticket that breached the 24-hour SLA, and roll all of this up into a summary and dashboard view.

| 📂 Sheet | 📄 Type | 🔍 Description |
|----------|---------|-----------------|
| Raw | Source Data | Original exported ticket rows (includes 1 duplicate) |
| Lookup | Reference Table | Maps `team_id` → team name & department |
| Clean | Processed Data | De-duplicated tickets enriched with department + breach flag |
| pivot_table | PivotTable | Average resolution hours by department × month |
| Summary | Aggregation | Breach count & breach rate by channel |
| Dashboard | KPI View | Total tickets, SLA breaches, breach rate, avg satisfaction |

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| 🧹 **Duplicate Handling** | Before/after row counts confirm de-duplication |
| 🔎 **XLOOKUP Enrichment** | Pulls department from a separate `Lookup` sheet by `team_id` |
| 🚩 **SLA Breach Flag** | `IF(resolution_hours > 24, 1, 0)` marks breaches automatically |
| 📊 **PivotTable Rollup** | Avg. resolution hours by department, broken out by month |
| 📈 **Channel Summary** | `COUNTIFS` totals breached tickets per channel (Email/Chat/Phone) |
| 🖥️ **KPI Dashboard** | One-glance cards: total tickets, breaches, breach rate, avg satisfaction |
| 🔗 **Fully Formula-Driven** | No manual values in derived sheets — everything recalculates live |

---

## 🏗️ Project Structure

```
📦 CustomerSupportanalysis/
│
├── 📄 ticket_analysis.xlsx   ← Main workbook (entry point)
│   ├── Raw                   ← Source ticket export
│   ├── Lookup                ← team_id → team/department reference
│   ├── Clean                 ← De-duplicated + enriched data
│   ├── pivot_table            ← Department × Month PivotTable
│   ├── Summary                ← Channel-wise breach summary
│   └── Dashboard              ← KPI cards
│
└── 📄 README.md               ← Project documentation
```

---

## 🔄 Project Workflow

```
Raw Export (Raw sheet)
         │
         ▼
┌──────────────────────────────┐
│   Remove Duplicate Rows       │  ← Before/After row count check
└───────────────┬───────────────┘
                │
                ▼
┌──────────────────────────────┐
│  XLOOKUP department (Clean)   │  ← Lookup sheet: team_id → department
└───────────────┬───────────────┘
                │
                ▼
┌──────────────────────────────┐
│  Flag SLA Breach (IF > 24h)   │
└───────────────┬───────────────┘
                │
        ┌───────┴────────┐
        ▼                 ▼
┌───────────────┐   ┌────────────────────┐
│  PivotTable    │   │ Summary (COUNTIFS) │
│ Dept × Month   │   │ Channel breach rate│
└───────┬────────┘   └─────────┬──────────┘
        │                      │
        └──────────┬───────────┘
                    ▼
           ┌──────────────────┐
           │   Dashboard KPIs  │
           └──────────────────┘
```

---

## 🧹 Part A — Data Cleaning

### 📝 1. De-duplication

> The `Raw` sheet contains 13 rows, one of which is an exact duplicate. The `Clean` sheet removes it and both row counts are tracked with formulas for auditability.

**Logic:**
```
After Row Count  = COUNTA(A2:A13)
Before Row Count = COUNTA(Raw!A2:A14)
```

---

### 🔎 2. Department Enrichment (XLOOKUP)

> Each ticket's `team_id` is matched against the `Lookup` sheet to pull in its department.

**Logic:**
```
=XLOOKUP(C2, Lookup!$A$2:$A$5, Lookup!$C$2:$C$5)
```

---

### 🚩 3. SLA Breach Flag

> Any ticket resolved in more than 24 hours is flagged as a breach.

**Logic:**
```
=IF(E2>24, 1, 0)
```

---

## 📊 Part B — Dashboard & Reporting

### 🔍 4. Channel Summary

> Counts breached tickets per channel and computes an overall breach rate.

**Logic:**
```
Breached Tickets = COUNTIFS(Clean!$D$2:$D$13, A2, Clean!$H$2:$H$13, 1)
SLA Breach Rate  = COUNTIF(Clean!H2:H13, 1) / COUNTA(Clean!A2:A13)
```

---

### 📌 5. PivotTable — Department × Month

> Shows average resolution hours for each department, broken down by month, with grand totals.

| Row Labels | Jan | Feb | Mar | Grand Total |
|------------|-----|-----|-----|-------------|
| Service    | 20  | 19  | 19  | 19.33 |
| Technical  | 28  | 29  | 28  | 28.33 |
| **Grand Total** | 24 | 24 | 23.5 | 23.83 |

---

### 🖥️ 6. Dashboard KPIs

**Key Concepts Used:**

| Concept | Detail |
|---------|--------|
| 🔁 `COUNTA` | Total ticket count |
| 🔎 `COUNTIF` | SLA breach count |
| ➗ Division | Breach rate as a ratio |
| ➕ `AVERAGE` | Average satisfaction score |

**Sample KPI Row:**
```
Total Tickets: 12   |  SLA Breaches: 5  |  Breach Rate: 0.42  |  Avg Satisfaction: 3.58
```

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| 📊 **Microsoft Excel** | 365 / 2021+ | Core spreadsheet application |
| 🔎 **XLOOKUP** | Excel 365 | Reference-table lookups |
| 🧮 **COUNTIFS / COUNTIF** | Built-in | Conditional counting |
| 🚩 **IF** | Built-in | SLA breach flagging |
| 📈 **PivotTable** | Built-in | Department × Month rollup |
| 🖨️ **AVERAGE / COUNTA** | Built-in | KPI calculations |

---

## 📈 Results & Insights

- ✅ **1 Duplicate Removed** — 13 raw rows cleaned down to 12 unique tickets
- 🔎 **Every Ticket Enriched** — department attached via `XLOOKUP` with zero manual entry
- 🚩 **5 SLA Breaches Identified** — tickets resolved in over 24 hours
- 📊 **Technical Department Slower** — consistently higher avg. resolution hours than Service across all three months
- 🖥️ **One-Glance Dashboard** — total tickets, breach rate, and satisfaction visible instantly

---

## 🏆 Advantages

| Advantage | Detail |
|-----------|--------|
| 🎓 **Practical Skill Set** | Combines cleaning, lookups, conditional flags, and pivoting in one file |
| 🔄 **Fully Live** | Every sheet recalculates automatically if raw data changes |
| 📚 **Educational** | Demonstrates a realistic ops-reporting pipeline end to end |
| 🖥️ **No Add-ins Needed** | Uses only native Excel formulas and PivotTables |
| ⚡ **Lightweight** | Single workbook, instantly usable in any modern Excel |
| 🧪 **Extensible** | Easy to add more months, teams, or KPI cards |
| 🛡️ **Auditable** | Before/after row counts make cleaning steps verifiable |

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

> *"Every dashboard starts with a clean sheet — just like every insight starts with clean data."*

**🎓 Role:** Data Analyst | Spreadsheet Automation Enthusiast \
**📍 Location:** India\
**🛠️ Skills:** Excel · XLOOKUP · PivotTables · Data Cleaning · Dashboarding

</div>

---

## 🙏 Acknowledgements

Special thanks to the following resources that made this project possible:

- 📚 [Microsoft Excel Support Docs](https://support.microsoft.com/excel) — Official Excel function reference
- 🔎 [Exceljet — XLOOKUP Guide](https://exceljet.net/functions/xlookup-function) — In-depth lookup function tutorials
- 📊 [Microsoft — PivotTable Guide](https://support.microsoft.com/en-us/office/create-a-pivottable-to-analyze-worksheet-data) — PivotTable creation reference
- 💬 [Stack Overflow Community](https://stackoverflow.com/) — Problem-solving support

---

<div align="center">

---

*Made with 📊 and ☕ — Last updated: 27 May, 2026*

</div>
