------------------------------------------------------------------------------------------
----------------------------------------- Sesion 2 ---------------------------------------
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
----------------------------------- Sesion 2 -Ejemplo S1 ---------------------------------
------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

-- UPDATE VueloAsiento
-- SET estadoAsiento = 'D'
-- WHERE idVuelo = 'GA4561B' AND
--       idAsiento = 'AR02';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo S2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Non-repeatable reads
BEGIN;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo S3 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Phantom reads
BEGIN;

INSERT INTO VueloAsiento VALUES ('GA4561B', 'ZZ01', 'D');

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RU1 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Read-Uncommitted
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL READ COMMITTED;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

-- UPDATE VueloAsiento
-- SET estadoAsiento = 'D'
-- WHERE idVuelo = 'GA4561B' AND
--       idAsiento = 'AR02';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RU2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Read-Uncommitted
-- Situación a evaluar -> Dirty reads con escritura
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE Cantidad
SET cantLibres = (SELECT COUNT(IdAsiento)
                  FROM VueloAsiento
                  WHERE idVuelo = 'GA4561B' AND
                        estadoAsiento = 'D')
WHERE idVuelo = 'GA4561B';

COMMIT TRANSACTION

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR1 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Non-repeatable reads
BEGIN;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR3 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Phantom reads
BEGIN ISOLATION LEVEL REPEATABLE READ;

INSERT INTO VueloAsiento VALUES ('GA4561B', 'ZZ01', 'D');

COMMIT;