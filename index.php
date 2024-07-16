<?php
if (session_status() == PHP_SESSION_NONE) {
  session_start();
}

// Verificar si ya ha iniciado sesión
if (isset($_SESSION['idusuario'])) {
  // Si ya está autenticado, redirigir a la página principal o a la vista deseada
  header("Location: ./views/usuarios.php");
  exit();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Bootstrap CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="./Css/login.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="./Js/sw.js"></script>
</head>
<body class="bg-dark">
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="card login-card">
            <h3 class="text-center">Iniciar Sesión</h3>
            <form id="frm-login" autocomplete="off"> 
                <div class="form-group">
                    <input type="text" class="form-control" id="usuario" placeholder=" " required>
                    <label for="usuario">Nombre de usuario</label>
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" id="clave" placeholder=" " required>
                    <label for="clave">Contraseña</label>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Ingresar</button>
            </form>
        </div>
    </div>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded",()=>{
          function $(id){
            return document.querySelector(id);
          }

          $("#frm-login").addEventListener("submit",(event)=>{
            event.preventDefault();
            login();
          });

          function login(){
            const parametros = new FormData();
            parametros.append("operacion","login");
            parametros.append("usuario",$("#usuario").value);
            parametros.append("clave",$("#clave").value);


            fetch(`./Controllers/usuarioLogin.controller.php`,{
              method: "POST",
              body: parametros
            })
              .then(respuesta => respuesta.json())
              .then(data =>{
                console.log(data)
                if(data.acceso == true){
                  bienvenida(`¡Inicio de Sesión Exitoso!`);
                  setTimeout(function(){
                    window.location.href = './views/clientes.php'
                  },2000);               
                }else{
                  //alert("Acceso denegado");
                  notificar('error','Acceso denegado','Vuelva a intentarlo',2);
                }
                
              })
              .catch(e =>{
                console.error(e)
              });
          }

        });
    </script>
</body>
</html>
