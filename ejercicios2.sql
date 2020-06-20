--**EJERCICIOS**

COMMIT;

--2.1
SELECT * FROM prueba2;
SELECT * FROM plantilla;

SELECT dni FROM plantilla;

--2.2
UPDATE plantilla
    SET nombre = 'Luis'
    WHERE dni = '12345678';

--2.3
DELETE FROM plantilla;
    --No permite porque serJefe tiene claves externas de plantilla.
DELETE FROM serjefe;
DELETE FROM plantilla;
    --Cuando se borran las CE, se puede borrar plantilla.


--2.7
INSERT INTO equipos VALUES (1,'Coviran Granada','Granada','John Titor',SYSDATE-(365*4));
INSERT INTO equipos VALUES (2,'TrotaMundos','Valencia','Lara Croft',TO_DATE('01/04/95','dd/mm/yy'));
--Tentativo terminarlo luego...


--**EJEMPLOS**
--2.1
INSERT INTO prueba2 VALUES('aa',1);
INSERT INTO prueba2 VALUES('Aa',2);
INSERT INTO prueba2 VALUES('aa',1);

--2.2
INSERT INTO plantilla(dni, nombre, estadocivil, fechaalta)
    VALUES('12345678','Pepe','soltero', SYSDATE);
INSERT INTO plantilla(dni, nombre, estadocivil, fechaalta)
    VALUES('87654321','Juan','casado', SYSDATE);
INSERT INTO serjefe VALUES ('87654321','12345678');
INSERT INTO plantilla (dni, estadocivil) VALUES ('11223344','soltero');

--2.3
UPDATE plantilla
    SET estadocivil = 'divorciado'
    WHERE nombre = 'Juan';
    
--2.4
DELETE FROM prueba2;

--2.5
UPDATE plantilla
    SET fechaalta = fechaalta+1
    WHERE nombre = 'Juan';
    
INSERT INTO plantilla
    VALUES ('11223355','Miguel','casado',TO_DATE('22/10/05','dd/mm/yy'),null);
    
--2.6
SELECT TO_CHAR(fechaalta,'dd-mon-yyyy') FROM plantilla;
SELECT TO_CHAR(fechaalta,'day hh:mm:ss') FROM plantilla;
--2.7
SELECT fechaalta FROM plantilla;


SELECT * from ventas where codpro ='S3';