<?php

session_start();

if(isset($_SESSION['total'])){
    $_SESSION['total']++;
}else{
    $_SESSION['total']=0;
}

    header('Location: somenteLogado.php');


?>