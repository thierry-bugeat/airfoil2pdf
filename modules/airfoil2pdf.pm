package airfoil2pdf;

use strict;

# Wing tip  : Saumon
# Wing root : Emplanture

BEGIN{
    use Exporter;
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

    $VERSION = 0.33;

    use PDF::Create;
    use Math::Bezier;
    use Math::CatmullRom;
    
    use Math::Trig;         # Standard module
    #use Data::Dumper;
}

# ======================================
# --- Debut de la classe airfoil2pdf ---
# ======================================

sub new{
    my($class, %args) = @_;
    my $this = bless({}, $class);

    $this->{version} = '0.33';
    $this->{corde_emplanture_mm} = 100;
    $this->{corde_saumon_mm} = 0;
    $this->{nb_nervures} = 1;
    $this->{talon_nervure} = 1;
    $this->{epaisseur_coffrage_en_mm} = 0;
    $this->{hachures_coffrage}=1;
    $this->{corde_max} = 0;
    $this->{coins_decoupe} = 1;
    $this->{smooth} = ''; # Reechantillonage des coordonnees du fichier dat par courbe de Bezier ou courbe Splice ( Cattmull-Rom )
                          # '' ou 'bezier' ou 'splice' ou 'catmullrom'

    $this->{dpi} = 150;
    $this->{imprimante} = 'A4'; # A4 ou A3
    $this->{orientation} = 'paysage'; # portrait ou paysage

    # --- Profil ---
    $this->{calage_emplanture} = 0;
    $this->{calage_saumon} = 0;

    # --- Divers ---
    $this->{datetime}=_datetime();
    $this->{date_generation}=_date_generation($this);

    # --- DAT ---
    $this->{dat_emplanture} = '';
    $this->{dat_saumon} = '';
    $this->{dat_dossier} = 'airfoils/dat/';
    #$this->{dat_coordonnees_x} = '';
    #$this->{dat_coordonnees_y} = '';
    $this->{dat_calage} = 0; # Stocke le calage temporaire de chaque nervure.

    # --- PDF ---
    $this->{pdf_dossier_de_sauvegarde}='output/';
    $this->{pdf_nom}='';
    $this->{pdf_resolution} = $this->{dpi};
    $this->{pdf_marges_mm} = 20;
    $this->{pdf_marges} = _mm2pixels($this->{pdf_marges_mm}, $this->{pdf_resolution});
    $this->{pdf_largeur} = 0; $this->{pdf_hauteur}=0; _pdf_get_dimensions($this);
    $this->{nb_pages_x} = 0;
    $this->{nb_pages_y} = 0;
        
    return $this;
}

# ==========================
# --- Methodes publiques ---
# ==========================

sub setWingRoot{
    my ($this, %params) = @_;

    while( my ($key,$value) = each(%params) )
    {
        $this->_set_wing_root_dat($value)   if $key eq 'dat';
        $this->_set_wing_root_chord($value) if $key eq 'chord';
        $this->_set_wing_root_angle($value) if $key eq 'angle';
    }

}

sub setWingTip{
    my ($this, %params) = @_;

    while( my ($key,$value) = each(%params) )
    {
        $this->_set_wing_tip_dat($value)    if $key eq 'dat';
        $this->_set_wing_tip_chord($value)  if $key eq 'chord';
        $this->_set_wing_tip_angle($value)  if $key eq 'angle';
    }

}

sub setNbNervures{
	my ($this, $nb)=@_;
	if(!(defined($nb))){ $nb = 1; }
	$this->{nb_nervures} = abs($nb);
}
sub setEpaisseurCoffrage{
	my ($this, $mm)=@_;
	if(!(defined($mm))){ $mm=0; }
	$this->{epaisseur_coffrage_en_mm} = $mm;
}
sub setPaperOrientation{
	# $orientation = portrait / paysage (defaut)
	my ($this, $orientation)=@_;
	if(lc($orientation) eq 'portrait'){$this->{orientation} = 'portrait';}
	else{$this->{orientation} = 'paysage';}
}
sub setPaperSize{
	# $imprimante = A4 (defaut) / A3
	my ($this, $imprimante)=@_;
	if(uc($imprimante) eq 'A3'){$this->{imprimante} = 'A3';}
	else{$this->{imprimante} = 'A4';}
}

sub createPdf{
	my($this)=@_;
	
	# --- Typos ---
		$this->{xxlarge} = _mm2pixels(11, $this->{dpi});
		$this->{xlarge} = _mm2pixels(9, $this->{dpi});
		$this->{large} = _mm2pixels(6, $this->{dpi});
		$this->{medium} = _mm2pixels(4, $this->{dpi});
		$this->{small} = _mm2pixels(3, $this->{dpi});
		$this->{xsmall} = _mm2pixels(2, $this->{dpi});
		$this->{xxsmall} = _mm2pixels(1, $this->{dpi});
	
	# ---/ Chargement des données DAT emplanture et saumon \---
		my($_fichier_dat) = '';
		$_fichier_dat = $this->{dat_dossier}.$this->{dat_emplanture}.'.dat';
		if(!-e $_fichier_dat){print '### Erreur ### Impossible de lire le fichier "'.$_fichier_dat.'"'; exit;}
		$_fichier_dat = $this->{dat_dossier}.$this->{dat_saumon}.'.dat';
		if(!-e $_fichier_dat){print '### Erreur ### Impossible de lire le fichier "'.$_fichier_dat.'"'; exit;}
		_readparse_dat($this);
	# ---\ Chargement des données DAT emplanture et saumon /---
		
	$this->{pdf} = new PDF::Create(
				'filename' => $this->{pdf_dossier_de_sauvegarde}.$this->{pdf_nom},
				'Version'  => 1.2,
				'PageMode' => 'UseOutlines',
				'Author'   => 'thierry.bugeat.free.fr',
				'Title'    => 'AIRFOIL 2 PDF'
				);

	$this->{root} = $this->{pdf}->new_page('MediaBox'  => [ 0, 0, $this->{pdf_largeur}, $this->{pdf_hauteur} ]);
				
	# --- Typos ---
	$this->{font1} = $this->{pdf}->font('Subtype'=>'Type1','Encoding'=>'WinAnsiEncoding','BaseFont'=>'Helvetica');
	$this->{font2} = $this->{pdf}->font('Subtype'=>'Type1','Encoding'=>'WinAnsiEncoding','BaseFont'=>'Helvetica-Bold');
	
	# --- Corde la plus grande ---
	$this->{corde_max}=_corde_max($this); # La corde la + grande entre l'emplanture et le saumon.

	# --- Calcule et memorise les cordes de toutes les nervures ---
	_cordes_des_nervures_en_mm($this);
	
	# --- Nombre de pages necessaires dans le PDF ---
	_pdf_set_nb_pages_x($this);
	_pdf_set_nb_pages_y($this);
		
	# --- Page de garde ---
	_pdf_creer_la_page_de_garde($this);

	# --- Page d'assemblage ---
	_pdf_creer_la_page_d_assemblage($this);
	
	# --- Page(s) contenant les/la nervure(s) ---
	_pdf_creer_les_pages_contenant_les_nervures($this);
	
	# --- Fermeture du PDF ---
	$this->{pdf}->close;

}
sub setDirOutput{
    my ($this, $dir)=@_;
    $this->{pdf_dossier_de_sauvegarde}=$dir;
}
sub setDirDat{
    my ($this, $dir)=@_;
    $this->{dat_dossier}=$dir;
}
sub setTalonNervure{
	my ($this, $booleen)=@_;
	$this->{talon_nervure}=$booleen;
}
sub setCoinsDecoupe{
	my ($this, $booleen)=@_;
	$this->{coins_decoupe}=$booleen;
}

sub setDpi{
	my ($this, $dpi)=@_;
	if(!(defined($dpi))){ $dpi = 150; }
	$this->{dpi} = abs($dpi);
	$this->{pdf_resolution} = $this->{dpi};
	$this->{pdf_marges} = _mm2pixels($this->{pdf_marges_mm}, $this->{pdf_resolution});
	$this->{pdf_largeur} = 0; $this->{pdf_hauteur}=0; _pdf_get_dimensions($this);
}

sub setSmooth{
	# $type = bezier / splice ou catmullrom ( 'splice' et 'catmullrom' sont equivalents )
	my ($this, $type)=@_;
	$this->{smooth}=$type;
}

sub setPdfName{
    my ($this, $pdfNom)=@_;
    $this->{pdf_nom}=$pdfNom;
}

# ========================
# --- Methodes privees ---
# ========================

# Wing root / Emplanture

sub _set_wing_root_dat{
    my ($this, $dat)=@_;
    if(!(defined($dat))){ return; }
    if( $dat eq '' ){ return ; }

    $dat=~s/\.dat//g;

    $this->{dat_emplanture} = $dat;
    if($this->{dat_saumon} eq ''){ $this->{dat_saumon} = $dat;}
}

sub _set_wing_root_chord{
    my ($this, $mm)=@_;
    if(!(defined($mm))){ $mm = 0; }
    $this->{corde_emplanture_mm} = abs($mm);
}

sub _set_wing_root_angle{
    my ($this, $degres)=@_;

    # Definition du calage de l'emplanture entre -2 et +2 degres.
    # En calant l'emplanture on cale automatiquement le saumon au meme angle si celui-ci n'a pas
    # ete defini precedemment.

    if(!(defined($degres))){ $degres = 0; }
    if($degres > 2){ $degres = 2; }
    if($degres < -2){ $degres = -2; }

    $this->{calage_emplanture} = $degres;
    if($this->{calage_saumon} == 0){ $this->{calage_saumon} = $degres;}
}

# Wing tip / Saumon

sub _set_wing_tip_dat{
    my ($this, $dat)=@_;
    if(!(defined($dat))){ return; }
    if( $dat eq '' ){ return ; }

    $dat=~s/\.dat//g;

    $this->{dat_saumon} = $dat;
    if($this->{dat_emplanture} eq ''){ $this->{dat_emplanture} = $dat;}
}

sub _set_wing_tip_chord{
    my ($this, $mm)=@_;
    if(!(defined($mm))){ $mm=0; }
    $this->{corde_saumon_mm} = $mm;
}

sub _set_wing_tip_angle{
    my ($this, $degres)=@_;

    # Definition du calage du saumon entre -2 et +2 degres.

    if(!(defined($degres))){ $degres = 0; }
    if($degres > 2){ $degres = 2; }
    if($degres < -2){ $degres = -2; }

    $this->{calage_saumon} = $degres;
}

# --- Methodes PDF ---

sub _pdf_creer_la_page_de_garde{
	my($this)=@_;
	
	my($_offset_x) = 0;
	my($_dats) = "$this->{dat_emplanture}";
	
	if($this->{dat_saumon} ne $this->{dat_emplanture}){
		$_offset_x = _mm2pixels(30, $this->{dpi});
		$_dats = "$this->{dat_emplanture} / $this->{dat_saumon}";
	}
	
	my($_page0) = $this->{root}->new_page; # Ajouter une page au document

	$_page0->stringc($this->{font1}, $this->{xxlarge}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)+_mm2pixels(30,$this->{dpi})), 'AIRFOIL 2 PDF');
	$_page0->stringc($this->{font1}, $this->{large}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)+_mm2pixels(22,$this->{dpi})), 'Generate airfoil for aeromodelism '.$this->{version});
	$_page0->stringc($this->{font1}, $this->{xlarge}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)+_mm2pixels(9,$this->{dpi})), "$_dats");
	$_page0->stringc($this->{font1}, $this->{small}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)-_mm2pixels(15,$this->{dpi})), "Ce document a ete genere le : $this->{datetime}");
	$_page0->stringc($this->{font1}, $this->{small}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)-_mm2pixels(19,$this->{dpi})), "Nombre de nervures generees : $this->{nb_nervures}");
	$_page0->stringc($this->{font1}, $this->{small}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)-_mm2pixels(23,$this->{dpi})), "Corde a l'emplanture : $this->{corde_emplanture_mm} mm");
	$_page0->stringc($this->{font1}, $this->{small}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)-_mm2pixels(27,$this->{dpi})), "Corde au saumon : $this->{corde_saumon_mm} mm");
	$_page0->stringc($this->{font1}, $this->{small}, ($this->{pdf_largeur}/2) , (($this->{pdf_hauteur}/2)-_mm2pixels(35,$this->{dpi})), "Document a imprimer sur une imprimante : $this->{imprimante}");
	$_page0->stringc($this->{font1}, $this->{medium}, ($this->{pdf_largeur}/2) , ($this->{pdf_marges}+(30/2)), "Website : thierry.bugeat.free.fr - Email : airfoil2pdf\@bugeat.com");
	$_page0->line( $this->{pdf_marges} , ($this->{pdf_hauteur}-$this->{pdf_marges}) , ($this->{pdf_largeur}-$this->{pdf_marges}) , ($this->{pdf_hauteur}-$this->{pdf_marges}) ); # Trait horizontal en haut de page
	$_page0->line( $this->{pdf_marges} , $this->{pdf_marges} , ($this->{pdf_largeur}-$this->{pdf_marges}) , $this->{pdf_marges} ); # Trait horizontal en bas de page

	# --- Dessin nervure(s) ---
	
	# ---/ Dessin de la nervure d'emplanture \---
		my($x ,$y, $x0, $y0, $x1, $y1)=0;
		my($profil_corde_pixels)=_mm2pixels(50, $this->{dpi});
		for(my($i)=1; $i<$#{$this->{dat_coordonnees_x_emplanture}}; $i++){
			$x = $this->{dat_coordonnees_x_emplanture}[$i];
			$y = $this->{dat_coordonnees_y_emplanture}[$i];
			$x1 = ((($this->{pdf_largeur})/2) - ($profil_corde_pixels/2)) + ($x*$profil_corde_pixels) - $_offset_x;
			$y1 = (($this->{pdf_hauteur})/2) + ($y*$profil_corde_pixels*(2/2));
			$_page0->line($x0 , $y0 ,$x1 , $y1) if ($i>1);
			$x0 = $x1; $y0 = $y1; # Memoriser l'emplacement du point qui vient d'etre calculé.
		}
	# ---\ Dessin de la nervure d'emplanture /---

	# ---/ Dessin de la nervure du saumon si defferente de celle de l'emplanture \---
		if($this->{dat_saumon} ne $this->{dat_emplanture}){
			($x ,$y, $x0, $y0, $x1, $y1)=0;
			$profil_corde_pixels=_mm2pixels(50, $this->{dpi});
			for(my($i)=1; $i<$#{$this->{dat_coordonnees_x_saumon}}; $i++){
				$x = $this->{dat_coordonnees_x_saumon}[$i];
				$y = $this->{dat_coordonnees_y_saumon}[$i];
				$x1 = ((($this->{pdf_largeur})/2) - ($profil_corde_pixels/2)) + ($x*$profil_corde_pixels) + $_offset_x;
				$y1 = (($this->{pdf_hauteur})/2) + ($y*$profil_corde_pixels*(2/2));
				$_page0->line($x0 , $y0 ,$x1 , $y1) if ($i>1);
				$x0 = $x1; $y0 = $y1; # Memoriser l'emplacement du point qui vient d'etre calculé.
			}
		}
	# ---\ Dessin de la nervure du saumon /---
	
}
sub _pdf_creer_la_page_d_assemblage{
	my($this)=@_;
	
	return if($this->{pdf_nb_pages_x}==1 && $this->{pdf_nb_pages_y}==1);
	
	# --- 2ième page du document : Plan d'assemblage des pages. ---
	my($_page2) = $this->{root}->new_page; # Ajouter une page au document
	_pdf_entete_page($this, \$_page2); # Entete de page
	$_page2->stringc($this->{font1}, 20, (($this->{pdf_largeur})/2) , ($this->{pdf_hauteur} - $this->{pdf_marges} - 225) , 'Assemblez vos pages imprimees comme ci-dessous :');
	
	my($noPage)=3;
	
	for(my($j)=0; $j<$this->{pdf_nb_pages_y}; $j++){
		for(my($i)=0; $i<$this->{pdf_nb_pages_x}; $i++){
				#rectangle x y w h
				my($w) = int(($this->{pdf_largeur})/10); # Dimensions de la 'vignette' de la page
				my($h) = int(($this->{pdf_hauteur})/10);
				my($offset_x) = (($this->{pdf_largeur})/2) - (($w*$this->{pdf_nb_pages_x})/2);
				my($offset_y) = ($this->{pdf_hauteur} - $this->{pdf_marges}) - ($h*$this->{pdf_nb_pages_y})-250;
				my($x) = $offset_x + ($i*$w);
				my($y) = $offset_y + ($j*$h);
				#$page2->rectangle( $x , $y , $w , $h); # BUG : Ne s'affiche pas si la ligne ci-dessous n'existe pas !
				$_page2->line($x , $y , $x+$w , $y);
				$_page2->line($x+$w , $y , $x+$w , $y+$h);
				$_page2->line($x+$w , $y+$h , $x , $y+$h);
				$_page2->line($x , $y+$h , $x , $y);
				$_page2->stringc($this->{font1}, 20, $x+($w/2) , $y+($h/2) , " Page $noPage");
			$noPage++;
		}
	}
	
}
sub _pdf_creer_les_pages_contenant_les_nervures{
	my($this)=@_;
	my($MinY, $MaxY) = 0;
	
	# --- Y ---
	for(my($ligne)=1; $ligne<=$this->{pdf_nb_pages_y}; $ligne++){
		
		# --- X ---
		for(my($i)=1; $i<=$this->{pdf_nb_pages_x}; $i++){
			my($y_axe) = 0;
			my($y_offset) = ($ligne-1) * ($this->{pdf_hauteur}-(2*$this->{pdf_marges}));
			$y_axe -= $y_offset;
			
			my($np) = $this->{root}->new_page; # Ajouter une page au document
			_pdf_entete_page($this, \$np);
			$np->stringc($this->{font1}, 6, ($this->{pdf_marges}+3) , ($this->{pdf_marges}-6) , "[$i]");
			$np->stringc($this->{font1}, 6, ($this->{pdf_marges}+10) , ($this->{pdf_marges}-6) , "[$ligne]");
						
			# Calculer les décalages d'une page à l'autre.
			
			my($x_offset) = ($i-1) * ($this->{pdf_largeur}-(2*$this->{pdf_marges})); # Sur chaque nouvelle page on décale les nervures dessinnées.
			
			# Pour chaque nervure de la page
			
			for(my($n)=0; $n < $this->{nb_nervures}; $n++){
								
				# Creation des coordonnees dat temporaires.
				# $this->{dat_coordonnees_x} et $this->{dat_coordonnees_y}
				# Ces coordonnees sont 1 mix entre le profil choisis pour l'emplanture
				# et le profil choisis pour le saumon.
				# Le numero de la nervure en cours est egalement utilisé.
				_effet_mixage_dats($this, $n);
				###
				_effet_rotation_dat($this, $n);
				###
			
				$MinY = _min_y($this);
				$MaxY = _max_y($this);
				
				# a) Calculer la hauteur de la nervure en mm et en pixels.
				my($MinY_mm) = ((-1*$MinY) * $this->{cordes_des_nervures_en_mm}[$n]);
				my($MaxY_mm) = ($MaxY * $this->{cordes_des_nervures_en_mm}[$n]);
				my($MinY_pixels) = _mm2pixels($MinY_mm, $this->{pdf_resolution}); 
				my($MaxY_pixels) = _mm2pixels($MaxY_mm, $this->{pdf_resolution});
				my($HauteurNervure_mm) = $MinY_mm + $MaxY_mm;
				my($HauteurNervure_pixels) = $MinY_pixels + $MaxY_pixels;
				
				# c) Calculer à quelle hauteur dans la page doit se situer l'axe de la nervure (1/2)
				$y_axe += $this->{pdf_marges} if ($n==0); # Ajouter la marge si c'est la première nervure.

				$y_axe += $MinY_pixels;
				
				if($this->{epaisseur_coffrage_en_mm}>0){
					my($_epaisseur_coffrage_en_points) = _mm2pixels($this->{epaisseur_coffrage_en_mm}, $this->{dpi});
					if($n>0){$y_axe += $_epaisseur_coffrage_en_points;}
					$y_axe += $_epaisseur_coffrage_en_points;
				}
				
				# d) Dessiner la nervure. ( $n = numéro de la nervure. )
				_pdf_dessine_nervure($this, $n, $HauteurNervure_mm, \$np, $x_offset, $y_axe, $MinY, $MaxY);
				
				# e) Calculer à quelle hauteur démarre la prochaine nervure (2/2)
				$y_axe += $MaxY_pixels;
			}
		} # for $n
	} # for ligne
}
sub _pdf_get_dimensions{
	my($this)=@_;
	# Retourne en pixels la largeur et la hauteur du pdf a creer.
	# A4 72 dpi portrait -> 595 x 842 pixels
	# A3 72 dpi portrait -> 842 x 1190 pixels
		
	if($this->{orientation} eq 'portrait'){
		if($this->{imprimante} eq 'A3'){
			$this->{pdf_largeur}=int(((842*$this->{dpi})/72));
			$this->{pdf_hauteur}=int(((1190*$this->{dpi})/72));
		} else {
			$this->{pdf_largeur}=int(((595*$this->{dpi})/72));
			$this->{pdf_hauteur}=int(((842*$this->{dpi})/72));
		}
	} else {
		if($this->{imprimante} eq 'A3'){
			$this->{pdf_largeur}=int(((1190*$this->{dpi})/72));
			$this->{pdf_hauteur}=int(((842*$this->{dpi})/72));
		} else {
			$this->{pdf_largeur}=int(((842*$this->{dpi})/72));
			$this->{pdf_hauteur}=int(((595*$this->{dpi})/72));
		}
	}

}
sub _pdf_set_nb_pages_x{
	# Fonction : Retourne le nombre de pages nécessaires pour dessiner la + grande nervure sur l'axe X. 
	my($this) = @_;
	
	my($largeur_page_en_mm) = _pixels2mm($this->{pdf_largeur} - (2 * $this->{pdf_marges}), $this->{pdf_resolution});
	$this->{pdf_nb_pages_x} = int(($this->{corde_max}) / $largeur_page_en_mm) + 1;

}
sub _pdf_set_nb_pages_y{
	# Fonction : Retourne le nombre de pages nécessaires pour dessiner toutes les nervures sur l'axe Y. 
	my($this) = @_;
	my(@hauteurs_nervures);
	my($_hauteur_totale_de_toutes_les_nervures_en_mm) = 0;

	# ---/ Pour chaque nervure \---
	
		for(my($n)=0; $n < $this->{nb_nervures}; $n++){
	
			_effet_mixage_dats($this, $n); # Mixe les fichiers dat.
			
			my($MinY) = _min_y($this); # Valeur mini du profil suivant l'axe Y.
			my($MaxY) = _max_y($this); # Valeur maxi du profil suivant l'axe Y.
			
			# --- Hauteur de la nervure actuelle ---
			my($MinY_mm) = ((-1*$MinY) * $this->{cordes_des_nervures_en_mm}[$n]);
			my($MaxY_mm) = ($MaxY * $this->{cordes_des_nervures_en_mm}[$n]);
			my($HauteurNervure_mm) = $MinY_mm + $MaxY_mm;
			
			if($this->{epaisseur_coffrage_en_mm} > 0){
				$HauteurNervure_mm += ( 2 * $this->{epaisseur_coffrage_en_mm} );
			}
		
			push(@hauteurs_nervures, $HauteurNervure_mm);
			
			#print "Nervure $n : Hauteur = $HauteurNervure_mm mm\n";
			$_hauteur_totale_de_toutes_les_nervures_en_mm += $HauteurNervure_mm;
			
		}
		#print "Hauteur nervures = $_hauteur_totale_de_toutes_les_nervures_en_mm\n";
		
	# ---\ Pour chaque nervure /---
	
	# ---/ Stockage des hauteurs des nervures \---
	$this->{hauteurs_nervures_en_mm} = ( 0 => [@hauteurs_nervures] ); # Insertion d'une liste @ dans un tableau de hachage %{}
	# ---\ Stockage des hauteurs des nervures /---
		
	# --- Calcul du nombre de page en Y ---
	my($hauteur_page_en_mm) = _pixels2mm($this->{pdf_hauteur} - (2 * $this->{pdf_marges}), $this->{pdf_resolution});
	$this->{pdf_nb_pages_y} = int($_hauteur_totale_de_toutes_les_nervures_en_mm / $hauteur_page_en_mm) + 1;
	
}
sub _pdf_entete_page{
	# Ajoute une page au document et retourne une reference.
	my($this, $ref)=@_;
	
	$$ref->stringc($this->{font1}, 20, (($this->{pdf_largeur})/2) , ($this->{pdf_hauteur} - $this->{pdf_marges} - 40) , 'AIRFOIL 2 PDF');
	$$ref->stringc($this->{font1}, 20, (($this->{pdf_largeur})/2) , ($this->{pdf_hauteur} - $this->{pdf_marges} - 60) , 'Module de generation de nervures pour l\'aeromodelisme');
	$$ref->stringc($this->{font1}, 20, (($this->{pdf_largeur})/2) , ($this->{pdf_hauteur} - $this->{pdf_marges} - 80) , "Profil(s) : $this->{dat_emplanture}, $this->{dat_saumon}");
	$$ref->stringc($this->{font1}, 16, (($this->{pdf_largeur})/2) , ($this->{pdf_hauteur} - $this->{pdf_marges} - 100) , 'Website : thierry.bugeat.free.fr - Email : airfoil2pdf@bugeat.com');
	$$ref->line( $this->{pdf_marges} , $this->{pdf_marges} , ($this->{pdf_largeur} - $this->{pdf_marges}) , $this->{pdf_marges} ); # Trait horizontal en bas de page
	$$ref->line( $this->{pdf_marges} , ($this->{pdf_hauteur} - $this->{pdf_marges}) , ($this->{pdf_largeur} - $this->{pdf_marges}) , ($this->{pdf_hauteur} - $this->{pdf_marges}) ); # Trait horizontal en haut de page
	$$ref->line( $this->{pdf_marges} , $this->{pdf_marges} , $this->{pdf_marges} , ($this->{pdf_hauteur} - $this->{pdf_marges}) ); # Trait vertical gauche
	$$ref->line( ($this->{pdf_largeur} - $this->{pdf_marges}) , $this->{pdf_marges} , ($this->{pdf_largeur} - $this->{pdf_marges}) , ($this->{pdf_hauteur} - $this->{pdf_marges}) ); # Trait vertical droit
	return;
}
sub _pdf_dessine_nervure{
	my($this, $no_nervure, $HauteurNervure_mm, $ref_page, $x_offset, $y_axe, $MinY, $MaxY)=@_;
	
	# $MinY : Valeur originelle mini du fichier dat sur l'axe Y.
	# $MaxY : Valeur originelle maxi du fichier dat sur l'axe Y.

	my($ppc) = _dpi2ppc($this->{dpi}); # Convertion des dpi en pixels par cm ($ppc)
	my($profil_corde_mm) = $this->{cordes_des_nervures_en_mm}[$no_nervure]; # Corde en mm
	my($profil_corde_pixels) = ($ppc*$profil_corde_mm)/10; # Corde en pixels
	my($ecart_nervures) = ((75*$this->{dpi})/72); # 75 en 72 dpi
	my($x_coffrage_precedent, $y_coffrage_precedent) = 0;

	my($longueur_coin_en_mm) = 5; # 5 mm
	my($longueur_coin_en_pixels) = _mm2pixels($longueur_coin_en_mm, $this->{dpi});
	
	my($epaisseur_coffrage_en_points) = 0;
	if($this->{epaisseur_coffrage_en_mm} > 0){
		$epaisseur_coffrage_en_points = _mm2pixels($this->{epaisseur_coffrage_en_mm}, $this->{dpi});
	}
	
	my($MinY_mm) = -1 * $MinY * $this->{cordes_des_nervures_en_mm}[$no_nervure]; 
	my($MinY_pixels) = _mm2pixels($MinY_mm, $this->{pdf_resolution});
	my($MaxY_mm) = $MaxY * $this->{cordes_des_nervures_en_mm}[$no_nervure]; 
	my($MaxY_pixels) = _mm2pixels($MaxY_mm, $this->{pdf_resolution});
	
	my($HauteurTotaleNervure_en_mm) = $this->{hauteurs_nervures_en_mm}[$no_nervure];
	my($HauteurTotaleNervure_en_pixels) = _mm2pixels($HauteurTotaleNervure_en_mm, $this->{pdf_resolution});
	
	# ===============================
	# --- Creer l'image du profil ---
	# ===============================

	# --- Axe du profil ---
	$$ref_page->line($this->{pdf_marges} , $y_axe , $this->{pdf_largeur} - $this->{pdf_marges} , $y_axe);
	my($HauteurNervure_mm_arrondi) = sprintf("%.1f", $HauteurNervure_mm); # Arrondir à 1 chiffre après la virgule
	
	# --- Nom du/des profil(s) / corde / calage ---
	my($taille_typo) = ($profil_corde_mm/10) * (($this->{dpi})/150);
	my($interligne) = $taille_typo;
	my($x_axe) = $this->{pdf_marges} + _mm2pixels((($profil_corde_mm*33)/100), $this->{dpi}); # On place le texte à 33 % de la corde.
	$$ref_page->stringc($this->{font1}, $taille_typo, $x_axe , $y_axe + ($interligne/2) + $MaxY_pixels - ($HauteurTotaleNervure_en_pixels / 2) , "Nervure $no_nervure / www.boonga.com");
	$$ref_page->stringc($this->{font1}, $taille_typo, $x_axe , $y_axe - ($interligne/2) + $MaxY_pixels - ($HauteurTotaleNervure_en_pixels / 2) , "$this->{dat_emplanture} - $this->{dat_saumon} / Corde = $profil_corde_mm mm / Hauteur = $HauteurNervure_mm_arrondi mm / Calage = $this->{dat_calage} degre(s)");
	
	# ---/ Recuperation des coordonnees du profil dans les tableaux @_dcx @_dcy \---
	
		# A ce niveau on reechantillonne ou non les coordonnees
		# en fonction de la variable $this->{setSmooth}
	
		# !!! A FAIRE !!!
		# Le reechantillonnage par courbe de Bezier modifie les
		# dimensions des nervures. Il faut ajouter un filtre de
		# de type 'resize' pour que les coordonnees x aillent bien
		# de 0 à 1, et que la hauteur soit egalement respectee.
		# Attention : Il n'est pas dit que le redimensionnement soit
		# le meme sur les deux axes x et y.
		# !!! A FAIRE !!!

		my(@_dcx);
		my(@_dcy);
		my(@_coordonnees);
	
		for(my($i)=0; $i <= $#{$this->{dat_coordonnees_x}}; $i++){
			if($this->{smooth} eq ''){
				push @_dcx,$this->{dat_coordonnees_x}[$i];
				push @_dcy,$this->{dat_coordonnees_y}[$i];
			} else {
				push @_coordonnees,$this->{dat_coordonnees_x}[$i];
				push @_coordonnees,$this->{dat_coordonnees_y}[$i];
			}
		}
		
		if( ($this->{smooth} eq 'splice') || ($this->{smooth} eq 'catmullrom') ){
			my($_nbReechantillonnages) = 100;
			my($catmullrom) = Math::CatmullRom->new(@_coordonnees);
			for(my($i)=0; $i <= $_nbReechantillonnages; $i++){
				my($_x, $_y) = $catmullrom->point(($i/$_nbReechantillonnages));
				push @_dcx,$_x;
				push @_dcy,$_y;
			}
		} # splice / catmullrom
		
		elsif($this->{smooth} eq 'bezier'){
			my($_nbReechantillonnages) = 100;
			my($bezier) = Math::Bezier->new(@_coordonnees);
			for(my($i)=0; $i <= $_nbReechantillonnages; $i++){
				my($_x, $_y) = $bezier->point(($i/$_nbReechantillonnages));
				push @_dcx,$_x;
				push @_dcy,$_y;
			}
			# ---/ Filtre "resize x" et "resize y" \---
				# La courbe de Bezier deforme/rapetisse le profil.
				# On re-etire le profil pour que la valeur @_dcx mini 
				# revienne a 0 et la valeur maxi a 1.
				# Pour l'axe y on se base sur les valeurs maxi 
				# et mini du fichier dat.
				my($_min_x) = _min(@_dcx);
				my($_max_x) = 1 - $_min_x;
				my($_min_y) = _min(@_dcy);
				my($_max_y) = _max(@_dcy);
				for(my($i)=0; $i < $#_dcx; $i++){
					$_dcx[$i] = ( $_dcx[$i] - $_min_x ) / $_max_x;
					$_dcy[$i] = $_dcy[$i] * ( $MaxY / $_max_y );
				}
			# ---\ Filtre "resize x" et "resize y" /---
		} # bezier
		
	# Variables en sortie : @_dcx @_dcy	
	# ---\ Recuperation des coordonnees du profil dans les tableaux @_dcx @_dcy /---
	
	my($_nbPoints) = $#_dcx;
		
	for(my($i)=0; $i <= $_nbPoints; $i++){
		
		# --- creer le contour (Version PDF)
		my($x0) = ($_dcx[$i-1] * $profil_corde_pixels) + $this->{pdf_marges} - $x_offset;
		my($y0) = $y_axe + ($_dcy[$i-1] * $profil_corde_pixels);
		my($x1) = ($_dcx[$i] * $profil_corde_pixels) + $this->{pdf_marges} - $x_offset;
		my($y1) = $y_axe + ($_dcy[$i] * $profil_corde_pixels);
		#print "===$_dcx[$i+1]===\n";
		
		# Premier point du profil
		if($i == 0){$x0 = $x1; $y0 = $y1;} 
		
		# Si nous ne sommes pas sur le dernier point du profil ... sinon ...
		my($x2, $y2)=0;
		if($i != $_nbPoints){
			$x2 = ($_dcx[$i+1] * $profil_corde_pixels) + $this->{pdf_marges} - $x_offset;
			$y2 = $y_axe + ($_dcy[$i+1] * $profil_corde_pixels);
		} else {
			$x2 = $x1; $y2 = $y1;
		}
				
		# -------------------------------------------------
		# On trace le segment que si l'on est dans la page.
		# Extrados :
		if($x0 >= $x1){if( ($x0>0) && ($x1<$this->{pdf_largeur}) ){$$ref_page->line($x0 , $y0 ,$x1 , $y1);}}
		# Intrados :
		else{if( ($x1>0) && ($x0<$this->{pdf_largeur}) ){$$ref_page->line($x0 , $y0 ,$x1 , $y1);}}
		#$$ref_page->line($x0 , $y0 ,$x1 , $y1);
		#print "$x0 , $y0 ,$x1 , $y1\n";
		# -------------------------------------------------
		
		# ---/ COFFRAGE \---
		if($this->{epaisseur_coffrage_en_mm} != 0){
			my($x_coffrage, $y_coffrage) = _get_coordonnees_point_de_coffrage($x0, $y0, $x1, $y1, $x2, $y2, $this->{epaisseur_coffrage_en_mm}, $this->{dpi});
			#print "$x1,$y1,$x_coffrage,$y_coffrage<hr>";
			if($x1 && $y1 && $x_coffrage && $y_coffrage){
				# Hachures du coffrage :
				if( (!$this->{hachures_coffrage}) && (($i==0)||($i==$_nbPoints)) ){$$ref_page->line($x1 , $y1 ,$x_coffrage , $y_coffrage);}
				if($this->{hachures_coffrage}){$$ref_page->line($x1 , $y1 ,$x_coffrage , $y_coffrage);}
				# Dessin du coffrage :
				if(($x_coffrage_precedent) && ($y_coffrage_precedent)){
					$$ref_page->line($x_coffrage_precedent , $y_coffrage_precedent ,$x_coffrage , $y_coffrage);
				}
				$x_coffrage_precedent = $x_coffrage; # Memoriser l'emplacement du point qui viens d'etre calculé.
				$y_coffrage_precedent = $y_coffrage; # Memoriser l'emplacement du point qui viens d'etre calculé.
			}
		}
		# ---\ COFFRAGE /---

		# ---/ Talon de la nervure + coins de découpe \---
		
		if($i == 0){
			
			my($_x0) = $x0;
			my($_y0) = $y_axe;
			
			# ---/ TALON DE NERVURE \----------------------------------------------------
			if($this->{talon_nervure}){
				$$ref_page->line($_x0 , ($_y0-($MinY_pixels/2)) ,$_x0 , ($_y0-$MinY_pixels));
				$$ref_page->line(($_x0-$MinY_pixels) , ($_y0-$MinY_pixels) ,($_x0+$MinY_pixels) , ($_y0-$MinY_pixels)); # T inversé
				$$ref_page->line(($_x0-$MinY_pixels) , ($_y0-$MinY_pixels) ,($_x0-($MinY_pixels*2)) , $_y0); # \
				$$ref_page->line(($_x0+$MinY_pixels) , ($_y0-$MinY_pixels) ,$_x0 , $_y0); # \
				# On ajoute sous le talon une epaisseur egale au coffrage.
				if($this->{epaisseur_coffrage_en_mm} > 0){
					$$ref_page->line(($_x0-$MinY_pixels) , ($_y0-$MinY_pixels) , ($_x0-$MinY_pixels), (($_y0-$MinY_pixels)-$epaisseur_coffrage_en_points));
					$$ref_page->line(($_x0+$MinY_pixels) , ($_y0-$MinY_pixels) , ($_x0+$MinY_pixels), (($_y0-$MinY_pixels)-$epaisseur_coffrage_en_points));
					$$ref_page->line(($_x0-$MinY_pixels) , (($_y0-$MinY_pixels)-$epaisseur_coffrage_en_points),($_x0+$MinY_pixels), (($_y0-$MinY_pixels)-$epaisseur_coffrage_en_points) );
				}
			}
			# ---\ TALON DE NERVURE /----------------------------------------------------
			
			# ---/ COINS DE DECOUPE \----------------------------------------------------
			if($this->{coins_decoupe}){
				
				# Coin HD
				$$ref_page->line($_x0 , ($_y0+$MaxY_pixels-$longueur_coin_en_pixels) ,$_x0 , ($_y0+$MaxY_pixels));
				$$ref_page->line(($_x0-$longueur_coin_en_pixels) , ($_y0+$MaxY_pixels) ,$_x0 , ($_y0+$MaxY_pixels));
				if($this->{epaisseur_coffrage_en_mm} > 0){
					$$ref_page->line($_x0 , ($_y0+$MaxY_pixels-$longueur_coin_en_pixels) ,$_x0 , ($_y0+$MaxY_pixels+$epaisseur_coffrage_en_points));
					$$ref_page->line(($_x0-$longueur_coin_en_pixels) , ($_y0+$MaxY_pixels+$epaisseur_coffrage_en_points) ,$_x0 , ($_y0+$MaxY_pixels+$epaisseur_coffrage_en_points)); # Epaisseur de coffrage au dessus du L inverse
				}
				
				# Coin HG
				$$ref_page->line((0+$this->{pdf_marges}) , ($_y0+$MaxY_pixels) , ($this->{pdf_marges}+$longueur_coin_en_pixels) , ($_y0+$MaxY_pixels));
				if($this->{epaisseur_coffrage_en_mm} > 0){
					$$ref_page->line((0+$this->{pdf_marges}) , ($_y0+$MaxY_pixels+$epaisseur_coffrage_en_points) , ($this->{pdf_marges}+$longueur_coin_en_pixels) , ($_y0+$MaxY_pixels+$epaisseur_coffrage_en_points));
				}
				
				# Coin BG
				$$ref_page->line((0+$this->{pdf_marges}) , ($_y0-$MinY_pixels) , ($this->{pdf_marges}+$longueur_coin_en_pixels) , ($_y0-$MinY_pixels));
				if($this->{epaisseur_coffrage_en_mm} > 0){
					$$ref_page->line((0+$this->{pdf_marges}) , ($_y0-$MinY_pixels-$epaisseur_coffrage_en_points) , ($this->{pdf_marges}+$longueur_coin_en_pixels) , ($_y0-$MinY_pixels-$epaisseur_coffrage_en_points));
				}

			}
			
			# Coin BD uniquement si on n'a pas un talon de nervure
			if(!$this->{talon_nervure}){
				if($this->{coins_decoupe}){
					$$ref_page->line($_x0 , ($_y0-$MinY_pixels+$longueur_coin_en_pixels) ,$_x0 , ($_y0-$MinY_pixels));
					$$ref_page->line(($_x0-$longueur_coin_en_pixels) , ($_y0-$MinY_pixels) ,$_x0 , ($_y0-$MinY_pixels));
					if($this->{epaisseur_coffrage_en_mm} > 0){
						$$ref_page->line($_x0 , ($_y0-$MinY_pixels) ,$_x0 , ($_y0-$MinY_pixels-$epaisseur_coffrage_en_points));
						$$ref_page->line(($_x0-$longueur_coin_en_pixels) , ($_y0-$MinY_pixels-$epaisseur_coffrage_en_points) ,$_x0 , ($_y0-$MinY_pixels-$epaisseur_coffrage_en_points)); # Epaisseur de coffrage au dessus du L inverse
					}
				}
			}
			# ---\ COINS DE DECOUPE /----------------------------------------------------
			
		} # if $i == 0
		
		# ---\ Talon de la nervure + coins de découpe /---
		
	} # for
	
}
# --- Methodes .dat ---
sub _readparse_dat{	
	my($this)=@_;
	my(@dats)=($this->{dat_emplanture}, $this->{dat_saumon});	
	
	local $/;
	local *F;
	
	my($i)=0;
	
	foreach(@dats){
		
		my($_dat_fichier) = $this->{dat_dossier}.$_.'.dat';
		
		open(F, "< $_dat_fichier\0") || &_error("### Erreur chargement fichier : [$_dat_fichier] ###") ;
		my($DAT)=<F>;
		
		close(F);
			
		# ---/ Parse DAT \---
		
		my(@LIGNES)=split(/\n/,$DAT);
		
		my(@datx); # tableau utilise pour stocker les coordonnes X du profil.
		my(@daty); # tableau utilise pour stocker les coordonnes Y du profil.
	
		for(my($ligne)=1; $ligne<=$#LIGNES; $ligne++){
			$LIGNES[$ligne]=~s/^\s+//; $LIGNES[$ligne]=~s/\s+$//; # Enlever les blancs aux extremites.
			$LIGNES[$ligne]=~s/  / /g; # Remplacer les doubles espaces par des simples.
			my($x,$y) = split(/ /,$LIGNES[$ligne],2);
			$x=~s/^\s+//; $x=~s/\s+$//;
			$y=~s/^\s+//; $y=~s/\s+$//;
			# --- Memoriser les coordonnees extraites ---
			push(@datx,$x);
			push(@daty,$y);
		}
	
		# ---\ Parse DAT /---
		
		# Memorisation des cordonnees obtenues.
		if($i == 0){
			$this->{dat_coordonnees_x_emplanture} = ( 0 => [@datx] ); # Insertion d'une liste @ dans un tableau de hachage %{}
			$this->{dat_coordonnees_y_emplanture} = ( 0 => [@daty] ); # Insertion d'une liste @ dans un tableau de hachage %{}
		} else {
			$this->{dat_coordonnees_x_saumon} = ( 0 => [@datx] ); # Insertion d'une liste @ dans un tableau de hachage %{}
			$this->{dat_coordonnees_y_saumon} = ( 0 => [@daty] ); # Insertion d'une liste @ dans un tableau de hachage %{}
		}
		
		$i++;
		
	} # foreach @dats

	return;
}
sub _min_y{
	# Fonction : Retourne la valeur Mini sur l'axe Y du profil passé en paramètre.
	my($this)=@_;
	my($OUT)=1;
	
	for(my($i)=0; $i < $#{$this->{dat_coordonnees_y}}; $i++){
		if($this->{dat_coordonnees_y}[$i] < $OUT){
			$OUT = $this->{dat_coordonnees_y}[$i];
		}
	}

	return $OUT;
}
sub _max_y{
	# Fonction : Retourne la valeur Maxi sur l'axe Y du profil passé en paramètre.
	my($this)=@_;
	my($OUT)=-1;
	
	for(my($i)=0; $i < $#{$this->{dat_coordonnees_y}}; $i++){
		if($this->{dat_coordonnees_y}[$i] > $OUT){
			$OUT = $this->{dat_coordonnees_y}[$i];
		}
	}

	return $OUT;
}
# --- Methodes nervures ---
sub _corde_max{
	my($this)=@_;
	# Fonction : Retourne la corde la plus grande entre l'emplanture et le saumon.
	
	my($corde0) = $this->{corde_emplanture_mm};
	my($corde1) = $this->{corde_saumon_mm};
		
	if ($corde0>$corde1){$this->{corde_max} = $corde0;}
	else {$this->{corde_max} = $corde1;}

}
sub _cordes_des_nervures_en_mm{
	# Fonction : 
	# Calcule et memorise les cordes de toutes les nervures à partir 
	# de la corde de l'emplanture, de la corde du saumon et du nombre 
	# de nervures.
	
	my($this)=@_;
	my(@CORDES);

	if(($this->{corde_emplanture_mm} eq '') || ($this->{corde_emplanture_mm} < 0)){$this->{corde_emplanture_mm} = 0;}
	if(($this->{corde_saumon_mm} eq '') || ($this->{corde_saumon_mm} < 0)){$this->{corde_saumon_mm} = 0;}
	
	# --- Aucune corde de rentrée ---
	if(($this->{corde_emplanture_mm} == 0) && ($this->{corde_saumon_mm} == 0)){
		$this->{corde_emplanture_mm} = 100;
	}
	
	# --- Une seule corde et $nb_nervures==1 ---
	if(($this->{corde_emplanture_mm} > 0) && ($this->{corde_saumon_mm} == 0) && ($this->{nb_nervures}==1)){
		push @CORDES,$this->{corde_emplanture_mm};
		$this->{cordes_des_nervures_en_mm} = ( 0 => [@CORDES] ); # Insertion d'une liste @ dans un tableau de hachage %{}
		return;
	}
	if(($this->{corde_emplanture_mm} == 0) && ($this->{corde_saumon_mm} > 0) && ($this->{nb_nervures}==1)){
		push @CORDES,$this->{corde_saumon_mm}; 
		$this->{cordes_des_nervures_en_mm} = ( 0 => [@CORDES] ); # Insertion d'une liste @ dans un tableau de hachage %{}
		return;
	}
	
	# --- Une seule corde et $nb_nervures > 1 ---
	if(($this->{corde_emplanture_mm} > 0) && ($this->{corde_saumon_mm} == 0)){
		$this->{corde_saumon_mm} = $this->{corde_emplanture_mm};
	}
	if(($this->{corde_emplanture_mm} == 0) && ($this->{corde_saumon_mm} > 0)){
		$this->{corde_emplanture_mm} = $this->{corde_saumon_mm};
	}
	
	# --- 2 nervures et + ---
	if($this->{nb_nervures} < 2){$this->{nb_nervures} = 2;}
	
	# Nervure d'emplanture :
	push @CORDES,$this->{corde_emplanture_mm};
	
	# Nervures intermediaires :
	my($nb_intermediaires) = $this->{nb_nervures}-2;
	if($nb_intermediaires > 0){
		for(my($n)=1; $n<=$nb_intermediaires; $n++){
			my($step) = ($this->{corde_emplanture_mm} - $this->{corde_saumon_mm}) / ($nb_intermediaires+1); # Ecart en mm sur la corde d'une nervure à l'autre
			my($corde_intermediaire) = $this->{corde_emplanture_mm} - ($step*$n);
			# Arrondir au mm
			my($corde_intermediaire_arrondie) = sprintf("%.0f", $corde_intermediaire);
			push @CORDES,$corde_intermediaire_arrondie;
		}
	}
	
	# Nervure du saumon :
	push @CORDES,$this->{corde_saumon_mm};
	
	# Memorisation des cordes obtenues.
	$this->{cordes_des_nervures_en_mm} = ( 0 => [@CORDES] ); # Insertion d'une liste @ dans un tableau de hachage %{}
	
	return ;
}
# --- Methodes de conversions d'unités ---
sub _mm2pixels{
	# Fonction : Convertion d'une longueur donnée en mm en pixels.
	my($longueur_en_mm, $resolution_en_dpi)=@_;
	my($longueur_en_pixels)=0;

	$longueur_en_pixels=$resolution_en_dpi*($longueur_en_mm/25.4);
		
	return $longueur_en_pixels;
}
sub _pixels2mm{
	# Fonction : Convertir une longueur donnée en pixels en mm
	my($longueur_en_pixels,$resolution_en_dpi)=@_;
	my($longueur_en_mm)=0;
		
	$longueur_en_mm=(($longueur_en_pixels/$resolution_en_dpi)*25.4);
		
	return $longueur_en_mm;
}

sub _dpi2ppc{
	# Fonction : Convertir des dpi en pixels par cm
	my($dpi)=@_;
	my($ppc) = (10*$dpi)/25.4;
	
	return $ppc;
}
# --- Methodes diverses ---
sub _error{
	my($mesg)=pop(@_);
	print "$mesg\n";
	exit 1;
}
sub _datetime{
	# Fonction : Retourne la date et l'heure actuelle sous la forme AAAA-MM-JJ HH:MM:SS
	
	my($DateTime,$sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)='';
	
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
		
	if(length($sec)<2){$sec="0$sec";}
	if(length($min)<2){$min="0$min";}
	if(length($hour)<2){$hour="0$hour";}
	if(length($mday)<2){$mday="0$mday";}
	$mon++;
	if(length($mon)<2){$mon="0$mon";}
	$year+=1900;
	
	return "$year-$mon-$mday $hour:$min:$sec";
}
sub _date_generation{
	# Fonction : Retourne la date et l'heure actuelle sous la forme AAAAMMJJ-HHMMSS
	my($this)=@_;
	my($_datetime)=_datetime();
	
	$_datetime =~ s/[-:]//g;
	$_datetime =~ s/ /-/;
	
	$this->{date_generation} = $_datetime;
}

sub _max{
	# Fonction : Retourne la valeur maxi de la liste passee en parametre.
	my $max = shift; $_ > $max and $max = $_ for @_; $max
}
sub _min{
	# Fonction : Retourne la valeur mini de la liste passee en parametre.
	my $min = shift; $_ < $min and $min = $_ for @_; $min 
}
# --- Methodes de calcul ---
sub _get_distance_entre_2_points{
	# Fonction : Retourne la distance entre les 2 points passes en parametre.
	my($x1, $y1, $x2, $y2) = @_;
	my($d)=0;
	
	$d = sqrt( (($x2 - $x1)**2) + (($y2 - $y1)**2) );
	
	return $d;
}
sub _get_coordonnees_point_de_coffrage{
	# Fonction :
	# Calcule les coordonnees d'un point de coffrage par rapport a 3 points consecutifs du profil.
	# Les coordonnees du point de coffrage sont donnees pour le point du milieu (point 2)
	
	my($x1,$y1,$x2,$y2,$x3,$y3,$epaisseur_coffrage_en_mm,$dpi)=@_;
	my($x_coffrage,$y_coffrage,$angle_pts_1_3,$angle_pt_2,$epaisseur_coffrage_en_points,$dx,$dy)=0;
	
	# --- DEFINITION D'UN TRIANGLE PAR RAPPORT A 3 POINTS CONSECUTIFS DE NOTRE PROFIL ---
	
		# Point 1 : $x1,$y1 , angle $a , longueur cote opposé $_a
		# Point 2 : $x2,$y2 , angle $b , longueur cote opposé $_b
		# Point 3 : $x3,$y3 , angle $c , longueur cote opposé $_c
	
	# 1) Angle d'inclinaison du segment entre les points 1 et 3 :
	
		$angle_pts_1_3=_angle_entre_2_points($x1,$y1,$x3,$y3);
	
	# 2) Angle de la perpendiculaire au segment pt1 pt3, passant par le point 2 :
	
		if(($angle_pts_1_3==180) and ($x1>$x3)){$angle_pts_1_3=-180;} # Cas particulier
		# Extrados :
		if(($angle_pts_1_3<0) && ($x1>$x3)){$angle_pt_2=($angle_pts_1_3+450);}
		elsif(($angle_pts_1_3>0) && ($x1>$x3)){$angle_pt_2=($angle_pts_1_3+90);}
		# Intrados :
		elsif(($angle_pts_1_3<0) && ($x1<$x3)){$angle_pt_2=($angle_pts_1_3+90);}
		elsif(($angle_pts_1_3>0) && ($x1<$x3)){$angle_pt_2=($angle_pts_1_3+90);}
		else{$angle_pt_2=0;}
		# Cas particuliers :
		if(($angle_pts_1_3==90) and ($x2<$x1)){$angle_pt_2=180;}
		if(($angle_pts_1_3==90) and ($x2>$x1)){$angle_pt_2=0;}

	# 3) Calcul des coordonnes du point de coffrage par rapport au point 2.
		
		$epaisseur_coffrage_en_points=_mm2pixels($epaisseur_coffrage_en_mm,$dpi);
		
		# cos alpha = adjacent / hypothenuse
		# sin alpha = oppose / hypothenuse
		# tan alpha = oppose / adjacent
	
		my($divy)=sin(deg2rad($angle_pt_2)); return if $divy==0;
		$dy=($epaisseur_coffrage_en_points*$divy); # Delta Y
		if(($angle_pt_2==0) || ($angle_pt_2==180)){$dy=0;} # Delta Y
		$dx=cos(deg2rad($angle_pt_2))*($epaisseur_coffrage_en_points); # Delta X
		
		$x_coffrage=($x2+$dx);
		$y_coffrage=($y2-$dy);

	return $x_coffrage,$y_coffrage;
}
sub _angle_entre_2_points{
	# Fonction : Retourne l'angle en degres entre les 2 points passes en parametre.
	# Les coordonnees 0,0 se situent en haut a gauche de l'ecran.
	
	# 0° a 3h
	# 90° a 6h
	# 180°  ou -180° ->a 9h
	# - 90° -> a 12h
	# 360° a 3h
	# etc...
	
	# Point 1 : $x1,$y1 , angle $a , longueur cote opposé $_a
	# Point 2 : $x2,$y2 , angle $b , longueur cote opposé $_b
	# Point 3 : $x3,$y3 , angle $c=90 degres , longueur cote opposé $_c
	
	my($x1, $y1, $x2, $y2)=@_;
	
	my($a)=0;
	my($x3)=$x2;
	my($y3)=$y1;
	my($_a)=$y3-$y2;
	my($_b)=$x3-$x1;
	$a=atan2($_a,$_b);

	return rad2deg($a);
}

sub _get_coordonnees_intersection{
	# Fonction : Calcule les coordonnées de l'intersection de 2 droites.
	
	# Les Segments sont définis par :
	# X1 Y1 à X2 Y2 pour le premier.
	# X3 Y3 à X4 Y4 pour le deuxième.
	
	# Il n'y a pas de gestion d'erreur si les segments sont parallèles.
	
	my($X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4) = @_;
	
	my($Xi) = (($X3 * $Y4 - $X4 * $Y3) * ($X1 - $X2) - ($X1 * $Y2 - $X2 * $Y1) * ($X3 - $X4)) / (($Y1 - $Y2) * ($X3 - $X4) - ($Y3 - $Y4) * ($X1 - $X2));
	my($Yi) = $Xi * (($Y1 - $Y2)/($X1 - $X2)) + (($X1 * $Y2 - $X2 * $Y1)/($X1 - $X2));
	
	return $Xi,$Yi;
}
# --- Effet ---
sub _effet_mixage_dats{
	my($this, $no_nervure)=@_;
		
	# Fonction : 
	# Mixe les profils d'emplanture et de saumon.
	# La nervure 0 (0%) est egale au profil de l'emplanture.
	# La dernière nervure (100%) est egale au profil du saumon.
	# Les nervures intermediaires sont un mix entre les 2 profils.
	# Les coordonnees calculees sont memorisees dans :
	# $this->{dat_coordonnees_x} et $this->{dat_coordonnees_y}
	
	# --- Premiere nervure ---
	if($no_nervure == 0){
		$this->{dat_coordonnees_x} = $this->{dat_coordonnees_x_emplanture};
		$this->{dat_coordonnees_y} = $this->{dat_coordonnees_y_emplanture}; 
	}
	
	# --- Derniere nervure ---
	elsif($no_nervure == -1+$this->{nb_nervures}){
		$this->{dat_coordonnees_x} = $this->{dat_coordonnees_x_saumon};
		$this->{dat_coordonnees_y} = $this->{dat_coordonnees_y_saumon}; 
	}
	
	# --- Nervures intermediaires ---
	else{
		my(@daty);
		my($_pourcentage) = ( 100 * $no_nervure ) / ( $this->{nb_nervures} - 1 );
		my($_x_emplanture, $_y_emplanture) = 0;
		my($_x_saumon, $_y_saumon) = 0;
		my($_extrados) = 1;
		my($_x_precedent) = 9999;
		my($pt0, $pt1)=0; # Sert a compter le nombre de points sur l'extrados et l'intrados. Utilisé pour le debug.
		# On passe en revue tous les points du profil d'emplanture.
		# Pour la coordonnee x d'emplanture en cours on memorise la coordonnee y d'emplanture.
		# Pour la coordonnee x d'emplanture en cours on calcule la correspondance x,y sur le profil du saumon.
		# y final = y emplanture - ( ( y emplanture - y saumon ) * ( pourcentage / 100 ) )
		$this->{dat_coordonnees_x} = $this->{dat_coordonnees_x_emplanture};
		for(my($i)=0; $i<=$#{$this->{dat_coordonnees_x_emplanture}}; $i++){
			$_x_emplanture = $this->{dat_coordonnees_x_emplanture}[$i];
			$_y_emplanture = $this->{dat_coordonnees_y_emplanture}[$i];
			# On regarde si on est sur l'extrados ou l'intrados du profil.
			if( $_x_precedent < $_x_emplanture ){$_extrados = 0;}
			# Pour la coordonnee x en cours on calcule la correspondance x,y sur le profil du saumon.
				my($_x0)=9999;
				my($_y0, $_x1, $_y1) = 0;
				for(my($j)=0; $j<=$#{$this->{dat_coordonnees_x_saumon}}; $j++){
					$_x1 = $this->{dat_coordonnees_x_saumon}[$j];
					$_y1 = $this->{dat_coordonnees_y_saumon}[$j];
					# Si on est sur l'extrados :
					if($_extrados){
						if( ($_x1 <= $_x_emplanture) and ($_x_emplanture < $_x0) ){
							($_x_saumon, $_y_saumon) = _get_coordonnees_intersection($_x0, $_y0, $_x1, $_y1, $_x_emplanture, 0, $_x_emplanture ,1);
							#print "(+) $_x_saumon, $_y_saumon\n";
							$pt0++; # Comptage des points de l'extrados.
							last;
						}
					}
					# Si on est sur l'intrados :
					else {
						if( ($_x0 < $_x_emplanture) and ($_x_emplanture <= $_x1) ){
							if($j == $#{$this->{dat_coordonnees_x_saumon}}){$_x1 = 2; $_y1 = $_y0; $_x0=0;}
							($_x_saumon, $_y_saumon) = _get_coordonnees_intersection($_x1, $_y1, $_x0, $_y0, $_x_emplanture, 0, $_x_emplanture ,-1);
							#print "(-) $_x_saumon, $_y_saumon\n";
							$pt1++; # Comptage des points de l'intrados.
							last;
						}
					}
					# Memorisation du point.
					$_x0 = $_x1;
					$_y0 = $_y1;
				} # for $j
			# Memorisation de la coordonnee $_y_saumon venant d'etre calculee.
			$_y_saumon = $_y_emplanture - ( ( $_y_emplanture - $_y_saumon ) * ( $_pourcentage / 100 ) );
			push(@daty, $_y_saumon);
			# Memorisation de la coordonnee x emplanture actuelle.
			$_x_precedent = $this->{dat_coordonnees_x_emplanture}[$i];
		} # for $i
		# Memorisation de toutes les coordonnees y calculees.
		#print "Nb points extrados / intrados => $pt0 / $pt1\n";
		#print "$#{$this->{dat_coordonnees_x}} points x\n";
		#print "$#daty points y\n";
		$this->{dat_coordonnees_y} = ( 0 => [@daty] );
	}
	
	return;
}
sub _effet_rotation_dat{
	my($this, $no_nervure)=@_;
	
	# Fonction : "Rotate" le profil à partir de ses coordonnées, du calage de l'emplanture, du
	# calage du saumon, et du numéro de la nervure en cours.
	
	if( ($this->{calage_emplanture} == 0) && ($this->{calage_saumon} == 0) ){ return; }
	
	my($_centre_x) = 1; # Centre de rotation positionne au bord de fuite.
	my($_centre_y) = 0; # Centre de rotation positionne au bord de fuite.
	
	my($_angle, $_angle_final, $_ptx, $_pty, $_dx, $_dy, $_hypothenuse) = 0;
	my($_angle_rotation) = 0;
	
	# --- Premiere nervure ---
	if($no_nervure == 0){ 
		$_angle_rotation = $this->{calage_emplanture}; 
	}
	
	# --- Derniere nervure ---
	elsif($no_nervure == -1+$this->{nb_nervures}){
		$_angle_rotation = $this->{calage_saumon};
	}
	
	# --- Nervures intermediaires ---
	else{
		my($_angle_total) = abs($this->{calage_emplanture}) + abs($this->{calage_saumon});
		my($_angle_step) = $_angle_total / ($this->{nb_nervures} - 1);
		$_angle_rotation = $this->{calage_emplanture} - ($_angle_step * $no_nervure);
	}
	
	# --- Stockage temporaire du calage de la nervure ---
	$this->{dat_calage} = $_angle_rotation;
	
	# --- Rotation de la nervure ---
	
	for(my($i)=0; $i <= $#{$this->{dat_coordonnees_x}}; $i++){
		$_ptx = $this->{dat_coordonnees_x}[$i];
		$_pty = $this->{dat_coordonnees_y}[$i];
		$_angle = _angle_entre_2_points($_centre_x, $_centre_y, $_ptx, $_pty);
		$_angle_final = $_angle + $_angle_rotation;
		$_hypothenuse = _get_distance_entre_2_points($_centre_x, $_centre_y, $_ptx, $_pty);
		# cos alpha = adjacent / hypothenuse <==> adjacent = cos alpha * hypothenuse
		$_dx = cos(deg2rad($_angle_final)) * ($_hypothenuse);
		# sin alpha = oppose / hypothenuse <==> oppose = sin alpha * hypothenuse
		$_dy = sin(deg2rad($_angle_final)) * ($_hypothenuse);
		# Memorisation des coordonnees finales de ce point.
		$this->{dat_coordonnees_x}[$i] = $_centre_x + $_dx;
		$this->{dat_coordonnees_y}[$i] = $_centre_y - $_dy;
		# print "$_ptx, $_pty / $this->{dat_coordonnees_x}[$i], $this->{dat_coordonnees_y}[$i]\n";
	}
	
	return;
}
# ===============================
# --- Documentation du module ---
# ===============================

# "perldoc airfoil2pdf.pm" permet d'afficher cette documentation à partir d'un terminal.

1;
__END__

=head1 NAME

 airfoil2pdf.pm - Generation de nervures pour l'aeromodelisme.

=head1 DESCRIPTION

Ce module permet de generer les nervures d'un profil a n'importe qu'elle echelle. Le fichier source contenant les coordonnees du profil est un fichier au format .dat . Le resultat est un fichier .pdf contenant le nombre de nervures demandees dont les dimensions sont calculees par rapport aux cordes d'emplanture et de saumon.

=head1 SYNOPSIS

use profil.pm;
 my $profil = profil->new();
 $profil->setDatEmplanture('e169');
 $profil->setCordeEmplanture(300);
 $profil->setCordeSaumon(200);
 $profil->setNbNervures(5);
 $profil->setEpaisseurCoffrage(1.5);
 $profil->setImprimante('A3');
 $profil->setOrientation('portrait');

=head1 FUNCTION setDatEmplanture

 Cette methode permet de definir le profil a utiliser pour l'emplanture de l'aile.
 Exemple : $profil->setDatEmplanture('e169');

=head1 FUNCTION setDatSaumon

 Cette methode permet de definir le profil a utiliser pour le saumon de l'aile.
 Par defaut, si le fichier .dat n'est pas spécifie, celui de l'emplanture est utilise.
 Exemple : $profil->setDatSaumon('n2412');

=head1 FUNCTION setCordeSaumon

 Cette methode permet de definir la longueur en mm de la corde du saumon.
 Exemple : $profil->setCordeSaumon(200);

=head1 FUNCTION setCordeEmplanture

 Cette fonction permet de definir la longueur en mm de la corde d'emplanture.
 Exemple : $airfoil->setEmplanture(300);

=head1 FUNCTION setNbNervures

Cette fonction permet de definir le nombre de nervures a generer.
Si aucun nombre n'est specifie, le programme regarde les longueurs des
cordes d'emplanture et de saumon, et en tire le nombre de nervures 
a generer : 0,1 ou 2
 Exemple : $airfoil->setNbNervures(4);
 Exemple : $airfoil->setNbNervures();
 
=head1 FUNCTION setTalonNervure
 
 Cette fonction permet de definir si des talons doivent etre ajoutes aux nervures.
 Les valeurs possibles sont 0 ou 1 (defaut).
 Exemple : $airfoil->setTalonNervure(0);
 Exemple : $airfoil->setTalonNervure(1);
 
=head1 FUNCTION setEpaisseurCoffrage

 Cette fonction permet de definir l'epaisseur du coffrage en mm.
 Les valeurs courantes sont : 1mm, 1.5mm, 2mm, 3mm
 Exemple : $airfoil->setEpaisseurCoffrage(1.5);

=head1 FUNCTION setCoinsDecoupe

 Cette fonction permet de definir si des coins de decoupe sont dessines.
 Les valeurs possibles sont 0 ou 1 (defaut).
 Exemple : $airfoil->setCoinsDecoupe(0);
 Exemple : $airfoil->setCoinsDecoupe(1);

=head1 FUNCTION setDossierDat

 Cette fonction permet de definir l'emplacement du dossier contenant
 les fichiers des profils au format .dat
 Exemple : $airfoil->setDossierDat('/donnees/profils/dats/');

=head1 FUNCTION setDossierDeSauvegarde

 Cette fonction permet de definir l'emplacement du dossier dans
 lequel le fichier final .pdf sera sauvegarde.
 Exemple : $airfoil->setDossierDeSauvegarde('/donnees/profils/pdfs/');

=head1 FUNCTION setImprimante

 Cette fonction permet de definir le format de votre imprimante : A4 (defaut) / A3
 Exemple : $airfoil->setImprimante('A3');

=head1 FUNCTION setOrientation

 Cette fonction permet de definir l'orientation de l'impression : portrait / paysage (defaut)
 Exemple : $airfoil->setOrientation('portrait');

=head1 FUNCTION setDpi

 Cette fonction permet de definir la resolution de l'impression.
 Plus la valeur est elevee, et plus les traces sont fins.
 Les valeurs courantes sont : 150dpi (defaut) , 300dpi
 Exemple : $airfoil->setDpi(150);

=head1 FUNCTION creerPdf

 Cette fonction demarre la creation du fichier au format .pdf
 Le fichier est sauvegarde dans le dossier defini avec la
 fonction "setDossierDeSauvegarde".

=cut
