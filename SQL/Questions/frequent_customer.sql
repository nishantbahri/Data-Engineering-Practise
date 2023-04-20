# CREATE TABLE SALES_FQ (
# ORDER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
# CUSTOMER_ID INT,
# SALARY NUMERIC(10,2),
# ORDER_DATE DATETIME
# );
#
# INSERT INTO SALES_FQ
# (ORDER_ID, CUSTOMER_ID, SALARY, ORDER_DATE) VALUES
# (10001,90001, 10000, '2022-02-01 09.00.00'),
# (10002,90001, 10000, '2022-02-03 09.00.00'),
# (10003,90001, 10000, '2022-02-07 09.00.00'),
# (10004,90001, 20000, '2022-02-09 09.00.00'),
# (10005,90001, 20000, '2022-02-14 09.00.00'),
# (10006,90001, 10000, '2022-02-14 09.00.00'),
# (10007,90001, 10000, '2022-02-17 09.00.00'),
# (10009,90001, 80000, '2022-02-21 09.00.00'),
# (100020,90001, 10000, '2022-02-23 09.00.00'),
# (100021,90001, 10000, '2022-02-28 09.00.00'),
#
# (10010,90002, 10000, '2022-02-01 09.00.00'),
# (10013,90002, 30000, '2022-02-09 09.00.00'),
# (10014,90002, 10000, '2022-02-14 09.00.00'),
# (10015,90002, 10000, '2022-02-14 09.00.00'),
# (10016,90002, 70000, '2022-02-17 09.00.00'),
# (10017,90002, 10000, '2022-02-21 09.00.00'),
# (10019,90002, 10000, '2022-02-28 09.00.00');

# 5.  Definition of Frequent Customer:
#     A Customer who has transacts on the platform atleast once in every 5 days since last transaction

with SALES_FQ_HISTORY AS (
SELECT ORDER_ID ,CUSTOMER_ID, SALARY,ORDER_DATE
       , lag(ORDER_DATE) over (partition by CUSTOMER_ID order by ORDER_DATE asc) as previous_order_date
FROM SALES_FQ)

, sales_fq_flag as (
                SELECT *, DATEDIFF(ORDER_DATE,previous_order_date) AS frequent_customer_flag
FROM SALES_FQ_HISTORY
    )

select distinct customer_id from sales_fq_flag where frequent_customer_flag <=5;


-- b.	Evaluate cumulative sum of salary for each customer in ascending order of ORDER_DATE

SELECT ORDER_ID ,CUSTOMER_ID, SALARY,ORDER_DATE
       , sum(SALARY) over (partition by CUSTOMER_ID order by ORDER_DATE,ORDER_ID ) as cum_sum
FROM SALES_FQ

-- c.	Order IDs which constitute Top 80 percentile basis Order_Value
with order_percentile as (
SELECT ORDER_ID ,CUSTOMER_ID, SALARY,ORDER_DATE
        , sum(SALARY) over (order by SALARY ) as running_sum
        , sum(SALARY) over () as total_sum
        , 0.8 * sum(SALARY) over () as eighty_percentile_sum
FROM SALES_FQ
)
select distinct order_id
from order_percentile
where running_sum  <= eighty_percentile_sum

-- d . Create a coupon_flag which becomes active on alternate transactions, signifying
-- availability of coupon. Assume coupon_flag is 1 (Active) on first transaction, find
-- number of days an offer was valid for each customer.

-- id  day      flag
-- 101 1st march 1
-- 101 2nd march 1
-- 101 3rd march 1

WITH alternate_orders_rank AS (
SELECT * , ROW_NUMBER() over (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS rn
FROM  SALES_FQ
)
SELECT *, CASE WHEN rn % 2 = 0 then 0 else 1 end as coupon_flag
FROM alternate_orders_rank;




