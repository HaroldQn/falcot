<?php

require_once 'Conexion.php';

class Requerimiento extends Conexion
{

  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  public function listarRequerimientos()
  {
    try {
      $consulta = $this->conexion->prepare("CALL sp_listar_requerimientos()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function listarDetRequerimientos($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL sp_detalle_requerimiento(?)");
      $consulta->execute(array($datos['idrequerimiento']));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registarRequerimiento($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_requerimiento(?,?,?)");
      $consulta->execute(array($datos['idusuario'], $datos['motivo'], $datos['observacion']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registarDetRequerimiento($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_detalle_requerimiento(?,?,?)");
      $consulta->execute(array($datos['idrequerimiento'], $datos['item'], $datos['cantidad']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // Detalle de requerimiento cotizaciones proveedores
  public function lista_cotizaciones_proveedores($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL sp_listar_cotizaciones_proveedor(?)");
      $consulta->execute(array($datos['idrequerimiento']));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function registrar_cotizacion_proveedor($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_cotizacion_proveedor(?,?,?)");
      $consulta->execute(array($datos['idrequerimiento'], $datos['precio_total'], $datos['ruta_pdf']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // Detalle de la data de cotizacion pdf, constancia de pagom, factura
  public function listar_detalle_cotizacion_proveedor($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL sp_listar_detalle_cotizacion_proveedor(?)");
      $consulta->execute(array($datos['idcotizacion_prov']));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }


  public function registrar_detalle_cotizacion_proveedor($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_detalle_cotizacion_proveedor(?,?,?,?,?)");
      $consulta->execute(array(
        $datos['idcotizacion_prov'], 
        $datos['idordencompra'], 
        $datos['ruta_guia'], 
        $datos['ruta_pdf'], 
        $datos['ruta_pago']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
