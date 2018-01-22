-- Ejercicio 1
select au_lname, au_fname, title
from authors
inner join titleauthor
	on authors.au_id = titleauthor.au_id
inner join titles
	on titleauthor.title_id = titles.title_id
order by au_lname

-- Ejercicio 2
select pub_name, fname || ' ' || lname as "empleados" , job_lvl
from employee
inner join publishers 
	on employee.pub_id = publishers.pub_id
where job_lvl > 200

-- Ejercicio 3
select au_lname, au_fname, sum(qty*price) as "ingresos"
from sales s
inner join titles t
	on s.title_id = t.title_id
inner join titleauthor ta
	on ta.title_id = t.title_id
inner join authors a
	on ta.au_id = a.au_id
group by au_lname, au_fname  
order by "ingresos" desc

-- Ejercicio 4
select type
from titles
group by type 
having avg(price) > 12

-- Ejercicio 5
select fname, lname
from employee
where hire_date = (select max(hire_date)
					from employee)

-- Ejercicio 6.1 
select pub_name
from publishers p
where exists (select *
				from titles t
				where t.pub_id = p.pub_id and
					t.type = 'business')

select distinct(pub_name)
from publishers p
inner join titles t
	on p.pub_id = t.pub_id
where t.type = 'business'

-- Ejercicio 7
SELECT title 
FROM titles left JOIN sales
ON titles.title_id = sales.title_id
WHERE date_part('year', sales.ord_date) NOT IN (1993, 1994) OR 
		sales.ord_date is null

select title
from titles t
where t.title_id not in (select s.title_id 
							from sales s
							where date_part('year', s.ord_date) in (1993,1994)) 

-- Ejercicio 8
select title, pub_name, price
from titles t
inner join publishers p 
	on t.pub_id = p.pub_id
where price < (select avg(price)
				from titles t2
				where t2.pub_id = p.pub_id )


-- Ejercicio 9
select	au_fname as "nombre",
		au_lname as "apellido",
		case contract
			when 1 then 'si'
			when 0 then 'no'
		end as "posee contrato?"
from authors 


-- Ejercicio 10
select  lname,
		case 
			when job_lvl < 100 then 'puntaje menor que 100'
			when job_lvl > 200 then 'puntaje mayor que 200'
			else 'puntaje entre 100 y 200'
		end		
from employee
