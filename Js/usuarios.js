document.addEventListener("DOMContentLoaded",()=>{
    function $(id){
        return document.querySelector(id);
    }
    const lista = document.getElementById('lista-usuarios');
    const btnEliminar = document.querySelectorAll(".eliminar")
    const btnGuardar = document.getElementById('guardar');
    const btnGuardarClave = document.getElementById('guardar_clave');
    const formUsuario = document.getElementById('form-usuario');
    const modalUsuario = document.getElementById('modal-usuario');
    
    function listarUsuarios(){
        const parametros = new FormData();
        parametros.append("operacion","listarUsuarios");
        fetch(`../Controllers/usuario.controller.php`,{
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(data =>{
            lista.innerHTML = '';
            datos = data.filter( rol => rol.rol == 'asistente');
            console.log(datos)
            if (datos.length == 0) {
                let fila = `
                    <tr>
                        <td colspan="5" class="text-center">No hay datos</td>
                    </tr>
                `
                lista.innerHTML += fila
            }
            else{
                datos.forEach( usuario => {
                    let fila = '';
    
                    fila =`
                        <tr>
                            <td>${usuario.usuario}</td>
                            <td>${usuario.nombres}</td>
                            <td>${usuario.apellidos}</td>
                            <td>${usuario.rol}</td>
                            <td>
                                <button class="btn btn-primary editar" id="btn-editar-${usuario.idusuario}" data-id="${usuario.idusuario}" data-bs-toggle="modal" data-bs-target="#modal-clave">Editar</button>
                                <button class="btn btn-danger eliminar" id="btn-eliminar-${usuario.idusuario}" data-id="${usuario.idusuario}"><i class="bi bi-trash"></i></button>
                            </td>
                            
                        </tr>
                    `
                lista.innerHTML += fila;
                });
            }
        });
    }

    function registrarUsuario(){
        const parametros = new FormData();
        parametros.append("operacion","registrarUsuario");
        parametros.append("usuario",$("#usuario").value);
        parametros.append("clave",$("#clave").value);
        parametros.append("nombres",$("#nombres").value);
        parametros.append("apellidos",$("#apellidos").value);
        parametros.append("rol",2);
        fetch(`../Controllers/usuario.controller.php`,{
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(data =>{
            listarUsuarios();
            window.location.href = './usuarios.php';
        })
        .catch(error => {
            notificar('error','El usuario ya existe antes o no se pudo registrar','Vuelva a intentarlo con otro nombre de usuario',2);
        });
    }

    function eliminarUsuario(id){
        const parametros = new FormData();
        parametros.append("operacion","eliminarUsuario");
        parametros.append("idusuario",id);

        fetch(`../Controllers/usuario.controller.php`,{
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(data => {
            listarUsuarios();
            bienvenida(`¡Usuario eliminado exitosamente!`);
        });

    }

    function actualizarClave(id){
        const parametros = new FormData();
        parametros.append("operacion","actualizarClave");
        parametros.append("idusuario",id);
        parametros.append("clave",$("#clave_nueva").value);
        fetch(`../Controllers/usuario.controller.php`,{
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(data =>{
            listarUsuarios();
            window.location.href = './usuarios.php';
        })
        .catch(error => console.log(error));
    }

    lista.addEventListener("click", (event) => {
        if (event.target.classList.contains('eliminar')) {
            let idusuario = event.target.dataset.id;
            
            mostrarPregunta("FALCOT TECHNOLOGY", "¿Está seguro de eliminar este usuario?").then((result) => {          
                if (result.isConfirmed) {
                    eliminarUsuario(idusuario);
                }
            });
        }
    });

    lista.addEventListener("click", (event) => {
        if (event.target.classList.contains('editar')) {
            let idusuario = event.target.dataset.id;

            btnGuardarClave.addEventListener("click", (event) => {
                actualizarClave(idusuario);
            });
        }
    });    

    btnGuardar.addEventListener("click", (event) => {
        registrarUsuario();
    });


    listarUsuarios();
});