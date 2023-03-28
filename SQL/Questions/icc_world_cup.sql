
/*

 create table icc_world_cup

(

Team_1 Varchar(20),

Team_2 Varchar(20),

Winner Varchar(20)

);

INSERT INTO icc_world_cup values('India','SL','India');

INSERT INTO icc_world_cup values('SL','Aus','Aus');

INSERT INTO icc_world_cup values('SA','Eng','Eng');

INSERT INTO icc_world_cup values('Eng','NZ','NZ');

INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;


 */




show tables ;

with distinct_team_names as (

SELECT DISTINCT team_1 as team_name from icc_world_cup

union

SELECT DISTINCT team_2 as team_name from icc_world_cup

),

winners as (select * from distinct_team_names

left join icc_world_cup on icc_world_cup.Winner = distinct_team_names.team_name

)

SELECT team_name, count(*) as matches_played,

sum(case when team_name = Winner then 1 else 0 end) as no_of_wins,

sum(case when team_name = Winner then 0 else 1 end) as no_of_losses

from winners

group by team_name;