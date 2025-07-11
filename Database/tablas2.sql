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
  estado char(1) default 1,
  CONSTRAINT fk_cotizacion_prov FOREIGN KEY(idrequerimiento) REFERENCES requerimientos(idrequerimiento)
)ENGINE = INNODB;

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