-- Ejercicio 1
CREATE TABLE cliente
(
	codCli int NOT NULL,
	ape varchar(30) NOT NULL,
	nom varchar(30) NOT NULL,
	dir varchar(40) NOT NULL,
	codPost char(9) NULL DEFAULT 3000
);

CREATE TABLE productos
(
	codProd int NOT NULL,
	descr varchar(30) NOT NULL,
	precUnit float NOT NULL,
	stock smallint NOT NULL
);

CREATE TABLE pedidos
(
	numPed int NOT NULL,
	fechPed date NOT NULL,
	codCli int NOT NULL
);

CREATE TABLE detalle
(
	codDetalle int NOT NULL,
	numPed int NOT NULL,
	codProd int NOT NULL,
	cant int NOT NULL,
	precioTot float NULL
);

CREATE TABLE proveed
(
	codProv serial,
	razonSoc varchar(30) NOT NULL,
	dir varchar(30) NOT NULL
);

-- Ejercicio 2
insert into cliente
	(codCli, ape, nom, dir)
	values (1, 'LOPEZ', 'JOSE MARIA', 'Gral. Paz 3124');
	
-- Ejercicio 3
insert into cliente
	values (2, 'GERVASOLI', 'MAURO', 'San Luis 472', NULL);

-- Ejercicio 4
insert into proveed
	(razonSoc, dir)
	values ('FLUKE INGENIERIA', 'RUTA 9 Km. 80'),
			('PVD PATCHES', 'Pinar de Rocha 1154');
			
-- Ejercicio 5
create table Ventas
(
	codVent serial,
	fechaVent date not null default current_timestamp,
	usuarioDB varchar(30) not null default user,
	monto float
);

-- Ejercicio 6
insert into Ventas
	(monto)
	values (100), (200);
	
-- Ejercicio 7
select *
	into clistafe
	from cliente
	where codPost = '3000';
	
-- Ejercicio 8
insert into clistafe
	select *
		from cliente;

-- Ejercicio 9
update cliente
	set dir = 'TCM 168'
	where dir like '%1%';

-- Ejercicio 10
update cliente
	set codPost = default;
	
-- Ejercicio 11
delete from clistafe
	where codPost is null;

-- Ejercicio 12
create temp table Tempi
(
	codCli int not null,
	ape varchar(30) not null
);

select *
	from Tempi;

-- Ejercicio 13
select au_lname, au_fname, address, city
	into temporal
	from authors
	where state = 'CA';
	
select *
	from temporal;