<?php

require_once '../Models/OrdenCompra.php';

if(isset($_POST['operacion'])){
  $orden = new OrdenCompra;

  switch ($_POST['operacion']) {
    case 'crear_orden_compra':

      $datosEnviar = [
        'iddetalleusuario'  =>$_POST['iddetalleusuario'],
        'cliente'           =>$_POST['cliente'],
        'moneda'            =>$_POST['moneda'],
        'fechaCreacion'     =>$_POST['fechaCreacion'],
        'descuento'         =>$_POST['descuento'],
        'grupoCompra'       =>$_POST['grupoCompra'],
        'destino'           =>$_POST['destino'],
        'observaciones'     =>$_POST['observaciones'],
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