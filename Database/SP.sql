-- ************* --
--   SP UBIGEO   --
-- ************* --
DELIMITER //
CREATE PROCEDURE spListarDepartamentos()
BEGIN
    SELECT iddepartamento, departamento
		FROM departamentos;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spListarProvincias(IN _iddepartamento INT)
BEGIN
    SELECT idprovincia, provincia
		FROM provincias WHERE iddepartamento = _iddepartamento  ;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spListarDistritos( IN _idprovincia INT)
BEGIN
    SELECT iddistrito, distrito
		FROM distritos WHERE idprovincia = _idprovincia ;
END //
DELIMITER ;






-- ************* --
--  SP USUARIOS  --
-- ************* --
DELIMITER $$
CREATE PROCEDURE spu_usuario_login( 
IN _usuario VARCHAR(60)
)
BEGIN
	SELECT * from usuarios where usuario = _usuario and fechaFin IS NULL;
END $$

call spu_usuario_login('admin')

DELIMITER $$
CREATE PROCEDURE spu_usuario_listarUsuarios()
BEGIN
    SELECT USU.idusuario, USU.usuario, USU.clave, USU.nombres, USU.apellidos, USU.idrol, ROL.rol
		FROM usuarios USU INNER JOIN roles ROL ON USU.idrol = ROL.idrol
			WHERE usu.estado = '1';
END $$

DELIMITER $$
CREATE PROCEDURE spu_usuario_registrarUsuario (
    IN _usuario 	VARCHAR(60),
    IN _clave 		VARCHAR(100),
    IN _nombres 	VARCHAR(40),
    IN _apellidos 	VARCHAR(60),
    IN _idrol 		INT
)
BEGIN
    INSERT INTO usuarios (usuario, clave, nombres, apellidos, idrol)
    VALUES (_usuario, _clave, _nombres, _apellidos, _idrol);
END $$

call 

DELIMITER $$
CREATE PROCEDURE spu_usuario_editarClave(
    IN _idusuario 	INT,
    IN _clave 		VARCHAR(100)
)
BEGIN
    UPDATE usuarios
    SET 
        clave 		= _clave
    WHERE idusuario = _idusuario;
END $$

call spu_usuario_editarClave(1,'hola')
select * from usuarios;

DELIMITER $$
CREATE PROCEDURE spu_usuario_eliminarUsuario (
    IN _idusuario 	INT
)
BEGIN
    UPDATE usuarios
    SET 
        estado 		= '0',
        fechaFin 	= NOW()
    WHERE idusuario = _idusuario;
END $$


-- ******************** --
--  SP ClIENTE EMPRESA  --
-- ******************** --
DELIMITER //
CREATE PROCEDURE spBuscarClientePorRuc(
IN _ruc VARCHAR(12)
)
BEGIN
	SELECT 
        EMPCLI.idempresacliente, EMPCLI.razonSocial,
        EMPCLI.nroDocumento, EMPCLI.direccion, EMPCLI.correo,
        DIS.distrito, EMPCLI.iddistrito, EMPCLI.ubigeo, EMPCLI.contacto,
        EMPCLI.actividadEconomica, EMPCLI.telefono, EMPCLI.celular
    FROM empresas_cliente EMPCLI 
		INNER JOIN distritos DIS ON EMPCLI.iddistrito = DIS.iddistrito
	WHERE EMPCLI.nroDocumento = _ruc;

END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE spVerificarCliente(IN _ruc VARCHAR(12))
BEGIN
    DECLARE cluentaCliente BOOLEAN;
    
    SELECT COUNT(*) INTO cluentaCliente
    FROM empresas_cliente
    WHERE nroDocumento = _ruc;
    
    IF cluentaCliente > 0 THEN
        SELECT TRUE AS `exists`;
    ELSE
        SELECT FALSE AS `exists`;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spListarEmpresaClientePorID(IN _idempresacliente INT)
BEGIN
    SELECT 
        EMPCLI.idempresacliente, EMPCLI.razonSocial,
        EMPCLI.nroDocumento, EMPCLI.direccion, EMPCLI.correo,
        DIS.distrito, PRO.provincia, DEP.departamento,
        EMPCLI.iddistrito, PRO.idprovincia, PRO.iddepartamento, EMPCLI.ubigeo,
        EMPCLI.actividadEconomica, EMPCLI.telefono
    FROM empresas_cliente EMPCLI 
		INNER JOIN distritos DIS ON EMPCLI.iddistrito = DIS.iddistrito
        INNER JOIN provincias PRO ON DIS.idprovincia = PRO.idprovincia
        INNER JOIN departamentos DEP on PRO.iddepartamento = DEP.iddepartamento
    WHERE
        EMPCLI.idempresacliente = _idempresacliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spListarEmpresasCliente()
BEGIN
    SELECT 
        EMPCLI.idempresacliente, EMPCLI.razonSocial,
        EMPCLI.nroDocumento, EMPCLI.direccion, EMPCLI.correo,
        DIS.distrito, PRO.provincia, DEP.departamento,
        EMPCLI.iddistrito, EMPCLI.ubigeo,
        EMPCLI.actividadEconomica, EMPCLI.telefono
    FROM empresas_cliente EMPCLI 
		INNER JOIN distritos DIS ON EMPCLI.iddistrito = DIS.iddistrito
        INNER JOIN provincias PRO ON DIS.idprovincia = PRO.idprovincia
        INNER JOIN departamentos DEP on PRO.iddepartamento = DEP.iddepartamento
    WHERE
        EMPCLI.estado = '1';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spRegistrarEmpresaClienteAPI (
    IN _razonSocial 		VARCHAR(70),
    IN _nroDocumento 		VARCHAR(12),
    IN _direccion 			VARCHAR(60),
	IN _correo				VARCHAR(60),
    IN _contacto			VARCHAR(40),
    IN _celular				CHAR(10),
    IN _distrito 			VARCHAR(30),
    IN _ubigeo 				CHAR(12),
    IN _telefono 			CHAR(12)
)
BEGIN
	SELECT iddistrito INTO @iddistrito FROM distritos WHERE distrito = _distrito;
    
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, correo, contacto, celular, iddistrito, ubigeo, telefono)
    VALUES (_razonSocial, _nroDocumento, _direccion, _correo, _contacto, _celular, @iddistrito, _ubigeo, _telefono);

	SELECT @@last_insert_id as'idcliente';

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spRegistrarEmpresaCliente (
    IN _razonSocial 		VARCHAR(70),
    IN _nroDocumento 		VARCHAR(12),
    IN _direccion 			VARCHAR(60),
	IN _correo				VARCHAR(60),
    IN _iddistrito 			INT,
    IN _ubigeo 				CHAR(12),
    IN _actividadEconomica 	VARCHAR(70),
    IN _telefono 			CHAR(12)
)
BEGIN
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, correo, iddistrito, ubigeo, actividadEconomica, telefono)
    VALUES (_razonSocial, _nroDocumento, _direccion, _correo, _iddistrito, _ubigeo, _actividadEconomica, _telefono);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spEditarEmpresaCliente (
    IN _idempresacliente 	INT,
    IN _razonSocial 		VARCHAR(70),
    IN _nroDocumento 		VARCHAR(12),
    IN _direccion 			VARCHAR(60),
	IN _correo				VARCHAR(60),
    IN _iddistrito 			INT,
    IN _ubigeo 				CHAR(12),
    IN _actividadEconomica 	VARCHAR(70),
    IN _telefono 			CHAR(12)
)
BEGIN
    UPDATE empresas_cliente
    SET 
        razonSocial  		= _razonSocial,
        nroDocumento 		= _nroDocumento,
        direccion    		= _direccion,
        correo				= _correo,
        iddistrito   		= _iddistrito,
        ubigeo       		= _ubigeo,
        actividadEconomica 	= _actividadEconomica,
        telefono     		= _telefono,
        fechaEdicion 		= NOW()
    WHERE idempresacliente = _idempresacliente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE eliminarEmpresaCliente (
    IN _idempresacliente 	INT
)
BEGIN
    UPDATE empresas_cliente
    SET 
        estado = '0',
        fechaFin = NOW()
    WHERE idempresacliente = _idempresacliente;
END //
DELIMITER ;


-- ******************** --
--  SP Orden Compra  --
-- ******************** --

DELIMITER //
CREATE PROCEDURE spCrearOrdenCompra(
IN 	_iddetalleusuario 	INT,
IN 	_cliente 		 	VARCHAR(12),
IN 	_moneda 		    VARCHAR(10),
IN 	_fechaCreacion    	DATE,
IN 	_descuento		 	CHAR(6),
IN  _grupoCompra		VARCHAR(15),
IN  _destino			VARCHAR(20),
IN  _observaciones 		VARCHAR(60),
IN  _condicionPago      VARCHAR(40)
)
BEGIN
	SELECT idempresacliente INTO @idempresacliente FROM empresas_cliente WHERE nroDocumento = _cliente;
    
	INSERT INTO orden_compra(iddetalleusuario, idcliente, moneda, fechaCreacion, descuento, grupoCompra, destino, observaciones, condicionPago)
		VALUES(_iddetalleusuario, @idempresacliente, _moneda, _fechaCreacion, _descuento, _grupoCompra, _destino, _observaciones, _condicionPago);
        
	SELECT @@last_insert_id as'idordencompra';

END //
DELIMITER ;


-- ************************* --
--  SP Detalle Orden Compra  --
-- ************************* --

DELIMITER //
CREATE PROCEDURE spCrearDetalleOrdenCompra(
IN 	_idordencompra 		INT,
IN 	_item 		 		CHAR(5),
IN 	_centro 			INT,
IN 	_descripcion		VARCHAR(60),
IN 	_cantidad			INT,
IN  _utm				CHAR(10),
IN  _precioUnitario		DECIMAL(10,2)
)
BEGIN
	INSERT INTO detalle_orden_compra(idordencompra, item, centro, descripcion, cantidad, utm, precioUnitario)
		VALUES(_idordencompra, _item, _centro, _descripcion, _cantidad, _utm, _precioUnitario);
END //
DELIMITER ;




