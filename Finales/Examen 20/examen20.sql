-- Ejercicio 1

create table Proveedor
(
	IDProveedor int primary key,
	RazonSocial varchar(50) not null
);

create table Componente
(
	IDComponente int primary key,
	Componente varchar(40) not null
);

create table ProvComp
(
	IDProveedor int references Proveedor,
	IDComponente int references Componente,
	
	constraint pk_provcomp
		primary key (IDProveedor, IDComponente)
);

insert into Proveedor
values (1, 'Matias el seductor');
insert into Proveedor
values (2, 'Luis el destructor');
insert into Proveedor
values (3, 'Pablo el calculador');

insert into Componente
values (1, 'Tuerca')
insert into Componente
values (2, 'Tornillo')
insert into Componente
values (3, 'Clavo')
insert into Componente
values (4, 'Bulon')

insert into ProvComp values (1, 1);
insert into ProvComp values (1, 2);
insert into ProvComp values (1, 3);
insert into ProvComp values (1, 4);
insert into ProvComp values (2, 1);
insert into ProvComp values (2, 2);
insert into ProvComp values (2, 4);
insert into ProvComp values (3, 2);
insert into ProvComp values (3, 3);

--Obtener la razón social de todos los proveedores que, como mínimo,
--proveen todos los componentes que provee el proveedor con IDProveedor 2.

(select count(c.IDComponente)
from Componente c
	inner join ProvComp pc
		on c.IDComponente = pc.IDComponente
	inner join Proveedor p
		on pc.IDProveedor = p.IDProveedor
where p.IDProveedor = 2)

select p2.IDProveedor, p2.RazonSocial
from Proveedor p2
	inner join ProvComp pc2
		on p2.IDProveedor = pc2.IDProveedor
where pc2.IDComponente in (select c.IDComponente
							from Componente c
								inner join ProvComp pc
									on c.IDComponente = pc.IDComponente
								inner join Proveedor p
									on pc.IDProveedor = p.IDProveedor
							where p.IDProveedor = 2)
group by p2.IDProveedor, p2.RazonSocial
having COUNT(*) = (select count(c.IDComponente)
					from Componente c
						inner join ProvComp pc
							on c.IDComponente = pc.IDComponente
						inner join Proveedor p
							on pc.IDProveedor = p.IDProveedor
					where p.IDProveedor = 2)
					
-- Ejercicio 2

alter table sales
drop constraint UPKCL_sales;

