<?php
    function selectDat($name,$aDats)
    {
        $out = '';
        
        $out .= '<select name = "'.$name.'">';
        $out .= '<option value = "" >---</option>';
        
        foreach ( $aDats as $dat )
        {
            $out .= '<option value = "'.$dat.'" >'.$dat.'</option>';
        }
        
        $out .= '</select>';
        
        return $out;
    }
?>
