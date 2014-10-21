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
        #print ("trait $trait origine $origine|\n");
        ($langue) = @_;
        $filesortie = new IO::File;
        $filesortie->open("> conf.txt") or die "impossible ouvrir conf";
        $filesortie->write($langue, 2);
        $filesortie->close;
        if ($trait ne "sudoku") {
                menu($trait);
                affichage_grille($trait);
        } else {
                $main->destroy;
                sudoku();
        }
}

sub traduction {                # translation
       @tab =  ("en", "OUI", "YES",
                "en", "NON", "NO",
                "en", "FIN SAISIE", "END OF SEIZURE",
                "en", "Est ce une nouvelle grille? oui/non", "Is it a new grid? yes/no",
                "en", "Tout n\'est pas r�gl�", "It is not enturely resolved",
                "en", "Supprimer le chiffre choisi", "Delete the selected number",
                "en", "Erreur de saisie", "Error of seizure",
                "en", "Erreur", "Error",
                "en", "Tout n\'est pas trouv�", "Solution is not complete",
                "en", "Saisir chiffres", "Type numbers",
                "en", "Faux la bonne valeur est ","False the right value is ",
                "en", "Bravo", "Cheer!",
                "en", "Tout est r�gl�", "Enturely resolved",
                "en", "Fichier", "File",
                "en", "Sauver", "Save",
                "en", "Quitter", "Exit",
                "en", "Options", "Options",
                "en", "Resoudre une grille saisie", "Do you want to solve an old grid",
                "en", "Demander une nouvelle grille", "Create a new grid",
                "en", "Creer une grille", "Build a grid",
                "en", "Solution", "Solution",
                "en", "Langues", "Language",
                "en", "fran�ais", "french",
                "en", "anglais", "english",
                "en", "allemand", "german",
                "en", "espagnol", "spanish",
                "en", "Quelle difficult�?", "Which difficulty?",
                "en", "Facile", "Easy",
                "en", "Difficile", "Difficult",
                "en", "Tr�s difficile", "Very difficult",
                "en", "Aide?","Help?",
                "en", "Enfant","Child",
                "en", "chiffres","numbers",
                "en", "animaux","animals",
                "en", "Choisir dessin","Choose drawings",
                "en", "Annulation","Cancellation",
                "ge", "OUI", "YA",
                "ge", "NON", "NEIN",
                "ge", "FIN SAISIE", "ERFASSUNGSENDE",
                "ge", "Est ce une nouvelle grille? oui/non", "Ist dieses neue Gitter? ya/nein",
                "ge", "Tout n\'est pas r�gl�", "Alles wird nicht reguliert",
                "ge", "Supprimer le chiffre choisi", "Die ausgew�hlte Zahl abschaffen",
                "ge", "Erreur de saisie", "Erfassungsfehler",
                "ge", "Erreur", "Fehler",
                "ge", "Tout n\'est pas trouv�", "Alles wird nicht gefunden",
                "ge", "Saisir chiffres", "Zahlen erfassen",
                "ge", "Bravo", "Bravo!",
                "ge", "Tout est r�gl�", "Alles gefunden wird",
                "ge", "Faux la bonne valeur est ","Unwahrheit der gute Wert ist ",
                "ge", "Fichier", "Kartei",
                "ge", "Sauver", "Retten",
                "ge", "Quitter", "Exit",
                "ge", "Options", "Optionen",
                "ge", "Resoudre une grille saisie", "Ein Gitter l�sen",
                "ge", "Demander une nouvelle grille", "Ein neue Gitter?",
                "ge", "Creer une grille", "Ein Gitter schaffen",
                "ge", "Solution", "L�sung",
                "ge", "Langues", "Sprachen",
                "ge", "fran�ais", "franzose",
                "ge", "anglais", "Engl�nder",
                "ge", "allemand", "deutsch",
                "ge", "espagnol", "spanish",
                "ge", "Quelle difficult�?", "Welche Schwierigkeit",
                "ge", "Facile", "Einfach",
                "ge", "Difficile", "Schwierig",
                "ge", "Tr�s difficile", "Sehr schwierig",
                "ge", "Aide?","Helfen?",
                "ge", "Enfant","Kinder",
                "ge", "chiffres","Zahlen",
                "ge", "animaux","Tiere",
                "ge", "Choisir dessin","Zeichnung w�hlen",
                "ge", "Annulation","Annullierung",
                "sp", "OUI", "SI",
                "sp", "NON", "NO",
                "sp", "FIN SAISIE", "FINAL DE INTRODUCCION",
                "sp", "Est ce une nouvelle grille? oui/non", "?Es la esta nueva rejilla? si/no",
                "sp", "Tout n\'est pas r�gl�", "No se regula todo",
                "sp", "Supprimer le chiffre choisi", "Suprimir la cifra elegida",
                "sp", "Erreur de saisie", "Error de introducci�n",
                "sp", "Erreur", "Error",
                "sp", "Tout n\'est pas trouv�", "No se encuentra todo",
                "sp", "Saisir chiffres", "Coger cifras",
                "sp", "Bravo", "Bravo!",
                "sp", "Tout est r�gl�", "Todo se encuentra",
                "sp", "Faux la bonne valeur est ","Falsificaci�n el buen valor es ",
                "sp", "Fichier", "Fichero",
                "sp", "Sauver", "Salvar",
                "sp", "Quitter", "Exit",
                "sp", "Options", "Opciones",
                "sp", "Resoudre une grille saisie", "Solucionar una rejilla",
                "sp", "Demander une nouvelle grille", "Pedir una nueva rejilla",
                "sp", "Creer une grille", "Crear una rejilla",
                "sp", "Solution", "Soluci�n",
                "sp", "Langues", "Lenguas",
                "sp", "fran�ais", "frenc�s",
                "sp", "anglais", "Ingl�s",
                "sp", "allemand", "alem�n",
                "sp", "espagnol", "espa�ol",
                "sp", "Quelle difficult�?", "?Qu� dificultad",
                "sp", "Facile", "facil",
                "sp", "Difficile", "dificil",
                "sp", "Tr�s difficile", "muy dificil",
                "sp", "Aide?","?ayuda",
                "sp", "Enfant","Ni�o",
                "sp", "chiffres","cifras",
                "sp", "animaux","animales",
                "sp", "Choisir dessin","Escoger dibujo",
                "sp", "Annulation","Anulaci�n",
                "it", "OUI", "SI",
                "it", "NON", "NO",
                "it", "FIN SAISIE", "FINE DI BATTITURA",
                "it", "Est ce une nouvelle grille? oui/non", "E una questa nuova griglia? si/no",
                "it", "Tout n\'est pas r�gl�", "Tutto non � regolato",
                "it", "Supprimer le chiffre choisi", "Eliminare la cifra scelta",
                "it", "Erreur de saisie", "Errore di battitura",
                "it", "Erreur", "Errore",
                "it", "Tout n\'est pas trouv�", "Tutto non � trovato",
                "it", "Saisir chiffres", "Osservare cifre",
                "it", "Bravo", "Bravo!",
                "it", "Tout est r�gl�", "Tutto � trovato",
                "it", "Faux la bonne valeur est ","Falsificazione il buon valore � ",
                "it", "Fichier", "Archivio",
                "it", "Sauver", "Salvare",
                "it", "Quitter", "Exit",
                "it", "Options", "Opzione",
                "it", "Resoudre une grille saisie", "Risolvere una griglia",
                "it", "Demander une nouvelle grille", "Chidere una nuova grilia",
                "it", "Creer une grille", "Creare una griglia",
                "it", "Solution", "Soluzione",
                "it", "Langues", "Lingue",
                "it", "fran�ais", "francese",
                "it", "anglais", "inglese",
                "it", "allemand", "tedesco",
                "it", "espagnol", "spagnolo",
                "it", "Quelle difficult�?", "Quale difficolt�?",
                "it", "Facile", "Facile",
                "it", "Difficile", "Difficile",
                "it", "Tr�s difficile", "Molto difficile",
                "it", "Aide?","Aiuto?",
                "it", "Enfant","Bambino",
                "it", "chiffres","numeri",
                "it", "animaux","animali",
                "it", "Choisir dessin","Scegliere disegno",
                "it", "Annulation","Annullamento",
                "pt", "OUI", "SIM",
                "pt", "NON", "NAO",
                "pt", "FIN SAISIE", "FIM DE APREENSAO",
                "pt", "Est ce une nouvelle grille? oui/non", "E esta nova grelha? sim/n�o",
                "pt", "Tout n\'est pas r�gl�", "Todo n�o � regulado",
                "pt", "Supprimer le chiffre choisi", "Suprimir o numero escolhido",
                "pt", "Erreur de saisie", "Erro de apreens�o",
                "pt", "Erreur", "Erro",
                "pt", "Tout n\'est pas trouv�", "Todo n�o � encontrado",
                "pt", "Faux la bonne valeur est ","Falsifica��o o valor bom � ",
                "pt", "Saisir chiffres", "Apreender numeros",
                "pt", "Bravo", "Bravo!",
                "pt", "Tout est r�gl�", "Qualquer � encontrado",
                "pt", "Fichier", "Fichero",
                "pt", "Sauver", "Salvar",
                "pt", "Quitter", "Exit",
                "pt", "Options", "Op��es",
                "pt", "Resoudre une grille saisie", "Resolver uma grelha",
                "pt", "Demander une nouvelle grille", "Pedir uma nova grelha",
                "pt", "Creer une grille", "Criar uma grelha",
                "pt", "Solution", "Solu��o",
                "pt", "Langues", "Linguas",
                "pt", "fran�ais", "franc�s",
                "pt", "anglais", "ingl�s",
                "pt", "allemand", "alem�o",
                "pt", "espagnol", "espanhol",
                "pt", "Quelle difficult�?", "qual dificulda",
                "pt", "Facile", "facil",
                "pt", "Difficile", "dificil",
                "pt", "Tr�s difficile", "muito dificil",
                "pt", "Aide?","ayuda?",
                "pt", "chiffres","n�meros",
                "pt", "animaux","animais",
                "pt", "Choisir dessin","Escolher desenho",
                "pt", "Annulation","Anula��o",
                "pt", "Enfant","crian�a"
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
        