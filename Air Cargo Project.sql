create database air_cargo;
create table if not exists routes (
    Route_id              tinyint      primary key,
    Flight_num            smallint     not null,
    Origin_airport        char(3)      not null,
    Destination_airport   char(3)      not null,
    Aircraft_id           varchar(15)  not null,
    Distance_miles        smallint     not null,
    constraint check_miles check (distance_miles > 0),
    constraint check_flight_num check (flight_num > 0)
);

create table if not exists customer (
    customer_id      tinyint       primary key,
    first_name       varchar(30)  not null,
    last_name        varchar(30)   not null,
    date_of_birth    date          not null,
    gender           char(1)
);

create table if not exists ticket_details (
    p_date          date   not null,
    customer_id     tinyint  not null references customer(customer_id),
    aircraft_id     varchar(20)   not null,
    class_id        varchar(20)   not null,
    no_of_tickets   tinyint       not null,
    a_code          char(3)       not null,
    price_per_ticket  smallint    not null,
    brand             varchar(30)  not null
);

select
	*
from
    passengers_on_flights
where
    route_id between 1 and 25
order by route_id, customer_id;

select count(*) from ticket_details;

select
    count(*) as 'Number of Passengers',
    sum(price_per_ticket) as 'Total Revenue'
from
    ticket_details
where
    class_id = 'Bussiness';
    
select
    concat(first_name, '',last_name) as "Full Name"
from
    customer;
    
select * from customer c
where exists (select 1 from ticket_details t
where t.customer_id = c.customer_id)
order by customer_id;

select c.first_name, c.last_name
from customer c
where exists (select 1 from ticket_details t
where t.customer_id = c.customer_id and
   brand = 'Emirates');
   
select customer_id, count(customer_id) as 'Number of Travels'
from passengers_on_flights
where class_id = 'Economy Plus'
group by customer_id
having count(customer_id) >=1;
   
select if(sum(no_of_tickets * price_per_ticket) > 10000,
    'Yes, Revenue crossed 10000','No, Revenue has not crossed 10000') as Result
from
   ticket_details;
   
create user 'acuser'@'localhost' identified by '<password>';
grant all privileges on ac.* to 'acuser'@'localhost';

select
    class_id,
    price_per_ticket,
    max(price_per_ticket) over(partition by class_id) as Maximum_price
from
    ticket_details;
    
select 
    customer_id
from
    passengers_on_flights
where route_id=4;

explain analyze select  * from passengers_on_flights where route_id = 4;

select
    customer_id,
    aircraft_id,
    sum(no_of_tickets * price_per_ticket) 'Total Price'
from
    ticket_details
group by
    customer_id, aircraft_id with rollup;
    
create view bussiness_class as
select 
	customer_id, brand 
from
    ticket_details
where
    class_id = 'Bussiness';
select * from bussiness_class;

select c.customer_id, c.first_name, c.last_name,
        f.route_id
from passengers_on_flights f
inner join customer c on
    c.customer_id = f.customer_id
where f.route_id between 10 and 15
order by route_id;

DELIMITER &&
 CREATE PROCEDURE get_total_passengers_()
 BEGIN
 DECLARE total_passengers INT DEFAULT 0;
 SELECT COUNT(*) into total_passengers FROM passengers_on_flights;
 SELECT total_passengers;
 END &&


select flight_num, sum(distance_miles) as total_miles,
    case
       when sum(distance_miles) <= 2000 then "SDT"
       when sum(distance_miles) <= 6500 then "MDT"
	   else
           "LDT"
	end as distance_desc
 from routes
 group by flight_num;
 
select p_date, customer_id, class_id,
	case
       when class_id = 'Business'
       or class_id = 'Economy Plus' THEN 'YES' 
       else 'NO'
 end as Complimentary_Service
 from
    ticket_details
    order by customer_id;
    
select *
from
   customer 
where
   last_name = 'Scott';
          







