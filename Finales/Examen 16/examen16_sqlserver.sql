-- Ejercicio 1.1
SELECT s.Descrip
FROM Sucursal s
WHERE (SELECT sum(Cant)
       FROM DepProd dp
         INNER JOIN Deposito d ON dp.IDDeposito = d.IDDeposito
       WHERE d.IDSucursal = s.IDSucursal)
      >
      (SELECT sum(Cant)
       FROM LocalProd lp
         INNER JOIN LocalVenta lv ON lp.IDLocal = lp.IDLocal
       WHERE lv.IDSucursal = s.IDSucursal);

-- Ejercicio 1.2
BEGIN TRY
BEGIN TRANSACTION;

ALTER TABLE Local
  DROP CONSTRAINT PK_Local;

ALTER TABLE Local
  ADD CONSTRAINT PK_Local
PRIMARY KEY (IDLocal, Tipo);

ALTER TABLE Local
  ADD CONSTRAINT chk_Local_Tipo
CHECK (Tipo IN ('D', 'V'));

INSERT INTO Local
  SELECT
    lv.IDLocal,
    lv.IDSucursal,
    lv.Descrip,
    'V'
  FROM LocalVenta lv;

INSERT INTO Local
  SELECT
    d.IDLocal,
    d.IDSucursal,
    d.Descrip,
    'D'
  FROM Deposito d;

DECLARE
@nTuplasLV INT = (SELECT count(*)
                  FROM LocalVenta),
@nTuplasD INT = (SELECT count(*)
                 FROM Deposito),
@nTuplasInsertadas INT = (SELECT count(*)
                          FROM Local);

IF @nTuplasLV + @nTuplasD <> @nTuplasInsertadas
  RAISERROR ('', 12, 1);

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
END CATCH

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