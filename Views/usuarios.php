<?php
  session_start(); // Crea o hereda la sessión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    echo "<h1 class='mt-5 text-center'>NO PUEDES TENER ACCESO</h1>";
    echo "<h5 class='mt-5 text-center'>¡PORVAFOR TRATE DE INICIAR SESION!</h5>";
    echo "<div class='d-flex justify-content-center align-items-center mt-5'>";
    echo "<a href='../index.php' class='btn btn-primary btn-lg btn-block text-center'>Iniciar Sesión</a>";
    echo "</div>";
    exit();
  }
  
?>

<?php require_once './navbar.php'; ?>
    <div class="container">
        <h1 class="text-center m-3">Gestion de Usuario</h1>
    <div class="container row mb-3 mt-3">
        <div class="col col-md-4">
        </div>
        <div class="col col-md-4"></div>
        <div class="col col-md-4 d-flex justify-content-end">
            <button class="btn btn-success" id="btnAgregarUsuario" data-bs-toggle="modal" data-bs-target="#modal-usuario">Registrar usuario</button>
        </div>
    </div>
    
    <div class="container">
        <div class="table-responsive">
            <table class="table table-striped  table-sm table-bordered text-center" id="tabla-usuario">
            <thead class="table-dark">
                <tr>
                    <th scope="col">Usuario</th>
                    <th scope="col">Nombres</th>
                    <th scope="col">Apellidos</th>
                    <th scope="col">Rol</th>
                    <th scope="col">Operaciones</th>
                </tr>
            </thead>
            <tbody id="lista-usuarios">
            </tbody>
            
            </table>
        </div>   
    </div>
    <div class="modal fade" id="modal-usuario" tabindex="-1" aria-labelledby="modal-usuario" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header bg-success justify-content-center" >
                    <h5 class="modal-title fs-5 text-light" >Registrar usuario</>
                </div>
                    <form autocomplete="off" id="form-usuario">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col col-md-12">
                                    <label for="usuario" class="form-label">Nombre del usuario:</label>
                                    <input type="text" name="usuario" class="form-control" id="usuario">
                                </div>
                                <div class="col col-md-12 mt-2">
                                    <label for="clave" class="form-label">Contraseña:</label>
                                    <input type="text" name="clave" class="form-control" id="clave">
                                </div>
                                <div class="col col-md-12 mt-2">
                                    <label for="nombres" class="form-label">Nombres:</label>
                                    <input type="text" name="nombres" class="form-control" id="nombres">
                                </div>
                                <div class="col col-md-12 mt-2">
                                    <label for="apellidos" class="form-label">Apellidos:</label>
                                    <input type="text" name="apellidos" class="form-control" id="apellidos">
                                </div>
                            </div>                    
                        </div>

                        <div class="modal-footer">
                            <button type="button" id="guardar" class="btn btn-outline-primary flex-fill"><i class="bi bi-check-square-fill"></i>Guardar</button>
                            <button type="button" data-bs-dismiss="modal" class="btn btn-outline-danger flex-fill" data-bs-dismiss="modal"><i class="bi bi-x-square-fill"></i>Cerrar</button>
                        </div>
                    </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modal-clave" tabindex="-1" aria-labelledby="modal-clave" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header bg-success justify-content-center" >
                    <h5 class="modal-title fs-5 text-light" >Actualizar contraseña</>
                </div>
                    <form autocomplete="off" id="form-usuario">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col col-md-12 mt-2">
                                    <label for="clave" class="form-label">Nueva contraseña:</label>
                                    <input type="text" name="clave" class="form-control" id="clave_nueva">
                                </div>
                            </div>                    
                        </div>

                        <div class="modal-footer">
                            <button type="button" id="guardar_clave" class="btn btn-outline-primary flex-fill"><i class="bi bi-check-square-fill"></i>Guardar</button>
                            <button type="button" data-bs-dismiss="modal" class="btn btn-outline-danger flex-fill" data-bs-dismiss="modal"><i class="bi bi-x-square-fill"></i>Cerrar</button>
                        </div>
                    </form>
            </div>
        </div>
    </div>

</div>

<script>
    document.addEventListener("DOMContentLoaded",()=>{
        function $(id){
            return document.querySelector(id);
        }
        const lista = document.getElementById('lista-usuarios');
        const btnEliminar = document.querySelectorAll(".eliminar")
        const btnGuardar = document.getElementById('guardar');
        const btnGuardarClave = document.getElementById('guardar_clave');
        const formUsuario = document.getElementById('form-usuario');
        const modalUsuario = document.getElementById('modal-usuario');
        
        function listarUsuarios(){
            const parametros = new FormData();
            parametros.append("operacion","listarUsuarios");
            fetch(`../Controllers/usuario.controller.php`,{
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(data =>{
                lista.innerHTML = '';
                datos = data.filter( rol => rol.rol == 'asistente');
                datos.forEach( usuario => {
                    let fila = '';

                    fila =`
                        <tr>
                            <td>${usuario.usuario}</td>
                            <td>${usuario.nombres}</td>
                            <td>${usuario.apellidos}</td>
                            <td>${usuario.rol}</td>
                            <td>
                                <button class="btn btn-primary editar" id="btn-editar-${usuario.idusuario}" data-id="${usuario.idusuario}" data-bs-toggle="modal" data-bs-target="#modal-clave">Editar</button>
                                <button class="btn btn-danger eliminar" id="btn-eliminar-${usuario.idusuario}" data-id="${usuario.idusuario}"><i class="bi bi-trash"></i></button>
                            </td>
                            
                        </tr>
                    `
                lista.innerHTML += fila;
                });
            });
        }

        function registrarUsuario(){
            const parametros = new FormData();
            parametros.append("operacion","registrarUsuario");
            parametros.append("usuario",$("#usuario").value);
            parametros.append("clave",$("#clave").value);
            parametros.append("nombres",$("#nombres").value);
            parametros.append("apellidos",$("#apellidos").value);
            parametros.append("rol",2);
            fetch(`../Controllers/usuario.controller.php`,{
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(data =>{
                listarUsuarios();
                window.location.href = './usuarios.php';
            })
            .catch(error => console.log(error));
        }

        function eliminarUsuario(id){
            const parametros = new FormData();
            parametros.append("operacion","eliminarUsuario");
            parametros.append("idusuario",id);

            fetch(`../Controllers/usuario.controller.php`,{
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(data => {
                listarUsuarios();
            });

        }

        function actualizarClave(id){
            const parametros = new FormData();
            parametros.append("operacion","actualizarClave");
            parametros.append("idusuario",id);
            parametros.append("clave",$("#clave_nueva").value);
            fetch(`../Controllers/usuario.controller.php`,{
                method: "POST",
                body: parametros
            })
            .then(respuesta => respuesta.json())
            .then(data =>{
                listarUsuarios();
                window.location.href = './usuarios.php';
            })
            .catch(error => console.log(error));
        }

        lista.addEventListener("click", (event) => {
            if (event.target.classList.contains('eliminar')) {
                let idusuario = event.target.dataset.id;
                
                mostrarPregunta("FALCOT TECHNOLOGY", "¿Está seguro de eliminar este usuario?").then((result) => {          
                    if (result.isConfirmed) {
                        eliminarUsuario(idusuario);
                    }
                });
            }
        });

        lista.addEventListener("click", (event) => {
            if (event.target.classList.contains('editar')) {
                let idusuario = event.target.dataset.id;

                btnGuardarClave.addEventListener("click", (event) => {
                    actualizarClave(idusuario);
                });
            }
        });

        

        btnGuardar.addEventListener("click", (event) => {
            registrarUsuario();
        });


        listarUsuarios();
    });
</script>

</body>
</html>