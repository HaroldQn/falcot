<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Bootstrap CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="./Css/login.css">
</head>
<body class="bg-dark">
    <div class="container d-flex justify-content-center align-items-center min-vh-100">
        <div class="card login-card">
            <h3 class="text-center">Iniciar Sesión</h3>
            <form autocomplete="off"> 
                <div class="form-group">
                    <input type="email" class="form-control" id="email" placeholder=" " required>
                    <label for="email">Nombre de usuario</label>
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" id="password" placeholder=" " required>
                    <label for="password">Contraseña</label>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Ingresar</button>
            </form>
        </div>
    </div>
    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
