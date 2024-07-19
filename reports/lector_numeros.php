<?php

function numero_a_palabras($numero) {
    $unidad = ['', 'uno', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve'];
    $decena = ['', 'diez', 'veinte', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta', 'noventa'];
    $centena = ['', 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos', 'seiscientos', 'setecientos', 'ochocientos', 'novecientos'];
    $especiales = ['diez', 'once', 'doce', 'trece', 'catorce', 'quince', 'dieciséis', 'diecisiete', 'dieciocho', 'diecinueve'];
    
    if ($numero == 0) {
        return 'cero';
    }

    $palabras = '';

    if ($numero >= 1000000) {
        $millones = floor($numero / 1000000);
        if ($millones == 1) {
            $palabras .= 'un millón ';
        } else {
            $palabras .= numero_a_palabras($millones) . ' millones ';
        }
        $numero %= 1000000;
    }

    if ($numero >= 1000) {
        $mil = floor($numero / 1000);
        if ($mil == 1) {
            $palabras .= 'mil ';
        } else {
            $palabras .= numero_a_palabras($mil) . ' mil ';
        }
        $numero %= 1000;
    }

    if ($numero >= 100) {
        $cien = floor($numero / 100);
        if ($cien == 1 && $numero < 200) {
            $palabras .= 'ciento ';
        } else {
            $palabras .= $centena[$cien] . ' ';
        }
        $numero %= 100;
    }

    if ($numero >= 20) {
        $diez = floor($numero / 10);
        $unidad_restante = $numero % 10;
        $palabras .= $decena[$diez];
        if ($unidad_restante > 0) {
            $palabras .= ' y ' . $unidad[$unidad_restante] . ' ';
        } else {
            $palabras .= ' ';
        }
    } elseif ($numero >= 10) {
        $palabras .= $especiales[$numero - 10] . ' ';
    } elseif ($numero > 0) {
        $palabras .= $unidad[$numero] . ' ';
    }

    return trim($palabras);
}

// Función para convertir un número con decimales en palabras
function convertir_a_palabras($numero) {
    $entero = floor($numero);
    $decimales = round(($numero - $entero) * 100);

    $palabras = ucfirst(numero_a_palabras($entero));
    if ($decimales > 0) {
        $palabras .= ' con ' . numero_a_palabras($decimales) . ' centimos';
    } else {
        $palabras .= ' con cero centimos';
    }

    return $palabras;
}
?>
