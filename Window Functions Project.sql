--Window Functions ( row_number, rank, dense_rank)

create table Employe
(EmpID int,
EmpName varchar(20),
EmpSalary int)

insert into Employe values
(1,'Atul',5000),
(3,'atul',8000),
(4,'atul',10000),
(7,'ramkumar',1000),
(8,'Rohit',4000),
(6,'rohit',20000),
(5,'taj',10000),
(2,'taj',600)

Truncate Table Employe

select *
from Employe


select EmpID, EmpName as EmpName, EmpSalary, row_number() over(order by EmpName) as rownumber
from Employe
--Result rownumber: 1-2-3-4-5-6-7-8

select EmpID, EmpName as EmpName, EmpSalary, rank() over(order by EmpName) as rank_
from Employe
--Result rank_ 1,1,1,4,5,5,7,7

select EmpID, EmpName as EmpName, EmpSalary, dense_rank() over(order by EmpName) as denserank
from Employe
--Result denserank 1,1,1,2,3,3,4,4


--rownumber,rank,denserank must have over and order by clause. Partition by is not necessary.
select EmpID, EmpName as EmpName, EmpSalary, row_number() over(order by EmpSalary) as rownumber
from Employe

--difference between rownumber and rank. EmpSalary has two 10000. Rownumber ignore it(6,7) . It is written like 6,6 by Rank. Then it continues with 8.
select EmpID, EmpName as EmpName, EmpSalary, rank() over(order by EmpSalary) as rank_
from Employe

--difference between rank and dense_rank. EmpSalary has two 10000. It is written like 6,6 by DenseRank. Then it continues with 7**.
select EmpID, EmpName as EmpName, EmpSalary, dense_rank() over(order by EmpSalary) as denserank
from Employe



--Every query has same results.

-- Rownumber starts "1" for each empname, orders according to salary asc or desc., increase 1 by 1.
select EmpID, EmpName as EmpName, EmpSalary, row_number() over(partition by EmpName order by EmpSalary) as rownumber
from Employe

-- Rank starts "1" for each empname, orders according to salary asc or desc., increase 1 by 1.
select EmpID, EmpName as EmpName, EmpSalary, rank() over(partition by EmpName order by EmpSalary) as rank_
from Employe

-- Denserank starts "1" for each empname, orders according to salary asc or desc., increase 1 by 1.
select EmpID, EmpName as EmpName, EmpSalary, dense_rank() over(partition by EmpName order by EmpSalary) as denserank
from Employe

/* 
unbounded preceding, unbounded following
unbounded preceding: belirlenen aral??ktaki ilk sat??r
unbounded following: Belirlenen aral??ktaki son sat??r
current_row:
preceding: ??nceki
following
*/

SELECT EmpID,EmpName,EmpSalary, first_value(empID) over( partition by EmpName order by EmpSalary asc rows between unbounded preceding and unbounded following ) as FV
from employe
--first group by EmpName, order by asc EmpSalary and proceeding all rows. 
--??nce empname e g??re gruplar, grubu empsalary e g??re s??ralar(asc) sonra t??m sat??rlar i??in i??lem yapar.

SELECT EmpID,EmpName,EmpSalary, first_value(empID) over( partition by EmpName order by EmpSalary asc rows between current row and unbounded following ) as FV
from employe
--proceeding between the corrent row and the other rows which located current rows below.
--mevcuttaki sat??r ve sonras?? i??in i??lem yapar.

SELECT EmpID,EmpName,EmpSalary, first_value(empID) over( partition by EmpName order by EmpSalary asc rows between current row and 1 following ) as FV
from employe
--??nce empname e g??re gruplar, grubu empsalary e g??re s??ralar(asc) ve mevcuttaki sat??r ve 1 sonras?? i??in first value ??al??????r.

--LAG AND LEAD 

--LAG: SHOW PREVIOUS VALUE ACCORDING TO PARTITION AND ORDERS.
SELECT PROD_ID, SALES_YEAR, SALES_AMOUNT, LAG(SALES_AMOUNT) OVER(PARTITION BY PROD_ID ORDER BY SALES_YEAR) AS PREVIOUS
FROM SALES	

--LEAD: SHOW FOLLOWING VALUE ACCORDING TO PARTITION AND ORDERS.
SELECT PROD_ID, SALES_YEAR, SALES_AMOUNT, LEAD(SALES_AMOUNT) OVER(PARTITION BY PROD_ID ORDER BY SALES_YEAR ) AS FORWARD
FROM SALES

--LAG AND LEAD DON'T ALLOW WINDOW FRAME(UNBOUNDED PRECEDING FOLLOWING)
SELECT PROD_ID, SALES_YEAR, SALES_AMOUNT, LEAD(SALES_AMOUNT,2,0) OVER(PARTITION BY PROD_ID ORDER BY SALES_YEAR ) AS FORWARD
FROM SALES
--LEAD(SALES_AMOUNT,2,0) consider second value after current row, write 0 instead of NULL


--find median (0.5 MEDIAN,0.7 APPROX. LAST VALUE)
SELECT PROD_ID, SALES_YEAR, SALES_AMOUNT, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SALES_AMOUNT) OVER(PARTITION BY SALES_YEAR) AS median,
PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY SALES_AMOUNT) OVER(PARTITION BY SALES_YEAR) AS median
FROM SALES

--PERCENT_RANK
SELECT PROD_ID, SALES_YEAR, SALES_AMOUNT,
PERCENT_RANK() OVER (PARTITION by sales_year ORDER BY SALES_AMOUNT) AS PERRANK
FROM SALES
--ANSWER: FOR 2015 0,0.5,1
