<?php

$clave = "cardenas2024";

$claveEncriptada = password_hash($clave, PASSWORD_BCRYPT);

var_dump($claveEncriptada);