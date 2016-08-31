<?php

session_start();

$msg = "";

if (isset($_SESSION['logado'])){

    $msg = "<h1>---> Mensagem secreta... ['secret']</h1>";

}else{

    header('Location: loginForm.php');

}

?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
</head>
<body>
    <h3 data-sec="<?php echo $msg; ?>">Secreto</h3>    
    <a href="cart.php">add</a>
    <h2><?php if(isset($_SESSION['total'])) echo $_SESSION['total']; ?></h2>
</body>
</html>
