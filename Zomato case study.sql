use Zomato;
--  count number of orders.
select count(*) from orders;

--  replicated sample function from pandas
select * from order_details 
order by rand()
limit 5;

--  To find the NULL values
select * from orders where restaurant_rating is null;
-- To replace NULL values with 0
 UPDATE orders SET restaurant_rating = 0 
 WHERE restaurant_rating IS NULL;

-- Find  num of orders placed by each customer.
select t1.user_id,t1.name,count(*) as num_orders from users t1
join orders t2 on t1.user_id=t2.user_id
group by t1.user_id;

-- find restaurants with most no of menu items.
select t1.r_id,t1.r_name,count(*) 'num of items' from restaurants t1
join menu t2
on t1.r_id=t2.r_id
group by t1.r_id;

-- no of votes and avg rating for all restaurants.
select t1.r_id,t1.r_name,count(*) as num_votes, round(avg(delivery_rating)) as rating from restaurants t1
join orders t2 on
t1.r_id=t2.r_id
group by t1.r_id;

-- find the food being sold at most num of restaurants.
select t1.f_id,t2.f_name,count(*) as qty_sold from  menu t1 
join food t2 on t2.f_id=t1.f_id
group by t1.f_id
order by qty_sold desc limit 1;

-- find restaurant with max revenue in given mnth.(may).
select t2.r_name,sum(t1.amount) as revenue from orders t1
join restaurants t2 on t1.r_id=t2.r_id
where monthname(date)="May"
group by t1.r_id
order by revenue desc limit 1;

-- find restaurants with sales>1500.
select t1.r_name,sum(t2.amount) as revenue from restaurants t1
join orders t2 on t1.r_id=t2.r_id
group by t1.r_id
having revenue >1500;

-- month on month revenue of kfc.
select t1.r_name,monthname(t2.date),sum(t2.amount)as revenue from restaurants t1
join orders t2 on t1.r_id=t2.r_id
where t1.r_name="kfc"
group by month(t2.date)
order by month(t2.date) ;

-- find customers who never ordered.
SELECT user_id,name from users t1 
where user_id not in (select user_id from orders);

-- show order details of a particular customer in a given date range.
select t1.name,t2.order_id,t2.date,t2.amount,t4.f_name from users t1
join orders t2 on t1.user_id=t2.user_id
join order_details t3 on t2.order_id=t3.order_id
join food t4 on t3.f_id=t4.f_id
where t1.name='Nitish' and  date between '2022-05-01' and '2022-06-01'
order by date(date);

-- customer fav food.
with user_order_counts as(
select t1.user_id,t3.f_id,t3.f_name,count(*) as num_orders from orders t1
join order_details t2 on t1.order_id=t2.order_id
join food t3 on t2.f_id=t3.f_id
group by t1.user_id,t3.f_id,t3.f_name),
user_rank as (select user_id,f_id,f_name,rank() over(partition by user_id order by num_orders desc) as rnk
from user_order_counts)

select t1.user_id,t1.name,t2.f_name as fav_food from users t1
join user_rank t2 on t1.user_id=t2.user_id and rnk=1;

-- find most costly restaurants (avg price/dish).
select t1.r_name,round((sum(price)/count(*))) as avg_price_per_dish from restaurants t1
join menu t2
on t1.r_id=t2.r_id
group by t1.r_id
order by avg_price_per_dish desc limit 1;

-- find delivery partner compensation  as salary using formula (# deliveries *100 + 1000*avg_rating).
select t1.partner_name,count(*) as num_orders,round((count(*)*100+1000*avg(t2.delivery_rating))) as salary 
from delivery_partner t1
join orders t2 on t1.partner_id=t2.partner_id
group by t1.partner_id;

-- find revenue per month for a restaurant.
select t1.r_name,monthname(date) as mnth,sum(amount) as revenue from restaurants t1
join orders t2 on t1.r_id=t2.r_id
where t1.r_id=2
group by month(date)
order by month(date);

-- find all only  veg restaurants.
select t3.r_name from food t1
join menu t2 on t1.f_id=t2.f_id
join restaurants t3 on t2.r_id=t3.r_id
group by t2.r_id
having min(type)='Veg' and max(type)='Veg';

-- find min , max and avg  order value for all customers.
select t1.name,min(amount) as minimum,max(amount) as maximum,avg(amount) as avgerage  from users t1
join orders t2
on t1.user_id=t2.user_id
group by t1.user_id;




