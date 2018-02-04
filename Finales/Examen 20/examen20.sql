-- Ejercicio 1

CREATE TABLE Proveedor
(
  IDProveedor INT PRIMARY KEY,
  RazonSocial VARCHAR(50) NOT NULL
);

CREATE TABLE Componente
(
  IDComponente INT PRIMARY KEY,
  Componente   VARCHAR(40) NOT NULL
);

CREATE TABLE ProvComp
(
  IDProveedor  INT REFERENCES Proveedor,
  IDComponente INT REFERENCES Componente,

  CONSTRAINT pk_provcomp
  PRIMARY KEY (IDProveedor, IDComponente)
);

INSERT INTO Proveedor
VALUES (1, 'Matias el seductor');
INSERT INTO Proveedor
VALUES (2, 'Luis el destructor');
INSERT INTO Proveedor
VALUES (3, 'Pablo el calculador');

INSERT INTO Componente
VALUES (1, 'Tuerca');
INSERT INTO Componente
VALUES (2, 'Tornillo');
INSERT INTO Componente
VALUES (3, 'Clavo');
INSERT INTO Componente
VALUES (4, 'Bulon');

INSERT INTO ProvComp VALUES (1, 1);
INSERT INTO ProvComp VALUES (1, 2);
INSERT INTO ProvComp VALUES (1, 3);
INSERT INTO ProvComp VALUES (1, 4);
INSERT INTO ProvComp VALUES (2, 1);
INSERT INTO ProvComp VALUES (2, 2);
INSERT INTO ProvComp VALUES (2, 4);
INSERT INTO ProvComp VALUES (3, 2);
INSERT INTO ProvComp VALUES (3, 3);

--Obtener la razón social de todos los proveedores que, como mínimo,
--proveen todos los componentes que provee el proveedor con IDProveedor 2.

(SELECT count(c.IDComponente)
 FROM Componente c
   INNER JOIN ProvComp pc
     ON c.IDComponente = pc.IDComponente
   INNER JOIN Proveedor p
     ON pc.IDProveedor = p.IDProveedor
 WHERE p.IDProveedor = 2);

SELECT
  p2.IDProveedor,
  p2.RazonSocial
FROM Proveedor p2
  INNER JOIN ProvComp pc2
    ON p2.IDProveedor = pc2.IDProveedor
WHERE pc2.IDComponente IN (SELECT c.IDComponente
                           FROM Componente c
                             INNER JOIN ProvComp pc
                               ON c.IDComponente = pc.IDComponente
                             INNER JOIN Proveedor p
                               ON pc.IDProveedor = p.IDProveedor
                           WHERE p.IDProveedor = 2)
GROUP BY p2.IDProveedor, p2.RazonSocial
HAVING COUNT(*) = (SELECT count(c.IDComponente)
                   FROM Componente c
                     INNER JOIN ProvComp pc
                       ON c.IDComponente = pc.IDComponente
                     INNER JOIN Proveedor p
                       ON pc.IDProveedor = p.IDProveedor
                   WHERE p.IDProveedor = 2);

-- Ejercicio 2

ALTER TABLE sales
  DROP CONSTRAINT UPKCL_sales;

CREATE OR REPLACE FUNCTION fn_tr_ejer2()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
  cantidad SMALLINT;
BEGIN
  SELECT qty
  INTO cantidad
  FROM sales
  WHERE stor_id = NEW.stor_id AND
        ord_num = NEW.ord_num AND
        title_id = NEW.title_id;

  IF cantidad IS NULL
  THEN
    RETURN NEW;
  END IF;

  UPDATE sales
  SET qty    = cantidad + new.qty,
    ord_date = new.ord_date,
    payterms = new.payterms
  WHERE stor_id = NEW.stor_id AND
        ord_num = NEW.ord_num AND
        title_id = NEW.title_id;

  RETURN NULL;
END;
$$;

CREATE TRIGGER tr_ejer2
  BEFORE INSERT
  ON sales
  FOR EACH ROW
EXECUTE PROCEDURE fn_tr_ejer2();

SELECT *
FROM sales
WHERE stor_id = '7067' AND ord_num = 'P2121';

INSERT INTO sales
VALUES ('7067', 'P2121', current_timestamp, 10, 'ON invoice', 'PC8888');

