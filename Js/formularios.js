const fechaInput = document.getElementById('fechaInput');
  const btnRenderizarFila = document.getElementById("renderizar-fila");
  const btnBuscarClienteSistema = document.getElementById("btnBuscarClienteSistema");
  const btnSeleccionar = document.getElementById("btnSeleccionar");
  const btnFinalizarOrdenCompra = document.getElementById("finalizarOrdenCompra");
  const modalvisor = new bootstrap.Modal(document.getElementById('modal-cliente'));
  const formOrdePago = new bootstrap.Modal(document.getElementById('formulario-orden-pago'));

  function registrarClienteApi(){
    const parametros = new FormData();
    parametros.append("operacion","registrar_clientes_api")
    parametros.append("razonSocial", razon_social.value)
    parametros.append("nroDocumento", ruc.value)
    parametros.append("direccion", direccion.value)
    parametros.append("correo", correo.value)
    parametros.append("contacto", contacto.value)
    parametros.append("celular", celular.value)
    parametros.append("iddistrito", distrito_cli)
    parametros.append("ubigeo", ubigeo_cli)
    parametros.append("telefono", telefono.value)

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)
        if(datos.idcliente !== null && datos.idcliente !== "" && datos.idcliente !== 0){
          bienvenida(`¡Se ha registrado un nuevo usuario!`);
          setTimeout(function(){
            registrarOrdenCompra();
          },2000);  

        }else{
          //mostrar error
          console.log("Error al registrar al nuevo cliente")
        }
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function registrarOrdenCompra(){
  
    const parametros = new FormData();
    parametros.append("operacion","crear_orden_compra")
    parametros.append("iddetalleusuario", 1)
    parametros.append("cliente", ruc.value)
    parametros.append("moneda", moneda.value)
    parametros.append("fechaCreacion", fechaInput.value)
    parametros.append("descuento", descuento.value)
    parametros.append("grupoCompra", grupoCompra.value)
    parametros.append("destino", destino.value)
    parametros.append("observaciones", observaciones.value)
    parametros.append("condicionpago", condPago.value)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)
        if(datos.idordencompra !== null && datos.idordencompra !== "" && datos.idordencompra !== 0){
          traerDetalleFormularioOrdenCompra(datos.idordencompra)
        }else{

        }
        
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function registrarDetalleOrdenCompra(idcompra, item, centro, descripcion, cantidad, utm, precio){
    const parametros = new FormData();
    parametros.append("operacion","crear_detalle_orden_compra")
    parametros.append("idordencompra", idcompra)
    parametros.append("item", item)
    parametros.append("centro", centro)
    parametros.append("descripcion", descripcion)
    parametros.append("cantidad", cantidad)
    parametros.append("utm", utm)
    parametros.append("precioUnitario", precio)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)

      })
      .catch((error) => {
          console.log(error);
      });
  }

  function verificarClienteExiste(ruc){
    const parametros = new FormData();
    parametros.append("operacion","verificar_cliente")
    parametros.append("ruc", ruc)

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)
        if(datos.exists == 1){
          console.log("el registro existe")
          registrarOrdenCompra()

        }else if(datos.exists == 0){
          "el registro no existe"
          registrarClienteApi();

        }
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function traerDetalleFormularioOrdenCompra(nordecompra){
    const rows = document.querySelectorAll('#nueva_fila .row');
    
    rows.forEach(row => {
      // Obtener los valores de los inputs dentro de cada row
      const item = row.querySelector('input[name="item"]').value;
      const centro = row.querySelector('input[name="centro"]').value;
      const descripcionProducto = row.querySelector('input[name="descripcionProducto"]').value;
      const cantidad = row.querySelector('input[name="cantidad"]').value;
      const unidad = row.querySelector('select[name="unidad"]').value;
      const precio = row.querySelector('input[name="precio"]').value;

      registrarDetalleOrdenCompra(nordecompra, item, centro, descripcionProducto, cantidad, unidad, precio)

    });
  }


  btnFinalizarOrdenCompra.addEventListener("click",function(){

    // if (!formOrdePago.checkValidity()) {
    //   return;
    // }

    let doc_empresa = "";
    doc_empresa = ruc.value;
    verificarClienteExiste(doc_empresa)
    
  });


  // Creamos Variables
  let fechaActual ='';
  let indiceFila = 0;
  let IDcliente = 0;

  // Asignamos Fecha de hoy
  fechaActual = new Date();
  const year = fechaActual.getFullYear();
  const month = String(fechaActual.getMonth() + 1).padStart(2, '0'); 
  const day = String(fechaActual.getDate()).padStart(2, '0');
  const fechaFormateada = `${year}-${month}-${day}`;
  fechaInput.value = fechaFormateada;

  // Renderizar Inputs 
  function rederizarInputs(indiceFila){
    const contenedor = document.getElementById("nueva_fila");

    let nuevaFila = document.createElement('div');
    nuevaFila.classList.add('row', 'mb-3');
    nuevaFila.id = `fila-${indiceFila}`;
    nuevaFila.innerHTML = `
      <div div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="number" class="form-control" name="item" placeholder="ITEM" disabled>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="tel" class="form-control" name="centro" maxlength="10" placeholder="CENTRO" required>
      </div>
      <div class="col-12 col-md-4 mb-3 mb-md-0">
        <input type="text" class="form-control" name="descripcionProducto" maxlength="60" placeholder="DESCRIPCIÓN PRODUCTO" required>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="tel" class="form-control cantidad" name="cantidad" maxlength="15" placeholder="CANT" required>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <select type="text" class="form-control" name="unidad" required>
          <option value="">-----</option>
          <option value="KG">KG</option>
          <option value="L">L</option>
          <option value="UNID">UNID</option>
        </select>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="tel" class="form-control precio" name="precio" maxlength="15" placeholder="PRECIO U." required>
      </div>
      <div class="col-12 col-md-2 mb-3 mb-md-0">
        <input type="text" class="form-control importeTotal" name="importeTotal" placeholder="IMPORTE TOTAL" disabled>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <button type="button" class="btn-close" onclick="eliminarFila('fila-${indiceFila}')"></button>
      </div>
    `;
    
    contenedor.appendChild(nuevaFila);

    const items = document.querySelectorAll('input[name="item"]');

    // Asigna valores consecutivos empezando desde 1
    items.forEach((item, index) => {
      item.value = index + 1;
    });

  }
  
  function eliminarFila(idFila) {
    let fila = document.getElementById(idFila);
    fila.remove();

    const items = document.querySelectorAll('input[name="item"]');
    items.forEach((item, index) => {
      item.value = index + 1;
    });

  }

  btnRenderizarFila.addEventListener("click", function(){
    indiceFila ++;
    console.log(indiceFila)
    rederizarInputs(indiceFila);
  });

  // CLIENTES
  function listarClienteSistema(){
    const parametros = new FormData();
    parametros.append("operacion","listar_clientes")

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
         console.log(datos)
         renderizarClientes(datos)
 
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function renderizarClientes(datos){

    let contenedor = document.getElementById("contenedor-clientes");

    let nuevaLista = '';
    datos.forEach(registro =>{
      nuevaLista = `
        <a class="list-group-item list-group-item-action" name="list-cliente" data-bs-toggle="list" data-id="${registro.idempresacliente}">${registro.razonSocial}</a>
        `;
        contenedor.innerHTML += nuevaLista;
      });

    var items = document.querySelectorAll('.list-group-item[name="list-cliente"]');

    items.forEach(function(item) {
      item.addEventListener('click', function(event) {
        var id = event.currentTarget.getAttribute('data-id');
        IDcliente = id;
        // Aquí puedes hacer lo que necesites con el ID
      });
    });



  }

  function asignarClienteInputs(idcliente){
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
        razon_social.value = datos.razonSocial;
        // actividadEconomica.value = datos.actividadEconomica;
        correo.value = datos.correo;
        ruc.value = datos.nroDocumento;
        direccion.value = datos.direccion;
        telefono.value = datos.telefono;
        // ubigeo.value = datos.ubigeo;
        // selectDepartamento.value = datos.iddepartamento;
        // obtenerProvincias(datos.iddepartamento);
        // obtenerDistritos(datos.idprovincia);
        // renderizarDistrito(datos.idprovincia,datos.iddistrito);

      })
      .catch((error) => {
          console.log(error);
      });
  }

  btnBuscarClienteSistema.addEventListener("click",function(){
    listarClienteSistema()
  });

  btnSeleccionar.addEventListener("click",function(){
    asignarClienteInputs(IDcliente);
    modalvisor.hide()
  });