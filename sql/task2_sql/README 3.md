<div align="center">

# -- ! Ticket SLA MySQL Analysis ! --
### *MySQL Schema Design & Analytical Query Suite for Support Ticket SLA Breaches*

[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![SQL](https://img.shields.io/badge/SQL-Joins%20%26%20Aggregation-FF6F00?style=for-the-badge&logo=databricks&logoColor=white)](https://www.mysql.com/)
[![Schema](https://img.shields.io/badge/Schema-Relational%20Design-4CAF50?style=for-the-badge&logo=databricks&logoColor=white)](https://www.mysql.com/)
[![Analytics](https://img.shields.io/badge/Analytics-GROUP%20BY%20%7C%20HAVING-9C27B0?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)

<br/>

> *"A good schema asks the right question before a single row is ever inserted."*

</div>

---

## 📋 Table of Contents

- [📌 Overview](#-overview)
- [🎯 Problem Statement](#-problem-statement)
- [✨ Key Features](#-key-features)
- [🏗️ Project Structure](#️-project-structure)
- [🔄 Project Workflow](#-project-workflow)
- [🗄️ Part A — Schema & Setup](#️-part-a--schema--setup)
- [🔢 Part B — Analytical Queries](#-part-b--analytical-queries)
- [🛠️ Tech Stack](#️-tech-stack)
- [📈 Results & Insights](#-results--insights)
- [🏆 Advantages](#-advantages)
- [📄 License](#-license)
- [👤 Author](#-author)
- [🙏 Acknowledgements](#-acknowledgements)

---

## 📌 Overview

The **Ticket SLA MySQL Analysis** project is a two-file SQL workflow (`setup.sql` + `queries.sql`) that models a support-ticketing system in MySQL and answers key SLA (Service Level Agreement) reporting questions using pure SQL — joins, `GROUP BY`, `HAVING`, and `LEFT JOIN`-based integrity checks.

This project is designed to:
- Strengthen understanding of relational schema design with foreign keys
- Practice `JOIN`, `GROUP BY`, and `HAVING` for SLA-style reporting
- Apply `LEFT JOIN` for data-integrity / orphan-key diagnostics
- Rank categories using `ORDER BY` with tie-breaking rules and `LIMIT`

---

## 🎯 Problem Statement

> **Objective:** Design a relational schema for support tickets and write analytical SQL to surface SLA breaches.

You are given two entities — `teams` (department lookup) and `tickets` (ticket facts) — linked by a foreign key. The database must answer: which departments take longest to resolve tickets, which teams breach the 24-hour SLA on average, which channels see the most individual breaches, and whether every ticket correctly references a valid team.

| 📂 File | 📄 Type | 🔍 Description |
|---------|---------|-----------------|
| setup.sql | Schema + Seed Data | Creates `teams` & `tickets` tables, inserts sample rows |
| queries.sql | Analytical Queries | 4 queries answering SLA/reporting questions |

The goal is to demonstrate **relational schema design and analytical SQL** through a realistic support-ticket dataset.

---

## ✨ Key Features

| Feature | Description |
|--------|-------------|
| 🗄️ **Two-Table Schema** | `teams` (4 rows) and `tickets` (12 rows) linked by `team_id` |
| 🔗 **Foreign Key Constraint** | `tickets.team_id` references `teams.team_id` for referential integrity |
| 📊 **Department SLA Report** | Average resolution hours per department, sorted worst-first |
| 🚩 **HAVING-Based Breach Filter** | Flags teams whose *average* resolution time exceeds 24 hours |
| 📈 **Top-Channel Ranking** | Top 2 channels by individual breach count, alphabetical tie-break |
| 🛡️ **Integrity Diagnostics** | `LEFT JOIN` checks confirm every ticket maps to a valid team |
| 📐 **Deterministic Ordering** | Every query has explicit `ORDER BY` tie-breaking rules |

---

## 🏗️ Project Structure

```
📦 CustomerSupportanalysis/
│
├── 📄 setup.sql              ← Schema creation + seed data (run first)
├── 📄 queries.sql             ← Analytical queries (run second)
│
└── 📄 README.md               ← Project documentation
```

---

## 🔄 Project Workflow

```
Run setup.sql
      │
      ▼
┌─────────────────────────────┐
│  Create teams & tickets      │  ← teams: 4 rows, tickets: 12 rows
│  (FK: tickets.team_id)       │
└────────────┬─────────────────┘
             │
             ▼
        Run queries.sql
             │
     ┌───────┼────────┬─────────────┐
     ▼       ▼        ▼             ▼
┌─────────┐ ┌────────┐ ┌──────────┐ ┌──────────────┐
│ S2a     │ │ S2b    │ │ S2c      │ │ S3           │
│ Avg by  │ │ SLA    │ │ Top 2    │ │ Integrity    │
│ Dept    │ │ Breach │ │ Channels │ │ Diagnostic   │
│         │ │ Teams  │ │ Breached │ │ (LEFT JOIN)  │
└─────────┘ └────────┘ └──────────┘ └──────────────┘
     │       │        │             │
     └───────┴────────┴─────────────┘
                    │
                    ▼
           Reporting Complete ✅
```

---

## 🗄️ Part A — Schema & Setup

### 📝 1. Table Design

> Two tables: a small `teams` lookup and a `tickets` fact table linked by foreign key.

**Logic:**
```sql
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    department VARCHAR(50) NOT NULL
);

CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY,
    team_id INT NOT NULL,
    channel VARCHAR(20) NOT NULL,
    resolution_hours DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_tickets_team
        FOREIGN KEY (team_id) REFERENCES teams(team_id)
);
```

**Seed Data:** 4 teams (Support, Billing, Technical, Sales) and 12 tickets across `email`, `phone`, `chat`, and `web` channels.

---

## 🔢 Part B — Analytical Queries

### 📊 2. S2a — Average Resolution Time by Department

> Joins tickets to teams and averages resolution hours per department, worst (slowest) first.

**Logic:**
```sql
SELECT
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS tk
JOIN teams AS tm ON tk.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC, tm.department ASC;
```

---

### 🚩 3. S2b — Teams Breaching SLA (Average > 24h)

> Uses `HAVING` to keep only teams whose *average* resolution time exceeds the 24-hour SLA.

**Logic:**
```sql
SELECT
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS tk
JOIN teams AS tm ON tk.team_id = tm.team_id
GROUP BY tm.team_id, tm.department
HAVING AVG(tk.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC, tm.department ASC;
```

---

### 📈 4. S2c — Top Two Channels by Breach Count

> Counts individual breached tickets (resolution_hours > 24) per channel, keeping only the top 2.

**Logic:**
```sql
SELECT
    tk.channel,
    COUNT(*) AS breach_ticket_count
FROM tickets AS tk
WHERE tk.resolution_hours > 24
GROUP BY tk.channel
ORDER BY breach_ticket_count DESC, tk.channel ASC
LIMIT 2;
```

---

### 🛡️ 5. S3 — Data Integrity Diagnostic

> Confirms every ticket references a valid team using a `LEFT JOIN`; an orphan-key check expects zero rows.

**Logic:**
```sql
SELECT
    tk.team_id
FROM tickets AS tk
LEFT JOIN teams AS tm ON tk.team_id = tm.team_id
WHERE tm.team_id IS NULL;
```

**Key Concepts Used:**

| Concept | Detail |
|---------|--------|
| 🔗 `JOIN` | Combines ticket facts with team/department names |
| 🧮 `GROUP BY` | Aggregates rows per department/team |
| 🚩 `HAVING` | Filters aggregated groups (not raw rows) |
| 📐 `ORDER BY ... , ... ASC` | Deterministic tie-breaking |
| 🛡️ `LEFT JOIN ... IS NULL` | Classic orphan-key integrity check |

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| 🗄️ **MySQL** | 8.0+ | Relational database engine |
| 🔗 **INNER JOIN / LEFT JOIN** | Built-in | Combining and validating related tables |
| 🧮 **GROUP BY / HAVING** | Built-in | Aggregated department/team reporting |
| 📐 **ORDER BY / LIMIT** | Built-in | Ranking and top-N filtering |
| 🔑 **FOREIGN KEY** | Built-in | Referential integrity between tables |

---

## 📈 Results & Insights

- ✅ **4 Departments Analyzed** — Support, Billing, Technical, and Sales compared on average resolution time
- 🚩 **SLA-Breaching Teams Identified** — teams averaging over 24 hours flagged via `HAVING`
- 📊 **Top Breach Channels Surfaced** — the two channels with the most individually breached tickets
- 🛡️ **Zero Orphan Keys** — integrity diagnostic confirms every ticket maps to a valid team
- 🔁 **Fully Reproducible** — `setup.sql` then `queries.sql` regenerates the entire analysis from scratch

---

## 🏆 Advantages

| Advantage | Detail |
|-----------|--------|
| 🎓 **Realistic Schema** | Small but complete two-table relational design with a foreign key |
| 🔄 **Reusable Queries** | Each query is self-contained and easy to adapt to other datasets |
| 📚 **Educational** | Reinforces `JOIN`, `GROUP BY`, `HAVING`, and integrity-check patterns |
| 🖥️ **No External Tools** | Runs in any standard MySQL 8.0+ client |
| ⚡ **Lightweight** | Two short `.sql` files, runnable in seconds |
| 🧪 **Extensible** | Easy to add more teams, tickets, or new SLA thresholds |
| 🛡️ **Data Integrity Built-In** | Foreign key + diagnostic query guard against orphaned records |

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for full details.

```
MIT License — Free to use, modify, and distribute with attribution.
```

---

## 👤 Author

<div align="center">

### Asvi Ambaliya

[![GitHub](https://img.shields.io/badge/GitHub-yourhandle-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/)

> *"Every report starts with a well-joined table — just like every query starts with a single SELECT."*

**🎓 Role:** Data Analyst | SQL Enthusiast \
**📍 Location:** India\
**🛠️ Skills:** MySQL · Joins · Aggregation · Schema Design · SLA Reporting

</div>

---

## 🙏 Acknowledgements

Special thanks to the following resources and communities that made this project possible:

- 📚 [MySQL Official Docs](https://dev.mysql.com/doc/) — Official MySQL reference manual
- 🔁 [Mode — SQL Tutorial](https://mode.com/sql-tutorial/) — In-depth SQL tutorials
- 📐 [GeeksForGeeks — SQL JOINs](https://www.geeksforgeeks.org/sql-join-set-1-inner-left-right-and-full-joins/) — Join type examples
- 🖥️ [W3Schools SQL](https://www.w3schools.com/sql/) — Beginner SQL reference
- 💬 [Stack Overflow Community](https://stackoverflow.com/) — Problem-solving support

---

<div align="center">

---

*Made with 🗄️ and ☕ — Last updated: 27 May, 2026*

</div>
