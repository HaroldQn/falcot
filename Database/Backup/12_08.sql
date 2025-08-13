-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-08-2025 a las 05:09:07
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u952246627_falcot24`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_detalle_cotizacion` (IN `_idcotizacion_prov` INT, IN `_iddet_requerimiento` INT, IN `_marca` VARCHAR(30), IN `_precio_unitario` FLOAT(7,2))   BEGIN
    INSERT INTO det_cotizacion_data (
        idcotizacion_prov, iddet_requerimiento, marca, precio_unitario
    )
    VALUES (
        _idcotizacion_prov, _iddet_requerimiento, _marca, _precio_unitario
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_cotizacion_proveedor` (IN `_idrequerimiento` INT, IN `_empresa` VARCHAR(60), IN `_moneda` VARCHAR(20))   BEGIN
    INSERT INTO cotizaciones_proveedores (idrequerimiento, empresa, moneda)
    VALUES (_idrequerimiento, _empresa, _moneda);
    
    -- Retorna el ID de la cotización recién creada
    SELECT LAST_INSERT_ID() AS idcotizacion_prov_creada;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarEmpresaCliente` (IN `_idempresacliente` INT)   BEGIN
    UPDATE empresas_cliente
    SET 
        estado = '0',
        fechaFin = NOW()
    WHERE idempresacliente = _idempresacliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cotizaciones_json` (IN `p_idrequerimiento` INT)   BEGIN
  -- Asegurarnos de soportar un JSON grande
  SET SESSION group_concat_max_len = 1000000;

  SELECT CONCAT(
           '[',
           GROUP_CONCAT(
             CONCAT(
               '{"nombre":"', sub.empresa, '",',
               '"moneda":"', sub.moneda, '",',
               '"idcotizacion_prov":"', sub.idcotizacion_prov, '",',
               '"cotizaciones":[', sub.detail_list, ']}'
             )
             ORDER BY sub.empresa
             SEPARATOR ','
           ),
           ']'
         ) AS resultado_json
  FROM (
    SELECT 
      cp.idcotizacion_prov,
      cp.empresa,
      cp.moneda,
      IFNULL(
        (
          SELECT GROUP_CONCAT(
                   CONCAT(
                     '{"marca":"', dcd.marca, '",',
                     '"precioU":', dcd.precio_unitario, ',',
                     '"total":', ROUND(dcd.precio_unitario * dr.cantidad, 2), 
                     '}'
                   )
                   ORDER BY dcd.iddet_cotizacion_data
                   SEPARATOR ','
                 )
          FROM det_cotizacion_data AS dcd
          JOIN det_requerimientos    AS dr 
            ON dcd.iddet_requerimiento = dr.iddet_requerimiento
          WHERE dcd.idcotizacion_prov = cp.idcotizacion_prov
        ),
        ''
      ) AS detail_list
    FROM cotizaciones_proveedores AS cp
    WHERE cp.idrequerimiento = p_idrequerimiento
    AND estado = 1
  ) AS sub;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_detalle_orden_compra` (IN `p_idordencompra` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spBuscarClientePorRuc` (IN `_ruc` VARCHAR(12))   BEGIN
	SELECT 
        EMPCLI.idempresacliente, EMPCLI.razonSocial,
        EMPCLI.nroDocumento, EMPCLI.direccion, EMPCLI.correo,
        DIS.distrito, EMPCLI.iddistrito, EMPCLI.ubigeo, EMPCLI.contacto,
        EMPCLI.actividadEconomica, EMPCLI.telefono, EMPCLI.celular
    FROM empresas_cliente EMPCLI 
		INNER JOIN distritos DIS ON EMPCLI.iddistrito = DIS.iddistrito
	WHERE EMPCLI.nroDocumento = _ruc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCambiarEstadoAprobado` (IN `_idordencompra` INT)   BEGIN
	UPDATE orden_compra 
    SET
		estado = 2
	WHERE idordencompra = _idordencompra;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCambiarEstadoRechazado` (IN `_idordencompra` INT)   BEGIN
	UPDATE orden_compra 
    SET
		estado = 0
	WHERE idordencompra = _idordencompra;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCrearDetalleOrdenCompra` (IN `_idordencompra` INT, IN `_item` CHAR(5), IN `_centro` INT, IN `_descripcion` VARCHAR(60), IN `_cantidad` DECIMAL(10,2), IN `_utm` CHAR(10), IN `_precioUnitario` DECIMAL(10,4))   BEGIN
	INSERT INTO detalle_orden_compra(idordencompra, item, centro, descripcion, cantidad, utm, precioUnitario)
		VALUES(_idordencompra, _item, _centro, _descripcion, _cantidad, _utm, _precioUnitario);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spCrearOrdenCompra` (IN `_iddetalleusuario` INT, IN `_cliente` VARCHAR(12), IN `_moneda` VARCHAR(10), IN `_fechaCreacion` DATE, IN `_descuento` CHAR(6), IN `_grupoCompra` VARCHAR(15), IN `_destino` VARCHAR(60), IN `_observaciones` VARCHAR(60), IN `_condicionPago` VARCHAR(40), IN `_celular` CHAR(9), IN `_telefono` CHAR(12), IN `_contacto` VARCHAR(40), IN `_correo` VARCHAR(60))   BEGIN
	SELECT idempresacliente INTO @idempresacliente FROM empresas_cliente WHERE nroDocumento = _cliente;
    
	INSERT INTO orden_compra(iddetalleusuario, idcliente, moneda, fechaCreacion, descuento, grupoCompra, destino, observaciones, condicionPago, celular, telefono, contacto, correo)
		VALUES(_iddetalleusuario, @idempresacliente, _moneda, _fechaCreacion, _descuento, _grupoCompra, _destino, _observaciones, _condicionPago, _celular, _telefono, _contacto, _correo);
        
	SELECT @@last_insert_id as'idordencompra';

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spEditarClienteEnOrdenCompra` (IN `_idcliente` INT, IN `_celular` CHAR(10), IN `_correo` VARCHAR(60), IN `_contacto` VARCHAR(40), IN `_telefono` CHAR(12))   BEGIN
	UPDATE empresas_cliente SET
    celular = _celular ,
    correo  = _correo ,
    contacto = _contacto,
    telefono = _telefono
    WHERE idempresacliente = _idcliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spEditarEmpresaCliente` (IN `_idempresacliente` INT, IN `_razonSocial` VARCHAR(70), IN `_nroDocumento` VARCHAR(12), IN `_direccion` VARCHAR(60), IN `_correo` VARCHAR(60), IN `_iddistrito` INT, IN `_ubigeo` CHAR(12), IN `_telefono` CHAR(12), IN `_celular` CHAR(10), IN `_contacto` VARCHAR(40))   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarDepartamentos` ()   BEGIN
    SELECT iddepartamento, departamento
		FROM departamentos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarDistritos` (IN `_idprovincia` INT)   BEGIN
    SELECT iddistrito, distrito
		FROM distritos WHERE idprovincia = _idprovincia ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarEmpresaClientePorID` (IN `_idempresacliente` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarEmpresasCliente` ()   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarOrdenCompraPorRol` (IN `_fechaCreacion` VARCHAR(10))   BEGIN
    IF _fechaCreacion IS NULL OR _fechaCreacion = '' THEN
        -- List all orders if _fechaCreacion is NULL
        SELECT USU.idrol, ORDCOMP.idordencompra, EMPRCLI.razonSocial, EMPRCLI.nroDocumento, ORDCOMP.fechaCreacion, ORDCOMP.estado 
        FROM orden_compra ORDCOMP
        INNER JOIN empresas_cliente EMPRCLI ON ORDCOMP.idcliente = EMPRCLI.idempresacliente
        INNER JOIN detalle_usuarios DETUSU ON ORDCOMP.iddetalleusuario = DETUSU.iddetalleusuario
        INNER JOIN usuarios USU ON DETUSU.idusuario = USU.idusuario	
		ORDER BY ORDCOMP.fechaCreacion DESC;
		
        ELSE
    -- Filter orders by _fechaCreacion
        SELECT USU.idrol, ORDCOMP.idordencompra, EMPRCLI.razonSocial,  EMPRCLI.nroDocumento,ORDCOMP.fechaCreacion, ORDCOMP.estado 
        FROM orden_compra ORDCOMP
        INNER JOIN empresas_cliente EMPRCLI ON ORDCOMP.idcliente = EMPRCLI.idempresacliente
        INNER JOIN detalle_usuarios DETUSU ON ORDCOMP.iddetalleusuario = DETUSU.iddetalleusuario
        INNER JOIN usuarios USU ON DETUSU.idusuario = USU.idusuario
        WHERE ORDCOMP.fechaCreacion = _fechaCreacion
        ORDER BY ORDCOMP.fechaCreacion DESC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spListarProvincias` (IN `_iddepartamento` INT)   BEGIN
    SELECT idprovincia, provincia
		FROM provincias WHERE iddepartamento = _iddepartamento  ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spRegistrarEmpresaCliente` (IN `_razonSocial` VARCHAR(70), IN `_nroDocumento` VARCHAR(12), IN `_direccion` VARCHAR(60), IN `_correo` VARCHAR(60), IN `_iddistrito` INT, IN `_ubigeo` CHAR(12), IN `_telefono` CHAR(12), IN `_celular` CHAR(10), IN `_contacto` VARCHAR(40))   BEGIN
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, correo, iddistrito, ubigeo, telefono, celular, contacto)
    VALUES (_razonSocial, _nroDocumento, _direccion, _correo, _iddistrito, _ubigeo, _telefono, _celular, _contacto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spRegistrarEmpresaClienteAPI` (IN `_razonSocial` VARCHAR(70), IN `_nroDocumento` VARCHAR(12), IN `_direccion` VARCHAR(60), IN `_correo` VARCHAR(60), IN `_contacto` VARCHAR(40), IN `_celular` CHAR(10), IN `_distrito` VARCHAR(30), IN `_ubigeo` CHAR(12), IN `_telefono` CHAR(12), IN `_provincia` VARCHAR(30), IN `_departamento` VARCHAR(30))   BEGIN
	
	SELECT DIS.iddistrito INTO @iddistrito FROM distritos DIS
    left JOIN provincias PRO ON DIS.idprovincia = PRO.idprovincia
    left JOIN departamentos DEP ON PRO.iddepartamento = DEP.iddepartamento 
    WHERE DIS.distrito = _distrito AND PRO.provincia = _provincia AND DEP.departamento = _departamento;
    
    INSERT INTO empresas_cliente (razonSocial, nroDocumento, direccion, correo, contacto, celular, iddistrito, ubigeo, telefono)
    VALUES (_razonSocial, _nroDocumento, _direccion, _correo, _contacto, _celular, @iddistrito, _ubigeo, _telefono);

	SELECT @@last_insert_id as'idcliente';

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_actualizar_estado_requerimiento` (IN `_idrequerimiento` INT, IN `_estado` CHAR(1))   BEGIN
	UPDATE requerimientos SET estado = _estado WHERE idrequerimiento = _idrequerimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_agregar_documento_requerimiento` (IN `_idrequerimiento` INT, IN `_idtipodoc` INT, IN `_nombre` VARCHAR(100))   BEGIN
	INSERT INTO documentos_requerimiento(idrequerimiento, idtipodoc, nombre)VALUES(_idrequerimiento, _idtipodoc, _nombre);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_calcular_totales` (IN `_idordencompra` INT)   BEGIN
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
		SET subtotal = suma_total_precios/1.18;
		
		-- IGV 
		SET igv =  suma_total_precios - suma_total_precios/1.18;
		
		-- DESCUENTO
		SELECT descuento INTO descuento_final FROM orden_compra WHERE idordencompra = _idordencompra;
		
		-- TOTAL
		SET total = (subtotal + igv) - descuento_final;
		
		SELECT subtotal AS Subtotal, igv AS IGV, descuento_final AS Descuento, total AS Total;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_cerrar_requerimiento` (IN `_idrequerimiento` INT)   BEGIN
	UPDATE requerimientos SET estado = 3 WHERE idrequerimiento = _idrequerimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_eliminar_cotizacion_prov` (IN `idcotizacion_prov_` INT)   BEGIN
	UPDATE cotizaciones_proveedores SET estado = 0 WHERE idcotizacion_prov = idcotizacion_prov_;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_eliminar_documento` (IN `_iddocumento` INT)   BEGIN
	UPDATE documentos_requerimiento SET estado = 0 WHERE iddocumento = _iddocumento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_lista_doc_requerimiento` (IN `_idrequerimiento` INT)   BEGIN
    SELECT * FROM documentos_requerimiento WHERE idrequerimiento = _idrequerimiento AND estado = 1 ORDER BY idtipodoc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_obetner_orden_compra` (IN `_idordencompra` INT)   BEGIN
    SELECT 
        oc.idordencompra,
        oc.moneda,
        oc.fechaCreacion,
        oc.descuento,
        oc.grupoCompra,
        oc.destino,
        oc.original,
        oc.estado,
        oc.condicionPago,

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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_detalle_requerimiento` (IN `_idrequerimiento` INT, IN `_item` VARCHAR(100), IN `_cantidad` INT)   BEGIN
    INSERT INTO det_requerimientos (idrequerimiento, item, cantidad)
    VALUES (_idrequerimiento, _item, _cantidad);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_requerimiento` (IN `_idusuario` INT, IN `_motivo` VARCHAR(255), IN `_observacion` VARCHAR(255))   BEGIN
    INSERT INTO requerimientos (idusuario, motivo, observacion)
    VALUES (_idusuario, _motivo, _observacion);

    SELECT @@last_insert_id as'idrequerimiento';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuario_editarClave` (IN `_idusuario` INT, IN `_clave` VARCHAR(100))   BEGIN
    UPDATE usuarios
    SET 
        clave 		= _clave
    WHERE idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuario_eliminarUsuario` (IN `_idusuario` INT)   BEGIN
    UPDATE usuarios
    SET 
        estado 		= '0',
        fechaFin 	= NOW()
    WHERE idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuario_listarUsuarios` ()   BEGIN
    SELECT USU.idusuario, USU.usuario, USU.clave, USU.nombres, USU.apellidos, USU.idrol, ROL.rol
		FROM usuarios USU INNER JOIN roles ROL ON USU.idrol = ROL.idrol
			WHERE USU.estado = '1';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuario_login` (IN `_usuario` VARCHAR(60))   BEGIN
	SELECT * from usuarios USU
    LEFT join detalle_usuarios DT ON USU.idusuario = DT.idusuario  
    where USU.usuario = _usuario and USU.estado = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_usuario_registrarUsuario` (IN `_usuario` VARCHAR(60), IN `_clave` VARCHAR(100), IN `_nombres` VARCHAR(40), IN `_apellidos` VARCHAR(60), IN `_idrol` INT)   BEGIN
    INSERT INTO usuarios (usuario, clave, nombres, apellidos, idrol)
    VALUES (_usuario, _clave, _nombres, _apellidos, _idrol);
    
	SELECT @@last_insert_id INTO @nuevousuario;
    
    INSERT INTO detalle_usuarios(idusuario, idempresa)VALUES
    (@nuevousuario, 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_ver_requerimiento` (IN `_idrequerimiento` INT)   BEGIN
	SELECT * FROM requerimientos where idrequerimiento = _idrequerimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spVerificarCliente` (IN `_ruc` VARCHAR(12))   BEGIN
    DECLARE cluentaCliente BOOLEAN;
    
    SELECT COUNT(*) INTO cluentaCliente
    FROM empresas_cliente
    WHERE nroDocumento = _ruc;
    
    IF cluentaCliente > 0 THEN
        SELECT TRUE AS `exists`;
    ELSE
        SELECT FALSE AS `exists`;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_requerimiento` (IN `p_idrequerimiento` INT)   BEGIN
    SELECT 
        dr.iddet_requerimiento,
        dr.item,
        dr.cantidad,
        dr.estado
    FROM det_requerimientos dr
    WHERE dr.idrequerimiento = p_idrequerimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_requerimientos` ()   BEGIN
    SELECT 
        r.idrequerimiento,
        CONCAT(u.nombres, ' ', u.apellidos) AS usuario,
        r.motivo,
        r.fecha,
        r.observacion,
        r.estado
    FROM requerimientos r
    INNER JOIN detalle_usuarios du ON r.idusuario = du.iddetalleusuario
    INNER JOIN usuarios u ON du.idusuario = u.idusuario ORDER BY r.idrequerimiento DESC ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizaciones_proveedores`
--

CREATE TABLE `cotizaciones_proveedores` (
  `idcotizacion_prov` int(11) NOT NULL,
  `idrequerimiento` int(11) DEFAULT NULL,
  `empresa` varchar(60) DEFAULT NULL,
  `moneda` varchar(20) DEFAULT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cotizaciones_proveedores`
--

INSERT INTO `cotizaciones_proveedores` (`idcotizacion_prov`, `idrequerimiento`, `empresa`, `moneda`, `estado`) VALUES
(3, 17, 'TORIBIO SAC', 'SOLES', '1'),
(4, 17, 'SHULS', 'SOLES', '0'),
(5, 17, 'SAN FERNANDO', 'SOLES', '1'),
(6, 17, 'OBREROS SAC', 'DOLARES', '1'),
(7, 15, 'SAN FERNANDO', 'SOLES', '1'),
(8, 14, 'SAC MANUEL', 'SOLES', '1'),
(9, 18, 'CHINA SAC', 'SOLES', '1'),
(10, 18, 'PERU SAC', 'SOLES', '1'),
(11, 13, 'DIMELO', 'SOLES', '1'),
(12, 12, 'FALCOT SAC', 'SOLES', '1'),
(13, 19, 'OBREORS SAC', 'SOLES', '1'),
(14, 19, 'FALCOT SAC', 'SOLES', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `iddepartamento` int(11) NOT NULL,
  `departamento` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`iddepartamento`, `departamento`) VALUES
(1, 'Amazonas'),
(2, 'Áncash'),
(3, 'Apurímac'),
(4, 'Arequipa'),
(5, 'Ayacucho'),
(6, 'Cajamarca'),
(7, 'Callao'),
(8, 'Cusco'),
(9, 'Huancavelica'),
(10, 'Huánuco'),
(11, 'Ica'),
(12, 'Junín'),
(13, 'La Libertad'),
(14, 'Lambayeque'),
(15, 'Lima'),
(16, 'Loreto'),
(17, 'Madre de Dios'),
(18, 'Moquegua'),
(26, 'No Asignado'),
(19, 'Pasco'),
(20, 'Piura'),
(21, 'Puno'),
(22, 'San Martín'),
(23, 'Tacna'),
(24, 'Tumbes'),
(25, 'Ucayali');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_orden_compra`
--

CREATE TABLE `detalle_orden_compra` (
  `iddetalleordencompra` int(11) NOT NULL,
  `idordencompra` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `centro` int(11) DEFAULT NULL,
  `descripcion` varchar(60) NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `utm` char(10) NOT NULL,
  `precioUnitario` decimal(10,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `detalle_orden_compra`
--

INSERT INTO `detalle_orden_compra` (`iddetalleordencompra`, `idordencompra`, `item`, `centro`, `descripcion`, `cantidad`, `utm`, `precioUnitario`) VALUES
(1, 1, 1, 530, 'OXIGENO INDUSTRIAL EN CIL.', '1.00', 'KG', '127.1200'),
(2, 2, 1, 530, 'OXIGENO INDUSTRIAL EN CIL.', '1.00', 'KG', '127.1200'),
(3, 3, 1, 530, 'PINTURAS EN SPRAY CYA', '4.00', 'KG', '37.2900'),
(4, 4, 1, 530, 'ORING MILIMETRICO 3 X 15', '20.00', 'UND', '0.6000'),
(5, 5, 1, 530, 'ORING MILIMETRICO 3 X 15 - B-565', '20.00', 'UND', '0.5100'),
(6, 5, 2, 530, 'ORING MILIMETRICO 3 X 16 - B-567', '20.00', 'UND', '0.5500'),
(7, 5, 3, 530, 'ORING MILIMETRICO 2 * 12 - B-220', '10.00', 'UND', '0.2700'),
(8, 5, 4, 530, 'ORING MILIMETRICO 2 * 14 - B-224', '10.00', 'UND', '0.3800'),
(9, 5, 5, 530, 'ORING MILIMETRICO 2 * 18 - B-232', '10.00', 'UND', '0.4100'),
(10, 5, 6, 530, 'ORING MILIMETRICO 2.95 * 14 - B-563', '20.00', 'UND', '0.4900'),
(11, 5, 7, 530, 'ORING MILIMETRICO 2 * 17 - B-228', '10.00', 'UND', '0.5100'),
(12, 5, 8, 530, 'ORING MILIMETRICO 2 * 17 - B-230', '10.00', 'UND', '0.5500'),
(13, 5, 9, 530, 'PASADORES TUBULARES 3 * 2/12 - PATB-3', '10.00', 'UND', '1.8600'),
(14, 5, 10, 530, 'PASADOR TUBULAR 6 * 2.1/2 - PATB-6', '10.00', 'UND', '2.1200'),
(15, 5, 11, 530, 'PASADOR TUBULAR 6 * 2 - PATB-2', '10.00', 'UND', '2.3700'),
(16, 5, 12, 530, 'PASADORES 1/8 * 1.1/2 - PA-1812', '100.00', 'UND', '0.2100'),
(17, 6, 10, 530, 'PASADOR TUBULAR 6*2.1/2', '10.00', 'UND', '2.1200'),
(18, 6, 12, 530, 'PASADORES 1/8*1.1/2', '100.00', 'UND', '0.2100'),
(19, 6, 11, 530, 'PASADOR TUBULAR 6*2', '10.00', 'UND', '2.3700'),
(20, 6, 9, 530, 'PASADORES TUBULARES 3*2/12', '10.00', 'UND', '1.8600'),
(21, 6, 8, 530, 'ORING MILIMETRICO 2*17', '10.00', 'UND', '0.5500'),
(22, 6, 6, 530, 'ORING MILIMETRICO 2.95*14', '20.00', 'UND', '0.4900'),
(23, 6, 5, 530, 'ORING MILIMETRICO 2*18', '10.00', 'UND', '0.4100'),
(24, 6, 7, 530, 'ORING MILIMETRICO 2*17', '10.00', 'UND', '0.5100'),
(25, 6, 2, 530, 'ORING MILIMETRICO 3 X 16', '20.00', 'UND', '0.5500'),
(26, 6, 1, 530, 'ORING MILIMETRICO 3 X 15', '20.00', 'UND', '0.5100'),
(27, 6, 3, 530, 'ORING MILIMETRICO 2*12', '10.00', 'UND', '0.2700'),
(28, 6, 4, 530, 'ORING MILIMETRICO 2*14', '10.00', 'UND', '0.3800'),
(29, 7, 1, 530, 'ORING MILIMETRICO 3 X 15 B- 565', '20.00', 'UND', '0.5100'),
(30, 7, 9, 530, 'PASADORES TUBULARES 3*2./12 PATB- 3', '10.00', 'UND', '1.8600'),
(31, 7, 10, 530, 'PASADOR TUBULAR 6*2.1/2 PATB- 6', '10.00', 'UND', '2.1200'),
(32, 7, 12, 530, 'PASADORES 1/8*1.1/2 PA- 1812', '100.00', 'UND', '0.2100'),
(33, 7, 11, 530, 'PASADOR TUBULAR 6*2 PATB- 2', '10.00', 'UND', '2.3700'),
(34, 7, 7, 530, 'ORING MILIMETRICO 2*17 B- 228', '10.00', 'UND', '0.5100'),
(35, 7, 6, 530, 'ORING MILIMETRICO 2.95*14 B- 563', '20.00', 'UND', '0.4900'),
(36, 7, 8, 530, 'ORING MILIMETRICO 2*17 B- 230', '10.00', 'UND', '0.5500'),
(37, 7, 4, 530, 'ORING  MILIMETRICO 2*14 B-224', '10.00', 'UND', '0.3800'),
(38, 7, 2, 530, 'ORING MILIMETRICO 3 X 16 B-567', '20.00', 'UND', '0.5500'),
(39, 7, 5, 530, 'ORING MILIMETRICO 2*18 B- 232', '10.00', 'UND', '0.4100'),
(40, 7, 3, 530, 'ORING MILIMETRICO 2* 12 B-220', '10.00', 'UND', '0.2700'),
(41, 8, 1, 530, 'ORING MILIMETRICO 3 X 15 B-565', '20.00', 'UND', '0.5080'),
(42, 8, 3, 530, 'ORING MILIMETRICO 2\" B-220', '10.00', 'UND', '0.2710'),
(43, 8, 2, 530, 'ORING MILIMETRICO 3 X 16 B-567', '20.00', 'UND', '0.5510'),
(44, 9, 1, 530, 'ORING MILIMETRICO 3 X 15 B-565 ', '20.00', 'UND', '0.5080'),
(45, 9, 2, 530, 'ORING MILIMETRICO 3 X 16  B-567 ', '20.00', 'UND', '0.5510'),
(46, 9, 3, 530, 'ORING MILIMETRICO 2*12 B-220 ', '10.00', 'UND', '0.2710'),
(47, 9, 4, 530, 'ORING MILIMETRICO 2*14 B-224', '10.00', 'UND', '0.3810'),
(48, 9, 5, 530, 'ORING MILIMETRICO 2*18 B-232 ', '10.00', 'UND', '0.4070'),
(49, 9, 6, 530, 'ORING MILIMETRICO 2.95*14 B-563 ', '20.00', 'UND', '0.4920'),
(50, 9, 7, 530, 'ORING MILIMETRICO 2*17 B-228', '10.00', 'UND', '0.5080'),
(51, 9, 8, 530, 'ORING MILIMETRCO 2*17 B-230 ', '10.00', 'UND', '0.5510'),
(52, 9, 9, 530, 'PASADORES TUBULARES 3*2./12 PATB-3 ', '10.00', 'UND', '1.8640'),
(53, 9, 10, 530, 'PASADOR TUBULAR 6*2.1/2 PATB-6 ', '10.00', 'UND', '2.1190'),
(54, 9, 11, 530, 'PASADOR TUBULAR 6*2 PATB-2 ', '10.00', 'UND', '2.3730'),
(55, 9, 12, 530, 'PASADORES 1/8*1.1/2 PA-1812 ', '100.00', 'UND', '0.2120'),
(56, 10, 1, 530, 'ORING MILIMETRICO 3 X 15 B-565', '20.00', 'UND', '0.5080'),
(57, 10, 2, 530, 'ORING MILIMETRICO 3 X 15 B-565', '20.00', 'UND', '0.5510'),
(58, 10, 4, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '0.3810'),
(59, 10, 3, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '0.2710'),
(60, 10, 12, 530, 'ORING MILIMETRICO 3 X 15 B-565', '100.00', 'UND', '0.2120'),
(61, 10, 11, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '2.3720'),
(62, 10, 10, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '2.1190'),
(63, 10, 7, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '0.5080'),
(64, 10, 9, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '1.8640'),
(65, 10, 8, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '0.5510'),
(66, 10, 6, 530, 'ORING MILIMETRICO 3 X 15 B-565', '20.00', 'UND', '0.4920'),
(67, 10, 5, 530, 'ORING MILIMETRICO 3 X 15 B-565', '10.00', 'UND', '0.4070'),
(68, 11, 1, 530, 'ORING MILIMETRICO 3 X 15 B- 565', '20.00', 'UND', '0.5080'),
(69, 11, 2, 530, 'ORING MILIMETRICO 3 X 16 B- 567', '20.00', 'UND', '0.5510'),
(70, 11, 3, 530, 'ORING MILIMETRICO 2*12 B- 220', '10.00', 'UND', '0.2710'),
(71, 11, 6, 530, 'ORING MILIMETRICO 2.95*14 B- 563', '20.00', 'UND', '0.4920'),
(72, 11, 5, 530, 'ORING MILIMETRICO 2*18 B- 232', '10.00', 'UND', '0.4070'),
(73, 11, 7, 530, 'ORING MILIMETRICO 2*17 B- 228', '10.00', 'UND', '0.5080'),
(74, 11, 4, 530, 'ORING MILIMETRICO 2*14 B- 224', '10.00', 'UND', '0.3810'),
(75, 11, 8, 530, 'ORING MILIMETRICO 2*17 B- 230', '10.00', 'UND', '0.5510'),
(76, 11, 10, 530, 'PASADOR TUBULAR 6*2.1/2 PATB- 6', '10.00', 'UND', '2.1190'),
(77, 11, 9, 530, 'PASADORES TUBULARES 3*2./12 PATB-3', '10.00', 'UND', '1.8640'),
(78, 11, 11, 530, 'PASADOR TUBULAR 6*2 PATB- 2', '10.00', 'UND', '2.3720'),
(79, 11, 12, 530, 'PASADORES 1/8*1.1/2 PA- 1812', '100.00', 'UND', '0.2120'),
(80, 12, 1, 530, '983-326 CINTA REFLECTIVA G DIAMANTE ROJO/BLANCO 2\"X50YD 3M ', '1.00', 'UND', '317.8000'),
(81, 13, 1, 2, 'POR PRUEBA', '2.00', 'UND', '20.0000'),
(82, 14, 1, 530, 'PLATINA 11/4X1/4', '1.00', 'UND', '115.2500'),
(83, 15, 1, 530, 'OXIGENO INDUSTRIAL EN CIL. PROPIEDAD OVASUR', '10.00', 'UND', '12.7120'),
(84, 16, 1, 530, 'OXIGENO INDUSTRIAL EN CIL. PROPIEDAD OVASUR ', '10.00', 'UND', '12.7120'),
(85, 17, 1, 530, 'BARRA IH. MAT 1045 CROMADA 040 MM', '40.00', 'METRO', '3.0500'),
(86, 18, 1, 530, 'OXIGENO INDUSTRIAL', '10.00', 'M3', '12.7120'),
(87, 19, 1, 530, 'OXIGENO INDUSTRIAL', '10.00', 'M3', '12.7120'),
(88, 20, 1, 530, 'OXIGENO INDUSTRIAL', '10.00', 'M3', '12.7120'),
(89, 21, 1, 530, 'RESORTE DE COMPRENSION ACERO INOX 0.80MM X 6MM X 40MM', '400.00', 'UND', '2.5420'),
(90, 22, 1, 530, 'RESORTE DE COMPRENSION ACERO INOX 0.80MM X 6MM X 40MM', '400.00', 'UND', '2.5430'),
(91, 23, 1, 530, 'OXIGENO INDUSTRIAL', '10.00', 'M3', '12.7120'),
(92, 24, 1, 530, 'RESORTES DE COMPRENSION INOX ', '400.00', 'UND', '2.5420'),
(93, 25, 1, 530, 'resortes de comprension inox 0.80mmx6mmx40mm', '400.00', 'UND', '2.5420'),
(94, 26, 1, 530, 'resorte de comprension acero inox 0.80mmx6mmx40mm', '400.00', 'UND', '2.5430'),
(95, 27, 1, 2, 'producto 1', '400.00', 'UND', '3.0000'),
(96, 27, 2, 3, 'producto 2', '20.00', 'UND', '3.5000'),
(97, 27, 3, 4, 'producto 3', '10.00', 'UND', '10.9000'),
(98, 28, 1, 1, 'producto1', '400.00', 'UND', '3.0000'),
(99, 28, 3, 3, 'producno', '110.00', 'UND', '10.9000'),
(100, 28, 2, 2, 'producto2', '20.00', 'UND', '3.0000'),
(101, 29, 1, 530, 'RESORTE DE COMPRENSION ACERO INOX 0.80 MM X 6MM X 40MM', '400.00', 'UND', '3.0000'),
(102, 30, 1, 2, 'PRUEBA', '0.50', 'KG', '100.0000'),
(103, 31, 1, 2, 'PRU', '0.40', 'METRO', '359.9000'),
(104, 32, 1, 530, 'BARRA IH. MAT 1045 CROMADA Ø40 MM', '0.40', 'METRO', '359.9000'),
(105, 33, 1, 530, 'RESORTE DE COMPRENSION ACERO INOX 0.80 X 6MM X 40 MM', '500.00', 'UND', '3.0000'),
(106, 34, 1, 530, 'OXIGENO INDUSTRIAL ', '10.00', 'M3', '15.0000'),
(107, 35, 1, 530, 'BARRA DE NYLON', '1.00', 'UND', '89.9980'),
(108, 36, 1, 530, 'BRONCE SAE 64 DE 2X1 1/2', '1.00', 'UND', '170.9270'),
(109, 37, 1, 530, 'BRONCE SAE 64 DE 2X1 1/2', '1.00', 'UND', '238.0000'),
(110, 38, 1, 530, 'RODAMIENTO RIGIDO DE 1HIL.DE BOLAS 8X22X7', '2.00', 'UND', '9.4751'),
(111, 38, 2, 530, 'RODAMIENTO RIGIDO DE 1HIL.DE BOLAS 12X32X10', '2.00', 'UND', '10.8560'),
(112, 38, 3, 530, 'CHUMACERA PARED EJE 2\"', '1.00', 'UND', '140.1950'),
(113, 38, 4, 530, 'SELLOS INDUSTRIALES 20X30X7 HMSA10 RG', '18.00', 'UND', '4.9560'),
(114, 38, 5, 530, 'SELLOS INDUSTRIALES CR 25X52X8 HMSA 10 RG', '3.00', 'UND', '5.6520'),
(115, 39, 1, 530, 'NEGRO BRILLANTE # 11', '2.00', 'UND', '44.0000'),
(116, 39, 2, 530, 'SPRAY ROJO BRILLANTE # 311', '1.00', 'UND', '44.0000'),
(117, 39, 3, 530, 'DORADO #27', '1.00', 'UND', '65.0000'),
(118, 39, 4, 530, 'MEDIUM GRAY # 22', '2.00', 'UND', '44.0000'),
(119, 40, 1, 530, 'soldadura overcord s 1/8', '2.00', 'KG', '20.0000'),
(120, 40, 2, 530, 'soldadura citofonte 5/32', '0.50', 'KG', '300.0000'),
(121, 41, 1, 530, 'POLO MANGA LARGA 20/1 TALLA M PLOMO', '10.00', 'UND', '13.0000'),
(122, 41, 2, 530, 'POLO MANGA LARGA 20/1 TALLA L PLOMO', '4.00', 'UND', '13.0000'),
(123, 41, 3, 530, 'PANTALON JEAN LAVADO 1/32-5/30-1/34', '7.00', 'UND', '34.5000'),
(124, 41, 4, 530, 'LENTE VISION ANTIEMPAÑANTE AF SEGPRO DOCENA', '1.00', 'UND', '30.0000'),
(125, 42, 1, 530, 'SOLDADURA OVERCORD S 1/8', '2.00', 'KG', '20.0010'),
(126, 42, 2, 530, 'SOLDADURA CITOFONTE 5/32', '0.50', 'KG', '300.0030'),
(127, 43, 1, 530, 'RODAMIENTO RIGIDO DE BOLAS 25X52X15', '2.00', 'UND', '17.8770'),
(128, 43, 2, 530, 'RODAMIENTO RIGIDO DE BOLAS 20X47X14', '2.00', 'UND', '15.6940'),
(129, 43, 3, 530, 'RODAMIENTO RIGIDO DE 1HIL. DE BOLAS 15X35X11', '2.00', 'UND', '11.8000'),
(130, 43, 4, 530, 'RODAMIENTO RIGIDO DE 1HIL. DE BOLAS 17X40X12', '2.00', 'UND', '13.1810'),
(131, 43, 5, 530, 'RODAMIENTO RIGIDO DE 1HIL. DE BOLAS 12X37X12', '2.00', 'UND', '13.1220'),
(132, 43, 6, 530, 'RODAMIENTO RIGIDO DE 1HIL. DE BOLAS 30X72X19', '2.00', 'UND', '32.5330'),
(133, 43, 7, 530, 'RODAMIENTO RIGIDO DE BOLAS 30X62X16', '2.00', 'UND', '24.0480'),
(134, 43, 9, 530, 'SELLOS INDUSTRIALES 40X80X10 HMSA10 RG', '2.00', 'UND', '12.1540'),
(135, 43, 8, 530, 'RODAMIENTO DE BOLAS 45X100X25', '2.00', 'UND', '79.0950'),
(136, 43, 11, 530, 'RETEN CIEGO 90X7', '2.00', 'UND', '5.4750'),
(137, 43, 10, 530, 'SELLOS INDUSTRIALES 60X90X10 HMSA10 RG', '2.00', 'UND', '10.1830'),
(138, 43, 12, 530, 'SELLOS INDUSTRIALES 35X50X8 HMSA10 RG', '2.00', 'UND', '6.5020'),
(139, 43, 13, 530, 'SELLOS INDUSTRIALES 35X55X8 HMSA10 RG', '2.00', 'UND', '6.5020'),
(140, 43, 14, 530, 'RETEN REVESTIDO NITRILO D/LABIO 15X26X7', '2.00', 'UND', '1.9470'),
(141, 43, 15, 530, 'RETEN 30X50X10', '2.00', 'UND', '5.9240'),
(142, 43, 17, 530, 'RETEN REVESTIDO NITRILO D/LABIO 25.00X32.00X4.00', '2.00', 'UND', '2.5490'),
(143, 43, 18, 530, 'RETEN CR 25X40X8 HMSA10 RG', '2.00', 'UND', '5.3930'),
(144, 43, 16, 530, 'RETEN CR 30X50X7 HMSA10 RG', '2.00', 'UND', '5.9240'),
(145, 43, 19, 530, 'RETEN (30.00X45.00X7)', '2.00', 'UND', '5.8650'),
(146, 43, 20, 530, 'RETEN CR 20X35X8 HMSA10 RG D/LABIO', '2.00', 'UND', '6.2300'),
(147, 43, 21, 530, 'RETEN RECUBIERTO DE NITRILO CR 30X47X7 HMSA10 RG', '2.00', 'UND', '5.9240'),
(148, 43, 22, 530, 'SELLOS INDUSTRIALES 20X30X7 HMSA10 RG', '2.00', 'UND', '4.9670'),
(149, 44, 1, 530, 'ARGON P\'SOLDAR EN CILINDRO PROPIEDAD OVASUR', '8.00', 'M3', '50.0000'),
(150, 45, 1, 530, 'ARGON', '8.00', 'M3', '50.0000'),
(151, 46, 1, 530, 'GUANTE DE CUERO EXTERIOR REFORZADO DOCENA ', '1.00', 'UND', '75.0000'),
(152, 47, 3, 530, 'U. SIMPLE AC. INOX. C-316 C/R CLASS 150 3/8\"', '10.00', 'UND', '3.0400'),
(153, 47, 1, 530, 'U. SIMPLE AC. INOX. C-316 C/R CLASS 150 1/4\"', '40.00', 'UND', '2.2100'),
(154, 47, 2, 530, 'U. SIMPLE AC. INOX. C-316 C/R CLASS 150 1/2\"', '10.00', 'UND', '3.4600'),
(155, 48, 1, 530, 'GUANTE DE CUERO EXTERIOR REFORZADO DOCENA', '2.00', 'UND', '75.0000'),
(156, 49, 1, 530, 'Cardan T6 1010mm 60 hp c/Proteccion', '1.00', 'UND', '1058.4600'),
(157, 50, 1, 530, 'Cardan T8 1010mm 80-120 hp c/Proteccion', '1.00', 'UND', '1145.4300'),
(158, 51, 1, 530, 'OXIGENO INDUSTRIAL', '10.00', 'M3', '15.0000'),
(159, 52, 1, 530, 'OXIGENO INDUSTRIAL ', '20.00', 'M3', '15.0000'),
(160, 53, 1, 530, 'GUANTE DE BADANA IMPORTADO TECSEG DOCENA', '2.00', 'UND', '61.0000'),
(161, 54, 1, 530, 'chuck universal 8\" 3 mordazas k11-200mm', '1.00', 'UND', '580.0100'),
(162, 55, 1, 530, 'camara exterior + camara interior ', '2.00', 'UND', '299.0000'),
(163, 56, 1, 530, 'camara exterior + camara interior ', '2.00', 'UND', '299.0000'),
(164, 57, 1, 530, 'camara exterior + camara interior ', '1.00', 'UND', '299.0000'),
(165, 58, 1, 530, 'caja spray negro brillante ', '5.00', 'UND', '44.0000'),
(166, 58, 2, 530, 'caja spray negro mate ', '1.00', 'UND', '44.0000'),
(167, 58, 3, 530, 'caja spray jade green', '1.00', 'UND', '44.0000'),
(168, 58, 4, 530, 'caja spray morado', '1.00', 'UND', '44.0000'),
(169, 58, 5, 530, 'caja spray deep violet', '1.00', 'UND', '44.0000'),
(170, 58, 6, 530, 'caja spray dorado', '1.00', 'UND', '65.0000'),
(171, 59, 1, 530, 'caja spray negro brillante', '4.00', 'UND', '44.0000'),
(172, 59, 2, 530, 'caja spray negro mate', '1.00', 'UND', '44.0000'),
(173, 59, 3, 530, 'caja spray dorado', '1.00', 'UND', '65.0000'),
(174, 59, 4, 530, 'caja spray jade green', '1.00', 'UND', '44.0000'),
(175, 59, 5, 530, 'caja spray morado', '1.00', 'UND', '44.0000'),
(176, 59, 7, 530, 'caja spray plateado', '1.00', 'UND', '65.0000'),
(177, 59, 6, 530, 'caja spray deep violet', '1.00', 'UND', '44.0000'),
(178, 60, 1, 530, 'VALVULA DE LA BOMBA JP -150', '1.00', 'JUEGO', '135.0000'),
(179, 61, 1, 530, 'VALVULA DE LA BOMBA JP -150 ', '1.00', 'JUEGO', '135.0000'),
(180, 62, 1, 530, '30205 J2/Q ROD DE RODILLOS CONICOS MILIMETRICOS SK', '4.00', 'UND', '35.0000'),
(181, 62, 2, 530, 'M84548 ROD DE RODILLOS NTN', '2.00', 'UND', '35.0000'),
(182, 62, 3, 530, 'RETEN 25X52X8 HMSA10 RG SKF', '2.00', 'UND', '10.0000'),
(183, 63, 1, 530, 'PLACA CARB P/FRESAR FCC TPKR 1603PPR-YBG302', '10.00', 'UND', '14.1400'),
(184, 63, 2, 530, 'PLACA CARB P/FRESAR FCC TPKR 2204PDR-YBC301', '10.00', 'UND', '18.8000'),
(185, 64, 1, 530, 'PLACA CARB P/FRESAR FCC TPKR 1603PPR-YBG302', '10.00', 'UND', '16.6850'),
(186, 64, 2, 530, 'PLACA CARB P/FRESAR FCC TPKR 2204PDR-YBC301', '10.00', 'UND', '22.1840'),
(187, 65, 2, 530, 'MANDIL DE CUERO CROMO', '3.00', 'UND', '16.5000'),
(188, 65, 1, 530, 'LENTE ANTIEMPAÑANTE AF SP200 DOCENA', '2.00', 'UND', '30.0000'),
(189, 65, 3, 530, 'GUANTES CAJA DE 100 UNIDADES', '1.00', 'UND', '13.5000'),
(190, 66, 1, 530, 'PLACA CARB P/FRESAR FCC TPKR 1603PPR-YBG302', '10.00', 'UND', '16.6850'),
(191, 66, 2, 530, 'PLACA CARB P/FRESAR FCC TPKR 2204PDR-YBC301', '10.00', 'UND', '22.1840'),
(192, 67, 1, 530, 'chuck universal 8\"  mordazas k11-200mm sanou', '1.00', 'UND', '570.0000'),
(193, 67, 2, 530, 'cuchilla cuadradacob 10% 3/8\" 3/8\" x 4\" vrw tools land', '1.00', 'UND', '42.8200'),
(194, 68, 1, 530, 'oxigeno industrial', '1.00', 'M3', '150.0000'),
(195, 69, 1, 530, 'oxigeno industrial', '1.00', 'M3', '150.0000'),
(196, 70, 1, 530, 'oxigeno industrial', '1.00', 'M3', '150.0000'),
(197, 71, 1, 530, 'thiner acrilico reforzado envans iq -200 -2.8L', '6.00', 'UND', '15.0000'),
(198, 71, 2, 530, 'base al aceite automotriz evans gris 1GL', '3.00', 'UND', '35.0000'),
(199, 72, 5, 530, 'OREJERA ADAPTABLE AL CASCO', '2.00', 'UND', '18.0000'),
(200, 72, 6, 530, 'TAPON AUDITIVO EN BOLSA', '2.00', 'UND', '1.0000'),
(201, 72, 2, 530, 'MANDIL DE CUERO CROMO', '3.00', 'UND', '16.5000'),
(202, 72, 3, 530, 'GUANTES DE NITRILO COLOR CELESTE X 100 UND ', '1.00', 'UND', '13.5000'),
(203, 72, 4, 530, 'CASCO BELLPOWER BLANCO', '2.00', 'UND', '5.0000'),
(204, 72, 1, 530, 'LENTE ANTIEMPAÑANTE AF SP200 DOCENA', '2.00', 'UND', '30.0000'),
(205, 73, 3, 530, 'RETEN 30x52x7	', '3.00', 'UND', '11.0170'),
(206, 73, 4, 530, 'RETEN 30x80x10	', '3.00', 'UND', '11.8640'),
(207, 73, 2, 530, 'RETEN 20x30x5	', '3.00', 'UND', '8.4746'),
(208, 73, 1, 530, 'RETEN 15x24x7	', '3.00', 'UND', '8.4746'),
(209, 74, 2, 530, 'RETEN 20X30X5', '3.00', 'UND', '10.0000'),
(210, 74, 1, 530, 'RETEN 15X24X7', '3.00', 'UND', '10.0000'),
(211, 74, 3, 530, 'RETEN 30X52X7', '3.00', 'UND', '13.0000'),
(212, 74, 4, 530, 'RETEN 30X80X10', '3.00', 'UND', '14.0000'),
(213, 75, 1, 530, 'Rueda 10.0/75-15,3\" 14PR 760*264mm', '4.00', 'UND', '997.9850'),
(214, 76, 1, 530, 'RUEDA 10.0/75-15,3\" 14PR 760*264MM ', '4.00', 'UND', '997.9850'),
(215, 77, 1, 530, 'rod ntn 4t 30210', '5.00', 'UND', '49.5340'),
(216, 77, 3, 530, 'reten snd 55x90x10', '5.00', 'UND', '6.6820'),
(217, 77, 2, 530, 'rod ntn 4t 30207', '5.00', 'UND', '33.7657'),
(218, 78, 1, 530, 'RT 20+35+7 TC NBR70 RETEN RADIAL KMK PC503', '2.00', 'UND', '3.4000'),
(219, 78, 2, 530, 'RT 20+30+7 TC NBR70 RETEN RADIAL KMK PC004', '2.00', 'UND', '3.2000'),
(220, 78, 3, 530, 'RT 60+110+10 TC NBR70 RETEN RADIAL TTO', '2.00', 'UND', '24.0000'),
(221, 78, 4, 530, 'RT 15+24+7 TC NBR70 RETEN RADIAL TTO B401', '2.00', 'UND', '3.8000'),
(222, 78, 5, 530, 'RT 35+72+10 TC NBR70 RETEN RADIAL KMK PF635', '2.00', 'UND', '6.7000'),
(223, 78, 6, 530, 'RT 50+80+10 TC NBR70 RETEN RADIAL KMK PG051', '2.00', 'UND', '8.5000'),
(224, 78, 7, 530, 'RT 40+80+10 TC NBR70 RETEN RADIAL TTO G059', '2.00', 'UND', '12.0000'),
(225, 78, 8, 530, 'RT 20+30+5 TC NBR70 RETEN RADIAL KMK PC033', '2.00', 'UND', '3.2000'),
(226, 78, 9, 530, 'RT 30+52+7 TC NBR70 RETEN RADIAL TTO E2117', '2.00', 'UND', '4.7000'),
(227, 78, 10, 530, 'RT 20+38+8 TC NBR70 RETEN RADIAL TTO C866', '2.00', 'UND', '4.2000'),
(228, 78, 11, 530, 'RT 35+50+8 TC NBR70 RETEN RADIAL TTO E002', '2.00', 'UND', '4.5000'),
(229, 78, 12, 530, 'RT 50+68+8 TC NBR70 RETEN RADIAL TTO F476', '2.00', 'UND', '7.5000'),
(230, 78, 13, 530, '6204 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '11.3000'),
(231, 78, 14, 530, '6202 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '9.0000'),
(232, 78, 15, 530, '607 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '7.7000'),
(233, 78, 16, 530, '6006 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '15.5000'),
(234, 78, 17, 530, '6203 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '9.0000'),
(235, 78, 18, 530, '6304 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '15.0000'),
(236, 78, 19, 530, '6301 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '12.0000'),
(237, 78, 20, 530, '6207 2ZC3 ZKL ROD RIGIDO DE UNA HILERA ', '2.00', 'UND', '22.0000'),
(238, 78, 21, 530, '6205 ZKL ROD RIGIDO DE UNA HILERA DE BOLAS', '4.00', 'UND', '12.4000'),
(239, 78, 22, 530, '30205 A ZKL ROD RODILLO CONICO 25+52+15', '2.00', 'UND', '25.5000'),
(240, 79, 1, 530, 'CHUCK C/LLAVE 1-19MM 3/4\" JT4 SANOU', '1.00', 'UND', '29.7124'),
(241, 79, 2, 530, 'ESPIGA P/CHUCK MT4-JT4 SANOU', '1.00', 'UND', '8.3662'),
(242, 80, 1, 530, 'FLANGE NO MECANIZADO HELICE NEGRA ', '1.00', 'UND', '159.0600'),
(243, 81, 1, 530, 'Helice D.900mm 8 Aspas P.Var.(Negra)', '1.00', 'UND', '1176.7000'),
(244, 82, 1, 530, 'Flange no Mecanizado Helice Negra ALT', '1.00', 'UND', '159.0600'),
(245, 83, 1, 530, 'Helice D.900mm 8 Aspas P.Var(Negra)', '1.00', 'UND', '1176.7000'),
(246, 84, 1, 530, 'OXIGENO INDUSTRIAL', '1.00', 'M3', '150.0000'),
(247, 85, 1, 530, 'RETEN 45X85X10 TC - SND', '2.00', 'UND', '7.6200'),
(248, 85, 2, 530, 'RODAMIENTO NTN 6209 ZZC3/2AS', '2.00', 'UND', '39.4930'),
(249, 85, 3, 530, 'RODAMIENTO NTN 6201  ZZC3/5K', '2.00', 'UND', '9.9960'),
(250, 85, 4, 530, 'RODAMIENTO NTN 6202 ZZC3/2AS', '2.00', 'UND', '9.2790'),
(251, 85, 5, 530, 'RODAMIENTO NTN 6307 ZZC3/5K', '2.00', 'UND', '40.7040'),
(252, 85, 6, 530, 'RODAMIENTO NTN 6308 ZZC3/5K', '2.00', 'UND', '51.3740'),
(253, 85, 7, 530, 'RODAMIENTO NTN 6206 ZZC3/5K', '2.00', 'UND', '21.3380'),
(254, 86, 2, 530, 'CONO P/MANDRINADOR MANUAL MT4*1 1/2*18UNF M16*2.0 F1-MT4 VRW', '1.00', 'UND', '37.0040'),
(255, 86, 3, 530, 'PORTAS-BARRAS PARA BARRENAR F1-18-7PCS VRW CNC', '1.00', 'UND', '195.0060'),
(256, 86, 1, 530, 'MANDRINADOR MANUAL 3\" F1-18MM 1 1/2*18UNF VRW CNC', '1.00', 'UND', '64.9940'),
(257, 87, 1, 530, 'MANDRINADOR MANUAL 3\" F1-18MM 1 1/2*18UNF VRW CNC ', '1.00', 'UND', '64.9940'),
(258, 87, 3, 530, 'PORTAS-BARRAS PARA BARRENAR F1-18-7PCS VRW CNC', '1.00', 'UND', '195.0060'),
(259, 87, 2, 530, 'CONO P/MANDRINADOR MANUAL MT4*1 1/2*18UNF M16*2.0 F1-MT4 VRW', '1.00', 'UND', '37.0040'),
(260, 88, 1, 530, 'MESA EN CRUZ 550MM X 190MM VRW', '1.00', 'UND', '660.0000'),
(261, 89, 1, 530, 'JUEGO DE BROCAS COBALTO 1.0 - 13.0 MM 25PZS FEINM', '1.00', 'UND', '310.0000'),
(262, 90, 1, 530, 'OXIGENO INDUSTRIAL', '1.00', 'M3', '150.0000'),
(263, 91, 1, 530, 'oxigeno industrial', '1.00', 'M3', '150.0000'),
(264, 91, 2, 530, 'argon industrial', '1.00', 'M3', '500.0000'),
(265, 92, 1, 530, 'rodamiento 6205', '2.00', 'UND', '15.7050'),
(266, 92, 2, 530, 'rodamiento 6004', '6.00', 'UND', '12.1650'),
(267, 92, 3, 530, 'rodamiento 6002', '2.00', 'UND', '10.2070'),
(268, 93, 1, 530, 'oxigeno industrial ', '2.00', 'M3', '150.0000'),
(269, 94, 1, 530, 'surtidor modelo 3/8 boq 1.5mm', '3.00', 'UND', '164.5390'),
(270, 95, 1, 530, 'Cardan T6 1010mm 60 hp c/Proteccion', '2.00', 'UND', '931.2900'),
(271, 96, 1, 530, 'CARDAN T6 1010MM 60 HP C/PROTECCION ', '2.00', 'UND', '931.2900'),
(272, 97, 1, 530, 'TS TruSpark- Molycal - Grasa de alto desempeño con Moly NLGI', '4.00', 'KG', '18.2900'),
(273, 98, 2, 530, 'placa  carb p/fresar zcc tpkn2204pdskr-ybg202', '10.00', 'UND', '23.3050'),
(274, 98, 1, 530, 'placa carb p/fresar zcc tpkn1603pdskr-ybm351', '10.00', 'UND', '16.6970'),
(275, 99, 2, 530, 'brocas cil cobalto heinz mil. 1.0-13.0mm(x 25 piezas)', '1.00', 'UND', '413.7700'),
(276, 99, 1, 530, 'brocas cil 5% cob 1/16 - 1/2 (29pzas) vrw tools', '1.00', 'UND', '402.6040'),
(277, 100, 1, 530, 'BROCAS CIL 5% COB 1/16\" - 1/2\" (29PZAS) VRW TOOLS ', '1.00', 'UND', '402.6000'),
(278, 100, 2, 530, ' BROCAS CIL COBALTO HEINZ MIL. 1.0-13.0MM (X25 PIEZAS) ', '1.00', 'UND', '413.7700'),
(279, 101, 1, 530, 'ZAPATO FULL PLUS 41/4-40/2 ', '6.00', 'UND', '69.7000'),
(280, 101, 2, 530, 'POLO MANGA LARGA 20/1 TALLA M PLOMO', '10.00', 'UND', '12.5000'),
(281, 101, 3, 530, 'POLO MANGA LARGA 20/1 TALLA L PLOMO', '4.00', 'UND', '12.5000'),
(282, 101, 4, 530, 'LENTE ANTIEMPAÑANTE AF SP200 SEGPRO 1 DOCENA CLARO /1 DOCENA', '2.00', 'UND', '30.0000'),
(283, 102, 1, 530, 'PLANCHA DE FIERRO LIZA DE 3mm x 1.20mt x 2.40 mt', '3.00', 'UND', '235.0000'),
(284, 102, 2, 530, 'TUBOS CUADRADOS 1 1/4 x 2mm', '3.00', 'UND', '45.0000'),
(285, 102, 3, 530, 'TUBOS CUADRADOS 1 1/2 x 2mm', '1.00', 'UND', '52.0000'),
(286, 102, 4, 530, 'TUBOS RECTANGULARES DE 2\" x 3\" x 3mm', '2.00', 'UND', '135.0000'),
(287, 102, 5, 530, 'PUNTO AZUL 1/8', '10.00', 'KG', '16.0000'),
(288, 102, 6, 530, 'THINNER', '2.00', 'GL', '17.0000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_usuarios`
--

CREATE TABLE `detalle_usuarios` (
  `iddetalleusuario` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idempresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `detalle_usuarios`
--

INSERT INTO `detalle_usuarios` (`iddetalleusuario`, `idusuario`, `idempresa`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `det_cotizacion_data`
--

CREATE TABLE `det_cotizacion_data` (
  `iddet_cotizacion_data` int(11) NOT NULL,
  `idcotizacion_prov` int(11) DEFAULT NULL,
  `iddet_requerimiento` int(11) DEFAULT NULL,
  `marca` varchar(30) DEFAULT NULL,
  `precio_unitario` float(7,2) NOT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `det_cotizacion_data`
--

INSERT INTO `det_cotizacion_data` (`iddet_cotizacion_data`, `idcotizacion_prov`, `iddet_requerimiento`, `marca`, `precio_unitario`, `estado`) VALUES
(1, 3, 24, 'SKF', 10.00, '1'),
(2, 3, 25, 'NTN', 20.00, '1'),
(3, 4, 24, 'NAK', 90.00, '1'),
(4, 4, 25, 'NTN', 40.00, '1'),
(5, 5, 24, 'SKF', 10.00, '1'),
(6, 5, 25, 'NTN', 80.00, '1'),
(7, 6, 24, 'SKF', 8.00, '1'),
(8, 6, 25, 'ZKL', 20.00, '1'),
(9, 7, 21, 'SKF', 10.00, '1'),
(10, 8, 20, 'SKF', 100.00, '1'),
(11, 9, 26, 'KMK', 40.00, '1'),
(12, 9, 27, 'SKF', 20.00, '1'),
(13, 10, 26, 'SKF', 30.00, '1'),
(14, 10, 27, 'TTO', 50.00, '1'),
(15, 11, 19, 'SKF', 120.00, '1'),
(16, 12, 17, 'TRUPER', 45.00, '1'),
(17, 12, 18, 'KAMASA', 32.00, '1'),
(18, 13, 28, 'ACEROS', 20.00, '1'),
(19, 13, 29, 'TRUPER', 20.00, '1'),
(20, 14, 28, 'ACEROS', 10.00, '1'),
(21, 14, 29, 'TRUPER', 20.00, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `det_requerimientos`
--

CREATE TABLE `det_requerimientos` (
  `iddet_requerimiento` int(11) NOT NULL,
  `idrequerimiento` int(11) DEFAULT NULL,
  `item` varchar(100) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `det_requerimientos`
--

INSERT INTO `det_requerimientos` (`iddet_requerimiento`, `idrequerimiento`, `item`, `cantidad`, `estado`) VALUES
(1, 1, 'POLVORA BLUE 1/3', 10, '1'),
(2, 2, 'PINZA ELECTRICA', 2, '1'),
(5, NULL, 'olla', 100, '1'),
(6, NULL, 'olla', 100, '1'),
(7, 6, 'olla', 100, '1'),
(11, 9, 'Llanta', 1, '1'),
(12, 9, 'Guante', 10, '1'),
(13, 10, 'dimelo ', 1, '1'),
(14, 10, 'ada', 111, '1'),
(15, 11, 'ASDASSDFASDF', 1, '1'),
(16, 11, 'SADFSDF', 1, '1'),
(17, 12, 'ASDASSDFASDF', 1, '1'),
(18, 12, 'SADFSDF', 1, '1'),
(19, 13, 'aaaa', 1, '1'),
(20, 14, 'Clavos', 1, '1'),
(21, 15, 'Bolsa de cemento', 1, '1'),
(22, 16, 'SOLDURA', 100, '1'),
(23, 16, 'CINTAS', 25, '1'),
(24, 17, 'CLAVOS', 5, '1'),
(25, 17, 'UNION', 5, '1'),
(26, 18, 'CLAVOS', 1, '1'),
(27, 18, 'CEMENTO', 1, '1'),
(28, 19, 'clavos', 1, '1'),
(29, 19, 'alicates', 1, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distritos`
--

CREATE TABLE `distritos` (
  `iddistrito` int(11) NOT NULL,
  `distrito` varchar(60) NOT NULL,
  `idprovincia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `distritos`
--

INSERT INTO `distritos` (`iddistrito`, `distrito`, `idprovincia`) VALUES
(1, 'Chachapoyas', 1),
(2, 'Asunción', 1),
(3, 'Balsas', 1),
(4, 'Cheto', 1),
(5, 'Chiliquin', 1),
(6, 'Chuquibamba', 1),
(7, 'Granada', 1),
(8, 'Huancas', 1),
(9, 'La Jalca', 1),
(10, 'Leimebamba', 1),
(11, 'Levanto', 1),
(12, 'Magdalena', 1),
(13, 'Mariscal Castilla', 1),
(14, 'Molinopampa', 1),
(15, 'Montevideo', 1),
(16, 'Olleros', 1),
(17, 'Quinjalca', 1),
(18, 'San Francisco de Daguas', 1),
(19, 'San Isidro de Maino', 1),
(20, 'Soloco', 1),
(21, 'Sonche', 1),
(22, 'Bagua', 2),
(23, 'Aramango', 2),
(24, 'Copallin', 2),
(25, 'El Parco', 2),
(26, 'Imaza', 2),
(27, 'La Peca', 2),
(28, 'Jumbilla', 3),
(29, 'Chisquilla', 3),
(30, 'Churuja', 3),
(31, 'Corosha', 3),
(32, 'Cuispes', 3),
(33, 'Florida', 3),
(34, 'Jazan', 3),
(35, 'Recta', 3),
(36, 'San Carlos', 3),
(37, 'Shipasbamba', 3),
(38, 'Valera', 3),
(39, 'Yambrasbamba', 3),
(40, 'Nieva', 4),
(41, 'El Cenepa', 4),
(42, 'Río Santiago', 4),
(43, 'Lamud', 5),
(44, 'Camporredondo', 5),
(45, 'Cocabamba', 5),
(46, 'Colcamar', 5),
(47, 'Conila', 5),
(48, 'Inguilpata', 5),
(49, 'Longuita', 5),
(50, 'Lonya Chico', 5),
(51, 'Luya', 5),
(52, 'Luya Viejo', 5),
(53, 'María', 5),
(54, 'Ocalli', 5),
(55, 'Ocumal', 5),
(56, 'Pisuquia', 5),
(57, 'Providencia', 5),
(58, 'San Cristóbal', 5),
(59, 'San Francisco de Yeso', 5),
(60, 'San Jerónimo', 5),
(61, 'San Juan de Lopecancha', 5),
(62, 'Santa Catalina', 5),
(63, 'Santo Tomas', 5),
(64, 'Tingo', 5),
(65, 'Trita', 5),
(66, 'San Nicolás', 6),
(67, 'Chirimoto', 6),
(68, 'Cochamal', 6),
(69, 'Huambo', 6),
(70, 'Limabamba', 6),
(71, 'Longar', 6),
(72, 'Mariscal Benavides', 6),
(73, 'Milpuc', 6),
(74, 'Omia', 6),
(75, 'Santa Rosa', 6),
(76, 'Totora', 6),
(77, 'Vista Alegre', 6),
(78, 'Bagua Grande', 7),
(79, 'Cajaruro', 7),
(80, 'Cumba', 7),
(81, 'El Milagro', 7),
(82, 'Jamalca', 7),
(83, 'Lonya Grande', 7),
(84, 'Yamon', 7),
(85, 'Huaraz', 8),
(86, 'Cochabamba', 8),
(87, 'Colcabamba', 8),
(88, 'Huanchay', 8),
(89, 'Independencia', 8),
(90, 'Jangas', 8),
(91, 'La Libertad', 8),
(92, 'Olleros', 8),
(93, 'Pampas Grande', 8),
(94, 'Pariacoto', 8),
(95, 'Pira', 8),
(96, 'Tarica', 8),
(97, 'Aija', 9),
(98, 'Coris', 9),
(99, 'Huacllan', 9),
(100, 'La Merced', 9),
(101, 'Succha', 9),
(102, 'Llamellin', 10),
(103, 'Aczo', 10),
(104, 'Chaccho', 10),
(105, 'Chingas', 10),
(106, 'Mirgas', 10),
(107, 'San Juan de Rontoy', 10),
(108, 'Chacas', 11),
(109, 'Acochaca', 11),
(110, 'Chiquian', 12),
(111, 'Abelardo Pardo Lezameta', 12),
(112, 'Antonio Raymondi', 12),
(113, 'Aquia', 12),
(114, 'Cajacay', 12),
(115, 'Canis', 12),
(116, 'Colquioc', 12),
(117, 'Huallanca', 12),
(118, 'Huasta', 12),
(119, 'Huayllacayan', 12),
(120, 'La Primavera', 12),
(121, 'Mangas', 12),
(122, 'Pacllon', 12),
(123, 'San Miguel de Corpanqui', 12),
(124, 'Ticllos', 12),
(125, 'Carhuaz', 13),
(126, 'Acopampa', 13),
(127, 'Amashca', 13),
(128, 'Anta', 13),
(129, 'Ataquero', 13),
(130, 'Marcara', 13),
(131, 'Pariahuanca', 13),
(132, 'San Miguel de Aco', 13),
(133, 'Shilla', 13),
(134, 'Tinco', 13),
(135, 'Yungar', 13),
(136, 'San Luis', 14),
(137, 'San Nicolás', 14),
(138, 'Yauya', 14),
(139, 'Casma', 15),
(140, 'Buena Vista Alta', 15),
(141, 'Comandante Noel', 15),
(142, 'Yautan', 15),
(143, 'Corongo', 16),
(144, 'Aco', 16),
(145, 'Bambas', 16),
(146, 'Cusca', 16),
(147, 'La Pampa', 16),
(148, 'Yanac', 16),
(149, 'Yupan', 16),
(150, 'Huari', 17),
(151, 'Anra', 17),
(152, 'Cajay', 17),
(153, 'Chavin de Huantar', 17),
(154, 'Huacachi', 17),
(155, 'Huacchis', 17),
(156, 'Huachis', 17),
(157, 'Huantar', 17),
(158, 'Masin', 17),
(159, 'Paucas', 17),
(160, 'Ponto', 17),
(161, 'Rahuapampa', 17),
(162, 'Rapayan', 17),
(163, 'San Marcos', 17),
(164, 'San Pedro de Chana', 17),
(165, 'Uco', 17),
(166, 'Huarmey', 18),
(167, 'Cochapeti', 18),
(168, 'Culebras', 18),
(169, 'Huayan', 18),
(170, 'Malvas', 18),
(171, 'Caraz', 19),
(172, 'Huallanca', 19),
(173, 'Huata', 19),
(174, 'Huaylas', 19),
(175, 'Mato', 19),
(176, 'Pamparomas', 19),
(177, 'Pueblo Libre', 19),
(178, 'Santa Cruz', 19),
(179, 'Santo Toribio', 19),
(180, 'Yuracmarca', 19),
(181, 'Piscobamba', 20),
(182, 'Casca', 20),
(183, 'Eleazar Guzmán Barron', 20),
(184, 'Fidel Olivas Escudero', 20),
(185, 'Llama', 20),
(186, 'Llumpa', 20),
(187, 'Lucma', 20),
(188, 'Musga', 20),
(189, 'Ocros', 21),
(190, 'Acas', 21),
(191, 'Cajamarquilla', 21),
(192, 'Carhuapampa', 21),
(193, 'Cochas', 21),
(194, 'Congas', 21),
(195, 'Llipa', 21),
(196, 'San Cristóbal de Rajan', 21),
(197, 'San Pedro', 21),
(198, 'Santiago de Chilcas', 21),
(199, 'Cabana', 22),
(200, 'Bolognesi', 22),
(201, 'Conchucos', 22),
(202, 'Huacaschuque', 22),
(203, 'Huandoval', 22),
(204, 'Lacabamba', 22),
(205, 'Llapo', 22),
(206, 'Pallasca', 22),
(207, 'Pampas', 22),
(208, 'Santa Rosa', 22),
(209, 'Tauca', 22),
(210, 'Pomabamba', 23),
(211, 'Huayllan', 23),
(212, 'Parobamba', 23),
(213, 'Quinuabamba', 23),
(214, 'Recuay', 24),
(215, 'Catac', 24),
(216, 'Cotaparaco', 24),
(217, 'Huayllapampa', 24),
(218, 'Llacllin', 24),
(219, 'Marca', 24),
(220, 'Pampas Chico', 24),
(221, 'Pararin', 24),
(222, 'Tapacocha', 24),
(223, 'Ticapampa', 24),
(224, 'Chimbote', 25),
(225, 'Cáceres del Perú', 25),
(226, 'Coishco', 25),
(227, 'Macate', 25),
(228, 'Moro', 25),
(229, 'Nepeña', 25),
(230, 'Samanco', 25),
(231, 'Santa', 25),
(232, 'Nuevo Chimbote', 25),
(233, 'Sihuas', 26),
(234, 'Acobamba', 26),
(235, 'Alfonso Ugarte', 26),
(236, 'Cashapampa', 26),
(237, 'Chingalpo', 26),
(238, 'Huayllabamba', 26),
(239, 'Quiches', 26),
(240, 'Ragash', 26),
(241, 'San Juan', 26),
(242, 'Sicsibamba', 26),
(243, 'Yungay', 27),
(244, 'Cascapara', 27),
(245, 'Mancos', 27),
(246, 'Matacoto', 27),
(247, 'Quillo', 27),
(248, 'Ranrahirca', 27),
(249, 'Shupluy', 27),
(250, 'Yanama', 27),
(251, 'Abancay', 28),
(252, 'Chacoche', 28),
(253, 'Circa', 28),
(254, 'Curahuasi', 28),
(255, 'Huanipaca', 28),
(256, 'Lambrama', 28),
(257, 'Pichirhua', 28),
(258, 'San Pedro de Cachora', 28),
(259, 'Tamburco', 28),
(260, 'Andahuaylas', 29),
(261, 'Andarapa', 29),
(262, 'Chiara', 29),
(263, 'Huancarama', 29),
(264, 'Huancaray', 29),
(265, 'Huayana', 29),
(266, 'Kishuara', 29),
(267, 'Pacobamba', 29),
(268, 'Pacucha', 29),
(269, 'Pampachiri', 29),
(270, 'Pomacocha', 29),
(271, 'San Antonio de Cachi', 29),
(272, 'San Jerónimo', 29),
(273, 'San Miguel de Chaccrampa', 29),
(274, 'Santa María de Chicmo', 29),
(275, 'Talavera', 29),
(276, 'Tumay Huaraca', 29),
(277, 'Turpo', 29),
(278, 'Kaquiabamba', 29),
(279, 'José María Arguedas', 29),
(280, 'Antabamba', 30),
(281, 'El Oro', 30),
(282, 'Huaquirca', 30),
(283, 'Juan Espinoza Medrano', 30),
(284, 'Oropesa', 30),
(285, 'Pachaconas', 30),
(286, 'Sabaino', 30),
(287, 'Chalhuanca', 31),
(288, 'Capaya', 31),
(289, 'Caraybamba', 31),
(290, 'Chapimarca', 31),
(291, 'Colcabamba', 31),
(292, 'Cotaruse', 31),
(293, 'Ihuayllo', 31),
(294, 'Justo Apu Sahuaraura', 31),
(295, 'Lucre', 31),
(296, 'Pocohuanca', 31),
(297, 'San Juan de Chacña', 31),
(298, 'Sañayca', 31),
(299, 'Soraya', 31),
(300, 'Tapairihua', 31),
(301, 'Tintay', 31),
(302, 'Toraya', 31),
(303, 'Yanaca', 31),
(304, 'Tambobamba', 32),
(305, 'Cotabambas', 32),
(306, 'Coyllurqui', 32),
(307, 'Haquira', 32),
(308, 'Mara', 32),
(309, 'Challhuahuacho', 32),
(310, 'Chincheros', 33),
(311, 'Anco_Huallo', 33),
(312, 'Cocharcas', 33),
(313, 'Huaccana', 33),
(314, 'Ocobamba', 33),
(315, 'Ongoy', 33),
(316, 'Uranmarca', 33),
(317, 'Ranracancha', 33),
(318, 'Rocchacc', 33),
(319, 'El Porvenir', 33),
(320, 'Los Chankas', 33),
(321, 'Chuquibambilla', 34),
(322, 'Curpahuasi', 34),
(323, 'Gamarra', 34),
(324, 'Huayllati', 34),
(325, 'Mamara', 34),
(326, 'Micaela Bastidas', 34),
(327, 'Pataypampa', 34),
(328, 'Progreso', 34),
(329, 'San Antonio', 34),
(330, 'Santa Rosa', 34),
(331, 'Turpay', 34),
(332, 'Vilcabamba', 34),
(333, 'Virundo', 34),
(334, 'Curasco', 34),
(335, 'Arequipa', 35),
(336, 'Alto Selva Alegre', 35),
(337, 'Cayma', 35),
(338, 'Cerro Colorado', 35),
(339, 'Characato', 35),
(340, 'Chiguata', 35),
(341, 'Jacobo Hunter', 35),
(342, 'La Joya', 35),
(343, 'Mariano Melgar', 35),
(344, 'Miraflores', 35),
(345, 'Mollebaya', 35),
(346, 'Paucarpata', 35),
(347, 'Pocsi', 35),
(348, 'Polobaya', 35),
(349, 'Quequeña', 35),
(350, 'Sabandia', 35),
(351, 'Sachaca', 35),
(352, 'San Juan de Siguas', 35),
(353, 'San Juan de Tarucani', 35),
(354, 'Santa Isabel de Siguas', 35),
(355, 'Santa Rita de Siguas', 35),
(356, 'Socabaya', 35),
(357, 'Tiabaya', 35),
(358, 'Uchumayo', 35),
(359, 'Vitor', 35),
(360, 'Yanahuara', 35),
(361, 'Yarabamba', 35),
(362, 'Yura', 35),
(363, 'José Luis Bustamante Y Rivero', 35),
(364, 'Camaná', 36),
(365, 'José María Quimper', 36),
(366, 'Mariano Nicolás Valcárcel', 36),
(367, 'Mariscal Cáceres', 36),
(368, 'Nicolás de Pierola', 36),
(369, 'Ocoña', 36),
(370, 'Quilca', 36),
(371, 'Samuel Pastor', 36),
(372, 'Caravelí', 37),
(373, 'Acarí', 37),
(374, 'Atico', 37),
(375, 'Atiquipa', 37),
(376, 'Bella Unión', 37),
(377, 'Cahuacho', 37),
(378, 'Chala', 37),
(379, 'Chaparra', 37),
(380, 'Huanuhuanu', 37),
(381, 'Jaqui', 37),
(382, 'Lomas', 37),
(383, 'Quicacha', 37),
(384, 'Yauca', 37),
(385, 'Aplao', 38),
(386, 'Andagua', 38),
(387, 'Ayo', 38),
(388, 'Chachas', 38),
(389, 'Chilcaymarca', 38),
(390, 'Choco', 38),
(391, 'Huancarqui', 38),
(392, 'Machaguay', 38),
(393, 'Orcopampa', 38),
(394, 'Pampacolca', 38),
(395, 'Tipan', 38),
(396, 'Uñon', 38),
(397, 'Uraca', 38),
(398, 'Viraco', 38),
(399, 'Chivay', 39),
(400, 'Achoma', 39),
(401, 'Cabanaconde', 39),
(402, 'Callalli', 39),
(403, 'Caylloma', 39),
(404, 'Coporaque', 39),
(405, 'Huambo', 39),
(406, 'Huanca', 39),
(407, 'Ichupampa', 39),
(408, 'Lari', 39),
(409, 'Lluta', 39),
(410, 'Maca', 39),
(411, 'Madrigal', 39),
(412, 'San Antonio de Chuca', 39),
(413, 'Sibayo', 39),
(414, 'Tapay', 39),
(415, 'Tisco', 39),
(416, 'Tuti', 39),
(417, 'Yanque', 39),
(418, 'Majes', 39),
(419, 'Chuquibamba', 40),
(420, 'Andaray', 40),
(421, 'Cayarani', 40),
(422, 'Chichas', 40),
(423, 'Iray', 40),
(424, 'Río Grande', 40),
(425, 'Salamanca', 40),
(426, 'Yanaquihua', 40),
(427, 'Mollendo', 41),
(428, 'Cocachacra', 41),
(429, 'Dean Valdivia', 41),
(430, 'Islay', 41),
(431, 'Mejia', 41),
(432, 'Punta de Bombón', 41),
(433, 'Cotahuasi', 42),
(434, 'Alca', 42),
(435, 'Charcana', 42),
(436, 'Huaynacotas', 42),
(437, 'Pampamarca', 42),
(438, 'Puyca', 42),
(439, 'Quechualla', 42),
(440, 'Sayla', 42),
(441, 'Tauria', 42),
(442, 'Tomepampa', 42),
(443, 'Toro', 42),
(444, 'Ayacucho', 43),
(445, 'Acocro', 43),
(446, 'Acos Vinchos', 43),
(447, 'Carmen Alto', 43),
(448, 'Chiara', 43),
(449, 'Ocros', 43),
(450, 'Pacaycasa', 43),
(451, 'Quinua', 43),
(452, 'San José de Ticllas', 43),
(453, 'San Juan Bautista', 43),
(454, 'Santiago de Pischa', 43),
(455, 'Socos', 43),
(456, 'Tambillo', 43),
(457, 'Vinchos', 43),
(458, 'Jesús Nazareno', 43),
(459, 'Andrés Avelino Cáceres Dorregaray', 43),
(460, 'Cangallo', 44),
(461, 'Chuschi', 44),
(462, 'Los Morochucos', 44),
(463, 'María Parado de Bellido', 44),
(464, 'Paras', 44),
(465, 'Totos', 44),
(466, 'Sancos', 45),
(467, 'Carapo', 45),
(468, 'Sacsamarca', 45),
(469, 'Santiago de Lucanamarca', 45),
(470, 'Huanta', 46),
(471, 'Ayahuanco', 46),
(472, 'Huamanguilla', 46),
(473, 'Iguain', 46),
(474, 'Luricocha', 46),
(475, 'Santillana', 46),
(476, 'Sivia', 46),
(477, 'Llochegua', 46),
(478, 'Canayre', 46),
(479, 'Uchuraccay', 46),
(480, 'Pucacolpa', 46),
(481, 'Chaca', 46),
(482, 'San Miguel', 47),
(483, 'Anco', 47),
(484, 'Ayna', 47),
(485, 'Chilcas', 47),
(486, 'Chungui', 47),
(487, 'Luis Carranza', 47),
(488, 'Santa Rosa', 47),
(489, 'Tambo', 47),
(490, 'Samugari', 47),
(491, 'Anchihuay', 47),
(492, 'Oronccoy', 47),
(493, 'Puquio', 48),
(494, 'Aucara', 48),
(495, 'Cabana', 48),
(496, 'Carmen Salcedo', 48),
(497, 'Chaviña', 48),
(498, 'Chipao', 48),
(499, 'Huac-Huas', 48),
(500, 'Laramate', 48),
(501, 'Leoncio Prado', 48),
(502, 'Llauta', 48),
(503, 'Lucanas', 48),
(504, 'Ocaña', 48),
(505, 'Otoca', 48),
(506, 'Saisa', 48),
(507, 'San Cristóbal', 48),
(508, 'San Juan', 48),
(509, 'San Pedro', 48),
(510, 'San Pedro de Palco', 48),
(511, 'Sancos', 48),
(512, 'Santa Ana de Huaycahuacho', 48),
(513, 'Santa Lucia', 48),
(514, 'Coracora', 49),
(515, 'Chumpi', 49),
(516, 'Coronel Castañeda', 49),
(517, 'Pacapausa', 49),
(518, 'Pullo', 49),
(519, 'Puyusca', 49),
(520, 'San Francisco de Ravacayco', 49),
(521, 'Upahuacho', 49),
(522, 'Pausa', 50),
(523, 'Colta', 50),
(524, 'Corculla', 50),
(525, 'Lampa', 50),
(526, 'Marcabamba', 50),
(527, 'Oyolo', 50),
(528, 'Pararca', 50),
(529, 'San Javier de Alpabamba', 50),
(530, 'San José de Ushua', 50),
(531, 'Sara Sara', 50),
(532, 'Querobamba', 51),
(533, 'Belén', 51),
(534, 'Chalcos', 51),
(535, 'Chilcayoc', 51),
(536, 'Huacaña', 51),
(537, 'Morcolla', 51),
(538, 'Paico', 51),
(539, 'San Pedro de Larcay', 51),
(540, 'San Salvador de Quije', 51),
(541, 'Santiago de Paucaray', 51),
(542, 'Soras', 51),
(543, 'Huancapi', 52),
(544, 'Alcamenca', 52),
(545, 'Apongo', 52),
(546, 'Asquipata', 52),
(547, 'Canaria', 52),
(548, 'Cayara', 52),
(549, 'Colca', 52),
(550, 'Huamanquiquia', 52),
(551, 'Huancaraylla', 52),
(552, 'Hualla', 52),
(553, 'Sarhua', 52),
(554, 'Vilcanchos', 52),
(555, 'Vilcas Huaman', 53),
(556, 'Accomarca', 53),
(557, 'Carhuanca', 53),
(558, 'Concepción', 53),
(559, 'Huambalpa', 53),
(560, 'Independencia', 53),
(561, 'Saurama', 53),
(562, 'Vischongo', 53),
(563, 'Cajamarca', 54),
(564, 'Asunción', 54),
(565, 'Chetilla', 54),
(566, 'Cospan', 54),
(567, 'Encañada', 54),
(568, 'Jesús', 54),
(569, 'Llacanora', 54),
(570, 'Los Baños del Inca', 54),
(571, 'Magdalena', 54),
(572, 'Matara', 54),
(573, 'Namora', 54),
(574, 'San Juan', 54),
(575, 'Cajabamba', 55),
(576, 'Cachachi', 55),
(577, 'Condebamba', 55),
(578, 'Sitacocha', 55),
(579, 'Celendín', 56),
(580, 'Chumuch', 56),
(581, 'Cortegana', 56),
(582, 'Huasmin', 56),
(583, 'Jorge Chávez', 56),
(584, 'José Gálvez', 56),
(585, 'Miguel Iglesias', 56),
(586, 'Oxamarca', 56),
(587, 'Sorochuco', 56),
(588, 'Sucre', 56),
(589, 'Utco', 56),
(590, 'La Libertad de Pallan', 56),
(591, 'Chota', 57),
(592, 'Anguia', 57),
(593, 'Chadin', 57),
(594, 'Chiguirip', 57),
(595, 'Chimban', 57),
(596, 'Choropampa', 57),
(597, 'Cochabamba', 57),
(598, 'Conchan', 57),
(599, 'Huambos', 57),
(600, 'Lajas', 57),
(601, 'Llama', 57),
(602, 'Miracosta', 57),
(603, 'Paccha', 57),
(604, 'Pion', 57),
(605, 'Querocoto', 57),
(606, 'San Juan de Licupis', 57),
(607, 'Tacabamba', 57),
(608, 'Tocmoche', 57),
(609, 'Chalamarca', 57),
(610, 'Contumaza', 58),
(611, 'Chilete', 58),
(612, 'Cupisnique', 58),
(613, 'Guzmango', 58),
(614, 'San Benito', 58),
(615, 'Santa Cruz de Toledo', 58),
(616, 'Tantarica', 58),
(617, 'Yonan', 58),
(618, 'Cutervo', 59),
(619, 'Callayuc', 59),
(620, 'Choros', 59),
(621, 'Cujillo', 59),
(622, 'La Ramada', 59),
(623, 'Pimpingos', 59),
(624, 'Querocotillo', 59),
(625, 'San Andrés de Cutervo', 59),
(626, 'San Juan de Cutervo', 59),
(627, 'San Luis de Lucma', 59),
(628, 'Santa Cruz', 59),
(629, 'Santo Domingo de la Capilla', 59),
(630, 'Santo Tomas', 59),
(631, 'Socota', 59),
(632, 'Toribio Casanova', 59),
(633, 'Bambamarca', 60),
(634, 'Chugur', 60),
(635, 'Hualgayoc', 60),
(636, 'Jaén', 61),
(637, 'Bellavista', 61),
(638, 'Chontali', 61),
(639, 'Colasay', 61),
(640, 'Huabal', 61),
(641, 'Las Pirias', 61),
(642, 'Pomahuaca', 61),
(643, 'Pucara', 61),
(644, 'Sallique', 61),
(645, 'San Felipe', 61),
(646, 'San José del Alto', 61),
(647, 'Santa Rosa', 61),
(648, 'San Ignacio', 62),
(649, 'Chirinos', 62),
(650, 'Huarango', 62),
(651, 'La Coipa', 62),
(652, 'Namballe', 62),
(653, 'San José de Lourdes', 62),
(654, 'Tabaconas', 62),
(655, 'Pedro Gálvez', 63),
(656, 'Chancay', 63),
(657, 'Eduardo Villanueva', 63),
(658, 'Gregorio Pita', 63),
(659, 'Ichocan', 63),
(660, 'José Manuel Quiroz', 63),
(661, 'José Sabogal', 63),
(662, 'San Miguel', 64),
(663, 'Bolívar', 64),
(664, 'Calquis', 64),
(665, 'Catilluc', 64),
(666, 'El Prado', 64),
(667, 'La Florida', 64),
(668, 'Llapa', 64),
(669, 'Nanchoc', 64),
(670, 'Niepos', 64),
(671, 'San Gregorio', 64),
(672, 'San Silvestre de Cochan', 64),
(673, 'Tongod', 64),
(674, 'Unión Agua Blanca', 64),
(675, 'San Pablo', 65),
(676, 'San Bernardino', 65),
(677, 'San Luis', 65),
(678, 'Tumbaden', 65),
(679, 'Santa Cruz', 66),
(680, 'Andabamba', 66),
(681, 'Catache', 66),
(682, 'Chancaybaños', 66),
(683, 'La Esperanza', 66),
(684, 'Ninabamba', 66),
(685, 'Pulan', 66),
(686, 'Saucepampa', 66),
(687, 'Sexi', 66),
(688, 'Uticyacu', 66),
(689, 'Yauyucan', 66),
(690, 'Callao', 67),
(691, 'Bellavista', 67),
(692, 'Carmen de la Legua Reynoso', 67),
(693, 'La Perla', 67),
(694, 'La Punta', 67),
(695, 'Ventanilla', 67),
(696, 'Mi Perú', 67),
(697, 'Cusco', 68),
(698, 'Ccorca', 68),
(699, 'Poroy', 68),
(700, 'San Jerónimo', 68),
(701, 'San Sebastian', 68),
(702, 'Santiago', 68),
(703, 'Saylla', 68),
(704, 'Wanchaq', 68),
(705, 'Acomayo', 69),
(706, 'Acopia', 69),
(707, 'Acos', 69),
(708, 'Mosoc Llacta', 69),
(709, 'Pomacanchi', 69),
(710, 'Rondocan', 69),
(711, 'Sangarara', 69),
(712, 'Anta', 70),
(713, 'Ancahuasi', 70),
(714, 'Cachimayo', 70),
(715, 'Chinchaypujio', 70),
(716, 'Huarocondo', 70),
(717, 'Limatambo', 70),
(718, 'Mollepata', 70),
(719, 'Pucyura', 70),
(720, 'Zurite', 70),
(721, 'Calca', 71),
(722, 'Coya', 71),
(723, 'Lamay', 71),
(724, 'Lares', 71),
(725, 'Pisac', 71),
(726, 'San Salvador', 71),
(727, 'Taray', 71),
(728, 'Yanatile', 71),
(729, 'Yanaoca', 72),
(730, 'Checca', 72),
(731, 'Kunturkanki', 72),
(732, 'Langui', 72),
(733, 'Layo', 72),
(734, 'Pampamarca', 72),
(735, 'Quehue', 72),
(736, 'Tupac Amaru', 72),
(737, 'Sicuani', 73),
(738, 'Checacupe', 73),
(739, 'Combapata', 73),
(740, 'Marangani', 73),
(741, 'Pitumarca', 73),
(742, 'San Pablo', 73),
(743, 'San Pedro', 73),
(744, 'Tinta', 73),
(745, 'Santo Tomas', 74),
(746, 'Capacmarca', 74),
(747, 'Chamaca', 74),
(748, 'Colquemarca', 74),
(749, 'Livitaca', 74),
(750, 'Llusco', 74),
(751, 'Quiñota', 74),
(752, 'Velille', 74),
(753, 'Espinar', 75),
(754, 'Condoroma', 75),
(755, 'Coporaque', 75),
(756, 'Ocoruro', 75),
(757, 'Pallpata', 75),
(758, 'Pichigua', 75),
(759, 'Suyckutambo', 75),
(760, 'Alto Pichigua', 75),
(761, 'Santa Ana', 76),
(762, 'Echarate', 76),
(763, 'Huayopata', 76),
(764, 'Maranura', 76),
(765, 'Ocobamba', 76),
(766, 'Quellouno', 76),
(767, 'Kimbiri', 76),
(768, 'Santa Teresa', 76),
(769, 'Vilcabamba', 76),
(770, 'Pichari', 76),
(771, 'Inkawasi', 76),
(772, 'Villa Virgen', 76),
(773, 'Villa Kintiarina', 76),
(774, 'Megantoni', 76),
(775, 'Paruro', 77),
(776, 'Accha', 77),
(777, 'Ccapi', 77),
(778, 'Colcha', 77),
(779, 'Huanoquite', 77),
(780, 'Omachaç', 77),
(781, 'Paccaritambo', 77),
(782, 'Pillpinto', 77),
(783, 'Yaurisque', 77),
(784, 'Paucartambo', 78),
(785, 'Caicay', 78),
(786, 'Challabamba', 78),
(787, 'Colquepata', 78),
(788, 'Huancarani', 78),
(789, 'Kosñipata', 78),
(790, 'Urcos', 79),
(791, 'Andahuaylillas', 79),
(792, 'Camanti', 79),
(793, 'Ccarhuayo', 79),
(794, 'Ccatca', 79),
(795, 'Cusipata', 79),
(796, 'Huaro', 79),
(797, 'Lucre', 79),
(798, 'Marcapata', 79),
(799, 'Ocongate', 79),
(800, 'Oropesa', 79),
(801, 'Quiquijana', 79),
(802, 'Urubamba', 80),
(803, 'Chinchero', 80),
(804, 'Huayllabamba', 80),
(805, 'Machupicchu', 80),
(806, 'Maras', 80),
(807, 'Ollantaytambo', 80),
(808, 'Yucay', 80),
(809, 'Huancavelica', 81),
(810, 'Acobambilla', 81),
(811, 'Acoria', 81),
(812, 'Conayca', 81),
(813, 'Cuenca', 81),
(814, 'Huachocolpa', 81),
(815, 'Huayllahuara', 81),
(816, 'Izcuchaca', 81),
(817, 'Laria', 81),
(818, 'Manta', 81),
(819, 'Mariscal Cáceres', 81),
(820, 'Moya', 81),
(821, 'Nuevo Occoro', 81),
(822, 'Palca', 81),
(823, 'Pilchaca', 81),
(824, 'Vilca', 81),
(825, 'Yauli', 81),
(826, 'Ascensión', 81),
(827, 'Huando', 81),
(828, 'Acobamba', 82),
(829, 'Andabamba', 82),
(830, 'Anta', 82),
(831, 'Caja', 82),
(832, 'Marcas', 82),
(833, 'Paucara', 82),
(834, 'Pomacocha', 82),
(835, 'Rosario', 82),
(836, 'Lircay', 83),
(837, 'Anchonga', 83),
(838, 'Callanmarca', 83),
(839, 'Ccochaccasa', 83),
(840, 'Chincho', 83),
(841, 'Congalla', 83),
(842, 'Huanca-Huanca', 83),
(843, 'Huayllay Grande', 83),
(844, 'Julcamarca', 83),
(845, 'San Antonio de Antaparco', 83),
(846, 'Santo Tomas de Pata', 83),
(847, 'Secclla', 83),
(848, 'Castrovirreyna', 84),
(849, 'Arma', 84),
(850, 'Aurahua', 84),
(851, 'Capillas', 84),
(852, 'Chupamarca', 84),
(853, 'Cocas', 84),
(854, 'Huachos', 84),
(855, 'Huamatambo', 84),
(856, 'Mollepampa', 84),
(857, 'San Juan', 84),
(858, 'Santa Ana', 84),
(859, 'Tantara', 84),
(860, 'Ticrapo', 84),
(861, 'Churcampa', 85),
(862, 'Anco', 85),
(863, 'Chinchihuasi', 85),
(864, 'El Carmen', 85),
(865, 'La Merced', 85),
(866, 'Locroja', 85),
(867, 'Paucarbamba', 85),
(868, 'San Miguel de Mayocc', 85),
(869, 'San Pedro de Coris', 85),
(870, 'Pachamarca', 85),
(871, 'Cosme', 85),
(872, 'Huaytara', 86),
(873, 'Ayavi', 86),
(874, 'Córdova', 86),
(875, 'Huayacundo Arma', 86),
(876, 'Laramarca', 86),
(877, 'Ocoyo', 86),
(878, 'Pilpichaca', 86),
(879, 'Querco', 86),
(880, 'Quito-Arma', 86),
(881, 'San Antonio de Cusicancha', 86),
(882, 'San Francisco de Sangayaico', 86),
(883, 'San Isidro', 86),
(884, 'Santiago de Chocorvos', 86),
(885, 'Santiago de Quirahuara', 86),
(886, 'Santo Domingo de Capillas', 86),
(887, 'Tambo', 86),
(888, 'Pampas', 87),
(889, 'Acostambo', 87),
(890, 'Acraquia', 87),
(891, 'Ahuaycha', 87),
(892, 'Colcabamba', 87),
(893, 'Daniel Hernández', 87),
(894, 'Huachocolpa', 87),
(895, 'Huaribamba', 87),
(896, 'Ñahuimpuquio', 87),
(897, 'Pazos', 87),
(898, 'Quishuar', 87),
(899, 'Salcabamba', 87),
(900, 'Salcahuasi', 87),
(901, 'San Marcos de Rocchac', 87),
(902, 'Surcubamba', 87),
(903, 'Tintay Puncu', 87),
(904, 'Quichuas', 87),
(905, 'Andaymarca', 87),
(906, 'Roble', 87),
(907, 'Pichos', 87),
(908, 'Santiago de Tucuma', 87),
(909, 'Huanuco', 88),
(910, 'Amarilis', 88),
(911, 'Chinchao', 88),
(912, 'Churubamba', 88),
(913, 'Margos', 88),
(914, 'Quisqui (Kichki)', 88),
(915, 'San Francisco de Cayran', 88),
(916, 'San Pedro de Chaulan', 88),
(917, 'Santa María del Valle', 88),
(918, 'Yarumayo', 88),
(919, 'Pillco Marca', 88),
(920, 'Yacus', 88),
(921, 'San Pablo de Pillao', 88),
(922, 'Ambo', 89),
(923, 'Cayna', 89),
(924, 'Colpas', 89),
(925, 'Conchamarca', 89),
(926, 'Huacar', 89),
(927, 'San Francisco', 89),
(928, 'San Rafael', 89),
(929, 'Tomay Kichwa', 89),
(930, 'La Unión', 90),
(931, 'Chuquis', 90),
(932, 'Marías', 90),
(933, 'Pachas', 90),
(934, 'Quivilla', 90),
(935, 'Ripan', 90),
(936, 'Shunqui', 90),
(937, 'Sillapata', 90),
(938, 'Yanas', 90),
(939, 'Huacaybamba', 91),
(940, 'Canchabamba', 91),
(941, 'Cochabamba', 91),
(942, 'Pinra', 91),
(943, 'Llata', 92),
(944, 'Arancay', 92),
(945, 'Chavín de Pariarca', 92),
(946, 'Jacas Grande', 92),
(947, 'Jircan', 92),
(948, 'Miraflores', 92),
(949, 'Monzón', 92),
(950, 'Punchao', 92),
(951, 'Puños', 92),
(952, 'Singa', 92),
(953, 'Tantamayo', 92),
(954, 'Rupa-Rupa', 93),
(955, 'Daniel Alomía Robles', 93),
(956, 'Hermílio Valdizan', 93),
(957, 'José Crespo y Castillo', 93),
(958, 'Luyando', 93),
(959, 'Mariano Damaso Beraun', 93),
(960, 'Pucayacu', 93),
(961, 'Castillo Grande', 93),
(962, 'Pueblo Nuevo', 93),
(963, 'Santo Domingo de Anda', 93),
(964, 'Huacrachuco', 94),
(965, 'Cholon', 94),
(966, 'San Buenaventura', 94),
(967, 'La Morada', 94),
(968, 'Santa Rosa de Alto Yanajanca', 94),
(969, 'Panao', 95),
(970, 'Chaglla', 95),
(971, 'Molino', 95),
(972, 'Umari', 95),
(973, 'Puerto Inca', 96),
(974, 'Codo del Pozuzo', 96),
(975, 'Honoria', 96),
(976, 'Tournavista', 96),
(977, 'Yuyapichis', 96),
(978, 'Jesús', 97),
(979, 'Baños', 97),
(980, 'Jivia', 97),
(981, 'Queropalca', 97),
(982, 'Rondos', 97),
(983, 'San Francisco de Asís', 97),
(984, 'San Miguel de Cauri', 97),
(985, 'Chavinillo', 98),
(986, 'Cahuac', 98),
(987, 'Chacabamba', 98),
(988, 'Aparicio Pomares', 98),
(989, 'Jacas Chico', 98),
(990, 'Obas', 98),
(991, 'Pampamarca', 98),
(992, 'Choras', 98),
(993, 'Ica', 99),
(994, 'La Tinguiña', 99),
(995, 'Los Aquijes', 99),
(996, 'Ocucaje', 99),
(997, 'Pachacutec', 99),
(998, 'Parcona', 99),
(999, 'Pueblo Nuevo', 99),
(1000, 'Salas', 99),
(1001, 'San José de Los Molinos', 99),
(1002, 'San Juan Bautista', 99),
(1003, 'Santiago', 99),
(1004, 'Subtanjalla', 99),
(1005, 'Tate', 99),
(1006, 'Yauca del Rosario', 99),
(1007, 'Chincha Alta', 100),
(1008, 'Alto Laran', 100),
(1009, 'Chavin', 100),
(1010, 'Chincha Baja', 100),
(1011, 'El Carmen', 100),
(1012, 'Grocio Prado', 100),
(1013, 'Pueblo Nuevo', 100),
(1014, 'San Juan de Yanac', 100),
(1015, 'San Pedro de Huacarpana', 100),
(1016, 'Sunampe', 100),
(1017, 'Tambo de Mora', 100),
(1018, 'Nasca', 101),
(1019, 'Changuillo', 101),
(1020, 'El Ingenio', 101),
(1021, 'Marcona', 101),
(1022, 'Vista Alegre', 101),
(1023, 'Palpa', 102),
(1024, 'Llipata', 102),
(1025, 'Río Grande', 102),
(1026, 'Santa Cruz', 102),
(1027, 'Tibillo', 102),
(1028, 'Pisco', 103),
(1029, 'Huancano', 103),
(1030, 'Humay', 103),
(1031, 'Independencia', 103),
(1032, 'Paracas', 103),
(1033, 'San Andrés', 103),
(1034, 'San Clemente', 103),
(1035, 'Tupac Amaru Inca', 103),
(1036, 'Huancayo', 104),
(1037, 'Carhuacallanga', 104),
(1038, 'Chacapampa', 104),
(1039, 'Chicche', 104),
(1040, 'Chilca', 104),
(1041, 'Chongos Alto', 104),
(1042, 'Chupuro', 104),
(1043, 'Colca', 104),
(1044, 'Cullhuas', 104),
(1045, 'El Tambo', 104),
(1046, 'Huacrapuquio', 104),
(1047, 'Hualhuas', 104),
(1048, 'Huancan', 104),
(1049, 'Huasicancha', 104),
(1050, 'Huayucachi', 104),
(1051, 'Ingenio', 104),
(1052, 'Pariahuanca', 104),
(1053, 'Pilcomayo', 104),
(1054, 'Pucara', 104),
(1055, 'Quichuay', 104),
(1056, 'Quilcas', 104),
(1057, 'San Agustín', 104),
(1058, 'San Jerónimo de Tunan', 104),
(1059, 'Saño', 104),
(1060, 'Sapallanga', 104),
(1061, 'Sicaya', 104),
(1062, 'Santo Domingo de Acobamba', 104),
(1063, 'Viques', 104),
(1064, 'Concepción', 105),
(1065, 'Aco', 105),
(1066, 'Andamarca', 105),
(1067, 'Chambara', 105),
(1068, 'Cochas', 105),
(1069, 'Comas', 105),
(1070, 'Heroínas Toledo', 105),
(1071, 'Manzanares', 105),
(1072, 'Mariscal Castilla', 105),
(1073, 'Matahuasi', 105),
(1074, 'Mito', 105),
(1075, 'Nueve de Julio', 105),
(1076, 'Orcotuna', 105),
(1077, 'San José de Quero', 105),
(1078, 'Santa Rosa de Ocopa', 105),
(1079, 'Chanchamayo', 106),
(1080, 'Perene', 106),
(1081, 'Pichanaqui', 106),
(1082, 'San Luis de Shuaro', 106),
(1083, 'San Ramón', 106),
(1084, 'Vitoc', 106),
(1085, 'Jauja', 107),
(1086, 'Acolla', 107),
(1087, 'Apata', 107),
(1088, 'Ataura', 107),
(1089, 'Canchayllo', 107),
(1090, 'Curicaca', 107),
(1091, 'El Mantaro', 107),
(1092, 'Huamali', 107),
(1093, 'Huaripampa', 107),
(1094, 'Huertas', 107),
(1095, 'Janjaillo', 107),
(1096, 'Julcán', 107),
(1097, 'Leonor Ordóñez', 107),
(1098, 'Llocllapampa', 107),
(1099, 'Marco', 107),
(1100, 'Masma', 107),
(1101, 'Masma Chicche', 107),
(1102, 'Molinos', 107),
(1103, 'Monobamba', 107),
(1104, 'Muqui', 107),
(1105, 'Muquiyauyo', 107),
(1106, 'Paca', 107),
(1107, 'Paccha', 107),
(1108, 'Pancan', 107),
(1109, 'Parco', 107),
(1110, 'Pomacancha', 107),
(1111, 'Ricran', 107),
(1112, 'San Lorenzo', 107),
(1113, 'San Pedro de Chunan', 107),
(1114, 'Sausa', 107),
(1115, 'Sincos', 107),
(1116, 'Tunan Marca', 107),
(1117, 'Yauli', 107),
(1118, 'Yauyos', 107),
(1119, 'Junin', 108),
(1120, 'Carhuamayo', 108),
(1121, 'Ondores', 108),
(1122, 'Ulcumayo', 108),
(1123, 'Satipo', 109),
(1124, 'Coviriali', 109),
(1125, 'Llaylla', 109),
(1126, 'Mazamari', 109),
(1127, 'Pampa Hermosa', 109),
(1128, 'Pangoa', 109),
(1129, 'Río Negro', 109),
(1130, 'Río Tambo', 109),
(1131, 'Vizcatan del Ene', 109),
(1132, 'Tarma', 110),
(1133, 'Acobamba', 110),
(1134, 'Huaricolca', 110),
(1135, 'Huasahuasi', 110),
(1136, 'La Unión', 110),
(1137, 'Palca', 110),
(1138, 'Palcamayo', 110),
(1139, 'San Pedro de Cajas', 110),
(1140, 'Tapo', 110),
(1141, 'La Oroya', 111),
(1142, 'Chacapalpa', 111),
(1143, 'Huay-Huay', 111),
(1144, 'Marcapomacocha', 111),
(1145, 'Morococha', 111),
(1146, 'Paccha', 111),
(1147, 'Santa Bárbara de Carhuacayan', 111),
(1148, 'Santa Rosa de Sacco', 111),
(1149, 'Suitucancha', 111),
(1150, 'Yauli', 111),
(1151, 'Chupaca', 112),
(1152, 'Ahuac', 112),
(1153, 'Chongos Bajo', 112),
(1154, 'Huachac', 112),
(1155, 'Huamancaca Chico', 112),
(1156, 'San Juan de Iscos', 112),
(1157, 'San Juan de Jarpa', 112),
(1158, 'Tres de Diciembre', 112),
(1159, 'Yanacancha', 112),
(1160, 'Trujillo', 113),
(1161, 'El Porvenir', 113),
(1162, 'Florencia de Mora', 113),
(1163, 'Huanchaco', 113),
(1164, 'La Esperanza', 113),
(1165, 'Laredo', 113),
(1166, 'Moche', 113),
(1167, 'Poroto', 113),
(1168, 'Salaverry', 113),
(1169, 'Simbal', 113),
(1170, 'Victor Larco Herrera', 113),
(1171, 'Ascope', 114),
(1172, 'Chicama', 114),
(1173, 'Chocope', 114),
(1174, 'Magdalena de Cao', 114),
(1175, 'Paijan', 114),
(1176, 'Rázuri', 114),
(1177, 'Santiago de Cao', 114),
(1178, 'Casa Grande', 114),
(1179, 'Bolívar', 115),
(1180, 'Bambamarca', 115),
(1181, 'Condormarca', 115),
(1182, 'Longotea', 115),
(1183, 'Uchumarca', 115),
(1184, 'Ucuncha', 115),
(1185, 'Chepen', 116),
(1186, 'Pacanga', 116),
(1187, 'Pueblo Nuevo', 116),
(1188, 'Julcan', 117),
(1189, 'Calamarca', 117),
(1190, 'Carabamba', 117),
(1191, 'Huaso', 117),
(1192, 'Otuzco', 118),
(1193, 'Agallpampa', 118),
(1194, 'Charat', 118),
(1195, 'Huaranchal', 118),
(1196, 'La Cuesta', 118),
(1197, 'Mache', 118),
(1198, 'Paranday', 118),
(1199, 'Salpo', 118),
(1200, 'Sinsicap', 118),
(1201, 'Usquil', 118),
(1202, 'San Pedro de Lloc', 119),
(1203, 'Guadalupe', 119),
(1204, 'Jequetepeque', 119),
(1205, 'Pacasmayo', 119),
(1206, 'San José', 119),
(1207, 'Tayabamba', 120),
(1208, 'Buldibuyo', 120),
(1209, 'Chillia', 120),
(1210, 'Huancaspata', 120),
(1211, 'Huaylillas', 120),
(1212, 'Huayo', 120),
(1213, 'Ongon', 120),
(1214, 'Parcoy', 120),
(1215, 'Pataz', 120),
(1216, 'Pias', 120),
(1217, 'Santiago de Challas', 120),
(1218, 'Taurija', 120),
(1219, 'Urpay', 120),
(1220, 'Huamachuco', 121),
(1221, 'Chugay', 121),
(1222, 'Cochorco', 121),
(1223, 'Curgos', 121),
(1224, 'Marcabal', 121),
(1225, 'Sanagoran', 121),
(1226, 'Sarin', 121),
(1227, 'Sartimbamba', 121),
(1228, 'Santiago de Chuco', 122),
(1229, 'Angasmarca', 122),
(1230, 'Cachicadan', 122),
(1231, 'Mollebamba', 122),
(1232, 'Mollepata', 122),
(1233, 'Quiruvilca', 122),
(1234, 'Santa Cruz de Chuca', 122),
(1235, 'Sitabamba', 122),
(1236, 'Cascas', 123),
(1237, 'Lucma', 123),
(1238, 'Marmot', 123),
(1239, 'Sayapullo', 123),
(1240, 'Viru', 124),
(1241, 'Chao', 124),
(1242, 'Guadalupito', 124),
(1243, 'Chiclayo', 125),
(1244, 'Chongoyape', 125),
(1245, 'Eten', 125),
(1246, 'Eten Puerto', 125),
(1247, 'José Leonardo Ortiz', 125),
(1248, 'La Victoria', 125),
(1249, 'Lagunas', 125),
(1250, 'Monsefu', 125),
(1251, 'Nueva Arica', 125),
(1252, 'Oyotun', 125),
(1253, 'Picsi', 125),
(1254, 'Pimentel', 125),
(1255, 'Reque', 125),
(1256, 'Santa Rosa', 125),
(1257, 'Saña', 125),
(1258, 'Cayalti', 125),
(1259, 'Patapo', 125),
(1260, 'Pomalca', 125),
(1261, 'Pucala', 125),
(1262, 'Tuman', 125),
(1263, 'Ferreñafe', 126),
(1264, 'Cañaris', 126),
(1265, 'Incahuasi', 126),
(1266, 'Manuel Antonio Mesones Muro', 126),
(1267, 'Pitipo', 126),
(1268, 'Pueblo Nuevo', 126),
(1269, 'Lambayeque', 127),
(1270, 'Chochope', 127),
(1271, 'Illimo', 127),
(1272, 'Jayanca', 127),
(1273, 'Mochumi', 127),
(1274, 'Morrope', 127),
(1275, 'Motupe', 127),
(1276, 'Olmos', 127),
(1277, 'Pacora', 127),
(1278, 'Salas', 127),
(1279, 'San José', 127),
(1280, 'Tucume', 127),
(1281, 'Lima', 128),
(1282, 'Ancón', 128),
(1283, 'Ate', 128),
(1284, 'Barranco', 128),
(1285, 'Breña', 128),
(1286, 'Carabayllo', 128),
(1287, 'Chaclacayo', 128),
(1288, 'Chorrillos', 128),
(1289, 'Cieneguilla', 128),
(1290, 'Comas', 128),
(1291, 'El Agustino', 128),
(1292, 'Independencia', 128),
(1293, 'Jesús María', 128),
(1294, 'La Molina', 128),
(1295, 'La Victoria', 128),
(1296, 'Lince', 128),
(1297, 'Los Olivos', 128),
(1298, 'Lurigancho', 128),
(1299, 'Lurin', 128),
(1300, 'Magdalena del Mar', 128),
(1301, 'Pueblo Libre', 128),
(1302, 'Miraflores', 128),
(1303, 'Pachacamac', 128),
(1304, 'Pucusana', 128),
(1305, 'Puente Piedra', 128),
(1306, 'Punta Hermosa', 128),
(1307, 'Punta Negra', 128),
(1308, 'Rímac', 128),
(1309, 'San Bartolo', 128),
(1310, 'San Borja', 128),
(1311, 'San Isidro', 128),
(1312, 'San Juan de Lurigancho', 128),
(1313, 'San Juan de Miraflores', 128),
(1314, 'San Luis', 128),
(1315, 'San Martín de Porres', 128),
(1316, 'San Miguel', 128),
(1317, 'Santa Anita', 128),
(1318, 'Santa María del Mar', 128),
(1319, 'Santa Rosa', 128),
(1320, 'Santiago de Surco', 128),
(1321, 'Surquillo', 128),
(1322, 'Villa El Salvador', 128),
(1323, 'Villa María del Triunfo', 128),
(1324, 'Barranca', 129),
(1325, 'Paramonga', 129),
(1326, 'Pativilca', 129),
(1327, 'Supe', 129),
(1328, 'Supe Puerto', 129),
(1329, 'Cajatambo', 130),
(1330, 'Copa', 130),
(1331, 'Gorgor', 130),
(1332, 'Huancapon', 130),
(1333, 'Manas', 130),
(1334, 'Canta', 131),
(1335, 'Arahuay', 131),
(1336, 'Huamantanga', 131),
(1337, 'Huaros', 131),
(1338, 'Lachaqui', 131),
(1339, 'San Buenaventura', 131),
(1340, 'Santa Rosa de Quives', 131),
(1341, 'San Vicente de Cañete', 132),
(1342, 'Asia', 132),
(1343, 'Calango', 132),
(1344, 'Cerro Azul', 132),
(1345, 'Chilca', 132),
(1346, 'Coayllo', 132),
(1347, 'Imperial', 132),
(1348, 'Lunahuana', 132),
(1349, 'Mala', 132),
(1350, 'Nuevo Imperial', 132),
(1351, 'Pacaran', 132),
(1352, 'Quilmana', 132),
(1353, 'San Antonio', 132),
(1354, 'San Luis', 132),
(1355, 'Santa Cruz de Flores', 132),
(1356, 'Zúñiga', 132),
(1357, 'Huaral', 133),
(1358, 'Atavillos Alto', 133),
(1359, 'Atavillos Bajo', 133),
(1360, 'Aucallama', 133),
(1361, 'Chancay', 133),
(1362, 'Ihuari', 133),
(1363, 'Lampian', 133),
(1364, 'Pacaraos', 133),
(1365, 'San Miguel de Acos', 133),
(1366, 'Santa Cruz de Andamarca', 133),
(1367, 'Sumbilca', 133),
(1368, 'Veintisiete de Noviembre', 133),
(1369, 'Matucana', 134),
(1370, 'Antioquia', 134),
(1371, 'Callahuanca', 134),
(1372, 'Carampoma', 134),
(1373, 'Chicla', 134),
(1374, 'Cuenca', 134),
(1375, 'Huachupampa', 134),
(1376, 'Huanza', 134),
(1377, 'Huarochiri', 134),
(1378, 'Lahuaytambo', 134),
(1379, 'Langa', 134),
(1380, 'Laraos', 134),
(1381, 'Mariatana', 134),
(1382, 'Ricardo Palma', 134),
(1383, 'San Andrés de Tupicocha', 134),
(1384, 'San Antonio', 134),
(1385, 'San Bartolomé', 134),
(1386, 'San Damian', 134),
(1387, 'San Juan de Iris', 134),
(1388, 'San Juan de Tantaranche', 134),
(1389, 'San Lorenzo de Quinti', 134),
(1390, 'San Mateo', 134),
(1391, 'San Mateo de Otao', 134),
(1392, 'San Pedro de Casta', 134),
(1393, 'San Pedro de Huancayre', 134),
(1394, 'Sangallaya', 134),
(1395, 'Santa Cruz de Cocachacra', 134),
(1396, 'Santa Eulalia', 134),
(1397, 'Santiago de Anchucaya', 134),
(1398, 'Santiago de Tuna', 134),
(1399, 'Santo Domingo de Los Olleros', 134),
(1400, 'Surco', 134),
(1401, 'Huacho', 135),
(1402, 'Ambar', 135),
(1403, 'Caleta de Carquin', 135),
(1404, 'Checras', 135),
(1405, 'Hualmay', 135),
(1406, 'Huaura', 135),
(1407, 'Leoncio Prado', 135),
(1408, 'Paccho', 135),
(1409, 'Santa Leonor', 135),
(1410, 'Santa María', 135),
(1411, 'Sayan', 135),
(1412, 'Vegueta', 135),
(1413, 'Oyon', 136),
(1414, 'Andajes', 136),
(1415, 'Caujul', 136),
(1416, 'Cochamarca', 136),
(1417, 'Navan', 136),
(1418, 'Pachangara', 136),
(1419, 'Yauyos', 137),
(1420, 'Alis', 137),
(1421, 'Allauca', 137),
(1422, 'Ayaviri', 137),
(1423, 'Azángaro', 137),
(1424, 'Cacra', 137),
(1425, 'Carania', 137),
(1426, 'Catahuasi', 137),
(1427, 'Chocos', 137),
(1428, 'Cochas', 137),
(1429, 'Colonia', 137),
(1430, 'Hongos', 137),
(1431, 'Huampara', 137),
(1432, 'Huancaya', 137),
(1433, 'Huangascar', 137),
(1434, 'Huantan', 137),
(1435, 'Huañec', 137),
(1436, 'Laraos', 137),
(1437, 'Lincha', 137),
(1438, 'Madean', 137),
(1439, 'Miraflores', 137),
(1440, 'Omas', 137),
(1441, 'Putinza', 137),
(1442, 'Quinches', 137),
(1443, 'Quinocay', 137),
(1444, 'San Joaquín', 137),
(1445, 'San Pedro de Pilas', 137),
(1446, 'Tanta', 137),
(1447, 'Tauripampa', 137),
(1448, 'Tomas', 137),
(1449, 'Tupe', 137),
(1450, 'Viñac', 137),
(1451, 'Vitis', 137),
(1452, 'Iquitos', 138),
(1453, 'Alto Nanay', 138),
(1454, 'Fernando Lores', 138),
(1455, 'Indiana', 138),
(1456, 'Las Amazonas', 138),
(1457, 'Mazan', 138),
(1458, 'Napo', 138),
(1459, 'Punchana', 138),
(1460, 'Torres Causana', 138),
(1461, 'Belén', 138),
(1462, 'San Juan Bautista', 138),
(1463, 'Yurimaguas', 139),
(1464, 'Balsapuerto', 139),
(1465, 'Jeberos', 139),
(1466, 'Lagunas', 139),
(1467, 'Santa Cruz', 139),
(1468, 'Teniente Cesar López Rojas', 139),
(1469, 'Nauta', 140),
(1470, 'Parinari', 140),
(1471, 'Tigre', 140),
(1472, 'Trompeteros', 140),
(1473, 'Urarinas', 140),
(1474, 'Ramón Castilla', 141),
(1475, 'Pebas', 141),
(1476, 'Yavari', 141),
(1477, 'San Pablo', 141),
(1478, 'Requena', 142),
(1479, 'Alto Tapiche', 142),
(1480, 'Capelo', 142),
(1481, 'Emilio San Martín', 142),
(1482, 'Maquia', 142),
(1483, 'Puinahua', 142),
(1484, 'Saquena', 142),
(1485, 'Soplin', 142),
(1486, 'Tapiche', 142),
(1487, 'Jenaro Herrera', 142),
(1488, 'Yaquerana', 142),
(1489, 'Contamana', 143),
(1490, 'Inahuaya', 143),
(1491, 'Padre Márquez', 143),
(1492, 'Pampa Hermosa', 143),
(1493, 'Sarayacu', 143),
(1494, 'Vargas Guerra', 143),
(1495, 'Barranca', 144),
(1496, 'Cahuapanas', 144),
(1497, 'Manseriche', 144),
(1498, 'Morona', 144),
(1499, 'Pastaza', 144),
(1500, 'Andoas', 144),
(1501, 'Putumayo', 145),
(1502, 'Rosa Panduro', 145),
(1503, 'Teniente Manuel Clavero', 145),
(1504, 'Yaguas', 145),
(1505, 'Tambopata', 146),
(1506, 'Inambari', 146),
(1507, 'Las Piedras', 146),
(1508, 'Laberinto', 146),
(1509, 'Manu', 147),
(1510, 'Fitzcarrald', 147),
(1511, 'Madre de Dios', 147),
(1512, 'Huepetuhe', 147),
(1513, 'Iñapari', 148),
(1514, 'Iberia', 148),
(1515, 'Tahuamanu', 148),
(1516, 'Moquegua', 149),
(1517, 'Carumas', 149),
(1518, 'Cuchumbaya', 149),
(1519, 'Samegua', 149),
(1520, 'San Cristóbal', 149),
(1521, 'Torata', 149),
(1522, 'Omate', 150),
(1523, 'Chojata', 150),
(1524, 'Coalaque', 150),
(1525, 'Ichuña', 150),
(1526, 'La Capilla', 150),
(1527, 'Lloque', 150),
(1528, 'Matalaque', 150),
(1529, 'Puquina', 150),
(1530, 'Quinistaquillas', 150),
(1531, 'Ubinas', 150),
(1532, 'Yunga', 150),
(1533, 'Ilo', 151),
(1534, 'El Algarrobal', 151),
(1535, 'Pacocha', 151),
(1536, 'Chaupimarca', 152),
(1537, 'Huachon', 152),
(1538, 'Huariaca', 152),
(1539, 'Huayllay', 152),
(1540, 'Ninacaca', 152),
(1541, 'Pallanchacra', 152),
(1542, 'Paucartambo', 152),
(1543, 'San Francisco de Asís de Yarusyacan', 152),
(1544, 'Simon Bolívar', 152),
(1545, 'Ticlacayan', 152),
(1546, 'Tinyahuarco', 152),
(1547, 'Vicco', 152),
(1548, 'Yanacancha', 152),
(1549, 'Yanahuanca', 153),
(1550, 'Chacayan', 153),
(1551, 'Goyllarisquizga', 153),
(1552, 'Paucar', 153),
(1553, 'San Pedro de Pillao', 153),
(1554, 'Santa Ana de Tusi', 153),
(1555, 'Tapuc', 153),
(1556, 'Vilcabamba', 153),
(1557, 'Oxapampa', 154),
(1558, 'Chontabamba', 154),
(1559, 'Huancabamba', 154),
(1560, 'Palcazu', 154),
(1561, 'Pozuzo', 154),
(1562, 'Puerto Bermúdez', 154),
(1563, 'Villa Rica', 154),
(1564, 'Constitución', 154),
(1565, 'Piura', 155),
(1566, 'Castilla', 155),
(1567, 'Catacaos', 155),
(1568, 'Cura Mori', 155),
(1569, 'El Tallan', 155),
(1570, 'La Arena', 155),
(1571, 'La Unión', 155),
(1572, 'Las Lomas', 155),
(1573, 'Tambo Grande', 155),
(1574, 'Veintiseis de Octubre', 155),
(1575, 'Ayabaca', 156),
(1576, 'Frias', 156),
(1577, 'Jilili', 156),
(1578, 'Lagunas', 156),
(1579, 'Montero', 156),
(1580, 'Pacaipampa', 156),
(1581, 'Paimas', 156),
(1582, 'Sapillica', 156),
(1583, 'Sicchez', 156),
(1584, 'Suyo', 156),
(1585, 'Huancabamba', 157),
(1586, 'Canchaque', 157),
(1587, 'El Carmen de la Frontera', 157),
(1588, 'Huarmaca', 157),
(1589, 'Lalaquiz', 157),
(1590, 'San Miguel de El Faique', 157),
(1591, 'Sondor', 157),
(1592, 'Sondorillo', 157),
(1593, 'Chulucanas', 158),
(1594, 'Buenos Aires', 158),
(1595, 'Chalaco', 158),
(1596, 'La Matanza', 158),
(1597, 'Morropon', 158),
(1598, 'Salitral', 158),
(1599, 'San Juan de Bigote', 158),
(1600, 'Santa Catalina de Mossa', 158),
(1601, 'Santo Domingo', 158),
(1602, 'Yamango', 158),
(1603, 'Paita', 159),
(1604, 'Amotape', 159),
(1605, 'Arenal', 159),
(1606, 'Colan', 159),
(1607, 'La Huaca', 159),
(1608, 'Tamarindo', 159),
(1609, 'Vichayal', 159),
(1610, 'Sullana', 160),
(1611, 'Bellavista', 160),
(1612, 'Ignacio Escudero', 160),
(1613, 'Lancones', 160),
(1614, 'Marcavelica', 160),
(1615, 'Miguel Checa', 160),
(1616, 'Querecotillo', 160),
(1617, 'Salitral', 160),
(1618, 'Pariñas', 161),
(1619, 'El Alto', 161),
(1620, 'La Brea', 161),
(1621, 'Lobitos', 161),
(1622, 'Los Organos', 161),
(1623, 'Mancora', 161),
(1624, 'Sechura', 162),
(1625, 'Bellavista de la Unión', 162),
(1626, 'Bernal', 162),
(1627, 'Cristo Nos Valga', 162),
(1628, 'Vice', 162),
(1629, 'Rinconada Llicuar', 162),
(1630, 'Puno', 163),
(1631, 'Acora', 163),
(1632, 'Amantani', 163),
(1633, 'Atuncolla', 163),
(1634, 'Capachica', 163),
(1635, 'Chucuito', 163),
(1636, 'Coata', 163),
(1637, 'Huata', 163),
(1638, 'Mañazo', 163),
(1639, 'Paucarcolla', 163),
(1640, 'Pichacani', 163),
(1641, 'Plateria', 163),
(1642, 'San Antonio', 163),
(1643, 'Tiquillaca', 163),
(1644, 'Vilque', 163),
(1645, 'Azángaro', 164),
(1646, 'Achaya', 164),
(1647, 'Arapa', 164),
(1648, 'Asillo', 164),
(1649, 'Caminaca', 164),
(1650, 'Chupa', 164),
(1651, 'José Domingo Choquehuanca', 164),
(1652, 'Muñani', 164),
(1653, 'Potoni', 164),
(1654, 'Saman', 164),
(1655, 'San Anton', 164),
(1656, 'San José', 164),
(1657, 'San Juan de Salinas', 164),
(1658, 'Santiago de Pupuja', 164),
(1659, 'Tirapata', 164),
(1660, 'Macusani', 165),
(1661, 'Ajoyani', 165),
(1662, 'Ayapata', 165),
(1663, 'Coasa', 165),
(1664, 'Corani', 165),
(1665, 'Crucero', 165),
(1666, 'Ituata', 165),
(1667, 'Ollachea', 165),
(1668, 'San Gaban', 165),
(1669, 'Usicayos', 165),
(1670, 'Juli', 166),
(1671, 'Desaguadero', 166),
(1672, 'Huacullani', 166),
(1673, 'Kelluyo', 166),
(1674, 'Pisacoma', 166),
(1675, 'Pomata', 166),
(1676, 'Zepita', 166),
(1677, 'Ilave', 167),
(1678, 'Capazo', 167),
(1679, 'Pilcuyo', 167),
(1680, 'Santa Rosa', 167),
(1681, 'Conduriri', 167),
(1682, 'Huancane', 168),
(1683, 'Cojata', 168),
(1684, 'Huatasani', 168),
(1685, 'Inchupalla', 168),
(1686, 'Pusi', 168),
(1687, 'Rosaspata', 168),
(1688, 'Taraco', 168),
(1689, 'Vilque Chico', 168),
(1690, 'Lampa', 169),
(1691, 'Cabanilla', 169),
(1692, 'Calapuja', 169),
(1693, 'Nicasio', 169),
(1694, 'Ocuviri', 169),
(1695, 'Palca', 169),
(1696, 'Paratia', 169),
(1697, 'Pucara', 169),
(1698, 'Santa Lucia', 169),
(1699, 'Vilavila', 169),
(1700, 'Ayaviri', 170),
(1701, 'Antauta', 170),
(1702, 'Cupi', 170),
(1703, 'Llalli', 170),
(1704, 'Macari', 170),
(1705, 'Nuñoa', 170),
(1706, 'Orurillo', 170),
(1707, 'Santa Rosa', 170),
(1708, 'Umachiri', 170),
(1709, 'Moho', 171),
(1710, 'Conima', 171),
(1711, 'Huayrapata', 171),
(1712, 'Tilali', 171),
(1713, 'Putina', 172),
(1714, 'Ananea', 172),
(1715, 'Pedro Vilca Apaza', 172),
(1716, 'Quilcapuncu', 172),
(1717, 'Sina', 172),
(1718, 'Juliaca', 173),
(1719, 'Cabana', 173),
(1720, 'Cabanillas', 173),
(1721, 'Caracoto', 173),
(1722, 'San Miguel', 173),
(1723, 'Sandia', 174),
(1724, 'Cuyocuyo', 174),
(1725, 'Limbani', 174),
(1726, 'Patambuco', 174),
(1727, 'Phara', 174),
(1728, 'Quiaca', 174),
(1729, 'San Juan del Oro', 174),
(1730, 'Yanahuaya', 174),
(1731, 'Alto Inambari', 174),
(1732, 'San Pedro de Putina Punco', 174),
(1733, 'Yunguyo', 175),
(1734, 'Anapia', 175),
(1735, 'Copani', 175),
(1736, 'Cuturapi', 175),
(1737, 'Ollaraya', 175),
(1738, 'Tinicachi', 175),
(1739, 'Unicachi', 175),
(1740, 'Moyobamba', 176),
(1741, 'Calzada', 176),
(1742, 'Habana', 176),
(1743, 'Jepelacio', 176),
(1744, 'Soritor', 176),
(1745, 'Yantalo', 176),
(1746, 'Bellavista', 177),
(1747, 'Alto Biavo', 177),
(1748, 'Bajo Biavo', 177),
(1749, 'Huallaga', 177),
(1750, 'San Pablo', 177),
(1751, 'San Rafael', 177),
(1752, 'San José de Sisa', 178),
(1753, 'Agua Blanca', 178),
(1754, 'San Martín', 178),
(1755, 'Santa Rosa', 178),
(1756, 'Shatoja', 178),
(1757, 'Saposoa', 179),
(1758, 'Alto Saposoa', 179),
(1759, 'El Eslabón', 179),
(1760, 'Piscoyacu', 179),
(1761, 'Sacanche', 179),
(1762, 'Tingo de Saposoa', 179),
(1763, 'Lamas', 180),
(1764, 'Alonso de Alvarado', 180),
(1765, 'Barranquita', 180),
(1766, 'Caynarachi', 180),
(1767, 'Cuñumbuqui', 180),
(1768, 'Pinto Recodo', 180),
(1769, 'Rumisapa', 180),
(1770, 'San Roque de Cumbaza', 180),
(1771, 'Shanao', 180),
(1772, 'Tabalosos', 180),
(1773, 'Zapatero', 180),
(1774, 'Juanjuí', 181),
(1775, 'Campanilla', 181),
(1776, 'Huicungo', 181),
(1777, 'Pachiza', 181),
(1778, 'Pajarillo', 181),
(1779, 'Picota', 182),
(1780, 'Buenos Aires', 182),
(1781, 'Caspisapa', 182),
(1782, 'Pilluana', 182),
(1783, 'Pucacaca', 182),
(1784, 'San Cristóbal', 182),
(1785, 'San Hilarión', 182),
(1786, 'Shamboyacu', 182),
(1787, 'Tingo de Ponasa', 182),
(1788, 'Tres Unidos', 182),
(1789, 'Rioja', 183),
(1790, 'Awajun', 183),
(1791, 'Elías Soplin Vargas', 183),
(1792, 'Nueva Cajamarca', 183),
(1793, 'Pardo Miguel', 183),
(1794, 'Posic', 183),
(1795, 'San Fernando', 183),
(1796, 'Yorongos', 183),
(1797, 'Yuracyacu', 183),
(1798, 'Tarapoto', 184),
(1799, 'Alberto Leveau', 184),
(1800, 'Cacatachi', 184),
(1801, 'Chazuta', 184),
(1802, 'Chipurana', 184),
(1803, 'El Porvenir', 184),
(1804, 'Huimbayoc', 184),
(1805, 'Juan Guerra', 184),
(1806, 'La Banda de Shilcayo', 184),
(1807, 'Morales', 184),
(1808, 'Papaplaya', 184),
(1809, 'San Antonio', 184),
(1810, 'Sauce', 184),
(1811, 'Shapaja', 184),
(1812, 'Tocache', 185),
(1813, 'Nuevo Progreso', 185),
(1814, 'Polvora', 185),
(1815, 'Shunte', 185),
(1816, 'Uchiza', 185),
(1817, 'Tacna', 186),
(1818, 'Alto de la Alianza', 186),
(1819, 'Calana', 186),
(1820, 'Ciudad Nueva', 186),
(1821, 'Inclan', 186),
(1822, 'Pachia', 186),
(1823, 'Palca', 186),
(1824, 'Pocollay', 186),
(1825, 'Sama', 186),
(1826, 'Coronel Gregorio Albarracín Lanchipa', 186),
(1827, 'La Yarada los Palos', 186),
(1828, 'Candarave', 187),
(1829, 'Cairani', 187),
(1830, 'Camilaca', 187),
(1831, 'Curibaya', 187),
(1832, 'Huanuara', 187),
(1833, 'Quilahuani', 187),
(1834, 'Locumba', 188),
(1835, 'Ilabaya', 188),
(1836, 'Ite', 188),
(1837, 'Tarata', 189),
(1838, 'Héroes Albarracín', 189),
(1839, 'Estique', 189),
(1840, 'Estique-Pampa', 189),
(1841, 'Sitajara', 189),
(1842, 'Susapaya', 189),
(1843, 'Tarucachi', 189),
(1844, 'Ticaco', 189),
(1845, 'Tumbes', 190),
(1846, 'Corrales', 190),
(1847, 'La Cruz', 190),
(1848, 'Pampas de Hospital', 190),
(1849, 'San Jacinto', 190),
(1850, 'San Juan de la Virgen', 190),
(1851, 'Zorritos', 191),
(1852, 'Casitas', 191),
(1853, 'Canoas de Punta Sal', 191),
(1854, 'Zarumilla', 192),
(1855, 'Aguas Verdes', 192),
(1856, 'Matapalo', 192),
(1857, 'Papayal', 192),
(1858, 'Calleria', 193),
(1859, 'Campoverde', 193),
(1860, 'Iparia', 193),
(1861, 'Masisea', 193),
(1862, 'Yarinacocha', 193),
(1863, 'Nueva Requena', 193),
(1864, 'Manantay', 193),
(1865, 'Raymondi', 194),
(1866, 'Sepahua', 194),
(1867, 'Tahuania', 194),
(1868, 'Yurua', 194),
(1869, 'Padre Abad', 195),
(1870, 'Irazola', 195),
(1871, 'Curimana', 195),
(1872, 'Neshuya', 195),
(1873, 'Alexander Von Humboldt', 195),
(1874, 'Purus', 196),
(1875, 'No Asignado', 197);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos_requerimiento`
--

CREATE TABLE `documentos_requerimiento` (
  `iddocumento` int(11) NOT NULL,
  `idrequerimiento` int(11) DEFAULT NULL,
  `idtipodoc` int(11) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `fecha` date DEFAULT current_timestamp(),
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `documentos_requerimiento`
--

INSERT INTO `documentos_requerimiento` (`iddocumento`, `idrequerimiento`, `idtipodoc`, `nombre`, `fecha`, `estado`) VALUES
(1, 17, 1, 'ORDEN_COMPRA1990', '2025-08-06', '0'),
(2, 16, 1, 'ORDEN_COMPRA9921', '2025-08-06', '1'),
(3, 17, 2, 'cv_harold_2024.pdf', '2025-08-06', '0'),
(4, 17, 3, 'cotizacion (1)', '2025-08-06', '0'),
(5, 17, 3, 'report (2)', '2025-08-06', '0'),
(6, 17, 1, 'orden-compra-90', '2025-08-06', '0'),
(7, 17, 1, 'INFORME 01-0067 - SERV. PRENSADO DE MANGUERAS HIDRAULICAS -  BETA (1)', '2025-08-06', '0'),
(8, 17, 1, 'INFORME 01-0067 - SERV. PRENSADO DE MANGUERAS HIDRAULICAS -  BETA (1)', '2025-08-06', '0'),
(9, 17, 1, 'Harold CV', '2025-08-06', '0'),
(10, 15, 3, 'PROGRAMACION DE CLASES Y CRONOGRAMA DE ENTREGABLES 35535', '2025-08-07', '3'),
(11, 15, 4, 'haroldcvactualizado', '2025-08-07', '1'),
(12, 15, 2, 'Reporte', '2025-08-07', '0'),
(13, 15, 2, 'orden-compra-38', '2025-08-07', '1'),
(14, 17, 2, 'orden-compra-90', '2025-08-08', '1'),
(15, 17, 4, 'verificqdo-10', '2025-08-08', '0'),
(16, 17, 4, 'verificqdo-10', '2025-08-08', '0'),
(17, 17, 4, 'orden-compra-38', '2025-08-08', '1'),
(18, 14, 4, 'orden-compra-90', '2025-08-08', '0'),
(19, 14, 4, 'INFORME 01-0067 - SERV. PRENSADO DE MANGUERAS HIDRAULICAS -  BETA (1)', '2025-08-08', '1'),
(20, 18, 1, 'orden-compra-90', '2025-08-08', '1'),
(21, 18, 2, 'orden-compra-38', '2025-08-08', '1'),
(22, 18, 4, 'report', '2025-08-08', '1'),
(23, 13, 4, 'orden-compra-39', '2025-08-08', '1'),
(24, 19, 1, 'orden-compra-90', '2025-08-08', '0'),
(25, 19, 2, 'report', '2025-08-08', '1'),
(26, 19, 4, 'orden-compra-38', '2025-08-08', '0'),
(27, 19, 4, 'orden-compra-39', '2025-08-08', '1'),
(28, 12, 1, 'orden-compra-90', '2025-08-08', '1'),
(29, 12, 1, 'orden-compra-38', '2025-08-08', '1'),
(30, 12, 4, 'orden-compra-39', '2025-08-08', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `idempresa` int(11) NOT NULL,
  `razonSocial` varchar(70) NOT NULL,
  `ruc` char(11) NOT NULL,
  `direccion` varchar(60) DEFAULT NULL,
  `iddistrito` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`idempresa`, `razonSocial`, `ruc`, `direccion`, `iddistrito`) VALUES
(1, 'SOLUCIONES TECNOLOGICAS INDUSTRIALES FALCOT S.A.C.', '20610562176', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 1010);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas_cliente`
--

CREATE TABLE `empresas_cliente` (
  `idempresacliente` int(11) NOT NULL,
  `razonSocial` varchar(70) NOT NULL,
  `nroDocumento` varchar(12) NOT NULL,
  `direccion` varchar(60) NOT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `celular` char(10) DEFAULT NULL,
  `contacto` varchar(40) DEFAULT NULL,
  `iddistrito` int(11) NOT NULL,
  `ubigeo` char(12) DEFAULT NULL,
  `actividadEconomica` varchar(70) DEFAULT NULL,
  `telefono` char(12) DEFAULT NULL,
  `estado` char(1) DEFAULT '1',
  `fechaInicio` date DEFAULT curdate(),
  `fechaEdicion` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `empresas_cliente`
--

INSERT INTO `empresas_cliente` (`idempresacliente`, `razonSocial`, `nroDocumento`, `direccion`, `correo`, `celular`, `contacto`, `iddistrito`, `ubigeo`, `actividadEconomica`, `telefono`, `estado`, `fechaInicio`, `fechaEdicion`, `fechaFin`) VALUES
(7, 'REPUESTO DISEL \"DOMINGUITA\"', '10218473062', 'PRINC. CAR. PANAMERICANA SUR KM. 197 N° 203-02 ', 'nohay@gmail.com', '995224672', 'RUPUESTO DIESEL DOMINGUITA', 1007, '', NULL, '1724112414', '1', '2024-07-24', NULL, NULL),
(8, 'RESORTES INDUSTRIALES PERU S.A.,C', '20607351032', 'AV. CALCA NRO. 290 COO. VEINTISIETE DE ABRIL - LIMA ATE', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', 'RESORTES INDUSTRIALES', 1283, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(9, 'MULTIPERNOS FERCOSERV', '20606429992', 'AV. JOSE FAUSTINO CARRION 319', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(10, 'COMERCIAL CONISLLA', '17194141165', '565 URB. VICTOR ANDRES BELAUNDE', 'correo@gmail.com', '999999999', 'JUAN', 1013, '', NULL, '7612431', '1', '2024-07-24', NULL, NULL),
(11, 'CORPORACION RODASUR S.A.C', '20144961146', 'AV. AGUSTIN DE LA  ROSA TORO 155-163 LIMA SAN LUIS ', '', '975288557', 'ALCIDES PORTOCARRERO', 1314, '', NULL, '4125900', '1', '2024-07-24', '2024-08-05', NULL),
(12, 'MAK GRAF S.A.C', '20605942670', 'AV. REPUBLICA DE ARGENTINA 144 URB. LIMA INDUSTRIAL  ', '', '', '', 1281, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(13, 'COMERCIAL JUANMARC S.A.C', '20601662435', 'AV. PANAMERICANA SUR NRO. 301', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(14, 'FERRECHINCHA CENTER E.I.R.L', '20603065388', 'PANAM. SUR KM. 199 N°362', '', '922842303', '970789567', 1007, '', NULL, '056-626156', '1', '2024-07-24', NULL, NULL),
(15, 'COMERCIAL ACEROS ALATA E.I.R.L', '20609141477', 'CAR. PANAMERICANA SUR 197 COSTADO HOSTAL IMPERIO', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(16, 'RODAMIENTO SALAS ', '20338621214', 'AV. TOMAS VALLE 2951 URB. EL CONDOR PROV. CONST. DEL CALLAO', 'VENTAS@RODAMIENTOSALASRL.COM', '951336926', 'ALFONSO SALAS', 690, '', NULL, '5756050', '1', '2024-07-24', NULL, NULL),
(17, 'MULTIPLE SOLUTIONS GROUP S.A.C', '20601130981', 'A.H. NUEVA ESPERANZA MZA. M LOTE. 04', '', '', '', 1290, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(18, 'AJUSTE PERFECTO S.A.C', '2050024966', 'CALLE OMICRON 340- 348 IND. Y COMERCIO - CALLAO', '', '946557616', 'AJUSTE PERFECTO ', 690, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(19, 'ALPOBRON E.I.R.L.', '20612411019', 'AV. GUILLERMO DANSEY 918 COO. NIÑO JESUS INT. 24A1', '', '', '', 1281, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(20, ' OXIGENO VENTA ALQUILER Y SERVICIOS DEL SUR E.I.R.L. ', '20520545833', 'CAL. LOS FAISANES NRO. 171 INT. 14B URB. LA CAMPIÑA', '', '998184118', '981180739', 1288, '', NULL, '735-0164', '1', '2024-07-24', NULL, NULL),
(21, 'FRECT S.A.C.', '20605446362', 'CAL. ANDRES RAZURI 150 ENTRE AV BENAVIDES Y SANTOS NAGARO', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(22, 'VENTAS Y SERVICIOS VELASQUEZ S.R.L.', '20534720361', 'CARRET. PANAMERICANA SUR KM. 199 NRO 304', 'ventasyserviciosvelasquez@hotmail.com', '994156903', 'Nataly Bravo', 1007, '', NULL, '056-264723', '1', '2024-07-24', NULL, NULL),
(23, 'ALCANTARA NAPA MARIA DEL ROSARIO', '10728425577', 'AV. SANTA RITA C.P. CONDORILLO BAJO MZA. S LOTE. 27', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(24, 'IMPORT & EXPORT YAZZU S.R.L.', '20611915820', 'MZA. F LOTE. 4 GRU. 8 SECTOR 6', '', '', '', 1322, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(25, 'COBET S.A.C.', '20534466049', 'CAL. ARICA 106 INT. 01 A MEDIA CDRA DE JAKSA', '', '', '', 1007, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(26, 'PERNOS Y PERNOS INOX F 6 G S.A.C.', '20518543572', 'CALLE LOS ECONOMISTAS MZ.F3 LOTE 4 URB. RAMÓN CASTILLA', 'pernosinoxfyg@hormail.es', '999007410', '', 1312, '', NULL, '013873150', '1', '2024-07-24', NULL, NULL),
(28, 'AGRO INDUSTRIAS PERUANAS S A', '20100728916', 'AV. SAN LUIS 2252 A 1.5 CDRAS. DE SAN BORJA NORTE', '', '', '', 1310, '', NULL, '', '1', '2024-07-24', NULL, NULL),
(29, 'RESORTES PERU A & J E.I.R.L.', '20609357798', 'PQ. MARIA PARADO DE BELLIDO MZA. K LOTE 6 ', '', '954119050', '967192427', 1283, '150103', NULL, '', '1', '2024-07-30', NULL, NULL),
(30, 'TECNOLOGIA INDUSTRIAL PERUANA SOCIEDAD ANONIMA CERRADA - TECIP S.A.C.', '20543728927', 'AV. LOS FRUTALES NRO 486 URB. INDUSTRIAL DEL ARTESANO ', 'ventas@tecip.com.pe', '986650380', '', 1283, '150103', NULL, '014947998', '1', '2024-08-07', NULL, NULL),
(31, 'CUSTOM SEALS S.A.C', '20544511301', 'AV. MARISCAL OSCAR R. BENAVID NRO 655 URB. LIMA INDUSTRIAL ', '', '', '', 1281, '150101', NULL, '012229713', '1', '2024-08-09', NULL, NULL),
(32, 'DISTRIBUIDORA FERRETERA TRIPLE A E.I.R.L.', '20553147990', 'PJ. CRNL. MIGUEL ZAMORA NRO 127 ', 'triplea 230@hotmail.com', '983412971', '', 1281, '150101', NULL, '', '1', '2024-08-28', NULL, NULL),
(33, 'GRUPO SAFETY DE LA CRUZ S.A.C.', '20611404167', 'AV. REPUBLICA DE ARGENTINA NRO 530 URB. LIMA INDUSTRIAL ', 'ventasgrupodelacruz@gmail.com', '902755571', '906164603', 1281, '150101', NULL, '940437964', '1', '2024-08-29', NULL, NULL),
(34, 'FLOREZ CHOQUE ARIANA ANDREA', '10759991465', 'PJ. CRNL. MIGUEL ZAMORA NRO 127', '', '', '', 1281, '150101', NULL, '', '1', '2024-08-29', NULL, NULL),
(35, 'CIA CAMPORSAL S.A.', '20415721677', 'AV. GUILLERMO DANSEY NRO 471 INT. B ', '', '', '', 1281, '150101', NULL, '', '1', '2024-09-06', NULL, NULL),
(36, 'IMPORTADORA ACONCAGUA SOCIEDAD ANONIMA CERRADA - IMPORTADORA ACONCAGUA', '20565909275', 'AV. JULIO CESAR TELLO NRO 693 INT. 201 ', 'www.impac.com.pe', '', '', 1311, '150131', NULL, '056597251', '1', '2024-09-06', NULL, NULL),
(37, 'METAL TRADING S & C E.I.R.L.', '20613037242', 'AV. REPUBLICA DE ARGENTINA NRO 639 INT. C075 URB. LIMA INDUS', '', '', '', 1281, '150101', NULL, '', '1', '2024-09-20', NULL, NULL),
(38, 'NOVAELEC SAC', '20602329233', 'AV. CAMINOS DEL INCA NRO 1457 URB. LAS GARDENIAS ', '', '', '', 1320, '150140', NULL, '', '1', '2024-09-23', NULL, NULL),
(39, 'NOVA LITE S.A.C.', '20612067709', 'CAL. DIALECTICA NRO 139 URB. JOSE CARLOS MARIATEGUI ', '', '', '', 346, '040112', NULL, '', '1', '2024-09-23', NULL, NULL),
(40, 'VID AGRO S.A.C.', '20502630378', 'AV. INGENIEROS NORTE NRO 251 URB. LA MERCED ', '', '', '', 1283, '150103', NULL, '', '1', '2024-10-04', '2024-10-04', NULL),
(41, 'COMPANY TOOLS PERU S.A.C.', '20601110351', 'AV. MARISCAL OSCAR R. BENAVID NRO 578 INT. 101A URB. LIMA IN', 'ventas2@companytoolsperu.com', '', '', 1281, '150101', NULL, '977678683', '1', '2024-10-11', NULL, NULL),
(42, 'IMPORTACIONES INDUSTRIALES BENDEZU E.I.R.L.', '20600386108', 'AV. MARISCAL OSCAR R. BENAVID NRO 578 INT. 101 URB. LIMA IND', '', '970390185', '', 1281, '150101', NULL, '017947169', '1', '2024-10-17', NULL, NULL),
(43, 'EVANS IQ INDUSTRIAS QUIMICAS S.A.C.', '20607170348', 'AV. ATREM MZA. A LOTE 5 ASC. INDUSTRIAS UNIDAS ', 'ventas@evansiq.com', '924862435', 'alexander e.', 1286, '150106', NULL, '017483818', '1', '2024-10-18', NULL, NULL),
(44, 'IPM GLOBAL IMPORT S.A.', '20605657452', 'AV. MARISCAL OSCAR R. BENAVID NRO 1471 URB. CHACRA RIOS NORT', 'VENTAS@ipm-gi.com', '960943561', '', 1281, '150101', NULL, '', '1', '2024-10-30', NULL, NULL),
(45, 'IMPORTADORA Y DISTRIBUIDORA DE RETENES RODAMIENTOS Y AFINES SOCIEDAD A', '20432420834', 'AV. RAMON CARCAMO NRO 506 ', '', '', '', 1281, '150101', NULL, '', '1', '2024-11-05', NULL, NULL),
(46, 'NE & AL FERREIMPORT S.A.C.', '20611084120', 'AV. GUILLERMO DANSEY NRO 828 INT. E105 URB. LIMA INDUSTRIAL ', 'ventas.neal@gmail.com', '906725416', '', 1281, '150101', NULL, '', '1', '2024-12-12', NULL, NULL),
(47, 'TECNIGLOBAL S.A.C', '20392696513', 'JR. LAS MERCEDES NRO 1140 URB. ZARATE ', 'ventas@tecniglobal.com', '993005195', '', 1312, '150132', NULL, '', '1', '2025-02-05', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_compra`
--

CREATE TABLE `orden_compra` (
  `idordencompra` int(11) NOT NULL,
  `iddetalleusuario` int(11) NOT NULL,
  `idcliente` int(11) NOT NULL,
  `moneda` varchar(10) NOT NULL,
  `fechaCreacion` date DEFAULT curdate(),
  `descuento` decimal(10,2) DEFAULT NULL,
  `grupoCompra` varchar(15) DEFAULT NULL,
  `destino` varchar(60) DEFAULT NULL,
  `observaciones` varchar(60) DEFAULT NULL,
  `condicionPago` varchar(40) DEFAULT NULL,
  `original` varchar(50) DEFAULT NULL,
  `telefono` char(12) DEFAULT NULL,
  `contacto` varchar(40) DEFAULT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `celular` char(9) DEFAULT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `orden_compra`
--

INSERT INTO `orden_compra` (`idordencompra`, `iddetalleusuario`, `idcliente`, `moneda`, `fechaCreacion`, `descuento`, `grupoCompra`, `destino`, `observaciones`, `condicionPago`, `original`, `telefono`, `contacto`, `correo`, `celular`, `estado`) VALUES
(1, 3, 20, 'soles', '2024-07-22', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '0'),
(2, 3, 20, 'soles', '2024-07-22', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(3, 2, 12, 'soles', '2024-07-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(4, 3, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '0'),
(5, 3, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '0'),
(6, 3, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '0'),
(7, 3, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '0'),
(8, 1, 8, 'soles', '2024-07-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '0'),
(9, 2, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '2'),
(10, 1, 10, 'soles', '2024-06-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '7612431', 'JUAN', 'correo@gmail.com', '999999999', '0'),
(11, 5, 29, 'soles', '2024-07-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '967192427', '', '954119050', '2'),
(12, 3, 30, 'soles', '2024-08-06', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '014947998', '', 'ventas@tecip.com.pe', '986650380', '2'),
(13, 1, 7, 'soles', '2024-08-07', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '1724112414', 'RUPUESTO DIESEL DOMINGUITA', 'nohay@gmail.com', '995224672', '0'),
(14, 3, 22, 'soles', '2024-08-07', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '056-264723', '', 'ventasyserviciosvelasquez@hotmail.com', '', '2'),
(15, 5, 20, 'soles', '2024-08-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(16, 5, 20, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(17, 5, 31, 'soles', '2024-08-08', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '012229713', '', '', '', '2'),
(18, 3, 20, 'soles', '2024-08-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(19, 3, 20, 'soles', '2024-08-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR LUNES 12 COMO ATENCION PARA DESPACHO', '7 días', NULL, '735-0164', '981180739', '', '998184118', '0'),
(20, 3, 20, 'soles', '2024-08-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR EL LUNES 12 COMO ATENCION PARA DESPACHO', '7 días', NULL, '735-0164', '981180739', '', '998184118', '0'),
(21, 5, 8, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR DOMINGO 11 COMO ATENCION PARA DESPACHO', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '2'),
(22, 5, 8, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR DOMINGO 11 COMO ATENCION PARA DESPACHO ', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '0'),
(23, 2, 20, 'soles', '2024-08-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR LUNES 12 COMO ATENCION PARA DESPACHO', '7 días', NULL, '735-0164', '981180739', '', '998184118', '2'),
(24, 2, 8, 'soles', '2024-08-08', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '0'),
(25, 2, 8, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR DOMINGO 11 COMO ATENCION PARA DESPACHO ', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '0'),
(26, 2, 8, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '0'),
(27, 1, 7, 'soles', '2023-06-27', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '7 días', NULL, '1724112414', 'RUPUESTO DIESEL DOMINGUITA', 'nohay@gmail.com', '995224672', '0'),
(28, 1, 7, 'soles', '2023-08-15', '100.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '1724112414', 'RUPUESTO DIESEL DOMINGUITA', 'nohay@gmail.com', '995224672', '0'),
(29, 2, 8, 'soles', '2024-08-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '2'),
(30, 1, 14, 'soles', '2023-02-01', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'NADA MALO', 'contado', NULL, '056-626156', '970789567', '', '922842303', '0'),
(31, 1, 14, 'dolares', '2024-06-05', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'NADA MALO', '30 días', NULL, '056-626156', '970789567', '', '922842303', '0'),
(32, 2, 31, 'soles', '2024-08-08', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '012229713', '', '', '', '2'),
(33, 5, 8, 'soles', '2024-08-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', 'RESORTES INDUSTRIALES', 'VENTAS1RESORTES@HOTMAIL.COM', '960945137', '2'),
(34, 5, 20, 'soles', '2024-08-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'CONSIDERAR EL 21/08 COMO ATENCION PARA DESPACHO', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(35, 3, 19, 'soles', '2024-08-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(36, 3, 19, 'soles', '2024-08-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'EL pago se realizara el día 30 de agosto', 'contado', NULL, '', '', '', '', '0'),
(37, 3, 19, 'soles', '2024-08-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', 'El pago se realizara el día 30 de Agosto', 'contado', NULL, '', '', '', '', '2'),
(38, 5, 11, 'soles', '2024-08-27', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '4125900', 'ALCIDES PORTOCARRERO', '', '975288557', '2'),
(39, 3, 12, 'soles', '2024-08-27', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(40, 2, 32, 'soles', '2024-08-28', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', 'triplea 230@hotmail.com', '983412971', '2'),
(41, 3, 33, 'soles', '2024-08-28', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(42, 3, 34, 'soles', '2024-08-29', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(43, 3, 11, 'soles', '2024-09-03', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '4125900', 'ALCIDES PORTOCARRERO', '', '975288557', '2'),
(44, 3, 20, 'soles', '2024-09-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '0'),
(45, 3, 20, 'soles', '2024-09-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(46, 5, 33, 'soles', '2024-09-05', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(47, 3, 35, 'soles', '2024-09-06', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(48, 3, 33, 'soles', '2024-09-06', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(49, 2, 36, 'soles', '2024-09-06', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '7 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(50, 2, 36, 'soles', '2024-09-06', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '7 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(51, 3, 20, 'soles', '2024-09-09', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(52, 5, 20, 'soles', '2024-09-16', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(53, 2, 33, 'soles', '2024-09-19', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(54, 2, 37, 'soles', '2024-09-20', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(55, 2, 38, 'soles', '2024-09-23', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '0'),
(56, 2, 39, 'soles', '2024-09-23', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '0'),
(57, 2, 39, 'soles', '2024-09-23', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(58, 2, 12, 'soles', '2024-09-24', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '940409981', '2'),
(59, 2, 12, 'soles', '2024-09-27', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '940409981', '2'),
(60, 2, 40, 'soles', '2024-10-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '0'),
(61, 2, 40, 'dolares', '2024-10-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(62, 2, 16, 'soles', '2024-10-05', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '5756050', 'ALFONSO SALAS', 'VENTAS@RODAMIENTOSALASRL.COM', '951336926', '2'),
(63, 2, 37, 'soles', '2024-10-10', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '902463381', '0'),
(64, 2, 37, 'soles', '2024-10-10', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '902463381', '2'),
(65, 2, 33, 'soles', '2024-10-11', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(66, 2, 41, 'soles', '2024-10-11', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '977678683', '', 'ventas2@companytoolsperu.com', '', '2'),
(67, 2, 42, 'soles', '2024-10-17', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '017947169', '', '', '970390185', '2'),
(68, 2, 20, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '0'),
(69, 2, 20, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '0'),
(70, 2, 20, 'soles', '2024-10-17', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(71, 2, 43, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '017483818', 'alexander e.', 'ventas@evansiq.com', '924862435', '2'),
(72, 2, 33, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(73, 2, 16, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '5756050', 'ALFONSO SALAS', 'VENTAS@RODAMIENTOSALASRL.COM', '951336926', '0'),
(74, 2, 16, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '5756050', 'ALFONSO SALAS', 'VENTAS@RODAMIENTOSALASRL.COM', '951336926', '2'),
(75, 2, 36, 'soles', '2024-10-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(76, 2, 36, 'soles', '2024-10-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(77, 2, 44, 'soles', '2024-10-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', 'VENTAS@ipm-gi.com', '960943561', '2'),
(78, 5, 45, 'soles', '2024-11-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', '', '', '2'),
(79, 5, 42, 'dolares', '2024-11-14', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '017947169', '', '', '970390185', '2'),
(80, 5, 36, 'soles', '2024-11-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(81, 5, 36, 'soles', '2024-11-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(82, 5, 36, 'soles', '2024-11-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(83, 5, 36, 'soles', '2024-11-18', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(84, 2, 20, 'soles', '2024-11-19', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '735-0164', '981180739', '', '998184118', '2'),
(85, 5, 44, 'soles', '2024-11-21', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', 'VENTAS@ipm-gi.com', '960943561', '2'),
(86, 2, 42, 'dolares', '2024-11-22', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '017947169', '', '', '970390185', '2'),
(87, 1, 42, 'dolares', '2024-11-22', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '017947169', '', '', '970390185', '2'),
(88, 1, 42, 'dolares', '2024-11-22', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '017947169', '', '', '970390185', '2'),
(89, 2, 46, 'soles', '2024-12-12', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '', '', 'ventas.neal@gmail.com', '906725416', '2'),
(90, 2, 20, 'soles', '2024-12-20', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '735-0164', '981180739', '', '998184118', '2'),
(91, 2, 20, 'soles', '2025-01-13', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '735-0164', '981180739', '', '998184118', '2'),
(92, 2, 11, 'soles', '2025-01-28', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '4125900', 'ALCIDES PORTOCARRERO', '', '975288557', '2'),
(93, 2, 20, 'soles', '2025-01-29', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '735-0164', '981180739', '', '998184118', '2'),
(94, 2, 36, 'soles', '2025-01-30', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(95, 2, 36, 'dolares', '2025-02-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '056597251', '', 'www.impac.com.pe', '', '0'),
(96, 2, 36, 'soles', '2025-02-04', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '056597251', '', 'www.impac.com.pe', '', '2'),
(97, 2, 47, 'dolares', '2025-02-05', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '', '', 'ventas@tecniglobal.com', '993005195', '2'),
(98, 2, 41, 'soles', '2025-02-12', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '977678683', '', 'ventas2@companytoolsperu.com', '', '2'),
(99, 2, 41, 'soles', '2025-02-12', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '977678683', '', 'ventas2@companytoolsperu.com', '', '2'),
(100, 2, 42, 'soles', '2025-02-13', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '30 días', NULL, '017947169', '', '', '970390185', '2'),
(101, 2, 33, 'soles', '2025-02-14', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', 'contado', NULL, '940437964', '906164603', 'ventasgrupodelacruz@gmail.com', '902755571', '2'),
(102, 7, 22, 'soles', '2025-02-20', '0.00', '', 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA', '', '15 días', NULL, '056-264723', 'Nataly Bravo', 'ventasyserviciosvelasquez@hotmail.com', '994156903', '2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

CREATE TABLE `provincias` (
  `idprovincia` int(11) NOT NULL,
  `provincia` varchar(60) NOT NULL,
  `iddepartamento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `provincias`
--

INSERT INTO `provincias` (`idprovincia`, `provincia`, `iddepartamento`) VALUES
(1, 'Chachapoyas', 1),
(2, 'Bagua', 1),
(3, 'Bongará', 1),
(4, 'Condorcanqui', 1),
(5, 'Luya', 1),
(6, 'Rodríguez de Mendoza', 1),
(7, 'Utcubamba', 1),
(8, 'Huaraz', 2),
(9, 'Aija', 2),
(10, 'Antonio Raymondi', 2),
(11, 'Asunción', 2),
(12, 'Bolognesi', 2),
(13, 'Carhuaz', 2),
(14, 'Carlos Fermín Fitzcarrald', 2),
(15, 'Casma', 2),
(16, 'Corongo', 2),
(17, 'Huari', 2),
(18, 'Huarmey', 2),
(19, 'Huaylas', 2),
(20, 'Mariscal Luzuriaga', 2),
(21, 'Ocros', 2),
(22, 'Pallasca', 2),
(23, 'Pomabamba', 2),
(24, 'Recuay', 2),
(25, 'Santa', 2),
(26, 'Sihuas', 2),
(27, 'Yungay', 2),
(28, 'Abancay', 3),
(29, 'Andahuaylas', 3),
(30, 'Antabamba', 3),
(31, 'Aymaraes', 3),
(32, 'Cotabambas', 3),
(33, 'Chincheros', 3),
(34, 'Grau', 3),
(35, 'Arequipa', 4),
(36, 'Camaná', 4),
(37, 'Caravelí', 4),
(38, 'Castilla', 4),
(39, 'Caylloma', 4),
(40, 'Condesuyos', 4),
(41, 'Islay', 4),
(42, 'La Uniòn', 4),
(43, 'Huamanga', 5),
(44, 'Cangallo', 5),
(45, 'Huanca Sancos', 5),
(46, 'Huanta', 5),
(47, 'La Mar', 5),
(48, 'Lucanas', 5),
(49, 'Parinacochas', 5),
(50, 'Pàucar del Sara Sara', 5),
(51, 'Sucre', 5),
(52, 'Víctor Fajardo', 5),
(53, 'Vilcas Huamán', 5),
(54, 'Cajamarca', 6),
(55, 'Cajabamba', 6),
(56, 'Celendín', 6),
(57, 'Chota', 6),
(58, 'Contumazá', 6),
(59, 'Cutervo', 6),
(60, 'Hualgayoc', 6),
(61, 'Jaén', 6),
(62, 'San Ignacio', 6),
(63, 'San Marcos', 6),
(64, 'San Miguel', 6),
(65, 'San Pablo', 6),
(66, 'Santa Cruz', 6),
(67, 'Prov. Const. del Callao', 7),
(68, 'Cusco', 8),
(69, 'Acomayo', 8),
(70, 'Anta', 8),
(71, 'Calca', 8),
(72, 'Canas', 8),
(73, 'Canchis', 8),
(74, 'Chumbivilcas', 8),
(75, 'Espinar', 8),
(76, 'La Convención', 8),
(77, 'Paruro', 8),
(78, 'Paucartambo', 8),
(79, 'Quispicanchi', 8),
(80, 'Urubamba', 8),
(81, 'Huancavelica', 9),
(82, 'Acobamba', 9),
(83, 'Angaraes', 9),
(84, 'Castrovirreyna', 9),
(85, 'Churcampa', 9),
(86, 'Huaytará', 9),
(87, 'Tayacaja', 9),
(88, 'Huánuco', 10),
(89, 'Ambo', 10),
(90, 'Dos de Mayo', 10),
(91, 'Huacaybamba', 10),
(92, 'Huamalíes', 10),
(93, 'Leoncio Prado', 10),
(94, 'Marañón', 10),
(95, 'Pachitea', 10),
(96, 'Puerto Inca', 10),
(97, 'Lauricocha ', 10),
(98, 'Yarowilca ', 10),
(99, 'Ica ', 11),
(100, 'Chincha ', 11),
(101, 'Nasca ', 11),
(102, 'Palpa ', 11),
(103, 'Pisco ', 11),
(104, 'Huancayo ', 12),
(105, 'Concepción ', 12),
(106, 'Chanchamayo ', 12),
(107, 'Jauja ', 12),
(108, 'Junín ', 12),
(109, 'Satipo ', 12),
(110, 'Tarma ', 12),
(111, 'Yauli ', 12),
(112, 'Chupaca ', 12),
(113, 'Trujillo ', 13),
(114, 'Ascope ', 13),
(115, 'Bolívar ', 13),
(116, 'Chepén ', 13),
(117, 'Julcán ', 13),
(118, 'Otuzco ', 13),
(119, 'Pacasmayo ', 13),
(120, 'Pataz ', 13),
(121, 'Sánchez Carrión ', 13),
(122, 'Santiago de Chuco ', 13),
(123, 'Gran Chimú ', 13),
(124, 'Virú ', 13),
(125, 'Chiclayo ', 14),
(126, 'Ferreñafe ', 14),
(127, 'Lambayeque ', 14),
(128, 'Lima ', 15),
(129, 'Barranca ', 15),
(130, 'Cajatambo ', 15),
(131, 'Canta ', 15),
(132, 'Cañete ', 15),
(133, 'Huaral ', 15),
(134, 'Huarochirí ', 15),
(135, 'Huaura ', 15),
(136, 'Oyón ', 15),
(137, 'Yauyos ', 15),
(138, 'Maynas ', 16),
(139, 'Alto Amazonas ', 16),
(140, 'Loreto ', 16),
(141, 'Mariscal Ramón Castilla ', 16),
(142, 'Requena ', 16),
(143, 'Ucayali ', 16),
(144, 'Datem del Marañón ', 16),
(145, 'Putumayo', 16),
(146, 'Tambopata ', 17),
(147, 'Manu ', 17),
(148, 'Tahuamanu ', 17),
(149, 'Mariscal Nieto ', 18),
(150, 'General Sánchez Cerro ', 18),
(151, 'Ilo ', 18),
(152, 'Pasco ', 19),
(153, 'Daniel Alcides Carrión ', 19),
(154, 'Oxapampa ', 19),
(155, 'Piura ', 20),
(156, 'Ayabaca ', 20),
(157, 'Huancabamba ', 20),
(158, 'Morropón ', 20),
(159, 'Paita ', 20),
(160, 'Sullana ', 20),
(161, 'Talara ', 20),
(162, 'Sechura ', 20),
(163, 'Puno ', 21),
(164, 'Azángaro ', 21),
(165, 'Carabaya ', 21),
(166, 'Chucuito ', 21),
(167, 'El Collao ', 21),
(168, 'Huancané ', 21),
(169, 'Lampa ', 21),
(170, 'Melgar ', 21),
(171, 'Moho ', 21),
(172, 'San Antonio de Putina ', 21),
(173, 'San Román ', 21),
(174, 'Sandia ', 21),
(175, 'Yunguyo ', 21),
(176, 'Moyobamba ', 22),
(177, 'Bellavista ', 22),
(178, 'El Dorado ', 22),
(179, 'Huallaga ', 22),
(180, 'Lamas ', 22),
(181, 'Mariscal Cáceres ', 22),
(182, 'Picota ', 22),
(183, 'Rioja ', 22),
(184, 'San Martín ', 22),
(185, 'Tocache ', 22),
(186, 'Tacna ', 23),
(187, 'Candarave ', 23),
(188, 'Jorge Basadre ', 23),
(189, 'Tarata ', 23),
(190, 'Tumbes ', 24),
(191, 'Contralmirante Villar ', 24),
(192, 'Zarumilla ', 24),
(193, 'Coronel Portillo ', 25),
(194, 'Atalaya ', 25),
(195, 'Padre Abad ', 25),
(196, 'Purús', 25),
(197, 'No Asignado', 26);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requerimientos`
--

CREATE TABLE `requerimientos` (
  `idrequerimiento` int(11) NOT NULL,
  `idusuario` int(11) DEFAULT NULL,
  `motivo` varchar(255) NOT NULL,
  `fecha` date DEFAULT current_timestamp(),
  `observacion` varchar(255) NOT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `requerimientos`
--

INSERT INTO `requerimientos` (`idrequerimiento`, `idusuario`, `motivo`, `fecha`, `observacion`, `estado`) VALUES
(1, 8, 'Faltante', '2025-02-28', 'Urgencia la polvora', '1'),
(2, 8, 'FALTANTE', '2025-02-28', 'URGENTE', '1'),
(3, 1, '--------', '2025-03-06', '--------', '1'),
(4, 1, '--------', '2025-03-06', '--------', '1'),
(5, 1, '--------', '2025-03-06', '--------', '1'),
(6, 1, '--------', '2025-03-07', 'URGENTE', '1'),
(7, 1, '--------', '2025-03-07', 'URGENTE', '1'),
(8, 1, '--------', '2025-03-07', '--------', '1'),
(9, 1, '--------', '2025-03-07', 'ya tu sabes', '1'),
(10, 1, '--------', '2025-03-07', 'ya sabes', '1'),
(11, 1, 'fghfghfg', '2025-03-07', 'fghfghfgh', '1'),
(12, 1, 'VGUASGUH H', '2025-03-07', 'fsdfsdfasdf', '0'),
(13, 1, '--------', '2025-03-07', 'jklahsdklfhakljsdhfkljaskdljfhakjhsfkjahsdkfjhaskjdfhkaljshdfk askjdfhkajsdhfkjahsdkfj hjsdfkjhasdkfjh aksdhjfkajsdhfkjasdfjk aksjdfhkajshdfkljha lskhdfkajsdfh', '3'),
(14, 1, '-----------------------------------', '2025-04-22', '-----------------------------------', '3'),
(15, 1, '-----------------------------------', '2025-04-22', '-----------------------------------', '3'),
(16, 1, 'FALTANTE DE STOCK', '2025-04-22', 'URGENTE PENDITE A PROCESO ', '2'),
(17, 1, '-----------------------------------', '2025-07-29', '-----------------------------------', '3'),
(18, 1, '-----------------------------------', '2025-08-08', '-----------------------------------', '3'),
(19, 1, '-----------------------------------', '2025-08-08', '-----------------------------------', '3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(25) NOT NULL,
  `estado` char(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `rol`, `estado`) VALUES
(1, 'admin', '1'),
(2, 'asistente', '1'),
(3, 'mecanico', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_documento`
--

CREATE TABLE `tipo_documento` (
  `idtipodoc` int(11) NOT NULL,
  `tipo` varchar(15) NOT NULL,
  `create_at` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipo_documento`
--

INSERT INTO `tipo_documento` (`idtipodoc`, `tipo`, `create_at`) VALUES
(1, 'OR', '2025-07-30'),
(2, 'FACT', '2025-07-30'),
(3, 'GUIA', '2025-07-30'),
(4, 'PAGO', '2025-07-30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `usuario` varchar(60) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `nombres` varchar(40) NOT NULL,
  `apellidos` varchar(60) NOT NULL,
  `idrol` int(11) DEFAULT NULL,
  `estado` char(1) DEFAULT '1',
  `fechaInicio` date DEFAULT curdate(),
  `fechaFin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `usuario`, `clave`, `nombres`, `apellidos`, `idrol`, `estado`, `fechaInicio`, `fechaFin`) VALUES
(1, 'mcardenas', '$2y$10$wuC1s5K3yTW591rUNl1wUuK19IGIldOgcBizuzqn0bIqCaLtESCN2', 'Miguel', 'Cardenas', 1, '1', '2024-07-21', NULL),
(2, 'mhuamani', '$2y$10$0v/0gfETIT9EUIr6EOD2YeDLo9qbkOOjI2tUBQAWdY2W.0RQlSZXS', 'MILAGROS', 'HUAMANI SANCHEZ', 2, '1', '2024-07-21', NULL),
(3, 'mferreyra', '$2y$10$JP/Cm5CavjReeJHJDTHRee.Ds73Ef0LTrJEmLaUwlfBcQkPPhaZ5y', 'MARYORI', 'FERREYRA ATUNCAR', 2, '1', '2024-07-21', NULL),
(4, 'luisppp', '$2y$10$r0c.x9avIONwQCB9BaeYM.c/My3RAPl6hmeou/3.5tP.aPf.R8DG.', 'Luis', 'Tom', 2, '0', '2024-07-21', '2024-07-22'),
(5, 'MAGUIRRE', '$2y$10$ZuJG/xI3FZfzV2COrOL2e.ex8SS/i34KavJYiyzx.BOweRQ2bjXH2', 'MELANY ', 'AGUIRRE FERNANDEZ', 2, '1', '2024-08-02', NULL),
(6, 'hquispe', '$2y$10$sN0OFcBfJO9n/H6S9E0aTu/4DJYHKuxXla60lfvNUWHPAn/o9fFz6', 'Harold', 'Quispe', 2, '1', '2024-11-05', NULL),
(7, 'kflores', '$2y$10$igoK8QddgCqqE3V0rRJWfOrUPku4pfHl6EUThZfmWP0lSIubcCEYK', 'kimberly', 'flores', 2, '1', '2025-02-11', NULL),
(8, 'haroldqn', '$2y$10$KcnIA/bOAfTkY.ce6Ed/reyW694VoMQ0ux5n/WLIXWR/PFvtrp61q', 'Harold', 'Quispe', 3, '1', '2025-02-27', NULL),
(9, 'a', '$2y$10$cKJvU.DGdQvJpxAprhCksumQOWGhH2Wll9AjppcXn4o2iHSjpGtWC', 'a', 'a', 3, '0', '2025-02-27', '2025-02-27');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cotizaciones_proveedores`
--
ALTER TABLE `cotizaciones_proveedores`
  ADD PRIMARY KEY (`idcotizacion_prov`),
  ADD KEY `fk_cotizacion_prov` (`idrequerimiento`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`iddepartamento`),
  ADD UNIQUE KEY `uk_departamento_departamentos` (`departamento`);

--
-- Indices de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD PRIMARY KEY (`iddetalleordencompra`);

--
-- Indices de la tabla `detalle_usuarios`
--
ALTER TABLE `detalle_usuarios`
  ADD PRIMARY KEY (`iddetalleusuario`),
  ADD KEY `fk_idusuario_detalle_usuarios` (`idusuario`),
  ADD KEY `fk_idempresa_detalle_usuarios` (`idempresa`);

--
-- Indices de la tabla `det_cotizacion_data`
--
ALTER TABLE `det_cotizacion_data`
  ADD PRIMARY KEY (`iddet_cotizacion_data`),
  ADD KEY `fk_iddet_requerimiento` (`iddet_requerimiento`),
  ADD KEY `fk_idcotizacion_proc` (`idcotizacion_prov`);

--
-- Indices de la tabla `det_requerimientos`
--
ALTER TABLE `det_requerimientos`
  ADD PRIMARY KEY (`iddet_requerimiento`),
  ADD KEY `fk_det_requerimiento` (`idrequerimiento`);

--
-- Indices de la tabla `distritos`
--
ALTER TABLE `distritos`
  ADD PRIMARY KEY (`iddistrito`),
  ADD KEY `fk_idprovincia_distritos` (`idprovincia`);

--
-- Indices de la tabla `documentos_requerimiento`
--
ALTER TABLE `documentos_requerimiento`
  ADD PRIMARY KEY (`iddocumento`),
  ADD KEY `fk_idrequerimiento` (`idrequerimiento`),
  ADD KEY `fk_idtipodoc` (`idtipodoc`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idempresa`),
  ADD KEY `fk_distrito_empresa` (`iddistrito`);

--
-- Indices de la tabla `empresas_cliente`
--
ALTER TABLE `empresas_cliente`
  ADD PRIMARY KEY (`idempresacliente`),
  ADD UNIQUE KEY `uk_nroDocumento_empresas_cliente` (`nroDocumento`),
  ADD KEY `fk_iddistrito_empresas_cliente` (`iddistrito`);

--
-- Indices de la tabla `orden_compra`
--
ALTER TABLE `orden_compra`
  ADD PRIMARY KEY (`idordencompra`),
  ADD KEY `fk_iddetalleusuario_orden_compra` (`iddetalleusuario`),
  ADD KEY `fk_idcliente_orden_compra` (`idcliente`);

--
-- Indices de la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD PRIMARY KEY (`idprovincia`),
  ADD KEY `fk_iddepartamento_provincias` (`iddepartamento`);

--
-- Indices de la tabla `requerimientos`
--
ALTER TABLE `requerimientos`
  ADD PRIMARY KEY (`idrequerimiento`),
  ADD KEY `fk_usuario` (`idusuario`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `uk_rol_roles` (`rol`);

--
-- Indices de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  ADD PRIMARY KEY (`idtipodoc`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `uk_clave_usuarios` (`usuario`),
  ADD KEY `fk_idrol_usuarios` (`idrol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cotizaciones_proveedores`
--
ALTER TABLE `cotizaciones_proveedores`
  MODIFY `idcotizacion_prov` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `iddepartamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  MODIFY `iddetalleordencompra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=289;

--
-- AUTO_INCREMENT de la tabla `detalle_usuarios`
--
ALTER TABLE `detalle_usuarios`
  MODIFY `iddetalleusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `det_cotizacion_data`
--
ALTER TABLE `det_cotizacion_data`
  MODIFY `iddet_cotizacion_data` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `det_requerimientos`
--
ALTER TABLE `det_requerimientos`
  MODIFY `iddet_requerimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `distritos`
--
ALTER TABLE `distritos`
  MODIFY `iddistrito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1876;

--
-- AUTO_INCREMENT de la tabla `documentos_requerimiento`
--
ALTER TABLE `documentos_requerimiento`
  MODIFY `iddocumento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idempresa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `empresas_cliente`
--
ALTER TABLE `empresas_cliente`
  MODIFY `idempresacliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `orden_compra`
--
ALTER TABLE `orden_compra`
  MODIFY `idordencompra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT de la tabla `provincias`
--
ALTER TABLE `provincias`
  MODIFY `idprovincia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT de la tabla `requerimientos`
--
ALTER TABLE `requerimientos`
  MODIFY `idrequerimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  MODIFY `idtipodoc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cotizaciones_proveedores`
--
ALTER TABLE `cotizaciones_proveedores`
  ADD CONSTRAINT `fk_cotizacion_prov` FOREIGN KEY (`idrequerimiento`) REFERENCES `requerimientos` (`idrequerimiento`);

--
-- Filtros para la tabla `detalle_usuarios`
--
ALTER TABLE `detalle_usuarios`
  ADD CONSTRAINT `fk_idempresa_detalle_usuarios` FOREIGN KEY (`idempresa`) REFERENCES `empresa` (`idempresa`),
  ADD CONSTRAINT `fk_idusuario_detalle_usuarios` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `det_cotizacion_data`
--
ALTER TABLE `det_cotizacion_data`
  ADD CONSTRAINT `fk_idcotizacion_proc` FOREIGN KEY (`idcotizacion_prov`) REFERENCES `cotizaciones_proveedores` (`idcotizacion_prov`),
  ADD CONSTRAINT `fk_iddet_requerimiento` FOREIGN KEY (`iddet_requerimiento`) REFERENCES `det_requerimientos` (`iddet_requerimiento`);

--
-- Filtros para la tabla `det_requerimientos`
--
ALTER TABLE `det_requerimientos`
  ADD CONSTRAINT `fk_det_requerimiento` FOREIGN KEY (`idrequerimiento`) REFERENCES `requerimientos` (`idrequerimiento`);

--
-- Filtros para la tabla `distritos`
--
ALTER TABLE `distritos`
  ADD CONSTRAINT `fk_idprovincia_distritos` FOREIGN KEY (`idprovincia`) REFERENCES `provincias` (`idprovincia`);

--
-- Filtros para la tabla `documentos_requerimiento`
--
ALTER TABLE `documentos_requerimiento`
  ADD CONSTRAINT `fk_idrequerimiento` FOREIGN KEY (`idrequerimiento`) REFERENCES `requerimientos` (`idrequerimiento`),
  ADD CONSTRAINT `fk_idtipodoc` FOREIGN KEY (`idtipodoc`) REFERENCES `tipo_documento` (`idtipodoc`);

--
-- Filtros para la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD CONSTRAINT `fk_distrito_empresa` FOREIGN KEY (`iddistrito`) REFERENCES `distritos` (`iddistrito`);

--
-- Filtros para la tabla `empresas_cliente`
--
ALTER TABLE `empresas_cliente`
  ADD CONSTRAINT `fk_iddistrito_empresas_cliente` FOREIGN KEY (`iddistrito`) REFERENCES `distritos` (`iddistrito`);

--
-- Filtros para la tabla `orden_compra`
--
ALTER TABLE `orden_compra`
  ADD CONSTRAINT `fk_idcliente_orden_compra` FOREIGN KEY (`idcliente`) REFERENCES `empresas_cliente` (`idempresacliente`),
  ADD CONSTRAINT `fk_iddetalleusuario_orden_compra` FOREIGN KEY (`iddetalleusuario`) REFERENCES `detalle_usuarios` (`iddetalleusuario`);

--
-- Filtros para la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD CONSTRAINT `fk_iddepartamento_provincias` FOREIGN KEY (`iddepartamento`) REFERENCES `departamentos` (`iddepartamento`);

--
-- Filtros para la tabla `requerimientos`
--
ALTER TABLE `requerimientos`
  ADD CONSTRAINT `fk_usuario` FOREIGN KEY (`idusuario`) REFERENCES `detalle_usuarios` (`iddetalleusuario`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_idrol_usuarios` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
