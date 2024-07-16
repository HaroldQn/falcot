<?php require_once './navbar.php'; ?>
<h1 class="text-center">Clientes </h1>

<div class="container container-sm">
  <button type="button" class="btn btn-success mb-3" id="crear-usuario" data-bs-toggle="modal" data-bs-target="#modal-cliente">Agregar Cliente</button>

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
        <!-- <th scope="row">1</th>
        <td>a</td>
        <td>b</td>
        <td>@mdo</td>
        <td>@mdo</td>
        <td>
          <button type="button" class="btn btn-sm btn-warning editar">Editar</button>
          <button type="button" class=" btn btn-sm btn-danger eliminar">Eliminar</button>
        </td> -->
      </tr>
    </tbody>
  </table>

</div>

<!-- Modal -->
<div class="modal fade" id="modal-cliente" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header text-center">
        <h1 class="modal-title " id="titulo-modal">Agregar nuevo cliente</h1>
      </div>
      <form action="" id="form-modal" autocomplete="off">
        <div class="modal-body">

            <label for="razonSocial" class="form-label">Ingrese Razon social</label>
            <input type="text" class="form-control" id="razonSocial" maxlength="60" required>

            <div class="row">
              <div class="col col-md-6">
                <label for="actividadEconomica" class="form-label">Actividad Economica</label>
                <input type="text" class="form-control mb-1" id="actividadEconomica" maxlength="60">
              </div>

              <div class="col col-md-6">
                <label for="correo" class="form-label">Correo</label>
                <input type="text" class="form-control mb-1" id="correo" maxlength="30">
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-6">             
                <label for="numeroDoc" class="form-label">Ingrese NumeroDoc</label>
                <input type="number" class="form-control" id="numeroDoc" required>
              </div>
              <div class="col col-sm-6">
                <label for="direccion" class="form-label">Ingrese direccion</label>
                <input type="text" class="form-control mb-1" id="direccion" maxlength="60" required>
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-4">
                <label for="departamento" class="form-label">Departamento</label>
                <select name="departamento" class="form-control" id="departamento" required> 
                  <option value="">Seleccione</option>
                </select>
              </div>
              <div class="col col-sm-4">
                <label for="provincia" class="form-label">Provincia</label>
                <select name="provincia" class="form-control" id="provincia" required>
                  <option value="1">Seleccione</option>
                </select>
              </div>
              <div class="col col-sm-4">
                <label for="distrito" class="form-label">Distrito</label>
                <select name="distrito" class="form-control" id="distrito" required>
                  <option value="1">Seleccione</option>
                </select>
              </div>
            </div>

            <div class="row mb-2">
              <div class="col col-sm-6">
                <label for="telefono" class="form-label">Telefono</label>
                <input type="number" class="form-control mb-1" id="telefono">
              </div>

              <div class="col col-sm-6">
                <label for="ubigeo" class="form-label">Ubigeo</label>
                <input type="text" class="form-control mb-1" id="ubigeo" maxlength="60">
              </div>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary flex-fill" data-bs-dismiss="modal">cerrar</button>
            <button type="submit" id="btnGuardar" class="btn btn-primary flex-fill">Guardar</button>
          </div>
        </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
  document.addEventListener("DOMContentLoaded", () => {
    const tabla = document.querySelector("#tabla-cliente tbody");
    const selectDepartamento = document.getElementById("departamento");
    const selectProvincia = document.getElementById("provincia");
    const selectDistrito = document.getElementById("distrito");
    const crearUsuario = document.getElementById("crear-usuario");
    const formulario = document.getElementById("form-modal");
    const btnGuardar = document.getElementById("btnGuardar");
    const modalvisor = new bootstrap.Modal(document.getElementById('modal-cliente'));

    // varible bandera y el id del cliente
    let bandera = true
    let IDcliente = 0;


    // Funciones para traer y renderizar los datos de las regiones
    function obtenerDepartamentos(){
      let parametros = new FormData();
      parametros.append("operacion","listar_departamentos")

      fetch(`../Controllers/region.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          //  console.log(datos)   

           datos.forEach(dato => {
            const option = document.createElement('option');
            option.value = dato.iddepartamento;
            option.textContent = dato.departamento;
            selectDepartamento.appendChild(option);
          });
        })
        .catch((error) => {
            console.log(error);
        });
    }

    function obtenerProvincias(id){
      let parametros = new FormData();
      parametros.append("operacion","listar_provincias")
      parametros.append("iddepartamento",id)

      fetch(`../Controllers/region.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          //  console.log(datos)   
          
           selectProvincia.innerHTML=""
           datos.forEach(dato => {
            const option = document.createElement('option');
            option.value = dato.idprovincia;
            option.textContent = dato.provincia;
            selectProvincia.appendChild(option);
          });
        })
        .catch((error) => {
            console.log(error);
        });
    }

    function obtenerDistritos(id){
      let parametros = new FormData();
      parametros.append("operacion","listar_distritos")
      parametros.append("idprovincia",id)

      fetch(`../Controllers/region.controller.php`, {
        method: "POST",
        body: parametros
      })
      .then(res => res.json())
      .then(datos => {
          // console.log(datos)   
        
          selectDistrito.innerHTML=""
          datos.forEach(dato => {
          const option = document.createElement('option');
          option.value = dato.iddistrito;
          option.textContent = dato.distrito;
          selectDistrito.appendChild(option);
        });
      })
      .catch((error) => {
          console.log(error);
      });
    }
  
    function renderizarDistrito(idprovincia, iddistrito){
      let parametros = new FormData();
      parametros.append("operacion","listar_distritos")
      parametros.append("idprovincia",idprovincia)

      fetch(`../Controllers/region.controller.php`, {
        method: "POST",
        body: parametros
      })
      .then(res => res.json())
      .then(datos => {
          // console.log(datos)   
        
          selectDistrito.innerHTML=""
          datos.forEach(dato => {
          const option = document.createElement('option');
          option.value = dato.iddistrito;
          option.textContent = dato.distrito;

          if (dato.iddistrito === iddistrito) {
            option.selected = true;
          }

          selectDistrito.appendChild(option);
        });
      })
      .catch((error) => {
          console.log(error);
      });
    }

    selectDepartamento.addEventListener("change",function (event){
      let idprovincia = selectDepartamento.value;
      obtenerProvincias(idprovincia)
    })

    selectProvincia.addEventListener("change",function (event){
      let iddistrito = selectProvincia.value;
      obtenerDistritos(iddistrito)
    })

    // Funciones de Cliente
    function obtenerClientes(idcliente){
      const parametros = new FormData();
      parametros.append("operacion","listar_clientes")

      fetch(`../Controllers/cliente.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          //  console.log(datos)
           renderizarTabla(datos)
   
        })
        .catch((error) => {
            console.log(error);
        });
    }

    function renderizarTabla(datos){
      let numFila = 1;
      tabla.innerHTML = '';
      datos.forEach(registro => {
          let nuevafila =``;
          nuevafila = `
              <tr>
                  <td>${numFila}</td>
                  <td>${registro.razonSocial}</td>
                  <td>${registro.nroDocumento}</td>
                  <td>${registro.direccion}</td>
                  <td>${registro.telefono}</td>
                  <td>
                      <button class="btn btn-warning editar" data-id=${registro.idempresacliente} data-bs-toggle="modal" data-bs-target="#modal-cliente"><i class="lni lni-pencil"></i></button>
                      <button class="btn btn-danger eliminar" data-id=${registro.idempresacliente}><i class="lni lni-trash-can"></i></button>
                  </td>
              </tr>
          `;
          tabla.innerHTML += nuevafila;
          numFila++;
      });

      const btnModificar = document.querySelectorAll(".editar");
      const btnEliminar = document.querySelectorAll(".eliminar");

      btnEliminar.forEach(function(boton) {
        boton.addEventListener("click", function(event) {
          let id = event.currentTarget.dataset.id;
          console.log(id);
        });
      });

      btnModificar.forEach(function(boton) {
        boton.addEventListener("click", function(event) {
          bandera = false
          let id = event.currentTarget.dataset.id;
          IDcliente = id;
          obtenerClientePorId(id)
        });
      });

    }

    function obtenerClientePorId(idcliente){
      const parametros = new FormData();
      parametros.append("operacion","listar_clientes_id")
      parametros.append("idempresacliente", idcliente)

      fetch(`../Controllers/cliente.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          console.log(datos)
          razonSocial.value = datos.razonSocial;
          actividadEconomica.value = datos.actividadEconomica;
          correo.value = datos.correo;
          numeroDoc.value = datos.nroDocumento;
          direccion.value = datos.direccion;
          telefono.value = datos.telefono;
          ubigeo.value = datos.ubigeo;
          selectDepartamento.value = datos.iddepartamento;
          obtenerProvincias(datos.iddepartamento);
          obtenerDistritos(datos.idprovincia);
          renderizarDistrito(datos.idprovincia,datos.iddistrito);

        })
        .catch((error) => {
            console.log(error);
        });
    }

    function registrarCliente(){
      const parametros = new FormData();
      parametros.append("operacion","registrar_clientes")
      parametros.append("razonSocial",razonSocial.value)
      parametros.append("nroDocumento",numeroDoc.value)
      parametros.append("direccion",direccion.value)
      parametros.append("correo", correo.value)
      parametros.append("iddistrito",distrito.value)
      parametros.append("ubigeo",ubigeo.value)
      parametros.append("actividadEconomica",actividadEconomica.value)
      parametros.append("telefono",telefono.value)

      fetch(`../Controllers/cliente.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          //  console.log(datos)
           obtenerClientes()   
        })
        .catch((error) => {
            console.log(error);
        });
    }

    function editarCliente(id){
      const parametros = new FormData();
      parametros.append("operacion","editar_clientes")
      parametros.append("idempresacliente", id)
      parametros.append("razonSocial",razonSocial.value)
      parametros.append("nroDocumento",numeroDoc.value)
      parametros.append("direccion",direccion.value)
      parametros.append("correo", correo.value)
      parametros.append("iddistrito",distrito.value)
      parametros.append("ubigeo",ubigeo.value)
      parametros.append("actividadEconomica",actividadEconomica.value)
      parametros.append("telefono",telefono.value)

      fetch(`../Controllers/cliente.controller.php`, {
        method: "POST",
        body: parametros
      })
        .then(res => res.json())
        .then(datos => {
          obtenerClientes();
        })
        .catch((error) => {
            console.log(error);
        });
    }

    crearUsuario.addEventListener("click", function(){
      bandera = true
      formulario.reset();
    });

    btnGuardar.addEventListener("click", function(){
      if (!formulario.checkValidity()) {
        return;
      }

      if(bandera){
        registrarCliente();
        modalvisor.hide();
        
      }else{
        // console.log("bandera FALSE")
        // console.log(IDcliente)
        editarCliente(IDcliente)
      }
    })


    obtenerDepartamentos();
    obtenerClientes();

  })
</script>
</body>
</html>
