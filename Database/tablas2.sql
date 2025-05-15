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


CREATE TABLE cotizaciones_proveedores(
  idcotizacion_prov INT PRIMARY KEY AUTO_INCREMENT,
  idrequerimiento INT,
  precio_total DECIMAL(10,2) NOT NULL,
  ruta_pdf VARCHAR(255) NOT NULL,
  estado CHAR(1) DEFAULT(1),
  fecha DATE DEFAULT(now()),
  CONSTRAINT fk_cotizacion_prov FOREIGN KEY(idrequerimiento) REFERENCES requerimientos(idrequerimiento)
)ENGINE = INNODB;

INSERT INTO cotizaciones_proveedores (idrequerimiento, precio_total, ruta_pdf) VALUES(16, 1000, 'rutita21.pdf');
Select * from cotizaciones_proveedores;

CREATE TABLE det_cotizacion_data(
iddet_cotizacion_data INT PRIMARY KEY AUTO_INCREMENT,
idcotizacion_prov INT,
tipo_doc varchar(20),
ruta VARCHAR(255) NOT NULL,
estado CHAR(1) DEFAULT(1),
CONSTRAINT fk_det_cotizacion_data FOREIGN KEY(idcotizacion_prov) REFERENCES cotizaciones_proveedores(idcotizacion_prov)
)ENGINE = INNODB;

INSERT INTO det_cotizacion_data (idcotizacion_prov, tipo_doc, ruta) VALUES(6, 'pago', 'pago.pdf');
SELECT * FROM det_cotizacion_data