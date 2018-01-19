use pubs
select * from titles

-- Ejercicio 1
select title_id, title, type, price * 1.08
	from titles 
	order by type, title

-- Ejercicio 2
select title_id, title, type, price * 1.08 'precio actualizado'
	from titles 
	order by type, title

-- Ejercicio 3
select title_id, title, type, price * 1.08 'precio actualizado'
	from titles 
	order by 'precio actualizado' desc

-- Ejercicio 4
select title_id, title, type, price * 1.08 'precio actualizado'
	from titles 
	order by 4 desc

-- Ejercicio 5
select * from employee

select lname + ', ' + fname 'listado autores' 
	from employee
	order by 1

-- Ejercicio 7
select title_id + ' posee un valor de $' + convert(varchar,price) 
	from titles

-- Ejercicio 8
sp_help

-- Ejercicio 9
sp_help 'authors'

-- Ejercicio 10
select title, price
	from titles
	where price <= 13

-- Ejercicio 11
select lname, hire_date 
	from employee
	where hire_date between '01/01/1991' and '01/01/1992'

-- Ejercicio 12
select au_id, address, city
	from authors
	where au_id not in ('172-32-1176', '238-95-7766')

