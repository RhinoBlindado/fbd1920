-- CUESTIONARIO 1 

-- PRIMERA PREGUNTA
-- ELIMINACION
DROP TABLE expone;
DROP TABLE sesion_ocupa;
DROP TABLE sala;
DROP TABLE escribe;
DROP TABLE congreso;
DROP TABLE articulo;
DROP TABLE autor;

-- CREACION
CREATE TABLE congreso
(
    nombre VARCHAR2(32),
    anno INT,
    ciudad VARCHAR2(32),
    pais VARCHAR2(32),
    centro VARCHAR2(32),
    
    CONSTRAINT congreso_claveprimaria PRIMARY KEY(nombre,anno)
);


CREATE TABLE sala
(
    codS CHAR(8),
    nombre VARCHAR2(32),
    capacidad INT,
    
    CONSTRAINT sala_claveprimaria PRIMARY KEY(codS)
);

CREATE TABLE articulo
(
    codAr CHAR(8),
    titulo VARCHAR2(32),
    tema VARCHAR2(32),
    n_pag INT,
    
    CONSTRAINT articulo_claveprimaria PRIMARY KEY(codAr)
);

CREATE TABLE autor
(
    codAu CHAR(8),
    nombre VARCHAR2(32),
    email VARCHAR2(32),
    universidad VARCHAR(32),
    
    CONSTRAINT autor_claveprimaria PRIMARY KEY (codAu),
    CONSTRAINT autor_emailunico UNIQUE(email)
);

CREATE TABLE escribe
(
    codAr,
    codAu,
    
    CONSTRAINT escribe_claveextAr FOREIGN KEY(codAr) REFERENCES articulo(codAr),
    CONSTRAINT escribe_claveextAu FOREIGN KEY(codAu) REFERENCES autor(codAu),
    
    CONSTRAINT escribe_claveprimaria PRIMARY KEY(codAr,codAu)
);

CREATE TABLE sesion_ocupa
(
    nombre,
    anno,
    nro_sesion INT,
    tema VARCHAR2(32),
    fecha_hora DATE,
    codS NOT NULL,
    
    CONSTRAINT sesion_ocupa_FK1 FOREIGN KEY(nombre, anno) REFERENCES congreso(nombre, anno),
    CONSTRAINT sesion_ocupa_FK2 FOREIGN KEY(codS) REFERENCES sala(codS),
    CONSTRAINT sesion_ocupa_PK PRIMARY KEY(nombre, anno, nro_sesion)
);

CREATE TABLE expone
(
    nombre,
    anno,
    nro_sesion,
    codAr,
    codAu,
    
    CONSTRAINT expone_FK_sesion FOREIGN KEY(nombre, anno, nro_sesion) REFERENCES sesion_ocupa(nombre, anno, nro_sesion),
    CONSTRAINT expone_FK_sala FOREIGN KEY(codAr, codAu) REFERENCES escribe(codAr, codAu),
    CONSTRAINT expone_PK PRIMARY KEY(codAr, codAu)
);




--SEGUNDA PREGUNTA


-- Eliminacion
DROP TABLE encuentra;
DROP TABLE excava;
DROP TABLE dirige;
DROP TABLE pertenece;
DROP TABLE parcela;
DROP TABLE senior;
DROP TABLE pieza_arqu;
DROP TABLE zona;
DROP TABLE equipo;
DROP TABLE arqueologos;

-- Creacion
CREATE TABLE arqueologos
(
    numCol INT,
    /*Los pasaportes pueden tener letras*/
    pasaporte VARCHAR2(16) ,
    nacionalidad VARCHAR2(32),
    categoria VARCHAR2(16),
    
    CONSTRAINT arqueologo_PK PRIMARY KEY(numCol),
    CONSTRAINT arqueologo_UQ UNIQUE(pasaporte)
);

CREATE TABLE equipo
(
    codUnico CHAR(8),
    nombre VARCHAR2(32),
    numMiembros INT,
    
    CONSTRAINT equipo_PK PRIMARY KEY(codUnico)
);

CREATE TABLE zona
(
    codZ CHAR(8) CONSTRAINT zona_PK PRIMARY KEY,
    denominacion VARCHAR2(16),
    provincia VARCHAR2(16),
    pais VARCHAR2(16)
);

CREATE TABLE pieza_arqu
(
    codPieza CHAR(8) CONSTRAINT pieza_PK PRIMARY KEY,
    descripcion VARCHAR2(64),
    antiguedad INT
);

CREATE TABLE senior
(
    numCol CONSTRAINT senior_FK REFERENCES arqueologos(numCol) CONSTRAINT senior_PK PRIMARY KEY,
    uni_proveniencia VARCHAR2(32),
    anno_inicio DATE
    /*, anno_experiencia INT --> lo escribo pero como es calculado debería hacerse en la vista, no aquí*/
);

CREATE TABLE parcela
(
    codZ CONSTRAINT parcela_FK REFERENCES zona(codZ),
    numSecuencia INT,
    anchura FLOAT,
    longitud FLOAT,
    tipoTerreno VARCHAR2(32),
    
    CONSTRAINT parcela_PK PRIMARY KEY(codZ,numSecuencia)
);

CREATE TABLE pertenece
(
    numCol CONSTRAINT pertenece_FK_arq REFERENCES arqueologos(numCol) CONSTRAINT pertenece_PK PRIMARY KEY,
    codUnico CONSTRAINT pertenece_FK_equ REFERENCES equipo(codUnico) NOT NULL
);

CREATE TABLE dirige
(
    numCol CONSTRAINT dirige_FK_sen REFERENCES senior(numCol) CONSTRAINT dirige_FK PRIMARY KEY,
    codUnico CONSTRAINT dirige_FK_equ REFERENCES equipo(codUnico) CONSTRAINT dirige_UQ UNIQUE NOT NULL 
);

CREATE TABLE excava
(
    codUnico CONSTRAINT excava_FK_equ REFERENCES equipo(codUnico),
    codZ,
    numSecuencia,
    fecha DATE,
    numeroPiezas INT,
    
    CONSTRAINT excava_FK_par FOREIGN KEY(codZ,numSecuencia) REFERENCES parcela(codZ,numSecuencia),
    CONSTRAINT excava_PK PRIMARY KEY(codZ, numSecuencia, fecha)
);

CREATE TABLE encuentra
(
    codPieza CONSTRAINT encuentra_FK_pie REFERENCES pieza_arqu(codPieza) CONSTRAINT encuentra_PK PRIMARY KEY,
    codZ NOT NULL,
    numSecuencia NOT NULL,
    fecha NOT NULL,
    
    CONSTRAINT encuentra_FK_exc FOREIGN KEY(codZ, numSecuencia, fecha) REFERENCES excava(codZ, numSecuencia, fecha)
);


--TERCERA PREGUNTA
DROP TABLE llega;
DROP TABLE registra;
DROP TABLE autobus_tiene;
DROP TABLE parada;
DROP TABLE incidencia;
DROP TABLE modelo;
DROP TABLE linea;

CREATE TABLE linea
(
    nombreLinea VARCHAR2(32) CONSTRAINT linea_PK PRIMARY KEY
);

CREATE TABLE modelo
(
    nombreModelo VARCHAR2(32) CONSTRAINT modelo_PK PRIMARY KEY,
    capacidadModelo INT,
    consumoModelo FLOAT
);

CREATE TABLE incidencia
(
    refInci INT CONSTRAINT incidencia_PK PRIMARY KEY,
    descrInci VARCHAR2(32),
    costoInci FLOAT CONSTRAINT incidencia_costo CHECK(costoInci>=0),
    tipoInci VARCHAR2(32)
);

CREATE TABLE parada
(
    nombreLinea CONSTRAINT parada_FK REFERENCES linea(nombreLinea),
    ordenParada INT,
    direcParada VARCHAR2(32),
    nombreParada VARCHAR2(32),
    tiempoParada FLOAT CONSTRAINT parada_tiempoErr CHECK(tiempoParada>=0),
    
    CONSTRAINT parada_PK PRIMARY KEY(nombreLinea, ordenParada)
);

CREATE TABLE autobus_tiene
(
    numMat CHAR(8) CONSTRAINT autobus_tiene_PK PRIMARY KEY,
    nombreModelo CONSTRAINT autobus_tiene_FK REFERENCES modelo(nombreModelo) NOT NULL
);

CREATE TABLE registra
(
    numMat CONSTRAINT registra_FK_bus REFERENCES autobus_tiene(numMat),
    refInci CONSTRAINT registra_FK_inc REFERENCES incidencia(refInci),
    fechaIncidencia DATE,
    
    CONSTRAINT registra_PK PRIMARY KEY(numMat, refInci, fechaIncidencia)
);

CREATE TABLE llega
(
    numMat  CONSTRAINT llega_FK_bus REFERENCES autobus_tiene(numMat),
    cuando DATE,
    nombreLinea,
    ordenParada,
    nomUsuario VARCHAR2(32),
    
    CONSTRAINT llega_FK_par FOREIGN KEY(nombreLinea,ordenParada) REFERENCES parada(nombreLinea, ordenParada),
    CONSTRAINT llega_PK PRIMARY KEY (numMat,cuando)
);