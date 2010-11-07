#!/usr/bin/perl -w

# **************************************************************
# * example2.pl                                                *
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

$airfoil->setWingRoot( %params = ('dat' => 'e169', 'chord' => 180) );

$airfoil->setWingTip ( %params = ('chord' => 120) );

$airfoil->setNbNervures(14);
$airfoil->createPdf();
