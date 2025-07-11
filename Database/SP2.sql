
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

DELIMITER $$
CREATE PROCEDURE spu_actualizar_estado_requerimiento(
	IN _idrequerimiento INT,
    IN _estado CHAR(1)
)
BEGIN
	UPDATE requerimientos SET estado = _estado WHERE idrequerimiento = _idrequerimiento;
END $$
CALL spu_actualizar_estado_requerimiento(18,0)

-- -------------------------------------------------
-- REGISTRAR UNA COTIZACION DE UN PROVEEDOR
DELIMITER $$
CREATE PROCEDURE crear_cotizacion_proveedor (
    IN _idrequerimiento INT,
    IN _empresa VARCHAR(60),
    IN _moneda VARCHAR(20)
)
BEGIN
    INSERT INTO cotizaciones_proveedores (idrequerimiento, empresa, moneda)
    VALUES (_idrequerimiento, _empresa, _moneda);
    
    -- Retorna el ID de la cotización recién creada
    SELECT LAST_INSERT_ID() AS idcotizacion_prov_creada;
END $$
call crear_cotizacion_proveedor(17, 'LOS TORIBIANITOS 2', 'DOLARES')

DELIMITER $$
CREATE PROCEDURE agregar_detalle_cotizacion (
    IN _idcotizacion_prov INT,
    IN _iddet_requerimiento INT,
    IN _marca VARCHAR(30),
    IN _precio_unitario FLOAT(7,2)
)
BEGIN
    INSERT INTO det_cotizacion_data (
        idcotizacion_prov, iddet_requerimiento, marca, precio_unitario
    )
    VALUES (
        _idcotizacion_prov, _iddet_requerimiento, _marca, _precio_unitario
    );
END $$
call agregar_detalle_cotizacion(3, 26, 'MKM', 65.84 )
-- -----------------------------------
DELIMITER $$
CREATE PROCEDURE get_cotizaciones_json(
  IN p_idrequerimiento INT
)
BEGIN
  -- Asegurarnos de soportar un JSON grande
  SET SESSION group_concat_max_len = 1000000;

  SELECT CONCAT(
           '[',
           GROUP_CONCAT(
             CONCAT(
               '{"nombre":"', sub.empresa, '",',
               '"moneda":"', sub.moneda, '",',
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
END $$
CALL get_cotizaciones_json(17)




