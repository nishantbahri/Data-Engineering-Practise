# Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
# Create table Users (users_id int, banned varchar(50), role varchar(50));
# Truncate table Trips;
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
# insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
# Truncate table Users;
# insert into Users (users_id, banned, role) values ('1', 'No', 'client');
# insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
# insert into Users (users_id, banned, role) values ('3', 'No', 'client');
# insert into Users (users_id, banned, role) values ('4', 'No', 'client');
# insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
# insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
# insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
# insert into Users (users_id, banned, role) values ('13', 'No', 'driver');


select * from Trips;
-- (id, client_id, driver_id, city_id, status, request_at)
select * from Users;
-- (users_id, banned, role)

with unbanned_cancel as (

    select t.*
    from Trips t
    inner join Users c on t.client_id = c.users_id
    inner join Users d on t.driver_id = d.users_id
    where c.banned = 'No' and d.banned = 'No'

)
select request_at, sum(case when status like '%can%' then 1 else 0 end) as cancelled_trips,
       count(*) as total_trips,
       round(1.0 *  sum(case when status like '%can%' then 1 else 0 end) / count(*) * 100,2) as canceleld_percent
from unbanned_cancel
group by 1;
