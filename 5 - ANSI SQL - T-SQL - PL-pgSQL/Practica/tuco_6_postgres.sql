CREATE OR REPLACE FUNCTION test()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
  res INTEGER;
BEGIN
  -- Otras sentencias no peligrosas...
  BEGIN
    EXECUTE 'DROP TABLE noexiste';
    EXCEPTION
    WHEN undefined_table
      THEN
        RAISE NOTICE 'ERROR SQLERRM: % SQLSTATE: %',
        SQLERRM, SQLSTATE;
    WHEN OTHERS
      THEN
        RAISE NOTICE 'Others... ERROR SQLERRM: % SQLSTATE: %',
        SQLERRM, SQLSTATE;
  END;
  RETURN;
END
$$;

SELECT test();

-- Ejercicio 1
CREATE OR REPLACE FUNCTION ejer1()
  RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE vPrice NUMERIC(10, 2);
BEGIN
  SELECT pepe
  INTO vPrice
  FROM titles
  WHERE title_id = 'BU1111';

  EXCEPTION
  WHEN OTHERS
    THEN
      RAISE NOTICE 'Error SQLERRM: %. SQLSTATE: %', SQLERRM, SQLSTATE;
END;
$$;

SELECT ejer1();

-- Ejercicio 2
CREATE OR REPLACE FUNCTION ejer2
  (tipo CHAR(12))
  RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS
$$
DECLARE result NUMERIC(10, 2);
BEGIN
  SELECT price
  INTO STRICT result
  FROM titles
  WHERE type = tipo;

  return result;
END;
$$;

select ejer2('business');
select ejer2('noexiste');
select ejer2('UNDECIDED');