-- previous month sale, next month sale, ytd sale for every state

CREATE TABLE SALES (
CITY text,
YEAR INT,
MONTH INT,
SALES INT
);

drop table SALES;
INSERT INTO SALES  VALUES
('Delhi',2020, 5,4300),
('Delhi',2020, 6,6300),
('Delhi',2020, 7,8400),
('Delhi',2020, 8,1060),
('Delhi',2020, 9,1250),
('Delhi',2020, 10,1270),
('Delhi',2020, 11,1000),
('Delhi',2020, 12,1000),
('MUMBAI',2020, 5,1270);

select * from SALES;

select *
, LAG(SALES) over (PARTITION BY CITY ORDER BY YEAR,MONTH ) AS prev_month_sale
, LEAD(SALES) over (PARTITION BY CITY ORDER BY YEAR,MONTH ) AS next_month_sale
, sum(SALES) over (PARTITION BY CITY ORDER BY YEAR,MONTH ) AS ytd_sales
from SALES;