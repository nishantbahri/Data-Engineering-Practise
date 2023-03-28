
/* create table customer_orders (
 order_id integer,
# customer_id integer,
# order_date date,
# order_amount integer
# );
# select * from customer_orders;
# insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
# ,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
# ,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
# ;

 */

-- Creating the first order data for every customers for comparision
with first_orders as (
select  customer_id, min(order_date) as first_visit_date
FROM customer_orders
group by 1)

-- Joined on the basis of customer_id and checkin if it is first purchase or not
select
    total_order.order_date,
    SUM(case when (total_order.order_date = first_order.first_visit_date) then 1 else 0 end) as new_customer_count,
    SUM(case when (total_order.order_date != first_order.first_visit_date ) then 1 else 0 end) as repeat_customer_count,
    SUM(case when (total_order.order_date = first_order.first_visit_date) then order_amount else 0 end) as new_customer_amount,
    SUM(case when (total_order.order_date != first_order.first_visit_date) then order_amount else 0 end) as repeat_customer_amount
from customer_orders total_order
left join first_orders first_order on total_order.customer_id = first_order.customer_id
group by 1;