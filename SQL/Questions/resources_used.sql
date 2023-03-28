create table entries (
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')

insert into entries
values
('C','Bangalore','C@gmail.com',1,'MONITOR')

select * from entries;

-- total vists in office
with total_vists as (
    select
    name,
    floor,
    count(*) as no_of_floor_visit,
    rank() over (partition by name order by count(*) desc) as rn
from entries
group by 1,2
),
most_floor as (
select name,floor as most_visited_floor
from total_vists tv
where tv.rn = 1
),
result as (
  select mf.name,mf.most_visited_floor,count(1) as total_vists
from entries e
left join most_floor mf on e.name = mf.name
group by 1,2
)
select result.*,
    concat(',',resources)
from result
inner join entries on result.name = entries.name


