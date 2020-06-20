CREATE TABLE objetoAstronomico
(   
  codObj INT CONSTRAINT llavePrim PRIMARY KEY,
  fechaDescrObj DATE CONSTRAINT nonulo NOT NULL,
  observatorioObj VARCHAR2(32)
);


ALTER TABLE OBJETOASTRONOMICO ADD CONSTRAINT "Nombre observatorio animal"  UNIQUE (observatorioObj);

INSERT INTO OBJETOASTRONOMICO (codObj,observatorioobj) VALUES (303,'hsseyNow');

DROP TABLE objetoastronomico;


CREATE TABLE Xz
(
    fecha DATE PRIMARY KEY CHECK(TO_CHAR(fecha,'YYYY') != '2012')
);

INSERT INTO xz VALUES (TO_DATE('2010','YYYY'));






CREATE TABLE pruebaX
(
    nombre VARCHAR(32) PRIMARY KEY NOT NULL,
    edad NUMBER(3,0) DEFAULT 0 NOT NULL
);

ALTER TABLE pruebaX ADD(apellido VARCHAR(32) DEFAULT 'n' NOT NULL);

ALTER TABLE pruebaX DROP(apellido);

DESCRIBE pruebaX;

INSERT INTO pruebaX (nombre)
(SELECT nompro FROM proveedor);





CREATE TABLE A (
    codigo CHAR(2)
);

INSERT INTO A VALUES('J1');
INSERT INTO A VALUES('J2');
INSERT INTO A VALUES('J3');
INSERT INTO A VALUES('J4');

CREATE TABLE B (
    codigo CHAR(2)
);

INSERT INTO B VALUES('J2');
INSERT INTO B VALUES('J3');

(SELECT * FROM A)
    MINUS
(SELECT * FROM B);


(SELECT * FROM B)
    MINUS
(SELECT * FROM A);

DELETE FROM A WHERE codigo='J2';
DELETE FROM A WHERE codigo='J3';


ALTER TABLE A ADD (bonus INT DEFAULT 0 CHECK (bonus >= 0));
UPDATE A SET  bonus = 1 WHERE codigo = 'J3';
UPDATE A SET bonus = bonus+1 WHERE codigo='J3';

SELECT * FROM ventas NATURAL JOIN (Select * from pieza);


CREATE TABLE C (

    A varchar2(10),
    B varchar2(10),
    C varchar2(10),
    D varchar2(10),
    E date CHECK (TO_CHAR(E,'YYYY') != '2012'),
    PRIMARY KEY (A,B),
    UNIQUE (B,C,D)
);

INSERT INTO C VALUES('a','b','c','d',TO_DATE('2020','YYYY'));
INSERT INTO C VALUES('a','b','c','d',TO_DATE('2012','YYYY'));

DROP TABLE C;



SELECT DISTINCT codpie, colorin FROM ventas NATURAL JOIN (SELECT codpie, color colorin FROM pieza) WHERE colorin = 'Gris' OR colorin = 'Rojo';


CREATE TABLE pieza2 (
codpie VARCHAR2(3) PRIMARY KEY,
nompie VARCHAR2(10)  NOT NULL,
color VARCHAR2(10),
peso NUMBER(5,2) CHECK (peso>0 and peso<=100),
ciudad VARCHAR2(15));


INSERT INTO pieza2 
(SELECT * FROM pieza);


ALTER TABLE pieza2 ADD (CULO float);

UPDATE pieza2 SET CULO = (SELECT AVG(cantidad) FROM ventas WHERE ventas.codpie = pieza2.codpie)
WHERE codpie IN (SELECT codpie FROM ventas GROUP BY codpie HAVING SUM(cantidad) > 1000);


SELECT eq1,TO_CHAR(fecha,'YYYY'),SUM(res1) FROM encuentros GROUP BY (eq1);

