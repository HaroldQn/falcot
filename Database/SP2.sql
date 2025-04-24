
-- SPU PARTE 2 SOLICITUDES
DELIMITER $$
CREATE PROCEDURE spu_registrar_requerimiento(
    IN _idusuario INT,
    IN _motivo VARCHAR(255),
    IN _observacion VARCHAR(255)
)
BEGIN
    INSERT INTO requerimientos (idusuario, motivo, observacion)
    VALUES (_idusuario, _motivo, _observacion);

    SELECT @@last_insert_id as'idrequerimiento';
END $$
CALL spu_registrar_requerimiento(8,'FALTANTE','URGENTE')

DELIMITER $$
CREATE PROCEDURE spu_registrar_detalle_requerimiento(
    IN _idrequerimiento INT,
    IN _item VARCHAR(100),
    IN _cantidad INT
)
BEGIN
    INSERT INTO det_requerimientos (idrequerimiento, item, cantidad)
    VALUES (_idrequerimiento, _item, _cantidad);
END $$
CALL spu_registrar_detalle_requerimiento(2,'PINZA ELECTRICA',2);

DELIMITER $$
CREATE PROCEDURE sp_listar_requerimientos()
BEGIN
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
END $$
CALL sp_listar_requerimientos

DELIMITER $$
CREATE PROCEDURE sp_detalle_requerimiento(IN p_idrequerimiento INT)
BEGIN
    SELECT 
        dr.iddet_requerimiento,
        dr.item,
        dr.cantidad,
        dr.estado
    FROM det_requerimientos dr
    WHERE dr.idrequerimiento = p_idrequerimiento;
END $$

CALL sp_detalle_requerimiento(12)
-- -------------------------------------------------

DELIMITER $$
CREATE PROCEDURE sp_listar_cotizaciones_proveedor(
    IN _idrequerimiento INT
)
BEGIN
    SELECT 
        cp.idcotizacion_prov,
        cp.idrequerimiento,
        cp.precio_total,
        cp.ruta_pdf,
        cp.fecha,
        cp.estado
    FROM cotizaciones_proveedores cp
    WHERE cp.idrequerimiento = _idrequerimiento;
END $$
CALL sp_listar_cotizaciones_proveedor(16)

DELIMITER $$
CREATE PROCEDURE spu_registrar_cotizacion_proveedor(
    IN _idrequierimiento INT,
    IN _precio_total DECIMAL(10,2),
    IN _ruta_pdf VARCHAR(255)
)
BEGIN
    INSERT INTO cotizaciones_proveedores (idrequerimiento, precio_total, ruta_pdf)
    VALUES (_idrequierimiento, _precio_total, _ruta_pdf);
END $$
CALL spu_registrar_cotizacion_proveedor(16, 1000, 'ruta123.pdf');

DELIMITER $$
CREATE PROCEDURE sp_listar_detalle_cotizacion_proveedor(
    IN _idcotizacion_prov INT
)
BEGIN
    SELECT 
        dc.iddet_cotizacion_data,
        dc.idcotizacion_prov,
        dc.idordencompra,
        dc.ruta_guia,
        dc.ruta_factura,
        dc.ruta_pago,
        dc.estado
    FROM det_cotizacion_data dc
    WHERE dc.idcotizacion_prov = _idcotizacion_prov;
END $$
CALL sp_listar_detalle_cotizacion_proveedor(1)

DELIMITER $$
CREATE PROCEDURE spu_registrar_detalle_cotizacion_proveedor(
    IN _idcotizacion_prov INT,
    IN _idordencompra INT,
    IN _ruta_guia VARCHAR(255),
    IN _ruta_factura VARCHAR(255),
    IN _ruta_pago VARCHAR(255)
)
BEGIN
    INSERT INTO det_cotizacion_data (idcotizacion_prov, idordencompra, ruta_guia, ruta_factura, ruta_pago)
    VALUES (_idcotizacion_prov, _idordencompra, _ruta_guia, _ruta_factura, _ruta_pago);
END $$
CALL spu_registrar_detalle_cotizacion_proveedor(1, 1, 'guia123.pdf', 'factura.pdf', 'pago.pdf');
