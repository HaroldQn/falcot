-- ************* --
--   SP UBIGEO   --
-- ************* --
DELIMITER $$
CREATE PROCEDURE spListarDepartamentos()
BEGIN
    SELECT iddepartamento, departamento
		FROM departamentos;
END $$

DELIMITER $$
CREATE PROCEDURE spListarProvincias(IN _iddepartamento INT)
BEGIN
    SELECT idprovincia, provincia
		FROM provincias WHERE iddepartamento = _iddepartamento  ;
END $$

DELIMITER $$
CREATE PROCEDURE spListarDistritos( IN _idprovincia INT)
BEGIN
    SELECT iddistrito, distrito
		FROM distritos WHERE idprovincia = _idprovincia ;
END $$






-- ************* --
--  SP USUARIOS  --
-- ************* --
DELIMITER $$
CREATE PROCEDURE spu_usuario_login( 
IN _usuario VARCHAR(60)
)
BEGIN
	SELECT * from usuarios USU
    LEFT join detalle_usuarios DT ON USU.idusuario = DT.idusuario  
    where USU.usuario = _usuario and USU.estado = 1;
END $$

DELIMITER $$
CREATE PROCEDURE spu_usuario_listarUsuarios()
BEGIN
    SELECT USU.idusuario, USU.usuario, USU.clave, USU.nombres, USU.apellidos, USU.idrol, ROL.rol
		FROM usuarios USU INNER JOIN roles ROL ON USU.idrol = ROL.idrol
			WHERE USU.estado = '1';
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
        EMPCLI.actividadEconomica, EMPCLI.telefono, EMPCLI.celular, EMPCLI.contacto
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
        EMPCLI.actividadEconomica, EMPCLI.telefono, EMPCLI.celular, EMPCLI.contacto
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
    IN _telefono			CHAR(12),
    IN _provincia			VARCHAR(30),
	IN _departamento		VARCHAR(30)
)
BEGIN
	
	SELECT DIS.iddistrito INTO @iddistrito FROM distritos DIS
    left JOIN provincias PRO ON DIS.idprovincia = PRO.idprovincia
    left JOIN departamentos DEP ON PRO.iddepartamento = DEP.iddepartamento 
    WHERE DIS.distrito = _distrito AND PRO.provincia = _provincia AND DEP.departamento = _departamento;
    
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
    IN _telefono 			CHAR(12),
    IN _celular				CHAR(10),
    IN _contacto			VARCHAR(40)
)
BEGIN
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, correo, iddistrito, ubigeo, telefono, celular, contacto)
    VALUES (_razonSocial, _nroDocumento, _direccion, _correo, _iddistrito, _ubigeo, _telefono, _celular, _contacto);
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
    IN _telefono 			CHAR(12),
    IN _celular				CHAR(10),
    IN _contacto			VARCHAR(40)
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
        telefono     		= _telefono,
        celular				= _celular,
        contacto			= _contacto,
        fechaEdicion 		= NOW()
    WHERE idempresacliente = _idempresacliente;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE spEditarClienteEnOrdenCompra(
IN _idcliente INT,
IN _celular CHAR(10),
IN _correo  VARCHAR(60),
IN _contacto VARCHAR(40),
IN _telefono CHAR(12)
)
BEGIN
	UPDATE empresas_cliente SET
    celular = _celular ,
    correo  = _correo ,
    contacto = _contacto,
    telefono = _telefono
    WHERE idempresacliente = _idcliente;
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

-- ESTA FUNCION TIENES QUE VOLVERLA A EJECUTAR
DELIMITER $$
CREATE PROCEDURE spu_obetner_orden_compra(
	IN _idordencompra INT
)
BEGIN
    SELECT 
        oc.idordencompra,
        oc.moneda,
        oc.fechaCreacion,
        oc.descuento,
        oc.grupoCompra,
        oc.destino,
        oc.original,
        oc.estado,

        oc.celular,
        oc.telefono,
        oc.contacto,
        oc.correo,

		oc.observaciones,
        u.nombres AS usuario_nombres,
        u.apellidos AS usuario_apellidos,
        ec.razonSocial AS cliente_razonSocial,
        ec.nroDocumento AS cliente_ruc,
        ec.celular AS cliente_celular,
        ec.telefono AS cliente_telefono,
        ec.contacto AS cliente_contacto,
        ec.correo AS cliente_correo,
        ec.direccion AS cliente_direccion
    FROM 
        orden_compra oc
        INNER JOIN detalle_usuarios du ON oc.iddetalleusuario = du.iddetalleusuario
        INNER JOIN usuarios u ON du.idusuario = u.idusuario
        INNER JOIN empresas_cliente ec ON oc.idcliente = ec.idempresacliente
	WHERE idordencompra = _idordencompra;
END $$

-- ---------------------------------------------------------------

DELIMITER $$
CREATE PROCEDURE obtener_detalle_orden_compra (
    IN p_idordencompra INT
)
BEGIN
    SELECT 
        doc.iddetalleordencompra,
        doc.idordencompra,
        doc.item,
        doc.centro,
        doc.descripcion,
        doc.cantidad,
        doc.utm,
        doc.precioUnitario,
        (doc.cantidad * doc.precioUnitario) AS total
    FROM 
        detalle_orden_compra doc
    WHERE 
        doc.idordencompra = p_idordencompra;
END $$

DELIMITER $$
CREATE PROCEDURE spu_calcular_totales(
    IN _idordencompra INT
)
BEGIN
    DECLARE subtotal DECIMAL(10,2);
    DECLARE igv DECIMAL(10,2);
    DECLARE descuento_final DECIMAL(10,2);
    DECLARE total DECIMAL(10,2);

    SELECT SUM(cantidad * precioUnitario)
    INTO subtotal
    FROM detalle_orden_compra
    WHERE idordencompra = _idordencompra;
    SET igv = subtotal * 0.18;
    
    SELECT descuento
    INTO descuento_final
    FROM orden_compra
    WHERE idordencompra = _idordencompra;

    SET total = (subtotal + igv) - descuento_final;
    SELECT subtotal AS Subtotal, igv AS IGV, descuento_final AS Descuento, total AS Total;
END $$



-- ******************** --
--  SP Orden Compra  --
-- ******************** --
DELIMITER //
CREATE PROCEDURE spCambiarEstadoAprobado(IN _idordencompra INT)
BEGIN
	UPDATE orden_compra 
    SET
		estado = 2
	WHERE idordencompra = _idordencompra;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE spCambiarEstadoRechazado(IN _idordencompra INT)
BEGIN
	UPDATE orden_compra 
    SET
		estado = 0
	WHERE idordencompra = _idordencompra;
END //
DELIMITER;


DELIMITER //
CREATE PROCEDURE spListarOrdenCompraPorRol(
    IN _fechaCreacion VARCHAR(10)  
)
BEGIN
    IF _fechaCreacion IS NULL OR _fechaCreacion = '' THEN
        -- List all orders if _fechaCreacion is NULL
        SELECT USU.idrol, ORDCOMP.idordencompra, EMPRCLI.razonSocial, EMPRCLI.nroDocumento, ORDCOMP.fechaCreacion, ORDCOMP.estado 
        FROM orden_compra ORDCOMP
        INNER JOIN empresas_cliente EMPRCLI ON ORDCOMP.idcliente = EMPRCLI.idempresacliente
        INNER JOIN detalle_usuarios DETUSU ON ORDCOMP.iddetalleusuario = DETUSU.iddetalleusuario
        INNER JOIN usuarios USU ON DETUSU.idusuario = USU.idusuario;
    ELSE
        -- Filter orders by _fechaCreacion
        SELECT USU.idrol, ORDCOMP.idordencompra, EMPRCLI.razonSocial,  EMPRCLI.nroDocumento,ORDCOMP.fechaCreacion, ORDCOMP.estado 
        FROM orden_compra ORDCOMP
        INNER JOIN empresas_cliente EMPRCLI ON ORDCOMP.idcliente = EMPRCLI.idempresacliente
        INNER JOIN detalle_usuarios DETUSU ON ORDCOMP.iddetalleusuario = DETUSU.iddetalleusuario
        INNER JOIN usuarios USU ON DETUSU.idusuario = USU.idusuario
        WHERE ORDCOMP.fechaCreacion = _fechaCreacion;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE spCrearOrdenCompra(
IN 	_iddetalleusuario 	INT,
IN 	_cliente 		 	VARCHAR(12),
IN 	_moneda 		    VARCHAR(10),
IN 	_fechaCreacion    	DATE,
IN 	_descuento		 	CHAR(6),
IN  _grupoCompra		VARCHAR(15),
IN  _destino			VARCHAR(60),
IN  _observaciones 		VARCHAR(60),
IN  _condicionPago      VARCHAR(40),
IN  _celular 			CHAR(9),
IN 	_telefono			CHAR(12),
IN  _contacto			VARCHAR(40),
IN  _correo            	VARCHAR(60)
)
BEGIN
	SELECT idempresacliente INTO @idempresacliente FROM empresas_cliente WHERE nroDocumento = _cliente;
    
	INSERT INTO orden_compra(iddetalleusuario, idcliente, moneda, fechaCreacion, descuento, grupoCompra, destino, observaciones, condicionPago, celular, telefono, contacto, correo)
		VALUES(_iddetalleusuario, @idempresacliente, _moneda, _fechaCreacion, _descuento, _grupoCompra, _destino, _observaciones, _condicionPago, _celular, _telefono, _contacto, _correo);
        
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

-- v.2
DELIMITER //
create procedure obtener_detalle_orden_compra(
IN p_idordencompra int
)
BEGIN
 -- CAMBIAR POR 26
 IF p_idordencompra <= 26 THEN
	 SELECT 
			doc.iddetalleordencompra,
			doc.idordencompra, doc.item, doc.centro,
			doc.descripcion, doc.cantidad, doc.utm,
			doc.precioUnitario,
			ROUND(doc.cantidad * doc.precioUnitario, 2) AS total
		FROM 
			detalle_orden_compra doc
		WHERE 
			doc.idordencompra =26
		ORDER BY 
			doc.item ASC;
 ELSE
	 SELECT 
		doc.iddetalleordencompra,
		doc.idordencompra, doc.item, doc.centro,
		doc.descripcion, doc.cantidad, doc.utm,
		ROUND(doc.precioUnitario/1.18, 2) as precioUnitario,
		ROUND(((doc.cantidad * doc.precioUnitario)/1.18), 2) AS total
	FROM 
		detalle_orden_compra doc
	WHERE 
		doc.idordencompra = p_idordencompra
	ORDER BY 
		doc.item ASC;
 END IF;
END //

DELIMITER //
CREATE PROCEDURE spu_calcular_totales(
IN _idordencompra INT
)
BEGIN
	DECLARE subtotal DECIMAL(10,2);
	DECLARE igv DECIMAL(10,2);
	DECLARE descuento_final DECIMAL(10,2);
	DECLARE total DECIMAL(10,2);
	DECLARE suma_total_precios DECIMAL(10,2);
	-- cambiar a 26
	IF _idordencompra <= 26 THEN
		 SELECT SUM(cantidad * precioUnitario) INTO subtotal FROM detalle_orden_compra WHERE idordencompra = _idordencompra;
		SET igv = subtotal * 0.18;
		
		-- DESCUENTO
		SELECT descuento INTO descuento_final FROM orden_compra WHERE idordencompra = _idordencompra;
		
		-- TOTAL
		SET total = (subtotal + igv) - descuento_final;
		
		SELECT subtotal AS Subtotal, igv AS IGV, descuento_final AS Descuento, total AS Total;
    ELSE
		
		-- SUMA DE PRECIO DE LOS PRODUCTOS CON IGV
		SELECT SUM(cantidad * precioUnitario) INTO suma_total_precios FROM detalle_orden_compra WHERE idordencompra = _idordencompra;
		
		-- SUBTOTAL
		SET total = (subtotal + igv) - descuento_final;
		
		-- IGV 
		SET igv =  suma_total_precios - suma_total_precios/1.18;
		
		-- DESCUENTO
		SELECT descuento INTO descuento_final FROM orden_compra WHERE idordencompra = _idordencompra;
		
		-- TOTAL
		SET total = (subtotal + igv) - descuento_final;
		
		SELECT subtotal AS Subtotal, igv AS IGV, descuento_final AS Descuento, total AS Total;
    END IF;
END //

