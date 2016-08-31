<?php

session_start();

// print_r($_SESSION);


if(isset($_POST['email']) != 0 && isset($_POST['password']) != 0){


    if(strcmp($_POST['email'], 'root') == 0 &&
       strcmp($_POST['password'], 'root') == 0 ){
        $_SESSION['logado'] = true;
    }else{ echo "wrong";}
    
}else{ echo "not submitted";}

if (isset($_SESSION['logado'])) {
    ?>

    <h1>Logado, clique abaixo para sair</h1>
    <a href="logout.php">sair</a>

    <?php

     $listaSecreta = array('Item Hello','Item world');

     $lista = array_reduce( 
            array_map( function($i){ 
                return "<li>$i</li>"; //map
            }, $listaSecreta ), function($a,$i){ 
                return $i . $a;//reduce
            });
     echo "<ul>$lista</ul>";
     echo "<a href='somenteLogado.php'>somente Logado</a>";
}else{
     
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Wreq</title>
</head>
<body>
    <h1>Logar</h1>
    <form action="loginForm.php" method="post" accept-charset="utf-8">
        <input type="text" name="email" value="root" >
        <input type="password" name="password" value="root" >
        <input type="submit" value="Entrar">
    </form>
<?php 

 }

?>
</body>
</html>