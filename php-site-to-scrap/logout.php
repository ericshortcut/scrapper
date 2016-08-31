<?php

session_start();
session_destroy();

$_SESSION['logado'] = false;

header('Location: loginForm.php')
?>