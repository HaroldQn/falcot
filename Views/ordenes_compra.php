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
    
  </div>
</body>
</html>