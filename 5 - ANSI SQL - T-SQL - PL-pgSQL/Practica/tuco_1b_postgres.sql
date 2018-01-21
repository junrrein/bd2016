select * from titles

-- Ejercicio 1
select title_id, title, type, price * 1.08
	from titles 
	order by type, title;

-- Ejercicio 2
select title_id, title, type, price * 1.08 as "precio actualizado"
	from titles 
	order by type, title;

-- Ejercicio 3
select title_id, title, type, price * 1.08 as "precio actualizado"
	from titles 
	order by "precio actualizado" desc;

-- Ejercicio 4
select title_id, title, type, price * 1.08 as "precio actualizado"
	from titles
	order by 4 desc;

-- Ejercicio 5
select * from employee;

select lname || ', ' || fname as "listado autores"
	from employee
	order by 1;

-- Ejercicio 6
select title_id || ' posee un valor de $' || cast(price as varchar)
	from titles;

-- Ejercicio 7
select title_id || ' posee un valor de $' || price::varchar
	from titles;

-- Ejercicio 10
select title, price
	from titles
	where price <= 13;

-- Ejercicio 11
select lname, hire_date 
	from employee
	where hire_date between '01/01/1991' and '01/01/1992';

-- Ejercicio 12
select au_id, address, city
	from authors
	where au_id not in ('172-32-1176', '238-95-7766');

-- Ejercicio 11 - Nuevo
select title_id, title
	from titles
	where title like '%Computer%';

-- Ejercicio 12 - Nuevo
select pub_name, city, state
	from publishers
	where state is null;

SELECT COUNT (DISTINCT type)
	FROM titles;

-- Ejercicio 13 - Nuevo
select COUNT(price) as "Publicaciones con precio", COUNT(*) as "Total de publicaciones"
	from titles;
	
-- Ejercicio 14 - Nuevo
select COUNT(distinct price)
	from titles;
	
-- Ejercicio 15 - Nuevo
select MAX(hire_date)
	from employee;
	
select lname, fname
	from employee
	where hire_date = '01-05-1994 00:00:00.000';
	
-- Ejercicio 16 - Nuevo
select SUM(price * ytd_sales) as "Total ventas"
	from titles;
	
-- Ejercicio 17 - Nuevo
select sum(qty) as "Cantidad de ventas en Junio"
	from sales
	where date_part('month', ord_date) = 6;

SELECT cast(hire_date as varchar)
	FROM Employee;
	
Select substring(title, 5, 4)
	from titles;

SELECT cast(price as varchar)
	from titles;