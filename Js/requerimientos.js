import { toast, Preguntar } from "./exports/alert.js";

document.addEventListener("DOMContentLoaded", () => {
  const API = "../Controllers/requerimiento.controller.php";
  const tabla = document.getElementById("lista-requerimientos");
  const tablaLista = document.getElementById("lista-det-requerimientos");
  const form = document.getElementById("form-modal");
  const modal = new bootstrap.Modal(document.getElementById("modal-requerimiento"));
  const contenedorDetalle = document.getElementById("list-detalle-render");
  const btnAbrirModal = document.getElementById("crear-requerimiento");

  // Renderiza la tabla de requerimientos
  async function listarRequerimientos() {
    try {
      const formData = new FormData();
      formData.append("operacion", "lista_requerimientos");
      const res = await fetch(API, { method: "POST", body: formData });
      const data = await res.json();
      const renderedRows = await Promise.all(data.map(renderFilaRequerimiento));
      tabla.innerHTML = renderedRows.join("");
    } catch (error) {
      console.error(error);
    }
  }

  // Renderiza una fila de la tabla de requerimientos
  async function renderFilaRequerimiento({ idrequerimiento, usuario, fecha, estado, motivo, observacion }) {
    const buttonEstado = await renderBotonesEstado(idrequerimiento, estado);
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
        ${buttonEstado}
      </tr>
    `;
  }

  // Renderiza los botones de acción según el estado
  function renderBotonesEstado(id, estado) {
    if (estado === "1") {
      return `
        <td>
          <div class="btn-group" role="group">
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
      return `
        <td>
          <button class="btn btn-warning" data-id="${id}">
            <i class="bi bi-arrow-bar-right"></i>
          </button>
        </td>
      `;
    } else {
      return `
        <td>
          <button class="btn btn-secondary" disabled>
            <i class="bi bi-x-circle"></i>
          </button>
        </td>
      `;
    }
  }

  // Renderiza el detalle de un requerimiento
  async function verRequerimiento(id) {
    try {
      tablaLista.innerHTML = "";
      const formData = new FormData();
      formData.append("operacion", "lista_det_requerimientos");
      formData.append("idrequerimiento", id);
      const res = await fetch(API, { method: "POST", body: formData });
      const data = await res.json();
      tablaLista.innerHTML = data.map(renderFilaDetalle).join("");
    } catch (error) {
      console.error(error);
    }
  }

  // Renderiza una fila del detalle
  function renderFilaDetalle({ item, cantidad }, index) {
    return `
      <tr>
        <td>${index + 1}</td>
        <td>${item}</td>
        <td>${cantidad}</td>
      </tr>
    `;
  }

  // Crea una nueva fila para el formulario de requerimiento
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

  // Registra un requerimiento y sus detalles
  async function registrarRequerimiento() {
    const formData = new FormData();
    formData.append("operacion", "registrar_requerimiento");
    formData.append("motivo", form.motivo.value.trim() || "-----------------------------------");
    formData.append("observacion", form.observacion.value || "-----------------------------------");
    const res = await fetch(API, { method: "POST", body: formData });
    const { idrequerimiento } = await res.json();
    const filas = document.querySelectorAll(".input-group");
    const detalles = [...filas].map(fila => {
      const item = fila.querySelector("[name='requerimiento']").value;
      const cantidad = fila.querySelector("[name='cantidad']").value || 1;
      return registrarDetRequerimiento(idrequerimiento, item, cantidad);
    });
    await Promise.all(detalles);
    await listarRequerimientos();
    modal.hide();
    toast("success", "Requerimiento registrado correctamente.");
  }

  // Registra un detalle de requerimiento
  async function registrarDetRequerimiento(idrequerimiento, item, cantidad) {
    const formData = new FormData();
    formData.append("operacion", "registrar_det_requerimiento");
    formData.append("idrequerimiento", idrequerimiento);
    formData.append("item", item);
    formData.append("cantidad", cantidad);
    await fetch(API, { method: "POST", body: formData });
  }

  // Cambia el estado de un requerimiento
  async function cambiarEstadoRequerimiento(idRequerimiento, nuevoEstado) {
    try {
      const formData = new FormData();
      formData.append("operacion", "actualizar_estado_requetimiento");
      formData.append("idrequerimiento", idRequerimiento);
      formData.append("estado", nuevoEstado);
      await fetch(API, { method: "POST", body: formData });
      toast("success", "Estado actualizado correctamente.");
      await listarRequerimientos();
    } catch (error) {
      console.error("Error al cambiar el estado:", error);
    }
  }

  // Delegación de eventos para la tabla de requerimientos
  tabla.addEventListener("click", (e) => {
    const anularBtn = e.target.closest(".anular-requerimiento");
    const procesoBtn = e.target.closest(".proceso-requerimiento");
    const verDetalleBtn = e.target.closest(".ver-detalle");
    const btnWarning = e.target.closest(".btn-warning");
    if (anularBtn) {
      cambiarEstadoRequerimiento(anularBtn.dataset.id, "2");
    } else if (procesoBtn) {
      cambiarEstadoRequerimiento(procesoBtn.dataset.id, "0");
    } else if (verDetalleBtn) {
      verRequerimiento(verDetalleBtn.dataset.id);
    } else if (btnWarning) {
      console.log("ID del botón warning:", btnWarning.dataset.id);
      window.location.href = `../Views/det_requerimiento.php?id=${btnWarning.dataset.id}`;
    }
  });

  // Delegación de eventos para el formulario
  form.addEventListener("click", (e) => {
    if (e.target.classList.contains("agregar-fila")) {
      createRow();
    } else if (
      e.target.classList.contains("eliminar-fila") ||
      e.target.classList.contains("bi-trash-fill")
    ) {
      const fila = e.target.closest(".input-group");
      if (fila) fila.remove();
    }
  });

  // Envío del formulario
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    await registrarRequerimiento();
  });

  // Inicializa el formulario al abrir el modal
  btnAbrirModal.addEventListener("click", () => {
    form.reset();
    contenedorDetalle.innerHTML = `
      <div class="input-group">
        <input class="form-control" style="width: 65%;" type="text" name="requerimiento" placeholder="Requerimiento" maxlength="255" required>
        <input type="number" class="form-control" placeholder="Cantidad" name="cantidad" min="1" value="1">
      </div>
    `;
  });
  

  // Inicialización
  listarRequerimientos();
});
