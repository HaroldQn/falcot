<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Falcot</title>
    <!-- Bootstrap CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <link href="https://cdn.lineicons.com/4.0/lineicons.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Bootstrap JavaScript Libraries -->
    <script src="../Js/navbar.js"></script>
    <script src="../Js/sw.js"></script>
    
    <!-- Sweet Alert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body style="background-color:#E5E8E8" data-idusuario="<?php echo isset($_SESSION['idusuario']) ? $_SESSION['idusuario'] : ''; ?>">
    <div class="bg-dark">
        <nav class="navbar navbar-expand-sm navbar-light w-100">
            <a class="navbar-brand text-light" href="#"><strong>FalcotTechnology</strong> <?php echo ($_SESSION["nombres"] ." ".$_SESSION["apellidos"]);?></a>
            <button class="navbar-toggler bg-white" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon text-light"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item active">
                        <a class="nav-link text-light fw-bolder" href="./ordenes_compra.php"><strong>Lista de Ordenes</strong></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-light fw-bolder" href="./generar_orden_compra.php"><strong>Generar orden</strong></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-light fw-bolder" href="./clientes.php"><strong>Clientes</strong></a>
                    </li>
                    <?php if ($_SESSION['idrol'] == 1): ?> 
                    <li class="nav-item">
                        <a class="nav-link text-light fw-bolder" href="./usuarios.php"><strong>Usuarios</strong></a>
                    </li>
                    <?php endif; ?>
                    <li class="nav-item">
                        <a class="nav-link text-light fw-bolder" href="../Controllers/usuarioLogin.controller.php?operacion=destroy"><strong><i class="bi bi-box-arrow-left"></i></strong></a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>