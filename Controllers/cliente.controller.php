<?php
require '../Models/Cliente.php';

if(isset($_POST['operacion'])){
  $clientes = new Cliente;

  switch ($_POST['operacion']) {
    case 'listar_clientes':
      echo json_encode($clientes->listarClientes());
      break; 

    case 'listar_clientes_id':
      $datosEnviar = [
        'idempresacliente' => $_POST['idempresacliente']
      ];
      echo json_encode($clientes->listarClientePorID($datosEnviar));
      break; 

    case 'buscar_cliente_ruc':
      $datosEnviar = [
        'ruc' => $_POST['ruc']
      ];
      echo json_encode($clientes->buscarClientePorRuc($datosEnviar));
      break; 

    case 'verificar_cliente':
      $datosEnviar = [
        'ruc' => $_POST['ruc']
      ];
      echo json_encode($clientes->verificarCliente($datosEnviar));
      break; 

    case 'registrar_clientes':

      $datosEnviar = [
        'razonSocial'         => $_POST['razonSocial'],
        'nroDocumento'        => $_POST['nroDocumento'],
        'direccion'           => $_POST['direccion'],
        'correo'              => $_POST['correo'],
        'iddistrito'          => $_POST['iddistrito'],
        'ubigeo'              => $_POST['ubigeo'],
        'telefono'            => $_POST['telefono'],
        'celular'            => $_POST['celular'],
        'contacto'            => $_POST['contacto'],
      ];
      echo json_encode($clientes->registrarCliente($datosEnviar));
      break; 

    case 'registrar_clientes_api':

      $datosEnviar = [
        'razonSocial'         => $_POST['razonSocial'],
        'nroDocumento'        => $_POST['nroDocumento'],
        'direccion'           => $_POST['direccion'],
        'correo'              => $_POST['correo'],
        'contacto'            => $_POST['contacto'],
        'celular'             => $_POST['celular'],
        'iddistrito'          => $_POST['iddistrito'],
        'ubigeo'              => $_POST['ubigeo'],
        'telefono'            => $_POST['telefono'],
        'provincia'           => $_POST['provincia'],
        'departamento'        => $_POST['departamento'],
      ];
      echo json_encode($clientes->registrarClientePorApi($datosEnviar));
      break; 

    case 'editar_clientes':

      $datosEnviar = [
        'idempresacliente'    => $_POST['idempresacliente'],
        'razonSocial'         => $_POST['razonSocial'],
        'nroDocumento'        => $_POST['nroDocumento'],
        'direccion'           => $_POST['direccion'],
        'correo'              => $_POST['correo'],
        'iddistrito'          => $_POST['iddistrito'],
        'ubigeo'              => $_POST['ubigeo'],
        'telefono'            => $_POST['telefono'],
        'celular'            => $_POST['celular'],
        'contacto'            => $_POST['contacto'],
      ];
      echo json_encode($clientes->editarCliente($datosEnviar));
      break; 
  

    case 'eliminar_cliente':

      $datosEnviar = [
        'idempresacliente'    => $_POST['idempresacliente']
      ];
      echo json_encode($clientes->eliminarEmpresaCliente($datosEnviar));
      break; 
  

    case 'editar_cliente_orden_compra':

      $datosEnviar = [
        'idcliente'     => $_POST['idcliente'],
        'celular'       => $_POST['celular'],
        'correo'        => $_POST['correo'],
        'contacto'      => $_POST['contacto'],
        'telefono'      => $_POST['telefono'],
      ];
      echo json_encode($clientes->editarCLienteEnOrdenCompra($datosEnviar));
      break; 
  }
}

?>