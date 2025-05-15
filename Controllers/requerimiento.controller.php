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

    case 'actualizar_estado_requetimiento':
      $data = [
        'idrequerimiento' => $_POST['idrequerimiento'],
        'estado' => $_POST['estado']
      ];
      echo json_encode($requerimiento->actualizar_estado_requerimiento($data));
      break;    

    // Detalle de requerimiento cotizaciones proveedores
    case 'lista_cotizaciones_proveedores':
      $data = ['idrequerimiento' => $_POST['idrequerimiento']];
      echo json_encode($requerimiento->lista_cotizaciones_proveedores($data));
      break;

    case 'registrar_cotizacion_proveedor':
      // Guardar el archivo PDF en la carpeta 'pdf_cot'
      $rutaDestino = '../pdf_cot/' . basename($_FILES['ruta_pdf']['name']);
      $nameArchivo = $_FILES['ruta_pdf']['name'];
      if (move_uploaded_file($_FILES['ruta_pdf']['tmp_name'], $rutaDestino)) {
        $data = [
          'idrequerimiento' => $_POST['idrequerimiento'],
          'precio_total' => $_POST['precio_total'],
          'ruta_pdf' => $nameArchivo
        ];
        $result = $requerimiento->registrar_cotizacion_proveedor($data);
        echo json_encode([
          'success' => true,
          'message' => 'Archivo PDF guardado correctamente.',
          'data' => $result
        ]);
      } else {
        echo json_encode(['success' => false, 'message' => 'Error al guardar el archivo PDF.']);
      }
      break;
      
    // Detalle de cotizacion proveedor
    case 'lista_detalle_cotizacion_proveedor':
      $data = ['idcotizacion_prov' => $_POST['idcotizacion_prov']];
      echo json_encode($requerimiento->listar_detalle_cotizacion_proveedor($data));
      break;

    case 'cambiar_estado_cotizacion_prov':
      $data = [
        'idcotizacion_prov' => $_POST['idcotizacion_prov'],
        'estado' => $_POST['estado']
      ];
      echo json_encode($requerimiento->cambiar_estado_cotizacion_prov($data));
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
      // -------------------------
    case 'listar_data_cotizacion':
      $data = ['idcotizacion_prov' => $_POST['idcotizacion_prov']];
      echo json_encode($requerimiento->listar_detalle_cotizacion_aprobada($data));
      break;
    case 'registrar_doc_cotizacion':
      $rutaDestino = '../pdf_data_cotizaciones/' . basename($_FILES['ruta']['name']);
      $nameArchivo = $_FILES['ruta']['name'];
      if (move_uploaded_file($_FILES['ruta']['tmp_name'], $rutaDestino)) {
        $data = [
          'idcotizacion_prov' => $_POST['idcotizacion_prov'],
          'tipo' => $_POST['tipo'],
          'ruta' => $nameArchivo
        ];
        $result = $requerimiento->registrar_doc_cotizacion($data);
        echo json_encode([
          'success' => true,
          'message' => 'Archivo PDF guardado correctamente.',
          'data' => $result
        ]);
      } else {
        echo json_encode(['success' => false, 'message' => 'Error al guardar el archivo PDF.']);
      }
      break;
    
    case 'eliminar_doc_cotizacion':
      $data = [
        'idcotizacion_prov' => $_POST['idcotizacion_prov'],
        'tipo' => $_POST['tipo']
      ];
      echo json_encode($requerimiento->eliminar_doc_cotizacion($data));
      break;
      

  }

}