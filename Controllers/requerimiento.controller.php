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

    case 'lista_cotizaciones_proveedores':
      $data = ['idrequerimiento' => $_POST['idrequerimiento']];
      echo json_encode($requerimiento->lista_cotizaciones_proveedores($data));
      break;

    case 'registrar_cotizacion_proveedor':
      $data = [
        'idrequerimiento' => $_POST['idrequerimiento'],
        'precio_total' => $_POST['precio_total'],
        'ruta_pdf' => $_POST['ruta_pdf']
      ];
      echo json_encode($requerimiento->registrar_cotizacion_proveedor($data));
      break;

    case 'lista_detalle_cotizacion_proveedor':
      $data = ['idcotizacion_prov' => $_POST['idcotizacion_prov']];
      echo json_encode($requerimiento->listar_detalle_cotizacion_proveedor($data));
      break;

    case 'registrar_detalle_cotizacion_proveedor':
      $data = [
        'idcotizacion_prov' => $_POST['idcotizacion_prov'],
        'item' => $_POST['item'],
        'cantidad' => $_POST['cantidad'],
        'precio_unitario' => $_POST['precio_unitario'],
        'precio_total' => $_POST['precio_total']
      ];
      echo json_encode($requerimiento->registrar_detalle_cotizacion_proveedor($data));
      break;
  }

}