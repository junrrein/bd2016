-- Ejercicio 1
CREATE TABLE Auditoria
(
  CodEvento CHAR(3),
  IDUsuario VARCHAR(50) DEFAULT user,
  FechaHora DATETIME    DEFAULT current_timestamp
);

CREATE TABLE #temporal
(
  CodError  INT         DEFAULT error_number(),
  IDUsuario VARCHAR(50) DEFAULT user,
  FechaHora DATETIME    DEFAULT current_timestamp,
  IDProceso INTEGER     DEFAULT @@spid
);

ALTER PROCEDURE ejer1
  (@title_id VARCHAR(6))
AS
  BEGIN
    BEGIN TRY
    IF exists(SELECT title_id
              FROM titles
              WHERE title_id = @title_id)
      BEGIN
        DELETE FROM titles
        WHERE title_id = @title_id;

        INSERT INTO Auditoria (CodEvento) -- Borrar esto para el ejercicio 2,
        VALUES ('004'); -- o se va a insertar dos veces para un delete
      END
    ELSE
      SELECT
        title_id,
        title
      FROM titles
      WHERE title_id LIKE substring(@title_id, 1, 2) + '%';
    END TRY
    BEGIN CATCH
    INSERT INTO #temporal DEFAULT VALUES;
    END CATCH
  END

-- Ejercicio 2
CREATE TRIGGER tr_ejer2
  ON titles
  AFTER DELETE
AS
  INSERT INTO Auditoria (CodEvento)
  VALUES ('004');

-- Ejercicio 3
CREATE TABLE Empleado
(
  ID      INTEGER,
  Ape     VARCHAR(100),
  Puntaje SMALLINT
);

INSERT INTO Empleado VALUES (1, 'pepe', 1);
INSERT INTO Empleado VALUES (2, 'poroto', 2);
INSERT INTO Empleado VALUES (3, 'eulogia', 1);
INSERT INTO Empleado VALUES (4, 'petruchia', 1);

SELECT
  Puntaje,
  count(*)
    AS "Cant. Empleados",
  cast(count(*) AS NUMERIC) / (SELECT count(*)
                               FROM Empleado)
    AS "Porc. sobre el total"
FROM Empleado
GROUP BY Puntaje;

SELECT user;