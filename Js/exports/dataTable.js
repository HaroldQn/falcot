export function dataTable(tablaId) {
  $(tablaId).DataTable({
    "paging": true,
    "ordering": true,
    "order": [[0, "desc"]],
    "searching": true,
    "info": false,
    "pageLength": 50, // Muestra 25 registros por página de inicio
    "language": {
      "paginate": {
        "next": "Siguiente",
        "previous": "Anterior"
      },
      "search": "Buscar:",
      "lengthMenu": "Mostrar _MENU_ registros",
      "zeroRecords": "No se encontraron registros",
      "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
      "infoEmpty": "Mostrando 0 a 0 de 0 registros",
      "infoFiltered": "(filtrado de _MAX_ registros totales)"
    }
  });
}
