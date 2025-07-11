// js/cotizaciones.js

const colores = ["warning", "info", "danger","primary"];

export async function obtenerCotizaciones(idrequerimiento, api) {
  try {
    const formData = new FormData();
    formData.append("operacion", "listar_cotizaciones");
    formData.append("idrequerimiento", idrequerimiento);

    const res = await fetch(api, { method: "POST", body: formData });
    const data = await res.json();

    const stringJSON = data[0].resultado_json;
    const empresas = JSON.parse(stringJSON);

    // Agregar color
    empresas.forEach((empresa, index) => {
      empresa.color = colores[index % colores.length];
    });

    return empresas;
  } catch (error) {
    console.error("Error al obtener cotizaciones", error);
    return [];
  }
}
