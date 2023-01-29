CREATE TABLE clientes(
	id serial PRIMARY KEY,
	rut VARCHAR(15) UNIQUE NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	edad int NOT NULL check(edad >=18 and edad <=85)
);


INSERT INTO clientes (rut, nombre, edad) VALUES
('1.111.111-1', 'Carlos', 25),
('2.222.222-2', 'Sebastián', 85),
('3.333.333-3', 'José', 18),
('4.444.444-4', 'Carlos', 50),
('5.555.555-5','Jacinto',60);

select * from clientes;

CREATE TABLE cuentas(
	id serial PRIMARY KEY,
	numero VARCHAR(15) NOT NULL UNIQUE,
	rut_cliente VARCHAR(13) NOT NULL,
	saldo int not null default 0 check(saldo >=-5000 and saldo <=100000),
	FOREIGN KEY (rut_cliente) REFERENCES clientes(rut)
);

INSERT INTO cuentas(numero, rut_cliente, saldo) VALUES
('1000001', '1.111.111-1', -5000),
('1000002', '1.111.111-1', 50000);

INSERT INTO cuentas(numero, rut_cliente, saldo) VALUES
('1000003', '2.222.222-2', 10000),
('1000004', '2.222.222-2', -1000);

INSERT INTO cuentas(numero, rut_cliente, saldo) VALUES
('1000005', '3.333.333-3', 100000),
('1000006', '3.333.333-3', 50000);

INSERT INTO cuentas(numero, rut_cliente, saldo) VALUES
('1000007', '4.444.444-4', 45000),
('1000008', '4.444.444-4', 1000);

INSERT INTO cuentas(numero, rut_cliente, saldo) VALUES
('1000009', '5.555.555-5', -5000),
('1000010', '5.555.555-5', 1000);


select * from cuentas;

-- 3. LISTAR EL SALDO DE LA CUENTA DEL CLIENTE CON MÁS DE EDAD.


SELECT rut, nombre, edad, numero, saldo FROM CLIENTES cl
inner JOIN cuentas cu
ON cl.rut = cu.rut_cliente
WHERE edad = (SELECT max(edad) FROM CLIENTES cl
inner JOIN cuentas cu
ON cl.rut = cu.rut_cliente);


-- 4. LISTAR EL PROMEDIO DE EDAD DE LOS CLIENTES CON SALDO NEGATIVO


SELECT AVG(EDAD) FROM CLIENTES CL
INNER JOIN CUENTAS CU
ON CL.RUT = CU.RUT_CLIENTE
WHERE CU.SALDO < 0;

--5 LISTAR EL NOMBRE Y CANTIDAD DE CUENTAS DE QUIENES TIENEN MAS DE UNA

SELECT CL.RUT, CL.NOMBRE, COUNT(*) cantidad FROM CLIENTES CL
INNER JOIN CUENTAS CU
ON CL.RUT = CU.RUT_CLIENTE
GROUP BY CL.RUT, CL.NOMBRE
ORDER BY cantidad DESC;

--6 listar el saldo combinado (suma) de cada cliente con mas de una cuenta

SELECT 
  clientes.rut, 
  clientes.nombre, 
  SUM(cuentas.saldo) as saldo_combinado
FROM clientes
JOIN cuentas ON clientes.rut = cuentas.rut_cliente
GROUP BY clientes.rut, clientes.nombre
HAVING COUNT(cuentas.id) > 1;



--7 listar todos los clientes y su saldo combinado de todos aquellos clientes que tengan al menos una cuenta con saldo negativo

SELECT clientes.nombre, SUM(cuentas.saldo) as total_saldo
FROM clientes
JOIN cuentas ON clientes.rut = cuentas.rut_cliente
WHERE cuentas.saldo < 0
GROUP BY clientes.nombre;




