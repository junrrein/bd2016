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

SELECT
  p.pub_id,
  sum(qty * price)
FROM publishers p
  INNER JOIN titles t ON p.pub_id = t.pub_id
  INNER JOIN sales s ON t.title_id = s.title_id
GROUP BY p.pub_id;

-- Ejercicio 6

CREATE OR REPLACE FUNCTION trasladarEmpleado()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  id_editorial       CHAR(4);
  ventas_editorial   NUMERIC(10, 2);
  id_mayor           CHAR(4);
  id_menor1          CHAR(4);
  id_menor2          CHAR(4);
  ventas_mayor       NUMERIC(10, 2) := 0;
  ventas_menor1      NUMERIC(10, 2) := 10000000;
  ventas_menor2      NUMERIC(10, 2) := 10000000;
  id_empleado        CHAR(9);
  fecha_contratacion DATE;
  id_viejo           CHAR(9);
  fecha_viejo        DATE := '1/1/2020';

    cur_editorial CURSOR FOR
    SELECT
      p.pub_id,
      sum(qty * price)
    FROM publishers p
      INNER JOIN titles t ON p.pub_id = t.pub_id
      INNER JOIN sales s ON t.title_id = s.title_id
    GROUP BY p.pub_id;

    cur_empleado CURSOR FOR
    SELECT
      emp_id,
      hire_date
    FROM employee
    WHERE pub_id IN (id_menor1, id_menor2) AND
          job_lvl = 100;
BEGIN
  OPEN cur_editorial;

  LOOP
    FETCH NEXT FROM cur_editorial INTO id_editorial, ventas_editorial;
    EXIT WHEN NOT found;

    IF ventas_editorial > ventas_mayor
    THEN
      ventas_mayor := ventas_editorial;
      id_mayor := id_editorial;
    END IF;

    IF ventas_editorial < ventas_menor1
    THEN
      ventas_menor2 := ventas_menor1;
      id_menor2 := id_menor1;
      ventas_menor1 := ventas_editorial;
      id_menor1 := id_editorial;
    ELSEIF ventas_editorial < ventas_menor2
      THEN
        ventas_menor2 := ventas_editorial;
        id_menor2 := id_editorial;
    END IF;
  END LOOP;

  CLOSE cur_editorial;

  --   RAISE NOTICE '%, %, %', id_mayor, id_menor1, id_menor2;

  OPEN cur_empleado;

  LOOP
    FETCH NEXT FROM cur_empleado INTO id_empleado, fecha_contratacion;
    EXIT WHEN NOT found;

    IF fecha_contratacion < fecha_viejo
    THEN
      id_viejo := id_empleado;
      fecha_viejo := fecha_contratacion;
    END IF;
  END LOOP;

  CLOSE cur_empleado;

  --   RAISE NOTICE '%, %', id_viejo, fecha_viejo;
  UPDATE employee
  SET pub_id = id_mayor
  WHERE emp_id = id_viejo;
END;
$$;

SELECT trasladarEmpleado();