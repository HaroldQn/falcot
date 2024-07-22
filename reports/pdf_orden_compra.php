<?php
  session_start(); // Crea o hereda la sessión

  if (!isset($_SESSION["status"]) || $_SESSION["status"] == false) {
    # code...
    include '../Views/no_acceso.php';
    exit();
  }

// Composer
require_once '../vendor/autoload.php';
require_once './lector_numeros.php';

// Html2Pdf
use Spipu\Html2Pdf\Html2Pdf;
use Spipu\Html2Pdf\Exception\Html2PdfException;
use Spipu\Html2Pdf\Exception\ExceptionFormatter;

try {
    ob_start();

    // Estilos CSS contenidos en un HTML <style>
    include './estilos.html';

    // Incorporar datos dinámicos(BD)
    require_once '../Models/Pdf_orden_compra.php';

    $reporte_header = new Reporte();
    $id = $_GET['idordencompra']; // Valor buscado
    $resultado = $reporte_header->obtener_orden_compra(['idordencompra' => $id]);
    $detalle = $reporte_header->obtener_detalle_orden_compra(['idordencompra' => $id]);
    $totales = $reporte_header->obtener_totales_orden_compra(['idordencompra' => $id]);

    // Convertir el total a palabras
    $totalEnLetras = convertir_a_palabras($totales[0]['Total']);

    // Desplegar la data obtenida en nuestra plantilla
    include './plantilla.php';
    $content = ob_get_clean();
    // Constructor (orientacion, papel, idioma, true, codificacion, margenes(izq, arriba, der, abajo))
    $html2pdf = new Html2Pdf('P', 'A4', 'es', true, 'UTF-8', array(7, 5, 5, 5));

    $html2pdf->pdf->SetDisplayMode('fullpage');
    $html2pdf->writeHTML($content);
    $html2pdf->output('orden-compra-'.$id.'.pdf');
} catch (Html2PdfException $e) {
    $html2pdf->clean();

    $formatter = new ExceptionFormatter($e);
    echo $formatter->getHtmlMessage();
}
