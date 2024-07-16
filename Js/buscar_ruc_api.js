document.getElementById('btnBuscar').addEventListener('click', () => {
    const ruc_buscado = document.getElementById('ruc_buscado').value; // Obtener el RUC del input
    const razonSocial = document.getElementById('razon_social');
    const ruc = document.getElementById('ruc');
    const direccion = document.getElementById('direccion');
    const url = '../Api/api.php';
  
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `numero=${encodeURIComponent(ruc_buscado)}` // Enviar el RUC
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        razonSocialBuscado = data.razonSocial;
        rucBuscado = data.numeroDocumento;
        direccionBuscada = data.direccion;
  
        razonSocial.value = razonSocialBuscado;
        ruc.value = rucBuscado;
        direccion.value = direccionBuscada;
  
    })
    .catch(error => {
        console.error('Error:', error);
    });
  });