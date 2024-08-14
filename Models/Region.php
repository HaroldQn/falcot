<?php
require_once "Conexion.php";

class Region extends Conexion{

  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function listarDepartamentos(){
    try {
      $consulta = $this->conexion->prepare("CALL spListarDepartamentos");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function listarProvincias($datos =[]){
    try {
      $consulta = $this->conexion->prepare("CALL spListarProvincias(?)");
      $consulta->execute(
        array(
          $datos['iddepartamento']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function listarDistritos($datos= []){
    try {
      $consulta = $this->conexion->prepare("CALL spListarDistritos(?)");
      $consulta->execute(
        array(
          $datos['idprovincia']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

} 

?>