-- Ejercicio 3
-- Parte A
ALTER PROCEDURE getErrorInfo
AS
  SELECT
    error_number()    AS ErrorNumber,
    error_message()   AS ErrorMessage,
    error_severity()  AS ErrorSeverity,
    error_state()     AS ErrorState,
    error_procedure() AS ErrorProcedure,
    error_line()      AS ErrorLine;
GO

-- Parte B
CREATE PROCEDURE buscarPrecio
  (
    @title_id VARCHAR(6),
    @precio   MONEY OUTPUT
  )
AS
  SELECT @precio = price
  FROM titles
  WHERE title_id = @title_id;

  IF @@rowcount = 0
    RETURN 70

  IF @precio IS NULL
    RETURN 71

  RETURN 0
GO

DECLARE @precioRetornado MONEY, @retorno INT;
EXECUTE @retorno = buscarPrecio 'MK5656', @precioRetornado OUTPUT;
SELECT @retorno;

DECLARE @precioRetornado MONEY, @retorno INT;
EXECUTE @retorno = buscarPrecio 'MC3026', @precioRetornado OUTPUT;
SELECT @retorno;

DECLARE @precioRetornado MONEY, @retorno INT;
EXECUTE @retorno = buscarPrecio 'BU1032', @precioRetornado OUTPUT;
SELECT @retorno;

-- Parte C
ALTER PROCEDURE insertaSales
  (
    @stor_id  CHAR(4),
    @ord_num  VARCHAR(20),
    @qty      SMALLINT,
    @title_id VARCHAR(6)
  )
AS
  DECLARE @precioObtenido MONEY, @retorno INT;
  EXECUTE @retorno = buscarPrecio @title_id, @precioObtenido OUTPUT;

  IF @retorno = 70
    BEGIN
      RAISERROR ('Publicación inexistente', 12, 1);
      RETURN 70;
    END

  IF @retorno = 71
    BEGIN
      RAISERROR ('La publicación no posee precio', 12, 1);
      RETURN 71;
    END

  BEGIN TRY
  INSERT INTO sales
  VALUES (@stor_id,
          @ord_num,
          CURRENT_TIMESTAMP,
          @qty,
          'Net 40',
          @title_id);

  RETURN 0;
  END TRY
  BEGIN CATCH
  EXECUTE getErrorInfo;
  RETURN 72;
  END CATCH
GO

DECLARE @retorno INTEGER;
EXECUTE @retorno = insertaSales '6380', '4565', 2, 'MK5626';
PRINT @retorno; -- Publicación inexistente

DECLARE @retorno INTEGER;
EXECUTE @retorno = insertaSales '6380', '4565', 2, 'MC3026';
PRINT @retorno; -- La publicación no posee precio

DECLARE @retorno INTEGER;
EXECUTE @retorno = insertaSales '6380', '4565', 2, 'BU1032';
PRINT @retorno; -- Exito
SELECT *
FROM sales
WHERE year(ord_date) = 2018;



