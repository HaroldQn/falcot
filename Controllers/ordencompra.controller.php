<?php

require_once '../Models/OrdenCompra.php';

if(isset($_POST['operacion'])){
  $orden = new OrdenCompra;

  switch ($_POST['operacion']) {
    case 'cambiar_estado_aprobado':

      $datosEnviar = [
        'idordencompra'  =>$_POST['idordencompra'],
      ];

      echo json_encode($orden->cambiarEstadoAprobado($datosEnviar));
      break; 

    case 'cambiar_estado_rechazado':

      $datosEnviar = [
        'idordencompra'  =>$_POST['idordencompra'],
      ];

      echo json_encode($orden->cambiarEstadoRechazado($datosEnviar));
      break; 

    case 'listar_orden_rol':

      $datosEnviar = [
        'idrol'  =>$_POST['idrol'],
      ];

      echo json_encode($orden->listarOrdenCompraPorRol($datosEnviar));
      break; 

    case 'crear_orden_compra':

      $datosEnviar = [
        'iddetalleusuario'  =>$_POST['iddetalleusuario'],
        'cliente'           =>$_POST['cliente'],
        'moneda'            =>$_POST['moneda'],
        'fechaCreacion'     =>$_POST['fechaCreacion'],
        'descuento'         =>$_POST['descuento'],
        'grupoCompra'       =>"",
        'destino'           =>$_POST['destino'],
        'observaciones'     =>$_POST['observaciones'],
        'condicionpago'     =>$_POST['condicionpago'],
        'celular'           =>$_POST['celular'],
        'telefono'          =>$_POST['telefono'],
        'contacto'          =>$_POST['contacto'],
        'correo'            =>$_POST['correo'],
      ];

      echo json_encode($orden->registrarOrdenCompra($datosEnviar));
      break; 

    case 'crear_detalle_orden_compra':

      $datosEnviar = [
        'idordencompra'    =>$_POST['idordencompra'],
        'item'             =>$_POST['item'],
        'centro'           =>$_POST['centro'],
        'descripcion'      =>$_POST['descripcion'],
        'cantidad'         =>$_POST['cantidad'],
        'utm'              =>$_POST['utm'],
        'precioUnitario'   =>$_POST['precioUnitario'],
      ];

      echo json_encode($orden->registrarDetalleOrdenCompra($datosEnviar));
      break; 

  }

}

?>