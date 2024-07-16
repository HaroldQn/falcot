<?php 
require_once '../Models/Region.php';

if(isset($_POST['operacion'])){
  $region = new Region;

  switch ($_POST['operacion']) {
    case 'listar_departamentos':
      echo json_encode($region->listarDepartamentos());
      break; 

    case 'listar_provincias':
      $datosEnviar = [
        'iddepartamento'  =>$_POST['iddepartamento']
      ];
      echo json_encode($region->listarProvincias($datosEnviar));
      break; 

    case 'listar_distritos':
      $datosEnviar = [
        'idprovincia'  =>$_POST['idprovincia']
      ];
      echo json_encode($region->listarDistritos($datosEnviar));
      break; 

  }
}

?>