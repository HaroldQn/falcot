import { toast, Preguntar } from "./exports/alert.js"; 
import {obtenerEstadoRequerimiento} from "./estado.js";

const ID = new URLSearchParams(window.location.search).get("id");
const RUTA = "../Controllers/requerimiento.controller.php";

// ESTADO DEL REQUERIMIENTO
const estado = await obtenerEstadoRequerimiento(ID);
console.log("Estado del requerimiento:", estado);
if (estado == 3) {
  console.log("El requerimiento está en estado 3, se pueden subir y eliminar documentos.");
  ocultarSubidaDocumentos();
}
console.log(estado);


document.querySelectorAll('input[type="file"]').forEach(input => {
  const group = input.closest(".input-group");
  const button = group.querySelector("button");

  button.disabled = true;

  input.addEventListener("change", () => {
    button.disabled = !input.files.length;
  });

  button.addEventListener("click", async () => {
    const archivo = input.files[0];
    if (!archivo) return;

    const tipoDocumento = input.dataset.tipo;

    const formData = new FormData();
    formData.append("operacion", "agregar_documento");
    formData.append("idrequerimiento", ID);
    formData.append("idtipodoc", tipoDocumento);
    formData.append("archivo", archivo);

    try {
      await fetch(RUTA, { method: "POST", body: formData });
      toast('success',`Archivo ${archivo.name} subido correctamente`);
      await cargarDocumentos();
    } catch (err) {
      console.error(`Error al subir ${archivo.name}:`, err);
      toast('error',`Error al subir ${archivo.name}`);
    }

    input.value = "";
    button.disabled = true;
  });
});

async function cargarDocumentos() {
  try {
    const formData = new FormData();
    formData.append("operacion", "listar_documentos");
    formData.append("idrequerimiento", ID);

    const response = await fetch(RUTA, { method: "POST", body: formData });
    const documentos = await response.json();

    const tipos = {
      1: "Orden de Compra",
      2: "Factura",
      3: "Guía de Remisión",
      4: "Comprobante de Pago"
    };

    const colores = {
      1: "success",
      2: "warning",
      3: "primary",
      4: "info"
    };

    const contenedor = document.getElementById("contenedor-documentos");
    contenedor.innerHTML = ""; // limpiar

    Object.keys(tipos).forEach((tipoId) => {
      const docs = documentos.filter(doc => doc.idtipodoc == tipoId);
      const titulo = tipos[tipoId];
      const color = colores[tipoId];

      const bloque = document.createElement("div");
      bloque.classList.add("mb-4");

      const header = document.createElement("h5");
      header.textContent = titulo;
      bloque.appendChild(header);

      if (docs.length === 0) {
        const mensaje = document.createElement("p");
        mensaje.textContent = `No hay ${titulo.toLowerCase()} cargada`;
        mensaje.classList.add("text-muted");
        bloque.appendChild(mensaje);
        if (tipoId == 4) {
          const btnCerrar = document.getElementById("btnCerrarCotizacion");
          btnCerrar.style.display = "none";
        }else{
          const btnCerrar = document.getElementById("btnCerrarCotizacion");
          btnCerrar.style.display = "block";
        }

      } else {
        const ul = document.createElement("ul");
        ul.classList.add("list-group", "list-group-flush");

        docs.forEach(doc => {
          const li = document.createElement("li");
          li.classList.add("list-group-item", `list-group-item-${color}`);

          const enlace = document.createElement("a");
          enlace.href = `../pdfs/${doc.nombre}.pdf`; // ajusta la ruta real
          enlace.target = "_blank";
          enlace.textContent = doc.nombre;
          console.log("Estado del requerimiento dentro del bucle:", estado);
          if (estado === '0') {
            console.log("Estado del requerimiento:", estado);
            const btnEliminar = document.createElement("button");
            btnEliminar.classList.add("btn", "btn-danger", "btn-sm", "float-end");
            btnEliminar.dataset.id = doc.iddocumento;
            btnEliminar.innerHTML = `<i class="bi bi-trash"></i>`;
            btnEliminar.onclick = () => Preguntar(
              () => eliminarDocumento(doc.iddocumento),
              `¿Deseas eliminar el documento ${doc.nombre}?`,
              "warning"
            );
            li.appendChild(btnEliminar);
          }


          li.appendChild(enlace);
          ul.appendChild(li);
        });

        bloque.appendChild(ul);
      }

      contenedor.appendChild(bloque);
    });

  } catch (error) {
    console.error("Error al cargar documentos:", error);
  }
}

async function eliminarDocumento(id) {
  console.log(id)
  try {
    const response = await fetch(RUTA, {
      method: "POST",
      body: new URLSearchParams({
        operacion: "eliminar_documento",
        iddocumento: id
      })
    });

    toast("success", "Documento eliminado correctamente");
    await cargarDocumentos();

  } catch (error) {
    console.error("Error al eliminar documento:", error);
    
  }
}

function ocultarSubidaDocumentos() {
  const contenedorInputs = document.querySelector(".contenedor-inputs");
  estado == 3
    ? contenedorInputs.classList.add("d-none")
    : contenedorInputs.classList.remove("d-none");
}

const btnCerrar = document.getElementById("btnCerrarCotizacion");
btnCerrar.addEventListener("click", async () => {
  Preguntar(
    ()=> cerrarCotizacion(),
    "¿Estás seguro de cerrar la cotización? No podrás subir o eliminar más documentos.",
    "warning"
  );
})

async function cerrarCotizacion() {
  try {
    const formData = new FormData();
    formData.append("operacion", "cerrar_requerimiento");
    formData.append("idrequerimiento", ID);
    const response = await fetch(RUTA, { method: "POST", body: formData });
    window.location.href = `../Views/det_requerimiento.php?id=${ID}`;
  } catch (error) {
    console.error("Error al cerrar cotización:", error);
  }
}


cargarDocumentos();
