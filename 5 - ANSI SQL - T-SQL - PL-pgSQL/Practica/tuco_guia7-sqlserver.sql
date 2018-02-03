-- Ejercicio 1
INSERT INTO Autores
  SELECT *
  FROM authors;
GO

ALTER TRIGGER tr_ejercicio1
ON Autores
AFTER DELETE
AS
PRINT 'Se borraron ' +
      convert(VARCHAR, @@rowcount) +
      ' filas de la tabla Autores';

DELETE FROM dbo.Autores;
GO

-- Ejercicio 2
CREATE TRIGGER tr_ejercicio2
  ON Autores
  AFTER INSERT, UPDATE
AS
  PRINT 'Datos insertados en transaction log';
SELECT *
FROM inserted;
PRINT 'Datos eliminados en transaction log';
SELECT *
FROM deleted;

SELECT *
FROM Autores;

INSERT INTO autores
VALUES ('111-11-1111', 'Lynne', 'Jeff', '415 658-9932',
        'Galvez y Ochoa', 'Berkeley', 'CA', '94705', 1);

UPDATE Autores
SET au_fname = 'Nicanor'
WHERE au_id = '111-11-1111';

-- Ejercicio 3
-- Implemente un trigger T-SQL (tr_ejercicio3) para inserción sobre la tabla productos que,
-- ante la inserción de un producto con stock negativo, dispare el error de aplicación 'El stock
-- debe ser positivo o cero' con una severidad 12 y contexto 1 y deshaga la transacción.
CREATE TRIGGER tr_ejercicio3
  ON tuco_guia2.dbo.productos
  AFTER INSERT
AS
  BEGIN
    DECLARE @stock SMALLINT;

    SELECT @stock = stock
    FROM inserted;

    IF @stock < 0
      BEGIN
        RAISERROR ('El stock debe ser positivo o cero', 12, 1);
        ROLLBACK TRANSACTION;
      END
  END;

INSERT INTO Productos
VALUES (10, 'Producto 10', 200, -6)

-- Ejercicio 4
-- Implemente un trigger T-SQL (tr_ejercicio4) que impida insertar publicaciones de
-- editoriales que no hayan vendido por más de $1500 (tabla Sales).
ALTER TRIGGER tr_ejercicio4
ON titles
AFTER INSERT
AS
BEGIN
  DECLARE @pub_id CHAR(4);
  SELECT @pub_id = pub_id
  FROM inserted;

  DECLARE @ventas MONEY;
  SELECT @ventas = sum(qty * price)
  FROM sales s
    INNER JOIN titles t ON s.title_id = t.title_id
  WHERE pub_id = @pub_id;

  IF @ventas < 1500 OR @ventas IS NULL
    ROLLBACK TRANSACTION;
END

INSERT INTO titles
VALUES ('PC4545', 'Prueba 1', 'trad_cook', '1389',
        14.99, 8000.00, 10, 4095, 'Prueba 1', '06/12/91');

INSERT INTO titles
VALUES ('PC4646', 'Prueba 2', 'trad_cook', '1622',
        14.99, 8000.00, 10, 4095, 'Prueba 1', '06/12/91');

-- Ejercicio 7
-- Se desea crear un trigger (tr_Ejercicio7) para DELETE sobre la tabla Employee que por
-- cada sentencia DELETE que afecte más de una tupla genere una entrada en la tabla
-- Registro.

CREATE TABLE Registro
(
  fecha              DATE         NULL,
  tabla              VARCHAR(100) NULL,
  operacion          VARCHAR(30)  NULL,
  CantFilasAfectadas INTEGER      NULL
);

ALTER TRIGGER tr_ejercicio7
ON employee
AFTER DELETE
AS
BEGIN
  DECLARE @cantFilas INT;
  SET @cantFilas = @@rowcount;

  IF @cantFilas > 1
    BEGIN
      INSERT INTO Registro
      VALUES (current_timestamp, 'employee', 'DELETE', @cantFilas);
    END
END

DELETE FROM employee
WHERE emp_id IN ('M-L67958F', 'Y-L77953M');