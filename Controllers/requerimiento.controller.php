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
    
    case 'actualizar_estado_requerimiento':
      $data = [
        'idrequerimiento' => $_POST['idrequerimiento'],
        'estado' => $_POST['estado']
      ];
      echo json_encode($requerimiento->cambiarEstadoRequerimiento($data));
      break;

    case 'crear_cotizacion_proveedor':
      $data = [
        'idrequerimiento' => $_POST['idrequerimiento'],
        'empresa' => $_POST['empresa'],
        'moneda' => $_POST['moneda']
      ];
      echo json_encode($requerimiento->crear_cotizacion_proveedor($data));
      break;
    case 'agregar_detalle_cotizacion':
      $data = [
        'idcotizacion_prov' => $_POST['idcotizacion_prov'],
        'iddet_requerimiento' => $_POST['iddet_requerimiento'],
        'marca' => $_POST['marca'],
        'precio' => $_POST['precio']
      ];
      echo json_encode($requerimiento->agregar_detalle_cotizacion($data));
      break;
    
    case 'listar_cotizaciones':
      $data = ['idrequerimiento' => $_POST['idrequerimiento']];
      echo json_encode($requerimiento->lista_cotizaciones($data));
      break;

    case 'eliminar_cotizacion_proveedor':
      $data = ['idcotizacion_prov' => $_POST['idcotizacion_prov']];
      echo json_encode($requerimiento->eliminar_cotizacion_proveedor($data));
      break;

    case 'agregar_documento':
      if (isset($_FILES['archivo']) && $_FILES['archivo']['error'] == 0) {
        $nombreArchivo = $_FILES['archivo']['name'];
        $nombreSinExt = pathinfo($nombreArchivo, PATHINFO_FILENAME);
        $rutaTemporal = $_FILES['archivo']['tmp_name'];
        $rutaDestino = '../pdfs/' . $nombreArchivo;

        if (move_uploaded_file($rutaTemporal, $rutaDestino)) {
          $data = [
            'idrequerimiento' => $_POST['idrequerimiento'],
            'idtipodoc' => $_POST['idtipodoc'],
            'nombre' => $nombreSinExt,
          ];
          echo json_encode($requerimiento->agregar_documento($data));
        } else {
          echo json_encode(['error' => 'Error al subir el archivo']);
        }
      }

  }

}