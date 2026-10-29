# CRM Sales Pipeline Analysis

Who is missing the target? An interactive Power BI dashboard built on CRM sales and opportunities data. Data prepared with SQL.


## Business Question

Total sales reached **10M**, but the team finished **-4M (-27.5%)** below target. Where does the gap come from?

## Key Findings

- Every manager finished below target.
- **Dustin Brinkmann** had the widest gap: **-55%**.
- High sales do not mean target achieved. **Vicki Laflamme** is #2 in sales but missed her target by 154K.
- Only 4 of the top 10 salespeople beat their target. **Darcel Schlecht** led with **+40%**.
- A percentage gap (Gap %) is fairer than a value gap. Targets are not equal across people.

## Tools

- **SQL**: data cleaning and preparation
- **Power BI**: data modeling, DAX, dashboard design
- **Canva**: dashboard backgrounds

## Data Model

Star schema with `sales_pipeline` as the fact table.

| Table | Role |
|---|---|
| sales_pipeline | Fact: deals, close_date, close_value, deal_stage |
| accounts | Dimension: companies, sector, employees, revenue, location |
| products | Dimension: product, series, sales_price |
| sales_teams | Dimension: sales_agent, manager, regional_office |


## Dashboard Pages

| Page | What it shows |
|---|---|
| Home | Cover and navigation |
| Accounts | Client companies, avg deal value, revenue by country |
| Sectors | Company age vs deal value, revenue by sector |
| Salespeople | Top/Bottom 10 by sales, orders, and Gap |
| Managers | Gap by manager, sales vs target over time |

Every page has slicers: account, sector, product, manager, sales_agent.

## Main DAX Measures

```DAX
Total Sales = SUM( sales_pipeline[close_value] )

Gap = [Total Sales] - [Total Target]

Gap % = DIVIDE( [Gap], [Total Target] )
```

## Screenshots

## Repository Structure

```
├── README.md
├── sql/            # SQL cleaning scripts
├── data/           # dataset (or link to source)
├── images/         # dashboard screenshots
└── CRM_Dashboard.pbix
```

## How to Use

1. Download `CRM_Dashboard.pbix`.
2. Open it in Power BI Desktop.
3. If asked, point the data source to the files in `/data`.

## Authors
Ahmed Gamal |
Mahmoud Abdelnaser |
Ahmed Ashraf
