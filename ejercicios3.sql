--EJERCICIOS
/*
1) Proveedor (codpro, nompro, status, ciudad)
              --CP--
2) Pieza (codpie, nompie, color, peso, ciudad)
         --CP--
3) Proyecto (codpj, nompj, ciudad)
              -CP-
	     _CE1_  _CE2__ CE3_
4) Ventas (codpro, codpie, codpj, cantidad, fecha)
			------CP-----------
*/
--3.1
    --Quita repetidos.
SELECT DISTINCT ciudad FROM proyecto;

--3.2
SELECT codpie FROM ventas;
SELECT DISTINCT codpie FROM ventas;
    --Si, ya que hay repetidos.

--3.3
SELECT * FROM pieza WHERE ((color='Gris' OR color='Rojo') AND ciudad='Madrid');

--3.4
SELECT * FROM ventas WHERE (cantidad BETWEEN 200 AND 300);

--3.5
SELECT * FROM pieza WHERE (nompie LIKE '%Tornillo%') OR (nompie LIKE '%tornillo%');

--3.6
SELECT table_name
FROM ALL_TABLES
WHERE TABLE_NAME like UPPER('%ventas');

--3.8
(SELECT DISTINCT codpj FROM ventas WHERE codpro='S2')
    MINUS
(SELECT DISTINCT codpj FROM ventas WHERE codpro!='S2');

--3.9
(SELECT DISTINCT ciudad FROM proveedor)
    UNION
(SELECT DISTINCT ciudad FROM pieza)
    UNION
(SELECT DISTINCT ciudad FROM proyecto);

--3.10
-- No borra repetidos.
(SELECT DISTINCT ciudad FROM proveedor)
    UNION ALL
(SELECT DISTINCT ciudad FROM pieza)
    UNION ALL
(SELECT DISTINCT ciudad FROM proyecto);

--3.11

SELECT * FROM ventas,proveedor;
    --115 tuplas

--3.12
(SELECT codpro, codpie, codpj FROM proveedor, proyecto, pieza 
    WHERE proveedor.ciudad = proyecto.ciudad AND proveedor.ciudad = pieza.ciudad)
    INTERSECT
(SELECT codpro, codpie, codpj FROM ventas);

--3.13
SELECT P1.nompro, P1.ciudad, P2.nompro, P2.ciudad FROM proveedor P1, proveedor P2 WHERE P1.ciudad != P2.ciudad AND P1.codpro < P2.codpro;

--3.14
(SELECT codpie, peso FROM pieza)
    MINUS
(SELECT x.codpie, x.peso FROM pieza x, pieza y WHERE x.peso < y.peso);

--3.15
    --Dar el nombre.
SELECT DISTINCT nompie FROM pieza 
    NATURAL JOIN 
(SELECT DISTINCT codpie FROM ventas, proveedor WHERE proveedor.ciudad = 'Madrid' AND proveedor.codpro = ventas.codpro);

    --Solo el codigo de pieza (y obtenerlo con natural join
SELECT DISTINCT codpie FROM ventas
    NATURAL JOIN
(SELECT DISTINCT codpro FROM proveedor WHERE ciudad = 'Madrid');

--3.16
/*Encuentra la ciudad y los c�digos de las piezas suministradas a cualquier 
proyecto por un proveedor que est� en la misma ciudad donde est� el proyecto.*/

SELECT DISTINCT codpie, ciudad FROM pieza
    NATURAL JOIN
(SELECT codpie FROM ventas
        NATURAL JOIN
(SELECT codpro,codpj,proveedor.ciudad FROM proveedor, proyecto WHERE proveedor.ciudad = proyecto.ciudad));

/*ORDER BY*/
--3.17
/*Comprobar la salida de la consulta anterior [Ejemplo 3.13] sin la cl�usula ORDER BY. */
SELECT nompro
FROM proveedor;

--3.18
/*Listar las ventas ordenadas por cantidad, si algunas ventas coinciden en la
cantidad se ordenan en funci�n de la fecha de manera descendente*/
SELECT * FROM ventas
ORDER BY cantidad DESC, fecha DESC;

--3.19
/*Mostrar las piezas vendidas por los proveedores de Madrid. (Fragmentando
la consulta con ayuda del operador IN.) Compara la soluci�n con la del ejercicio 3.15.*/

SELECT DISTINCT codpie FROM ventas 
WHERE codpro IN
(SELECT codpro FROM proveedor WHERE ciudad='Madrid');

--3.20
/*Encuentra los proyectos que est�n en una ciudad donde se fabrica alguna
pieza.*/

SELECT DISTINCT codpj FROM proyecto
WHERE ciudad IN
(SELECT ciudad FROM pieza);

--3.21
/*Encuentra los c�digos de aquellos proyectos que no utilizan ninguna pieza
roja que est� suministrada por un proveedor de Londres. */
SELECT DISTINCT codpj FROM ventas
WHERE codpie NOT IN
(SELECT codpie FROM pieza WHERE color='Rojo')
AND codpro NOT IN
(SELECT codpro FROM proveedor WHERE ciudad='Londres');


--Version AR puro
SELECT DISTINCT codpj FROM
(SELECT codpro, codpie, codpj FROM ventas
    MINUS
((SELECT codpro,codpie,codpj FROM pieza NATURAL JOIN (SELECT * FROM ventas) WHERE color='Rojo')
    INTERSECT
(SELECT codpro,codpie,codpj FROM proveedor NATURAL JOIN (SELECT * FROM ventas) WHERE ciudad='Londres')));


--3.22
/*Muestra el c�digo de las piezas cuyo peso es mayor que el peso de cualquier
�tornillo�*/
SELECT codpie, peso FROM pieza
WHERE peso > ALL (SELECT peso FROM pieza WHERE nompie LIKE '%Tornillo%');

--3.23
/*Ejercicio 3.23 Encuentra las piezas con peso m�ximo. Compara esta soluci�n con la obtenida
en el ejercicio 3.14*/
SELECT codpie FROM pieza
WHERE peso >= ALL (SELECT peso from pieza);


--3.24
/*Encontrar los c�digos de las piezas suministradas a todos los proyectos
localizados en Londres.*/

--AR
SELECT DISTINCT codpie FROM ventas
        MINUS
SELECT DISTINCT codpie FROM 
((SELECT DISTINCT codpie, codpj FROM (SELECT DISTINCT codpie FROM ventas),(SELECT codpj FROM proyecto WHERE ciudad='Londres'))
        MINUS
(SELECT DISTINCT codpie, codpj FROM ventas));


--MIXTO

SELECT DISTINCT codpie FROM pieza WHERE NOT EXISTS
    (
        (SELECT DISTINCT codpj FROM proyecto WHERE ciudad='Londres')
            MINUS
        (SELECT DISTINCT codpj FROM ventas WHERE pieza.codpie=ventas.codpie)
    );
    

SELECT codpj FROM
(
        (SELECT DISTINCT codpj FROM ventas)
            MINUS
        (SELECT  codpj FROM proyecto WHERE ciudad='Londres' )
);
    
    
--3.25    
--Profesora, primera deducci�n:
(SELECT codpro FROM proveedor)
    MINUS
(SELECT DISTINCT codpro FROM ventas NATURAL JOIN pieza WHERE ciudad NOT IN
(SELECT DISTINCT ciudad FROM proyecto));

 
--Yo, deducido:
SELECT DISTINCT codpro FROM ventas
    MINUS
SELECT DISTINCT codpro FROM (

    (SELECT DISTINCT codpro, codpie FROM (SELECT DISTINCT codpro FROM ventas),
    (SELECT DISTINCT codpie FROM (SELECT DISTINCT codpie,ciudad FROM pieza NATURAL JOIN (SELECT DISTINCT ciudad FROM proyecto))))
        MINUS
    (SELECT DISTINCT codpro, codpie FROM ventas))
;

--Lo que es
--Sofisticado:
SELECT codpro FROM proveedor
WHERE NOT EXISTS
(
    (SELECT DISTINCT codpro, ciudad FROM ventas, proyecto WHERE proveedor.codpro = ventas.codpro)
        MINUS
    (SELECT DISTINCT codpro, ciudad FROM ventas NATURAL JOIN (SELECT * FROM pieza) WHERE proveedor.codpro = ventas.codpro)
);

--3.26
SELECT COUNT(*) FROM ventas WHERE cantidad > 1000;

--3.27
SELECT MAX(peso) FROM pieza;

--3.28
SELECT codpie FROM pieza WHERE peso = ( SELECT MAX(peso) FROM pieza);

--3.29
    --No lo resuelve.
SELECT codpie, MAX(peso)
FROM pieza;

--3.30
SELECT codpro FROM ventas GROUP BY (codpro) HAVING COUNT(*) > 3;

--3.31
SELECT media, nompie FROM pieza
    NATURAL JOIN
(SELECT codpie, AVG(cantidad) media FROM ventas GROUP BY (codpie));

--3.32
SELECT codpro, AVG(cantidad) FROM ventas WHERE codpie = 'P1' GROUP BY codpro;

--3.33
SELECT codpie, codpj, SUM(cantidad) FROM ventas 
GROUP BY codpie, codpj
ORDER BY codpie, codpj;

--3.35
SELECT nompro, sumtotal FROM proveedor
    NATURAL JOIN
(SELECT codpro, SUM(cantidad) sumtotal FROM ventas GROUP BY (codpro) HAVING SUM(cantidad) > 1000);

--3.36
SELECT codpie, SUM(cantidad)
    FROM ventas
    GROUP BY codpie
    HAVING SUM(cantidad) = (SELECT MAX(SUM (X.cantidad))
                            FROM ventas X
                            GROUP BY X.codpie);

--3.38
SELECT AVG(cantidad), TO_CHAR(fecha,'MONTH') FROM ventas GROUP BY TO_CHAR(fecha,'MONTH');

--3.42
SELECT codpro FROM ventas 
    GROUP BY codpro 
    HAVING SUM(cantidad) > (SELECT SUM(cantidad) FROM ventas X WHERE codpro = 'S1');


 SELECT codpro, sum(cantidad)
    FROM ventas
    GROUP BY codpro
    HAVING SUM(cantidad) = (SELECT MAX(SUM(V1.cantidad))
                            FROM ventas V1
                            GROUP BY V1.codpro);
                            
--3.43
SELECT codpro 
    FROM ventas
    GROUP BY codpro
    HAVING SUM(cantidad) > ANY(SELECT SUM(cantidad) FROM  ventas V1 GROUP BY V1.codpro)
    ORDER BY SUM(cantidad) DESC;
    
    
--3.44

SELECT * FROM ventas NATURAL JOIN ;

SELECT ciudad FROM proyecto x 
NATURAL JOIN(SELECT DISTINCT codpj FROM ventas WHERE codpro = 'S3');

--3.45
SELECT codpro
    FROM ventas
    GROUP BY codpro HAVING count(*) > 10;
    
--3.46
SELECT DISTINCT codpro FROM ventas X WHERE NOT EXISTS
(
    (SELECT DISTINCT codpie  FROM ventas WHERE X.codpro = ventas.codpro)
        MINUS
    (SELECT DISTINCT codpie FROM ventas WHERE codpro = 'S1')
);


SELECT DISTINCT codpro FROM ventas
        MINUS
SELECT DISTINCT codpro FROM 
((SELECT DISTINCT codpro, codpie FROM (SELECT DISTINCT codpro FROM ventas),(SELECT DISTINCT codpie FROM ventas WHERE codpro='S1'))
        MINUS
(SELECT DISTINCT codpro, codpie FROM ventas));


INSERT INTO ventas VALUES ('S5','P2','J1',600,SYSDATE);
INSERT INTO ventas VALUES ('S5','P4','J1',666,SYSDATE);

DELETE FROM ventas WHERE codpro='S5' AND codpie='P2';
DELETE FROM ventas WHERE codpro='S5' AND codpie='P4';

--3.47
SELECT codpro, SUM(cantidad)
FROM ventas WHERE codpro IN
(SELECT DISTINCT codpro FROM ventas
        MINUS
SELECT DISTINCT codpro FROM 
((SELECT DISTINCT codpro, codpie FROM (SELECT DISTINCT codpro FROM ventas),(SELECT DISTINCT codpie FROM ventas WHERE codpro='S1'))
        MINUS
(SELECT DISTINCT codpro, codpie FROM ventas))) GROUP BY (codpro);

--3.48
SELECT DISTINCT codpj FROM ventas
    MINUS
SELECT DISTINCT codpj FROM
(SELECT DISTINCT codpj, codpro FROM (SELECT DISTINCT codpj FROM ventas),(SELECT DISTINCT codpro FROM ventas WHERE codpie='P3')
    MINUS
(SELECT DISTINCT codpj, codpro FROM ventas));

--3.49
SELECT codpro, AVG(cantidad) 
    FROM ventas WHERE codpro IN (SELECT DISTINCT codpro FROM ventas WHERE codpie='P3') 
    GROUP BY (codpro);


--3.50
SELECT INDEX_NAME, TABLE_NAME FROM USER_INDEXES;

--3.51

--3.52
SELECT codpro, AVG(cantidad), TO_CHAR(fecha,'YYYY') FROM ventas GROUP BY(TO_CHAR(fecha,'YYYY'),codpro) ORDER BY codpro ASC;

--3.53
SELECT codpro FROM ventas 
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Rojo') GROUP BY (codpro) HAVING COUNT(*) = 1;

--3.54
SELECT DISTINCT codpro FROM ventas 
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Rojo');

--3.55


--3.56
SELECT codpro FROM ventas 
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Rojo') GROUP BY (codpro) HAVING COUNT(*) > 1;

--3.57
(SELECT DISTINCT codpro FROM ventas 
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Rojo'))
     MINUS
(SELECT DISTINCT codpro FROM ventas WHERE codpro IN
(SELECT DISTINCT codpro FROM ventas 
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Rojo')) AND cantidad <= 10);

--3.58
UPDATE proveedor 
    SET status='1'
    WHERE codpro IN (SELECT DISTINCT codpro FROM ventas
        NATURAL JOIN
(SELECT codpro FROM ventas GROUP BY (codpro) HAVING COUNT(DISTINCT codpie) = 1) WHERE codpie='P1');

--3.59



--3.60 Muestra la informaci�n disponible acerca de los encuentros de liga

SELECT * FROM encuentros;

--3.61 Muestra los nombres de los equipos y de los jugadores jugadores ordenados alfab�ticamente.

SELECT nombree, nombrej FROM equipos NATURAL JOIN jugadores ORDER BY nombree, nombrej;

--3.62 Muestra los jugadores que no tienen ninguna falta.

SELECT codj FROM jugadores WHERE codj NOT IN (SELECT codj FROM faltas);

--3.63 Muestra los compa�eros de equipo del jugador que tiene por c�digo x (codJ=�x�) y donde x es uno elegido por ti

SELECT codj FROM jugadores WHERE codj LIKE 'C%' AND codj!='C2';

--3.64  Muestra los jugadores y la localidad donde juegan (la de sus equipos).

SELECT codj, localidad FROM jugadores NATURAL JOIN (SELECT code, localidad FROM equipos);

--3.65 Muestra los equipos que han ganado alg�n encuentro jugando como local
-- EQ1 es Local y EQ2 es Visitante.
SELECT DISTINCT eq1 FROM encuentros WHERE RES1 > RES2 ORDER BY eq1;

--3.66 Muestra los equipos que han ganado alg�n encuentro

SELECT DISTINCT code FROM equipos WHERE code IN (SELECT eq1 FROM encuentros WHERE RES1 > RES2) OR code IN (SELECT eq2 FROM encuentros WHERE RES2>RES1);

--3.67 Muestra los equipos que todos los encuentros que han ganado lo han hecho como equipo local. 
    --Selecciona equipos locales que en un encuentro no perdieron como equipo local y no ganaron como visitante.
SELECT DISTINCT eq1 FROM encuentros WHERE eq1 NOT IN
(SELECT DISTINCT eq1 FROM encuentros WHERE RES2 > RES1)
 AND eq1 NOT IN
(SELECT DISTINCT eq2 FROM encuentros WHERE RES2 > RES1);


--3.68 Muestra los equipos que han ganado todos los encuentros jugando como equipo local. 


--3.69 Muestra los encuentros que faltan para terminar la liga

SELECT x.code local,y.code visitante FROM equipos x, equipos y WHERE x.code != y.code
    MINUS
(SELECT eq1, eq2 FROM encuentros);


--3.70 Muestra los encuentros que tienen lugar en la misma localidad.

SELECT x.eq1, x.eq2 , x.fecha FROM (SELECT eq1,eq2,fecha,localidad FROM encuentros JOIN (equipos) ON encuentros.eq1 = equipos.code) x,
                (SELECT eq1, localidad FROM encuentros JOIN (equipos) ON encuentros.eq1 = equipos.code) y WHERE x.localidad = y.localidad AND x.eq1 != y.eq1;


--3.71 Para cada equipo muestra el n�mero de encuentros que ha disputado como local. 

SELECT eq1, COUNT(*) Nro_encuentros_como_local FROM encuentros GROUP BY(eq1);

--3.72 Muestra los encuentros en los que se alcanz� mayor diferencia.

SELECT eq1,eq2 FROM encuentros GROUP BY (eq1,eq2) HAVING MAX(res1-res2) = (SELECT MAX(res1-res2)FROM encuentros) 
OR MAX(res2-res1) = (SELECT MAX(res2-res1) FROM encuentros);

--3.73 Muestra los jugadores que no han superado 3 faltas acumuladas

SELECT codj FROM faltas GROUP BY (codj) HAVING SUM(num) < 4 ;

--3.74 Muestra los equipos con mayores puntuaciones en los partidos jugados fuera de casa. 

SELECT eq2 FROM encuentros GROUP BY (eq2) HAVING MAX(res2) = (SELECT MAX(res2) FROM encuentros);

--3.75 Muestra todas las victorias de cada equipo, jugando como local o como visitante. 

SELECT * FROM encuentros WHERE res1 > res2;

--3.76 Muestra el equipo con mayor n�mero de victorias
SELECT code FROM equipos WHERE code IN
((SELECT eq1 FROM encuentros WHERE res1 > res2 GROUP BY eq1 HAVING COUNT(*) 
            >= ALL( SELECT COUNT(*) FROM encuentros WHERE res1 > res2 GROUP BY eq1))
            UNION
(SELECT eq2 FROM encuentros WHERE res2 > res1 GROUP BY eq2 HAVING COUNT(*) 
            >= ALL( SELECT COUNT(*) FROM encuentros WHERE res2 > res1 GROUP BY eq2)));

--3.77 Muestra el promedio de puntos por equipo en los encuentros de ida

SELECT eq2, AVG(res2) FROM encuentros GROUP BY eq2;

--3.78 Muestra el equipo con mayor n�mero de puntos en total de los encuentros jugados. 

SELECT X,SUM(Y) FROM
((SELECT eq1 X, res1 Y FROM encuentros)
    UNION ALL
(SELECT eq2 X, res2 Y FROM encuentros)) GROUP BY X HAVING SUM(Y) = (SELECT MAX(SUM(Y)) FROM
                                                                    ((SELECT eq1 X, res1 Y FROM encuentros)
                                                                        UNION ALL
                                                                    (SELECT eq2 X, res2 Y FROM encuentros)) GROUP BY X);

--4.1 Crear una vista con los proveedores de Londres. �Qu� sucede si insertamos
    --en dicha vista la tupla (�S7�,�Jose Suarez�,3,�Granada�)?. (Buscar en [8] la cl�usula WITH CHECK OPTION )
    
CREATE VIEW proveLondres (codpro, nompro, status, ciudad) AS
SELECT codpro, nompro, status, ciudad FROM proveedor WHERE ciudad='Londres';
    
INSERT INTO proveLondres VALUES('S7','Jose Suarez',3,'Granada');
--Te deja insertarlo.

CREATE OR REPLACE VIEW proveLondres (codpro, nompro, status, ciudad) AS
SELECT codpro, nompro, status, ciudad FROM proveedor WHERE ciudad='Londres' WITH CHECK OPTION;
--Ahora no permite insersi�n

--4.2 Crear una vista con los nombres de los proveedores y sus ciudades. Inserta
    --sobre ella una fila y explica cu�l es el problema que se plantea. �Habr�a problemas de
    --actualizaci�n? 
    
CREATE VIEW provCiu (nompro,ciudad) AS
SELECT nompro, ciudad FROM proveedor;

INSERT INTO provCiu VALUES ('Antonio','Valencia');
--Si, no se tiene la clave primaria.


--4.3 Crear una vista donde aparezcan el c�digo de proveedor, el nombre de proveedor y el c�digo del proyecto 
    --tales que la pieza sumistrada sea gris. Sobre esta vista realiza
    --alguna consulta y enumera todos los motivos por los que ser�a imposible realizar una inserci�n.
    
CREATE VIEW proGris (codpro,nompro,codpj) AS
(SELECT DISTINCT codpro, nompro, codpj FROM proveedor
    NATURAL JOIN
(SELECT codpro, codpj FROM ventas
    NATURAL JOIN
(SELECT codpie FROM pieza WHERE color='Gris')));
    
INSERT INTO proGris VALUES('G4','El pana','J99');
    --No se permite por el uso de las funciones entre m�s de una tabla
    
    
    
--5.1 Ver la descripci�n de la vista del cat�logo USER_TABLES. 
DESCRIBE USER_TABLES;

--5.2 


--*******EJEMPLOS
--3.1 
    --Esto es el equivalente a Proyecci�n
SELECT ciudad FROM proyecto;

--3.2
SELECT * FROM proveedor;
SELECT codpro, nompro, status, ciudad FROM proveedor;

--3.3 
    --Seleccion
SELECT codpro FROM ventas WHERE codpj='J1';

--3.4
SELECT nompro, ciudad FROM proveedor WHERE ciudad LIKE 'L%';

--3.5
    --Uso de operadores aritm�ticos y funciones num�ricas.
SELECT cantidad/12, round(cantidad/12,3), trunc(cantidad/12,3),
floor(cantidad/12), ceil(cantidad/12)
FROM ventas WHERE (cantidad/12)>10;

--3.6
SELECT codpro, nompro FROM proveedor WHERE status IS NOT NULL;

--3.7
SELECT table_name
FROM ALL_TABLES
WHERE TABLE_NAME like '%ventas';

--3.8
(SELECT DISTINCT ciudad FROM proveedor WHERE status>2)
    MINUS
(SELECT DISTINCT ciudad FROM pieza WHERE codpie='P1');

--3.13
SELECT nompro
FROM proveedor
ORDER BY nompro;

--3.14
/*Encontrar las piezas suministradas por proveedores de Londres. (Sin usar el
operador de reuni�n.)*/
SELECT codpie
FROM ventas
WHERE codpro IN
(SELECT codpro FROM proveedor WHERE ciudad = 'Londres');

--3.15
SELECT codpro
FROM proveedor
WHERE EXISTS (SELECT * FROM ventas
WHERE ventas.codpro = proveedor.codpro
AND ventas.codpie='P1');

--3.16
SELECT codpro
FROM proveedor
WHERE status = (SELECT status FROM proveedor WHERE codpro='S3');

--3.17
SELECT codpie
FROM pieza
WHERE peso > ANY
(SELECT peso FROM pieza WHERE nompie LIKE 'Tornillo%');

--3.23
SELECT v.codpro, v.codpj, j.nompj, AVG(v.cantidad)
FROM ventas v, proyecto j
WHERE v.codpj=j.codpj
GROUP BY (v.codpj, j.nompj,v.codpro);

--3.24
 SELECT codpro, sum(cantidad)
    FROM ventas
    GROUP BY codpro
    HAVING SUM(cantidad) = (SELECT MAX(SUM(V1.cantidad))
                            FROM ventas V1
                            GROUP BY V1.codpro);
                            
--3.26
SELECT * FROM ventas
WHERE fecha BETWEEN TO_DATE('01/01/2002','DD/MM/YYYY') AND
TO_DATE('31/12/2004','DD/MM/YYYY');