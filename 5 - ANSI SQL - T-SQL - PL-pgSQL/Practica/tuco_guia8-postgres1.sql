---------------------------------------------------------------------------------------------
-------------------------------------------- Sesion 1 ---------------------------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo S1 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL SERIALIZABLE;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

SELECT pg_sleep(10);

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo S2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Non-repeatable reads
BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

SELECT pg_sleep(20);

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo S3 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Serializable
-- Situación a evaluar -> Phantom reads
BEGIN ISOLATION LEVEL SERIALIZABLE;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

SELECT pg_sleep(10);

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RU1 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Read-Uncommitted
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

SELECT pg_sleep(20);

ROLLBACK;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RU2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Read-Uncommitted
-- Situación a evaluar -> Dirty reads con escritura
BEGIN ISOLATION LEVEL READ COMMITTED;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

SELECT pg_sleep(10);

ROLLBACK;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RU3 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Read-Uncommitted
-- Situación a evaluar -> Non-repeatable reads
BEGIN ISOLATION LEVEL READ COMMITTED;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

SELECT pg_sleep(20);

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR1 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Dirty reads
BEGIN ISOLATION LEVEL REPEATABLE READ;

UPDATE VueloAsiento
SET estadoAsiento = 'O'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

SELECT pg_sleep(10);

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR2 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Non-repeatable reads
BEGIN ISOLATION LEVEL REPEATABLE READ;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

SELECT pg_sleep(20);

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

---------------------------------------------------------------------------------------------
-------------------------------------- Sesion 1 -Ejemplo RR3 ---------------------------------
---------------------------------------------------------------------------------------------

-- Isolation Level -> Repeatable-Read
-- Situación a evaluar -> Phantom reads
BEGIN ISOLATION LEVEL REPEATABLE READ;

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

SELECT pg_sleep(10);

SELECT IdAsiento
FROM VueloAsiento
WHERE idVuelo = 'GA4561B' AND
      estadoAsiento = 'D';

COMMIT;

/*
Conclusiones:
  En Postgres, los niveles READ UNCOMMITED y READ COMMITED son equivalentes.
  REPEATABLE READ actúa como el SERIALIZABLE de SQL Server.
  SERIALIZABLE en Postgres provee garantías más fuertes que el SERIALIZABLE de SQL Server (¿seguro?).
 */