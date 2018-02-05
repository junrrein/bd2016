-- Ejercicio 1
SELECT
  au_lname,
  au_fname,
  title
FROM authors
  INNER JOIN titleauthor
    ON authors.au_id = titleauthor.au_id
  INNER JOIN titles
    ON titleauthor.title_id = titles.title_id
ORDER BY au_lname;

-- Ejercicio 2
SELECT
  pub_name,
  fname || ' ' || lname AS "empleados",
  job_lvl
FROM employee
  INNER JOIN publishers
    ON employee.pub_id = publishers.pub_id
WHERE job_lvl > 200;

-- Ejercicio 3
SELECT
  au_lname,
  au_fname,
  sum(qty * price) AS "ingresos"
FROM sales s
  INNER JOIN titles t
    ON s.title_id = t.title_id
  INNER JOIN titleauthor ta
    ON ta.title_id = t.title_id
  INNER JOIN authors a
    ON ta.au_id = a.au_id
GROUP BY au_lname, au_fname
ORDER BY "ingresos" DESC;

-- Ejercicio 4
SELECT type
FROM titles
GROUP BY type
HAVING avg(price) > 12;

-- Ejercicio 5
SELECT
  fname,
  lname
FROM employee
WHERE hire_date = (SELECT max(hire_date)
                   FROM employee);

-- Ejercicio 6.1 
SELECT pub_name
FROM publishers p
WHERE exists(SELECT *
             FROM titles t
             WHERE t.pub_id = p.pub_id AND
                   t.type = 'business');

SELECT DISTINCT (pub_name)
FROM publishers p
  INNER JOIN titles t
    ON p.pub_id = t.pub_id
WHERE t.type = 'business';

-- Ejercicio 7
SELECT title
FROM titles
  LEFT JOIN sales
    ON titles.title_id = sales.title_id
WHERE date_part('year', sales.ord_date) NOT IN (1993, 1994) OR
      sales.ord_date IS NULL;

SELECT title
FROM titles t
WHERE t.title_id NOT IN (SELECT s.title_id
                         FROM sales s
                         WHERE date_part('year', s.ord_date) IN (1993, 1994));

-- Ejercicio 8
SELECT
  title,
  pub_name,
  price
FROM titles t
  INNER JOIN publishers p
    ON t.pub_id = p.pub_id
WHERE price < (SELECT avg(price)
               FROM titles t2
               WHERE t2.pub_id = p.pub_id);

-- Ejercicio 9
SELECT
  au_fname AS "nombre",
  au_lname AS "apellido",
  CASE contract
  WHEN 1
    THEN 'si'
  WHEN 0
    THEN 'no'
  END
           AS "posee contrato?"
FROM authors;

-- Ejercicio 10
SELECT
  lname,
  CASE
  WHEN job_lvl < 100
    THEN 'puntaje menor que 100'
  WHEN job_lvl > 200
    THEN 'puntaje mayor que 200'
  ELSE 'puntaje entre 100 y 200'
  END
FROM employee
