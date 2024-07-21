<?php
  session_start(); // Crea o hereda la sesión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    include_once 'no_acceso.php';
    exit();
  }
?>
<?php require_once './navbar.php'; ?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generar Orden de Compra</title>
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="">

<div class="container mt-3" >
  <h3 class="text-center">GENERAR ORDEN DE COMPRA</h3>
</div>

<div class="">
  <div class="row mb-3 mx-1">
    
    <div class="col-md-4 d-flex justify-content-start">
      <input type="text" class="form-control " id="ruc_buscado" maxlength="11" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
      <button class="btn btn-primary" id="btnBuscar">Buscar</button>
      <button class="btn btn-warning ml-2" id="btnBuscarClienteSistema" data-bs-toggle="modal" data-bs-target="#modal-cliente"><i class="lni lni-users"></i></button>
    </div>

    <div class="col-md-4 d-flex justify-content-start">
    </div>

    <div class="col-md-4 d-flex">
    </div>


  </div>
</div>

<div class="mb-5  p-3 bg-body" id="div-1">
  <form action="" id="formulario-orden-pago">
    <div class="row mb-3">
      <div class="col-sm-12 col-md-5 mb-3 mb-md-0">
        <input type="text" class="form-control" id="razon_social" maxlength="60" placeholder="RAZON SOCIAL" disabled required>
      </div>
      <div class="col-sm-6 col-md-3 mb-3 mb-md-0">
        <input type="text" class="form-control" id="ruc" maxlength="11" placeholder="RUC" readonly required>
      </div>
      <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
        <select id="moneda" class="form-control" placeholder="MONEDA" required>
          <option value="">Moneda</option>
          <option value="soles">Soles</option>
          <option value="dolares">Dolares</option>
        </select>
      </div>
      <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
        <input type="number" class="form-control" id="nFactura" placeholder="N° FACTURA" disabled>
      </div>
    </div>
  
    <div class="row mb-3">
      <div class="col-sm-12 col-md-6 mb-3 mb-md-0">
        <input type="text" class="form-control" id="direccion" maxlength="60" placeholder="DIRECCION" required readonly>
      </div>
      <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
        <input type="tel" class="form-control" id="celular" maxlength="9" placeholder="CELULAR" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
      </div>
      <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
        <select type="text" class="form-control" id="condPago" placeholder="COND. PAGO" required>
          <option value="">COND. PAGO</option>
          <option value="contado">Contado</option>
          <option value="7 días">7 días</option>
          <option value="15 días">15 días</option>
          <option value="30 días">30 días</option>
        </select>
      </div>
      <div class="col-sm-6 col-md-2 mb-3 mb-md-0">
        <input type="date" class="form-control" id="fechaInput" placeholder="FECHA" required>
      </div>
    </div>
  
    <div class="row mb-3">
      <div class="col-sm-12 col-md-3 mb-3 mb-md-0"></div>
      <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
        <input type="text" class="form-control" id="correo" maxlength="40" placeholder="CORREO">
      </div>
      <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
        <input type="text" class="form-control" id="contacto" maxlength="40" placeholder="CONTACTO">
      </div>
      <div class="col-sm-12 col-md-3 mb-3 mb-md-0">
        <input type="tel" maxlength="12" id="telefono" class="form-control" placeholder="TELEFONO" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
      </div>
    </div>
    <hr>

    <div class="row mb-3">
      <div class="col-12 col-md-1 text-center">
        <strong>ITEM</strong>
      </div>
      <div class="col-12 col-md-1 text-center">
        <strong>CENTRO</strong>
      </div>
      <div class="col-12 col-md-4 text-center">
        <strong>DESCRIPCIÓN DEL SERVICIO</strong>
      </div>
      <div class="col-12 col-md-1 text-center">
        <strong>CANTIDAD PEDIDA</strong>
      </div>
      <div class="col-12 col-md-1 text-center">
        <strong>UNID.</strong>
      </div>
      <div class="col-12 col-md-1 text-center">
        <strong>PRECIO UNITARIO</strong>
      </div>
      <div class="col-12 col-md-2 text-center">
        <strong>IMPORTE TOTAL</strong>
      </div>
      <div class="col-12 col-md-1 text-center">
        <button type="button" id="renderizar-fila" class="btn-success btn-sm btn mb-3"><i class="lni lni-plus"></i> </button> 
      </div>
    </div>
  

    <!-- NUEVA FILA : Este div es para la nueva fila -->
    <div class="nueva_fila" id="nueva_fila">
      <div class="row mb-3">
        <div class="col-12 col-md-1 mb-3 mb-md-0">
          <input type="number" class="form-control" value="1" name="item" placeholder="ITEM" readonly>
        </div>
        <div class="col-12 col-md-1 mb-3 mb-md-0">
          <input type="tel" class="form-control" name="centro" maxlength="10" min="0"  placeholder="CENTRO" required oninput="this.value = this.value.replace(/[^0-9]/g, '');">
        </div>
        <div class="col-12 col-md-4 mb-3 mb-md-0">
          <input type="text" class="form-control" name="descripcionProducto" maxlength="60" placeholder="DESCRIPCIÓN PRODUCTO" required>
        </div>
        <div class="col-12 col-md-1 mb-3 mb-md-0">
          <input type="tel" class="form-control cantidad" name="cantidad" maxlength="15" min="1"  placeholder="CANT" oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
        </div>
        <div class="col-12 col-md-1 mb-3 mb-md-0">
          <select type="text" class="form-control" name="unidad" required>
            <option value="">-----</option>
            <option value="KG">KG</option>
            <option value="LT">Lt</option>
            <option value="UNID">UNID</option>
          </select>
        </div>
        <div class="col-12 col-md-1 mb-3 mb-md-0">
          <input type="tel" class="form-control precio" name="precio" maxlength="15" placeholder="PRECIO U." oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
        </div>
        <div class="col-12 col-md-2 mb-3 mb-md-0">
          <input type="text" class="form-control importeTotal" name="importeTotal" placeholder="IMPORTE TOTAL" disabled>
        </div>
        <div class="col-12 col-md-1 mb-3 mb-md-0">
        </div>
      </div>
    </div>
  
  
    <hr>
    <div class="row">
      
      <div class="col-12 col-md-9">
        <input type="text" class="form-control" id="observaciones" maxlength="50" placeholder="OBSERVACIONES">
        <input type="text" class="form-control mt-3" id="destino"  maxlength="60" placeholder="DESTINO">

      </div>



      <div class="col-12 col-md-3">
        <div class="form-group row">
          <label for="subtotal" class="col-sm-4 col-form-label">SUBTOTAL:</label>
          <div class="col-sm-8">
            <input type="text" class="form-control mt-1" id="subtotal" placeholder="SUBTOTAL" disabled>
          </div>
        </div>
        <div class="form-group row">
          <label for="impuesto" class="col-sm-4 col-form-label">IMPUESTO:</label>
          <div class="col-sm-8">
            <input type="text" class="form-control mt-1" id="impuesto" placeholder="IMPUESTO" readonly>
          </div>
        </div>
        <div class="form-group row">
          <label for="descuento" class="col-sm-4 col-form-label">DESCUENTO:</label>
          <div class="col-sm-8">
            <input type="number" class="form-control mt-1" value="0" id="descuento" placeholder="DESCUENTO" min="0" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
          </div>
        </div>
        <div class="form-group row">
          <label for="total" class="col-sm-4 col-form-label">TOTAL:</label>
          <div class="col-sm-8">
            <input type="text" class="form-control mt-1" id="total" placeholder="TOTAL" disabled>
          </div>
        </div>
        
        <div class="row">
          <button type="button " class="btn btn-success flex-fill" id="finalizarOrdenCompra">Finalzar</button>
        </div>
      </div>
    </div>

  </form>
</div>

<!-- modal7 -->

<div class="modal fade" id="modal-cliente" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="exampleModalLabel">Seleccionar Cliente</h1>
      </div>
      <div class="modal-body">
        
        <div class="list-group" id="contenedor-clientes" role="tablist">

        </div>
        

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary flex-fill" data-bs-dismiss="modal">Cerrar</button>
        <button type="button" id="btnSeleccionar" class="btn btn-primary flex-fill">Seleccionar</button>
      </div>
    </div>
  </div>
</div>

<script src="../Js/buscar_ruc_api.js"></script>
<script>

  // Instanciamos Elementos
  destino.value = 'CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA';
  const fechaInput = document.getElementById('fechaInput');
  const btnRenderizarFila = document.getElementById("renderizar-fila");
  const btnBuscarClienteSistema = document.getElementById("btnBuscarClienteSistema");
  const btnSeleccionar = document.getElementById("btnSeleccionar");
  const btnFinalizarOrdenCompra = document.getElementById("finalizarOrdenCompra");
  const modalvisor = new bootstrap.Modal(document.getElementById('modal-cliente'));
  const formOrdePago = document.getElementById('formulario-orden-pago');


  function editar_cliente_existe(idcliente){
    const parametros = new FormData();
    parametros.append("operacion","editar_cliente_orden_compra")
    parametros.append("idcliente",idcliente)
    parametros.append("celular", celular.value)
    parametros.append("correo", correo.value)
    parametros.append("contacto", contacto.value)
    parametros.append("telefono", telefono.value)

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
    .then(res => res.json())
    .then(data => {
      console.log("Actualizado")
    })
    .catch((error) => {
        console.log(error);
    });
  }


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
    let descuento_verificado = descuento.value;
    if (descuento_verificado == null || descuento_verificado == ''){
      descuento_verificado = 0;
    }
    const parametros = new FormData();
    parametros.append("operacion","crear_orden_compra")
    parametros.append("iddetalleusuario", 1)
    parametros.append("cliente", ruc.value)
    parametros.append("moneda", moneda.value)
    parametros.append("fechaCreacion", fechaInput.value)
    parametros.append("descuento", descuento_verificado)
    // parametros.append("grupoCompra", grupoCompra.value)
    parametros.append("destino", destino.value)
    parametros.append("observaciones", observaciones.value)
    parametros.append("condicionpago", condPago.value)
    parametros.append("celular", celular.value)
    parametros.append("telefono", telefono.value)
    parametros.append("contacto", contacto.value)
    parametros.append("correo", correo.value)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        if(datos.idordencompra !== null && datos.idordencompra !== "" && datos.idordencompra !== 0){
          console.log("se registro una orden nueva")
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
        console.log("se registro un detalle nuevo")

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
          editar_cliente_existe(IDcliente)
          registrarOrdenCompra();

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

    // window.location.href = `../reports/pdf_orden_compra.php?idordencompra=${nordecompra}`

    bienvenida(`¡Se ha creado una nueva orden de compra!`);
    setTimeout(function(){
      window.open(`../reports/pdf_orden_compra.php?idordencompra=${nordecompra}`, '_blank');
      formOrdePago.reset();
      location.reload();
      
    },2000);  


  }


  btnFinalizarOrdenCompra.addEventListener("click",function(event){
    // console.log("fok")
    // console.log("DSasd")
    if (!formOrdePago.checkValidity()) {
      return;
    }
    
    event.preventDefault();
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
        <input type="tel" class="form-control" name="centro" maxlength="10" placeholder="CENTRO" required oninput="this.value = this.value.replace(/[^0-9]/g, '');">
      </div>
      <div class="col-12 col-md-4 mb-3 mb-md-0">
        <input type="text" class="form-control" name="descripcionProducto" maxlength="60" placeholder="DESCRIPCIÓN PRODUCTO" required>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <input type="tel" class="form-control cantidad" name="cantidad" maxlength="15" placeholder="CANT" oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
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
        <input type="tel" class="form-control precio" name="precio" maxlength="15" placeholder="PRECIO U." oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
      </div>
      <div class="col-12 col-md-2 mb-3 mb-md-0">
        <input type="text" class="form-control importeTotal" name="importeTotal" placeholder="IMPORTE TOTAL" disabled>
      </div>
      <div class="col-12 col-md-1 mb-3 mb-md-0">
        <button type="button" class="btn btn-close btn-danger" onclick="eliminarFila('fila-${indiceFila}')"><i class="bi bi-trash-fill"></i></button>
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
        contacto.value = datos.contacto;
        celular.value = datos.celular;
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

  // Total - descuento
  document.addEventListener('input', function(event) {
     
    if (event.target.classList.contains('cantidad') || event.target.classList.contains('precio')) {
      let row = event.target.closest('.row');
      let cantidad = parseFloat(row.querySelector('.cantidad').value) || 0;
      let precio = parseFloat(row.querySelector('.precio').value) || 0;
      let importeTotalField = row.querySelector('.importeTotal');
      
      let total = cantidad * precio;
      importeTotalField.value = total.toFixed(2);
      calcularTotales();
    }
  });

  function calcularTotales() {
    let subtotal = 0;
    document.querySelectorAll('.importeTotal').forEach(function(field) {
      subtotal += parseFloat(field.value) || 0;
    });

    subtotal_p = document.getElementById('subtotal').value = subtotal.toFixed(2);
    impuesto_f = subtotal * 0.18;

    document.getElementById('impuesto').value = impuesto_f.toFixed(2);
    let descuento = parseFloat(document.getElementById('descuento').value) || 0;

    const max = document.getElementById('descuento');

    let totalConImpuesto = subtotal + impuesto_f;
    max.setAttribute("max", totalConImpuesto);

    let totalFinal = totalConImpuesto - descuento;


    document.getElementById('total').value = totalFinal.toFixed(2);
  }

  function editar_cliente_existe(idcliente){
    const parametros = new FormData();
    parametros.append("operacion","")
    parametros.append("celular", celular.value)
    parametros.append("correo", correo.value)
    parametros.append("contacto", contacto.value)
    parametros.append("telefono", telefono.value)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
    })
    .then(res => res.json())
    .then(data => {
      console.log("Actualizado")
    })
    .catch((error) => {
        console.log(error);
    });
  }

  document.addEventListener('input', calcularTotales);
  document.getElementById('descuento').addEventListener('input', calcularTotales);
</script>

</body>
</html>
