<?php
    /*
    Copyright 2010 Thierry BUGEAT
    This file is part of airfoil2pdf.

    airfoil2pdf is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    airfoil2pdf is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with airfoil2pdf.  If not, see <http://www.gnu.org/licenses/>.
    */
    
    require_once('ui/configs/constants.php');
    require_once('ui/languages/en.php');
    require_once('ui/class/Dat.php');
    require_once('ui/inc/airfoil2pdf.inc.php');
    
    $dat = new Dat();
    $dat->setDirDat('airfoils/dat/');
    
    $dats = $dat->getList();

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <title>airfoil2pdf</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF8" />

        <link rel="icon" type="image/png" href="./ui/pics/favicon.png" />

        <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/themes/base/jquery-ui.css" type="text/css" media="all" />
        
        <link rel="stylesheet" type="text/css" href="./ui/css/defaut.css.php?PREFIX_URL_CSS=./" />
        <link rel="stylesheet" type="text/css" href="./ui/css/dropdown.css.php?PREFIX_URL_CSS=./" />
        <link rel="stylesheet" type="text/css" href="./ui/css/lucid.css.php?PREFIX_URL_CSS=./" />
        <link rel="stylesheet" type="text/css" href="./ui/css/airfoil2pdf.css.php" />

        <script type="text/javascript" src="./ui/js/jquery.min.js"></script>
        <script type="text/javascript" src="./ui/js/jquery-ui.min.js"></script>
        
        <script type="text/javascript" src="./ui/js/dropdown.js"></script>
        
    </head>
    <body>

        <form id = "airfoil2pdf_form" method = "post" action = "" >
        
        <input type="hidden" name="dir" value="<?php echo getcwd();?>" />

        <div class="row">

            <div id="accordion">

                <h3><a href="#" class="_wing_root"><?php echo _WING_ROOT; ?></a></h3>
                <div>
                    <?php echo _DAT_NAME; ?> <?php echo selectDat('dat[0]',$dats); ?>
                    <?php echo _CHORD; ?> <input type="text" name="chord[0]" value="170" />
                    <?php echo _WING_ANGLE; ?>
                    <input type="text" name="angle[0]" value="0" />
                </div>
                
                <h3><a href="#" class="_wing_tip"><?php echo _WING_TIP; ?></a></h3>
                <div>
                    <?php echo _DAT_NAME; ?> <?php echo _OPTIONAL; ?> <?php echo selectDat('dat[1]',$dats); ?>
                    <?php echo _CHORD; ?> <input type="text" name="chord[1]" value="120" />
                    <?php echo _WING_ANGLE; ?>
                    <input type="text" name="angle[1]" value="0" />
                </div>
                
                <h3><a href="#" class="_drawing_options"><?php echo _DRAWING_OPTIONS; ?></a></h3>
                <div>
                    <?php echo _HEELS; ?>
                    <input type="checkbox" name="heels" value="1" checked="checked" />
                    <?php echo _CORNERS; ?>
                    <input type="checkbox" name="corners" value="1" checked="checked" />
                    <?php echo _WING_FORMWORK; ?>
                    <select name="wingFormwork">
                        <option value = "0" selected="selected" >0 mm</option>
                        <option value = "1" >1 mm</option>
                        <option value = "1.5" >1.5 mm</option>
                        <option value = "2" >2 mm</option>
                        <option value = "3" >3 mm</option>
                    </select>
                </div>
                
                <h3><a href="#" class="_printer_options"><?php echo _PRINTER_OPTIONS; ?></a></h3>
                <div>
                    <?php echo _PRINTER_PAPER_SIZE; ?>
                        <select name="printerPaperSize">
                            <option value = "A4" selected="selected" >A4</option>
                            <option value = "A3" >A3</option>
                        </select>
                        <?php echo _PRINTER_PAPER_ORIENTATION; ?>
                        <select name="printerPaperOrientation">
                            <option value = "portrait" selected="selected" >portrait</option>
                            <option value = "landscape" >landscape</option>
                        </select>
                        <?php echo _PRINTER_DPI; ?>
                        <select name="printerDpi">
                            <option value = "150" selected="selected" >150 dpi</option>
                            <option value = "300" >300 dpi</option>
                        </select>
                </div>
                
            </div>
            <p>
                <?php echo _NUMBER_OF_AIRFOILS; ?>
                <select name="nbAirfoils">
                    <option value = "1" selected="selected">1</option>
                    <option value = "2" >2</option>
                    <option value = "3" >3</option>
                    <option value = "4" >4</option>
                    <option value = "5" >5</option>
                    <option value = "6" >6</option>
                    <option value = "7" >7</option>
                    <option value = "8" >8</option>
                    <option value = "9" >9</option>
                    <option value = "10" >10</option>
                </select>
                <input type="submit" />
            </p>
        </div>
        
        </form>

        <script type="text/javascript">

            $(document).ready(function() {
                $(function() {
                    $( "#accordion" ).accordion();
                });
            });
            
            /* ================================ */
            /* --- Click on button [submit] --- */
            /* ================================ */

            $("#airfoil2pdf_form").live("submit", function(event)
            {
                // stop form from submitting normally

                event.preventDefault(); 

                // get values from elements on the form:

                //var _url  = $(this).attr( 'action' );
                var _data = $(this).serialize();

                $.ajax({
                    type: "POST",
                    url: "ui/ajax/airfoil2pdf.pl",
                    data: _data,
                    success: function(msg,text){
                        alert(msg);
                    }
                });

            });

        </script>

    </body>
</html>
