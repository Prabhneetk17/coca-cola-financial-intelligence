# Coca-Cola Financial Planning, Forecasting & Variance Intelligence

An end-to-end financial analytics project focused on analysing historical financial performance, building revenue forecasts, investigating financial variances, and communicating insights through an interactive dashboard.

## Project Overview

This project analyses Coca-Cola's historical financial performance and develops a structured revenue forecasting and variance analysis framework.

The objective is to demonstrate how financial data can be transformed into meaningful business insights to support financial planning, performance monitoring, and decision-making.

The project combines financial data analysis, SQL-based data preparation, Excel modelling, and dashboard development.

## Business Problem

A finance team needs a consolidated view of business performance to understand:

- How has revenue evolved over time?
- What are the historical financial performance trends?
- How do actual results compare with relevant benchmarks?
- What does a forward-looking revenue scenario indicate?
- How can financial information be presented in a clear and decision-oriented format?

This project addresses these questions through historical analysis, forecasting, variance analysis, and visual reporting.

## Tools & Technologies

| Tool | Application |
|---|---|
| Microsoft Excel | Financial data analysis, calculations, reconciliation and modelling |
| MySQL 8 | Data preparation, SQL analysis, transformations and views |
| Power BI | Preparation of datasets for business intelligence reporting |
| HTML, CSS and JavaScript | Interactive financial dashboard |
| Chart.js | Dashboard visualisations |

## Project Components

### 1. Financial Data Analysis — Excel

The Excel workbook contains the financial analysis and supporting calculations used throughout the project.

Key activities include:
- Historical financial performance analysis
- Data reconciliation
- Financial calculations and comparisons
- Revenue forecasting support
- Variance analysis

### 2. SQL Analysis — MySQL

SQL was used to structure and analyse the financial datasets.

The repository includes scripts covering:

- Database setup and exploration
- Performance analysis and forecasting
- Variance analysis and reconciliation
- Reconciled analysis and forecast updates
- Power BI dataset exports

The SQL workflow also creates reporting views used to prepare datasets for downstream visualisation.

### 3. Revenue Forecasting

A revenue forecast was developed for FY2026–FY2028 using a 5.53% annual growth assumption.

The assumption is based on the geometric mean of the observed annual revenue growth rates for FY2022–FY2025.

| Financial Year | Forecast Revenue (USD) |
|---|---:|
| FY2026 | 50,592,137,300.00 |
| FY2027 | 53,389,882,492.69 |
| FY2028 | 56,342,342,994.54 |

These figures represent a model-based scenario, not Coca-Cola's official management guidance or published financial forecast.

### 4. Interactive Financial Dashboard

The project includes an HTML dashboard designed to communicate financial performance and forecast insights.

The dashboard provides a visual interface for exploring the financial analysis and forecast outputs.

To view it:
1. Download `Coca_Cola_Financial_Intelligence_Dashboard.html`.
2. Open the file in a modern web browser.
3. Ensure an internet connection is available for externally hosted dashboard libraries and fonts.

### 5. Power BI Data Preparation

Three datasets were exported from MySQL for use in Power BI:

- `coca_cola_historical_performance.csv`
- `coca_cola_historical_variance.csv`
- `coca_cola_revenue_forecast.csv`

These datasets provide separate analytical layers for historical performance, variance analysis, and revenue forecasting.

## Repository Contents

| File | Description |
|---|---|
| `CocaCola_Financial_Analysis_FINAL.xlsx` | Financial analysis workbook |
| `Coca_Cola_Financial_Intelligence_Dashboard.html` | Interactive HTML dashboard |
| `DATABASE SETUP AND EXPLORATION.sql` | Database creation and exploration |
| `PERFORMANCE ANALYSIS AND FORECASTING.sql` | Performance analysis and forecasting |
| `POWER BI EXPORT DATASETS.sql` | SQL reporting views and dataset exports |
| `RECONCILED ANALYSIS AND FORECAST UPDATE.sql` | Reconciliation and forecast updates |
| `VARIANCE ANALYSIS AND RECONCILIATION.sql` | Variance analysis |
| `coca_cola_historical_performance.csv` | Historical performance dataset |
| `coca_cola_historical_variance.csv` | Historical variance dataset |
| `coca_cola_revenue_forecast.csv` | Revenue forecast dataset |

## Data Sources & Methodology

The analysis is based on publicly available Coca-Cola financial information, including company annual reports and SEC filings.

Financial figures are organised into historical datasets and used for analytical calculations, reconciliation, and forecasting.

Where historical comparative figures have been revised in subsequent company filings, the later comparative figures are used in the reviewed analysis.

The forecast is an independent analytical exercise based on historical growth. It should not be interpreted as an official company projection.

## Important Limitations

- Forecast outputs depend on the stated growth assumption and are not guaranteed future results.
- Historical financial information is subject to the definitions and reporting conventions used in the source filings.
- The HTML dashboard uses externally hosted libraries and therefore requires an internet connection for all visual elements to load.
- The CSV files are prepared analytical outputs; they do not provide a live connection to the MySQL database.
- The repository does not currently include a Power BI `.pbix` report file.

## Project Objective

The goal of this project is to demonstrate practical financial analytics skills across data preparation, SQL querying, financial modelling, forecasting, reconciliation, and visual communication.

## Dashboard Preview

### 1. Financial Dashboard Overview
<img width="1920" height="1080" alt="01-dashboard-overview png" src="https://github.com/user-attachments/assets/1a2ea9b2-0948-418e-b99b-b0a2071b778c" />


### 2. Financial Analytics
<img width="1920" height="1080" alt="02-financial-analytics png" src="https://github.com/user-attachments/assets/7b7ed3ae-33da-4c1a-b691-11e225820be4" />

### 3. Financial Statements
<img width="1920" height="1080" alt="03-financial-statements png" src="https://github.com/user-attachments/assets/369d1f02-886f-4c67-9079-0537f1fe7cf4" />

### 4. Executive Insights & Data Quality
<img width="1920" height="1080" alt="04-executive-insights png" src="https://github.com/user-attachments/assets/abfc5e26-4af2-4b1f-8262-46e6eacdc587" />

**Author:** Prabhneet Kaur  
**GitHub:** [Prabhneetk17](https://github.com/Prabhneetk17)
