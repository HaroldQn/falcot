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
  <h3 class="text-center m-3" id="titulo">Comparativo de cotizaciones</h3>

  <div class="row mb-3 mt-3">
    <div class="col-md-12 d-flex justify-content-end">
      <button type="button" class="btn btn-success mb-1" id="registrar-cotizacion" data-bs-toggle="modal" data-bs-target="#modal-registrar-cotizacion">
        Registrar cotizacion
      </button>
    </div>
  </div>

  <div class="table-responsive">
    <table class="table table-bordered table-hover text-center align-middle" id="tabla-comparativa-cabezera">
      <thead class="">
      </thead>
      <tbody id="tabla-comparativa">
      </tbody>
      <tfoot>
      </tfoot>
    </table>
  </div>
</div>





<!-- Modal para visualizar el modal de registro -->
<div class="modal fade" id="modal-registrar-cotizacion" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header d-flex justify-content-center bg-dark">
        <h3 class="modal-title text-light" id="titulo-modal">Registrar cotizacion</h3>
      </div>
      <form action="" id="form-modal" autocomplete="off" method="post">
        <div class="table-responsive p-3">
          <div class="row">
            <div class="col-md-4">
              <input type="text" id="empresa" name="empresa" class="form-control" placeholder="Empresa" required>
            </div>
            <div class="col-md-4 mb-2">
              <select name="moneda" id="moneda" class="form-control" required>
                <option value="">Seleccione una moneda</option>
                <option value="SOLES">Soles</option>
                <option value="DOLARES">Dólares</option>
              </select>
            </div>
           
          </div>
          <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-dark">
              <tr>
                <th>ID</th>
                <th>Item</th>
                <th>Cantidad</th>
                <th>Marca</th>
                <th>Precio Unitario</th>
                <th>Precio Total</th>
              </tr>
            </thead>
            <tbody id="lista-det-requerimientos-modal">
              <!-- Se renderiza de manera dinamica -->
            </tbody>
          </table>
          <button type="submit" id="btnGuardar" class="btn btn-primary">Guardar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="row mb-3">
  <div class="col-md-4">
    <select id="select-empresa-cotizacion" class="form-select">
      <option value="">Seleccione una empresa</option>
    </select>
  </div>
  <div class="col-md-4">
    <button class="btn btn-primary" id="btn-generar-cotizacion">
      Generar cotización para proveedor
    </button>
  </div>
</div>




<script type="module" src="../Js/main.requerimiento.js"></script>
</body>

</html>