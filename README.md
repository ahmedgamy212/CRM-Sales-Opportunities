# CRM + Sales + Opportunities

A Power BI dashboard and SQL analysis project for exploring company accounts, sales pipeline performance, and sales-team results.

## Project files

- **`file.pbix`** — Power BI report with an embedded data model and five report pages.
- **`SQLQuery1.sql`** — SQL Server queries for company, product, opportunity, salesperson, manager, industry, and location analysis.

## Power BI report

The report is organized into these pages:

- **Home** — navigation and overview of salesperson performance against targets.
- **Accounts** — account revenue and employee metrics, company-value comparisons, location map, and account/sector/product/manager/salesperson filters.
- **Sectors and Deals** — sector comparisons, company value, and deal-related analysis.
- **Managers** — manager-level sales performance and trends over time.
- **Salespeople** — salesperson revenue comparisons and performance metrics.

Open `file.pbix` with Microsoft Power BI Desktop to explore the report. Slicers and report navigation are included in the dashboard.

## SQL analysis

`SQLQuery1.sql` contains standalone queries covering:

- Parent companies and subsidiaries, including combined revenue and subsidiary contribution.
- Product revenue and each product's share of an account's total.
- Account average revenue by years since establishment.
- Top and bottom salespeople by won revenue and order count.
- Top and bottom salespeople by revenue versus summed product-price targets.
- Manager performance, revenue per agent, and deal-stage counts.
- Revenue by office location and industry-sector rankings.
- Average time from engagement to close and won revenue by account.

### Running the queries

Run the statements in `SQLQuery1.sql` in a SQL Server-compatible environment with access to the project schema. The queries expect these tables and columns:

- `dbo.accounts` — account, subsidiary, revenue, establishment year, sector, and office location data.
- `sales_pipeline` — account, product, salesperson, deal stage, close value, engagement date, and close date data.
- `products` — product and sales price data.
- `sales_teams` — salesperson and manager assignments.

The script uses SQL Server functions and syntax, including `YEAR`, `DATEDIFF`, `TRY_CAST`, CTEs, and window functions. Adjust schema names or column names if your database uses a different structure.

## Notes

The PBIX file includes the report and its embedded Power BI model. The SQL script is provided separately for querying a compatible SQL Server database; no separate SQL database or source-data export is included in this repository.
