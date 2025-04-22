<?php

require_once 'Conexion.php';

class Requerimiento extends Conexion {

  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function listarRequerimientos(){
    try {
      $consulta = $this->conexion->prepare("CALL sp_listar_requerimientos()");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }
  public function listarDetRequerimientos($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL sp_detalle_requerimiento(?)");
      $consulta->execute(array($datos['idrequerimiento']));
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function registarRequerimiento($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_requerimiento(?,?,?)");
      $consulta->execute(array($datos['idusuario'],$datos['motivo'],$datos['observacion']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function registarDetRequerimiento($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spu_registrar_detalle_requerimiento(?,?,?)");
      $consulta->execute(array($datos['idrequerimiento'],$datos['item'],$datos['cantidad']));
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

}