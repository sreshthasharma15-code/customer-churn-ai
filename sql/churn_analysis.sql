-- =========================================================
-- CUSTOMER CHURN ANALYSIS
-- SQL Server
-- =========================================================


-- =========================================================
-- SETUP
-- =========================================================

USE CustomerChurnDB;


-- =========================================================
-- DATA CHECKS
-- =========================================================

-- Check that the table exists and data was imported correctly
SELECT TOP 10 *
FROM TelcoChurn;


-- Check total number of customers
SELECT COUNT(*) AS TotalCustomers
FROM TelcoChurn;


-- Check the data type of columns
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TelcoChurn'
ORDER BY ORDINAL_POSITION;


-- =========================================================
-- BASIC CHURN ANALYSIS
-- =========================================================

-- Business Question:
-- How many customers have churned?

SELECT COUNT(*) AS ChurnedCustomers
FROM TelcoChurn
WHERE Churn = 1;


-- Business Question:
-- What is the overall churn rate?

-- Churn rate = Churned Customers / Total Customers × 100

SELECT (100.0* (select count(*) from TelcoChurn where Churn =1) / (select count(*) from TelcoChurn))
as ChurnRate;

-- See the number of churned and non-churned customers
SELECT
    Churn,
    COUNT(*) AS CustomerCount
FROM TelcoChurn
GROUP BY Churn;


-- =========================================================
-- CONTRACT ANALYSIS
-- =========================================================

-- Business Question:
-- How many customers belong to each contract type?

select Contract, count(*) as CustomerCount from TelcoChurn 
group by Contract;


-- How many customers churned within each contract type?
select Contract,
count(*) as totalCustomers,
sum(case when Churn =1 then 1 else 0 end )as CustomersChurned 
from TelcoChurn 
group by Contract;


-- Which contract type has more churned customers?
select Contract, count(*) as TotalCustomers, sum(case when Churn=1 then 1 else 0 end) as Churned
from TelcoChurn
group by Contract;

--What is the churn rate for each contract type?
select Contract,count(*) as TotalCustomers,sum(case when Churn=1 then 1 else 0 end) as ChurnedCustomers ,round((100.0*(sum(case when Churn=1 then 1 else 0 end))/count(*)),2) as ChurnRate 
from TelcoChurn 
group by Contract ;



--Does Internet Service have a similar relationship with churn?
select InternetService,
count(*) as TotalCustomers, 
sum(case when Churn = 1 then 1 else 0 end) as ChurnedCustomers,
round(100.0*sum(case when Churn =1 then 1 else 0 end)/count(*),2) as ChurnRate
from TelcoChurn
group by InternetService;


--Does the payment method have an effect on churn?
select PaymentMethod,count(*) as TotalCustomers, 
sum(case when Churn =1 then 1 else 0 end) as ChurnedCustomers, 
round(100*sum(case when Churn=1 then 1 else 0 end)/count(*),2) as ChurnRate
from TelcoChurn
group by PaymentMethod
order by ChurnRate desc;


--Which customers are at particularly high risk of churn?
select 
    Contract, 
    InternetService,
    count(*) as TotalCustomers,
    sum(case when Churn=1 then 1 else 0 end) as ChurnedCutomers,
    round(100.0*sum(case when Churn=1 then 1 else 0 end )/count(*),2) as ChurnRate
from TelcoChurn
group by Contract, InternetService
order by ChurnRate desc;

--How many customers are in these high-churn segments?
select 
    Contract, 
    InternetService,
    sum(case when Churn =1 then 1 else 0 end) as TotalChurn,
    round(100.0*sum(case when Churn = 1 then 1 else 0 end)/count(*),2) as ChurnRate
from TelcoChurn
group by Contract, InternetService
having 100.0*sum(case when Churn=1 then 1 else 0 end)/count(*)>40
order by ChurnRate desc;


--Does churn depend on how long a customer has been with the company?
select 
    case 
        when tenure <=12 then '0-12 months'
        when tenure <=24 then '13-24 months'
        when tenure <=36 then '25-36 months'
        when tenure <=48 then '37-48 months'
        when tenure <=60 then '49-60 months'
        else '61-72 months'
    end as TenureGroup,
count(*) as TotalCustomer,
sum(case when Churn =1 then 1 else 0 end) as ChurnedCustomers,
cast (100.0*sum(case when Churn=1 then 1 else 0 end)/count(*) as decimal(5,2)) as ChurnRate
from TelcoChurn
group by 
case 
    when tenure <=12 then '0-12 months'
    when tenure <=24 then '13-24 months'
    when tenure <=36 then '25-36 months'
    when tenure <=48 then '37-48 months'
    when tenure <=60 then '49-60 months'
    else '61-72 months'
end
order by ChurnRate DESC;



--Which payment methods are associated with the highest churn?
select PaymentMethod,
count(*) as totalCustomers,
sum(case when Churn =1 then 1 else 0 end) as ChurnedCustomers,
cast( 100.0*sum(case when Churn=1 then 1 else 0 end)/count(*)     
as decimal(5,2)) as ChurnRate
from TelcoChurn
group by PaymentMethod
order by ChurnRate desc;
--Business finding: Electronic check customers have by far the 
--highest churn at 45.29%, more than twice the churn rate of 
--mailed-check customers (19.11%).



--Do support services relate to lower churn?
--Does having customer support and security services together relate to lower churn?
select TechSupport, OnlineSecurity, count(*) as TotalCustomers,
sum(case when Churn=1 then 1 else 0 end) as Churned,
cast( 100.0*sum(case when Churn=1 then 1 else 0 end)/count(*)   as decimal(5,2)) as ChurnRate
from TelcoChurn
group by OnlineSecurity, TechSupport
order by ChurnRate desc;
--Customers with neither Tech Support nor Online Security have a 48.96% churn rate
--That's a 39.95 percentage-point difference btwn those who have non and those who have both



--Does the combination of contract type and payment method identify an especially high-risk group?
select  Contract , PaymentMethod, count(*) as totalCustomers,
sum(case when Churn=1 then 1 else 0 end) as ChurnedCustomers,
cast (100.0 * sum(case when Churn=1 then 1 else 0 end)/count(*)  as decimal(5,2)) as ChurnRate
from TelcoChurn
group by Contract, PaymentMethod
order by ChurnRate desc;
--Month-to-month + Electronic check → 53.73% churn

--customer-level risk profile:
--How many customers fall into multiple high-risk characteristics at once?
with CustomerRisk as
(
    select 
        customerID,
        Churn,
        (
            case when Contract ='Month-to-month' then 1 else 0 end +
            case when InternetService = 'Fiber optic' then 1 else 0 end +
            case when PaymentMethod = 'Electronic check' then 1 else 0 end +
            case when OnlineSecurity= 'No' then 1 else 0 end +
            case when TechSupport= 'No' then 1 else 0 end +
            case when tenure <=12 then 1 else 0 end
        ) as RiskFactorCount
    from TelcoChurn
) 

select 
    RiskFactorCount ,
    count(*) as TotalCustomers,
    sum(case when Churn = 1 then 1 else 0 end) as ChurnedCustomers,
    cast(100.0*sum(case when Churn=1 then 1 else 0 end)/count(*)   as decimal(5,2))  as ChurnRate
from CustomerRisk
group by RiskFactorCount
order by RiskFactorCount;
--Customers accumulating multiple high-risk characteristics are dramatically more likely to churn




-- =========================================================
-- KEY FINDINGS
-- =========================================================

/*
1. Overall churn rate:
   26.54% of customers have churned.

2. Contract type:
   Month-to-month customers have 42.71% churn,
   compared with 2.83% for two-year contracts.

3. High-risk segment:
   Month-to-month + Fiber optic customers have
   the highest segment churn at 54.61%.

4. Payment method:
   Electronic check customers have 45.29% churn,
   substantially higher than other payment methods.

5. Support and security services:
   Customers with neither Tech Support nor Online Security
   have 48.96% churn, compared with 9.01% for customers
   with both services.

6. Combined risk:
   Churn increases sharply as customers accumulate
   observed churn-associated characteristics:
   1.92% with 0 risk factors vs. 74.45% with all 6.

Business takeaway:
Customers with multiple observed churn-associated
characteristics represent the highest-priority segments
for targeted retention strategies.
*/











