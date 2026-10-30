
-- COCA-COLA FINANCIAL ANALYSIS
-- TAB 2: EXPLORATORY AND FINANCIAL ANALYSIS
-- STEPS 7-12

USE coca_cola_financials;

-- STEP 7: Historical financial data
SELECT *
FROM annual_financials
ORDER BY fiscal_year;

-- STEP 8: Revenue analysis from FY2020 onward
SELECT
    fiscal_year,
    revenue_usd,
    ROUND(revenue_usd / 1000000000, 3) AS revenue_billions
FROM annual_financials
WHERE fiscal_year >= 2020
ORDER BY fiscal_year;

-- STEP 9: Revenue growth analysis
SELECT
    fiscal_year,
    revenue_usd,
    LAG(revenue_usd) OVER (
        ORDER BY fiscal_year
    ) AS previous_year_revenue,
    ROUND(
        (
            revenue_usd -
            LAG(revenue_usd) OVER (ORDER BY fiscal_year)
        ) * 100.0 /
        NULLIF(
            LAG(revenue_usd) OVER (ORDER BY fiscal_year),
            0
        ),
        2
    ) AS revenue_growth_pct
FROM annual_financials
ORDER BY fiscal_year;

-- STEP 10: Operating margin analysis
SELECT
    fiscal_year,
    revenue_usd,
    operating_income_usd,
    ROUND(
        operating_income_usd * 100.0 /
        NULLIF(revenue_usd, 0),
        2
    ) AS operating_margin_pct
FROM annual_financials
ORDER BY fiscal_year;

-- STEP 11: Revenue movement classification
WITH revenue_movement AS (
    SELECT
        fiscal_year,
        revenue_usd,
        LAG(revenue_usd) OVER (
            ORDER BY fiscal_year
        ) AS previous_year_revenue
    FROM annual_financials
)
SELECT
    fiscal_year,
    revenue_usd,
    previous_year_revenue,
    CASE
        WHEN revenue_usd > previous_year_revenue
            THEN 'Revenue Increased'
        WHEN revenue_usd < previous_year_revenue
            THEN 'Revenue Decreased'
        ELSE 'No Change'
    END AS revenue_status
FROM revenue_movement
ORDER BY fiscal_year;

-- STEP 12: Data quality checks
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT fiscal_year) AS unique_years,
    MIN(fiscal_year) AS first_year,
    MAX(fiscal_year) AS last_year,
    SUM(CASE WHEN revenue_usd IS NULL THEN 1 ELSE 0 END)
        AS missing_revenue,
    SUM(CASE WHEN gross_profit_usd IS NULL THEN 1 ELSE 0 END)
        AS missing_gross_profit,
    SUM(CASE WHEN operating_income_usd IS NULL THEN 1 ELSE 0 END)
        AS missing_operating_income,
    SUM(CASE WHEN revenue_usd <= 0 THEN 1 ELSE 0 END)
        AS nonpositive_revenue
FROM annual_financials;

-- Check duplicate years
SELECT
    fiscal_year,
    COUNT(*) AS year_count
FROM annual_financials
GROUP BY fiscal_year
HAVING COUNT(*) > 1;
