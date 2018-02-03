CREATE TABLE Vuelo
(
  idVuelo VARCHAR(8),
  fecha   DATE,
  PRIMARY KEY (idVuelo)
);

INSERT INTO vuelo
VALUES ('GA4561B', '2015/10/12');

CREATE TABLE VueloAsiento
(
  idVuelo       VARCHAR(8),
  idAsiento     VARCHAR(6),
  estadoAsiento CHAR(1) CHECK (estadoAsiento IN ('O', 'D')),
  PRIMARY KEY (idVuelo, idAsiento)
);

INSERT INTO VueloAsiento
VALUES ('GA4561B', 'AL01', 'D'),
  ('GA4561B', 'AL02', 'D'),
  ('GA4561B', 'AR01', 'D'),
  ('GA4561B', 'AR02', 'D');

CREATE TABLE Cantidad
(
  idVuelo    VARCHAR(8) PRIMARY KEY,
  cantLibres INTEGER NULL
);

INSERT INTO Cantidad (idVuelo)
VALUES ('GA4561B');