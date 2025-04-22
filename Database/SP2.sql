
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

