-- Comopanys
-------------------------------------------------------------------------
select
    p.account as parent_company,
    p.revenue as parent_revenue,
    s.account as subsidiary,
    s.revenue as subsidiary_revenue,

    p.revenue + sum(s.revenue) over (partition by p.account)
        as total_revenue,

    s.revenue * 100.0 /
        nullif(p.revenue + sum(s.revenue) over (partition by p.account), 0)
        as contribution_pct

from dbo.accounts p
join dbo.accounts s
    on s.subsidiary_of = p.account

union all

select
    a.account,
    a.revenue,
    null,
    null,
    a.revenue,
    0
from dbo.accounts a
where a.subsidiary_of is null
  and not exists (
      select 1
      from dbo.accounts c
      where c.subsidiary_of = a.account
  )

order by contribution_pct desc;

-------------------------------------------------------------------------
-------------------------------------------------------------------------
select
    account,
    product,
    sum(close_value) as [Total revenue],
    sum(sum(close_value)) over (partition by account) as totally,
    round(sum(close_value) * 100.0
          / nullif(sum(sum(close_value)) over (partition by account), 0), 2) as PCT
FROM sales_pipeline
GROUP BY account, product
HAVING sum(close_value) IS NOT NULL;

-------------------------------------------------------------------------
-------------------------------------------------------------------------
with CTE as(
select account ,YEAR(max(close_date))+1 as [last_year] from sales_pipeline
group by account
),CTE2 as(

select a.account,
	a.revenue,
	a.year_established,
	b.last_year,
	(b.last_year-a.year_established) as [Ages]
from accounts a join CTE b
on a.account = b.account
)
select
	account,
 	year_established,
	last_year,
	[Ages],
	Round((revenue/Ages),2) as [Avg Revenue]
from CTE2
order by [Avg Revenue] desc
-- saler and Managers

--top 10 Salers ---------------------------------------------------------
-------------------------------------------------------------------------
with targets as (
select S.sales_agent,S.deal_stage,S.close_value,P.sales_price from sales_pipeline S left join products P
on S.product=p.product
),total as(
select  
	sales_agent,
	sum(Close_value) as Total_revenue,
	sum(sales_price) as Targets,
	count(*) total_orders
From targets
where deal_stage ='Won'
group by sales_agent
),Ranking as (
select *,
DENSE_RANK()over(order by Total_revenue desc,total_orders desc ) as RK from total
)
select * from Ranking
where RK <=10

--Bottom 10 Salers ------------------------------------------------------
-------------------------------------------------------------------------
with targets as (
select S.sales_agent,S.deal_stage,S.close_value,P.sales_price from sales_pipeline S left join products P
on S.product=p.product
),total as(
select  
	sales_agent,
	sum(Close_value) as Total_revenue,
	sum(sales_price) as Targets,
	count(*) total_orders
From targets
where deal_stage ='Won'
group by sales_agent
),Ranking as (
select *,
DENSE_RANK()over(order by Total_revenue,total_orders ) as RK from total
)
select * from Ranking
where RK <=10

-- Top 10 By Target PCT--------------------------------------------------
-------------------------------------------------------------------------
with targets as (
    select S.sales_agent, S.close_value, P.sales_price
    from sales_pipeline S
    left join products P on S.product = P.product
    where S.deal_stage = 'Won'
),
total as (
    select
        sales_agent,
        sum(close_value) as Total_revenue,
        sum(sales_price) as Targets
    from targets
    group by sales_agent
),
PCT as (
    select *,
        (Total_revenue - Targets) * 100.0 / Targets as pct
    from total
),
Ranking as (
    select *,
        dense_rank() over(order by PCT Desc) as RK
    from PCT
)
select sales_agent, Total_revenue, Targets, pct, RK
from Ranking
where RK <= 10
order by RK;

-- Bottom 10 -------------------------------------------------------------
--------------------------------------------------------------------------
with targets as (
    select S.sales_agent, S.close_value, P.sales_price
    from sales_pipeline S
    left join products P on S.product = P.product
    where S.deal_stage = 'Won'
),
total as (
    select
        sales_agent,
        sum(close_value) as Total_revenue,
        sum(sales_price) as Targets
    from targets
    group by sales_agent
),
PCT as (
    select *,
        (Total_revenue - Targets) * 100.0 / Targets as pct
    from total
),
Ranking as (
    select *,
        dense_rank() over(order by PCT ) as RK
    from PCT
)
select sales_agent, Total_revenue, Targets, pct, RK
from Ranking
where RK <= 10
order by RK;
---------------------------------------------------------------------------
with teamat as(
    select b.manager, a.sales_agent, a.close_value, c.sales_price
    from sales_pipeline a
    left join sales_teams b on a.sales_agent = b.sales_agent
    left join products c on a.product = c.product
    where a.deal_stage = 'Won'
),
total as(
    select manager,
           sum(close_value) as Total_revenue,
           sum(sales_price) as Targets,
           count(distinct sales_agent) as Agents
    from teamat
    group by manager
),
metrics as(
    select *,
           Total_revenue * 1.0 / Agents as Rev_per_agent,
           (Total_revenue - Targets) * 100.0 / Targets as pct
    from total
),
Ranking as(
    select *,
           dense_rank() over(order by PCT desc) as RK
    from metrics
)
select * from Ranking
order by RK;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
with teamat as(
    select b.manager, a.deal_stage
    from sales_pipeline a
    left join sales_teams b on a.sales_agent = b.sales_agent
)
select
    coalesce(manager, 'Unknown') as manager,
    count(case when deal_stage = 'Lost' then 1 end)        as total_lost,
    count(case when deal_stage = 'Engaging' then 1 end)    as total_engaging,
    count(case when deal_stage = 'Prospecting' then 1 end) as total_prospecting,
    count(case when deal_stage in ('Lost','Engaging','Prospecting') then 1 end) as Total
from teamat
group by manager
order by Total desc;
-- industry & location

-------------------------------------------------------------------------
-------------------------------------------------------------------------
SELECT 
    a.office_location,
    COUNT(DISTINCT a.account) AS total_companies,
    SUM(TRY_CAST(sp.close_value AS FLOAT)) AS total_revenue
FROM accounts a LEFT JOIN sales_pipeline sp ON a.account = sp.account
GROUP BY a.office_location
ORDER BY total_revenue DESC;

-------------------------------------------------------------------------
-------------------------------------------------------------------------
SELECT 
    a.sector AS industry_sector,
    COUNT(DISTINCT a.account) AS company_count,
    SUM(TRY_CAST(sp.close_value AS FLOAT)) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(TRY_CAST(sp.close_value AS FLOAT)) DESC) AS industry_rank
FROM accounts a
LEFT JOIN sales_pipeline sp ON a.account = sp.account
GROUP BY a.sector
ORDER BY industry_rank;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
SELECT 
    a.account,
    a.sector AS industry,
    a.office_location,
    AVG(DATEDIFF(day, TRY_CAST(sp.engage_date AS DATE), TRY_CAST(sp.close_date AS DATE))) AS avg_days_to_close,
    SUM(TRY_CAST(sp.close_value AS FLOAT)) AS total_won_revenue
FROM accounts a
JOIN sales_pipeline sp ON a.account = sp.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.account, a.sector, a.office_location
ORDER BY total_won_revenue DESC;