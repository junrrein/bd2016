-- Ejercicio 5
-- Implemente un trigger de Postgres que impida insertar publicaciones de
-- editoriales que no hayan vendido por más de $1500 (tabla Sales).
CREATE OR REPLACE FUNCTION fn_tr_ejercicio5()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE ventas NUMERIC(10);
BEGIN
  SELECT sum(qty * price)
  INTO ventas
  FROM titles t
    INNER JOIN sales s ON t.title_id = s.title_id
  WHERE pub_id = NEW.pub_id;

  IF ventas < 1500 OR ventas IS NULL
  THEN
    RAISE NOTICE 'Inserción cancelada';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER tr_ejercicio5
  BEFORE INSERT
  ON titles
  FOR EACH ROW
EXECUTE PROCEDURE fn_tr_ejercicio5();

INSERT INTO titles
VALUES ('PC4545', 'Prueba 1', 'trad_cook', '1389',
        14.99, 8000.00, 10, 4095, 'Prueba 1', '06/12/91');

INSERT INTO titles
VALUES ('PC4646', 'Prueba 2', 'trad_cook', '0736',
        14.99, 8000.00, 10, 4095, 'Prueba 1', '06/12/91');

-- Ejercicio 6
-- En PostgreSQL, agregue dos columnas adicionales a la tabla Publishers. FechaHoraAlta está
-- destinada a guardar la fecha y hora en que se da de alta una editorial. UsuarioAlta se
-- utilizará para registrar el usuario que realizó la operación de inserción:
--
-- ALTER TABLE publishers
--   ADD COLUMN FechaHoraAlta DATE NULL;
-- ALTER TABLE publishers
--   ADD COLUMN UsuarioAlta VARCHAR(255) NULL;
--
-- Defina un trigger (tr_ejercicio6) que, ante la inserción de una editorial, permita registrar la
-- fecha y hora de la operación (función CURRENT_TIMESTAMP) y el usuario que llevó a cabo la
-- operación (función SESSION_USER);
ALTER TABLE publishers
  ADD COLUMN FechaHoraAlta DATE NULL;
ALTER TABLE publishers
  ADD COLUMN UsuarioAlta VARCHAR(255) NULL;

CREATE OR REPLACE FUNCTION fn_tr_ejercicio6()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
  IF NEW.FechaHoraAlta IS NULL
  THEN
    NEW.FechaHoraAlta := current_timestamp;
  END IF;

  IF NEW.UsuarioAlta IS NULL
  THEN
    NEW.UsuarioAlta := session_user;
  END IF;

  RETURN new;
END;
$$;

CREATE TRIGGER tr_ejercicio6
  BEFORE INSERT
  ON publishers
  FOR EACH ROW
EXECUTE PROCEDURE fn_tr_ejercicio6();

INSERT INTO publishers
VALUES ('6969', 'Pepito Pubs', 'Santa Fe', 'SF', 'Argentina loco', NULL, NULL);

-- Ejercicio 7
-- Tenemos una tabla de registro con la siguiente estructura:
--
-- CREATE TABLE Registro
-- (
--   fecha              DATE         NULL,
--   tabla              VARCHAR(100) NULL,
--   operacion          VARCHAR(30)  NULL,
--   CantFilasAfectadas INTEGER      NULL
-- )
--
-- Se desean registrar en ella algunos movimientos que afectan varias filas, como UPDATE y
-- DELETE .
-- Se desea crear un trigger (tr_Ejercicio7) para DELETE sobre la tabla Employee que por
-- cada sentencia DELETE que afecte más de una tupla genere una entrada en la tabla
-- Registro.
-- Defina el trigger en T-SQL ó PL/pgSQL. Encuentra inconvenientes en alguno de los dos DBMS?

CREATE TABLE Registro
(
  fecha              DATE         NULL,
  tabla              VARCHAR(100) NULL,
  operacion          VARCHAR(30)  NULL,
  CantFilasAfectadas INTEGER      NULL
);

CREATE OR REPLACE FUNCTION fn_tr_ejercicio7()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
  cantFilas INT;
BEGIN
  GET DIAGNOSTICS cantFilas = ROW_COUNT;

  RAISE NOTICE '%', cantFilas;

  RETURN NULL;
END;
$$;

CREATE TRIGGER tr_ejercicio7
  AFTER DELETE
  ON employee
EXECUTE PROCEDURE fn_tr_ejercicio7();

DROP TRIGGER tr_ejercicio7
ON employee;

DELETE FROM employee
WHERE emp_id = 'ARD36773F';

