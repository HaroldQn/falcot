<?php

class Conexion{

  //1. Almacenamos los datos de conexión
  private $servidor = "localhost";
  private $puerto = "3306";
  private $baseDatos = "proyecto_falcot";
  private $usuario = "root";
  private $clave = "";

    public function getConexion(){

    try{
      $pdo = new PDO(
        "mysql:host={$this->servidor};
        port={$this->puerto};
        dbname={$this->baseDatos};
        charset=UTF8", 
        $this->usuario, 
        $this->clave
      );

      $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      return $pdo;
    }
    catch(Exception $e){
      die($e->getMessage());
    }
  }

}

// // Prueba de conexión
// $conexion = new Conexion();
// try {
//     $db = $conexion->getConexion();
//     echo "Conexión exitosa a la base de datos.";
// } catch (Exception $e) {
//     echo "Error al conectar a la base de datos: " . $e->getMessage();
// }