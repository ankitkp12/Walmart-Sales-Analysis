use pizza_sales_project;

-- total no of orders
select count(*) as total_no_of_orders 
from orders;

-- total revenue
select round(sum(od.quantity * p.price)) as total_revenue from order_details od
join pizza p
on od.pizza_id = p.pizza_id;

-- avg orders in a day
select round(count(order_id) / count(distinct date)) as avg_orders_in_a_day
from orders;

-- avg pizzas in an orders
select round(count(order_id) / count(distinct order_id)) as avg_pizzas_in_an_orders
from order_details;

-- sales by month
select monthname(date) as month,count(order_id) as total_pizza_ordered
from orders
group by monthname(date);

-- most preferred pizza size
select p.size,count(order_id) as total_orders from order_details od
join pizza p
on od.pizza_id = p.pizza_id
group by p.size
order by count(order_id) desc;

-- most preferred pizza category
with cte as
(
	select pt.category,count(od.order_id) as total_orders
	from order_details od
	join pizza p
	on od.pizza_id = p.pizza_id
	join pizza_types pt
	on p.pizza_type_id = pt.pizza_type_id
	group by pt.category
)
select category,concat(round((total_orders / sum(total_orders) over()) * 100,2),'%') as pct
from cte;

-- which days of the week are most likely busy 
select dayname(date) as day,count(order_id) as total_pizza_ordered 
from orders
group by dayname(date)
order by count(order_id) desc;

-- top 5 pizzas
select pt.category,pt.name,sum(od.quantity * p.price) as total_sales
from order_details od
join pizza p
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category,pt.name
order by sum(od.quantity * p.price) desc
limit 5;

-- bottom 5 pizzas
select pt.category,pt.name,round(sum(od.quantity * p.price),2) as total_sales
from order_details od
join pizza p
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category,pt.name
order by sum(od.quantity * p.price) asc
limit 5;

-- what are the peak hours
with cte as 
(
	select *,
	case
	when time(order_time) between '09:00:00'and '11:59:59' then '9-12 AM'
	when time(order_time) between '12:00:00'and '14:59:59' then '12-3 PM'
	when time(order_time) between '15:00:00'and '17:59:59' then '3-6 PM'
	when time(order_time) between '18:00:00'and '20:59:59' then '6-9 PM'
	else '9-12 PM' 
	end as time_slot 
	from orders
)
select time_slot,count(order_id) as total_orders
from cte
group by time_slot;
































