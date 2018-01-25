-- Ejercicio 2

DECLARE @Mens varchar(40)
SET @Mens = 'Just testing...'
SELECT @Mens
GO   -- eliminar esta linea

SELECT @Mens
GO

print 'hola'

-- Ejercicio 3
declare @precio money
set @precio = (Select price 
				from titles 
				where title_id = 'BU1111')
IF @precio > 10
	print 'El precio es mayor a 10'
ELSE
	BEGIN
		IF @precio = 10
			print 'El precio es igual a 10'
		ELSE
			print 'El precio es menor a 10'
	END
go

-- Ejemplo 2

CREATE OR REPLACE PROCEDURE PublicacionesBusiness
	(@pub_id CHAR(4))
AS
	DECLARE	@type CHAR(12)
	SET @type = 'business';
	IF NOT EXISTS (SELECT *
					FROM titles
					WHERE pub_id = @pub_id)
		RETURN 1;
	ELSE
		IF 1 < (SELECT COUNT(*)
				FROM titles
				WHERE pub_id = @pub_id AND type = @type)
			RETURN 1;
		ELSE
			RETURN 0;
		--END IF;
	--END IF

DECLARE @estado INT
EXEC @estado = PublicacionesBusiness '0736'
if @estado = 1
	print 'V'
else
	print 'N'

-- Ejercicio 5

DECLARE @Cant smallint

UPDATE sales
SET qty = qty + 1, @cant = qty
WHERE stor_id = '7067' AND title_id = 'PS2091'

select @cant

select qty
from sales
WHERE stor_id = '7067' AND title_id = 'PS2091'
GO

-- Ejercicio 6

create table t1
(
	ID int identity(1, 1),
	FechaHora datetime not null default current_timestamp
);

declare @i int
set @i = 0

while @i < 100
begin
	insert into t1 (FechaHora)
	values (DEFAULT);
	
	set @i = @i + 1;
end

truncate table t1;