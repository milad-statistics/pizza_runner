--a1.how many pizzas were ordered?
select count(pizza_id) from customer_orders;
--a2.how many unique customers orders were made?
select count(distinct order_id) from customer_orders;
--a3.how many successful orders were delivered by each runner?
select runner_id,count(duration_mins) from runner_orders
group by runner_id
order by count desc;
--a4.how many of each type of pizza was delivered?
select pizza_id,count(duration_mins) from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
group by pizza_id
order by pizza_id;
--a5.how many vegetarian and meatlovers were ordered by each customer?
select customer_id,count(pizza_name) filter(where pizza_name='Meatlovers') as meatlovers_count,
count(pizza_name) filter(where pizza_name='Vegetarian') as vegetarian_count from customer_orders co
join pizza_names pn on co.pizza_id=pn.pizza_id
group by customer_id
order by customer_id;
--a6.what was the maximum number of pizzas delivered in a single order?
select co.order_id,count(pizza_id) from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
where cancellation is null
group by co.order_id
order by count desc
limit 1;
--a7.for each customer how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id,
count(*) filter(where exclusions is not null or extras is not null) as count_of_changed_pizzas,
count(*) filter(where exclusions is null and extras is null) as count_of_no_changed_pizzas 
from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
where cancellation is null
group by customer_id
order by customer_id;
--a8.how many pizzas were delivered that had both exclusions and extras?
select count(*) filter(where exclusions is not null and extras is not null) as pizza_that_had_both 
from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
where cancellation is null;
--a9.what was the total volume of pizzas ordered for each hour of the day?
select extract(hour from order_time ) as hour_of_the_day,count(pizza_id) from customer_orders
group by extract(hour from order_time )
order by hour_of_the_day;
--a10.what was the volume of orders for each day of the week?
select extract(dow from order_time) as day_of_the_week,count(distinct order_id) from customer_orders
group by day_of_the_week
order by day_of_the_week;
--b1.how many runners signed up for each 1 week period?
with cte as(
select *,(registration_date-date '2021-01-01')/7 as week_number from runners)
select week_number+1 as week_number,count(runner_id) as runner_count from cte
group by week_number
order by week_number;
--b2.what was the average time in minutes it took for each runner to arrive at the pizza runner hq to pickup
--the order?
select avg(pickup_time-order_time) from customer_orders co
join runner_orders ro on co.order_id=ro.order_id;
--b3.is there any relationships between the number of pizzas and how long the order takes to prepare?
with cte as(
select co.order_id,count(pizza_id),pickup_time-order_time as preperation_time from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
group by co.order_id,ro.pickup_time,co.order_time)
select corr(count,extract(epoch from preperation_time)/60) from cte;
--b4.what was the average distance travelled for each customer?
with cte as(
select customer_id,co.order_id,round(avg(distance_km),2) from customer_orders co
join runner_orders ro on co.order_id=ro.order_id
group by customer_id,co.order_id
order by customer_id)
select customer_id,round(avg(round),1) from cte
group by customer_id;
--b5.what was the difference between the longest and the shortest delivery times for all orders?
select max(duration_mins)-min(duration_mins) as range_of_duration from runner_orders;
--b6.what was the average speed for each runner for each delivery and do you notice any trends for these values?
select *,round(distance_km/duration_mins,2) as speed_km_over_mins from runner_orders ro
join runners r on ro.runner_id=r.runner_id
where cancellation is null
order by speed_km_over_mins;
--b7.what is the successful delivery percentage for each runner?
select runner_id,count(duration_mins)*100/count(runner_id) as delivery_success_rate from runner_orders
group by runner_id
order by runner_id;
--c1.what are the standard ingredients for each pizza?
select * from pizza_recipes;
--c2.what was the most commonly added extra?
with cte as(
select *,unnest(string_to_array(extras,', ')) from customer_orders)
select unnest,count(unnest) from cte
group by unnest
order by count desc;
--c3.what was the most common exclusion?
with cte as(
select *,unnest(string_to_array(exclusions,', ')) exclusions_exploded from customer_orders)
select exclusions_exploded,count(exclusions_exploded) from cte
group by exclusions_exploded
order by count desc;










































