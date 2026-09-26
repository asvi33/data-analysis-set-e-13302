-- Task 2 SQL Analytical Queries
-- SQL Dialect: MySQL 8.0+
-- Run setup.sql FIRST, then run this file.

USE task2_sql;

-- ============================================================
-- S2a - Average resolution time by department
-- ============================================================
SELECT
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS tk
JOIN teams AS tm
    ON tk.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC, tm.department ASC;

-- ============================================================
-- S2b - Teams breaching SLA
-- Average resolution time must exceed 24 hours.
-- ============================================================
SELECT
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS tk
JOIN teams AS tm
    ON tk.team_id = tm.team_id
GROUP BY tm.team_id, tm.department
HAVING AVG(tk.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC, tm.department ASC;

-- ============================================================
-- S2c - Top two channels by breach count
-- A breach is resolution_hours > 24.
-- Alphabetical channel order breaks ties.
-- ============================================================
SELECT
    tk.channel,
    COUNT(*) AS breach_ticket_count
FROM tickets AS tk
WHERE tk.resolution_hours > 24
GROUP BY tk.channel
ORDER BY breach_ticket_count DESC, tk.channel ASC
LIMIT 2;

-- ============================================================
-- S3 - Data integrity diagnostic
-- LEFT JOIN from teams to tickets. A zero unmatched count
-- confirms that every ticket.team_id has a matching team.
-- ============================================================
SELECT
    tm.team_id,
    tm.department,
    COUNT(tk.ticket_id) AS ticket_count
FROM teams AS tm
LEFT JOIN tickets AS tk
    ON tm.team_id = tk.team_id
GROUP BY tm.team_id, tm.department
ORDER BY tm.team_id;

-- Optional explicit orphan-key diagnostic
-- Expected result: zero rows.
SELECT
    tk.team_id
FROM tickets AS tk
LEFT JOIN teams AS tm
    ON tk.team_id = tm.team_id
WHERE tm.team_id IS NULL;
