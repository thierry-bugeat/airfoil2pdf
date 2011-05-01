<?php
/*
Copyright 2011 Thierry BUGEAT
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

/**
 * Management Dat files and data
 * 
 * @name Dat.php
 * @author Thierry BUGEAT <thierry.bugeat@free.fr> 
 * @link 
 * @copyright Thierry BUGEAT 2011
 * @version 0.0.1
 * @package Dat.php
 */
 
 class Dat {
 
    // ==================
    // --- propriétés ---
    // ==================

    private $propriete;
    
    // ===============
    // --- Methods ---
    // ===============
    
    /**
    * Construct
    * 
    * @name Dat::__construct()
    * @param null
    * @return void 
    */
    
    public function __construct()
    {
        // --- DAT ---
    
        $this->{directory_dat} = 'airfoils/dat/';
    }
    function setDirDat($dir){
        $this->{directory_dat} = $dir;
    }
    function getList(){
        $dats = array();

        $d = dir($this->{directory_dat});

        while (false !== ($entry = $d->read())) 
        {
            if (preg_match('/\.dat/',$entry))
            {
                $entry = preg_replace('/\.dat/','',$entry);
                array_push($dats, $entry);
            }
        }
        
        $d->close();
        
        $dats_sort = sort($dats,SORT_STRING);
        
        return $dats;
    }
}
?>