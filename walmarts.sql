create database project;
use project;
#Table visualization
select * from walmart;
# Disinct Branch
select distinct branch
from walmart;
#customer type
select distinct `customer type`
from walmart;
#product line
select distinct `product line`
from walmart ;
#payment
select distinct payment
from walmart;
#1.Transactions by product line
select `Product line`,count(1) no_of_transactions
from walmart
group by `Product line`
order by no_of_transactions desc;
#2.Top 3 product lines 
with cte as(
select `Product line`,count(1) no_of_transactions
from walmart
group by `Product line`
order by no_of_transactions desc),
cte1 as(
select `Product line`,no_of_transactions,rank() over(order by `no_of_transactions` desc) ranking
from cte)
select `Product line`,no_of_transactions,ranking
from cte1
where ranking<=3;
#3.Transactions using payment mode

select Payment,count(1)no_of_transactions
from walmart
group by Payment
order by no_of_transactions desc;

#4.gender wise transactions
select Gender,count(1)no_of_transactions
from walmart
group by Gender;

#5.city and branch wise transaction
SELECT 
    City,
    Branch,
    COUNT(1) AS no_of_transactions
FROM walmart
GROUP BY City, Branch
ORDER BY no_of_transactions DESC;

#6.calculate the total sales and number of transactions for each product line and city.
select * from walmart;
select City,`Product line`,count(*) transaction_count,round(sum(Total)) total_sales
from walmart
group by City,`Product line`
order by City;

#7.Find the average gross margin percentage by City
select city,round(avg(`gross income`),2) avg_gross_income
from walmart
group by city
order by avg_gross_income desc;

#8.Average sales by customer type
select * from walmart;
select `customer type`,round(avg(Total),2) avg_sales
from walmart
group by `customer type`
order by avg_sales desc;

# 9.Find the Average Rating by Gender for Each Product Line
select `Product line`,round(avg(Rating),1) avg_rating
from walmart
group by `Product line`
order by avg_rating desc;
#. Identify Peak Transaction Hours

#10.Find the hour of the day with the highest number of transactions for each branch.
with cte as(
select branch,hour(time) hour_of_day,count(*) no_of_transaction
from walmart
group by branch,hour_of_day
order by branch,no_of_transaction desc),
cte1 as(
select *,dense_rank()over(partition by branch order by no_of_transaction desc) hour_rank,
100*no_of_transaction/sum(no_of_transaction) over (partition by branch) transaction_percentage
from cte)
select *,
case when hour_rank=1 then "Peak_hour"
     when hour_rank<=3 then "Top 3 busy hours"
     else "Off peak hours"
     end as Hour_category
from cte1;

#11.Calculate the total number of transactions per day for each product line, and identify trends.


UPDATE walmart
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

select `Product line`,`Date`,count(*) no_of_transactions
from walmart
group by `Product line`,`Date`
order by `Product line`,`Date`;

#12.Top Selling Product Lines by Branch
#Determine the most popular product lines in each branch.
select * from walmart;

With cte as (SELECT 
    Branch,
    `Product line`,
    COUNT(*) AS no_of_transactions
FROM walmart
GROUP BY Branch, `Product line`
ORDER BY Branch,no_of_transactions desc),
cte1 as (
select branch,`Product line`,no_of_transactions,rank() over(partition by Branch order by no_of_transactions desc) ranking
from cte)
select branch,`Product line`
from cte1
where ranking=1;

