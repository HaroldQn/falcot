<?php require_once './navbar.php'; ?>
<h1 class="text-center">Clientes </h1>

<div class="container container-sm">
  <button type="button" class="btn btn-success mb-3">Agregar Cliente</button>
  <table class="table table-bordered text-center" id="tabla-cliente">
    <thead >
      <tr>
        <th scope="col">#</th>
        <th scope="col">Razon social</th>
        <th scope="col">Ruc</th>
        <th scope="col">Dirección</th>
        <th scope="col">Telefono</th>
        <th scope="col">Opciones</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th scope="row">1</th>
        <td>Mark sssassaasdadds</td>
        <td>Otto22222222</td>
        <td>@mdo</td>
        <td>@mdo</td>
        <td>
          <button type="button" data-id="${element.idusuario}" class="btn btn-sm btn-warning editar">Editar</button>
          <button type="button" data-id="${element.idusuario}" class="eliminar btn btn-sm btn-danger ">Eliminar</button>
        </td>

      </tr>
    </tbody>
  </table>
</div>
<script>
  document.addEventListener("DOMContentLoaded", () => {

    

  })
</script>
</body>
</html>
