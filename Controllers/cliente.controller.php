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

    case 'registrar_clientes':

      $datosEnviar = [
        'razonSocial'         => $_POST['razonSocial'],
        'nroDocumento'        => $_POST['nroDocumento'],
        'direccion'           => $_POST['direccion'],
        'correo'              => $_POST['correo'],
        'iddistrito'          => $_POST['iddistrito'],
        'ubigeo'              => $_POST['ubigeo'],
        'actividadEconomica'  => $_POST['actividadEconomica'],
        'telefono'            => $_POST['telefono'],
      ];
      echo json_encode($clientes->registrarCliente($datosEnviar));
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
        'actividadEconomica'  => $_POST['actividadEconomica'],
        'telefono'            => $_POST['telefono'],
      ];
      echo json_encode($clientes->editarCliente($datosEnviar));
      break; 
  }
}

?>