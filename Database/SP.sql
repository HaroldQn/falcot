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

DELIMITER //
CREATE PROCEDURE listarUsuarios()
BEGIN
    SELECT USU.idusuario, USU.usuario, USU.clave, USU.nombres, USU.apellidos, USU.idrol, ROL.rol
		FROM usuarios USU INNER JOIN roles ROL ON USU.idrol = ROL.idrol
			WHERE estado = '1';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrarUsuario (
    IN _usuario 	VARCHAR(60),
    IN _clave 		VARCHAR(100),
    IN _nombres 	VARCHAR(40),
    IN _apellidos 	VARCHAR(60),
    IN _idrol 		INT
)
BEGIN
    INSERT INTO usuarios (usuario, clave, nombres, apellidos, idrol)
    VALUES (_usuario, _clave, _nombres, _apellidos, _idrol);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE editarUsuario (
    IN _idusuario 	INT,
    IN _usuario 	VARCHAR(60),
    IN _clave 		VARCHAR(100),
    IN _nombres		VARCHAR(40),
    IN _apellidos 	VARCHAR(60),
    IN _idrol 		INT
)
BEGIN
    UPDATE usuarios
    SET 
        usuario 	= _usuario,
        clave 		= _clave,
        nombres 	= _nombres,
        apellidos 	= _apellidos,
        idrol 		= _idrol
    WHERE idusuario = _idusuario;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE eliminarUsuario (
    IN _idusuario 	INT
)
BEGIN
    UPDATE usuarios
    SET 
        estado 		= '0',
        fechaFin 	= NOW()
    WHERE idusuario = _idusuario;
END //
DELIMITER ;

-- ******************** --
--  SP ClIENTE EMPRESA  --
-- ******************** --

DELIMITER //
CREATE PROCEDURE listarEmpresasCliente()
BEGIN
    SELECT 
        EMPCLI.idempresacliente, EMPCLI.razonSocial,
        EMPCLI.nroDocumento, EMPCLI.direccion,
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
CREATE PROCEDURE registrarEmpresaCliente (
    IN _razonSocial 		VARCHAR(70),
    IN _nroDocumento 		VARCHAR(12),
    IN _direccion 			VARCHAR(60),
    IN _iddistrito 			INT,
    IN _ubigeo 				CHAR(12),
    IN _actividadEconomica 	VARCHAR(70),
    IN _telefono 			CHAR(12)
)
BEGIN
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, iddistrito, ubigeo, actividadEconomica, telefono)
    VALUES (p_razonSocial, p_nroDocumento, p_direccion, p_iddistrito, p_ubigeo, p_actividadEconomica, p_telefono);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE editarEmpresaCliente (
    IN _idempresacliente 	INT,
    IN _razonSocial 		VARCHAR(70),
    IN _nroDocumento 		VARCHAR(12),
    IN _direccion 			VARCHAR(60),
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





