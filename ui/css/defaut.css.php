<?php
    header("Content-type: text/css");
    $PREFIX_URL_CSS = $_GET['PREFIX_URL_CSS'];
?>
body {
    margin: 0px;
    padding: 0px;
    background:url("<?=$PREFIX_URL_CSS?>defaut/background.jpg") no-repeat top center fixed #494949;
    /*background-attachment:fixed;*/
    /* font:0.75em Verdana,Arial,Clean,Helvetica,sans-serif; */
    font:11px Trebuchet MS, Tahoma,Arial CE, Helvetica;
    line-height: 125%;
    text-align:left;
    color:#000;
    font-family: Arial, sans-serif;
}
ul {
    margin: 0px;
    padding-left: 23px;
    line-height: 125%;
    text-align:left;
    color:#000000;
}
li{
    //list-style:none;
    color:#dddddd;
}

._a_ { cursor:pointer; }

a, ._a_{text-decoration:none;color:#8cb145;}

a:hover, ._a_:hover{
    color:#ff0000;
    text-decoration: none;
}

a img {
    border:0px;
}

a.warning{
    background:url(<?=$PREFIX_URL_CSS?>defaut/warning.png) no-repeat top right;
    padding-right:14px; 
}


a.info{ position:relative; }
a.info:hover{ z-index:25; }
a.info span{display:none}
a.info:hover span{
    display:block;
    position:absolute;
    top:0%;
    left:100%;
    padding:3px;
    margin-left:4px;
    width:200px;
    font-style:normal;
    color:gray;
    font-weight:normal;
    border:1px solid gray;
    background-color:#ffffb5;
    line-height:110%;
    border-radius:5px;
    -moz-border-radius:5px;
    -webkit-border-radius: 5px;
}

h1{margin:0px;font-size:14px;}
h2{margin:0px;font-size:12px;}
h3{margin:0px;font-size:11px;}
h4{margin:0px;font-size:11px;font-weight:normal;}
h5{margin:0px;font-size:10px;font-weight:normal;}

#console{
    display:none;
    background:#000000;
    color:#ccc;
    font-family:courier;
    height:75px;
    padding-left:2px;
    overflow:auto;
    left:100%;
    top:100%;
    margin-left:-742px;
    margin-top:-90px;
    position:fixed;
    width:500px;
    border:1px solid #666;
    filter:alpha(opacity=85);
    -moz-opacity: 0.85;
    opacity: 0.85;
}

.scrollbox{
    overflow:auto;
    width:100%;
    margin:3px 0px 3px 0px;
    height:60px;
    border:0px solid #666666;
}
.admin_url{
    font-family:Arial,Helvetica,serif;
    font-size:1em;
    color:#444444;
    font-weight:bold;
}
.admin_version{color:#ffffff; font-weight:normal;}
.version{color:#dddddd; font-weight:normal; padding-top:12px;}
.titre_site{
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/logo_maron.gif') no-repeat 0px 0px;
    height:40px;
    padding-left:45px;
}
table {
    border-collapse:separate;
    border-spacing:0px;
    text-align:left;
}

.menus{
	border:2px solid white;
	background-color:#c6bb60;
	width:200px;
	padding:4px;
}
.menus_extensions{
	border:2px solid white;
	background-color:#c6bb60;
	width:200px;
	padding:4px;
}
.menus_su{
	border:2px solid white;
	background-color:#c6bb60;
	width:200px;
	padding:4px;
}
.su_titre_mini{
	float:left;
	background:transparent url('<?=$PREFIX_URL_CSS?>defaut/lock_mini.gif') no-repeat 0px 0px;
	padding-left:19px;
	padding-right:3px;
	height:16px;
}
.admin{
	background-color:#dddddd;
	width:200px;
	margin-bottom:4px;
}

td.titre {
	font-size:				1em;
	color:					#444444;
	font-weight:			bold;
}

td.titre_colonne_non_visible {
	font-size:				1em;
	color:					#aaaaaa;
	font-weight:			bold;
}

.floatLeft{float:left;}
.floatRight{float:right;}
.float1{
	float:left;
	background-color:#e6e0d2;
	padding:5px;
	border:2px solid white;
	margin-right:0px;
}
.float2{
}
.titre {
	font-size:				1em;
	color:					#444444;
	font-weight:			bold;	
}
.SQL_titre {
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/folder-remote.png') no-repeat 0px 3px;
    height:18px;
    padding-left:28px;
    padding-top:8px;
    font-size:				1em;
    color:					#444444;
    font-weight:			bold;	
    border-top:1px solid #dddddd;
    margin-top:3px;
}

.titre_colonne {
    text-align:center;
    padding-left:5px;
    padding-top:3px;
    font-size:				1em;
    color:					#444444;
    font-weight:			bold;	
    border:1px solid #bbbbbb;
    border-bottom:0px;
    background:#eee;
    -moz-border-radius-topright: 9px;
    -webkit-border-top-right-radius: 9px;
    -moz-border-radius-topleft: 9px;
    -webkit-border-top-left-radius: 9px;
    border-radius: 9px;
}

form{
}

input{
    border:1px solid #888888;
    background-color:#ffffff;
    font-size:10px;
    text-align:left;
    color:#8cb145;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    border-radius: 4px;
}

input.libelles{
	font-size:10px;
	width:90px;
}

select {font-size:10px;}
.textarea{
	width:500px;
	height:100px;
	color:#666666;
	background-color:#efefef;
	border-top:0px solid #aaaaaa;
	border-right:1px solid #aaaaaa;
	border-bottom:1px solid #aaaaaa;
	border-left:1px solid #aaaaaa;
}
textarea.edit{
	width:500px;
	height:150px;
}
.total{
	font-size:				0.8em;
	color:					#9C9C9C;
	font-weight:			none;	
}
.externe{
	font-style:italic;
	color:gray;8cb145
}
.alerte{font-style:italic; color:red;}
.ok{font-style:italic; color:green;}

.remarque{
    padding:3px;
    font-style:normal;
    color:gray;
    font-weight:normal;
    border:1px solid gray;
    background-color:#ffffb5;
    line-height:110%;
    border-radius:5px;
    -moz-border-radius:5px;
    -webkit-border-radius: 5px;
}

.clearleft{
	clear:left;
}
.boxScroll2 {position:relative; float:left; left:0px; top:0px; width:350px; height:150px; overflow:auto;}
.boxScroll {position:relative; float:left; left:0px; top:0px; width:100px; height:233px; overflow:auto; margin-left:10px;}
.boxScroll_horizontal {position:relative; float:left; left:0px; top:0px; width:615px; height:80px; overflow:auto; margin:0px 0px 0px 10px; border:1px solid black;}
.recherche{
	width:60px;
}
.helpline { background-color: #465584; border-style: none; color:white; }
.sauver{font-size:10px; color:blue;}
.ajouter{font-size:10px;}
.supprimer{font-size:10px; color:red;}
.strike{font-style:italic; color:gray;}
.footer{
	text-align:left;
	margin:0px;
	padding:0px 0px 0px 10px;
	font-size:10px; color:#666;
}
.gray{color:#aaaaaa;}

.menu_inactive a, .menu_active a{
    display:block;
}

.menu_inactive:hover{
    background-color:#f4f4f4;
}

.menu_inactive:hover a{
    color:#888;
}

.menu_active{
    background: url(<?=$PREFIX_URL_CSS?>defaut/arrow0.gif) no-repeat 0px 40%;
    padding-left:18px;
}
.menu_active:hover{
    background-color:#8cb145;
}

.menu_active:hover a{
    color:#fff;
}

.news_inactive{}

.news_active{
    background: url(<?=$PREFIX_URL_CSS?>pics/arrow0.gif) no-repeat 2px 40%;
    padding-left:18px;
}

.bgcolor0{background-color:#ffffff; padding:1px 0px 1px 0px; text-align:center;}
.bgcolor1{background-color:#f4f4f4; padding:1px 0px 1px 0px; text-align:center;}

.menus_row0{background-color:#fff; padding:1px 0px 1px 0px;}
.menus_row1{background-color:#fff; padding:1px 0px 1px 0px;}

.menus_row0 li { padding-left:5px;}
.menus_row1 li { padding-left:5px;}

.ligne{clear:left; width:100%; float:left; border:1px solid blue;}
.cellule{float:left; width:40px; height:50px; border:1px solid red;}

.colonne_de_tri{font-style:italic; color:#8cb145;}

.count{
    color:white;
    background:#ccc;
    -moz-border-radius:8px;
    -webkit-border-radius:8px;
    border-radius:8px;
    padding:0px 3px 0px 3px;
}

/* --- Boites aves les coins arrondis : TITRES ---\*/

.ib_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/logo_rounded.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.main_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/main.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.upload_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/upload.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.extensions_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/extensions.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.su_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/su.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.show_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/show_table.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.edit_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/edit.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}

.news_liste_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/news_liste.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}
.news_edit_titre{
	background: url(<?=$PREFIX_URL_CSS?>defaut/news_edit.gif) no-repeat;
	height:40px;
	padding-top:15px;
	padding-left:50px;
}

/* --- LOGIN ---*/

.formConnexion{
	position:absolute;
	left:50%;
	top:50%;
	width:400px;
	height:350px;
	margin-left:-200px;
	margin-top:-180px;
	-moz-border-radius: 15px;
	-webkit-border-radius: 15px;
    border-radius: 15px;
	background:#111;
}

.formConnexion .boxbody{ background:none; border:0px; }

.formConnexion submit{ font-size:50px; color:red; }

#admin_logo{
    text-align:center;
    margin-top:5px;
    padding-top:45px;
    color:#000;
    background: url(<?=$PREFIX_URL_CSS?>defaut/logo_rounded.gif) no-repeat top center;
}

#admin_login { 
    background: url(<?=$PREFIX_URL_CSS?>defaut/user.gif) #FFF no-repeat;
    height:53px;
    padding-left:55px;
    border:1px solid #a29587;
}

#admin_login input { 
    height:31px; 
    width:100%; 
    border:0px; 
    color:#000; 
    font-size:20px;
    padding-top:15px;
}

#admin_password { text-align:right; width:100%; margin-top:5px; margin-bottom:5px; }

#admin_password #title { float:left; text-align:left; width:75px; }
#admin_password input  { width:225px; border:1px solid #a29587; }

/* =========== */
/* --- SQL --- */
/* =========== */

#sql_table{ width:100%; }

.sql_toolbar_edit{
    position:fixed;
    width:200px;
    height:78px;
    left:100%;
    top:100%;
    margin-left:-234px;
    margin-top:-97px;
    text-align:center;
    border:3px solid #aaa;
    background:#eee;
    padding:3px;
    -moz-border-radius-topleft: 9px;
    -webkit-border-top-left-radius: 9px;
    -moz-border-radius-topright: 9px;
    -webkit-border-top-right-radius: 9px;
    -moz-border-radius-bottomleft: 9px;
    -webkit-border-bottom-left-radius: 9px;
    -moz-border-radius-bottomright: 9px;
    -webkit-border-bottom-right-radius: 9px;
    border-radius: 9px;
    /*-moz-box-shadow: 0 0 3em #ddd;*/
    /*-webkit-box-shadow: 0 0 3em #ddd;*/
}

.sql_toolbar_edit input{
    width:98%;
    height:24px;
    margin:0px auto;
    text-align:center;
    margin:1px 0px 1px 0px;
    padding-left:24px;
    border:1px solid #bbb;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    border-radius: 3px;
    background:url('<?=$PREFIX_URL_CSS?>defaut/floppy.png') no-repeat 0px 0px;
}

.sql_toolbar_edit input:hover{
    cursor:pointer;
    background:url('<?=$PREFIX_URL_CSS?>defaut/floppy-hover.png') #ddd no-repeat 0px 0px;
}

.sql_checkbox0{}
.sql_checkbox0 h3 {
    background-image: url('<?=$PREFIX_URL_CSS?>defaut/checkbox0.gif');
    background-repeat: no-repeat;
    background-position: left;
    width:13px; height:16px;
    margin:0px auto;
}
.sql_checkbox0 h3 span{ display:none; }

.sql_checkbox1{}
.sql_checkbox1 h3 {
    background-image: url('<?=$PREFIX_URL_CSS?>defaut/checkbox1.gif');
    background-repeat: no-repeat;
    background-position: left;
    width:13px; height:16px;
    margin:0px auto;
}
.sql_checkbox1 h3 span{ display:none; }

#sql_empty_table{}
#sql_empty_table h3 {
    background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_empty_table.gif');
    background-repeat: no-repeat;
    background-position: left;
    width:37px; height:26px;
}
#sql_empty_table h3 span{ display:none; }

#sql_back_first{}
#sql_back_first h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_back_first.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#sql_back_first h3 span{ display:none; }

#sql_back{}
#sql_back h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_back.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#sql_back h3 span{ display:none; }

#sql_next{}
#sql_next h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_next.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#sql_next h3 span{ display:none; }

#sql_actualise{}
#sql_actualise h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_actualise.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#sql_actualise h3 span{ display:none; }

#sql_close{}
#sql_close h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/sql_close.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#sql_close h3 span{ display:none; }

#sql_url{ color:#aaa; }

.sql_edit_input{ color:black; text-align:center; background:none; border:1px solid #ddd; }
.sql_edit_input:hover{ color:black; background:white; border:1px solid #666; }

.sql_delete{
    display:block;
    width:16px;
    height:16px;
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/delete_mini.gif') no-repeat;
}

.sql_delete:hover{
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/delete_mini.gif') no-repeat;
}

.sql_alter_numeric{
    -moz-user-select: none;
    -webkit-user-select:none;
}
.sql_alter_numeric span._a_{
    background:#eeeeee;
    border-left:1px solid #dddddd;
    border-right:1px solid #dddddd;
    border-bottom:1px solid #dddddd;
    font-size:10px;
    text-align:center;
    -moz-border-radius-bottomleft: 4px;
    -webkit-border-top-right-radius: 4px;
    -moz-border-radius-bottomright: 4px;
    -webkit-border-bottom-right-radius: 4px;
    border-radius: 4px;
    padding:0px 5px 0px 5px;
    margin:0px;
}
.sql_alter_numeric span._a_:hover{
    background:#cccccc;
}

/* --- NEWS --- */

#news_back0{}
#news_back0 h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/news_stop_left.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#news_back0 h3 span{ display:none; }

#news_back1{}
#news_back1 h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/news_back.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#news_back1 h3 span{ display:none; }

#news_next0{}
#news_next0 h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/news_stop_right.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#news_next0 h3 span{ display:none; }

#news_next1{}
#news_next1 h3 {
	background-image: url('<?=$PREFIX_URL_CSS?>defaut/news_next.gif');
	background-repeat: no-repeat;
	background-position: left;
	width:26px; height:26px;
}
#news_next1 h3 span{ display:none; }

/* --- Boites aves les coins arrondis ---\*/

* html .boxhead h2 {height: 1%;} /* For IE 5 PC */

#sidebox_su{}

.sidebox {
	margin:10px; auto
	width:100%;
    -moz-border-radius: 9px;
	-webkit-border-radius: 9px;
    border-radius: 9px;
	background:#eeeeee;
	/* these go to the end as the css validator does not like them
	will be replaced by border-radius with css3 */	
    font-size: 100%;
    border:1px solid #000000;
    -moz-box-shadow: 0 0 4em #000;
    -webkit-box-shadow: 0 0 4em #000;
}

.boxhead {
    margin: 0;
    padding: 0;
    text-align: left;
    min-width:250px;
}
.boxhead h2 {
	margin: 0px;
	padding: 7px 15px 0px;
	color: white; 
	font-weight: bold; 
	font-size:16px; 
	line-height: 1em;
	text-shadow: rgba(0,0,0,.4) 1px 1px 5px; /* Safari-only, but cool */
}
.boxbody, .boxtoolbar {
	background:#fff;
    border-top:1px solid #cccccc;
    border-right:4px solid #eeeeee;
    border-bottom:1px solid #cccccc;
    border-left:4px solid #eeeeee;
	margin: 0px;
	padding: 5px 10px 0px;
}
.boxfooter {
	margin: 0;
	padding: 0;
	text-align: center;
}
.boxfooter h2 {
    color:#aaa;
    font-weight:normal;
    padding-top:7px;
    height:20px;
}

.checkboxs{
	overflow:auto;
	border:1px solid black;
	width:100%;
	height:100px;
}

#loading{
	position:absolute;
	top:0px;
	left:0px;
	border:0px solid blue;
	background-color:red;
	color:#ffffff;
	font-size:12px;
	font-weight:normal;
	z-index:1000;
}

#popup{
	float:left;
	color:black;
	font-size:12px;
	font-weight:normal;
	z-index:100;
}

.popup_miseEnPage {
	position:absolute;
	top:50%;
	width:800px;
	margin-left:150px;
	top:37px;
	background:#c0c0c0;
	color:#ffffff;
	filter:alpha(opacity=100);
	-moz-opacity: 1.00;
	opacity: 1.00;
	border:0px solid #00ff00;
	z-index:90;
}

.iframe_postlet{
	border:0px solid red;
	margin:0px;
	padding:0px;
	height:250px;
	width:100%;
}

.linkPopup{
background-image:url(../pics/popup.gif);
background-position:right center;
background-repeat:no-repeat;
margin:-2px 0;
padding:2px 22px 2px 0;
}

.formUploadPhoto{
	width:100%;
	padding:5px;
	border:1px solid #c0c0c0;
	-moz-border-radius: 9px;
	-webkit-border-radius: 9px;
	border-radius:9px;
	background:#f4f4f4;
}

.roundedBox{
	width:100%;
	padding:5px;
	border:1px solid #c0c0c0;
	-moz-border-radius-topright: 9px;
	-webkit-border-top-right-radius: 9px;
	-moz-border-radius-bottomleft: 9px;
	-webkit-border-bottom-left-radius: 9px;
	-moz-border-radius-bottomright: 9px;
	-webkit-border-bottom-right-radius: 9px;
    border-radius: 9px;
	background:#f4f4f4;
}

.onglet{
	width:175px;
}

.ui-sortable{line-height:90%;}

.postFilesList{
	width:100%;
	max-height:300px;
	margin-bottom:10px;
	overflow:auto;
}
.postFilesColumnTitle{
	-moz-border-radius-topright: 9px;
	-webkit-border-top-right-radius: 9px;
	-moz-border-radius-topleft: 9px;
	-webkit-border-top-left-radius: 9px;
    border-radius: 9px;
	font-weight:bold;
	text-align:center;
	border:1px solid #bbbbbb;
	border-bottom:0px;
	background:#eeeeee;
	margin:30px;
}
.postFilesColumnTitleBackground{
	padding-top:6px;
	background:#dddddd url('<?=$PREFIX_URL_CSS?>defaut/header.gif') repeat-x 0px 0px;
}

.linkDisconnect{
    height:19px;
    padding-left:28px;
    padding-top:5px;
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/stop.png') no-repeat 0px 0px;
}

.disconnect{
    cursor:pointer;
    display:block;
    background:url('<?=$PREFIX_URL_CSS?>defaut/stop.png') #eeeeee no-repeat 0px 0px;
    min-height:26px;
    width:100%;
    text-align:center;
    text-transform:uppercase;
    -moz-border-radius:6px;
    -webkit-border-radius:6px;
    border-radius:6px;
}
.disconnect:hover{ background:url('<?=$PREFIX_URL_CSS?>defaut/stop.png') #dddddd no-repeat 0px 0px; }

.selectThemePageConnexion{
    margin-left:20px;
}
.selectTheme{
    height:21px;
    padding-left:28px;
    padding-right:1px;
    padding-top:0px;
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/theme.png') no-repeat 0px -2px;
}

#fixedbar {
    -moz-background-clip:border;
    -moz-background-inline-policy:continuous;
    -moz-background-origin:padding;
    -moz-border-radius-topleft: 9px;
    -webkit-border-top-left-radius: 9px;
    -moz-border-radius-topright: 9px;
    -webkit-border-top-right-radius: 9px;
    border-radius: 9px;
    background:#c0c0c0 none repeat scroll 0 0;
    border-top:1px solid white;
    border-left:1px solid white;
    border-right:1px solid white;
    padding:5px;
    position:fixed;
    left:100%;
    top:100%;
    width:150px;
    margin-left:-200px;
    height:30px;
    z-index:1000;
    margin-top:-30px;
}

/* =================== */
/* --- SLIDE PANEL --- */
/* =================== */

#panel {
    background: #f4f4f4;
    height: 70px;
    display: none;
}

#slide {
    margin: 0;
    padding: 0;
    border-top: solid 1px #fff;
    border-bottom:1px solid #777;
    background:#e0e0e0;
    height:20px;
    border:0px solid red;
}

#slide img{
    border:0px;
    height:20px;
    vertical-align:middle;
    opacity:0.4;
    filter:alpha(opacity=40);
}

#slide img:hover{
    opacity:1.0;
    filter:alpha(opacity=100);
}

.btn-slide {
    background: url(<?=$PREFIX_URL_CSS?>defaut/white-arrow.gif) no-repeat right -56px;
    text-align: center;
    width: 154px;
    height: 13px;
    padding: 5px 10px 1px 0;
    margin: 0 auto;
    display: block;
    font: 100%/80% Arial, Helvetica, sans-serif;
    color: #333;
    text-decoration: none;
    float:right;
}

.active { background-position: right 5px; }

#slide .flag{
    height:14px;
}

/* ================ */
/* --- LIBELLES --- */
/* ================ */

.LIBELLES_titre {
    background:transparent url('<?=$PREFIX_URL_CSS?>defaut/locale.png') no-repeat 0px 3px;
    height:18px;
    padding-left:28px;
    padding-top:8px;
    font-size:				1em;
    color:					#444444;
    font-weight:			bold;
    border-top:1px solid #dddddd;
    margin-top:3px;
}

/* --- TOOLBAR --- */

#libelles_toolbar{
    list-style:none;
    padding:0px;
    width:100%;
    border-bottom:1px solid #ddd;
}

#libelles_toolbar li {
    display:inline;
    list-style:none outside none;
}
#libelles_toolbar li a.home {
    background-position:0 -93px;
    margin-left:0;
    padding:0;
    text-indent:-999em;
    width:45px;
}

#libelles_toolbar li a.home:hover{
    background-position:0 -124px;
}

#libelles_toolbar li a {
    background:url("<?=$PREFIX_URL_CSS?>defaut/menu.gif") no-repeat scroll 0 0 transparent;
    color:#382E1F;
    display:block;
    float:left;
    font-size:11px;
    height:31px;
    line-height:31px;
    margin-left:-10px;
    padding:0 20px;
    text-decoration:none;
    z-index:1;
}

#libelles_toolbar li a:hover{
    background-position:0 -62px;
}

#libelles_toolbar li a.lastmenu:hover {
    background-position:0 0;
    cursor:default;
}

/* --- TABLE --- */

#libelles_table{
    border-right:1px solid #ddd;
    border-bottom:1px solid #ddd;
    border-left:1px solid #ddd;
    width:100%;
}

#libelles_table td.titre{
    background:#ddd;
    text-align:center;
}

.libelles_order{
    width:30px;
    text-align:center;
}

/* ClearFix styles\*/


.clearfix:after {
    content: "."; 
    display: block;
    height: 0; 
    clear: both; 
    visibility: hidden;
 }
 
.clearfix{display: inline-block;}

