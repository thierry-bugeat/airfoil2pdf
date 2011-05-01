<?php
    header("Content-type: text/css");
?>
.ui-accordion .ui-accordion-header a{
    margin-left:7px;
    padding-left:55px;
    font-size: 20px;
    padding-top:10px; height:26px; /* Total height: 36 px */
}
._selected_{
    border-right:2px solid #000;
}
._wing_root, ._wing_tip{
    background:url(../pics/document-send.png) no-repeat 0px 0px;
}
._drawing_options{
    background:url(../pics/document-page-setup.png) no-repeat 0px 0px;
}
._printer_options{
    background:url(../pics/printer.png) no-repeat 0px 0px;
}
.row{
    padding:0px 10px 0px 10px;
}
#col-left{
    float:left;
    width:33%;
}
#col-center{
    float:left;
    width:33%;
}
#col-right{
    float:left;
    width:34%;
}
.ui-accordion .ui-accordion-header {
    padding-left:20px;
}