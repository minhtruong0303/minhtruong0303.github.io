select * from human_resouce.action
select * from human_resouce.employee
select * from human_resouce.performance


--- 1. Find work time employees who work in company so far
--- s1.Find ppl working in company so far
--- s2.Find work time of employees
--- s3.Result

with y as (
    select * from human_resouce.employee
    where str_to_date(TermDt, '%d/%M/%Y') > curdate()
    ),
    t as (
select
    *,(datediff( curdate(),str_to_date(EngDt,'%d/%m/%Y')))/365 as Work_time
from y
group by Work_time
order by Work_time)

select * from t
group by Work_time
order by Work_time  desc
hehe

--- 2.write a query to get people who are born on a given date
select EmpID, EmpName, DOB  from human_resouce.employee
where DOB = '11/Mar/1965'

--- 3.write a query to get people who are born between 2 given dates
select EmpID, EmpName, str_to_date(dob,'%d/%M/%Y') as DOB2  from human_resouce.employee
where str_to_date(dob,'%d/%M/%Y')  between '2001/01/01' and   '2002/01/01'

--- 4.write a query to get people who are born the same day & month excluding the year
with cte as (
    select EmpID, EmpName, str_to_date(dob, '%d/%M/%Y') as dob2 from human_resouce.employee
    )
select * from cte
where day(DOB2) =  '08' and month(DOB2) =  '10'

--- 5.write a query to get people who are born in a given year
with cte as (
    select EmpID, EmpName, str_to_date(dob, '%d/%M/%Y') as dob2 from human_resouce.employee
    )
select * from cte
where year(DOB2) ='2002'

--- 6.write a query to get all last name who start with a given letter with like operator
select EmpID, Empname from human_resouce.employee
where EmpName like 'T%'

--- 7.write a query to get all last name who start with a given letter without like operator
select EmpID, Empname from human_resouce.employee
where left(EmpName,1) = 'T'

--- 8.Caculate avarage rating of employees for each gender

select  E.GenderID,
        avg(p.rating)
from human_resouce.employee as E
left join human_resouce.performance as P
on E.EmpID = P.EmpID
group by E.GenderID

--- List out all employees whose rating is 5 and have more than 3 years



