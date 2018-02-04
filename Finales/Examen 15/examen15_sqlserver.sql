-- Ejercicio 1
CREATE TABLE Setup
(
  Tabla  VARCHAR(40) NOT NULL,
  Ultimo INTEGER
);

INSERT INTO setup VALUES ('Factura', 1);
INSERT INTO setup VALUES ('Detalle', 1);

ALTER PROCEDURE obtenerId
  (
    @nombreTabla VARCHAR(40),
    @id          INTEGER OUTPUT
  )
AS
  BEGIN
    SET @id = (SELECT Ultimo
               FROM Setup
               WHERE Tabla = @nombreTabla) + 1;

    IF @id IS NULL
      RAISERROR ('La tabla no existe en Setup', 12, 1);

    UPDATE Setup
    SET Ultimo = @id
    WHERE Tabla = @nombreTabla;
  END

DECLARE @nuevoID INTEGER;
EXECUTE obtenerId 'Factura', @nuevoID OUTPUT;
SELECT @nuevoID;