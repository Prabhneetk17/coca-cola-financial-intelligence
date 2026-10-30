
-- COCA-COLA FINANCIAL ANALYSIS
-- TAB 4: DATA RECONCILIATION AND REFRESH
-- STEPS 20-27

USE coca_cola_financials;

SET SQL_SAFE_UPDATES = 0;

-- STEP 20: Create reconciled copy
CREATE TABLE IF NOT EXISTS annual_financials_reconciled AS
SELECT *
FROM annual_financials;

-- STEP 21: Verify reconciliation_note column
-- Purpose: Confirm that the column required to document
-- financial data corrections exists in the reconciled table.

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'coca_cola_financials'
  AND TABLE_NAME = 'annual_financials_reconciled'
  AND COLUMN_NAME = 'reconciliation_note';
  
  -- STEP 22: Update 2017 financial figures

UPDATE annual_financials_reconciled
SET
    revenue_usd = 36212,
    gross_profit_usd = 22491,
    operating_income_usd = 7755,
    reconciliation_note = 'Reconciled with comparative financial figures'
WHERE fiscal_year = 2017;

-- STEP 23: Update 2018 financial figures

UPDATE annual_financials_reconciled
SET
    revenue_usd = 34300,
    gross_profit_usd = 21233,
    operating_income_usd = 9152,
    reconciliation_note = 'Reconciled with comparative financial figures'
WHERE fiscal_year = 2018;

-- STEP 24: Verify reconciled financial figures

SELECT
    fiscal_year,
    revenue_usd,
    gross_profit_usd,
    operating_income_usd,
    reconciliation_note
FROM annual_financials_reconciled
WHERE fiscal_year IN (2017, 2018)
ORDER BY fiscal_year;
-- STEP 25: Create financial performance view

CREATE OR REPLACE VIEW vw_financial_performance AS
SELECT
    fiscal_year,
    revenue_usd,
    gross_profit_usd,
    operating_income_usd,
    net_income_parent_usd,

    ROUND(
        (revenue_usd - LAG(revenue_usd) OVER (ORDER BY fiscal_year))
        / NULLIF(LAG(revenue_usd) OVER (ORDER BY fiscal_year), 0) * 100,
        2
    ) AS revenue_growth_pct,

    ROUND(gross_profit_usd / NULLIF(revenue_usd, 0) * 100, 2)
        AS gross_margin_pct,

    ROUND(operating_income_usd / NULLIF(revenue_usd, 0) * 100, 2)
        AS operating_margin_pct,

    ROUND(net_income_parent_usd / NULLIF(revenue_usd, 0) * 100, 2)
        AS net_margin_pct

FROM annual_financials_reconciled;
-- STEP 26: Create historical revenue variance view

CREATE OR REPLACE VIEW vw_historical_revenue_variance AS
SELECT
    fiscal_year,
    revenue_usd,

    ROUND(
        (revenue_usd - LAG(revenue_usd) OVER (ORDER BY fiscal_year))
        / NULLIF(LAG(revenue_usd) OVER (ORDER BY fiscal_year), 0) * 100,
        2
    ) AS actual_growth_pct,

    ROUND(5.53, 2) AS benchmark_growth_pct,

    ROUND(
        (
            (revenue_usd - LAG(revenue_usd) OVER (ORDER BY fiscal_year))
            / NULLIF(LAG(revenue_usd) OVER (ORDER BY fiscal_year), 0) * 100
        ) - 5.53,
        2
    ) AS growth_variance_pct_points

FROM annual_financials_reconciled;
-- STEP 27A: Calculate geometric average revenue growth
-- for the period 2022-2025

SELECT
    ROUND(
        (
            POWER(
                MAX(revenue_usd) / MIN(revenue_usd),
                1.0 / 3
            ) - 1
        ) * 100,
        2
    ) AS geometric_average_growth_pct
FROM annual_financials_reconciled
WHERE fiscal_year IN (2022, 2025);

-- STEP 27B: Check forecast assumptions table structure

DESCRIBE forecast_assumptions;
SELECT * FROM forecast_assumptions;
-- STEP 27B: Update forecast growth assumption
-- Purpose: Set the annual revenue growth assumption to 5.53%.

UPDATE forecast_assumptions
SET
    annual_growth_rate = 0.05530,
    assumption_note = '5.53% geometric average revenue growth, 2022-2025; provisional baseline'
WHERE assumption_id = 1;
-- Verify updated forecast assumption

SELECT
    assumption_id,
    assumption_name,
    annual_growth_rate,
    assumption_note
FROM forecast_assumptions;

DESCRIBE forecast_revenue;
-- STEP 27C: Clear previous forecast records

DELETE FROM forecast_revenue;
-- STEP 27D: Generate revenue forecast for 2026-2028

INSERT INTO forecast_revenue
(
    fiscal_year,
    forecast_revenue_usd,
    assumption_id,
    forecast_method
)

WITH RECURSIVE forecast_cte AS
(
    SELECT
        2026 AS fiscal_year,

        ROUND(
            (
                SELECT revenue_usd
                FROM annual_financials_reconciled
                WHERE fiscal_year = 2025
            ) * (1 + annual_growth_rate),
            2
        ) AS forecast_revenue_usd

    FROM forecast_assumptions
    WHERE assumption_id = 1

    UNION ALL

    SELECT
        fiscal_year + 1,

        ROUND(
            forecast_revenue_usd * (1 + annual_growth_rate),
            2
        )

    FROM forecast_cte
    CROSS JOIN forecast_assumptions
    WHERE assumption_id = 1
      AND fiscal_year < 2028
)

SELECT
    fiscal_year,
    forecast_revenue_usd,
    1 AS assumption_id,
    'Geometric average growth forecast' AS forecast_method

FROM forecast_cte;
-- STEP 27E: Display final revenue forecast

SELECT
    fiscal_year,
    forecast_revenue_usd,
    assumption_id,
    forecast_method
FROM forecast_revenue
ORDER BY fiscal_year;