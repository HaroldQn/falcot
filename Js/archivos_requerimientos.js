// Selecciona el input de tipo file y el botón
const fileInput = document.getElementById("inputGroupFile04");
const uploadButton = document.getElementById("inputGroupFileAddon04");

// Deshabilita el botón inicialmente
uploadButton.disabled = true;

// Agrega un evento 'change' al input
fileInput.addEventListener("change", () => {
  if (fileInput.files.length > 0) {
    // Habilita el botón si hay un archivo seleccionado
    uploadButton.disabled = false;
    console.log("Archivo seleccionado:", fileInput.files[0].name);
  } else {
    // Deshabilita el botón si no hay archivo seleccionado
    uploadButton.disabled = true;
  }
});



uploadButton.addEventListener("click", () => {
  // Realiza la carga del archivo aquí
  console.log("Cargando archivo:", fileInput.files[0].name);
});