-- Ejercicio 1
SELECT
  (SELECT TipoDocumentoEmitido
   FROM TiposDocumentoEmitido
   WHERE IDTipoDocumentoEmitido = de.IDTipoDocumentoEmitido)
    AS "Tipo de Documento Emitido",
  (SELECT count(*)
   FROM DocumentosEmitidos
   WHERE IDTipoDocumentoEmitido = de.IDTipoDocumentoEmitido AND
         UsuarioAlta LIKE 'WEBUSER')
    AS "Desde Sitio Web",
  (SELECT count(*)
   FROM DocumentosEmitidos
   WHERE IDTipoDocumentoEmitido = de.IDTipoDocumentoEmitido AND
         UsuarioAlta NOT LIKE 'WEBUSER')
    AS "Desde Oficinas"
FROM DocumentosEmitidos de
GROUP BY IDTipoDocumentoEmitido;

-- Ejercicio 2 (T-SQL)
ALTER PROCEDURE clasificarAlmacenes
AS
  BEGIN
    DECLARE @maximo MONEY;

    SELECT TOP 1 @maximo = round(sum(qty * price), 0)
    FROM sales S
      INNER JOIN titles t ON S.title_id = t.title_id
    GROUP BY stor_id
    ORDER BY 1 DESC;

    --     SELECT round(@maximo, 0);

    DECLARE
    @Cuartil1 MONEY = round(@maximo / 4, 0),
    @Cuartil2 MONEY = round(@maximo * 2 / 4, 0),
    @Cuartil3 MONEY = round(@maximo * 3 / 4, 0),
    @Cuartil1String VARCHAR(255) = '',
    @Cuartil2String VARCHAR(255) = '',
    @Cuartil3String VARCHAR(255) = '',
    @Cuartil4String VARCHAR(255) = '',
    @ventas MONEY,
    @almacen CHAR(4);

    DECLARE cursorVentas CURSOR FOR
      SELECT
        stor_id,
        round(sum(qty * price), 0)
      FROM sales s
        INNER JOIN titles t ON s.title_id = t.title_id
      GROUP BY stor_id;

    OPEN cursorVentas;
    FETCH NEXT FROM cursorVentas
    INTO @almacen, @ventas;

    WHILE @@fetch_status = 0
      BEGIN
        IF @ventas <= @Cuartil1
          SET @Cuartil1String = @Cuartil1String + @almacen + '-';
        ELSE
          BEGIN
            IF @ventas <= @Cuartil2
              SET @Cuartil2String = @Cuartil2String + @almacen + '-';

            ELSE
              BEGIN
                IF @ventas <= @Cuartil3
                  SET @Cuartil3String = @Cuartil3String + @almacen + '-';
                ELSE
                  SET @Cuartil4String = @Cuartil4String + @almacen + '-';
              END
          END

        FETCH NEXT FROM cursorVentas
        INTO @almacen, @ventas;
      END

    CLOSE cursorVentas;
    DEALLOCATE cursorVentas;

    DECLARE @tituloBase CHAR(17) = 'Ganancias hasta $';
    SELECT
      @tituloBase + cast(@Cuartil1 AS VARCHAR),
      @tituloBase + cast(@Cuartil2 AS VARCHAR),
      @tituloBase + cast(@Cuartil3 AS VARCHAR),
      @tituloBase + cast(@maximo AS VARCHAR)

    UNION ALL

    SELECT
      @cuartil1string,
      @Cuartil2String,
      @Cuartil3String,
      @Cuartil4String;
  END

EXECUTE clasificarAlmacenes;

-- Ejercicio 3
/*
Se da un non-repeatable read cuando una transacción relee tuplas que ya ha leído anteriormente,
y se encuentra con que las tuplas fueron modificadas o eliminadas por otra transacción.
Los niveles de aislamiento que presentan este tipo de situaciones son "READ UNCOMMITED"
y "READ COMMITED".
 */