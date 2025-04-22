<?php 
session_start();
include '../Models/Requerimiento.php';


if (isset($_POST['operacion'])) {
  $requerimiento = new Requerimiento;

  switch ($_POST['operacion']) {
    
    case 'lista_requerimientos':
      echo json_encode($requerimiento->listarRequerimientos());
      break;

    case 'lista_det_requerimientos':
      $data = ['idrequerimiento' => $_POST['idrequerimiento']];
      echo json_encode($requerimiento->listarDetRequerimientos($data));
      break;

    case 'registrar_requerimiento':
      $data = [
        'idusuario' => $_SESSION['idusuario'],
        'motivo' => $_POST['motivo'],
        'observacion' => $_POST['observacion']
      ];
      echo json_encode($requerimiento->registarRequerimiento($data));
      break;

    case 'registrar_det_requerimiento':
      $data = [
        'idrequerimiento' => $_POST['idrequerimiento'],
        'item' => $_POST['item'],
        'cantidad' => $_POST['cantidad']
      ];
      echo json_encode($requerimiento->registarDetRequerimiento($data));
      break;
  }

}