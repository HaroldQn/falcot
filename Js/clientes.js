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
        eliminarCliente(id);
        // console.log(id);
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

  function eliminarCliente(idcliente){
    const parametros = new FormData();
    parametros.append("operacion","eliminar_cliente")
    parametros.append("idempresacliente", idcliente)

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
    if (!formulario.checkValidity()) { return; }
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