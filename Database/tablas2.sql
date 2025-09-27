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

CREATE TABLE det_requerimientos(
iddet_requerimiento INT PRIMARY KEY AUTO_INCREMENT,
idrequerimiento INT,
item 		VARCHAR(100) NOT NULL,
cantidad 	INT NOT NULL,
estado 		CHAR(1) DEFAULT(1),
CONSTRAINT fk_det_requerimiento FOREIGN KEY(idrequerimiento) REFERENCES requerimientos(idrequerimiento)
)ENGINE = INNODB;
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

-- --------------------------------
-- TERCERA PARTE
CREATE TABLE tipo_documento(
	idtipodoc INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(15) NOT NULL,
    create_at DATE DEFAULT(now())
)ENGINE = INNODB;

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