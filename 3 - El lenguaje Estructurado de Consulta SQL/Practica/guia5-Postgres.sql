﻿create table guia5.Provincia
(
	id_provincia smallint
		constraint pk_provincia primary key,
	nom_provincia char(30) not null
);

create table guia5.Localidad
(
	id_provincia smallint
		constraint fk_loc_prov
			references guia5.Provincia (id_provincia),
	id_localidad smallint,
	nom_localidad char(40) not null,

	constraint pk_localidad primary key (id_provincia, id_localidad)
);

create table guia5.Seccion
(
	id_seccion smallint
		constraint pk_seccion primary key,
	nom_seccion char(30) not null
);

create table guia5.Sector
(
	id_seccion smallint
		constraint fk_sector_seccion
			references guia5.Seccion (id_seccion),
	id_sector smallint,
	nom_sector char(30) not null,

	constraint pk_sector primary key (id_seccion, id_sector)
);

create table guia5.Cargo
(
	id_cargo smallint
		constraint pk_cargo primary key,
	nom_cargo char(30) not null
);

create table guia5.Especialidad
(
	id_especialidad smallint
		constraint pk_especialidad primary key,
	nom_especialidad char(40) not null
);

create table guia5.Persona
(
	tipodoc char,
	nrodoc int,
	sexo char,
	id_provincia_vive smallint not null,
	id_localidad_vive smallint not null,
	id_provincia_nacio smallint null,
	id_localidad_nacio smallint null,
	tipodoc_padre char null,
	nrodoc_padre int null,
	sexo_padre char null,
	tipodoc_madre char null,
	nrodoc_madre int null,
	sexo_madre char null,
	apenom char(40) not null,
	domicilio char(50) null,
	fecha_nacimiento date null,

	constraint pk_persona primary key (tipodoc, nrodoc, sexo),
	constraint fk_loc_vive
		foreign key (id_provincia_vive, id_localidad_vive)
		references guia5.Localidad (id_provincia, id_localidad),
	constraint fk_loc_nacio
		foreign key (id_provincia_nacio, id_localidad_nacio)
		references guia5.Localidad (id_provincia, id_localidad),
	constraint fk_padre
		foreign key (tipodoc_padre, nrodoc_padre, sexo_padre)
		references guia5.Persona (tipodoc, nrodoc, sexo),
	constraint fk_madre
		foreign key (tipodoc_madre, nrodoc_madre, sexo_madre)
		references guia5.Persona (tipodoc, nrodoc, sexo)
);

create table guia5.Empleado
(
	id_empleado int
		constraint pk_empleado primary key,
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,
	fecha_ingreso date not null,

	constraint fk_empleado_persona
		foreign key (tipodoc, nrodoc, sexo)
		references guia5.Persona (tipodoc, nrodoc, sexo)
);

create table guia5.Medico
(
	matricula smallint
		constraint pk_medico primary key,
	id_especialidad smallint not null
		constraint fk_medico_especialidad
			references guia5.Especialidad (id_especialidad),
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,

	constraint fk_medico_persona
		foreign key (tipodoc, nrodoc, sexo)
		references guia5.Persona (tipodoc, nrodoc, sexo)
);

create table guia5.Historial
(
	id_empleado int
		constraint fk_historial_empleado
			references guia5.Empleado (id_empleado),
	fecha_inicio date,
	id_cargo smallint not null
		constraint fk_historial_cargo
			references guia5.Cargo (id_cargo),
	fecha_fin date null,

	constraint pk_historial
		primary key (id_empleado, fecha_inicio)
);

create table guia5.Sala
(
	id_seccion smallint,
	id_sector smallint,
	nro_sala smallint,
	id_especialidad smallint not null
		constraint fk_sala_especialidad
			references guia5.Especialidad (id_especialidad),
	id_encargado int not null
		constraint fk_sala_empleado_encargado
			references guia5.Empleado (id_empleado),
	nom_sala char(30) null,
	capacidad smallint null,

	constraint pk_sala
		primary key (id_seccion, id_sector, nro_sala),
	constraint fk_sector
		foreign key (id_seccion, id_sector)
		references guia5.Sector (id_seccion, id_sector)
);

create table guia5.Trabaja_en
(
	id_empleado int
		constraint fk_trabaja_empleado
			references guia5.Empleado (id_empleado),
	id_seccion smallint,
	id_sector smallint,
	nro_sala smallint,

	constraint pk_trabaja
		primary key (id_empleado, id_seccion, id_sector, nro_sala),
	constraint fk_trabaja_sala
		foreign key (id_seccion, id_sector, nro_sala)
		references guia5.Sala (id_seccion, id_sector, nro_sala)
);

create table guia5.Asignacion
(
	id_asignacion int
		constraint pk_asignacion primary key,
	matricula smallint not null
		constraint fk_asignacion_medico
			references guia5.Medico (matricula),
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,
	id_seccion smallint not null,
	id_sector smallint not null,
	nro_sala smallint not null,
	id_empleado int not null
		constraint fk_asignacion_empleado
			references guia5.Empleado (id_empleado),
	fecha_asignacion date not null,
	fecha_salida date null,

	constraint fk_asignacion_paciente
		foreign key (tipodoc, nrodoc, sexo)
		references guia5.Persona (tipodoc, nrodoc, sexo),
	constraint fk_asignacion_sala
		foreign key (id_seccion, id_sector, nro_sala)
		references guia5.Sala (id_seccion, id_sector, nro_sala)
);


INSERT into Provincia
	VALUES (1,'Santa Fe'), (2,'Buenos Aires'), (3,'Entre Rios');

INSERT into Localidad
	VALUES (1, 1, 'Franck'), (2,1,'Campana'), (3,1,'Hernandez');

INSERT into Seccion
	VALUES (1, 'ala norte'), (2,'laboratorio'), (3,'ala sur');

INSERT into Sector
	VALUES (1, 1, 'cardiologia'), (2,1,'rayos x'), (3,1,'pediatria');

INSERT into Especialidad
	VALUES (1, 'pediatria'), (2,'cirugia'), (3,'analisis visuales');

INSERT into Persona
	VALUES ('d', 32839455,'m',1, 1, 1, 1, NULL , NULL ,null, NULL, NULL , NULL , 'matyas primo', NULL , '05/02/1987'),
				 ('d', 34887512,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian unrrein', NULL , '03/08/1990'),
				('d', 3481234,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian pepito', NULL , '05/08/1996'),
				('d', 3487890,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian juberto', NULL , '03/08/1993');


INSERT into Medico
	VALUES (1, 1, 'd', 32839455,'m'), (2,2,'d', 34887512,'m');

INSERT into Empleado
	VALUES (1, 'd', 3481234,'m', '01/02/2010'), (2, 'd', 3487890,'m', '01/02/2012');

INSERT into Sala
	VALUES (1, 1, 1, 1, 1, 'sala_A', 34), (2, 1, 2, 2, 2, 'sala_B', 24);

INSERT into Asignacion
	VALUES (1, 1, 'd', 34887512, 'm', 1, 1, 1, 1, '01/06/2017', '06/06/2017');

INSERT into Trabaja_en
	VALUES (2, 1, 1, 1);

INSERT into Cargo
	VALUES (1, 'limpieza'), (2, 'turnos');

INSERT into Historial
	VALUES (1, '04/05/2016', 2, NULL ), (2, '02/05/2016', 1, NULL );















