<?php
require_once 'Conexion.php';

class Cliente extends Conexion{

  private $conexion;

  public function __CONSTRUCT(){
    $this->conexion = parent::getConexion();
  }

  public function verificarCliente($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spVerificarCliente(?)");
      $consulta->execute(
        array(
          $datos['ruc']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function listarClientePorID($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spListarEmpresaClientePorID(?)");
      $consulta->execute(
        array(
          $datos['idempresacliente']
        )
      );
      return $consulta->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function listarClientes(){
    try {
      $consulta = $this->conexion->prepare("CALL spListarEmpresasCliente");
      $consulta->execute();
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function registrarCliente($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spRegistrarEmpresaCliente(?,?,?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['razonSocial'],
          $datos['nroDocumento'],
          $datos['direccion'],
          $datos['correo'],
          $datos['iddistrito'],
          $datos['ubigeo'],
          $datos['actividadEconomica'],
          $datos['telefono']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function registrarClientePorApi($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spRegistrarEmpresaClienteAPI(?,?,?,?,?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['razonSocial'],
          $datos['nroDocumento'],
          $datos['direccion'],
          $datos['correo'],
          $datos['contacto'],
          $datos['celular'],
          $datos['iddistrito'],
          $datos['ubigeo'],
          $datos['actividadEconomica'],
          $datos['telefono']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function editarCliente($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spEditarEmpresaCliente(?,?,?,?,?,?,?,?,?)");
      $consulta->execute(
        array(
          $datos['idempresacliente'],
          $datos['razonSocial'],
          $datos['nroDocumento'],
          $datos['direccion'],
          $datos['correo'],
          $datos['iddistrito'],
          $datos['ubigeo'],
          $datos['actividadEconomica'],
          $datos['telefono']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

  public function eliminarEmpresaCliente($datos = []){
    try {
      $consulta = $this->conexion->prepare("CALL spEliminarEmpresaCliente(?)");
      $consulta->execute(
        array(
          $datos['idempresacliente']
        )
      );
      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die ($e->getMessage());
    }
  }

}

?>