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
          <tr>
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
            <td class="text-${estado === '0' ? 'success' : 'muted'} ">
              <strong>
                ${estado === '0' ? 'Aprobado' : 'Pendiente'}
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
          <button type="button" class="btn btn-danger">
            <i class="bi bi-trash-fill"></i>
          </button>
          <button type="button" class="btn btn-primary">
            <i class="bi bi-pencil-fill"></i>
          </button>
          <button type="button" class="btn btn-success">
            <i class="bi bi-check2-circle"></i>
          </button>
        </div>
      </td>
      `;
    } else {
      button = `
      <td>
        <button class="btn btn-secondary toggle-options" data-id="${id}">
          <i class="bi bi-chevron-down"></i>
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

  // Eventos

  addEventListener("click", async (e) => {
    if (e.target.classList.contains("ver-detalle")) {
      const id = e.target.dataset.id;
      await verRequerimiento(id);
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
            return `
            <tr>
              <td>${precio_total}</td>
              <td>${estado}</td>
              <td>${ruta_pdf}</td>
              <td>${fecha}</td>
              <td>Botones</td>
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
          <td colspan="1" style="background-color: #06202B;"></td>
          <td colspan="7" style="background-color: #06202B;">
            <div class="options-content" style="width: 100%; display: flex; justify-content: flex-end; align-items: center;">
              <button class="btn btn-warning">
                <i class="bi bi-box-arrow-in-up"></i> Subir PDF
              </button>
            </div>
            <div class="text-center" style="width: 100%; display: flex; justify-content: center; align-items: center;">
              <table class="table text-white table-bordered table-striped mt-2">
                <thead>
                  <tr>
                    <th>Precio Total</th>
                    <th>Estado</th>
                    <th>PDF</th>
                    <th>Fecha</th>
                    <th>Opciones</th>
                  </tr>
                </thead>
                <tbody>
                  ${await renderDeteiles(id)}
                </tbody>
              </table>
            </div>
          </td>
        `;
        button.closest("tr").after(optionsContainer);
      } else {
        // Mostrar u ocultar el <tr> si ya existe
        optionsContainer.style.display = optionsContainer.style.display === "none" ? "table-row" : "none";
      }
    }
  });

  listarRequerimientos();
});
