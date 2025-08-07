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

  public function cambiarEstadoRequerimiento($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_actualizar_estado_requerimiento(?,?)");
      $consulta->execute(array($datos['idrequerimiento'], $datos['estado']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // Segunda parte de la refactorizacion de codigo

  public function crear_cotizacion_proveedor($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL crear_cotizacion_proveedor(?,?,?)");
      $consulta->execute(array($datos['idrequerimiento'], $datos['empresa'], $datos['moneda']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function agregar_detalle_cotizacion($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL agregar_detalle_cotizacion(?,?,?,?)");
      $consulta->execute(array($datos['idcotizacion_prov'], $datos['iddet_requerimiento'], $datos['marca'], $datos['precio']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function lista_cotizaciones($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL get_cotizaciones_json(?)");
      $consulta->execute(array($datos['idrequerimiento']));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function eliminar_cotizacion_proveedor($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("CALL spu_eliminar_cotizacion_prov(?)");
      $consulta->execute(array($datos['idcotizacion_prov']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function agregar_documento($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spu_agregar_documento_requerimiento(?,?,?)");
      $consulta->execute(array($datos['idrequerimiento'], $datos['idtipodoc'], $datos['nombre']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
