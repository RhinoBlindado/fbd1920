/*EJERCICIOS EXTRA*/

--Parcial2_Practico_2018.pdf

--1)
DROP TABLE Bot;
CREATE TABLE Bot (
    email VARCHAR(32) PRIMARY KEY REFERENCES email(Participante),
    nombreBot VARCHAR(32) UNIQUE NOT NULL,
    cpp LONG,
    h VARCHAR(55)
);

DROP TABLE Partido;
CREATE TABLE Partido (
    fecha DATE,
    grupo CHAR(2),
    jLocal VARCHAR(32) REFERENCES Bot(email),
    jVisit VARCHAR(32) REFERENCES Bot(email),
    GLocal INT CHECK (GLocal IN (0,1)) NOT NULL,
    GVisit INT CHECK (GVisit IN (0,1)) NOT NULL,
    Empate INT CHECK (Empate IN (0,1)) NOT NULL,
    
    PRIMARY KEY (fecha,grupo,jLocal,jVisit),
    
    CHECK (jLocal != jVisit),
    CHECK (GLocal + GVisit + Empate = 1)
);




--Entrega 3/3


SELECT * FROM encuentros WHERE eq1 NOT IN
    (SELECT eq2 FROM encuentros WHERE RES2 > RES1);
    
SELECT * FROM equipos WHERE code NOT IN    
(SELECT DISTINCT * FROM encuentros WHERE RES1 > RES2);




