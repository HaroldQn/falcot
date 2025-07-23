// js/tablaComparativa.js

export function crearTablaComparativa(items, empresas) {
  const thead = document.querySelector("thead");
  const tbody = document.getElementById("tabla-comparativa");
  const tfoot = document.querySelector("tfoot");

  tbody.innerHTML = "";
  thead.innerHTML = "";
  tfoot.innerHTML = "";

  // Fila empresas
  let filaEmpresas = `<tr>
    <th rowspan="2">ID</th>
    <th rowspan="2">Item</th>
    <th rowspan="2">Cantidad</th>`;
  empresas.forEach(e => {
    filaEmpresas += `<th colspan="3" class="table-${e.color} text-dark">
      ${e.nombre}
      <button type="button" class="btn btn-sm btn-danger ms-2 ml-4" data-id="${e.idcotizacion_prov}" data-empresa="${e.nombre}" >
        <i class="bi bi-trash3-fill"></i>
      </button>
    </th>`;
  });
  filaEmpresas += `</tr>`;

  // Subtítulos
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

  // Cuerpo
  items.forEach((item, i) => {
  let fila = `<tr>
    <td>${i + 1}</td>
    <td>${item.item}</td>
    <td>${item.cantidad}</td>`;
  
  // Obtener precios totales de este ítem
  const totales = empresas.map(emp => emp.cotizaciones[i]?.total || 0);
  const minTotal = Math.min(...totales);

  empresas.forEach((emp, index) => {
    const cot = emp.cotizaciones[i] ?? { marca: "-", precioU: 0, total: 0 };

    const esMasBarato = cot.total === minTotal;

    fila += `
      <td>${cot.marca}</td>
      <td>${cot.precioU.toFixed(2)}</td>
      <td class="${esMasBarato ? "table-success fw-bold" : ""}">${cot.total.toFixed(2)}</td>
    `;
  });

  fila += `</tr>`;
  tbody.innerHTML += fila;
  });


  // Pie
  let filaTotales = `<tr class="fw-bold">
    <td colspan="3" class="text-end"></td>`;
  empresas.forEach(emp => {
    const suma = emp.cotizaciones.reduce((acc, cot) => acc + cot.total, 0).toFixed(2);
    const simbolo = emp.moneda === "SOLES" ? "S/ " : "$/ ";
    filaTotales += `
      <td colspan="2" class="text-end">Total ${emp.moneda}:</td>
      <td class="table-${emp.color}">${simbolo}${suma}</td>
    `;
  });
  filaTotales += `</tr>`;
  tfoot.innerHTML = filaTotales;
}
