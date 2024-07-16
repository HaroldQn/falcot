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

call sp

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





