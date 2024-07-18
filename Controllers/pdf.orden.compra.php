<?php

require_once '../Models/Pdf_orden_compra.php';

if (isset($_POST['operacion'])) {
  $reporte = new Reporte();

  switch ($_POST['operacion']) {
    case 'obtener_orden_compra':
      $data = ['idordencompra' => $_POST['idordencompra']];
      echo json_encode($reporte->obtener_orden_compra($data));
      break;

    case 'obtener_detalle_orden_compra':
      $data = ['idordencompra' => $_POST['idordencompra']];
      echo json_encode($reporte->obtener_detalle_orden_compra($data));
      break;

  }
  
}