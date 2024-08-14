<?php

require_once '../Models/Usuario.php';

if (isset($_POST['operacion'])) {
    $usuario = new Usuarios;

    switch ($_POST['operacion']) {
        case 'listarUsuarios':
            echo json_encode($usuario->listarUsuarios());
            break;
        
        case 'eliminarUsuario':
            $datosEnviar = ["idusuario" => $_POST["idusuario"]];
            echo json_encode($usuario->eliminarUsuario($datosEnviar));
            break;

        case 'registrarUsuario':
            $clave = password_hash($_POST["clave"], PASSWORD_BCRYPT);
            $datosEnviar = [
                "usuario" => $_POST["usuario"],
                "clave" => $clave,
                "nombres" => $_POST["nombres"],
                "apellidos" => $_POST["apellidos"],
                "rol" => $_POST["rol"]
            ];
            echo json_encode($usuario->registrarUsuario($datosEnviar));
            break;
        case 'actualizarClave':
            $clave = password_hash($_POST["clave"], PASSWORD_BCRYPT);
            $datosEnviar = [
                "idusuario" => $_POST["idusuario"],
                "clave" => $clave
            ];
            echo json_encode($usuario->actualizarClave($datosEnviar));
            break;
    }
}