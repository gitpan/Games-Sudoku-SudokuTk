package Games::Sudoku::SudokuTk;

use 5.008007;
#use strict;
#use warnings;


our $VERSION = '0.05'; 

sudoku();

# Autoload methods go after =cut, and are processed by the autosplit program.
 

1;

sub sudoku {
use Tk;
@precarre = "";
@wprecarre = "";
# Definition of main window 
$langue = "";
$main = MainWindow->new();
menu('sudoku');

$canvas = $main->Label(-text => 'Sudoku',
        -height => 4, -width => 10,
        -font => "Nimbus 100")->pack;
$wcanvas = 1;
MainLoop;
}

#* Copyright (C) 2006 Christian Guine
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
# menu.pm  menu management 
sub menu {
        use Games::Sudoku::affichgrille;
        use Games::Sudoku::newgrille;
        my ($origine) = @_;
        #print "menu " . $origine . "\n";
        # definition of menu
        if ($origine ne "sudoku") {
                $menubar -> destroy;
        }
        $menubar = $main->Frame;
        $menubar->pack(
                -fill => 'x');
        # File menu
        my $fichiermenu = $menubar->Menubutton(-text => tr1('Fichier'));
        $fichiermenu->pack(
                '-side' => 'left');

        #save
        $fichiermenu->command(
                -label          => tr1('Sauver'),
                -command        => [\&sauve],
                -accelerator    => 'Ctrl+s'
        );
        $main->bind('<Control-s>' => [\&sauve]);
        
        # Exit         
        $fichiermenu->command(
                -label          => tr1('Quitter'),
                -command        => [$main => 'destroy'],
                -accelerator    => 'Ctrl+q'
        );
        $main->bind('<Control-q>' => [$main => 'destroy']);
        
        if ($origine eq "affichgrille" or $origine eq "affichgrilleS" or $origine eq "sudoku") {
                # Options Menu
                my $optionmenu = $menubar->Menubutton(-text => tr1('Options'));
                $optionmenu->pack(
                        '-side' => 'left');
                # resolve of a seized grid
                $optionmenu->command(
                        -label          => tr1('Resoudre une grille saisie'),
                        -command        => [\&affichgrille,"R"],
                        -accelerator    => 'Ctrl+s',
                );
                $main->bind('<Control-s>' => [\&affichgrille,"R"]);

                # ask for a new grid
                $optionmenu->command(
                        -label          => tr1('Demander une nouvelle grille'),
                        -command        => [\&affichgrille,"C"],
                        -accelerator    => 'Ctrl+r',
                );
                $main->bind('<Control-n>' => [\&affichgrille,"R"]);
                
                # Creation of a new grid
                $optionmenu->command(
                        -label          => tr1('Creer une grille'),
                        -command        => [\&creation_grille],
                        -accelerator    => 'Ctrl+c',
                );
                my $text2 = tr1('Creer une grille') . ' C+c\n';
                $main->bind('<Control-c>' => [\&creation_grille]);
                
                if (($origine ne "affichgrilleS" 
                        and $origine ne "sudoku") or $trait = "V") {
                        # Solution
                        $optionmenu->command(
                                -label          => tr1('Solution'),
                                -command        => [\&solutiond,"S"],
                                -accelerator    => 'Ctrl+s',
                        );
                        my $text3 = tr1('Solution') . 'C+s\n';
                        $main->bind('Control-s>' => [\&solutiond,"S"]);
                }
        }
        # Language Menu
        my $languemenu = $menubar->Menubutton(-text => tr1('Langues'));
        $languemenu->pack(
                '-side' => 'left');
        # selection of languages
        $languemenu->radiobutton(-label => tr1('français'),
                -command => [\&changelang,"fr"]);        
        $languemenu->radiobutton(-label => tr1('anglais'),
                -command => [\&changelang,"en"]);   
        $languemenu->radiobutton(-label => tr1('allemand'),
                -command => [\&changelang,"ge"]);
        $languemenu->radiobutton(-label => tr1('espagnol'),
                -command => [\&changelang,"sp"]); 
        $languemenu->radiobutton(-label => tr1('italien'),
                -command => [\&changelang,"it"]);
        $languemenu->radiobutton(-label => tr1('portuguais'),
                -command => [\&changelang,"pt"]);
}
1;

#* Copyright (C) 2006 Christian Guine
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
                $wcanvas = 0;
        } else {
                $frame1 -> destroy;
        }
        ($fonction) = @_;
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
                $frame1 = $main->Frame(-width => 750, -height => 500);
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
                my $frame3 =$frame1->Frame;
                        $frame3->pack;
                $frame3 = $frame1->Button (
                                -command=>[\&OK2],
                                -text=>tr1('OK')
                        )->pack();   
        } else {
                menu('affichgrilleS');
                $frame1 = $main->Frame(-width => 750, -height => 500);
                $frame1->pack(-side=>'left');
                init_tableau();
                affichage_grille($fonction);
        }
        
}
1;

sub creation_grille {                   # Posting grid to build a problem
        if ($wcanvas == 1) {
                $canvas -> destroy;
                $wcanvas = 0;
        } else {
                $frame1 -> destroy;
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
                importation();
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
        newgrille('R');
}

sub affichage_grille {          # posting grid
        use Games::Sudoku::saisie1;
        ($trait) = @_;
        #print "affichage grille trait= " . $trait . "\n";
        $frame1->destroy;
        $frame1 = $main->Frame(-width => 750, -height => 500);
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
                                                        $frame12 = $frame7->Label(-text
                                                        => tr1('Faux la bonne valeur est ') 
                                                        . $bonnevaleur,
                                                        -font => "Nimbus 15"
                                                        )->pack();
                                                }
                                                $frame10 = $frame7->Label(-text 
                                                        => tr1('Tout n\'est pas trouvé'),
                                                        -font => "Nimbus 15"
                                                        )->pack();
                                        }
                                        $frame8 = $frame7->Label(-text => tr1('Saisir chiffres'),
                                                -font => "Nimbus 15"
                                                )->pack();
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
        for ($wi = 0; $wi < 3; $wi++) {         # posting areas
                $frame3[$wi] = $frame2->Frame(-borderwidth=>4)->pack;
                for ($wj = 0; $wj < 3; $wj++) {
                        $frame4[$wi][$wj] = $frame3[$wi]->Frame(-borderwidth=>4)->pack(-side=>'left');
                        for ($wwi = 0; $wwi < 3; $wwi++) {
                                $frame5[$wi][$wj][$wwi] = $frame4[$wi][$wj]->Frame->pack;
                                for ($wwj = 0; $wwj < 3; $wwj++) {
                                        $frame6[$wi][$wj][$wwi][$wwj] = $frame5[$wi][$wj][$wwi]
                                                ->Frame(-borderwidth=>2)->pack(-side=>'left');
                                                $i = (3 * $wi) + $wwi;
                                                $j = (3 * $wj) + $wwj;
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

sub affich_case {           # posting a box
        my ($i,$j) = @_;
        #print ("affich_case " . $i . " " . $j . "\n");
        my $trouve = 0;
        for (my $k = 0; $k < 9; $k++) {
                if ($precarre[$i][$j][$k] eq "S" or $precarre[$i][$j][$k] eq "C") {
                        $wk = $k + 1; 
                        $trouve++;
                }
        }
        if ($trouve != 0) {             # posting big box because number is found
                
                #print ("i= " . $i . " j= " . $j . " " . $precarre[$i][$j][$wk - 1] . "\n");
                if ($precarre[$i][$j][$wk - 1] eq "S") {
                        $backgroundcouleur = "red";
                } else {
                        $backgroundcouleur = "blue";
                }
                $entrycarre[$i][$j][$k] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Entry(-width=>2,-font => "Nimbus 30",-background=>$backgroundcouleur)
                        ->pack;
                $entrycarre[$i][$j][$k]->insert(0," " . $wk);
        } elsif ($trait eq "T" or $trait eq "V") { #posting big white box
                $entrycarre[$i][$j][0] = $frame6[$wi][$wj][$wwi][$wwj]
                        ->Entry(-width=>2,-font => "Nimbus 30",-background=> "white")
                        ->pack;
                $entrycarre[$i][$j][0]->insert(0," ");    
        } else {                        # postint small box because number not found
                for ($k = 0; $k < 9; $k++) {
                        $wk = $k + 1; 
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
                        $entrycarre[$i][$j][$k] = $frame7[$wi][$wj][$wwi][$wwj][$wwk]
                                ->Entry(-width=>2,-selectforeground => 'red')
                                ->pack(-side=>'left');
                        if ($precarre[$i][$j][$k] eq "P") { 
                                $entrycarre[$i][$j][$k]->insert(0," " . $wk);
                        } else {
                                $entrycarre[$i][$j][$k]->insert(0,"  ");
                        }
                }
        }
}

#* Copyright (C) 2006 Christian Guine
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
# newgrille.pm design of a new grid
sub newgrille { 
        use Games::Sudoku::sudokuprincipal;
        use Games::Sudoku::affichgrille;
        if ($wcanvas == 1) {            # delete Label of beginning
                $canvas -> destroy;
                $wcanvas = 0;
                $frame1 = $main->Frame;
                $frame1->pack;
        }
        $trait = "N";
        BOUCLE:while ($fin == 0) {              # loop as much as a solution was not found 
                                                # where all is found
        #print "debut boucle\n";
        init_tableau();                         # initialization table
        $fin = 0;
        $cpt = 0;
                LOOP:while ($fin == 0 and $cpt < 100) {         # loop for filling the grid
                        $cpt++;
                        # random search of a number
                        $i = int(rand(9));
                        $j = int(rand(9));
                        $k = int(rand(9));
                #print "ligne= " . ($i + 1) . " colonne= " . ($j + 1) . " valeur= " . ($k + 1) 
                 #       . " cpt= " . $cpt . "\n";
                        if ($precarre[$i][$j][$k] ne "P") {
                        #print ("deja pris");
                                next LOOP;
                        }
                        @wprecarre = "";        
                        # save before checking correct choice
                        for (my $wi = 0; $wi < 9; $wi++) {                
                                for (my $wj = 0; $wj < 9; $wj++) {
                                        for (my $wk = 0; $wk < 9; $wk++) {
                                                $wprecarre[$wi][$wj][$wk] = $precarre[$wi][$wj][$wk];
                                        }
                                }
                        }
                        # we cancel the other possibility on line column and area
                        $precarre[$i][$j][$k] = "S";
                        $trait = "N";
                        $ligne = $i;
                        $colonne = $j;
                        $valeur = $k;
                        $entree = "S";
                        $endroit = "";
                        modif_tableau();
                        # it is checked that there is no completely cancelled box
                        for (my $wi = 0; $wi < 9; $wi++) {                
                                for (my $wj = 0; $wj < 9; $wj++) {
                                        $trouve = 0;
                                        for (my $wk = 0; $wk < 9; $wk++) {
                                                if ($precarre[$wi][$wj][$wk] ne " ") {
                                                        $trouve = 1;
                                                }
                                        }
                                        if ($trouve == 0) {     # we have find a box completely cancelled
                                                                # we backup
                                                #print "case blanche i= " . $i . " j= " 
                                                 #      . $j . " k= " . $k . "\n";
                                                $#precarre = -1;
                                                for ($wi = 0; $wi < 9; $wi++) {                
                                                        for ($wj = 0; $wj < 9; $wj++) {
                                                                for ($wk = 0; $wk < 9; $wk++) {
                                                                        $precarre[$wi][$wj][$wk] = 
                                                                            $wprecarre[$wi][$wj][$wk];
                                                                }
                                                        }
                                                }
                                        exportation();
                                        #print ("case blanche");
                                        next LOOP;      #we seek an other number
                                        }
                                }
                        }
                        $final = 0;
                        solution();             # we are checking that all is found
                        $traitexport = "B";
                        exportationb();
                }
                # it is checked that all is filled
                $fin = 1; 
                $cpt1 = 0;
                $#enmoins = -1;
                for (my $wi = 0; $wi < 9; $wi++) {                
                        for (my $wj = 0; $wj < 9; $wj++) {
                                $trouve = 0;
                                for (my $wk = 0; $wk < 9; $wk++) {
                                        if ($precarre[$wi][$wj][$wk] ne " " 
                                                and $precarre[$wi][$wj][$wk] ne "P") {
                                                $trouve = 1;
                                                if ($precarre[$wi][$wj][$wk] eq "S") {
                                                        $cpt1++;      
                                                }                 
                                        }
                                }
                                if ($trouve == 0) {
                                        $fin = 0;       # we start again
                                }
                        }
                }
                #print "fin cpt1= " . $cpt1 . "\n";
        }
        $traitexport = "S";
        exportation();                # save the solution
        # Preparation grid for posting
        for (my $wi = 0; $wi < 9; $wi++) {                
                        for (my $wj = 0; $wj < 9; $wj++) {
                                $trouve = 0;
                                # Is it a seizure in the box? 
                                for (my $wk1 = 0; $wk1 < 9; $wk1++) {
                                        if ($precarre[$wi][$wj][$wk1] eq "S") {
                                                $trouve = 1;
                                                last;
                                        }
                                }      
                                for (my $wk = 0; $wk < 9; $wk++) {
                                        if ($precarre[$wi][$wj][$wk] ne "S") {
                                                if ($trouve == 0) { # if we find a seizure
                                                        $precarre[$wi][$wj][$wk] = "P";
                                                } else {
                                                        $precarre[$wi][$wj][$wk] = " ";
                                                }
                                        } 
                                }
                        }
        }
        # Elimination of impossible combinations
        for (my $wi = 0; $wi < 9; $wi++) {                
                        for (my $wj = 0; $wj < 9; $wj++) {
                                $trouve = 0;
                                for (my $wk = 0; $wk < 9; $wk++) {
                                        if ($precarre[$wi][$wj][$wk] eq "S") {
                                                $entree = "S";
                                                $ligne = $wi;
                                                $colonne = $wj;
                                                $valeur = $wk;
                                                $endroit = "";
                                                modif_tableau($entree);     
                                        }
                                }
                        }
        }
        $fin = 0;
        $traitexport = " ";
        exportation();
        $traitexport = "S";
        exportation();
        retour_arriere();
        $traitexport = " ";
        exportation();
        affichage_grille('V');
}
1;

#* Copyright (C) 2006 Christian Guine
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
# saisie1.pm treatement of seized modifications
#               function = "S" ==> solution
#               function = "R" ==> résolution
#               function = "C" ==> grid creation
#               function = "T" ==> seizure of  grid
#               function = "V" ==> seizure of solution
sub saisie1 {
        use Games::Sudoku::sudokuprincipal;
        #print "saisie1 trait= " . $trait . "\n";
        $erreur_saisie = 0;
        $#wprecarre = -1;
        # Save of context
        for ($i = 0; $i < 9; $i++) {                
                for ($j = 0; $j < 9; $j++) {
                        for ($k = 0; $k < 9; $k++) {
                                $wprecarre[$i][$j][$k] = $precarre[$i][$j][$k];
                        }
                }
        }
        
        for ($i = 0; $i < 9; $i++) {                
                for ($j = 0; $j < 9; $j++) {
                        my $trouve = "0";
                        for (my $k1 = 0; $k1 < 9; $k1++) { 
                                # we seek if a box is found 
                                #print " s " . $wprecarre[$i][$j][$k1];
                                if ($wprecarre[$i][$j][$k1] ne "P" 
                                        and $wprecarre[$i][$j][$k1] ne " "
                                        ) {
                                        $trouve = "1";
                                }
                        }
                        if ($trouve eq "0") {   # if not found
                                if ($trait eq "T" or $trait eq "V") { # seizure
                                        my $b = $entrycarre[$i][$j][0]->Entry;
                                        $valeurw = $entrycarre[$i][$j][0]->get;
                                        # delete spaces beginning and end
                                        $valeurw =~ s/^\s+//;
                                        #print " g " . $valeurw;
                                        if ($valeurw > 0 and $valeurw < 10) {      # There is a seizure 
                                                #print "valeur " . $valeurw . "\n";
                                                $erreur_aide = 0;
                                                if ($aide == 1) {
                                                        if ($precarres[$i][$j][$valeurw - 1] ne "C") {
                                                                $erreur_aide = 1;
                                                                for (my $k1 = 0; $k1 < 9; $k1++) {
                                                                if ($precarres[$i][$j][$k1] ne " " and
                                                                        $precarres[$i][$j][$k1] ne "P") 
                                                                        {
                                                                        $bonnevaleur = $k1 + 1;
                                                                        #print "valeur " . $bonnevaleur;
                                                                        last;
                                                                }
                                                                }
                                                        }
                                                }
                                                if (($precarre[$i][$j][$valeurw - 1] ne "P")
                                                        or $erreur_aide == 1) {
                                                        $erreur_saisie = 1;
                                                } else {
                                                        if ($trait eq "V") {     # we are seizing
                                                                                # a solution
                                                                $precarre[$i][$j][$valeurw - 1] = "C";
                                                                $entree = "C";
                                                        } else {        # we are seising a problem 
                                                                $precarre[$i][$j][$valeurw - 1] = "S";
                                                                $entree = "S";
                                                        }
                                                        $ligne = $i;
                                                        $colonne = $j;
                                                        $valeur = $valeurw - 1;
                                                        $endroit = "";
                                                        modif_tableau($entree);
                                                }
                                        }
                                } else {   # we are not seizing
                                        for ($k = 0; $k < 9; $k++) {
                                                #print "i= " . $i . " j= " . $j . " k= " . $k . "\n";
                                                if (exists ($entrycarre[$i][$j][$k])) {
                                                        my $b = $entrycarre[$i][$j][$k]->Entry;
                                                        $valeurw = $entrycarre[$i][$j][$k]->get;
                                                        # delete spaces beginning and end 
                                                        $valeurw =~ s/^\s+//;
                                                        #print " e " . $valeurw;
                                                        if ($wprecarre[$i][$j][$k] eq "P") {
                                                                $wcarre = $k + 1;
                                                        } else {
                                                                $wcarre = " ";
                                                        } 
                                        #print "saisie1 valeurw " . $valeurw . " ijk=" . $i . $j . $k
                                        #. " precarre=" . $wprecarre[$i][$j][$k]
                                        #. " precarre+1=" . $wprecarre[$i][$j][$k + 1]
                                        #;
                                                        if ($valeurw != $wcarre) {
                                                #print (" modif i= " . $i . " j= " . $j . " k= " . $k );
                                                                $precarre[$i][$j][$k] = "S";
                                                                $ligne = $i;
                                                                $colonne = $j;
                                                                $valeur = $k;
                                                                $entree = "S";
                                                                $endroit = "";
                                                                modif_tableau($entree);
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }
        #print "fin saisie1 $erreur_saisie\n";
        if ($trait eq "T") {
                affichage_grille('T');
        } elsif ($trait eq "V") {
                #verif_fin();
                affichage_grille('V');
        } else {
                solution();
        }
}
1;

#* Copyright (C) 2006 Christian Guine
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
# sudokuprincipal.pm 
# to resolve Sudoku in few seconds
sub sudokuprincipal {

}
1;

sub traitement {                    # treatment of seizure   
solution();
exportation();
verif_seul();                       # we indicate if a number remains alone after calculation
$final = 0;
while ($final == 0) {
        cherche_seul();             # we seek if a number can be alone in line column or area
}
$final = 0;
while ($final == 0) {
        cherche_sequence();         # we seek if a number is surely that which misses
}                                   # in its line column or area
verif_fin();                        # we check if all is found
print $trait . "\n";

affichage_grille('F');
}

sub fin_saisie {
        $traitexport = " ";
        exportation();
        $trait = "N";
        solution();
        $traitexport = "S";
        exportation();
        $trait = "V";
        $fin = 0;
        $traitexport = " ";
        importation();
        saisie1();
}

sub saisie2 {
        #print "saisie2 trait= " . $trait . "\n";
        $erreur_saisie = 0;
        if ($trait eq "V") {
                fin_saisie();
        } else {
                saisie1();
        }
}

sub verif {
        verif_fin();                        # we verifie if all is found
        if ($fin != 1) {
                importation();
                affichage_grille('T');
        } else {
                affichage_grille('F');
        }                       
}

sub solutiond {
        $trait = "S";
        solution();
}

sub solution {                              # Posting solution
        if ($trait eq "V") {
                importation('W');           # backup of initial grid
        }
        if ($trait eq "S") {
                importation('S');
        }
        verif_seul();                       # we indicate if a number is alone
        $final = 0;
        while ($final == 0) {
                cherche_seul();             # we check if a number can be alone in a line column or area
        }
        $final = 0;
        while ($final == 0) {
                cherche_sequence();         # we seek if a number is surely that which misses
                                            # in its line column or area
        }                                  
        verif_fin();                        # we verify that all is found
        if ($trait ne "N") {
                affichage_grille('F');
        }
}

sub verif_fin                   #Checking that all is found
{
        $fin = 1;
        for ($i = 0; $i < 9; $i++) {
                for ($j = 0; $j < 9; $j++) {
                        for ($k = 0; $k < 9; $k++) {
                                if ($precarre[$i][$j][$k] eq "P") {
                                        $fin = 0;
                                }
                        }
                }
        }
}

sub cherche_sequence         # we seek if a number is surely that which misses 
                             # in its line column or area
{
        # not implemented not useless
        #print "cherche_sequence\n";
        $final = 1;

}

sub cherche_seul
{
        #print "cherche_seul\n";
        $final = 1;
        for ($i = 0; $i < 9; $i++) {
                for ($j = 0; $j < 9; $j++) {
                        for ($k = 0; $k < 9; $k++) {
                                if ($precarre[$i][$j][$k] eq "P") {  # we find a number
                                        # we check that it is not the only possible one in the line
                                        # column or area
                                        # checking on the column
                                        $trouve = 0;
                                        for ($wj = 0; $wj < 9; $wj++) {
                                                if ($precarre[$i][$wj][$k] eq "P") {
                                                        $trouve++;
                                                }
                                        }
                                        if ($trouve == 1) {     
                                                $ligne = $i;
                                                $colonne = $j;
                                                $valeur = $k;
                                                $entree = "C";
                                                $endroit = "colonne";
                                                modif_tableau();
                                                $final = 0;
                                        }
                                        # checking line
                                        $trouve = 0;
                                        for ($wi = 0; $wi < 9; $wi++) {
                                                if ($precarre[$wi][$j][$k] eq "P") {
                                                        $trouve++;
                                                }
                                        }
                                        if ($trouve == 1) {
                                                $ligne = $i;
                                                $colonne = $j;
                                                $valeur = $k;
                                                $entree = "C";
                                                $endroit = "ligne";
                                                modif_tableau();
                                                $final = 0;
                                        }
                                        # checking area
                                        $trouve = 0;
                                        if ($i < 3) {
                                                $wimax = 3;
                                                $wimin = 0;
                                        } elsif ($i < 6) {
                                                $wimax = 6;
                                                $wimin = 3;
                                        } else {
                                                $wimax = 9;
                                                $wimin = 6;
                                        }
                                        if ($j < 3) {
                                                $wjmax = 3;
                                                $wjmin = 0;
                                        } elsif ($j < 6) {
                                                $wjmax = 6;
                                                $wjmin = 3;
                                        } else {
                                                $wjmax = 9;
                                                $wjmin = 6;
                                        }
                                        for ($wi = $wimin; $wi < $wimax; $wi++) {
                                                for ($wj = $wjmin; $wj < $wjmax; $wj++) {
                                                        if ($precarre[$wi][$wj][$k] eq "P") {
                                                                $trouve++;
                                                        }
                                                }
                                        }
                                        if ($trouve == 1) {
                                                $ligne = $i;
                                                $colonne = $j;
                                                $valeur = $k;
                                                $entree = "C";
                                                $endroit = "carre";
                                                modif_tableau();
                                                $final = 0;
                                        }
                                }
                        }
                }
        }
}

sub verif_seul                  # we verify that the number found is the only one in the box
{
        #print "verif_seul\n";
        for ($i = 0; $i < 9; $i++) {
                for ($j = 0; $j < 9; $j++) {
                        $seul = 0;
                        for ($k = 0; $k < 9; $k++) {
                                if ($precarre[$i][$j][$k] eq "P") {
                                        $seul++;
                                }
                        }
                        if ($seul == 1) {
                                for ($k = 0; $k < 9; $k++) {
                                        if ($precarre[$i][$j][$k] eq "P") {
                                                $ligne = $i;
                                                $colonne = $j;
                                                $valeur = $k;
                                                $entree = "C";
                                                $endroit = "";
                                                modif_tableau();
                                                $final = 0;
                                        }
                                }
                        }
                }
        }          
}

sub modif_tableau                       # If a number is found we cancel the possibility 
                                        #       of this number on the same line, the same column
                                        #       and the same area
{
        #print "modif_tableau " . $entree . " endroit " . $endroit . " ligne " . ($ligne + 1) 
         #       . " colonne " . ($colonne + 1) . " valeur " . ($valeur + 1) . "\n";
        $precarre[$ligne][$colonne][$valeur] = $entree;            # S pour seizure C for calculated
        #print "i= " . $i . " j= " . $j . " k= " . $k;
        #for (my $w1k = 0; $w1k < 9; $w1k++) {
                #print "mod0|" . $wprecarre[$i][$j][$w1k] . "|";
        #}
        for ($wwi = 0; $wwi < 9; $wwi++) {       # delete line
                if ($precarre[$wwi][$colonne][$valeur] eq "P") {
                        $precarre[$wwi][$colonne][$valeur] = " ";
                }
        }
        #for (my $w1k = 0; $w1k < 9; $w1k++) {
                #print "mod1|" . $wprecarre[$i][$j][$w1k] . "|";
        #}
        for ($wwj = 0; $wwj < 9; $wwj++) {       # delete column
                if ($precarre[$ligne][$wwj][$valeur] eq "P") {
                        $precarre[$ligne][$wwj][$valeur] = " ";
                }
        }
        for (my $w1k = 0; $w1k < 9; $w1k++) {
                #print "mod2|" . $wprecarre[$i][$j][$w1k] . "|";
        }
        for ($wwk = 0; $wwk < 9; $wwk++) {       # delete area
                if ($precarre[$ligne][$colonne][$wwk] eq "P") {
                        $precarre[$ligne][$colonne][$wwk] = " ";
                }
        }
        #for (my $w1k = 0; $w1k < 9; $w1k++) {
                #print "mod3|" . $wprecarre[$i][$j][$w1k] . "|";
        #}
        # delete possibility on an area
        if ($ligne < 3) {
                $wimax = 3;
                $wimin = 0;
        } elsif ($ligne < 6) {
                $wimax = 6;
                $wimin = 3;
        } else {
                $wimax = 9;
                $wimin = 6;
        }
        if ($colonne < 3) {
                $wjmax = 3;
                $wjmin = 0;
        } elsif ($colonne < 6) {
                $wjmax = 6;
                $wjmin = 3;
        } else {
                $wjmax = 9;
                $wjmin = 6;
        }
        for ($wwi = $wimin; $wwi < $wimax; $wwi++) {
                for ($wwj = $wjmin; $wwj < $wjmax; $wwj++) {
                        if ($precarre[$wwi][$wwj][$valeur] eq "P") {
                                $precarre[$wwi][$wwj][$valeur] = " ";
                        }
                }
        }
}

sub importations
{
        use IO::File;
        $filehandle = new IO::File;
        my $retour = $filehandle->open("< sudokus.txt") 
                or die "impossible ouvrir sudokus importations";  
        $#precarres = -1;
        for (my $i = 0; $i < 9; $i++) {
                for (my $j = 0; $j < 9; $j++) {
                        for (my $k = 0; $k < 9; $k++) {
                                $filehandle->read($newtext,1);
                                $val = $k + 1;
                                $carre[$i][$j][$k] = $val;
                                $precarres[$i][$j][$k] = $newtext;
                        }
                }
        }
        $filehandle->close;       
}

sub importation                 #importation data from a file
{         
        use IO::File;
        #use File::Copy;
        $#precarre = -1;
        my ($traitexport) = @_;
        #print "importation " . $traitexport . "\n";
        $filehandle = new IO::File;
        if ($traitexport eq "W") {                   
                my $retour = $filehandle->open("< sudokuw.txt");
                if ($retour != 1) {
                        $filesortie = new IO::File;
                        $filesortie->open("> sudokuw.txt") or die "impossible ouvrir sortie sudokuw";
                        $filesortie->write(" ", 1);
                        $filesortie->close;
                }
                $filehandle->close;
                $filehandle->open("< sudokuw.txt") or die "impossible d'ouvrir fichier sudokuw";  
        } elsif ($traitexport eq "S") {
                 my $retour = $filehandle->open("< sudokus.txt") or die "impossible ouvrir sudokus";     
        } else {
                my $retour = $filehandle->open("< sudoku.txt");
                if ($retour != 1) {
                        $filesortie = new IO::File;
                        $filesortie->open("> sudoku.txt") or die "impossible ouvrir sortie sudokuw";
                        $filesortie->write(" ", 1);
                        $filesortie->close;
                }
                $filehandle->close;
                $filehandle->open("< sudoku.txt") or die "impossible d'ouvrir fichier";
        }
        @carre = 0;
        $#precarre = -1;
        for ($i = 0; $i < 9; $i++) {
                for ($j = 0; $j < 9; $j++) {
                        for ($k = 0; $k < 9; $k++) {
                                $filehandle->read($newtext,1);
                                $val = $k + 1;
                                $carre[$i][$j][$k] = $val;
                                $precarre[$i][$j][$k] = $newtext;
                        }
                }
        }
        $filehandle->close;       
}

sub sauve
{
        $traitexport = " ";
        exportation();
}

sub exportation {
        use IO::File;
        #use File::Copy;
        #$trait = @_;
        #print "exportation trait " . $traitexport . " cpt1= " . $cpt1 . "\n";
        $filesortie = new IO::File;
        if ($traitexport eq "W") {                
                $filesortie->open("> sudokuw.txt") or die "impossible ouvrir sortie sudokuw";
        } elsif ($traitexport eq "S") {
                        $filesortie->open("> sudokus.txt") or die "impossible ouvrir sortie sudokus";
        } else {
                my $retour = $filesortie->open("> sudoku.txt");
                $filesortie->open("> sudoku.txt") or die "impossible ouvrir sortie ";
        }
        if ($traitexport eq "S") {
                $#enmoins = -1;                #init table
                if ($difficulte != 0) {
                        if ($difficulte >= 1) {
                                push (@enmoins, (int(rand ($cpt1) + 1)));
                        } 
                        if ($difficulte == 2) {
                                push (@enmoins, (int(rand ($cpt1) + 1)));
                        }
                }
                #print "enmoins ";
                #for $wi (0 .. $#enmoins) {
                 #       print " " . $enmoins[$wi];
                #}
                #print "\n";
        }
        $cpt2 = 0;
        for ($i = 0; $i < 9; $i++) {
                for ($j = 0; $j < 9; $j++) {
                        for ($k = 0; $k < 9; $k++) {
                                $text = $precarre[$i][$j][$k];
                                $filesortie->write($text, 1);
                                #if ($traitexport eq "S" and $enleve == 1
                                 #       and $precarre[$i][$j][$k] eq "S") {        
                                  #      $cpt2++;
                                   #     for $wi (0 .. $#enmoins) {
                                                #print $wi . " " . $cpt2 . "\n";
                                    #            if ($cpt2 eq $enmoins[$wi]) {
                                     #                   if ($traitexport eq "W") {
                                      #                          $precarre[$i][$j][$k] = "P";
                                       #                 } elsif ($traitexport eq "S") {
                                        #                        $precarre[$i][$j][$k] = "P";
                                         #                       retour_arriere();
                                          #              }
                                           #             print "enleve " . $cpt2 . " i= " . ($i + 1) 
                                            #              . " j= " . ($j + 1) . " k= " 
                                             #             . ($k + 1) . "\n";
                                              #  }
                                        #}
                                #}
                        }
                }
        }
        $filesortie->close; 
        #$enleve = 0;            
}

sub exportationb {
        use IO::File;
        $filesortie = new IO::File;
        $filesortie->open("> sudoku3.txt") or die "impossible ouvrir sortie sudoku3";
        $filehandle = new IO::File;                
        my $retour = $filehandle->open("< sudoku2.txt");
        if ($retour == 1) {
                for (my $is = 0; $is < 9; $is++) {
                        for (my $js = 0; $js < 9; $js++) {
                                for (my $ks = 0; $ks < 9; $ks++) {
                                        $filehandle->read($text,1);
                                        $filesortie->write($text, 1);      
                                }
                        }
                }
                $filehandle->close;
        }
        $filesortie->close;
        $filesortie = new IO::File;
        $filesortie->open("> sudoku2.txt") or die "impossible ouvrir sortie sudoku2";
        $filehandle = new IO::File;                
        my $retour = $filehandle->open("< sudoku1.txt");
        if ($retour == 1) {
                for (my $is = 0; $is < 9; $is++) {
                        for (my $js = 0; $js < 9; $js++) {
                                for (my $ks = 0; $ks < 9; $ks++) {
                                        $filehandle->read($text,1);
                                        $filesortie->write($text, 1);      
                                }
                        }
                }
                $filehandle->close;
        }
        $filesortie->close;
        $filesortie = new IO::File;
        $filesortie->open("> sudoku1.txt") or die "impossible ouvrir sortie sudoku2";
        for (my $is = 0; $is < 9; $is++) {
                for (my $js = 0; $js < 9; $js++) {
                        for (my $ks = 0; $ks < 9; $ks++) {
                                $text = $precarre[$is][$js][$ks];
                                $filesortie->write($text, 1);      
                        }
                }
        }
        $filesortie->close;                           
}

sub init_tableau {
        # initialization table
        for ($i = 0; $i < 9; $i++) {                # init lines
                for ($j = 0; $j < 9; $j++) {        # init columns
                        for ($k = 0; $k < 9; $k++) { # init areas
                                $val = $k + 1;
                                $carre[$i][$j][$k] = $val;
                                $precarre[$i][$j][$k] = "P"; #P for possible
                        }
                }
        }
}
 
sub retour_arriere {
        use IO::File;
        $filehandle = new IO::File;
        if ($difficulte != 0) {
                if ($difficulte == 1) {
                        $filehandle->open("< sudoku2.txt") 
                                or die "impossible ouvrir sortie sudoku1";
                } elsif ($difficulte == 2) {
                        $filehandle->open("< sudoku3.txt") 
                                or die "impossible ouvrir sortie sudoku2";
                }
                for (my $is = 0; $is < 9; $is++) {                
                        for (my $js = 0; $js < 9; $js++) {        
                                for (my $ks = 0; $ks < 9; $ks++) { 
                                $filehandle->read($text,1);
                                $precarre[$i][$j][$k] = $text;
                                }
                        }
                }
        }
        $filehandle->close;               
}               


#* Copyright (C) 2006 Christian Guine
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
# file of configuration tr1.pm
sub tr1 {
        use IO::File;
        if ($langue eq "") {
                # reading language in file conf.txt
                $filehandle = new IO::File; 
                my $retour = $filehandle->open("< conf.txt");
                if ($retour != 1) {
                        $langue = "en";
                        $filesortie = new IO::File;
                        $filesortie->open("> conf.txt") or die "impossible ouvrir conf";
                        $filesortie->write($langue, 2);
                        $filesortie->close; 
                }
                $filehandle->open("< conf.txt") or die "impossible d'ouvrir fichier sudokuw"; 
                $filehandle->read($langue,2);
                $filehandle->close;        
        }
        #print $langue . "\n";
        my ($nomfr) = @_;
        if ($langue ne "fr") {
                $nomtr = traduction($langue,$nomfr);
        } else {
                $nomtr = $nomfr;
        }
        #print $langue . " " . $nomfr . " " . $nomtr . "\n";
        return $nomtr;
}
1;

sub changelang {               # modification language in file conf.txt
        use IO::File; 
        ($langue) = @_;
        $filesortie = new IO::File;
        $filesortie->open("> conf.txt") or die "impossible ouvrir conf";
        $filesortie->write($langue, 2);
        $filesortie->close;
        menu('affichgrille');
        affichage_grille($trait);
}

sub traduction {                # translation
       @tab =  ("en", "OUI", "YES",
                "en", "NON", "NO",
                "en", "FIN SAISIE", "END OF SEIZURE",
                "en", "Est ce une nouvelle grille? oui/non", "Is it a new grid? yes/no",
                "en", "Tout n\'est pas réglé", "It is not enturely resolved",
                "en", "Supprimer le chiffre choisi", "Delete the selected number",
                "en", "Erreur de saisie", "Error of seizure",
                "en", "Erreur", "Error",
                "en", "Tout n\'est pas trouvé", "Solution is not complete",
                "en", "Saisir chiffres", "Type numbers",
                "en", "Bravo", "Cheer!",
                "en", "Tout est réglé", "Enturely resolved",
                "en", "Fichier", "File",
                "en", "Sauver", "Save",
                "en", "Quitter", "Exit",
                "en", "Options", "Options",
                "en", "Resoudre une grille saisie", "Do you want to solve an old grid",
                "en", "Demander une nouvelle grille", "Create a new grid",
                "en", "Creer une grille", "Build a grid",
                "en", "Solution", "Solution",
                "en", "Langues", "Language",
                "en", "français", "french",
                "en", "anglais", "english",
                "en", "allemand", "german",
                "en", "espagnol", "spanish",
                "en", "Quelle difficulté?", "Wich difficulty?",
                "en", "Facile", "Easy",
                "en", "Difficile", "Difficult",
                "en", "Très difficile", "Very difficult",
                "en", "Aide?","Help?",
                "ge", "OUI", "YA",
                "ge", "NON", "NEIN",
                "ge", "FIN SAISIE", "ERFASSUNGSENDE",
                "ge", "Est ce une nouvelle grille? oui/non", "Ist dieses neue Gitter? ya/nein",
                "ge", "Tout n\'est pas réglé", "Alles wird nicht reguliert",
                "ge", "Supprimer le chiffre choisi", "Die ausgewählte Zahl abschaffen",
                "ge", "Erreur de saisie", "Erfassungsfehler",
                "ge", "Erreur", "Fehler",
                "ge", "Tout n\'est pas trouvé", "Alles wird nicht gefunden",
                "ge", "Saisir chiffres", "Zahlen erfassen",
                "ge", "Bravo", "Bravo!",
                "ge", "Tout est réglé", "Alles gefunden wird",
                "ge", "Fichier", "Kartei",
                "ge", "Sauver", "Retten",
                "ge", "Quitter", "Exit",
                "ge", "Options", "Optionen",
                "ge", "Resoudre une grille saisie", "Ein Gitter lösen",
                "ge", "Demander une nouvelle grille", "Ein neue Gitter?",
                "ge", "Creer une grille", "Ein Gitter schaffen",
                "ge", "Solution", "Lösung",
                "ge", "Langues", "Sprachen",
                "ge", "français", "franzose",
                "ge", "anglais", "Engländer",
                "ge", "allemand", "deutsch",
                "ge", "espagnol", "spanish",
                "ge", "Quelle difficulté?", "Welche Schwierigkeit",
                "ge", "Facile", "Einfach",
                "ge", "Difficile", "Schwierig",
                "ge", "Très difficile", "Sehr schwierig",
                "ge", "Aide?","Helfen?",
                "sp", "OUI", "SI",
                "sp", "NON", "NO",
                "sp", "FIN SAISIE", "FINAL DE INTRODUCCION",
                "sp", "Est ce une nouvelle grille? oui/non", "?Es la esta nueva rejilla? si/no",
                "sp", "Tout n\'est pas réglé", "No se regula todo",
                "sp", "Supprimer le chiffre choisi", "Suprimir la cifra elegida",
                "sp", "Erreur de saisie", "Error de introducciõn",
                "sp", "Erreur", "Error",
                "sp", "Tout n\'est pas trouvé", "No se encuentra todo",
                "sp", "Saisir chiffres", "Coger cifras",
                "sp", "Bravo", "Bravo!",
                "sp", "Tout est réglé", "Todo se encuentra",
                "sp", "Fichier", "Fichero",
                "sp", "Sauver", "Salvar",
                "sp", "Quitter", "Exit",
                "sp", "Options", "Opciones",
                "sp", "Resoudre une grille saisie", "Solucionar una rejilla",
                "sp", "Demander une nouvelle grille", "Pedir una nueva rejilla",
                "sp", "Creer une grille", "Crear una rejilla",
                "sp", "Solution", "Soluciõn",
                "sp", "Langues", "Lenguas",
                "sp", "français", "frencés",
                "sp", "anglais", "Inglés",
                "sp", "allemand", "alemãn",
                "sp", "espagnol", "español",
                "sp", "Quelle difficulté?", "?Qué dificultad",
                "sp", "Facile", "facil",
                "sp", "Difficile", "dificil",
                "sp", "Très difficile", "muy dificil",
                "sp", "Aide?","?ayuda",
                "it", "OUI", "SI",
                "it", "NON", "NO",
                "it", "FIN SAISIE", "FINE DI BATTITURA",
                "it", "Est ce une nouvelle grille? oui/non", "E una questa nuova griglia? si/no",
                "it", "Tout n\'est pas réglé", "Tutto non è regolato",
                "it", "Supprimer le chiffre choisi", "Eliminare la cifra scelta",
                "it", "Erreur de saisie", "Errore di battitura",
                "it", "Erreur", "Errore",
                "it", "Tout n\'est pas trouvé", "Tutto non è trovato",
                "it", "Saisir chiffres", "Osservare cifre",
                "it", "Bravo", "Bravo!",
                "it", "Tout est réglé", "Tutto è trovato",
                "it", "Fichier", "Archivio",
                "it", "Sauver", "Salvare",
                "it", "Quitter", "Exit",
                "it", "Options", "Opzione",
                "it", "Resoudre une grille saisie", "Risolvere una griglia",
                "it", "Demander une nouvelle grille", "Chidere una nuova grilia",
                "it", "Creer une grille", "Creare una griglia",
                "it", "Solution", "Soluzione",
                "it", "Langues", "Lingue",
                "it", "français", "francese",
                "it", "anglais", "inglese",
                "it", "allemand", "tedesco",
                "it", "espagnol", "spagnolo",
                "it", "Quelle difficulté?", "Quale difficoltà?",
                "it", "Facile", "Facile",
                "it", "Difficile", "Difficile",
                "it", "Très difficile", "Molto difficile",
                "it", "Aide?","Aiuto?",
                "pt", "OUI", "SIM",
                "pt", "NON", "NAO",
                "pt", "FIN SAISIE", "FIM DE APREENSAO",
                "pt", "Est ce une nouvelle grille? oui/non", "E esta nova grelha? sim/não",
                "pt", "Tout n\'est pas réglé", "Todo não é regulado",
                "pt", "Supprimer le chiffre choisi", "Suprimir o numero escolhido",
                "pt", "Erreur de saisie", "Erro de apreensão",
                "pt", "Erreur", "Erro",
                "pt", "Tout n\'est pas trouvé", "Todo não é encontrado",
                "pt", "Saisir chiffres", "Apreender numeros",
                "pt", "Bravo", "Bravo!",
                "pt", "Tout est réglé", "Qualquer é encontrado",
                "pt", "Fichier", "Fichero",
                "pt", "Sauver", "Salvar",
                "pt", "Quitter", "Exit",
                "pt", "Options", "Opções",
                "pt", "Resoudre une grille saisie", "Resolver uma grelha",
                "pt", "Demander une nouvelle grille", "Pedir uma nova grelha",
                "pt", "Creer une grille", "Criar uma grelha",
                "pt", "Solution", "Solução",
                "pt", "Langues", "Linguas",
                "pt", "français", "francês",
                "pt", "anglais", "inglês",
                "pt", "allemand", "alemão",
                "pt", "espagnol", "espanhol",
                "pt", "Quelle difficulté?", "qual dificulda",
                "pt", "Facile", "facil",
                "pt", "Difficile", "dificil",
                "pt", "Très difficile", "muito dificil",
                "pt", "Aide?","ayuda?"
                );
        my ($langue,$nomfr) = @_;
        #print $langue . " " . $nomfr;
        $nomtr = $nomfr;
        #print "maxi " . $#tab . "\n";
        for (my $it = 0; $it <= $#tab; $it = $it + 3) {
                #print " i= " . $i;
                if ($tab[$it] eq $langue and $tab[$it + 1] eq $nomfr) {
                        $nomtr = $tab[$it + 2];
                        last;
                }
                #print "tab nomfr" . $tab[$it + 1] . " i= " . $it . "\n";
        }
        #print $nomtr . "\n";
        return($nomtr);
}
               
        

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Games::Sudoku::SudokuTk - Perl extension for Sudoku with Tk

=head1 SYNOPSIS

  use Games::Sudoku::SudokuTk;
 

=head1 DESCRIPTION

Game Sudoku with Tk

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Christian Guine, E<lt>c.guine@free.frE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Christian Guine

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut