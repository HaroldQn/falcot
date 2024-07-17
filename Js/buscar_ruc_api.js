function registrarClienteApi(razonSocial, numeroDoc, direccion,
    correo, distrito, ubigeo, actividadEconomica, telefono){
const parametros = new FormData();
parametros.append("operacion","registrar_clientes")
parametros.append("razonSocial",razonSocial)
parametros.append("nroDocumento",numeroDoc)
parametros.append("direccion",direccion)
parametros.append("correo", correo)
parametros.append("iddistrito",distrito)
parametros.append("ubigeo",ubigeo)
parametros.append("actividadEconomica",actividadEconomica)
parametros.append("telefono",telefono)

fetch(`../Controllers/cliente.controller.php`, {
    method: "POST",
    body: parametros
})
    .then(res => res.json())
    .then(datos => {
    //  console.log(datos)

    })
    .catch((error) => {
        console.log(error);
    });
};  

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
        if(data.razonSocial){
            console.log(data)
            razonSocialBuscado = data.razonSocial;
            rucBuscado = data.numeroDocumento;
            direccionBuscada = data.direccion;
      
            razonSocial.value = razonSocialBuscado;
            ruc.value = rucBuscado;
            direccion.value = direccionBuscada;
        }else{
            console.log("no hay datos")
        }
  
    })
    .catch(error => {
        console.error('Error:', error);
    });
  });