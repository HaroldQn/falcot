document.addEventListener("DOMContentLoaded", () => {
  const API = "../Controllers/requerimiento.controller.php";
  const tabla = document.getElementById("lista-requerimientos");
  const tabla_lista = document.getElementById("lista-det-requerimientos");
  const form = document.getElementById("form-modal");
  const modal = new bootstrap.Modal(document.getElementById("modal-requerimiento"));
  const contenedorDetalle = document.getElementById("list-detalle-render");
  const btnAbrirModal = document.getElementById("crear-requerimiento");

  async function listarRequerimientos() {
    try {
      const formData = new FormData();
      formData.append("operacion", "lista_requerimientos");

      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      const render = data
        .map(async ({ idrequerimiento, usuario, fecha, estado, motivo, observacion }) => {
          const ButtonEstado = await renderButon(idrequerimiento, estado);
          return `
            <tr data-id="${idrequerimiento}">
              <td>${idrequerimiento}</td>
              <td>${usuario}</td>
              <td>${fecha}</td>
              <td class="text-left">${motivo}</td>
              <td class="text-left" style="width: 10px;">${observacion}</td>
              <td>
                <button class="btn btn-dark ver-detalle" data-bs-toggle="modal" data-bs-target="#modal-requerimiento-list" data-id="${idrequerimiento}">
                  <i class="bi bi-eye-fill"></i>
                </button>
              </td>
              <td class="text-${estado === '0' ? 'primary' : estado === '1' ? 'muted' : 'danger'}">
                <strong>
                  ${estado === '0' ? 'En proceso' : estado === '1' ? 'En revision' : 'Anulado'}
                  
                </strong>
              </td>
              ${ButtonEstado}
            </tr>
          `;
        });
      const renderedRows = await Promise.all(render);
      tabla.innerHTML = renderedRows.join("");
    } catch (error) {
      console.log(error);
    }
  }

  async function renderButon(id, estado) {
    let button;
    if (estado === "1") {
      button = `
      <td>
        <div class="btn-group" role="group" aria-label="Basic mixed styles example">
          <button type="button" class="btn btn-danger anular-requerimiento" data-id="${id}">
            <i class="bi bi-trash-fill"></i>
          </button>
          <button type="button" class="btn btn-success proceso-requerimiento" data-id="${id}">
            <i class="bi bi-check2-circle"></i>
          </button>
        </div>
      </td>
      `;
    } else if (estado === "0") {
      button = `
      <td>
        <button class="btn btn-secondary toggle-options" data-id="${id}">
          <i class="bi bi-chevron-down"></i>
        </button>
      </td>
      `;
    } else {
      button = `
      <td>
        <button class="btn btn-secondary" disabled>
          <i class="bi bi-x-circle"></i>
        </button>
      </td>
      `;
    }

    return button;
  }

  async function verRequerimiento(id) {
    try {
      tabla_lista.innerHTML = "";
      const formData = new FormData();
      formData.append("operacion", "lista_det_requerimientos");
      formData.append("idrequerimiento", id);
      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      const renderListDet = data
        .map(({ item, cantidad }, index) => {
          return `
          <tr>
            <td>${index + 1}</td>
            <td>${item}</td>
            <td>${cantidad}</td>
          <tr>
        `;
        })
        .join("");
      tabla_lista.innerHTML = renderListDet;
    } catch (error) {
      console.log(error);
    }
  }

  function createRow() {
    const row = document.createElement("div");
    row.classList.add("input-group", "mt-2");
    row.innerHTML = `
      <input class="form-control" style="width: 65%;" type="text" name="requerimiento" placeholder="Requerimiento" maxlength="255" required>
      <input type="number" class="form-control" placeholder="Cantidad" name="cantidad" min="1" value="1">
      <button type="button" class="btn btn-danger eliminar-fila"><i class="bi bi-trash-fill"></i></button>
    `;
    contenedorDetalle.appendChild(row);
  }

  // Registro de datos 
  async function registrarRequerimiento() {
    const formData = new FormData();
    formData.append("operacion", "registrar_requerimiento");
    formData.append("motivo", form.motivo.value.trim() || "-----------------------------------");
    formData.append("observacion", form.observacion.value || "-----------------------------------");
    const res = await fetch(API, {
      method: "POST",
      body: formData,
    });
    const data = await res.json();
    const { idrequerimiento } = data;
    console.log(idrequerimiento);

    const filas = document.querySelectorAll(".input-group");
    const detalles = [...filas].map((fila) => {
      const item = fila.querySelector("[name='requerimiento']").value;
      const cantidad = fila.querySelector("[name='cantidad']").value || 1;
      console.log(item, cantidad);
      registrarDetRequerimiento(idrequerimiento, item, cantidad);
    });

    await Promise.all(detalles);
    listarRequerimientos();
    modal.hide();
  }

  async function registrarDetRequerimiento(idrequerimiento, item, cantidad) {
    console.log(idrequerimiento, item, cantidad);
    const formData = new FormData();
    formData.append("operacion", "registrar_det_requerimiento");
    formData.append("idrequerimiento", idrequerimiento);
    formData.append("item", item);
    formData.append("cantidad", cantidad);
    const res = await fetch(API, {
      method: "POST",
      body: formData,
    });
    const data = await res.json();
    console.log(data);
  }

  async function actualizarFilaRequerimiento(idRequerimiento) {
    try {
      const formData = new FormData();
      formData.append("operacion", "lista_requerimientos");

      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();

      // Buscar el registro actualizado
      const registroActualizado = data.find((req) => req.idrequerimiento === idRequerimiento);

      if (registroActualizado) {
        // Renderizar la fila actualizada
        const ButtonEstado = await renderButon(registroActualizado.idrequerimiento, registroActualizado.estado);
        const nuevaFila = `
          <td>${registroActualizado.idrequerimiento}</td>
          <td>${registroActualizado.usuario}</td>
          <td>${registroActualizado.fecha}</td>
          <td class="text-left">${registroActualizado.motivo}</td>
          <td class="text-left" style="width: 10px;">${registroActualizado.observacion}</td>
          <td>
            <button class="btn btn-dark ver-detalle" data-bs-toggle="modal" data-bs-target="#modal-requerimiento-list" data-id="${registroActualizado.idrequerimiento}">
              <i class="bi bi-eye-fill"></i>
            </button>
          </td>
          <td class="text-${registroActualizado.estado === '0' ? 'success' : 'muted'}">
            <strong>
              ${registroActualizado.estado === '0' ? 'Aprobado' : 'Pendiente'}
            </strong>
          </td>
          ${ButtonEstado}
        `;

        // Actualizar la fila en la tabla
        const fila = document.querySelector(`tr[data-id="${idRequerimiento}"]`);
        if (fila) {
          fila.innerHTML = nuevaFila;
        }
      }
    } catch (error) {
      console.error("Error al actualizar la fila:", error);
    }
  }

  async function renderizarCotizaciones(idRequerimiento) {
    try {
      const formData = new FormData();
      formData.append("operacion", "lista_cotizaciones_proveedores");
      formData.append("idrequerimiento", idRequerimiento);

      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();

      // Buscar el contenedor de las cotizaciones para este registro
      const contenedorCotizaciones = document.querySelector(`#options-${idRequerimiento} tbody`);

      if (data.length > 0) {
        const renderListDet = data
          .map(({ fecha, ruta_pdf, precio_total }) => {
            const nombreArchivo = ruta_pdf.substring(0, ruta_pdf.lastIndexOf('.'));
            return `
              <tr>
                <td>${fecha}</td>
                <td><a href="../pdf_cot/${ruta_pdf}" target="_blank">${nombreArchivo}</a></td>
                <td>${precio_total}</td>
                <td>
                  <button type="button" class="btn btn-danger eliminar-cotizacion" data-id="${idRequerimiento}">
                    <i class="bi bi-trash-fill"></i>
                  </button>
                </td>
              </tr>
            `;
          })
          .join("");
        contenedorCotizaciones.innerHTML = renderListDet;
      } else {
        contenedorCotizaciones.innerHTML = `
          <tr>
            <td colspan="4" style="text-align: center;">No hay cotizaciones registradas</td>
          </tr>
        `;
      }
    } catch (error) {
      console.error("Error al renderizar las cotizaciones:", error);
    }
  }

  // Eventos

  tabla.addEventListener("click", (e) => {
    if (e.target.closest(".anular-requerimiento")) {
      const button = e.target.closest(".anular-requerimiento");
      const id = button.dataset.id;
      cambiarEstadoRequerimiento(id, "2"); // Cambiar el estado a "2" (anulado)
    }
  
    // Verificar si se hizo clic en el botón "proceso-requerimiento"
    if (e.target.closest(".proceso-requerimiento")) {
      const button = e.target.closest(".proceso-requerimiento");
      const id = button.dataset.id; // Obtener el data-id
      cambiarEstadoRequerimiento(id, "0"); // Cambiar el estado a "0" (en proceso)
    }
  });

  addEventListener("click", async (e) => {
    const button = e.target.closest(".ver-detalle"); // Asegurarse de seleccionar el botón padre
    if (button) {
      const id = button.dataset.id; // Obtener el ID del requerimiento
      await verRequerimiento(id); // Llamar a la función para cargar el detalle
    }
  });

  form.addEventListener("click", async (e) => {
    if (e.target.classList.contains("agregar-fila")) {
      console.log("click");
      createRow();
    }

    if (
      e.target.classList.contains("eliminar-fila") ||
      e.target.classList.contains("bi-trash-fill")
    ) {
      const fila = e.target.closest(".input-group");
      fila ? fila.remove() : console.log("No se encontro la fila");
    }
  });

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    await registrarRequerimiento();
  });

  btnAbrirModal.addEventListener("click", () => {
    form.reset();
    contenedorDetalle.innerHTML = `
      <div class="input-group">
        <input class="form-control" style="width: 65%;" type="text" name="requerimiento" placeholder="Requerimiento" maxlength="255" required>
        <input type="number" class="form-control" placeholder="Cantidad" name="cantidad" min="1" value="1">
      </div>
    `;
  });


  async function renderDeteiles(id) {
    try {

      const formData = new FormData();
      formData.append("operacion", "lista_cotizaciones_proveedores");
      formData.append("idrequerimiento", id);
      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      console.log(data);
      if (data.length > 0) {
        const renderListDet = data
          .map(({ idrequerimiento, precio_total, ruta_pdf, fecha , estado}) => {
            const nombreArchivo = ruta_pdf.substring(0, ruta_pdf.lastIndexOf('.')); // Obtiene el nombre sin la extensión
            console.log(nombreArchivo);
            return `
            <tr>
              <td>${fecha}</td>
              <td><a href="../pdf_cot/${ruta_pdf}" target="_blank">${nombreArchivo}</a></td>
              <td>${precio_total}</td>
              <td>
                <button type="button" class="btn btn-danger">
                  <i class="bi bi-trash-fill"></i>
                </button>
                <button type="button" class="btn btn-success">
                  <i class="bi bi-check2-circle"></i>
                </button>
              </td>
            </tr>
          `;
          })
          .join("");
        return renderListDet;
      }else{
        return `
        <tr>
          <td colspan="6" style="text-align: center;">No hay cotizaciones registradas</td>
        </tr>
        `;
      }
      
    } catch (error) {
      console.log(error);
      
    }
  }

  //Cambiar estado requerimiento
  async function cambiarEstadoRequerimiento(idRequerimiento, nuevoEstado) {
    try {
      const formData = new FormData();
      formData.append("operacion", "actualizar_estado_requetimiento");
      formData.append("idrequerimiento", idRequerimiento);
      formData.append("estado", nuevoEstado);

      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      alert("Estado actualizado correctamente.");
      await listarRequerimientos();
    } catch (error) {
      console.error("Error al cambiar el estado:", error);
    }
  }

  //Eventos 
  // Delegación de eventos para evitar duplicados



  tabla.addEventListener("click", async (e) => {
    if (e.target.closest(".toggle-options")) {
      const button = e.target.closest(".toggle-options");
      const id = button.dataset.id;
      let optionsContainer = document.getElementById(`options-${id}`);

      if (!optionsContainer) {
        // Crear el <tr> dinámicamente si no existe
        optionsContainer = document.createElement("tr");
        optionsContainer.id = `options-${id}`;
        optionsContainer.classList.add("options-row");
        optionsContainer.innerHTML = `
          <td colspan="1"></td>
          <td colspan="7" style="background-color: #06202B;">
            <div class="options-content" style="width: 100%; display: flex; justify-content: flex-end; align-items: center;">
              <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#modal-subir-pdf" data-id="${id}">
                <i class="bi bi-box-arrow-in-up"></i> Subir PDF
              </button>
            </div>
            <div class="text-center" style="width: 100%; display: flex; justify-content: center; align-items: center;">
              <table class="table text-white table-bordered table-striped mt-2">
                <thead>
                  <tr>
                    <th>Fecha</th>
                    <th>PDF</th>
                    <th>Precio Total</th>
                    <th>Opciones</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </div>
          </td>
        `;
        button.closest("tr").after(optionsContainer);

        // Cambiar el ícono a flecha hacia arriba
        button.innerHTML = `<i class="bi bi-chevron-up"></i>`;
        await renderizarCotizaciones(id);
      } else {
        // Mostrar u ocultar el <tr> si ya existe
        if (optionsContainer.style.display === "none" || optionsContainer.style.display === "") {
          optionsContainer.style.display = "table-row";
          button.innerHTML = `<i class="bi bi-chevron-up"></i>`; // Cambiar a flecha hacia arriba
        } else {
          optionsContainer.style.display = "none";
          button.innerHTML = `<i class="bi bi-chevron-down"></i>`; // Cambiar a flecha hacia abajo
        }
      }
    }
  });

  // Limpiar el campo de archivo y establecer el idRequerimiento al abrir el modal
  document.getElementById("modal-subir-pdf").addEventListener("show.bs.modal", (event) => {
    // Limpiar el campo de archivo
    document.getElementById("archivo-pdf").value = "";

    // Obtener el botón que activó el modal
    const button = event.relatedTarget;

    // Obtener el idRequerimiento del botón
    const idRequerimiento = button.dataset.id;

    // Guardar el idRequerimiento en un atributo del modal para usarlo después
    const modal = document.getElementById("modal-subir-pdf");
    modal.dataset.idRequerimiento = idRequerimiento;
  });

  // Registrar el evento submit del formulario una sola vez
  document.getElementById("form-subir-pdf").addEventListener("submit", async (e) => {
    e.preventDefault();

    const formData = new FormData();
    const archivoPdf = document.getElementById("archivo-pdf").files[0];
    const monto = document.getElementById("monto").value;

    // Obtener el idRequerimiento del modal
    const idRequerimiento = document.getElementById("modal-subir-pdf").dataset.idRequerimiento;

    if (!archivoPdf) {
      alert("Por favor, selecciona un archivo PDF.");
      return;
    }

    formData.append("operacion", "registrar_cotizacion_proveedor");
    formData.append("idrequerimiento", idRequerimiento);
    formData.append("precio_total", monto);
    formData.append("ruta_pdf", archivoPdf);

    try {
      const res = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const data = await res.json();

      if (data.success) {
        alert("Archivo subido correctamente.");
        const modal = bootstrap.Modal.getInstance(document.getElementById("modal-subir-pdf"));
        modal.hide(); // Cerrar el modal correctamente

        // Actualizar dinámicamente el div de cotizaciones
        await renderizarCotizaciones(idRequerimiento);
      } else {
        alert("Error al subir el archivo.");
      }
    } catch (error) {
      console.error("Error al subir el archivo:", error);
      alert("Ocurrió un error al subir el archivo.");
    }
  });

  listarRequerimientos();
});
