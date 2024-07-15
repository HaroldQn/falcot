CREATE DATABASE proyecto_falcot;
USE proyecto_falcot;

CREATE TABLE departamentos(
iddepartamento 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
departamento 		VARCHAR(60) 	NOT NULL,
CONSTRAINT uk_departamento_departamentos UNIQUE(departamento)
)ENGINE = INNODB;



CREATE TABLE provincias(
idprovincia 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
provincia 			VARCHAR(60) 	NOT NULL,
iddepartamento 		INT 			NOT NULL,
CONSTRAINT fk_iddepartamento_provincias FOREIGN KEY(iddepartamento) REFERENCES departamentos(iddepartamento)
)ENGINE = INNODB;



CREATE TABLE distritos(
iddistrito 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
distrito 		VARCHAR(60) 	NOT NULL,
idprovincia		INT				NOT NULL,
CONSTRAINT fk_idprovincia_distritos FOREIGN KEY(idprovincia) REFERENCES provincias(idprovincia)
)ENGINE = INNODB;



CREATE TABLE roles(
idrol 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
rol 		VARCHAR(25) 	NOT NULL,
estado 		CHAR(1) 		DEFAULT(1),
CONSTRAINT 	uk_rol_roles UNIQUE(rol)
)ENGINE = INNODB;



CREATE TABLE usuarios(
idusuario 		INT 			PRIMARY KEY AUTO_INCREMENT,
usuario 		VARCHAR(60) 	NOT NULL,
clave 			VARCHAR(100) 	NOT NULL,
nombres 		VARCHAR(40) 	NOT NULL,
apellidos 		VARCHAR(60) 	NOT NULL,
idrol 			INT 			NULL,
estado 			CHAR(1) 		DEFAULT(1),
fechaInicio	 	DATE 			DEFAULT(now()),
fechaFin 		DATE 			NULL,
CONSTRAINT uk_clave_usuarios UNIQUE(usuario),
CONSTRAINT fk_idrol_usuarios FOREIGN KEY(idrol) REFERENCES roles(idrol)
)ENGINE = INNODB;



CREATE TABLE empresa(
idempresa 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
razonSocial 	VARCHAR(70) 	NOT NULL,
ruc 			CHAR(11) 		NOT NULL,
direccion 		VARCHAR(60) 	NULL,
iddistrito 		INT 			NOT NULL,
CONSTRAINT fk_distrito_empresa FOREIGN KEY(iddistrito) REFERENCES distritos(iddistrito)
)ENGINE = INNODB;



CREATE TABLE detalle_usuarios(
iddetalleusuario 	INT 		PRIMARY KEY 	AUTO_INCREMENT,
idusuario 			INT 		NOT NULL,
idempresa			INT 		NOT NULL,
CONSTRAINT fk_idusuario_detalle_usuarios FOREIGN KEY(idusuario) REFERENCES usuarios(idusuario),
CONSTRAINT fk_idempresa_detalle_usuarios FOREIGN KEY(idempresa) REFERENCES empresa(idempresa)
)ENGINE = INNODB;



CREATE TABLE empresas_cliente(
idempresacliente 	INT 			PRIMARY KEY 	AUTO_INCREMENT,
razonSocial 		VARCHAR(70) 	NOT NULL,
nroDocumento 		VARCHAR(12) 	NOT NULL,
direccion 			VARCHAR(60) 	NOT NULL,
iddistrito 			INT 			NOT NULL,
ubigeo 				CHAR(12) 		NULL,
actividadEconomica 	VARCHAR(70) 	NULL,
telefono 			CHAR(12) 		NULL,
estado 				CHAR(1) 		DEFAULT(1),
fechaInicio 		DATE 			DEFAULT(now()),
fechaEdicion 		DATE 			NULL,
fechaFin  			DATE 			NULL,
CONSTRAINT uk_nroDocumento_empresas_cliente UNIQUE(nroDocumento),
CONSTRAINT fk_iddistrito_empresas_cliente FOREIGN KEY(iddistrito) REFERENCES distritos(iddistrito)
)ENGINE = INNODB;



CREATE TABLE orden_compra(
idordencompra 		INT 			PRIMARY KEY 	AUTO_INCREMENT,
iddetalleusuario 	INT 			NOT NULL,
idcliente 			INT 			NOT NULL,
moneda 				VARCHAR(10) 	NOT NULL,
fechaCreacion 		DATE 			DEFAULT(now()),
descuento 			CHAR(6)			NULL,
grupoCompra 		VARCHAR(15) 	NULL,
destino 			VARCHAR(20) 	NULL,
original 			VARCHAR(50) 	NULL,
estado				CHAR(1) 		DEFAULT(1),
CONSTRAINT fk_iddetalleusuario_orden_compra FOREIGN KEY(iddetalleusuario) REFERENCES detalle_usuarios(iddetalleusuario),
CONSTRAINT fk_idcliente_orden_compra FOREIGN KEY(idcliente) REFERENCES empresas_cliente(idempresacliente)
)ENGINE = INNODB; 



CREATE TABLE detalle_orden_compra(
iddetalleordencompra 	INT 			PRIMARY KEY AUTO_INCREMENT,
idordencompra 			INT 			NOT NULL,
item 					CHAR(5) 		NOT NULL,
centro 					INT 			NULL,
descripcion 			VARCHAR(60) 	NOT NULL,
cantidad 				INT 			NOT NULL,
unidad 					CHAR(10) 		NOT NULL,
precioUnitario 			DECIMAL(10,2) 	NOT NULL
)ENGINE = INNODB;





