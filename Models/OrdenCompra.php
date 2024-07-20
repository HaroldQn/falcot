<?php

require_once 'Conexion.php';

class OrdenCompra extends Conexion{

  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function registrarOrdenCompra($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spCrearOrdenCompra(?,?,?,?,?,?,?,?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['iddetalleusuario'],
          $datos['cliente'],
          $datos['moneda'],
          $datos['fechaCreacion'],
          $datos['descuento'],
          $datos['grupoCompra'],
          $datos['destino'],
          $datos['observaciones'],
          $datos['condicionpago'],
          $datos['celular'],
          $datos['telefono'],
          $datos['contacto'],
          $datos['correo'],
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function registrarDetalleOrdenCompra($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spCrearDetalleOrdenCompra(?,?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['idordencompra'],
          $datos['item'],
          $datos['centro'],
          $datos['descripcion'],
          $datos['cantidad'],
          $datos['utm'],
          $datos['precioUnitario']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function listarOrdenCompraPorRol($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spListarOrdenCompraPorRol(?)");
      $consulta->execute(
        array(
          $datos['idrol']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function cambiarEstadoAprobado($datos=[]){
    try {
      $consulta = $this->conexion->prepare("CALL spCambiarEstadoAprobado(?)");
      $consulta->execute(
        array(
          $datos['idordencompra']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }
  public function cambiarEstadoRechazado($datos=[]){
    try {
      $consulta = $this->conexion->prepare("CALL spCambiarEstadoRechazado(?)");
      $consulta->execute(
        array(
          $datos['idordencompra']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }





}

?>