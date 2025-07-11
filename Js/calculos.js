const list_data_modal = document.getElementById("lista-det-requerimientos-modal");

export function activarCalculos() {
  const filas = list_data_modal.querySelectorAll("tr");

  filas.forEach(fila => {
    const cantidadElem = fila.querySelector(".cantidad");
    const inputPrecioUnitario = fila.querySelector(".precio-unitario");
    const inputPrecioTotal = fila.querySelector(".precio-total");

    if (inputPrecioUnitario && cantidadElem && inputPrecioTotal) {
      inputPrecioUnitario.addEventListener("input", () => {
        const cantidad = parseFloat(cantidadElem.textContent) || 0;
        const precioUnitario = parseFloat(inputPrecioUnitario.value) || 0;
        const total = (cantidad * precioUnitario).toFixed(2);
        inputPrecioTotal.value = total;

        actualizarTotalGeneral();
      });
    }
  });
}

function actualizarTotalGeneral() {
  const preciosTotales = list_data_modal.querySelectorAll(".precio-total");
  let suma = 0;

  preciosTotales.forEach(input => {
    const valor = parseFloat(input.value) || 0;
    suma += valor;
  });

  document.getElementById("total-general").textContent = suma.toFixed(2);
}


