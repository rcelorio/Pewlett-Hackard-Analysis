-- SQL Queries for challenge submission

-- creates table number_of_titles_with_dupes 
select ri.emp_no, ri.first_name, ri.last_name, t.title, t.from_date, s.salary
into number_of_titles_with_dupes
from retirement_info ri
    inner join titles t
    on ri.emp_no = t.emp_no
    inner join salaries s
    on ri.emp_no = s.emp_no

-- Remove dupes by partinioning on employee first and last then select the first row number of the partition usint CTE
with UN as (SELECT emp_no, first_name, last_name, title, from_date, salary, 
     ROW_NUMBER() OVER 
		(PARTITION BY (first_name, last_name) ORDER BY from_date DESC) rn
   FROM public.number_of_titles_with_dupes		  
            ) 

SELECT un.emp_no, un.first_name, un.last_name, un.title, un.from_date, un.salary, tcount.count
into number_of_titles_without_dupes 
FROM UN
-- join the count of employees with the same title on title 
  inner join (Select un.title, count(un.title) as count from UN group by un.title) tcount
  on UN.title = tcount.title
WHERE 
  rn = 1
  
 ORDER BY from_date DESC;
  