<?php
session_start(); // Crea o hereda la sesión

if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
  # code...
  include_once 'no_acceso.php';
  exit();
}
?>
<?php require_once './navbar.php'; ?>
<div class="m-4">
  <h3 class="text-center m-3">Requerimientos</h3>
  <div class="row mb-3 mt-3">
    <div class="col col-md-4">
    </div>
    <div class="col col-md-4"></div>
    <div class="col col-md-4 d-flex justify-content-end">
      <button type="button" class="btn btn-success mb-1" id="crear-requerimiento" data-bs-toggle="modal" data-bs-target="#modal-requerimiento">Registrar requerimiento</button>
    </div>
  </div>

  <div class="table">
    <table class="table table-striped table-sm table-bordered text-center" id="tabla-requerimiento">
      <colgroup>
            <col width="3%"> <!-- N° -->
            <col width="10%"> <!-- Solicitud -->
            <col width="5%"> <!-- Fecha -->
            <col width="30%"> <!-- Motivo -->
            <col width="30%"> <!-- Observaciones -->
            <col width="5%"> <!-- Detalle -->
            <col width="10%"> <!-- Estado -->
            <col width="7%"> <!-- Opciones -->
      </colgroup>
      <thead class="table-dark" style="position: sticky; top: 0; z-index: 2;">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Solicitado por</th>
          <th scope="col">Fecha</th>
          <th scope="col">Motivo</th>
          <th scope="col">Observaciones</th>
          <th scope="col">Detalle</th>
          <th scope="col">Estado</th>
          <th scope="col">Opciones</th>
        </tr>
      </thead>
      <tbody id="lista-requerimientos">
      </tbody>
    </table>
  </div>
</div>
<!-- Modal para visualizar el modal de registro -->
<div class="modal fade" id="modal-requerimiento" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header d-flex justify-content-center bg-dark">
        <h3 class="modal-title text-light" id="titulo-modal">Registrar requerimiento</h3>
      </div>
      <form action="" id="form-modal" autocomplete="off">
        <div class="row m-2">
          <div class="col-md-12" class="det_requerimiento">
            <h4>Detalle del requerimiento</h4>
            <button type="button" class="btn btn-primary mb-2 agregar-fila" id="agregar-detalle">Agregar</button>
            <div class="list-detalle-render" id="list-detalle-render">
              <div class="input-group">
                <input class="form-control" style="width: 65%;" type="text" name="requerimiento" placeholder="Requerimiento" maxlength="255" required>
                <input type="number" class="form-control" placeholder="cantidad" name="cantidad" min="1" value="1">
              </div>
            </div>
          </div>
          
          <div class="col-md-12 mt-2">
            <label for="motivo"> Motivo:</label>
            <textarea name="motivo" id="motivo" class="form-control p-4  w-100" placeholder="Ingrese el motivo del requerimiento"  rows="2"></textarea>
          </div>
          <div class="col-md-12 mt-2">
            <label for="observaciones"> Observaciones:</label>
            <textarea name="observacion" id="observaciones" class="form-control p-4  w-100" placeholder="Ingrese las observaciones del requerimiento si son necesarias." rows="2"></textarea>
          </div>
          <button type="submit" id="registra_animal" class="btn col-md-12 btn-success mt-2">Registrar</button>


        </div>
      </form>
    </div>
  </div>
</div>
<!-- Modal para ver el detalle del requerimiento -->
<div class="modal fade" id="modal-requerimiento-list" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header d-flex justify-content-center bg-dark">
        <h3 class="modal-title text-light" id="titulo-modal">Detalle del requerimiento</h3>
      </div>
      <table id="tabla-requerimiento-list" class="table table-striped  table-sm table-bordered text-center">
        <thead class="table-dark">
          <tr>
            <th scope="col">#</th>
            <th scope="col">Producto</th>
            <th scope="col">Cantidad</th>
          </tr>
        </thead>
        <tbody id="lista-det-requerimientos">
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal para subir PDF -->
<div class="modal fade" id="modal-subir-pdf" tabindex="-1" aria-labelledby="modalSubirPdfLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalSubirPdfLabel">Subir PDF</h5>
      </div>
      <form id="form-subir-pdf">
        <div class="modal-body">
          <div class="mb-3">
            <label for="archivo-pdf" class="form-label">Seleccionar archivo PDF</label>
            <input type="file" class="form-control" id="archivo-pdf" name="archivo-pdf" accept=".pdf" required>
          </div>
          <div class="">
            <label for="fecha" class="form-label">Monto:</label>
            <input type="number" class="form-control" id="monto" name="monto" placeholder="Ingrese el monto de la cotización" min="0" step="0.01" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary">Subir</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script type="module" src="../Js/requerimientos.js"></script>
</body>

</html>