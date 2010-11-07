#!/usr/bin/perl -w

# **************************************************************
# * example1.pl                                                *
# *------------------------------------------------------------*
# * Date :       Author :          Comments :                  *
# * ======       ========          ==========                  *
# * 02.11.2010   Thierry           Update : 02.11.2010         *
# **************************************************************

use lib "../modules";

use airfoil2pdf

$airfoil = airfoil2pdf->new();
$airfoil->setDirDat('../airfoils/dat/');
$airfoil->setDirOutput('../output/');

$airfoil->setWingRoot( %params = ('dat' => 'e169', 'chord' => 200) );

$airfoil->createPdf();
