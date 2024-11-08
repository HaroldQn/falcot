<?php
  session_start(); // Crea o hereda la sessión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    include_once 'no_acceso.php';
    exit();
  }
  $idrol = isset($_SESSION['idrol']) ? $_SESSION['idrol'] : '';
?>
<?php require_once './navbar.php'; ?>
<div class="container text-center mt-3">
  <h3>ORDENES DE COMPRA</h3>
</div>

<div class="container">
  <div class="row">
    <div class="col col-md-4">
      <label for="fecha-filtrar" class="form-label">Filtrar por fecha:</label>
      <input type="date" class="form-control" id="fecha-filtrar">
    </div>
    <div class="col col-md-4">
    </div>
    <div class="col col-md-4"></div>
  </div>
</div>

<div class="container mt-3">

  <table class="table table-sm table-bordered text-center" id="tabla-orden-compra">
    <thead class="table-dark" >
      <tr>
        <th scope="col" width="10%">N° OC</th>
        <th scope="col" width="45%">RAZON SOCIAL</th>
        <th scope="col" width="15%">RUC</th>
        <th scope="col" width="15%">FECHA CREACION</th>
        <th scope="col" width="15%">ACCIONES</th>
      </tr>
    </thead>
    <tbody>
      <!-- <tr>
        <th scope="row">1</th> 
        <td>empresa 1</td>
        <td>2024/04/32</td>
        <td>
          <button type="button" class="btn btn-sm btn-warning flex-fill editar">Editar</button>
          <button type="button" class=" btn btn-sm btn-danger  flex-fill eliminar">Eliminar</button>
        </td> 
      </tr> -->
    </tbody>
  </table>

</div>
<script src="../Js/sw.js"></script>
<script>
  let usuario = "<?php echo $idrol ?>"
</script>
<script src="../Js/Ordenes_compra.js"></script>
</body>
</html>