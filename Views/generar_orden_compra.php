<?php
  session_start(); // Crea o hereda la sesión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    include_once 'no_acceso.php';
    exit();
  }
?>
<?php require_once './navbar.php'; ?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generar Orden de Compra</title>
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container">
  <h3 class="text-center">GENERAR ORDEN DE COMPRA</h3>
</div>

<div class="container p-3 mx-5">
  <div class="row mb-3 mx-2">
    <div class="col-md-4 d-flex justify-content-start">
      <input type="text" class="form-control me-2" id="ruc" maxlength="11" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
      <button class="btn btn-primary">Buscar</button>
    </div>
  </div>
</div>

<div class="mb-5 shadow p-3 mx-5 bg-body rounded border">
  <div class="row mb-3">
    <div class="col-sm-12 col-md-5 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="RAZON SOCIAL" disabled>
    </div>
    <div class="col-sm-6 col-md-3 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="RUC" disabled>
    </div>
    <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="MONEDA" disabled>
    </div>
    <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="N° FACTURA" disabled>
    </div>
  </div>
  
  <div class="row mb-3">
    <div class="col-sm-12 col-md-6 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="DIRECCION">
    </div>
    <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="CELULAR">
    </div>
    <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="COND. PAGO">
    </div>
    <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="FECHA">
    </div>
  </div>
  
  <div class="row mb-3">
    <div class="col-sm-12 col-md-3 mb-3 mb-md-0"></div>
    <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="CORREO">
    </div>
    <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="CONTACTO">
    </div>
    <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="TELEFONO">
    </div>
  </div>
  <hr>

  <div class="row mb-3">
    <div class="col-12 col-md-1 text-center">
      <strong>ITEM</strong>
    </div>
    <div class="col-12 col-md-1 text-center">
      <strong>CENTRO</strong>
    </div>
    <div class="col-12 col-md-5 text-center">
      <strong>DESCRIPCIÓN DEL SERVICIO</strong>
    </div>
    <div class="col-12 col-md-1 text-center">
      <strong>CANTIDAD PEDIDA</strong>
    </div>
    <div class="col-12 col-md-1 text-center">
      <strong>UNID.</strong>
    </div>
    <div class="col-12 col-md-1 text-center">
      <strong>PRECIO UNITARIO</strong>
    </div>
    <div class="col-12 col-md-2 text-center">
      <strong>IMPORTE TOTAL</strong>
    </div>
  </div>

  <div class="row mb-3">
    <div class="col-12 col-md-1 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="ITEM" disabled>
    </div>
    <div class="col-12 col-md-1 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="CENTRO">
    </div>
    <div class="col-12 col-md-5 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="DESCRIPCIÓN PRODUCTO">
    </div>
    <div class="col-12 col-md-1 mb-3 mb-md-0">
      <input type="text" class="form-control cantidad" placeholder="CANT">
    </div>
    <div class="col-12 col-md-1 mb-3 mb-md-0">
      <input type="text" class="form-control" placeholder="UNIDAD" disabled>
    </div>
    <div class="col-12 col-md-1 mb-3 mb-md-0">
      <input type="text" class="form-control precio" placeholder="PRECIO U.">
    </div>
    <div class="col-12 col-md-2 mb-3 mb-md-0">
      <input type="text" class="form-control importeTotal" placeholder="IMPORTE TOTAL" disabled>
    </div>
  </div>
  <hr>

  <!-- NUEVA FILA : Este div es para la nueva fila -->
  <div class="nueva_fila" id="nueva_fila">
    <div class="row mb-3">
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="text" class="form-control" placeholder="ITEM">
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="text" class="form-control" placeholder="CENTRO">
      </div>
      <div class="col-12 col-md-5 mb-3 mb-md-0">
        <input type="text" class="form-control" placeholder="DESCRIPCIÓN PRODUCTO">
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="text" class="form-control cantidad" placeholder="CANT">
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="text" class="form-control" placeholder="UNIDAD">
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="text" class="form-control precio" placeholder="PRECIO U.">
      </div>
      <div class="col-12 col-md-2 mb-3 mb-md-0">
        <input type="text" class="form-control importeTotal" placeholder="IMPORTE TOTAL" disabled>
      </div>
    </div>
  </div>
  <hr>

  <div class="row">
    <div class="col-12 col-md-5">
      <input type="text" class="form-control" placeholder="OBSERVACIONES">
    </div>
    <div class="col-12 col-md-4">
      <input type="text" class="form-control" placeholder="GRUPO DE COMPRA">
    </div>
    <div class="col-12 col-md-3">
      <div class="form-group row">
        <label for="subtotal" class="col-sm-4 col-form-label">SUBTOTAL:</label>
        <div class="col-sm-8">
          <input type="text" class="form-control mt-1" id="subtotal" placeholder="SUBTOTAL" disabled>
        </div>
      </div>
      <div class="form-group row">
        <label for="impuesto" class="col-sm-4 col-form-label">IMPUESTO:</label>
        <div class="col-sm-8">
          <input type="text" class="form-control mt-1" id="impuesto" placeholder="IMPUESTO">
        </div>
      </div>
      <div class="form-group row">
        <label for="descuento" class="col-sm-4 col-form-label">DESCUENTO:</label>
        <div class="col-sm-8">
          <input type="text" class="form-control mt-1" id="descuento" placeholder="DESCUENTO">
        </div>
      </div>
      <div class="form-group row">
        <label for="total" class="col-sm-4 col-form-label">TOTAL:</label>
        <div class="col-sm-8">
          <input type="text" class="form-control mt-1" id="total" placeholder="TOTAL" disabled>
        </div>
      </div>
    </div>
  </div>
</div>

<script>

  document.addEventListener('input', function(event) {
    if (event.target.classList.contains('cantidad') || event.target.classList.contains('precio')) {
      let row = event.target.closest('.row');
      let cantidad = parseFloat(row.querySelector('.cantidad').value) || 0;
      let precio = parseFloat(row.querySelector('.precio').value) || 0;
      let importeTotalField = row.querySelector('.importeTotal');
      
      let total = cantidad * precio;
      importeTotalField.value = total.toFixed(2);
      
      calcularTotales();
    }
  });

  function calcularTotales() {
    let subtotal = 0;
    document.querySelectorAll('.importeTotal').forEach(function(field) {
      subtotal += parseFloat(field.value) || 0;
    });

    document.getElementById('subtotal').value = subtotal.toFixed(2);

    let impuesto = parseFloat(document.getElementById('impuesto').value) || 0;
    let descuento = parseFloat(document.getElementById('descuento').value) || 0;

    let totalConImpuesto = subtotal + (subtotal * (impuesto / 100));
    let totalFinal = totalConImpuesto - descuento;

    document.getElementById('total').value = totalFinal.toFixed(2);
  }

  document.getElementById('impuesto').addEventListener('input', calcularTotales);
  document.getElementById('descuento').addEventListener('input', calcularTotales);
</script>

</body>
</html>
