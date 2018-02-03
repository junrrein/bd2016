UPDATE VueloAsiento
SET estadoAsiento = 'D'
WHERE idVuelo = 'GA4561B' AND
      idAsiento = 'AR02';

DELETE FROM VueloAsiento
WHERE idAsiento = 'ZZ01';

SELECT
  pl.pid               AS "ProcessID",
  psa.datname          AS "DatabaseName",
  psa.usename          AS "UserName",
  psa.application_name AS "ApplicationName",
  ps.relname           AS "ObjectName",
  psa.query_start      AS "QueryStartTime",
  psa.state            AS "QueryState",
  psa.query            AS "SQLQuery",
  pl.locktype,
  pl.tuple             AS "TupleNumber",
  pl.mode              AS "LockMode",
  pl.granted
FROM pg_locks AS pl
  LEFT JOIN pg_stat_activity AS psa
    ON pl.pid = psa.pid
  LEFT JOIN pg_class AS ps
    ON pl.relation = ps.oid;