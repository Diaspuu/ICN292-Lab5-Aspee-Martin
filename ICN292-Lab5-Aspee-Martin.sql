drop database if exists andesbike;
create database andesbike;
use andesbike;

create table tiendas(
id_tienda int auto_increment,
nombre varchar(60) not null,
comuna varchar(50) not null,
primary key (id_tienda)
);

create table vendedores(
id_vendedor int auto_increment,
nombre varchar(80) not null,
id_tienda int,
fecha_ingreso date not null,
primary key (id_vendedor),
foreign key (id_tienda) references tiendas(id_tienda)
);

create table bicicletas(
id_bicicleta int auto_increment,
modelo varchar(60) not null,
categoria enum('Eléctrica', 'Infantil', 'Montaña', 'Ruta' , 'Urbana') not null,
precio decimal(10,2) not null,
primary key (id_bicicleta)
);

create table ventas(
id_venta int auto_increment,
id_vendedor int not null,
id_bicicleta int not null,
fecha date not null,
unidades int not null,
primary key (id_venta),
foreign key (id_vendedor) references vendedores(id_vendedor),
foreign key (id_bicicleta) references bicicletas(id_bicicleta)
);

insert into tiendas (nombre, comuna) values
('Andes Providencia', 'Providencia'),
('Andes Maipú','Maipú'),
('Andes Concepción','Concepción'),
('Andes La Serena','La Serena');

insert into vendedores(nombre, id_tienda, fecha_ingreso) values
('Camila Ortiz',1,'2024-06-20'),
('Diego Fuentes',1,'2024-01-15'),
('Javiera Soto',2,'2023-07-24'),
('Matías Herrera',2,'2024-01-15'),
('Paula Riquelme',3,'2022-11-02'),
('Ignacio Vera',3,'2024-08-19'),
('Fernanda Lillo',1,'2025-02-03'),
('Rubén Castro',null,'2025-06-10');

insert into bicicletas (modelo, categoria, precio) values
('Cordillera 29', 'Montaña', 549990.00),
('Ruta Austral', 'Ruta', 899990.00),
('Urbana Pro', 'Urbana', 329990.00),
('Pequeño Andes', 'Infantil', 149990.00),
('Volt City', 'Eléctrica', 1249990.00),
('Trail Master', 'Montaña', 749990.00),
('Urbana Lite', 'Urbana', 229990.00),
('Sprint R7', 'Ruta', 1099990.00);

insert into ventas(id_vendedor,id_bicicleta,fecha,unidades) values
(1, 1, '2025-03-04', 2),
(1, 3, '2025-03-18', 1),
(1, 5, '2025-05-09', 1),
(2, 2, '2025-04-08', 1),
(2, 1, '2025-04-11', 3),
(2, 7, '2025-05-06', 2),
(3, 4, '2025-03-21', 4),
(3, 3, '2025-04-15', 2),
(3, 6, '2025-05-20', 1),
(4, 1, '2025-03-27', 1),
(4, 5, '2025-04-02', 1),
(5, 2, '2025-03-04', 1),
(5, 6, '2025-04-23', 2),
(5, 4, '2025-06-02', 5),
(6, 3, '2025-05-13', 3),
(6, 7, '2025-06-17', 1),
(6, 1, '2025-06-24', 2),
(1, 6, '2025-06-30', 1);

SELECT v.nombre, COUNT(ve.id_venta) AS cantidad_ventas
FROM vendedores v
LEFT JOIN ventas ve ON v.id_vendedor = ve.id_vendedor
GROUP BY v.id_vendedor, v.nombre
ORDER BY cantidad_ventas DESC, v.nombre ASC;

select t.nombre as tienda, 
	count(ve.id_venta) as cantidad_ventas, 
	sum(ve.unidades) as unidades
from tiendas t
left join vendedores v on t.id_tienda = v.id_tienda
left join ventas ve on v.id_vendedor = ve.id_vendedor
group by t.id_tienda, t.nombre
order by unidades desc;

select  t.nombre
from tiendas t
left join vendedores v on t.id_tienda = v.id_tienda
where v.id_tienda is null;

select b.modelo as modelo,
count(ve.id_venta) as vendidas
from bicicletas b 
left join ventas ve on ve.id_bicicleta = b.id_bicicleta and ve.fecha between '2025-06-01' and '2025-06-30'
where ve.id_venta is null
group by b.id_bicicleta, b.modelo;

select v.nombre as vendedor, t.nombre as tienda
from vendedores v
left join tiendas t on t.id_tienda = v.id_tienda
left join ventas ve on ve.id_vendedor = v.id_vendedor
where ve.id_venta is null
group by v.id_vendedor, v.nombre;


select v1.nombre as vendedor_1, v2.nombre as vendedor_2, 
v1.fecha_ingreso as ingreso_1, v2.fecha_ingreso as ingreso_2,
t.nombre as tienda
from vendedores v1
join vendedores v2 on v1.id_tienda = v2.id_tienda and v1.id_vendedor < v2.id_vendedor
join tiendas t on v1.id_tienda = t.id_tienda
order by t.nombre, v1.fecha_ingreso asc;

select t.nombre, sum(ve.unidades * b.precio) as monto_total
from tiendas t
join vendedores v on t.id_tienda = v.id_tienda
join ventas ve on v.id_vendedor = ve.id_vendedor
join bicicletas b on ve.id_bicicleta = b.id_bicicleta
where b.categoria in ('montaña', 'ruta')
group by t.id_tienda, t.nombre
having monto_total > 2000000
order by monto_total desc;

select modelo, precio
from bicicletas
where precio > (select avg(precio) from bicicletas)
order by precio desc;

select v.nombre, avg(ve.unidades) as promedio_unidades
from vendedores v
join ventas ve on v.id_vendedor = ve.id_vendedor
group by v.id_vendedor, v.nombre
having promedio_unidades > (select avg(unidades) from ventas)
order by promedio_unidades desc, v.nombre asc;

select v.nombre, sum(ve.unidades * b.precio) as monto_total
from vendedores v
left join ventas ve on v.id_vendedor = ve.id_vendedor
left join bicicletas b on ve.id_bicicleta = b.id_bicicleta
group by v.id_vendedor, v.nombre
order by monto_total desc;