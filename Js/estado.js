export async function obtenerEstadoRequerimiento(id) {
  const formData = new FormData();
  formData.append("operacion", "ver_requerimiento");
  formData.append("idrequerimiento", id);

  try {
    const response = await fetch("../Controllers/requerimiento.controller.php", {
      method: "POST",
      body: formData
    });

    const data = await response.json(); // Ej: { estado: 3 }
    console.log(data.estado);

    if(data.estado === '3'){
        document.getElementById("btnCerrarCotizacion").classList.add("d-none");
        document.querySelector(".contenedor-boton").classList.add("d-none");
        document.getElementById("cerrado").classList.remove("d-none");
    }


    return data.estado;
  } catch (error) {
    console.error("Error obteniendo estado del requerimiento", error);
    return null;
  }
}
