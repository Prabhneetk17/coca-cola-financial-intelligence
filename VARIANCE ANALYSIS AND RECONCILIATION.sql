
-- COCA-COLA FINANCIAL ANALYSIS
-- TAB 3: FORECASTING AND VARIANCE
-- STEPS 13-19

USE coca_cola_financials;

-- STEP 13: Store forecast assumptions
CREATE TABLE IF NOT EXISTS forecast_assumptions (
    assumption_id INT PRIMARY KEY,
    assumption_name VARCHAR(100) NOT NULL,
    annual_growth_rate DECIMAL(8,5) NOT NULL,
    assumption_note VARCHAR(255)
);

INSERT INTO forecast_assumptions (
    assumption_id,
    assumption_name,
    annual_growth_rate,
    assumption_note
)
VALUES (
    1,
    'Historical average growth baseline',
    0.05590,
    'Provisional 5.59% growth assumption; not an approved company forecast'
)
ON DUPLICATE KEY UPDATE
    annual_growth_rate = VALUES(annual_growth_rate),
    assumption_note = VALUES(assumption_note);

-- STEP 14: Create forecast table
CREATE TABLE IF NOT EXISTS forecast_revenue (
    fiscal_year INT PRIMARY KEY,
    forecast_revenue_usd DECIMAL(20,2) NOT NULL,
    assumption_id INT NOT NULL,
    forecast_method VARCHAR(100) NOT NULL,
    FOREIGN KEY (assumption_id)
        REFERENCES forecast_assumptions(assumption_id)
);

-- STEP 15: Generate initial forecast
SET SQL_SAFE_UPDATES = 0;

DELETE FROM forecast_revenue;

INSERT INTO forecast_revenue (
    fiscal_year,
    forecast_revenue_usd,
    assumption_id,
    forecast_method
)
WITH RECURSIVE forecast_series AS (
    SELECT
        2025 AS fiscal_year,
        CAST(revenue_usd AS DECIMAL(20,2))
            AS forecast_revenue_usd
    FROM annual_financials
    WHERE fiscal_year = 2025

    UNION ALL

    SELECT
        fiscal_year + 1,
        CAST(
            forecast_revenue_usd *
            (
                1 + (
                    SELECT annual_growth_rate
                    FROM forecast_assumptions
                    WHERE assumption_id = 1
                )
            )
            AS DECIMAL(20,2)
        )
    FROM forecast_series
    WHERE fiscal_year < 2028
)
SELECT
    fiscal_year,
    forecast_revenue_usd,
    1,
    'Three-year compounded growth baseline'
FROM forecast_series
WHERE fiscal_year BETWEEN 2026 AND 2028;

-- STEP 16: View initial forecast
SELECT
    f.fiscal_year,
    ROUND(f.forecast_revenue_usd / 1000000000, 3)
        AS forecast_revenue_usd_billions,
    a.assumption_name,
    a.annual_growth_rate,
    f.forecast_method
FROM forecast_revenue f
JOIN forecast_assumptions a
    ON f.assumption_id = a.assumption_id
ORDER BY f.fiscal_year;

-- STEP 17: Historical performance view
CREATE OR REPLACE VIEW vw_financial_performance AS
WITH yearly_data AS (
    SELECT
        *,
        LAG(revenue_usd) OVER (
            ORDER BY fiscal_year
        ) AS previous_year_revenue,
        LAG(operating_income_usd) OVER (
            ORDER BY fiscal_year
        ) AS previous_year_operating_income
    FROM annual_financials
)
SELECT
    fiscal_year,
    revenue_usd,
    gross_profit_usd,
    operating_income_usd,
    net_income_parent_usd,
    operating_cash_flow_usd,
    capex_usd,
    ROUND(revenue_usd / 1000000000, 3)
        AS revenue_billions,
    previous_year_revenue,
    revenue_usd - previous_year_revenue
        AS revenue_change_usd,
    ROUND(
        (revenue_usd - previous_year_revenue) * 100.0 /
        NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_growth_pct,
    ROUND(
        operating_income_usd * 100.0 /
        NULLIF(revenue_usd, 0),
        2
    ) AS operating_margin_pct,
    operating_income_usd - previous_year_operating_income
        AS operating_income_change_usd
FROM yearly_data;

-- STEP 18: Historical benchmark variance
SELECT
    fiscal_year,
    revenue_usd AS actual_revenue_usd,
    LAG(revenue_usd) OVER (
        ORDER BY fiscal_year
    ) * 1.0559 AS benchmark_revenue_usd,
    revenue_usd -
        LAG(revenue_usd) OVER (
            ORDER BY fiscal_year
        ) * 1.0559 AS variance_usd
FROM annual_financials
WHERE fiscal_year >= 2017
ORDER BY fiscal_year;

-- STEP 19: Compare existing figures with later filing figures
WITH official_values AS (
    SELECT
        2017 AS fiscal_year,
        36212000000 AS official_revenue_usd,
        22491000000 AS official_gross_profit_usd,
        7755000000 AS official_operating_income_usd
    UNION ALL
    SELECT
        2018,
        34300000000,
        21233000000,
        9152000000
)
SELECT
    a.fiscal_year,
    a.revenue_usd AS current_revenue_usd,
    o.official_revenue_usd,
    a.revenue_usd - o.official_revenue_usd
        AS revenue_difference_usd,
    a.gross_profit_usd AS current_gross_profit_usd,
    o.official_gross_profit_usd,
    a.operating_income_usd AS current_operating_income_usd,
    o.official_operating_income_usd
FROM annual_financials a
JOIN official_values o
    ON a.fiscal_year = o.fiscal_year
ORDER BY a.fiscal_year;
