-- Task 2 SQL
-- SQL Dialect: MySQL
-- Version: MySQL 8.0+
-- Run this file FIRST.

CREATE DATABASE IF NOT EXISTS task2_sql;
USE task2_sql;

DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS teams;

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

-- Exactly 4 lookup rows
INSERT INTO teams (team_id, department) VALUES
(1, 'Support'),
(2, 'Billing'),
(3, 'Technical'),
(4, 'Sales');

-- Exactly 12 fact rows; duplicate rows are excluded.
INSERT INTO tickets (ticket_id, team_id, channel, resolution_hours) VALUES
(101, 1, 'email', 10.00),
(102, 1, 'phone', 26.00),
(103, 2, 'email', 30.00),
(104, 2, 'chat', 18.00),
(105, 3, 'chat', 40.00),
(106, 3, 'email', 28.00),
(107, 3, 'phone', 22.00),
(108, 4, 'web', 35.00),
(109, 4, 'email', 15.00),
(110, 1, 'chat', 32.00),
(111, 2, 'phone', 20.00),
(112, 4, 'chat', 27.00);
