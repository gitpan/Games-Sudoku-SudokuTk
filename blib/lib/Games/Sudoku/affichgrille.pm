#* Copyright (C) 2008 Christian Guine
# * This program is free software; you can redistribute it and/or modify it
# * under the terms of the GNU General Public License as published by the Free
# * Software Fondation; either version 2 of the License, or (at your option)
# * any later version.
# * This program is distributed in the hope that it will be useful, but WITHOUT
# * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# * more details.
# * You should have received a copy of the GNU General Public License along with
# * this program; if not, write to the Free Software Foundation, Inc., 59
# * Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# */
# affichgrille.pm    Posting of a grid 
#               fonction = "S" ==> solution
#               fonction = "R" ==> resolution
#               fonction = "C" ==> grid creation
#               fonction = "T" ==> seizure grid
#               fonction = "V" ==> seizure solution
sub affichgrille {
        use Tk;
        use Games::Sudoku::menu;
        use Games::Sudoku::tr1;
        if ($wcanvas == 1) {                    # cancellation image beginning 
                $canvas -> destroy;
                $framed -> destroy;
                $wcanvas = 0;
        } else {
                $frame1 -> destroy;
        }
        ($fonction) = @_;
        if ($Enfant == 1) {
                $nbcase = 4;
        } elsif ($MaxiSudoku == 1) {
                $nbcase = 16;
        } else {
                $nbcase = 9;
        }
        if ($fonction eq "S") {
                menu('affichgrilleS');
        } else {
                menu('affichgrille');
        }
        if ($fonction eq "R") {
                $frame1 = $main->Frame(-width => 750, -height => 500);
                $frame1->pack(-side=>'left');
                my $frame2 = $frame1->Frame;            # Posting Question 
                $frame2->pack;
                $frame2->Label(-text=>tr1('Est ce une nouvelle grille? oui/non'),
                        -font => "Nimbus 15")->pack(-side=>'left');
                $listoption = $frame2->Listbox(-width => 5, -height => 2)->pack(-side=>'right');
                $listoption->insert('end',tr1('OUI'),tr1('NON'));
                $listoption->activate(0);
                $listoption->bind('<Double-1>',\&OK1);
                $main->bind('<Key-Return>', => [\&OK1]);
                my $frame3 =$frame1->Frame;
                        $frame3->pack;
                $frame3 = $frame1->Button (
                                -command=>[\&OK1],
                                -text=>tr1('OK')
                        )->pack();
        } elsif ($fonction eq "C") {
                $frame1 = $main->Frame(-width => 750, -height => 600);
                $frame1->pack(-side=>'left');
                my $frame2 = $frame1->Frame;            # Posting Question 
                $frame2->pack;
                $frame2->Label(-text=>tr1('Quelle difficulté?'),
                        -font => "Nimbus 15")->pack(-side=>'left');
                $listdifficulte = $frame2->Listbox(-width => 10, -height => 3)->pack(-side=>'right');
                $listdifficulte->insert('end',tr1('Facile'),tr1('Difficile'),tr1('Très difficile'));
                $listdifficulte->activate(0);
                $listdifficulte->bind('<Double-1>',\&OK2);
                $main->bind('<Key-Return>', => [\&OK2]);
                my $frame3 = $frame1->Frame;
                        $frame3->pack;
                $frame3 = $frame1->Button (
                                -command=>[\&OK2],
                                -text=>tr1('OK')
                        )->pack();
        } else {
                menu('affichgrilleS');
                $frame1 = $main->Frame(-width => 750, -height => 600);
                $frame1->pack(-side=>'left');
                init_tableau();
                affichage_grille($fonction);
        }
        
}
1;

sub creation_grille {                   # Posting grid to build a problem
        if ($wcanvas == 1) {
                $canvas -> destroy;
                $framed -> destroy;
                $wcanvas = 0;
        } else {
                $frame1 -> destroy;
        }
        if ($Enfant == 1) {
                $nbcase = 4;
        } elsif ($MaxiSudoku == 1) {
                $nbcase = 16;
        } else {
                $nbcase = 9;
        }
        menu('affichgrille');
        $fonction = "R";
        menu('affichgrilleS');
        $frame1 = $main->Frame;
        $frame1->pack(-side=>'left');

        @precarre = ' ';
        @frame = ' ';
        @frame1 = ' ';
        @carre = 0;
        init_tableau();
        affichage_grille($fonction);        
}

sub OK1 {                       # seizure answer to question new grid yes/no
        use Games::Sudoku::sudokuprincipal;
        use Games::Sudoku::tr1;
        @precarre = ' ';
        @frame = ' ';
        @frame1 = ' ';
        @carre = 0;
        $option = $listoption->get('active');
        $option =~ s/^\s+//;      # delete spaces beginning and end
        my $reponse = tr1('NON');
        my $reponse1 = tr1('non');
        if ($option =~ m/$reponse/ or $option =~ m/$reponse1/) {
                #print "importation\n";
                importation("","txt");
        } else {
                #print "init\n";
                init_tableau();       
        }
        #print "OK1 " . $option . "\n";
        $trait = "T";
        $fin = 0;
        affichage_grille('T');
}

sub OK2 {                       # seizure answer to question difficult
        use Games::Sudoku::sudokuprincipal;
        use Games::Sudoku::tr1;
        $option = $listdifficulte->get('active');
        $option =~ s/^\s+//;      # delete spaces beginning and end
        my $reponse = tr1('Facile');
        my $reponse1 = tr1('Difficile');
        my $reponse2 = tr1('Très difficile');
        if ($option eq $reponse1) {
                $difficulte = 1;
        } elsif ($option eq $reponse2) {
                $difficulte = 2;
        } else {
                $difficulte = 0;
        }
        newgrille();
}

sub affichage_grille {          # posting grid
        use Games::Sudoku::saisie1;
        ($trait) = @_;
        #print "affichage grille trait= " . $trait . "\n";
        $frame1->destroy;
        $frame1 = $main->Frame(-width => 750, -height => 600);
        $frame1->pack;
        $frame2 = $frame1->Frame;
        $frame2->pack;
        $frame7 = $frame2->Frame->pack(-side=>'right');         # posting right side
        if ($trait ne "F" or $fin != 1) {
                if ($fonction ne "S") {
                        if ($trait ne "T" and $trait ne "V") {
                                if ($fin == 0) {
                                        $frame10 = $frame7->Label(-text => tr1('Tout n\'est pas réglé'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                        $frame8 = $frame7->Label(-text => 
                                                tr1('Supprimer le chiffre choisi'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                                $frame9 = $frame7->Button (
                                                        -command=>\&saisie1,
                                                        -text=>tr1('OK')
                                                        )->pack();
                                } else {
                                        $frame8 = $frame7->Label(-text => 
                                                tr1('Supprimer le chiffre choisi'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                }
                        } else {        # T seizure ou V end seizure
                                if ($erreur_saisie == 1 and $trait eq "T") {
                                        $frame11 = $frame7->Label(-text => tr1('Erreur de saisie'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                }
                                if ($erreur_saisie == 1 and $trait eq "V") {
                                        $frame11 = $frame7->Label(-text => tr1('Erreur'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                }
                                if ($fin == 0) {    # all is not found
                                        if ($trait eq "V") {
                                                $frame11 = $frame7->Frame;
                                                $checkaide= $frame7->Checkbutton(-text 
                                                        => tr1('Aide?'), 
                                                        -font => "Nimbus 15",
                                                        -variable => \$aide,
                                                        -command => \&importations
                                                        )->pack();
                                                if ($aide == 1) {
                                                        $checkaide->select;
                                                } else {
                                                        $checkaide->deselect;
                                                }
                                                if ($erreur_aide == 1) {
                                                        #print ("bonnevaleur = " . $bonnevaleur . "\n");
                                                        $affichbonnevaleur = $bonnevaleur;
                                                        if ($affichbonnevaleur == 10) {
                                                                $affichbonnevaleur = "A";
                                                        }
                                                        if ($affichbonnevaleur == 11) {
                                                                $affichbonnevaleur = "B";
                                                        }
                                                        if ($affichbonnevaleur == 12) {
                                                                $affichbonnevaleur = "C";
                                                        }
                                                        if ($affichbonnevaleur == 13) {
                                                                $affichbonnevaleur = "D";
                                                        }
                                                        if ($affichbonnevaleur == 14) {
                                                                $affichbonnevaleur = "E";
                                                        }
                                                        if ($affichbonnevaleur == 15) {
                                                                $affichbonnevaleur = "F";
                                                        }
                                                        if ($affichbonnevaleur == 16) {
                                                                $affichbonnevaleur = "G";
                                                        }
                                                        if ($dessin eq "animaux") {
                                                                $frame12 = $frame7->Frame;
                                                                $frame121 = $frame12->Label(-text
                                                                => tr1('Faux la bonne valeur est '), 
                                                                -font => "Nimbus 15"
                                                                )->pack(-side => 'left');
                                                                my $nomdessinanimaux = 
                                                                        $dessinanimaux{$affichbonnevaleur};
                                                                my $fichier = 
                                                                        $pref . '/photos/' . $nomdessinanimaux;
                                                                my $image = "image" . ($affichbonnevaleur);
                                                                my $im = $frame12
                                                                        ->Photo($image, -file => $fichier);
                                                                my $button = $frame12
                                                                        ->Button(-height => 45, -width => 45,
                                                                        -image => $im);
                                                                $button->pack(-side => 'left');
                                                        } else {
                                                                $frame12 = $frame7->Label(-text
                                                                => tr1('Faux la bonne valeur est ') 
                                                                . $affichbonnevaleur,
                                                                -font => "Nimbus 15"
                                                                )->pack();
                                                        }
                                                        $frame12->pack;
                                                }
                                                $frame10 = $frame7->Label(-text 
                                                        => tr1('Tout n\'est pas trouvé'),
                                                        -font => "Nimbus 15"
                                                        )->pack();
                                        }
                                        if ($dessin eq "animaux") {
                                                $frame8 = $frame7->Label(-text => tr1('Choisir dessin'),
                                                        -font => "Nimbus 15"
                                                        )->pack();
                                        } else {
                                                $frame8 = $frame7->Label(-text => tr1('Saisir chiffres'),
                                                        -font => "Nimbus 15"
                                                        )->pack();
                                        }
                                        $frame9 = $frame7->Button (
                                                -command=>\&fin_saisie,
                                                -text=> tr1('FIN SAISIE')
                                                )->pack();
                                } else {        # all is found
                                        $frame10 = $frame7->Label(-text => tr1('Bravo'),
                                                -font => "Nimbus 15"
                                                )->pack();
                                        
                                }
                        }
                } else {
                }
        } else {
                $frame10 = $frame7->Label(-text => tr1('Tout est réglé'),
                        -font => "Nimbus 15"
                        )->pack();
        }
        $i = 0;
        $j = 0;
        if ($nbcase == 4) {
                $wimax = 2;
                $wjmax = 2;
                $tailleborder = 2;
        } elsif ($nbcase == 16) {
                $wimax = 4;
                $wjmax = 4;
                $tailleborder = 2;
        } else {
                $wimax = 3;
                $wjmax = 3;
                $tailleborder = 4;
        }
        for ($wi = 0; $wi < $wimax; $wi++) {         # posting areas
                $frame3[$wi] = $frame2->Frame(-borderwidth=>4)->pack;
                for ($wj = 0; $wj < $wjmax; $wj++) {
                        $frame4[$wi][$wj] = $frame3[$wi]->Frame(-borderwidth=>$tailleborder)
                                ->pack(-side=>'left');
                        for ($wwi = 0; $wwi < $wimax; $wwi++) {
                                $frame5[$wi][$wj][$wwi] = $frame4[$wi][$wj]->Frame->pack;
                                for ($wwj = 0; $wwj < $wjmax; $wwj++) {
                                        $frame6[$wi][$wj][$wwi][$wwj] = $frame5[$wi][$wj][$wwi]
                                                ->Frame(-borderwidth=>($tailleborder/2))
                                                ->pack(-side=>'left');
                                                $i = ($wimax * $wi) + $wwi;
                                                $j = ($wjmax * $wj) + $wwj;
                                                affich_case($i,$j);
                                }
                        }
                }
        }
        #print "fin affich trait= " . $trait . "\n";
        if ($trait eq "V") {

                $traitexport = " ";
                exportation();
        }
        $main->bind('<Key-Return>', => [\&saisie2]);
                #}
}

sub affich_case {           # posting a square
        #use Games::Sudoku::conf;
        #conf();
        my ($i,$j) = @_;
        #print ("affich_case " . $i . " " . $j . "\n");
        if ($nbcase == 9 or $nbcase == 4) { 
                        $width = 2;
                        $taillefont = "30";
                } else { 
                        $width = 1;
                        $taillefont = "20";
                }
        my $trouve = 0;
        for (my $k = 0; $k < $nbcase; $k++) {
                if ($precarre[$i][$j][$k] eq "S" or $precarre[$i][$j][$k] eq "C") {
                        $wk = $k + 1; 
                        if ($wk < 10) {
                                $wkaffich = $wk;
                        } elsif ($wk == 10) {
                                $wkaffich = "A";
                        } elsif ($wk == 11) {
                                $wkaffich = "B";
                        } elsif ($wk == 12) {
                                $wkaffich = "C";
                        } elsif ($wk == 13) {
                                $wkaffich = "D";
                        } elsif ($wk == 14) {
                                $wkaffich = "E";
                        } elsif ($wk == 15) {
                                $wkaffich = "F";
                        } else {
                                $wkaffich = "G";
                        } 
                        $trouve++;
                }
        }
        if ($trouve != 0) {             # posting big square because number is found
                
                #print ("i= " . $i . " j= " . $j . " " . $precarre[$i][$j][$wk - 1] . "\n");
                if ($precarre[$i][$j][$wk - 1] eq "S") {
                        $backgroundcouleur = "red";
                } else {
                        $backgroundcouleur = "blue";
                }
                affich();
        } elsif ($trait eq "T" or $trait eq "V") { #posting big white square
                if ($dessin eq "animaux") {
                        if ($system eq "linux") {
                                $height = 2;
                                $width = 2;
                        } else { 
                                $height = 3;
                                $width = 7;
                        }
                        $entrycarre[$i][$j][0] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Button(-text => ' ', -height => $height, -width => $width,
                        -activebackground => "yellow",
                        -command => [\&affichdessin,$i,$j,$wi,$wj,$wwi,$wwj])
                        ->pack(-side=>'left');
                } else {
                        $entrycarre[$i][$j][0] = $frame6[$wi][$wj][$wwi][$wwj]
                                ->Entry(-width=>2,-font => "Nimbus " . $taillefont,-background => "white")
                                ->pack;
                        $entrycarre[$i][$j][0]->insert(0," ");
                }
        } else {                        # posting small square because number not found
                for ($k = 0; $k < $nbcase; $k++) {
                        $wk = $k + 1;
                        if ($wk < 10) {
                                $wkaffich = $wk;
                        } elsif ($wk == 10) {
                                $wkaffich = "A";
                        } elsif ($wk == 11) {
                                $wkaffich = "B";
                        } elsif ($wk == 12) {
                                $wkaffich = "C";
                        } elsif ($wk == 13) {
                                $wkaffich = "D";
                        } elsif ($wk == 14) {
                                $wkaffich = "E";
                        } elsif ($wk == 15) {
                                $wkaffich = "F";
                        } else {
                                $wkaffich = "G";
                        }
                        if ($nbcase == 4) {
                                $width = 2;
                                $taillefont = 4;
                                if ($k == 0 or $k == 2 or $k == 4) {
                                        if ($k == 0) {
                                                $wwk = 0;
                                        } elsif ($k == 2) {
                                                $wwk = 1;
                                        } else {
                                                $wwk = 2;
                                        }
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk] = $frame6[$wi][$wj][$wwi][$wwj]
                                        ->Frame(-borderwidth=>1);
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk]->pack;
                                }       
                        } elsif ($nbcase == 9) {
                                $width = 2;
                                $taillefont = 4;
                                if ($k == 0 or $k == 3 or $k == 6) {
                                        if ($k == 0) {
                                                $wwk = 0;
                                        } elsif ($k == 3) {
                                                $wwk = 1;
                                        } else {
                                                $wwk = 2;
                                        }
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk] = $frame6[$wi][$wj][$wwi][$wwj]
                                        ->Frame(-borderwidth=>1);
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk]->pack;
                                }
                        } else {                    #nbcase = 16
                                $width = 1;
                                $taillefont = 1;
                                if ($k == 0 or $k == 4 or $k == 8 or $k == 12) {
                                        if ($k == 0) {
                                                $wwk = 0;
                                        } elsif ($k == 4) {
                                                $wwk = 1;
                                        } elsif ($k == 8) {
                                                $wwk = 2;
                                        } else {
                                                $wwk = 3;
                                        }
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk] = $frame6[$wi][$wj][$wwi][$wwj]
                                        ->Frame(-borderwidth=>1);
                                $frame7[$wi][$wj][$wwi][$wwj][$wwk]->pack;
                                }
                        }
                        affich1();                # posting little square
                }
        }
}

sub affich {
        use Games::Sudoku::conf; 
        conf();
        if ($dessin eq "animaux") {
                $entrycarre[$i][$j][$k] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Canvas('width' => 45,-highlightbackground => 'black',
                                -height => 45);
                my $nomdessinanimaux = $dessinanimaux{$wkaffich};
                my $fichier = $pref . '/photos/' . $nomdessinanimaux;
                my $image = "image" . $wkaffich;
                $frame6[$wi][$wj][$wwi][$wwj]
                        ->Photo($image, -file => $fichier);
                $entrycarre[$i][$j][$k]->createImage(0, 0, -anchor => 'nw',
                        -image => $image);
                $entrycarre[$i][$j][$k]->pack;
        } else {
                $entrycarre[$i][$j][$k] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Entry(-width=>2, -font => "Nimbus " . $taillefont,
                        -background=>$backgroundcouleur)->pack;
                $entrycarre[$i][$j][$k]->insert(0," " . $wkaffich);
        }             
}

sub affich1 {                 # posting square or image
        #use Games::Sudoku::conf; 
        #conf();
        $entrycarre[$i][$j][$k] = $frame7[$wi][$wj][$wwi][$wwj][$wwk]
                ->Entry(-width=>$width,-selectforeground => 'red',
                -font => "Nimbus " . $taillefont)
                ->pack(-side=>'left');
        if ($precarre[$i][$j][$k] eq "P") {
                        $entrycarre[$i][$j][$k]->insert(0,$wkaffich);
        } else {
                        $entrycarre[$i][$j][$k]->insert(0,"  ");
        }
}

sub affichdessin {
        my ($idessin, $jdessin, $wi, $wj, $wwi, $wwj, $code) = @_;
        use Games::Sudoku::conf; 
        conf();
        #print "affichdessin $idessin $jdessin\n";
        if ($system eq "linux") {
                $height = 2;
                $width = 2;
        } else { 
                $height = 3;
                $width = 7;
        }
        $entrycarre[$idessin][$jdessin][0]->destroy;
        $entrycarre[$idessin][$jdessin][0] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Button(-text => ' ', -height => $height, -width => $width,
                        -background => "yellow")
                        ->pack(-side=>'left');
        $frame3 = $frame1->Frame->pack;
        my $textframe3 = $frame3->Label(-text => tr1('Choisissez'), 
                -font => "Nimbus 20")->pack;
        $frame4 = $frame1->Frame->pack;
        for (my $i = 0; $i < $nbcase; $i++) {             # posting drawings for choice
                my $nomdessinanimaux = $dessinanimaux{$i + 1};
                my $fichier = $pref . '/photos/' . $nomdessinanimaux;
                my $image = "image" . ($i + 1);
                my $im = $frame4->Photo($image, -file => $fichier);
                my $button = $frame4->Button(-height => 45, -width => 45,
                        -image => $im,
                        -command => [\&saisiedessin,$idessin,$jdessin,$i + 1]);
                $button->pack(-side => 'left');
        } 
        if ($system eq "Linux") {
                                $height = 3;
                                $width = 3;
                        } else { 
                                $height = 3;
                                $width = 7;
                        }
        my $button = $frame4->Button(-height => $height, -width => $width,
                        -text => tr1("annulation"),
                        -command => [\&annuldessin, $idessin, $jdessin, $wi, $wj, $wwi, $wwj]);
                $button->pack(-side => 'left');
}

sub annuldessin {
# step backwards on choice square in the case of drawings
        #use Games::Sudoku::conf; 
        #conf();
        my ($idessin, $jdessin, $wi, $wj, $wwi, $wwj, $code) = @_;
        if ($system eq "linux") {
                $height = 2;
                $width = 2;
        } else { 
                $height = 3;
                $width = 7;
        }
        $entrycarre[$idessin][$jdessin][0]->destroy;
        $entrycarre[$idessin][$jdessin][0] = $frame6[$wi][$wj][$wwi][$wwj]
                ->Button(-text => ' ', -height => $height, -width => $width,
                -background => "white",
                -command => [\&affichdessin,$idessin,$jdessin,$wi,$wj,$wwi,$wwj])
                ->pack(-side=>'left');
        $frame4->destroy;
        $frame3->destroy;        
}
sub Normal {
        if ($MaxiSudoku == 0) {
                $rbutton2->destroy;
                $MaxiSudoku = 2;
        }
        if ($Enfant == 0) {
                $rbutton3->destroy;
                $Enfant = 2;
        }
}

sub MaxiSudoku {
        if ($Normal == 0) {
                $rbutton1->destroy;
                $Normal = 2;
        }
        if ($Enfant == 0) {
                $rbutton3->destroy;
                $Enfant = 2;
        }
}

sub Enfant { 
        if ($Normal == 0) {
                $rbutton1->destroy;
                $Normal = 2;
        }
        if ($MaxiSudoku == 0) {
                $rbutton2->destroy;
                $MaxiSudoku = 2;
        }
        $dessin = "animaux";            # option by default
}

sub saisiedessin {
        # we chose a drawings which is transformed into number
        use Games::Sudoku::saisie1;
        ($idessin, $jdessin, $valdessin, $code) = @_;
        #print "saisiedessin $idessin $jdessin $valdessin\n";
        if ($valdessin == 10) {
                $valdessin = "A";
        } elsif ($valdessin == 11) {
                $valdessin = "B";
        } elsif ($valdessin == 12) {
                $valdessin = "C";
        } elsif ($valdessin == 13) {
                $valeurw = "D";
        } elsif ($valdessin == 14) {
                $valdessin = "E";
        } elsif ($valdessin == 15) {
                $valdessin = "F";
        } elsif ($valdessin == 16) {
                $valdessin = "G";
        }
        saisie1();      # Forcage at the end of seizure for backup
}