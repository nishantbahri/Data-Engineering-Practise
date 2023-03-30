
-- Please write a SQL query based on the below table to return
-- count of people whose grandparent is alive.

#  create table parent_status
#
# (
#
# Person Varchar(20),
#
# Parent Varchar(20),
#
# Status Varchar(20)
#
# );

# INSERT INTO parent_status values('A','X','Alive');
#
# INSERT INTO parent_status values('B','Y','Dead');
#
# INSERT INTO parent_status values('X','X1','Alive');
#
# INSERT INTO parent_status values('Y','Y1','Alive');
#
# INSERT INTO parent_status values('X1','X2','Alive');
#
# INSERT INTO parent_status values('Y1','Y2','Dead');
#
# select * from parent_status;
#
# EXPECTED O/P
# A
#

select * from parent_status;
select count(*) from parent_status person
inner join parent_status parent on person.Parent = parent.Person
inner join parent_status grandparent on parent.Parent = grandparent.Person
where lower(grandparent.Status) = 'alive';



