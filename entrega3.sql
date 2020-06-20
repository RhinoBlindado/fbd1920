--1) Mostrar los datos completos de los equipos que no han ganado ningï¿½n encuentro fuera de casa (como equipo visitante)


SELECT * FROM equipos WHERE code NOT IN
(SELECT DISTINCT eq2 FROM encuentros WHERE RES2 > RES1);

--2) Indique cual es el/los director/es de departamento que imparta/n mayor cantidad de grupos teï¿½ricos (tipo 'T').
SELECT NRP FROM grupos WHERE NRP IN
((SELECT DISTINCT director FROM departamento)
INTERSECT
(SELECT DISTINCT NRP FROM grupos WHERE tipo='T')) 
GROUP BY NRP HAVING COUNT(*) >= ANY (SELECT COUNT(*) FROM grupos G WHERE G.tipo='T' GROUP BY (G.nrp));

--3) Mostrar los equipos que han alineado a todos sus jugadores en los partidos jugados en casa.
INSERT INTO faltas VALUES('B4','RMA','VAL',4);


SELECT y.codj, y.code FROM jugadores y
    JOIN
(SELECT codj, eq1 FROM faltas WHERE num > 0) x ON y.codj=x.codj AND y.code=x.eq1;

SELECT code FROM 
((SELECT codj, code FROM jugadores)
    INTERSECT
(SELECT codj, eq1 FROM faltas WHERE num > 0)) GROUP BY (code) HAVING (COUNT(DISTINCT codj) = 5);



--Prof
SELECT codE
FROM equipos E WHERE

	NOT EXISTS (SELECT * FROM jugadores J WHERE (J.codE = E.codE) AND 

    	NOT EXISTS (SELECT * FROM faltas A WHERE (A.eq1 = E.codE) AND (A.codJ = J.codJ)));

--Quasi división

SELECT code FROM equipos WHERE NOT EXISTS(
(SELECT codj FROM jugadores WHERE jugadores.code = equipos.code)
    MINUS
(SELECT DISTINCT codj FROM faltas WHERE faltas.eq1 = equipos.code));


--4) 

CREATE VIEW compuBienMalo (ID, marca, modelo, tipo, costeMedio) AS
(SELECT ID, marca, modelo, tipo, reales FROM ordenador 
    NATURAL JOIN
(SELECT ID, AVG(costo) reales FROM repara GROUP BY ID HAVING((COUNT(*) > 5) OR (SUM(costo)>500))) ORDER BY marca,modelo);


