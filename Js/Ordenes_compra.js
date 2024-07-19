
document.addEventListener("DOMContentLoaded", () => {
  const tabla = document.querySelector("#tabla-orden-compra tbody");
  const btnFechaFiltro = document.getElementById("fecha-filtrar");
  let rol_usuario = `<?php echo $idrol; ?>`

  function asignarFechaHoy(){
    const today = new Date();
    
    // Formatear la fecha en YYYY-MM-DD
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0'); // Los meses son de 0 a 11
    const day = String(today.getDate()).padStart(2, '0');
    let formattedDate = `${year}-${month}-${day}`;
    btnFechaFiltro.value = formattedDate
  }

  function obtenerOrdenesCompra(){
    let fecha = btnFechaFiltro.value
    let fechaSTR = String(fecha)
    let parametros = new FormData();
    parametros.append("operacion","listar_orden_rol")
    parametros.append("idrol", fecha)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
      })
      .then(res => res.json())
      .then(datos => {

        if(datos.length > 0){
            renderizarTabla(datos);
        }else{
            tabla.innerHTML = '';
            tabla.innerHTML = '<tr><td colspan="4" class="table-active">No se econtraron ordenes este día</td></tr>';

        }

      })
      .catch((error) => {
          console.log(error);
      });
  }

  function cambiarEstadoAceptado(idordencompra){
    let parametros = new FormData();
    parametros.append("operacion","cambiar_estado_aprobado")
    parametros.append("idordencompra",idordencompra)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
      })
      .then(res => res.json())
      .then(datos => {
        obtenerOrdenesCompra();
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function cambiarEstadoRechazado(idordencompra){
    let parametros = new FormData();
    parametros.append("operacion","cambiar_estado_rechazado")
    parametros.append("idordencompra",idordencompra)

    fetch(`../Controllers/ordencompra.controller.php`, {
      method: "POST",
      body: parametros
      })
      .then(res => res.json())
      .then(datos => {
        obtenerOrdenesCompra();
      })
      .catch((error) => {
          console.log(error);
      });
  }

  function renderizarTabla(datos) {
    let numFila = 1;
    let html = '';
    tabla.innerHTML = '';
    let verificar = '';
    datos.forEach(dato => {

        if (usuario == 1) {
            if (dato.estado == 1) {
                verificar = `
                    <button class="btn btn-success confirmar" data-id="${dato.idordencompra}"><i class="lni lni-checkmark-circle"></i></button>
                    <button class="btn btn-warning editar" data-id="${dato.idordencompra}"><i class="lni lni-pencil"></i></button>
                    <button class="btn btn-danger rechazar" data-id="${dato.idordencompra}"><i class="lni lni-trash-can"></i></button>
                `;
            } else if (dato.estado == 2) {
                verificar = `
                    <button class="btn btn-success aceptado" data-id="${dato.idordencompra}">Aceptado</button>
                `;
            } else if (dato.estado == 0) {
                verificar = `
                    <button class="btn btn-danger rechazado" data-id="${dato.idordencompra}">Rechazado</button>
                `;
            }
        } else if (usuario == 2) {
            if (dato.estado == 1) {
                verificar = `
                    <button class="btn btn-primary espera" data-id="${dato.idordencompra}">En espera</button>
                `;
            } else if (dato.estado == 2) {
                verificar = `
                    <button class="btn btn-success aceptado" data-id="${dato.idordencompra}">Aceptado</button>
                `;
            } else if (dato.estado == 0) {
                verificar = `
                    <button class="btn btn-danger rechazado" data-id="${dato.idordencompra}">Rechazado</button>
                `;
            }
        }

        html += `
            <tr>
                <td>${numFila}</td>
                <td>${dato.razonSocial}</td>
                <td>${dato.fechaCreacion}</td>
                <td d-flex justify-content-around>${verificar}</td>
            </tr>
        `;
        numFila++;
      });

      tabla.innerHTML += html;

      const btnAceptar = document.querySelectorAll(".confirmar");
      const btnRechazar = document.querySelectorAll(".rechazar");
  
      btnAceptar.forEach(function(boton) {
        boton.addEventListener("click", function(event) {
          let id = event.currentTarget.dataset.id;
          cambiarEstadoAceptado(id);    
        });
      });

      btnRechazar.forEach(function(boton) {
        boton.addEventListener("click", function(event) {
          let id = event.currentTarget.dataset.id;
          PreguntarEliminar(function(){
              cambiarEstadoRechazado(id);
          })
        });
      });
      
  }

  btnFechaFiltro.addEventListener("change",function(){
    obtenerOrdenesCompra()
  });
 

  asignarFechaHoy()
  obtenerOrdenesCompra();

})
