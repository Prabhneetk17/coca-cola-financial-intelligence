-- COCA-COLA FINANCIAL ANALYSIS
-- TAB 5: POWER BI EXPORT DATASETS
-- STEP 28: Create historical performance dataset

USE coca_cola_financials;

CREATE OR REPLACE VIEW vw_powerbi_historical_performance AS

SELECT
    fiscal_year,
    revenue_usd,
    gross_profit_usd,
    operating_income_usd,
    net_income_parent_usd,
    total_assets_usd,
    current_assets_usd,
    current_liabilities_usd,
    parent_equity_usd,
    cash_usd,
    operating_cash_flow_usd,
    capex_usd,
    basic_eps_usd,
    diluted_eps_usd,
    dividends_per_share_usd,

    ROUND(
        (revenue_usd -
        LAG(revenue_usd) OVER (ORDER BY fiscal_year))
        / NULLIF(
            LAG(revenue_usd) OVER (ORDER BY fiscal_year), 0
        ) * 100,
        2
    ) AS revenue_growth_pct,

    ROUND(
        gross_profit_usd / NULLIF(revenue_usd, 0) * 100,
        2
    ) AS gross_margin_pct,

    ROUND(
        operating_income_usd / NULLIF(revenue_usd, 0) * 100,
        2
    ) AS operating_margin_pct,

    ROUND(
        net_income_parent_usd / NULLIF(revenue_usd, 0) * 100,
        2
    ) AS net_margin_pct

FROM annual_financials_reconciled;
SELECT *
FROM vw_powerbi_historical_performance
ORDER BY fiscal_year;
-- STEP 29: Retrieve historical performance dataset for Power BI

SELECT *
FROM vw_powerbi_historical_performance
ORDER BY fiscal_year;
-- STEP 30: Create Power BI revenue forecast dataset

CREATE OR REPLACE VIEW vw_powerbi_revenue_forecast AS

SELECT
    fiscal_year,
    forecast_revenue_usd,
    assumption_id,
    forecast_method
FROM forecast_revenue;
SELECT *
FROM vw_powerbi_revenue_forecast
ORDER BY fiscal_year;
-- STEP 31: Create Power BI historical variance dataset

CREATE OR REPLACE VIEW vw_powerbi_historical_variance AS

SELECT
    fiscal_year,
    revenue_usd,
    actual_growth_pct,
    benchmark_growth_pct,
    growth_variance_pct_points
FROM vw_historical_revenue_variance;
SELECT *
FROM vw_powerbi_historical_variance
ORDER BY fiscal_year;