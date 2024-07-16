<?php
// Datos
$token = 'apis-token-9476.n1TEQmlyBZ3fZNy3RjmLY0HFYRcIL28l';

$ruc = $_POST['numero'] ?? '';

if (empty($ruc)) {
    echo json_encode(['error' => 'RUC es requerido']);
    exit;
}

// Iniciar llamada a API
$curl = curl_init();

// Buscar RUC en SUNAT
curl_setopt_array($curl, array(
    CURLOPT_URL => 'https://api.apis.net.pe/v2/sunat/ruc?numero=' . $ruc,
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
