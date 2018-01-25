-- Ejercicio 1


CREATE OR REPLACE FUNCTION test
  ()
  RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE apellido VARCHAR(40) :='pepe';
BEGIN
  RETURN (SELECT apellido IS NULL);
END;
$$;

SELECT test();

-- Ejemplo 2

CREATE OR REPLACE FUNCTION PublicacionesBusiness(pub_id1 CHAR(4))
  RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE type1 CHAR(12);
BEGIN
  type1 := 'business';
  IF NOT EXISTS(SELECT *
                FROM titles
                WHERE pub_id = pub_id1)
  THEN RETURN TRUE;
  ELSE
    IF 1 <= (SELECT COUNT(*)
             FROM titles
             WHERE pub_id = pub_id1 AND type = type1)
    THEN RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END IF;
END;
$$;

SELECT PublicacionesBusiness('0877')

-- Ejercicio 4

CREATE OR REPLACE FUNCTION informarPrecio
  ()
  RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS
$$
DECLARE
  precio  MONEY;
  mensaje VARCHAR(100) := 'pepino';
BEGIN
  precio := (SELECT price
             FROM titles
             WHERE title_id = 'BU1111');
  mensaje := 'El precio es ' ||
             (CASE
              WHEN precio > 10 :: MONEY
                THEN 'mayor a 10'
              WHEN precio = 10 :: MONEY
                THEN 'igual a 10'
              ELSE 'menor a 10'
              END);
  PERFORM *
  FROM titles;
  RETURN mensaje;
END;
$$;

SELECT informarPrecio();
