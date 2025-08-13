// Importaciones
import { obtenerCotizaciones } from "./cotizaciones.requerimiento.js";
import { crearTablaComparativa } from "./tabla.requerimiento.js";
import { activarCalculos } from "./calculos.js";
import { toast, Preguntar } from "./exports/alert.js";
import { obtenerEstadoRequerimiento } from "./estado.js";


// Constantes globales
const ID = new URLSearchParams(window.location.search).get("id");
const API = "../Controllers/requerimiento.controller.php";
const form = document.getElementById("form-modal");
const list_data_modal = document.getElementById("lista-det-requerimientos-modal");
const estado = await obtenerEstadoRequerimiento(ID);

const contenerdorSelectEmpresa = document.querySelector(".container-select-empresa");
estado === 3
  ? contenerdorSelectEmpresa.classList.remove("d-none")
  : contenerdorSelectEmpresa.classList.add("d-none");

// Inicialización
verRequerimiento(ID);

// Eventos
form.addEventListener("submit", async (e) => {
  e.preventDefault();
  await registrarCotizacion();
  form.reset();
  await verRequerimiento(ID);
  $("#modal-registrar-cotizacion").modal("hide");
});



document.getElementById("btn-generar-cotizacion").addEventListener("click", generarCotizacion);
document.getElementById("tabla-comparativa-cabezera").addEventListener("click", function(e) {
  if (e.target.closest(".btn-danger")) {
    const btn = e.target.closest(".btn-danger");
    const nombreEmpresa = btn.dataset.empresa;
    const idEmpresa = btn.dataset.id;
    Preguntar(
      ()=> eliminarCotizacionProveedor(idEmpresa),
      `¿Deseas eliminar la cotización de ${nombreEmpresa}?`,
      "warning",
    )
  }
});

async function eliminarCotizacionProveedor(idEmpresa) {
  try {
    const formData = new FormData();
    formData.append("operacion", "eliminar_cotizacion_proveedor");
    formData.append("idcotizacion_prov", idEmpresa);

    const res = await fetch(API, { method: "POST", body: formData });
    const result = await res.json();
    toast("success","Cotización eliminada");
    await verRequerimiento(ID);

  } catch (error) {
    console.error("Error al eliminar cotización", error);
  }

}


// Funciones principales
async function verRequerimiento(id) {
  try {
    const formData = new FormData();
    formData.append("operacion", "lista_det_requerimientos");
    formData.append("idrequerimiento", id);

    const res = await fetch(API, { method: "POST", body: formData });
    const requerimientos = await res.json();
    const empresas = await obtenerCotizaciones(ID, API);

    window.empresasGlobal = empresas;
    window.requerimientosGlobal = requerimientos;

    crearTablaComparativa(requerimientos, empresas);
    poblarSelectEmpresas(empresas);
    await renderModalData(requerimientos);
  } catch (error) {
    console.error("Error al cargar requerimiento", error);
  }
}

async function renderModalData(data) {
  const opcionesMarca = ["SKF", "NAK", "NTN", "ZKL", "TTO", "KMK"]
    .map(marca => `<option value="${marca}">${marca}</option>`)
    .join("");

  let html = data.map(({ iddet_requerimiento, item, cantidad }, i) => `
    <tr id="${iddet_requerimiento}" class="fila-cotizacion">
      <td>${i + 1}</td>
      <td>${item}</td>
      <td class="cantidad">${cantidad}</td>
      <td>
        <input type="text" name="marca" class="form-control" required>
      </td>
      <td><input type="number" name="precio_unitario" class="form-control precio-unitario" min="0.01" step="0.01" value="0.00"></td>
      <td><input type="number" class="form-control precio-total" min="0.01" step="0.01" value="0.00" disabled></td>
    </tr>
  `).join("");

  html += `
    <tr>
      <td colspan="5" class="text-end fw-bold">Total General:</td>
      <td><span id="simbolo_moneda"></span><label id="total-general" class="fw-bold">0.00</label></td>
    </tr>
  `;

  list_data_modal.innerHTML = html;
  activarCalculos();
}

async function registrarCotizacion() {

  try {
    const formData = new FormData(form);
    formData.append("operacion", "crear_cotizacion_proveedor");
    formData.append("idrequerimiento", ID);


    const res = await fetch(API, { method: "POST", body: formData });
    const { idcotizacion_prov_creada } = await res.json();

    await registrarDetalleCotizaciones(idcotizacion_prov_creada);
  } catch (error) {
    console.error("Error al registrar cotización", error);
  }
}

async function registrarDetalleCotizaciones(idcotizacion) {
  const filas = document.querySelectorAll(".fila-cotizacion");

  for (const fila of filas) {
    const id = fila.id;
    const marca = fila.querySelector("input[name='marca']").value;
    const precio = fila.querySelector("input[name='precio_unitario']").value;

    try {
      const formData = new FormData();
      formData.append("operacion", "agregar_detalle_cotizacion");
      formData.append("idcotizacion_prov", idcotizacion);
      formData.append("iddet_requerimiento", id);
      formData.append("marca", marca);
      formData.append("precio", precio);

      await fetch(API, { method: "POST", body: formData });
    } catch (error) {
      console.error("Error en detalle de cotización", error);
    }
  }
}

function poblarSelectEmpresas(empresas) {
  const select = document.getElementById("select-empresa-cotizacion");
  if (!select) return;

  empresas.forEach(({ nombre }) => {
    const option = document.createElement("option");
    option.value = nombre;
    option.textContent = nombre;
    select.appendChild(option);
  });
}

function generarCotizacion() {
  const empresaNombre = document.getElementById("select-empresa-cotizacion").value;
  if (!empresaNombre) return toast('error',"Seleccione una empresa primero.");

  const empresa = window.empresasGlobal?.find(e => e.nombre === empresaNombre);
  if (!empresa) return toast('error',"Empresa no encontrada.");

  const cotizacionGenerada = empresa.cotizaciones.map((detalle, i) => {
    const req = window.requerimientosGlobal?.[i];
    return {
      item: i + 1,
      descripcion: req?.item ?? `Item ${i + 1}`,
      cantidad: req?.cantidad ?? 0,
      marca: detalle.marca,
      precioUnitario: detalle.precioU
    };
  });

  console.log("Cotización generada para:", empresa.nombre);
  console.log(cotizacionGenerada);

  localStorage.setItem("ordenCompraDatos", JSON.stringify(cotizacionGenerada));
  window.location.href = "./generar_orden_compra.php";
}
