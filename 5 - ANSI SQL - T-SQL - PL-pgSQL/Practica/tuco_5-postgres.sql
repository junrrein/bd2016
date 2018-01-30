-- Ejercicio 2
CREATE OR REPLACE FUNCTION act_precios()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  precio NUMERIC(10, 2);
    cur_precios CURSOR FOR SELECT price
                           FROM titles
                           WHERE pub_id = '0736';
BEGIN
  OPEN cur_precios;
  LOOP
    FETCH NEXT FROM cur_precios INTO precio;
    EXIT WHEN NOT FOUND;

    UPDATE titles
    SET price = CASE
                WHEN precio > 10
                  THEN precio * 0.75
                ELSE precio * 1.25
                END
    WHERE CURRENT OF cur_precios;
  END LOOP;
  CLOSE cur_precios;
END;
$$;

SELECT act_precios();
SELECT price
FROM titles
WHERE pub_id = '0736';

-- Ejercicio 4

CREATE OR REPLACE FUNCTION mostrar_autores()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  apellido         VARCHAR(40);
  ciudad_autor     VARCHAR(20);
  ciudad_editorial VARCHAR(20);

    cur_autor CURSOR FOR
    SELECT
      au_lname,
      city
    FROM authors;

    cur_editorial CURSOR FOR
    SELECT city
    FROM publishers;


BEGIN
  OPEN cur_autor;

  LOOP
    FETCH NEXT FROM cur_autor INTO apellido, ciudad_autor;
    EXIT WHEN NOT found;


    OPEN cur_editorial;
    LOOP
      FETCH NEXT FROM cur_editorial INTO ciudad_editorial;
      EXIT WHEN NOT found;

      IF ciudad_editorial = ciudad_autor
      THEN
        RAISE NOTICE 'El autor % reside en la misma ciudad que la editorial que lo edita', apellido;
      END IF;


    END LOOP;

    CLOSE cur_editorial;

  END LOOP;

  CLOSE cur_autor;
END;
$$;

SELECT mostrar_autores();

SELECT 'El autor ' || au_lname || ' reside en la misma ciudad que la editorial que lo edita'
FROM authors a
  INNER JOIN titleauthor ta ON a.au_id = ta.au_id
  INNER JOIN titles t ON ta.title_id = t.title_id
  INNER JOIN publishers p ON t.pub_id = p.pub_id
WHERE a.city = p.city;

select p.pub_id, sum(qty * price)
	from publishers p
		inner join titles t on p.pub_id = t.pub_id
		inner join sales s on t.title_id = s.title_id
	group by p.pub_id
	order by sum(qty * price);