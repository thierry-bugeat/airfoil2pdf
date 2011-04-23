<?php
    header("Content-type: text/css");
    $PREFIX_URL_CSS = $_GET['PREFIX_URL_CSS'];
?>
body {
    background:url("<?=$PREFIX_URL_CSS?>lucid/background.jpg") no-repeat top center fixed #4e1f41;
}
a, input{
    color:#fd6f6b;
}
.formConnexion, .menu_active:hover, .menu_inactive:hover{
    background:#4e1f41;
}
.sidebox {
    background:#DFD7CD;
}
.boxbody {
    border-right:4px solid #DFD7CD;
    border-left:4px solid #DFD7CD;
}

.ib_titre{
    background: url(<?=$PREFIX_URL_CSS?>defaut/logo_rounded.png) no-repeat;
    height:40px;
    padding-top:15px;
    padding-left:50px;
}
