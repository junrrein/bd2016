---EJERCICIO 1---
CREATE TABLE Auditoria
(
	CodEvento	varchar(3)	NOT NULL,
	IDUsuario	varchar(5)	NOT NULL,
	FechaHora	datetime	NOT NULL DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE #temporal
( 
	CodError	int			NOT NULL DEFAULT 0,
	IDUusario	varchar(5)	NOT NULL,
	FechaHora	datetime	NOT NULL DEFAULT CURRENT_TIMESTAMP,
	IDProceso	varchar(5)	NOT NULL
)

CREATE PROC Ejer1
(@title_id varchar(5))
AS
	
	IF (EXISTS (SELECT title_id
			  FROM titles
			  WHERE @title_id = title_id))
	begin -- si existe el codigo
		BEGIN TRANSACTION
		DELETE titles
		WHERE @title_id = title_id
		INSERT INTO Auditoria
		VALUES ('004',USER, CURRENT_TIMESTAMP)
		IF (@@ERROR = 0) 
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION
	end
	ELSE -- si el codigo no existe
	begin 
		SELECT title
		FROM titles
		WHERE substring(@title_id, 1,2) = substring(title_id, 1,2)
	end
	IF (@@ERROR != 0)
	begin
		INSERT INTO #temporal
		VALUES (@@ERROR, USER, CURRENT_TIMESTAMP, @@SPID)
	end


---EJERCICIO 2---
CREATE TRIGGER triEJER2
ON Auditoria
FOR insert
AS
	INSERT INTO Auditoria
	VALUES ('004',USER, CURRENT_TIMESTAMP)

---EJERCICIO 3---
/*create table empleado(
id int not null primary key,
ape varchar(10),
puntaje int
)

insert into empleado values (1, 'Ribas', 1)
insert into empleado values (2, 'Romero', 1)
insert into empleado values (3, 'Rinaldi', 1)

insert into empleado values (4, 'Bonazzola',2)
insert into empleado values (5, 'Angelici', 2)

insert into empleado values (6, 'Chiana', 3)

*/
select puntaje'Puntaje',count(id) 'Empleados',  count(id)*100/(select count(ID) 
										 from empleado) 'Porc.Sobre el total'
from empleado
group by puntaje