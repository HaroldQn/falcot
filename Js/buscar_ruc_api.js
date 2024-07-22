let distrito_cli = "";
let ubigeo_cli = "";
let actvidaEco_cli = "";
let provincia_cli = "";
let departamento_cli= "";

function limpiarInputsCliente(){
    razon_social.value = '';
    ruc.value = '';
    direccion.value = '';
    celular.value = '';
    correo.value = '';
    contacto.value = '';
    telefono.value = '';
}

function BuscarClienteEnSistema(){
    const razonSocial = document.getElementById('razon_social');
    const ruc = document.getElementById('ruc');
    const direccion = document.getElementById('direccion');

    const parametros = new FormData();
    parametros.append("operacion","buscar_cliente_ruc")
    parametros.append("ruc", ruc_buscado.value)

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)

        distrito_cli = datos.distrito;
        ubigeo_cli = datos.ubigeo;

        razon_social.value = datos.razonSocial;
        ruc.value = datos.nroDocumento;
        direccion.value = datos.direccion;
        celular.value = datos.celular;
        correo.value = datos.correo;
        contacto.value = datos.contacto;
        telefono.value = datos.telefono;

      })
      .catch((error) => {
          console.log(error);
      });
}

function BuscarClientePorApi(){
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
            // console.log(data)
            razonSocialBuscado = data.razonSocial;
            rucBuscado = data.numeroDocumento;
            direccionBuscada = data.direccion;

            distrito_cli = data.distrito;
            ubigeo_cli = data.ubigeo;
            provincia_cli = data.provincia;
            departamento_cli= data.departamento;
      
            razonSocial.value = razonSocialBuscado;
            ruc.value = rucBuscado;
            direccion.value = direccionBuscada;
            correo.value = '';
            contacto.value = '';
            telefono.value = '';
            celular.value = '';
        }else{
            limpiarInputsCliente();
            notificar('error','No se encontro ningun registro','ingrese otro ruc',2);
        }
  
    })
    .catch(error => {
        console.error('Error:', error);
    });
}


function verificarBusquedaCliente(){
    const parametros = new FormData();
    parametros.append("operacion","verificar_cliente")
    parametros.append("ruc", ruc_buscado.value)

    fetch(`../Controllers/cliente.controller.php`, {
      method: "POST",
      body: parametros
    })
      .then(res => res.json())
      .then(datos => {
        console.log(datos)
        if(datos.exists == 1){
            console.log("cliente existe")
            BuscarClienteEnSistema()

        }else if(datos.exists == 0){
            BuscarClientePorApi()
        }
      })
      .catch((error) => {
          console.log(error);
      });
}

document.getElementById('btnBuscar').addEventListener('click', () => {

    verificarBusquedaCliente()

});