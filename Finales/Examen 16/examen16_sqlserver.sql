-- Ejercicio 1.1


-- Ejercicio 2
ALTER PROCEDURE mostrarTablas
  (@nFilas INT = 3)
AS
  BEGIN
    DECLARE curTablas CURSOR FOR
      SELECT TABLE_NAME
      FROM INFORMATION_SCHEMA.tables;

    DECLARE @nombreTabla VARCHAR(50);

    OPEN curTablas;
    FETCH NEXT FROM curTablas
    INTO @nombreTabla;

    WHILE @@fetch_status = 0
      BEGIN
        PRINT 'Mostrando tabla ' + @nombreTabla;

        DECLARE @consulta VARCHAR(100) =
        'select top ' + cast(@nFilas AS VARCHAR) + ' * from ' + @nombreTabla;

        EXECUTE (@consulta);

        FETCH NEXT FROM curTablas
        INTO @nombreTabla;
      END

    CLOSE curTablas;
    DEALLOCATE curTablas;
  END

EXECUTE mostrarTablas;