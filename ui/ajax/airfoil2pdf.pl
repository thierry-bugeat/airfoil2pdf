#!/usr/bin/perl -w

# Copyright 2011 Thierry BUGEAT
# This file is part of airfoil2pdf.
# 
# airfoil2pdf is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# airfoil2pdf is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with airfoil2pdf.  If not, see <http://www.gnu.org/licenses/>.

print "content-type: text/html, charset=utf-8\n\n";

#use Cwd;
#my $dir = getcwd;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $cgi = new CGI;

my @params = $cgi->param();

if (!( -w $cgi->param('dir').'/output/' )) {
   print "ERROR : Cannot write in directory \"".$cgi->param('dir')."/output/\"\n";
   exit;
}

#print $cgi->header(), $cgi->start_html('airfoil2pdf.pl');
#
#    foreach my $param (@params) 
#    {
#        print $param, $cgi->param($param), "<br>\n";
#    }
#
#print $cgi->end_html();

use lib $dir."../../modules";

use airfoil2pdf

$airfoil = airfoil2pdf->new();
$airfoil->setDirDat('../../airfoils/dat/');
$airfoil->setDirOutput('../../output/');

%params = ( 'dat'   => $cgi->param('dat[0]'),
            'chord' => $cgi->param('chord[0]'),
            'angle' => $cgi->param('angle[0]'));                        # -2° ... +2°

$airfoil->setWingRoot(%params);

%params = ( 'dat'   => $cgi->param('dat[1]'),
            'chord' => $cgi->param('chord[1]'),
            'angle' => $cgi->param('angle[1]'));                        # -2° ... +2°

$airfoil->setWingTip(%params);

$airfoil->setTalonNervure($cgi->param('heels'));                        # 0, 1
$airfoil->setCoinsDecoupe($cgi->param('corners'));                      # 0, 1
$airfoil->setNbNervures($cgi->param('nbAirfoils'));
$airfoil->setEpaisseurCoffrage($cgi->param('wingFormwork'));            # 0, 1, 1.5, 2, 3

$airfoil->setPaperSize($cgi->param('printerPaperSize'));                # A4, A3
$airfoil->setPaperOrientation($cgi->param('printerPaperOrientation'));  # portrait, landscape
$airfoil->setDpi($cgi->param('printerDpi'));                            # 150, 300

$airfoil->createPdf();

print "OK";
