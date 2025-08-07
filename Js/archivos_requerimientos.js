import { toast } from "./exports/alert.js"; 

const ID = new URLSearchParams(window.location.search).get("id");
const RUTA = "../Controllers/requerimiento.controller.php";

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
    } catch (err) {
      console.error(`Error al subir ${archivo.name}:`, err);
      toast('error',`Error al subir ${archivo.name}`);
    }

    input.value = "";
    button.disabled = true;
  });
});
