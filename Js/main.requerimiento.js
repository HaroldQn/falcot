import { obtenerCotizaciones } from "./cotizaciones.requerimiento.js";
import { crearTablaComparativa } from "./tabla.requerimiento.js";
import { activarCalculos } from "./calculos.js";

const ID = new URLSearchParams(window.location.search).get("id");
const API = "../Controllers/requerimiento.controller.php";
const list_data_modal = document.getElementById(
  "lista-det-requerimientos-modal"
);
const botonGuardar = document.getElementById("btnGuardar");
const form = document.getElementById("form-modal");

async function verRequerimiento(id) {
  try {
    const formData = new FormData();
    formData.append("operacion", "lista_det_requerimientos");
    formData.append("idrequerimiento", id);

    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();

    const empresas = await obtenerCotizaciones(ID, API);
    
    window.empresasGlobal = empresas;
    window.requerimientosGlobal = data;
    crearTablaComparativa(data, empresas);
    poblarSelectEmpresas(empresas);
    await renderModalData(data);
  } catch (error) {
    console.error("Error al cargar requerimiento", error);
  }
}

async function renderModalData(data) {
  let render = data
    .map(
      ({ iddet_requerimiento, item, cantidad }, i) => `
    <tr id="${iddet_requerimiento}" class="fila-cotizacion">
      <td>${i + 1}</td>
      <td>${item}</td>
      <td class="cantidad">${cantidad}</td>
      <td>
        <select name="marca" class="form-control" required>
          <option value="">-------------</option>
          <option value="SKF">SKF</option>
          <option value="NAK">NAK</option>
          <option value="NTN">NTN</option>
          <option value="ZKL">ZKL</option>
          <option value="TTO">TTO</option>
          <option value="KMK">KMK</option>
        </select>
      </td>
      <td><input type="number" name="precio_unitario" class="form-control precio-unitario" min="0.01" step="0.01" value="0.00"></td>
      <td><input type="number" class="form-control precio-total" min="0.01" step="0.01" value="0.00" disabled></td>
    </tr>
  `
    )
    .join("");

  // Agregamos fila de total general
  render += `
    <tr>
      <td colspan="5" class="text-end fw-bold">Total General:</td>
      <td>
        <span id="simbolo_moneda"></span>
        <label id="total-general" class="fw-bold">0.00</label>
      </td>
    </tr>
  `;

  list_data_modal.innerHTML = render;

  // Llamar función para activar los cálculos automáticos
  activarCalculos();
}

async function registrarCotizacion() {
  const empresas = document.getElementById("empresa");
  const moneda = document.getElementById("moneda");

  try {
    const formData = new FormData();
    formData.append("operacion", "crear_cotizacion_proveedor");
    formData.append("idrequerimiento", ID);
    formData.append("empresa", empresas.value);
    formData.append("moneda", moneda.value);
    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();
    const { idcotizacion_prov_creada } = data;

    obtenerDataDetalleCotizacones(idcotizacion_prov_creada);
  } catch (error) {
    console.error("Error al registrar cotización", error);
  }
}

async function obtenerDataDetalleCotizacones(idcotizacion_prov_creada) {
  const filas = list_data_modal.querySelectorAll("tr.fila-cotizacion");
  [...filas].forEach((fila) => {
    const id = fila.id;
    const marca = fila.querySelector("select[name='marca']").value;
    const precio_unitario = fila.querySelector(
      "input[name='precio_unitario']"
    ).value;

    registrarDetCotizacion(
      idcotizacion_prov_creada,
      id,
      marca,
      precio_unitario
    );
  });
}

async function registrarDetCotizacion(
  idcotizacion_prov_creada,
  iddet_requerimiento,
  marca,
  precio_unitario
) {
  try {
    const formData = new FormData();
    formData.append("operacion", "agregar_detalle_cotizacion");
    formData.append("idcotizacion_prov", idcotizacion_prov_creada);
    formData.append("iddet_requerimiento", iddet_requerimiento);
    formData.append("marca", marca);
    formData.append("precio", precio_unitario);

    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();
  } catch (error) {
    console.error("Error al registrar detalle de cotización", error);
  }
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  await registrarCotizacion();
  form.reset();
  await verRequerimiento(ID);
  $("#modal-registrar-cotizacion").modal("hide");
  console.log("Guardando datos...");
});


function poblarSelectEmpresas(empresas) {
  const select = document.getElementById("select-empresa-cotizacion");
  if (!select) return;

  empresas.forEach(emp => {
    const option = document.createElement("option");
    option.value = emp.nombre;
    option.textContent = emp.nombre;
    select.appendChild(option);
  });
}

document.getElementById("btn-generar-cotizacion").addEventListener("click", async() => {
  const empresaSeleccionada = document.getElementById("select-empresa-cotizacion").value;
  if (!empresaSeleccionada) {
    alert("Seleccione una empresa primero.");
    return;
  }

  // Buscar la empresa seleccionada
  const empresa = window.empresasGlobal?.find(e => e.nombre === empresaSeleccionada);
  if (!empresa) {
    alert("Empresa no encontrada.");
    return;
  }

  // Generar la cotización
  const cotizacionGenerada = empresa.cotizaciones.map((detalle, i) => {
  const cantidad = window.requerimientosGlobal?.[i]?.cantidad ?? 0;
  const nombre = window.requerimientosGlobal?.[i]?.item ?? `Item ${i + 1}`;
  return {
    item: i + 1,
    descripcion: nombre, 
    cantidad: cantidad,
    marca: detalle.marca,
    precioUnitario: detalle.precioU
    };  
  });


  console.log("Cotización generada para:", empresa.nombre);
  console.log(cotizacionGenerada);
  await localStorage.setItem("ordenCompraDatos", JSON.stringify(cotizacionGenerada));
  window.location.href = "./generar_orden_compra.php";
});



// Ejecutar
verRequerimiento(ID);
