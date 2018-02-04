-- Ejercicio 1
CREATE PROCEDURE cuartaEncarnacion
  (
    @idAlma INTEGER
  )
AS
  BEGIN
    DECLARE cursorEncarnacion CURSOR FOR
      SELECT
        IDEncarnacion,
        IDTipoEncarnacion,
        FechaNacimiento,
        FechaMuerte
      FROM Encarnacion
      WHERE IDAlma = @idAlma
      ORDER BY FechaNacimiento;

    DECLARE
    @IDEncarnacion INTEGER,
    @IDTipoEncarnacion SMALLINT,
    @FechaNacimiento DATETIME,
    @FechaMuerte DATETIME,
    @i SMALLINT = 4;

    OPEN cursorEncarnacion;
    FETCH NEXT FROM cursorEncarnacion
    INTO @IDEncarnacion, @IDTipoEncarnacion, @FechaNacimiento, @FechaMuerte;

    WHILE @@fetch_status AND @i > 0
      BEGIN
        IF @IDTipoEncarnacion <> 2
          RAISERROR ('El alma tiene una reencarnación no animal entre sus primeras cuatro', 12, 1);

        FETCH NEXT FROM cursorEncarnacion
        INTO @IDEncarnacion, @IDTipoEncarnacion, @FechaNacimiento, @FechaMuerte;

        SET @i = @i - 1;
      END

    IF @i <> 0
      RAISERROR ('El alma no tiene cuatro reencarnaciones todavía', 12, 2);

    CLOSE cursorEncarnacion;
    DEALLOCATE cursorEncarnacion;

    SELECT
      @IDEncarnacion,
      'Tipo Animal',
      @FechaNacimiento,
      @FechaMuerte;
  END

-- Ejercicio 2
SELECT IDBox
FROM Box
WHERE IDArea IN (SELECT a.IDArea
                 FROM Area a
                   INNER JOIN Box b ON a.IDArea = b.IDArea
                 GROUP BY a.IDArea
                 HAVING max(b.Superficie) <= 10);