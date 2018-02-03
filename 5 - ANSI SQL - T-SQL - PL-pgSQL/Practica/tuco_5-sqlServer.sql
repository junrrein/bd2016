-- Ejercicio 1
declare cursor_precios cursor for
	select price 
	from titles 
	where pub_id = '0736'
for update;


declare @precio money;

open cursor_precios;

fetch next from cursor_precios into @precio

while @@fetch_status = 0
	begin
		if @precio is not null 
			update titles 
			set price = case  
							when @precio>10 then @precio*0.75
							else @precio*1.25
						end
			where current of cursor_precios;
	
		fetch next from cursor_precios into @precio;
	end

close cursor_precios;
deallocate cursor_precios;

select price 
	from titles 
	where pub_id = '0736';


-- Ejercicio 3

declare cur_tipo cursor for
	select distinct(type)
	from titles;

declare @tipo char(12);

open cur_tipo;
fetch next from cur_tipo into @tipo;

while @@fetch_status = 0 -- Bucle de tipo
	begin
		declare cur_precio cursor for
			select top 3 price
			from titles
			where type = @tipo
			order by price desc;

		declare @precio money;

		open cur_precio;
		fetch next from cur_precio into @precio;

		print 'Publicaciones más caras de tipo ' + @tipo;
		print '---------------------------------';

		while @@fetch_status = 0 -- Bucle de precio
			begin
				print @precio;

				fetch next from cur_precio into @precio;
			end

		print ''
		
		close cur_precio;
		deallocate cur_precio;
		
		fetch next from cur_tipo into @tipo;
	end;

close cur_tipo;
deallocate cur_tipo;

-- Ejercicio 5

declare cur_editorial cursor for
	select p.pub_id, sum(qty * price)
	from publishers p
		inner join titles t on p.pub_id = t.pub_id
		inner join sales s on t.title_id = s.title_id
	group by p.pub_id
	order by sum(qty * price);

declare
	@pub_mayor char(4),
	@pub_menor1 char(4),
	@pub_menor2 char(4),
	@mayor_venta money,
	@menor_venta1 money,
	@menor_venta2 money,
	@pub_id char(4),
	@venta money;

open cur_editorial;
fetch next from cur_editorial into @pub_id, @venta;

set @mayor_venta = 0;
set @menor_venta1 = 10000000;
set @menor_venta2 = 10000000;

while @@fetch_status = 0
begin
	if @venta > @mayor_venta
	begin
		set @pub_mayor = @pub_id;
		set @mayor_venta = @venta;
	end

	if @venta < @menor_venta1
	begin
		set @pub_menor2 = @pub_menor1;
		set @menor_venta2 = @menor_venta1;
		set @pub_menor1 = @pub_id;
		set @menor_venta1 = @venta;
	end
	else if @venta < @menor_venta2
		begin
			set @pub_menor2 = @pub_id;
			set @menor_venta2 = @venta;
		end
	
	fetch next from cur_editorial into @pub_id, @venta;
end

close cur_editorial;
deallocate cur_editorial;

--select @pub_mayor;
--select @pub_menor1;
--select @pub_menor2;

declare cur_empleados cursor for
	select emp_id, hire_date
	from employee
	where pub_id in (@pub_menor1, @pub_menor2) and
		job_id = 5;
	
declare
	@id_viejo char(9),
	@fecha_viejo datetime,
	@id_empleado char(9),
	@fecha_contratacion datetime;
	
open cur_empleados;
fetch next
	from cur_empleados
	into @id_empleado, @fecha_contratacion;

set @id_viejo = @id_empleado;
set @fecha_viejo = @fecha_contratacion;

while @@FETCH_STATUS = 0
begin
	if @fecha_contratacion < @fecha_viejo
	begin
		set @fecha_viejo = @fecha_contratacion;
		set @id_viejo = @id_empleado;
	end
	
	fetch next
		from cur_empleados
		into @id_empleado, @fecha_contratacion;
end;

close cur_empleados;
deallocate cur_empleados;

select @id_viejo, @fecha_viejo;

--update employee
--	set pub_id = @pub_mayor
--	where emp_id = @id_viejo;