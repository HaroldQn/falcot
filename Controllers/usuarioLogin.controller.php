<?php
session_start();  //  Crea o hereda la sesión

date_default_timezone_set("America/Lima");

require_once '../Models/Login.php';

if (isset($_POST['operacion'])) {
  $usuario = new usuarioLogin;

  switch ($_POST['operacion']) {
    case 'login':
      $datosEnviar = ["usuario" => $_POST["usuario"]];
      $registro = $usuario->login($datosEnviar);

      $statusLogin =[
      "acceso" => false,
      "mensaje" => ""
      ];

    if($registro == false){
      $_SESSION["status"] = false;
      $statusLogin["mensaje"] = "El usuario no existe";
    }else{

      $claveEncriptada = $registro["clave"];
      $_SESSION["idusuario"] = $registro["idusuario"];    
      $_SESSION["usuario"] = $registro["usuario"];     
      $_SESSION["nombres"] = $registro["nombres"];     
      $_SESSION["apellidos"] = $registro["apellidos"];     
      $_SESSION["idrol"] = $registro["idrol"];     
      $_SESSION["estado"] = $registro["estado"];     
      $_SESSION["fechaInicio"] = $registro["fechaInicio"];         
      $_SESSION["fechaInicio"] = $registro["fechaInicio"];
      $_SESSION["iddetalleusuario"] = $registro["iddetalleusuario"];

      if(password_verify($_POST['clave'],$claveEncriptada)){
        $_SESSION["status"]= TRUE;
        $statusLogin["acceso"] = true;
        $statusLogin["mensaje"] = "Acceso correcto";
      }else{
        $_SESSION["status"]= FALSE;
        $statusLogin["mensaje"] = "Error en la contraseña";
      }
    }
    echo json_encode($statusLogin);
      break;  
  }
}


if (isset($_GET['operacion'])) {
  if($_GET['operacion'] == 'destroy'){
    session_destroy();
    session_unset();

    header("Location: ../");
  }
}