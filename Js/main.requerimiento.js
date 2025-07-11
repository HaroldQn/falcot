import { obtenerCotizaciones } from "./cotizaciones.requerimiento.js";
import { crearTablaComparativa } from "./tabla.requerimiento.js";

const ID = new URLSearchParams(window.location.search).get("id");
const API = "../Controllers/requerimiento.controller.php";
const list_data_modal = document.getElementById("lista-det-requerimientos-modal");
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
    crearTablaComparativa(data, empresas);
    await renderModalData(data);
  } catch (error) {
    console.error("Error al cargar requerimiento", error);
  }
}

async function renderModalData(data) {
  console.log("Renderizando datos del modal", data);
  let render = data.map(({iddet_requerimiento,item, cantidad}, i) => `
    <tr id="${iddet_requerimiento}">
      <td>${i + 1}</td>
      <td>${item}</td>
      <td>${cantidad}</td>
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
      <td><input type="number" class="form-control" name="precio_unitario" min="0.01" step="0.01" value="0.00"></td>
      <td><input type="number" class="form-control" name="precio_total" min="0.01" step="0.01" value="0.00" disabled=true></td>
    </tr>
    `).join("");
  list_data_modal.innerHTML = render;
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
    const {idcotizacion_prov_creada} = data;

    obtenerDataDetalleCotizacones(idcotizacion_prov_creada);
  } catch (error) {
    console.error("Error al registrar cotización", error);
  }
}

async function obtenerDataDetalleCotizacones(idcotizacion_prov_creada) {
  const filas = list_data_modal.querySelectorAll("tr");
  [...filas].map(fila =>{
    const id = fila.id;
    const marca = fila.querySelector("select[name='marca']").value;
    const precio_unitario = fila.querySelector("input[name='precio_unitario']").value;

    registrarDetCotizacion(
      idcotizacion_prov_creada, 
      id, 
      marca, 
      precio_unitario);
  })
}

async function registrarDetCotizacion(
  idcotizacion_prov_creada, 
  iddet_requerimiento, 
  marca, 
  precio_unitario
) {
  try {
    console.log(idcotizacion_prov_creada, iddet_requerimiento, marca, precio_unitario);
    const formData = new FormData();
    formData.append("operacion", "agregar_detalle_cotizacion");
    formData.append("idcotizacion_prov", idcotizacion_prov_creada);
    formData.append("iddet_requerimiento", iddet_requerimiento);
    formData.append("marca", marca);
    formData.append("precio", precio_unitario);

    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();
    console.log("Detalle de cotización registrado:", data);
  } catch (error) {
    console.error("Error al registrar detalle de cotización", error);
  }
  
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  await registrarCotizacion();
  form.reset();
  await verRequerimiento(ID);
  $('#modal-registrar-cotizacion').modal('hide');
  console.log("Guardando datos...");
});



// Ejecutar
verRequerimiento(ID);
