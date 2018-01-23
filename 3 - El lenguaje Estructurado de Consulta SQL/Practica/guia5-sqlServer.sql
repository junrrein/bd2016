create table Provincia
(
	id_provincia smallint
		constraint pk_provincia primary key,
	nom_provincia char(30) not null
);

create table Localidad
(
	id_provincia smallint
		constraint fk_loc_prov
			references Provincia (id_provincia),
	id_localidad smallint,
	nom_localidad char(40) not null,

	constraint pk_localidad primary key (id_provincia, id_localidad)
);

create table Seccion
(
	id_seccion smallint
		constraint pk_seccion primary key,
	nom_seccion char(30) not null
);

create table Sector
(
	id_seccion smallint
		constraint fk_sector_seccion
			references Seccion (id_seccion),
	id_sector smallint,
	nom_sector char(30) not null,

	constraint pk_sector primary key (id_seccion, id_sector)
);

create table Cargo
(
	id_cargo smallint
		constraint pk_cargo primary key,
	nom_cargo char(30) not null
);

create table Especialidad
(
	id_especialidad smallint
		constraint pk_especialidad primary key,
	nom_especialidad char(40) not null
);

create table Persona
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
	fecha_nacimiento datetime null,

	constraint pk_persona primary key (tipodoc, nrodoc, sexo),
	constraint fk_loc_vive
		foreign key (id_provincia_vive, id_localidad_vive)
		references Localidad (id_provincia, id_localidad),
	constraint fk_loc_nacio
		foreign key (id_provincia_nacio, id_localidad_nacio)
		references Localidad (id_provincia, id_localidad),
	constraint fk_padre
		foreign key (tipodoc_padre, nrodoc_padre, sexo_padre)
		references Persona (tipodoc, nrodoc, sexo),
	constraint fk_madre
		foreign key (tipodoc_madre, nrodoc_madre, sexo_madre)
		references Persona (tipodoc, nrodoc, sexo)
);

create table Empleado
(
	id_empleado int
		constraint pk_empleado primary key,
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,
	fecha_ingreso datetime not null,

	constraint fk_empleado_persona
		foreign key (tipodoc, nrodoc, sexo)
		references Persona (tipodoc, nrodoc, sexo)
);

create table Medico
(
	matricula smallint
		constraint pk_medico primary key,
	id_especialidad smallint not null
		constraint fk_medico_especialidad
			references Especialidad (id_especialidad),
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,

	constraint fk_medico_persona
		foreign key (tipodoc, nrodoc, sexo)
		references Persona (tipodoc, nrodoc, sexo)
);

create table Historial
(
	id_empleado int
		constraint fk_historial_empleado
			references Empleado (id_empleado),
	fecha_inicio datetime,
	id_cargo smallint not null
		constraint fk_historial_cargo
			references Cargo (id_cargo),
	fecha_fin datetime null,

	constraint pk_historial
		primary key (id_empleado, fecha_inicio)
);

create table Sala
(
	id_seccion smallint,
	id_sector smallint,
	nro_sala smallint,
	id_especialidad smallint not null
		constraint fk_sala_especialidad
			references Especialidad (id_especialidad),
	id_encargado int not null
		constraint fk_sala_empleado_encargado
			references Empleado (id_empleado),
	nom_sala char(30) null,
	capacidad smallint null,

	constraint pk_sala
		primary key (id_seccion, id_sector, nro_sala),
	constraint fk_sector
		foreign key (id_seccion, id_sector)
		references Sector (id_seccion, id_sector)
);

create table Trabaja_en
(
	id_empleado int
		constraint fk_trabaja_empleado
			references Empleado (id_empleado),
	id_seccion smallint,
	id_sector smallint,
	nro_sala smallint,

	constraint pk_trabaja
		primary key (id_empleado, id_seccion, id_sector, nro_sala),
	constraint fk_trabaja_sala
		foreign key (id_seccion, id_sector, nro_sala)
		references Sala (id_seccion, id_sector, nro_sala)
);

create table Asignacion
(
	id_asignacion int
		constraint pk_asignacion primary key,
	matricula smallint not null
		constraint fk_asignacion_medico
			references Medico (matricula),
	tipodoc char not null,
	nrodoc int not null,
	sexo char not null,
	id_seccion smallint not null,
	id_sector smallint not null,
	nro_sala smallint not null,
	id_empleado int not null
		constraint fk_asignacion_empleado
			references Empleado (id_empleado),
	fecha_asignacion datetime not null,
	fecha_salida datetime null,

	constraint fk_asignacion_paciente
		foreign key (tipodoc, nrodoc, sexo)
		references Persona (tipodoc, nrodoc, sexo),
	constraint fk_asignacion_sala
		foreign key (id_seccion, id_sector, nro_sala)
		references Sala (id_seccion, id_sector, nro_sala)
);


INSERT into Provincia
	VALUES (1,'Santa Fe');
INSERT into Provincia
	VALUES (2,'Buenos Aires');
INSERT into Provincia
	VALUES (3,'Entre Rios');
 

INSERT into Localidad
	VALUES (1, 1, 'Franck');
INSERT into Localidad
	VALUES (2,1,'Campana');
INSERT into Localidad
	VALUES (3,1,'Hernandez');


INSERT into Seccion
	VALUES (1, 'ala norte');
INSERT into Seccion
	VALUES (2,'laboratorio');
INSERT into Seccion
	VALUES (3,'ala sur');

  

INSERT into Sector
	VALUES (1, 1, 'cardiologia')
INSERT into Sector
	VALUES (2,1,'rayos x');
INSERT into Sector
	VALUES (3,1,'pediatria');

  

INSERT into Especialidad
	VALUES (1, 'pediatria');
INSERT into Especialidad
	VALUES (2,'cirugia');
INSERT into Especialidad
	VALUES (3,'analisis visuales');

  

INSERT into Persona
	VALUES ('d', 32839455,'m',1, 1, 1, 1, NULL , NULL ,null, NULL, NULL , NULL , 'matyas primo', NULL , '05/02/1987');
INSERT into Persona
	VALUES ('d', 34887512,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian unrrein', NULL , '03/08/1990');
INSERT into Persona
	VALUES ('d', 3481234,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian pepito', NULL , '05/08/1996');
INSERT into Persona
	VALUES ('d', 3487890,'m',3, 1, 3, 1, NULL , NULL ,null, NULL, NULL , NULL , 'julian juberto', NULL , '03/08/1993');

				 
				
				


INSERT into Medico
	VALUES (1, 1, 'd', 32839455,'m');
INSERT into Medico
	VALUES  (2,2,'d', 34887512,'m');


INSERT into Empleado
	VALUES (1, 'd', 3481234,'m', '01/02/2010');
INSERT into Empleado
	VALUES (2, 'd', 3487890,'m', '01/02/2012');


INSERT into Sala
	VALUES (1, 1, 1, 1, 1, 'sala_A', 34);
INSERT into Sala
	VALUES (2, 1, 2, 2, 2, 'sala_B', 24);

INSERT into Asignacion
	VALUES (1, 1, 'd', 34887512, 'm', 1, 1, 1, 1, '01/06/2017', '06/06/2017');

INSERT into Trabaja_en
	VALUES (2, 1, 1, 1);

INSERT into Cargo
	VALUES (1, 'limpieza');
INSERT into Cargo
	VALUES (2, 'turnos');

INSERT into Historial
	VALUES (1, '04/05/2016', 2, NULL );
INSERT into Historial
	VALUES (2, '02/05/2016', 1, NULL );















