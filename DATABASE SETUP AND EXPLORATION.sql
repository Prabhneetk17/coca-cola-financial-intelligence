
-- COCA-COLA FINANCIAL ANALYSIS
-- TAB 1: DATABASE SETUP AND CLEANING
-- STEPS 1-6

-- STEP 1: Create database
CREATE DATABASE IF NOT EXISTS coca_cola_financials;

USE coca_cola_financials;

-- STEP 2: Import annual data
-- Use Table Data Import Wizard in MySQL Workbench.
-- Import your annual CSV into annual_financials_raw.

-- STEP 3: Inspect raw table
SHOW TABLES;

DESCRIBE annual_financials_raw;

SELECT *
FROM annual_financials_raw
LIMIT 20;

-- STEP 4: Create cleaned historical table
-- The annual_financials table was created from the imported raw data.
-- It contains one record per year, FY2016-FY2025.

-- STEP 5: Inspect cleaned table
DESCRIBE annual_financials;

SELECT *
FROM annual_financials
ORDER BY fiscal_year;

-- STEP 6: Check record count and year range
SELECT
    COUNT(*) AS total_records,
    MIN(fiscal_year) AS first_year,
    MAX(fiscal_year) AS last_year,
    COUNT(DISTINCT fiscal_year) AS unique_years
FROM annual_financials;
