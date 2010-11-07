#!/usr/bin/perl -w

# **************************************************************
# * example4.pl                                                *
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

%params = ( 'dat'   => 'e169',
            'chord' => 170,
            'angle' => 2        );  # -2° ... +2°

$airfoil->setWingRoot(%params);

%params = ( 'dat'   => 'naca2412',
            'chord' => 120,
            'angle' => -2       );  # -2° ... +2°

$airfoil->setWingTip(%params);

$airfoil->setTalonNervure(1);               # 0, 1
$airfoil->setCoinsDecoupe(1);               # 0, 1
$airfoil->setNbNervures(5);
$airfoil->setEpaisseurCoffrage(1.5);        # 1, 1.5, 2, 3

$airfoil->setPaperSize('A4');               # A4, A3
$airfoil->setPaperOrientation('portrait');  # portrait, paysage
$airfoil->setDpi(150);                      # 150, 300

$airfoil->createPdf();
