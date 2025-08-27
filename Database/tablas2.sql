-- PARTE DE 2 DE LAS MODIFICACIONES PARA SOLICITUDES
USE u952246627_falcot24;

CREATE TABLE requerimientos(
idrequerimiento INT PRIMARY KEY AUTO_INCREMENT,
idusuario 	INT,
motivo 		VARCHAR(255) NOT NULL, 
fecha 		DATE DEFAULT(now()),
observacion VARCHAR(255) NOT NULL,
estado 		CHAR(1) DEFAULT(1),
CONSTRAINT fk_usuario FOREIGN KEY(idusuario) REFERENCES detalle_usuarios(iddetalleusuario)
)ENGINE = INNODB;
INSERT INTO requerimientos (idusuario, motivo, fecha, observacion) VALUES (8, 'Faltante', '2025-02-28', 'Urgencia la polvora');
SELECT * FROM requerimientos;

CREATE TABLE det_requerimientos(
iddet_requerimiento INT PRIMARY KEY AUTO_INCREMENT,
idrequerimiento INT,
item 		VARCHAR(100) NOT NULL,
cantidad 	INT NOT NULL,
estado 		CHAR(1) DEFAULT(1),
CONSTRAINT fk_det_requerimiento FOREIGN KEY(idrequerimiento) REFERENCES requerimientos(idrequerimiento)
)ENGINE = INNODB;

INSERT INTO det_requerimientos (idrequerimiento, item, cantidad) VALUES(1, 'POLVORA BLUE 1/3', 10);
SELECT * FROM det_requerimientos;

-- ------------------------------------------
CREATE TABLE cotizaciones_proveedores(
  idcotizacion_prov INT PRIMARY KEY AUTO_INCREMENT,
  idrequerimiento INT,
  empresa varchar(60),
  moneda varchar(20),
  archivo varchar(150),
  estado char(1) default 1,
  CONSTRAINT fk_cotizacion_prov FOREIGN KEY(idrequerimiento) REFERENCES requerimientos(idrequerimiento)
)ENGINE = INNODB;
ALTER TABLE cotizaciones_proveedores ADD COLUMN archivo varchar(150) AFTER moneda;


INSERT INTO cotizaciones_proveedores (idrequerimiento, empresa, moneda) VALUES(17, 'INDUSTRIAS SAC', 'SOLES');
Select * from cotizaciones_proveedores;

CREATE TABLE det_cotizacion_data(
iddet_cotizacion_data INT PRIMARY KEY AUTO_INCREMENT,
idcotizacion_prov INT,
iddet_requerimiento INT,
marca varchar(30),
precio_unitario float(7,2) NOT NULL,
estado CHAR(1) DEFAULT 1,
CONSTRAINT fk_iddet_requerimiento FOREIGN KEY(iddet_requerimiento) REFERENCES det_requerimientos(iddet_requerimiento),
CONSTRAINT fk_idcotizacion_proc FOREIGN KEY(idcotizacion_prov) REFERENCES cotizaciones_proveedores(idcotizacion_prov)
)ENGINE = INNODB;

INSERT INTO det_cotizacion_data (idcotizacion_prov,iddet_requerimiento, marca, precio_unitario) VALUES(1,26, 'ZTK', 100.50);
SELECT * FROM det_cotizacion_data;

-- --------------------------------
-- TERCERA PARTE
CREATE TABLE tipo_documento(
	idtipodoc INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(15) NOT NULL,
    create_at DATE DEFAULT(now())
)ENGINE = INNODB;
INSERT INTO tipo_documento(tipo)values('OR'),('FACT'),('GUIA'),('PAGO');
SELECT * FROM tipo_documento;

CREATE TABLE documentos_requerimiento(
	iddocumento INT PRIMARY KEY AUTO_INCREMENT,
    idrequerimiento INT,
    idtipodoc INT,
    nombre varchar(100) NOT NULL,
    fecha DATE DEFAULT(now()),
    estado char(1) default 1,
    CONSTRAINT fk_idrequerimiento FOREIGN KEY (idrequerimiento) references requerimientos(idrequerimiento),
    CONSTRAINT fk_idtipodoc FOREIGN KEY (idtipodoc) references tipo_documento (idtipodoc)
)ENGINE = INNODB;
INSERT INTO documentos_requerimiento(idrequerimiento, idtipodoc, nombre)VALUES(17,1, 'ORDEN_COMPRA1990');


SELECT * FROM documentos_requerimiento where idrequerimiento = 15;
SELECT * FROM requerimientos where idrequerimiento = 15