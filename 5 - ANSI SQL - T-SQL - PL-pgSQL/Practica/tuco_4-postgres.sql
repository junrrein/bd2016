-- Ejercicio 1

CREATE OR REPLACE FUNCTION test
  ()
  RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE apellido VARCHAR(40);
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

SELECT PublicacionesBusiness('0877');

-- Ejercicio 4

CREATE OR REPLACE FUNCTION informarPrecio
  ()
  RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS
$$
DECLARE
  precio  MONEY;
  mensaje VARCHAR(100);
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

-- Ejercicio 9
-- Cree una función PL/pgSQL (sp_VerVenta) que obtenga la fecha de venta para
-- aquellas ventas para las que se especifique el código de almacén ( stor_id), número de orden
-- y cantidad. Ejecútela para los siguientes parámetros: código de almacén 7067, número de
-- orden P2121 y cantidad 40, primero especificados por posición (documentados) y luego por
-- nombre.

CREATE OR REPLACE FUNCTION VerVenta
  (
    cod_almacen CHAR(4),
    num_orden   VARCHAR(20),
    cantidad    SMALLINT
  )
  RETURNS DATE
LANGUAGE plpgsql
AS
$$
DECLARE
  fechaVenta DATE;
BEGIN
  SELECT ord_date
  INTO fechaVenta
  FROM sales
  WHERE stor_id = cod_almacen AND
        ord_num = num_orden AND
        qty = cantidad;

  RETURN fechaVenta;
END;
$$;

SELECT VerVenta('7067' :: CHAR(4), -- cod_almacen
                'P2121' :: VARCHAR(20), -- num_orden
                40 :: SMALLINT); -- cantidad

SELECT VerVenta(cod_almacen := '7067',
                num_orden := 'P2121',
                cantidad := 40 :: SMALLINT);

-- Ejercicio 15
-- En PostgreSQL, cree en pubs una tabla -llamada Editoriales- análoga a la tabla Publishers
-- en Pubs, pero únicamente con las columnas pub_id y pub_name y sin datos. Para la creación
-- de la estructura puede utilizar un Select pub_id, pub_name into Editoriales para una
-- condición que jamás sea verdadera.

SELECT
  pub_id,
  pub_name
INTO Editoriales
FROM publishers
WHERE 1 = 0;

-- Ejercicio 16
-- En PostgreSQL también, inserte en la tabla Editoriales –usando una función
-- PL/pgSQL- todas las filas de la tabla Publishers en Pubs. Implemente la inserción a través del
-- enfoque visto en la sección 18.

CREATE OR REPLACE FUNCTION insertarEditoriales()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  tuplasInsertadas INT;
BEGIN
  INSERT INTO Editoriales
    SELECT
      pub_id,
      pub_name
    FROM publishers;

  GET DIAGNOSTICS tuplasInsertadas = ROW_COUNT;

  IF tuplasInsertadas <> (SELECT count(*)
                          FROM publishers)
  THEN RAISE NOTICE 'La operación falló';
  ELSE
    RAISE NOTICE 'La operación tuvo éxito';
  END IF;
END;
$$;

SELECT insertarEditoriales();