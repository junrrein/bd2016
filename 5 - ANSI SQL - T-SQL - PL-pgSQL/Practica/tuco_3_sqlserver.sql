-- Ejercicio 1
select au_lname, au_fname, title
from authors
inner join titleauthor
	on authors.au_id = titleauthor.au_id
inner join titles
	on titleauthor.title_id = titles.title_id
order by au_lname

-- Ejercicio 2
