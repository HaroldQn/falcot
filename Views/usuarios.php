<?php
  session_start(); // Crea o hereda la sessión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    include_once 'no_acceso.php';
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
                    <form autocomplete="off" id="form-usuario-clave">
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

<script src="../Js/usuarios.js"></script>

</body>
</html>