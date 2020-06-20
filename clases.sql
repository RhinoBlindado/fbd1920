/*PRACTICAS DE FBD*/

/*-----CLASE 02/03/2020 INICIO------*/
/*CAPITULO 1*/
/*Ejercicio 1.1: Hacer una tabla prueba*/
CREATE TABLE prueba1(
    cad char(3),
    n int,
    x float);
    
CREATE TABLE prueba2(
    cad1 char(8),
    num int);

/*Ejercicio 1.2: Descripcion de una tabla. Es lo mismo que verla en la pesta?a pero esto sirve tambien*/
DESCRIBE prueba1

/*Ejemplo 1.1*/
CREATE TABLE plantilla
(
    dni varchar2(9),
    nombre varchar2(15),
    estadocivil varchar2(10)
    CHECK (estadocivil IN ('soltero', 'casado', 'divorciado', 'viudo')),
    fechaalta date,
    PRIMARY KEY (dni)
);
    
/*Ejercicio 1.4*/
CREATE TABLE serjefe
(
    dnijefe REFERENCES plantilla(dni),
    dnitrabajador REFERENCES plantilla(dni),
    PRIMARY KEY (dnitrabajador)
);    
    
/*Ejercicio 1.5*/
DROP TABLE prueba1;

/*Ejercicio 1.6*/
ALTER TABLE plantilla ADD (fechaBaja DATE);

ALTER TABLE plantilla ADD CONSTRAINT fechas CHECK(fechaAlta <= fechaBaja);

ALTER TABLE prueba2 DROP COLUMN num;

ALTER TABLE plantilla MODIFY estadocivil VARCHAR2(15);


/*Apartado 1.7 / Ejercicio 1.7*/
/*Se crean estas tablas...*/
CREATE TABLE proveedor
(
    codpro VARCHAR2(3) CONSTRAINT codpro_no_nulo NOT NULL
    CONSTRAINT codpro_clave_primaria PRIMARY KEY,
    nompro VARCHAR2(30) CONSTRAINT nompro_no_nulo NOT NULL,
    status NUMBER CONSTRAINT status_entre_1_y_10
    CHECK (status>=1 and status<=10),
    ciudad VARCHAR2(15)
);

CREATE TABLE pieza 
(
    codpie VARCHAR2(3) CONSTRAINT codpie_clave_primaria PRIMARY KEY,
    nompie VARCHAR2(10) CONSTRAINT nompie_no_nulo NOT NULL,
    color VARCHAR2(10),
    peso NUMBER(5,2)
    CONSTRAINT peso_entre_0_y_100 CHECK (peso>0 and peso<=100),
    ciudad VARCHAR2(15)
);

CREATE TABLE proyecto
(
    codpj VARCHAR2(3) CONSTRAINT codpj_clave_primaria PRIMARY KEY,
    nompj VARCHAR2(20) CONSTRAINT nompj_no_nulo NOT NULL,
    ciudad VARCHAR2(15)
);

CREATE TABLE ventas 
(
    codpro CONSTRAINT codpro_clave_externa_proveedor
    REFERENCES proveedor(codpro),
    codpie CONSTRAINT codpie_clave_externa_pieza
    REFERENCES pieza(codpie),
    codpj CONSTRAINT codpj_clave_externa_proyecto
    REFERENCES proyecto(codpj),
    cantidad NUMBER(4),
    CONSTRAINT clave_primaria PRIMARY KEY (codpro,codpie,codpj)
);

ALTER TABLE ventas ADD (fecha DATE);

/*Ejercicio 1.8*/
CREATE TABLE equipos
(
    codE CHAR(4) PRIMARY KEY,
    nombreE VARCHAR2(15) NOT NULL UNIQUE,
    localidad VARCHAR2(30) NOT NULL,
    entrenador VARCHAR2(30) NOT NULL,
    fecha_crea DATE NOT NULL
);

CREATE TABLE jugadores
(
    codJ CHAR(4) PRIMARY KEY,
    codE REFERENCES equipos(codE) NOT NULL,
    nombreJ VARCHAR2(30) NOT NULL
);

CREATE TABLE encuentros
(
    ELocal CONSTRAINT claveExtLocal REFERENCES  equipos(codE),
    EVisitante CONSTRAINT claveExtVisitante REFERENCES equipos(codE),
    fecha DATE,
    pLocal INT DEFAULT 0 CONSTRAINT localMayorCero CHECK (pLocal >= 0),
    pVisitante INT DEFAULT 0 CONSTRAINT visitanteMayorCero CHECK (pVisitante >= 0),
    CONSTRAINT clavePrimaria PRIMARY KEY(ELocal,Evisitante)
);


/*CAPITULO 2*/
/*Ejemplo 2.1*/
INSERT INTO prueba2 VALUES ('aa',1);
INSERT INTO prueba2 VALUES('Aa',2);
INSERT INTO prueba2 VALUES ('aa',1);

/*Ejemplo 2.2*/
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta) VALUES ('12345678','Pepe','soltero', SYSDATE);
INSERT INTO plantilla (dni,nombre,estadocivil,fechaalta) VALUES ('87654321','Juan', 'casado', SYSDATE);
INSERT INTO serjefe VALUES ('87654321','12345678');
INSERT INTO plantilla (dni, estadocivil) VALUES ('11223344','soltero');

/*Ejercicio 2.1*/
SELECT * FROM prueba;
SELECT * FROM plantilla;

INSERT INTO proyecto VALUES ('J1','Proyecto 1','Londres');
INSERT INTO proyecto VALUES ('J2','Proyecto 2','Londres');
INSERT INTO proyecto VALUES ('J3','Proyecto 3','Paris');
INSERT INTO proyecto VALUES ('J4','Proyecto 4','Roma');

SELECT * FROM opc.proveedor;

INSERT INTO proveedor SELECT * FROM opc.proveedor;
INSERT INTO pieza SELECT * FrOM opc.pieza;
INSERT INTO ventas SELECT * FROM opc.ventas;

/*-----CLASE 02/03/2020 FIN------*/
/*-----CLASE 16/04/2020 INICIO---*/
--EJEMPLO 2.3
UPDATE plantilla 
    SET estadocivil = 'divorciado'
    WHERE nombre = 'Juan';
/* En WHERE es recomendable usar la CP, ya que sino, puede 
actualizar todo lo que encuentre con ese mismo patrón*/

/*EJERCICIO 2.2*/
UPDATE PLANTILLA
SET NOMBRE = 'Luis'
WHERE DNI = '12345678';

/*EJEMPLO 2.4*/    
DELETE FROM prueba2;

/*EJERCICIO 2.3*/
DELETE FROM PLANTILLA;
/*No se puede porque SerJefe tiene una restricción de
integridad y hay que borrar en el orden inverso al creado.*/

DELETE FROM SERJEFE;
DELETE FROM PLANTILLA;

/*2.1.2*/
SELECT * FROM USER_TABLES;

/*2.1.5 - TIPO DE DATO DATE*/
/*UPDATE PLANTILLA ... */

INSERT INTO PLANTILLA
    VALUES ('11223355','MIGUEL','casado',
    TO_DATE ('22/10/2005','DD/MM/YYYY'),NULL);

/*EJEMPLO 2.6*/
SELECT TO_CHAR(fechaalta,'day') FROM plantilla;

/*EJERCICIO 2.4*/
/*YA HECHO ANTERIORMENTE...*/
INSERT INTO ventas VALUES ('S3', 'P1', 'J1', 150, '24/12/05');

INSERT INTO ventas (codpro, codpj) VALUES ('S4', 'J2');

/*Forma antigua de pasar los datos... Ver el TO_DATE*/
INSERT INTO ventas VALUES('S5','P3','J6',400,TO_DATE('25/12/00'));

/*EJERCICIO 2.5*/
UPDATE ventas
    SET fecha = TO_DATE(2005,'YYYY')
    WHERE codpro='S5';
    
    
/*EJERCICIO 2.6*/
SELECT codpro,codpie, TO_CHAR(fecha, '"Dia" day,dd/mm/yy') FROM ventas;

SELECT codpro,codpie, TO_CHAR(fecha, '"Dia" day,dd/mm/yy') AS Fecha FROM ventas;

/*EJERCICIO 2.4.1*/
INSERT INTO equipos VALUES('1','Granada','Granada','???',SYSDATE);
UPDATE equipos SET entrenador='Pablo Pin' WHERE  code='1';
UPDATE equipos SET fecha_crea=fecha_crea-365 WHERE code='1';

INSERT INTO jugadores VALUES('J1','1','Carlos Corts');
DELETE FROM jugadores WHERE codj='1';
----        CAPITULO 3
    
/*--3.2.1*/
/*---Ejemplo 3.1*/
/*----No funciona tal cual como la proyección; no elimina
        repetidos*/
SELECT ciudad FROM proyecto;

SELECT DISTINCT ciudad FROM proyecto;
SELECT DISTINCT codpj,ciudad FROM proyecto;

/*---Ejemplo 3.2*/
/*----Esto no se puede hacer en álgebra relacional.*/
SELECT * FROM proveedor;

/*---Ejercicio 3.2*/
SELECT codpro,codpie,codpj from ventas;
/*No se repetirán (no hay que usar DISTINT) ya que son las CPs*/

/*---Ejemplo 3.3*/
SELECT DISTINCT codpro FROM ventas WHERE codpj='J1';

/*---Ejercicio 3.3*/
SELECT codpie FROM pieza WHERE ciudad='Madrid' AND (color='Gris' OR color='Rojo' );  

/*---Ejercicio 3.4*/
SELECT codpro, codpie, codpj, cantidad FROM ventas WHERE cantidad>=200 AND cantidad<=300;

/*Ejemplo 3.4*/
SELECT nompro, ciudad FROM proveedor WHERE ciudad LIKE 'L%';

--Revisar
SELECT codpro FROM pieza WHERE nompie LIKE '%Tornillo%' OR nompie LIKE '%tornillo%';

--Ejemplo 3.5
SELECT cantidad/12, round(cantidad/12,3), trunc(cantidad/12,3),
floor(cantidad/12), ceil(cantidad/12)
FROM ventas WHERE (cantidad/12)>10;

--Ejemplo 3.6

--Ejemplo 3.7
SELECT table_name FROM ALL_TABLES WHERE TABLE_NAME LIKE 'ventas';

--EJERCICIO 3.6
SELECT owner, table_name FROM ALL_TABLES WHERE TABLE_NAME LIKE UPPER('ventas');

SELECT codpro, nompro FROM proveedor WHERE status IS NULL;
/*-----CLASE 16/04/2020 FIN------*/
/*-----CLASE 24/04/2020 INICIO---*/

--Ejemplo 3.8
--El DISTINCT es para evitar las tuplas repetidas
(SELECT DISTINCT ciudad FROM proveedor WHERE status>2)
MINUS 
(SELECT DISTINCT ciudad FROM pieza WHERE codpie='P1');

--Ejercicio 3.7
(SELECT DISTINCT ciudad FROM proveedor WHERE status>2)
INTERSECT
(SELECT DISTINCT ciudad FROM pieza WHERE codpie!='P1');


--Ejercicio 3.8
(SELECT DISTINCT codpj FROM ventas WHERE codpro='S1')
MINUS
(SELECT DISTINCT codpj FROM ventas WHERE codpro!='SI');

--Ejercicio 3.9
(SELECT ciudad FROM pieza) UNION (SELECT ciudad FROM proveedor) UNION (SELECT ciudad FROM proyecto);

--Ejercicio 3.10
--Notar que no borra repeditos
(SELECT ciudad FROM pieza) UNION ALL (SELECT ciudad FROM proveedor) UNION ALL (SELECT ciudad FROM proyecto);


--Producto Cartesiano
SELECT * FROM ventas, proveedor;

--Ejemplo 3.10
SELECT codpro,codpie,codpj
FROM proveedor, proyecto, pieza
WHERE Proveedor.ciudad='Londres' AND Proyecto.ciudad='Londres'
AND Pieza.ciudad='Londres';

--Ejercicio 3.12

(SELECT codpro, codpie, codpj
FROM proveedor, proyecto, pieza
WHERE Proveedor.ciudad=Proyecto.ciudad
AND Proyecto.ciudad=Pieza.ciudad)

INTERSECT

(SELECT codpro,codpie,codpj FROM );



--3.2.6
SELECT codpro, codpie, codpj
FROM proveedor S, proyecto Y, pieza P
WHERE S.ciudad=Y.ciudad and Y.ciudad=P.ciudad;

--Ejercicio 3.13
SELECT X.codpro, Y.codpro
FROM proveedor X, proveedor Y
WHERE X.ciudad != Y.ciudad AND x.codpro < y.codpro;

--Ejemplo 3.12
--Basica
SELECT nompro, cantidad FROM proveedor p , ventas v
WHERE cantidad > 800 AND p.codpro=v.codpro;

--Con Natural Join
SELECT nompro, cantidad
FROM proveedor NATURAL JOIN 
(SELECT * FROM ventas WHERE cantidad>800);
--El parentesis es para diferencias entre el SELECT interno y externo.
--Subconsulta en FROM, tratarla como nueva tabla.
SELECT nompro, cantidad
FROM proveedor s, (SELECT * FROM ventas WHERE cantidad>800) v
WHERE s.codpro= v.codpro;

--Theta Reunion
SELECT nompro, cantidad
FROM proveedor s JOIN (SELECT * FROM ventas WHERE cantidad>800) v
ON (s.codpro=v.codpro);

--Ejercicio 3.15

SELECT DISTINCT codpie FROM ventas NATURAL JOIN (SELECT codpro FROM proveedor WHERE ciudad='Roma');

--Sin NATURAL JOIN
SELECT DISTINCT codpie FROM ventas,(SELECT codpro FROM proveedor WHERE ciudad='Madrid') x
WHERE ventas.codpro=x.codpro;

--Ejercicio 3.16
SELECT DISTINCT codpie, ciudad
FROM(SELECT DISTINCT codpro, codpie, codpj FROM (SELECT codpro,codpj
FROM proveedor NATURAL JOIN proyecto) NATURAL JOIN ventas)
NATURAL JOIN pieza;

SELECT DISTINCT X.codpie, X.ciudad
FROM proveedor P, proyecto J, ventas V, pieza X
WHERE P.ciudad=J.ciudad AND V.codpro=P.codpro AND V.codpj=J.codpj AND V.codpie=X.codpie;

SELECT DISTINCT X.codpie, X.ciudad
FROM proveedor P, proyecto J, ventas V, pieza X
WHERE P.ciudad=J.ciudad AND V.codpro=P.codpro AND V.codpj=J.codpj AND V.codpie=X.codpie;

--Ordenacion
--Ejemplo 3.13
SELECT nompro
FROM proveedor
ORDER BY nompro;

--Ejercicio 3.15 ordenado
SELECT DISTINCT codpie FROM ventas NATURAL JOIN (SELECT codpro FROM proveedor WHERE ciudad='Madrid') ORDER BY codpie;

--Ejercicio 3.18
SELECT * FROM ventas ORDER BY cantidad DESC, fecha DESC;

--
SELECT codpie
FROM ventas
WHERE codpro IN
(SELECT codpro FROM proveedor WHERE ciudad = 'Londres');

SELECT codpro
FROM proveedor
WHERE EXISTS (SELECT * FROM ventas
WHERE ventas.codpro = proveedor.codpro
AND ventas.codpie='P1');

--EJ 3.19
SELECT DISTINCT codpie FROM ventas NATURAL JOIN (SELECT codpro FROM proveedor WHERE ciudad='Madrid');

SELECT DISTINCT codpie
    FROM ventas
    WHERE codpro IN
    (SELECT codpro FROM proveedor WHERE ciudad = 'Madrid');
    

--EJ 3.20
SELECT codpj FROM proyecto 
WHERE ciudad IN (SELECT DISTINCT ciudad FROM pieza);

--EJ 3.21
SELECT DISTINCT codpj FROM ventas WHERE codpie NOT IN
(SELECT codpie FROM pieza WHERE color = 'Rojo') AND
codpro NOT IN(SELECT codpro FROM proveedor WHERE ciudad='Londres');

/*-----CLASE 24/04/2020 FIN------*/
/*-----CLASE 30/04/2020 INICIO---*/
--EJ 3.21 
SELECT codpie FROM pieza WHERE color='Rojo';

SELECT codpro FROM proveedor WHERE ciudad='Londres';

SELECT DISTINCT codpj FROM ventas WHERE codpie 
    NOT IN(SELECT codpie FROM pieza WHERE color='Rojo')
    AND
    codpro NOT IN(SELECT codpro FROM proveedor WHERE ciudad='Londres');


--EX 3.19
SELECT MAX(cantidad), MIN(cantidad), SUM(cantidad) FROM ventas;
SELECT MAX(DISTINCT cantidad), MIN(DISTINCT cantidad), SUM(DISTINCT cantidad) FROM ventas;

--EJ 3.26
--COUNT cuenta filas.
SELECT COUNT(*) FROM ventas WHERE cantidad > 1000;

--EJ 3.27
SELECT MAX(peso) FROM pieza;

--EJ 3.28
--Calcular peso máximo de tres maneras diferentes
--Tipo AR
(SELECT codpie FROM pieza) MINUS ( SELECT P.codpie FROM pieza P, pieza Q WHERE P.peso < Q.peso);

--Tipo ALL
SELECT codpie FROM pieza WHERE peso >= ALL (SELECT peso FROM pieza);

--Reunion Natural                                       v-- renombrado
SELECT codpie FROM pieza NATURAL JOIN (SELECT MAX(peso) peso FROM pieza);

--Version Elegante
SELECT codpie FROM pieza WHERE peso = (SELECT MAX(peso) FROM pieza);

--EJ 3.29
SELECT codpie, MAX(peso) FROM pieza;
--No funciona ya que se está juntando una expresion individual de columna.

--EJ 3.30
SELECT DISTINCT a.codpro FROM ventas a, ventas b, ventas c 
            WHERE a.codpro = b.codpro AND b.codpro = c.codpro 
            AND ((a.codpj != b.codpj) OR (a.codpie != c.codpie));


---Grupos
 SELECT codpro, COUNT(*), MAX(cantidad)
FROM ventas
GROUP BY (codpro);


--EJ 3.31
SELECT nompie, media from pieza 
    NATURAL JOIN 
    (SELECT codpie, AVG(cantidad) media 
    FROM ventas GROUP BY (codpie));
    

--EJ 3.32    
SELECT codpro, AVG(cantidad) 
    FROM ventas WHERE codpie='P1'
    GROUP BY codpro;

--EJ 3.33
SELECT DISTINCT codpie, codpj, SUM(cantidad) FROM ventas
GROUP BY codpie, codpj
ORDER BY codpie, codpj;


--Ejemplo Condicional
SELECT codpro, AVG(cantidad)
FROM ventas
GROUP BY (codpro)
HAVING COUNT(*) >3;


--EX 3.22
Select codpro, codpie, AVG(cantidad)
FROM ventas
WHERE codpie='P1'
GROUP BY (codpro, codpie) HAVING COUNT(*) BETWEEN 2 AND 10;

--
SELECT v.codpro, v.codpj, j.nompj, AVG(v.cantidad)
FROM ventas v, proyecto j
WHERE v.codpj=j.codpj
GROUP BY (v.codpj, j.nompj,v.codpro);


--EJ 3.34
SELECT nompro, totventa FROM proveedor 
NATURAL JOIN 
(SELECT codpro, SUM(cantidad) totventa FROM ventas
    GROUP BY codpro
    HAVING SUM(cantidad) > 1000);

--EX
SELECT codpro, sum(cantidad)
    FROM ventas
    GROUP BY codpro
    HAVING SUM(cantidad) = 
    (SELECT MAX(SUM(V1.cantidad))
    FROM ventas V1
    GROUP BY V1.codpro);
    
    
SELECT codpie, sum(cantidad)
    FROM ventas
    GROUP BY codpie
    HAVING SUM (cantidad) = 
    (SELECT MAX(SUM(V1.cantidad))
    FROM ventas V1
    GROUP BY  V1.codpie);
    
    
--EJ 3.39
SELECT codpro, SUM(cantidad) FROM ventas 
    GROUP BY codpro
    HAVING SUM(cantidad) > (SELECT SUM(cantidad) FROM ventas WHERE codpro='S1');

/*-----CLASE 30/04/2020 FIN------*/
/*-----CLASE 07/05/2020 INICIO---*/
--EX 3.5
(SELECT codpro FROM ventas)
MINUS
    (SELECT codpro
        FROM (
        (SELECT v.codpro,p.codpie FROM
        (SELECT DISTINCT codpro FROM ventas) v,
        (SELECT codpie FROM pieza) p
    )
    MINUS
    (SELECT codpro,codpie FROM ventas)
    )
);

--EJ 3.24
--AR
(SELECT distinct codpie from ventas)
minus
(select distinct codpie from);
--CR
/*-----CLASE 07/05/2020 FIN---*/
/*-----CLASE 14/05/2020 INICIO---*/
--5.1
SELECT * FROM USER_TABLES; 

--3.30
DESCRIBE DICTIONARY;

SELECT * FROM DICTIONARY WHERE table_name LIKE '%INDEX%';

SELECT * FROM USER_INDEXES;

--3.4
SELECT owner, table_name  FROM ALL_TABLES WHERE table_name LIKE '%VENTAS%';

--3.5
SELECT * FROM DICTIONARY WHERE table_name LIKE '%OBJECT%';

SELECT * FROM USER_OBJECTS;


--Cap 5, vuelta...

CREATE TABLE acceso
(
    testigo NUMBER
);

INSERT INTO acceso VALUES(16);
INSERT INTO acceso VALUES(2059);

GRANT SELECT ON acceso TO x9108766;

SELECT * FROM rocio.acceso;

REVOKE SELECT ON acceso FROM x9108766;

GRANT SELECT ON acceso TO x9108766 WITH GRANT OPTION;

GRANT SELECT ON rocio.acceso TO x9108766;

SELECT * FROM X5313908.acceso;

REVOKE SELECT ON acceso FROM x9108766;

--CAP 6

CREATE INDEX indice_proveedor ON proveedor(nompro);

SELECT * FROM user_indexes;

CREATE INDEX indiprov ON proveedor(nompro,status);

DROP INDEX indiprov;
DROP INDEX indice_proveedor;

CREATE TABLE Prueba_Bit (color Varchar2(10));

CREATE INDEX Prueba_IDX ON Prueba_Bit(color);

SELECT count(*) FROM Prueba_Bit WHERE color='Amarillo' OR color= 'Azul';

DROP INDEX Prueba_IDX;

CREATE BITMAP INDEX Prueba_BITMAP_IDX ON Prueba_Bit(color);

DROP TABLE Prueba_Bit;

CREATE TABLE Prueba_IOT (id NUMBER PRIMARY KEY) ORGANIZATION INDEX;

CREATE CLUSTER cluster_codpro(codpro VARCHAR2(3));

CREATE TABLE proveedor2(
codpro VARCHAR2(3) PRIMARY KEY,
nompro VARCHAR2(30) NOT NULL,
status NUMBER(2) CHECK(status>=1 AND status<=10),
ciudad VARCHAR2(15))
CLUSTER cluster_codpro(codpro);
CREATE TABLE ventas2(
codpro VARCHAR2(3) REFERENCES proveedor2(codpro),
codpie REFERENCES pieza(codpie),
codpj REFERENCES proyecto(codpj),
cantidad NUMBER(4),
fecha DATE,
PRIMARY KEY (codpro,codpie,codpj))
CLUSTER cluster_codpro(codpro);

CREATE INDEX indice_cluster ON CLUSTER cluster_codpro;

INSERT INTO proveedor2 SELECT * FROM proveedor;

INSERT INTO ventas2 SELECT * FROM ventas;

SELECT codpro FROM ventas2;

SELECT * FROM USER_OBJECTS ORDER BY created DESC;

--Los ultimos temas no caen, pero hay información que cae en el examen.

/*-----CLASE 14/05/2020 FIN------*/
/*------------APENDICE-----------*/
COMMIT;