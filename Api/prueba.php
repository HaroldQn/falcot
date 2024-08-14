<?php
// Datos
$token = 'apis-token-9476.n1TEQmlyBZ3fZNy3RjmLY0HFYRcIL28l';

$ruc ='20607908355      ';

if (empty($ruc)) {
    echo json_encode(['error' => 'RUC es requerido']);
    exit;
}

// Permitir acceso desde cualquier origen
header('Access-Control-Allow-Origin: *');
// Permitir los métodos GET, POST, OPTIONS
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
// Permitir los encabezados de solicitud indicados
header('Access-Control-Allow-Headers: Authorization, Content-Type');

// Iniciar llamada a API
$curl = curl_init();

// Buscar RUC en SUNAT
curl_setopt_array($curl, array(
    CURLOPT_URL => 'https://api.apis.net.pe/v2/sunat/ruc/full?numero=' . $ruc,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_SSL_VERIFYPEER => 0,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_CUSTOMREQUEST => 'GET',
    CURLOPT_HTTPHEADER => array(
        'Referer: http://apis.net.pe/api-ruc',
        'Authorization: Bearer ' . $token
    ),
));

$response = curl_exec($curl);
curl_close($curl);

// Establecer el tipo de contenido
header('Content-Type: application/json');

// Devolver la respuesta como JSON
echo $response;
?>