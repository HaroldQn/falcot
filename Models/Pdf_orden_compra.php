<?php

require_once 'Conexion.php';

class Reporte extends Conexion
{
    private $conexion;
    public function __CONSTRUCT()
    {
        $this->conexion = parent::getConexion();
    }

    public function obtener_orden_compra($datos = [])
    {
        try {
        $cmd = $this->conexion->prepare('CALL spu_obetner_orden_compra(?)');
        $cmd->execute(
            array(
            $datos['idordencompra']
            )
        );

        return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
        die($e->getMessage());
        }
    }

    public function obtener_detalle_orden_compra($datos = [])
    {
        try {
        $cmd = $this->conexion->prepare('CALL obtener_detalle_orden_compra(?)');
        $cmd->execute(
            array(
            $datos['idordencompra']
            )
        );

        return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
        die($e->getMessage());
        }
    }

    public function obtener_totales_orden_compra($datos = [])
    {
        try {
        $cmd = $this->conexion->prepare('CALL spu_calcular_totales(?)');
        $cmd->execute(
            array(
            $datos['idordencompra']
            )
        );

        return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
        die($e->getMessage());
        }
    }
}