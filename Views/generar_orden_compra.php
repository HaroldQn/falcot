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
</body>
</html>