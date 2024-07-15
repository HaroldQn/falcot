<?php

$clave = "admin";

$claveEncriptada = password_hash($clave, PASSWORD_BCRYPT);

var_dump($claveEncriptada);