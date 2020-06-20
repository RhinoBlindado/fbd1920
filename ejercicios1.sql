/*  Asignatura: Bases de Datos
    Ejercicios del Cuaderno de Practicas
    Capitulo 1
*/

COMMIT; 

--*** EJERCICIOS ***-- 
--1.1
CREATE TABLE prueba2
(
    cad1 char(8),
    num int
);

--1.2
DESCRIBE prueba2;


--1.6
ALTER TABLE plantilla ADD fechabaja date;

--1.7
DESCRIBE ventas;

--1.8
CREATE TABLE equipos
(
    codE INT CONSTRAINT clavePrimaria PRIMARY KEY,
    nombreE varchar2(32) CONSTRAINT nombreEquipoUnico UNIQUE,
    localidad varchar2(32) CONSTRAINT localidadNoNula NOT NULL,
    entrenador varchar2(32) CONSTRAINT entrenadorNoNulo NOT NULL,
    fecha_crea date CONSTRAINT fechaNoNula NOT NULL
);

CREATE TABLE jugadores
(
    codJ INT CONSTRAINT codJ_clave_primaria PRIMARY KEY,
    codE CONSTRAINT codE_clave_externa REFERENCES equipos(codE) NOT NULL,
    nombreJ VARCHAR2(32) CONSTRAINT nombre_jugador_no_nulo NOT NULL
);

CREATE TABLE encuentros
(
    ELocal CONSTRAINT ELocal_clave_externa REFERENCES equipos(codE),
    EVisitante CONSTRAINT EVisitante_clave_externa REFERENCES equipos(codE),
    fecha DATE,
    Plocal INT DEFAULT 0 CONSTRAINT puntuacion_local_mayor_0 CHECK(pLocal >= 0),
    Pvisitante INT DEFAULT 0 CONSTRAINT puntuacion_visitante_mayor_0 CHECK (pVisitante >= 0),
    CONSTRAINT encuentros_clavePrimaria PRIMARY KEY(Elocal,Evisitante)
);

CREATE TABLE faltas
(
    codJ CONSTRAINT claveExternaJug REFERENCES jugadores(codJ),
    Elocal CONSTRAINT claveExternalocal REFERENCES equipos(codE),
    Evisitante CONSTRAINT claveExternavisi REFERENCES equipos(codE),
    numero INT DEFAULT 0 CONSTRAINT numeroentre0y5 CHECK(numero>=0 AND numero<=5),
    CONSTRAINT faltaclaveprimaria PRIMARY KEY (codJ,Elocal,Evisitante)
);

--*** EJEMPLOS ***--  
--1.1
CREATE TABLE plantilla(
    dni varchar2(9),
    nombre varchar2(15),
    estadocivil varchar2(10)
    --CHECK para restringir 'EstadoCivil' a esos valores solamente.
    CHECK (estadocivil IN ('soltero', 'casado', 'divorciado', 'viudo')),
    fechaalta date,
PRIMARY KEY (dni));