create table Pais
(
  codigo char(3)
    CONSTRAINT pk_pais PRIMARY KEY,
  nombre char(30) not null
);

create table Localidad
(
  codigo smallint
    CONSTRAINT pk_localidad PRIMARY KEY,
  nombre char(60) not null,
  codigo_postal smallint null
);

create table Tipo_domicilio
(
  id int
    CONSTRAINT pk_tipodom PRIMARY KEY ,
  tipo smallint not NULL
    constraint uk_tipodom_tipo unique,
  nombre char(60) not null
);

create table Funcion
(
  id INT
    CONSTRAINT pk_funcion PRIMARY KEY ,
  codigo smallint not NULL
    constraint u_funcion_codigo UNIQUE ,
  nombre char(60) not null
);

create table Tipo_PersJuridica
(
  id INT
    CONSTRAINT pk_tipo_persjuridica PRIMARY KEY ,
  codigo smallint not null
    CONSTRAINT u_tipo_persjuridica_codigo UNIQUE ,
  nombre char(60) not null
);

create table Persona
(
  id INT
    CONSTRAINT pk_persona PRIMARY KEY ,
  codigo int not null
    constraint u_persona_codigo UNIQUE ,
  telefono char(20) null,
  telefono_movil char(20) null,
  correo_electronico char(120) null,
  cuit_cuil int null,
  codigo_pais char(3) NULL
    CONSTRAINT fk_persona_pais
      REFERENCES Pais (codigo)
);

create table Domicilio
(
  id int
    CONSTRAINT pk_domicilio PRIMARY KEY ,
  id_persona int NULL
    CONSTRAINT fk_domicilio_persona
      REFERENCES Persona (id),
  item smallint null,
  detalle_domicilio char(100) not null,
  codigo_localidad smallint NULL
    CONSTRAINT fk_domicilio_localidad
      REFERENCES Localidad (codigo),
  id_tipodomicilio int null
    CONSTRAINT fk_domicilio_tipodom
      REFERENCES Tipo_domicilio (id),

  CONSTRAINT u_domicilio_idpersona_item
    UNIQUE (id_persona, item)
);

create table Persona_juridica
(
  id int,
  TPJ_id int NULL
    CONSTRAINT fk_persjurica_tpj
      REFERENCES Tipo_PersJuridica (id),
  razon_social char(40) not null,
  nombre_fantasia char(40) not null,

  constraint pk_persjuridica PRIMARY KEY (id),
  constraint fk_persjuridica_persona
    FOREIGN KEY (id) REFERENCES Persona (id)
);

create table Persona_fisica
(
  id int
    CONSTRAINT pk_persfisica PRIMARY KEY,
  tipo_documento char not null,
  numero_documento int not null,
  apellido char(40) not null,
  nombre char(40) not null,
  sexo char not null,
  fecha_nacimiento date NULL ,
  observaciones varchar(255) null,
  id_persona int NULL
    CONSTRAINT fk_persfisica_persona
      REFERENCES Persona (id),

  CONSTRAINT u_persfisica_tipodoc_nrodoc
    UNIQUE (tipo_documento, numero_documento)
);

create table Integra_persona_juridica
(
  id INT
    CONSTRAINT pk_intpersjur PRIMARY KEY ,
  id_persona_juridica int NULL
    CONSTRAINT fk_intpersjur_persjuridica
      REFERENCES Persona_juridica (id),
  item smallint NULL ,
  id_persona_fisica int NULL 
    CONSTRAINT fk_intpersjur_persfisica
      REFERENCES Persona_fisica (id),
  id_funcion int NULL 
    CONSTRAINT fk_intpersjur_funcion
      REFERENCES Funcion (id),
  observaciones char(100) not null,
  
  CONSTRAINT u_intpersjur_idpersjur_item
    UNIQUE (id_persona_juridica, item)
);