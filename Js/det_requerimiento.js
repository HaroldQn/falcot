const ID = new URLSearchParams(window.location.search).get("id");
const API = "../Controllers/requerimiento.controller.php";
const list_data_modal = document.getElementById("lista-det-requerimientos-modal");


async function obtenerCotizaciones(idrequerimiento) {
  try {
    const formData = new FormData();
    formData.append("operacion", "listar_cotizaciones");
    formData.append("idrequerimiento", idrequerimiento);

    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();

    const stringJSON = data[0].resultado_json;
    const dataJSON = JSON.parse(stringJSON);
    return dataJSON;
  } catch (error) {
    console.error("Error al obtener cotizaciones", error);
  }
}

const empresas = await obtenerCotizaciones(ID);

async function verRequerimiento(id) {
  try {
    const formData = new FormData();
    formData.append("operacion", "lista_det_requerimientos");
    formData.append("idrequerimiento", id);

    const res = await fetch(API, { method: "POST", body: formData });
    const data = await res.json();

    console.log("Datos de la BD:", data);
    obtenerCotizaciones(ID);
    // const empresasCotizadas = await obtenerCotizaciones(ID);
    // const stringJSON = empresasCotizadas[0].resultado_json;
    // const dataJSON = JSON.parse(stringJSON);
    // console.log("Datos de las cotizaciones:", dataJSON);

    crearTablaComparativa(data); // Usamos los datos reales
    await renderModalData(data);
  } catch (error) {
    console.error("Error al cargar requerimiento", error);
  }
}

async function renderModalData(data) {
  let render = data.map(({item, cantidad}, i) => `
    <tr>
      <td>${i + 1}</td>
      <td>${item}</td>
      <td>${cantidad}</td>
      <td>
        <select name="marca" class="form-control">
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
      <td><input type="number" class="form-control" name="precio_total" min="0.01" step="0.01" value="0.00"></td>
    </tr>
    `).join("");
  list_data_modal.innerHTML = render;
}

function crearTablaComparativa(items) {
  const thead = document.querySelector("thead");
  const tbody = document.getElementById("tabla-comparativa");
  const tfoot = document.querySelector("tfoot");

  // Limpiar contenido actual
  tbody.innerHTML = "";
  thead.innerHTML = "";
  tfoot.innerHTML = "";

  // Fila 1 (Empresas)
  let filaEmpresas = `<tr>
    <th rowspan="2">ID</th>
    <th rowspan="2">Item</th>
    <th rowspan="2">Cantidad</th>`;
  empresas.forEach(e => {
    filaEmpresas += `<th colspan="3" class="table-${e.color} text-dark">${e.nombre}</th>`;
  });
  filaEmpresas += `</tr>`;

  // Fila 2 (subtítulos)
  let filaSubtitulos = `<tr>`;
  empresas.forEach(e => {
    filaSubtitulos += `
      <th class="table-${e.color} text-dark">Marca</th>
      <th class="table-${e.color} text-dark">Pre.U</th>
      <th class="table-${e.color} text-dark">Total</th>
    `;
  });
  filaSubtitulos += `</tr>`;

  thead.innerHTML = filaEmpresas + filaSubtitulos;

  // Cuerpo de tabla
  items.forEach((item, i) => {
    let fila = `<tr>
      <td>${i + 1}</td>
      <td>${item.item}</td>
      <td>${item.cantidad}</td>`;
    empresas.forEach(emp => {
      const cot = emp.cotizaciones[i] ?? { marca: "-", precioU: 0, total: 0 };
      fila += `
        <td>${cot.marca}</td>
        <td>${cot.precioU.toFixed(2)}</td>
        <td>${cot.total.toFixed(2)}</td>
      `;
    });
    fila += `</tr>`;
    tbody.innerHTML += fila;
  });

  // Pie de tabla
  let filaTotales = `<tr class="fw-bold">
    <td colspan="3" class="text-end"></td>`;
  empresas.forEach(emp => {
    const suma = emp.cotizaciones.reduce((acc, cot) => acc + cot.total, 0).toFixed(2);
    filaTotales += `
      <td colspan="2" class="text-end">Total ${emp.nombre}:</td>
      <td class="table-${emp.color}">${suma}</td>
    `;
  });
  filaTotales += `</tr>`;
  tfoot.innerHTML = filaTotales;
}



// Ejecutar
verRequerimiento(ID);
