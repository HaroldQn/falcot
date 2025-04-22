-- PARTE DE 2 DE LAS MODIFICACIONES PARA SOLICITUDES
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
