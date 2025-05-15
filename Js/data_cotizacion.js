import { toast, Preguntar } from "./exports/alert.js";

document.addEventListener("DOMContentLoaded", function () {
  const idParam = new URLSearchParams(window.location.search);
  const id = idParam.get("id");

  const API = "../Controllers/requerimiento.controller.php";

  async function listar_data_cotizacion(id) {
    const parametros = new FormData();
    parametros.append("operacion", "listar_data_cotizacion");
    parametros.append("idcotizacion_prov", id);
    const req = await fetch(API, {
      method: "POST",
      body: parametros,
    });
    const res = await req.json();
    console.log(res);
    renderizarData(res); // Pasa el primer objeto de la respuesta
  }
  // -----------------------------------------------------
  async function renderizarData(data = []) {
    // Mapeo de tipos a labels
    const campos = [
      { key: "factura", label: "Factura" },
      { key: "guia", label: "Guia de remision" },
      { key: "pago", label: "Constancia de Pago" },
      { key: "orden", label: "Orden de compra" }
    ];

    let CONTENEDOR = `<div class="container">`;

    campos.forEach((campo, idx) => {
      const encontrado = data.find(item => item.tipo_doc === campo.key);
      const rutaArchivo = encontrado ? encontrado.ruta : "";

      CONTENEDOR += `
        <label class="form-label mt-${idx === 0 ? 0 : 3}">${campo.label}</label>
        <div class="input-group mb-3">
          <input type="text" class="form-control" id="nombre_${campo.key}" value="${rutaArchivo}" placeholder="Selecione un archivo" disabled>
          ${rutaArchivo
            ? `
              <a href="../pdf_data_cotizaciones/${rutaArchivo}" class="btn btn-outline-success" target="_blank" download>Descargar</a>
              <button class="btn btn-outline-danger ms-2" type="button" id="btn_del_${campo.key}">Eliminar</button>
            `
            : `
              <input type="file" class="d-none" id="file_${campo.key}" accept="application/pdf">
              <button class="btn btn-outline-success" type="button" id="btn_sel_${campo.key}">Seleccionar archivo</button>
              <button class="btn btn-primary d-none" type="button" id="btn_up_${campo.key}">Subir archivo</button>
            `
          }
        </div>
      `;
    });

    CONTENEDOR += `</div>`;

    const cuerpo = document.getElementById("main");
    cuerpo.innerHTML = CONTENEDOR;
    // ------------------------------------------------------------------------------

    async function subirArchivo(id, tipo, archivo) {
      console.log(id, tipo, archivo);
      const formData = new FormData();
      formData.append("operacion", "registrar_doc_cotizacion");
      formData.append("idcotizacion_prov", id);
      formData.append("tipo", tipo);
      formData.append("ruta", archivo);

      const req = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const res = await req.json();
      listar_data_cotizacion(id);
    }

    async function eliminarArchivo(id, tipo) {
      console.log(id, tipo);
      const formData = new FormData();
      formData.append("operacion", "eliminar_doc_cotizacion");
      formData.append("idcotizacion_prov", id);
      formData.append("tipo", tipo);

      const req = await fetch(API, {
        method: "POST",
        body: formData,
      });
      const res = await req.json();
      listar_data_cotizacion(id);
    }

    // Lógica de interacción solo para los que no tienen archivo
    campos.forEach((campo) => {
      const encontrado = data.find(item => item.tipo_doc === campo.key);
      if (!encontrado) {
        const btnSel = document.getElementById(`btn_sel_${campo.key}`);
        const btnUp = document.getElementById(`btn_up_${campo.key}`);
        const inputFile = document.getElementById(`file_${campo.key}`);
        const inputNombre = document.getElementById(`nombre_${campo.key}`);

        btnSel.addEventListener("click", () => {
          inputFile.click();
        });

        inputFile.addEventListener("change", () => {
          if (inputFile.files.length > 0) {
            inputNombre.value = inputFile.files[0].name;
            btnUp.classList.remove("d-none");
          } else {
            inputNombre.value = "";
            btnUp.classList.add("d-none");
          }
        });

        btnUp.addEventListener("click",async () => {
          toast( 'success',`Subiendo archivo para ${campo.label}`);
          await subirArchivo(id, campo.key, inputFile.files[0]);
        });
      }
    });

    // Después de renderizar, agrega la lógica para eliminar
    campos.forEach((campo) => {
      const encontrado = data.find(item => item.tipo_doc === campo.key);
      if (encontrado) {
        const btnDel = document.getElementById(`btn_del_${campo.key}`);
        if (btnDel) {
          btnDel.addEventListener("click", async () => {
            Preguntar(async () => {
              await eliminarArchivo(id, campo.key);
              listar_data_cotizacion(id);
              toast('success',`Archivo ${campo.label} eliminado`);
            }, `¿Estás seguro de eliminar el archivo ${campo.label}?`, "warning");
          });
        }
      }
    });
  }

  listar_data_cotizacion(id);
});
