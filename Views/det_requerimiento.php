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
  <div class="d-flex justify-content-between align-items-center m-3">
    <button class="btn btn-secondary" onclick="window.location.href='./requerimientos.php'">← Regresar</button>
    <h3 class="text-center flex-grow-1 mb-0" id="titulo">Comparativo de cotizaciones</h3>
    <div style="width: 100px;"></div> <!-- Espaciador para balancear el diseño -->
  </div>

  <h4 class="text-center m-3 bg-success text-light d-none" id="cerrado">CERRADO</h4>

  <div class="row mb-3 mt-3 contenedor-boton">
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

  <div class="row mb-3 container-select-empresa">
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

  <div class="row">
    <div class="col-md-6 contenedor-inputs">
      <div class="input-group">
        <label class="input-group-text bg-success text-light" for="inputGroupFile01">Orden de compra</label>
        <input type="file" accept=".pdf" class="form-control" id="inputOrdenCompra" data-tipo="1" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
        <button class="btn btn-outline-success" type="button" id="btnOrdenCompra" data-tipo="1">Subir</button>
      </div>
      <div class="input-group mt-3">
        <label class="input-group-text bg-warning text-light" for="inputGroupFile01">Factura</label>
        <input type="file" accept=".pdf" class="form-control" id="inputFactura" data-tipo="2" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
        <button class="btn btn-outline-success" type="button" id="btnFactura">Subir</button>
      </div>
      <div class="input-group mt-3">
        <label class="input-group-text bg-primary text-light" for="inputGroupFile01">Guía de remisión</label>
        <input type="file" accept=".pdf" class="form-control" id="inputGuia" data-tipo="3" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
        <button class="btn btn-outline-success" type="button" id="btnGuia">Subir</button>
      </div>
      <div class="input-group mt-3">
        <label class="input-group-text bg-info text-light" for="inputGroupFile01">Constancia de Pago</label>
        <input type="file" accept=".pdf" class="form-control" id="inputPago" data-tipo="4" aria-describedby="inputGroupFileAddon04" aria-label="Upload">
        <button class="btn btn-outline-success" type="button" id="btnPago">Subir</button>
      </div>
    </div>

    <div class="col-md-6" id="contenedor-documentos">
      <!-- Aquí se cargará dinámicamente -->
    </div>
  </div>

  
  <div class="d-grid gap-2">
    <button id="btnCerrarCotizacion" class="btn btn-primary" type="button" style="display: none;">Cerrar Cotizacion</button>
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

<script type="module" src="../Js/main.requerimiento.js"></script>
<script type="module" src="../Js/archivos_requerimientos.js"></script>
<script type="module" src="../Js/estado.js"></script>
</body>

</html>