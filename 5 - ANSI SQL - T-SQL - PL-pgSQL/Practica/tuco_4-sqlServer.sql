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

CREATE PROCEDURE PublicacionesBusiness
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
go

-- Ejercicio 7
--Cree un SP T-SQL (sp_ObtenerPrecio) sin parámetros de entrada que liste el
--precio de la publicación con código “PS2091”. Ejecútelo.

create procedure ObtenerPrecio
as
	select price
	from titles
	where title_id = 'PS2091';
	
execute ObtenerPrecio;
go

-- Ejercicio 8
--Reescriba en T-SQL el SP del Ejercicio 7 a fin de que proporcione el precio de
--cualquier publicación para la cual se proporcione un código. (sp_ObtenerPrec2). Ejecútelo a
--fin de consultar el precio de la publicación PS1372 

create procedure ObtenerPrecio2
(@codigo_titulo char(6))
as
	select price
	from titles
	where title_id = @codigo_titulo;
	
execute ObtenerPrecio2 'BU1032';
go

-- Ejercicio 10
--Reescriba en T-SQL el SP del Ejercicio 8 a fin de que la especificación del
--código de publicación sea opcional y establecido a NULL por omisión. (sp_ObtenerPrec3)
--Ejecútelo proporcionando el código de publicación PS1372 y sin proporcionar parámetros.

create procedure ObtenerPrecio3
(@codigo_titulo char(6) = null)
as
	select price
	from titles
	where title_id = @codigo_titulo;
	
execute ObtenerPrecio3 'PS1372';
execute ObtenerPrecio3;
go

-- Ejercicio 11
--Reescriba en T-SQL el SP del Ejercicio 10 de manera tal que –si el usuario
--omite el parámetro- se le notifique esta situación por medio de un mensaje informativo con la
--forma “El SP sp_ObtenerPrec4 requiere del parámetro title_id” y se finalice la ejecución del
--mismo.
--Ejecútelo con y sin parámetros.

create procedure ObtenerPrecio4
(@codigo_titulo char(6) = null)
as
	if @codigo_titulo is null
		print 'El SP sp_ObtenerPrec4 requiere del parámetro title_id'
	else
		select price
		from titles
		where title_id = @codigo_titulo;
	
execute ObtenerPrecio4 'PS1372';
execute ObtenerPrecio4;
go

-- Ejercicio 12

insert into productos
values (10, 'Articulo 1', 50, 20);
insert into productos
values (20, 'Articulo 2', 70, 40);
go

create procedure BuscaPrecio
(
	@cod_producto int,
	@precio float output
)
as
	select @precio = precUnit
	from productos
	where codProd = @cod_producto;
go
	
declare @precioBuscado float;
exec BuscaPrecio 20, @precioBuscado output;
select @precioBuscado;
go

alter procedure InsertaDetalle
(
	@codDetalle int,
	@numPed int,
	@codProd int,
	@cant int,
	@estOuput int output
)
as
	set @estOuput = 70;

	declare @precioBuscado float;
	exec BuscaPrecio @codProd, @precioBuscado output;
	
	insert into detalle
	values (@codDetalle, @numPed, @codProd, @cant, @cant * @precioBuscado);
go

exec InsertaDetalle
	@codDetalle = 1540,
	@numPed = 120,
	@codProd = 10,
	@cant = 2;
	
select * from detalle;

-- Ejercicio 13
--Ejecute nuevamente sp_InsertaDetalle con los datos del Ejercicio 12 pero
--omitiendo el valor de Cantidad. Capture y muestre el status de retorno del SP.

declare @estado int;
exec InsertaDetalle
	@codDetalle = 1540,
	@numPed = 120,
	@codProd = 10,
	@estOutput = @estado output;
print @estado;
go

-- Ejercicio 14
--Redefina en T-SQL el SP de inserción de detalles de pedidos a fin de que contemple la
--posibilidad de que no se encuentre el producto a pedir o que su precio sea NULL (aunque en
--este caso la definición de la tabla no lo permite).

alter procedure InsertaDetalle2
(
	@codDetalle int,
	@numPed int,
	@codProd int,
	@cant int
)
as
	if not exists (select * from productos where codProd = @codProd)
		return 1;
		
	declare @precioBuscado float;
	exec BuscaPrecio @codProd, @precioBuscado output;
	if @precioBuscado is null
		return 2;
	
	insert into detalle
	values (@codDetalle, @numPed, @codProd, @cant, @cant * @precioBuscado);
go

declare @estado int;
exec @estado = InsertaDetalle2
	@codDetalle = 1540,
	@numPed = 120,
	@codProd = 15,
	@cant = 2;
print @estado;
go

-- Ejercicio 17
--En T-SQL, y en base a las tablas Productos y Detalle creadas en la Guía de
--Trabajo Nro. 2, registre el pedido de cinco unidades del artículo con código 10. Para ello debe
--disminuir el stock en la tabla Productos e insertar los datos del pedido en la tabla Detalle
--(Código de detalle 1200, Número de pedido 1108). Tansaccione las operaciones de manera tal
--que tengan éxito o fracasen como una unidad.

create procedure verStock
(
	@codProd int,
	@stock smallint output
)
as
	select @stock = stock
	from productos
	where codProd = @codProd;
go

declare @stockObtenido smallint;
execute verStock 10, @stock = @stockObtenido output;
select @stockObtenido;
go

create procedure ingresarPedido
as
	begin transaction;
	declare @stockObtenido smallint;
	execute verStock 10, @stock = @stockObtenido output;
	
	if @stockObtenido < 5
		return 1;
		
	-- SIN TERMINAR
	
	commit transaction;
	