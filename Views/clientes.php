<?php
  session_start(); // Crea o hereda la sessión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    include_once 'no_acceso.php';
    exit();
  }
?>
<?php require_once './navbar.php'; ?>
  <div class="container">
    <h3 class="text-center m-3">Gestión de Clientes </h3>
  <div class="container row mb-3 mt-3">
      <div class="col col-md-4">
      </div>
      <div class="col col-md-4"></div>
      <div class="col col-md-4 d-flex justify-content-end">
        <button type="button" class="btn btn-success mb-1" id="crear-usuario" data-bs-toggle="modal" data-bs-target="#modal-cliente">Agregar Cliente</button>
      </div>
  </div>

  <div class="">
    <div class="table-responsive">
      <table class="table table-striped  table-sm table-bordered text-center" id="tabla-cliente">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Razon social</th>
            <th scope="col">Ruc</th>
            <th scope="col">Dirección</th>
            <th scope="col">Telefono</th>
            <th scope="col">Opciones</th>
          </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal -->
<div class="modal fade" id="modal-cliente" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header d-flex justify-content-center bg-dark" >
        <h3 class="modal-title text-light" id="titulo-modal">Agregar nuevo cliente</h3>
      </div>
      <form action="" id="form-modal" autocomplete="off">
        <div class="modal-body "style="background-color:#E5E8E8">

            <label for="razonSocial" class="form-label">Ingrese Razon social</label>
            <input type="text" class="form-control" id="razonSocial" maxlength="60" required>

            <div class="row mt-2">
              <div class="col col-md-6">
                <label for="actividadEconomica" class="form-label">Actividad Economica</label>
                <input type="text" class="form-control mb-1" id="actividadEconomica" maxlength="60">
              </div>

              <div class="col col-md-6">
                <label for="correo" class="form-label">Correo</label>
                <input type="text" class="form-control mb-1" id="correo" maxlength="30">
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-6">             
                <label for="numeroDoc" class="form-label">Ingrese NumeroDoc</label>
                <input type="number" class="form-control" id="numeroDoc" required>
              </div>
              <div class="col col-sm-6">
                <label for="direccion" class="form-label">Ingrese dirección</label>
                <input type="text" class="form-control mb-1" id="direccion" maxlength="60" required>
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-4">
                <label for="departamento" class="form-label">Departamento</label>
                <select name="departamento" class="form-control" id="departamento" required> 
                  <option value="">Seleccione</option>
                </select>
              </div>
              <div class="col col-sm-4">
                <label for="provincia" class="form-label">Provincia</label>
                <select name="provincia" class="form-control" id="provincia" required>
                  <option value="1">Seleccione</option>
                </select>
              </div>
              <div class="col col-sm-4">
                <label for="distrito" class="form-label">Distrito</label>
                <select name="distrito" class="form-control" id="distrito" required>
                  <option value="1">Seleccione</option>
                </select>
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-6">
                <label for="telefono" class="form-label">Teléfono</label>
                <input type="number" class="form-control mb-1" id="telefono">
              </div>

              <div class="col col-sm-6">
                <label for="ubigeo" class="form-label">Ubigeo</label>
                <input type="text" class="form-control mb-1" id="ubigeo" maxlength="60">
              </div>
            </div>

          </div>
          <div class="modal-footer" style="background-color:#ABB2B9">
            <button type="button" class="btn btn-secondary flex-fill" data-bs-dismiss="modal">cerrar</button>
            <button type="submit" id="btnGuardar" class="btn btn-primary flex-fill">Guardar</button>
          </div>
        </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="../Js/clientes.js"></script>
</body>
</html>

