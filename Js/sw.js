function bienvenida(mensaje){
    const Toast = Swal.mixin({
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 2000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
      }
    })
  
    Toast.fire({
      icon: 'success',
      title: mensaje
    })
  }
  
  function notificar(icon,titulo, mensaje, tiempo){
    Swal.fire({
      icon: icon,
      title: titulo,
      text: mensaje,
      confirmButtonColor: '#2E86C1',
      confirmButtonText: 'Aceptar',
      footer: '',
      timerProgressBar: true,
      timer: (tiempo * 1000)
    })
  }
  
  
  function mostrarPregunta(titulo, mensaje) {
    return Swal.fire({
      title: titulo,
      text: mensaje,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Aceptar',
      cancelButtonText: 'Cancelar',
      confirmButtonColor: '#2E86C1',
      cancelButtonColor: '#797D7F',
      footer: ''
    });
  }

  function PreguntarEliminar(callback) {
    return Swal.fire({
      title: `¿Estás seguro de rechazar esta orden de compra?`,
      text: "Este procedimiento no se podrá revertir",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      cancelButtonText: "Cancelar",
      confirmButtonText: "Rechazarlo"
      }).then((result) => {
          if (result.isConfirmed) {
              callback()
          }
  });
  }