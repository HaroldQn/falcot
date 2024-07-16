<?php

require_once '../Models/conexion.php';

class usuarioLogin extends Conexion
{
  private $conexion;

  public function __CONSTRUCT()
  {
    $this->conexion = parent::getConexion();
  }

  public function login($datos = [])
  {
    try {
      $consulta = $this->conexion->prepare("call spu_usuario_login(?)");
      $consulta->execute(
        array(
          $datos['usuario']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

}
