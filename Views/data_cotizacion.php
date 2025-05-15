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
  <h3 class="text-center m-3">Datos de la cotizacion</h3>
  <div id="main"></div>
<script type="module" src="../Js/data_cotizacion.js"></script>
</body>

</html>