<?php

class Conexion{

  //1. Almacenamos los datos de conexión
  private $servidor = "localhost";
  private $puerto = "3306";
  private $baseDatos = "u952246627_falcot24";
  private $usuario = "u952246627_falcot24";
  private $clave = "@Falcot2024";

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