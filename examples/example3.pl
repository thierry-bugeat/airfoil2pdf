#!/usr/bin/perl -w

# **************************************************************
# * example3.pl                                                *
# *------------------------------------------------------------*
# * Date :       Author :          Comments :                  *
# * ======       ========          ==========                  *
# * 07.11.2010   Thierry           Update : 07.11.2010         *
# **************************************************************

use lib "../modules";

use airfoil2pdf

$airfoil = airfoil2pdf->new();
$airfoil->setDirDat('../airfoils/dat/');
$airfoil->setDirOutput('../output/');

$airfoil->setWingRoot( %params = ( 'dat' => 'e169', 'chord' => 300 ) );

$airfoil->setWingTip ( %params = ( 'dat' => 'naca2412', 'chord' => 200 ) );

$airfoil->setNbNervures(5);
$airfoil->setEpaisseurCoffrage(1.5);        # 1, 1.5, 2, 3
$airfoil->setPaperSize('A3');               # A4, A3
$airfoil->setPaperOrientation('portrait');  # portrait, paysage
$airfoil->createPdf();
