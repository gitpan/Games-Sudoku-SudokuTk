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
                "en", "Saisir lettres", "Type letters",
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
                "en", "italien", "italian",
                "en", "portugais", "Portuguese",
                "en", "Quelle difficult�?", "Which difficulty?",
                "en", "Facile", "Easy",
                "en", "Difficile", "Difficult",
                "en", "Tr�s difficile", "Very difficult",
                "en", "Aide?","Help?",
                "en", "Enfant","Child",
                "en", "chiffres","numbers",
                "en", "animaux","animals",
                "en", "lettres","letters",
                "en", "couleurs","colors",
                "en", "Choisissez", "Choose",
                "en", "Choisir dessin","Choose drawings",
                "en", "Choisir couleurs", "Choose colors",
                "en", "Annulation","Cancellation",
                "en", "Simpliste","Simplistic",
                "en", "Ardu","Arduous",
                "en", "Grille 9x9 normale", "Normal Grid 9x9",
                "en", "Grille 6x6 facile", "Grid 6x6 easy",
                "en", "Grille 8x8 pas facile", "Grid 8x8 not easy",
                "en", "Grille 10x10 Difficile", "Grid 10x10 Difficult",
                "en", "Grille 12x12 Tr�s difficile", "Grid 12x12 very difficult",
                "en", "Grille 16x16 tr�s difficile", "Grid 16x16 very difficult",
                "en", "Grille 4x4 tr�s facile\navec dessins d'animaux\npar d�faut", "very easy grid 4x4\nwith animals\nby defect",
                "en", "Saisir une grille\npour la r�soudre", "To seize a grid\nto solve it",
                "en", "Cr�er une grille soi m�me", "Create a grid oneself",
                "en", "Il y a des chiffres\n dans les cases", "There are figures\nin the boxes",
                "en", "Il y a des lettres\n dans les cases", "There are letters\nin the boxes",
                "en", "Il y a des couleurs\n dans les cases", "There are colors\nin the boxes",
                "en", "Demander une nouvelle grille", "Ask for a new grid",
                "en", "Il y a des animaux\n dans les cases", "There are animals\n in the boxes",
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
                "ge", "Saisir lettres", "Briefe erfassen",
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
                "ge", "italien", "italienish",
                "ge", "portugais", "portugiesisch",
                "ge", "Quelle difficult�?", "Welche Schwierigkeit",
                "ge", "Facile", "Einfach",
                "ge", "Difficile", "Schwierig",
                "ge", "Tr�s difficile", "Sehr schwierig",
                "ge", "Aide?","Helfen?",
                "ge", "Enfant","Kinder",
                "ge", "chiffres","Zahlen",
                "ge", "animaux","Tiere",
                "ge", "lettres","Briefe",
                "ge", "couleurs","Farben",
                "ge", "Choisissez", "W�hlen Sie",
                "ge", "Choisir dessin","Zeichnung w�hlen",
                "ge", "Choisir couleurs", "Farben w�hlen",
                "ge", "Annulation","Annullierung",
                "ge", "Simpliste","Einfach",
                "ge", "Ardu","Schwierig",
                "ge", "Grille 9x9 normale", "Normal Gitter 9x9",
                "ge", "Grille 6x6 facile", "Gitter 6x6 einfaches",
                "ge", "Grille 8x8 pas facile", "Gitter 8x8 nicht einfaches",
                "ge", "Grille 10x10 Difficile", "Gitter 10x10 Schwieriges",
                "ge", "Grille 12x12 Tr�s difficile", "Gitter 12x12 sehr Schwieriges",
                "ge", "Grille 16x16 tr�s difficile", "Gitter 16x16 sehr schwieriges",
                "ge", "Grille 4x4 tr�s facile\navec dessins d'animaux\npar d�faut", "sehr einfaches\nGitter 4x4 mit Tieren\nmangels", 
                "ge", "Saisir une grille\npour la r�soudre", "Ein Gitter erfassen,\num es zu l�sen",
                "ge", "Cr�er une grille soi m�me", "Ein Gitter es sogar schaffen",
                "ge", "Il y a des chiffres\n dans les cases", "Es gibt Zahlen in den K�sten",
                "ge", "Il y a des lettres\n dans les cases", "Es gibt Briefe\nin den K�sten",
                "ge", "Demander une nouvelle grille", "ein neues Gitter zu verlangen",
                "ge", "Il y a des animaux\n dans les cases", "Es gibt Tiere in den K�sten",
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
                "sp", "Saisir lettres", "Coger cartas",
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
                "sp", "italien", "italiano",
                "sp", "portugais", "portugu�s",
                "sp", "Quelle difficult�?", "?Qu� dificultad",
                "sp", "Facile", "facil",
                "sp", "Difficile", "dificil",
                "sp", "Tr�s difficile", "muy dificil",
                "sp", "Aide?","?ayuda",
                "sp", "Enfant","Ni�o",
                "sp", "chiffres","cifras",
                "sp", "animaux","animales",
                "sp", "lettres","letras",
                "sp", "couleurs","colores",
                "sp", "Choisissez", "Escoja",
                "sp", "Choisir dessin","Escoger dibujo",
                "en", "Choisir couleurs", "Escoger colores",
                "sp", "Annulation","Anulaci�n",
                "sp", "Simpliste","Simplista",
                "sp", "Ardu","Arduo",
                "sp", "Grille 9x9 normale", "Normal rejilla 9x9",
                "sp", "Grille 6x6 facile", "rejilla 6x6 f�cil",
                "sp", "Grille 8x8 pas facile", "rejilla 8x8 no f�cil",
                "sp", "Grille 10x10 Difficile", "rejilla 10x10 Dificil",
                "sp", "Grille 12x12 Tr�s difficile", "rejilla 12x12 muy dificil",
                "sp", "Grille 16x16 tr�s difficile", "rejilla 16x16 muy dificil",
                "sp", "Grille 4x4 tr�s facile\navec dessins d'animaux\npar d�faut", "rejilla 4x4 muy f�cil\ncon animales\npor defecto",
                "sp", "Saisir une grille\npour la r�soudre", "Coger una rejilla\npara solucionarlo",
                "sp", "Cr�er une grille soi m�me", "Crear una rejilla s� incluso",
                "sp", "Il y a des chiffres\n dans les cases", "Hay cifras\nen las casillas",
                "sp", "Il y a des lettres\n dans les cases", "Hay letras\nen las casillas",
                "sp", "Il y a des couleurs\n dans les cases", "Hay colores\nen las casillas",
                "sp", "Demander une nouvelle grille", "pedir una nueva rejilla",
                "sp", "Il y a des animaux\n dans les cases", "Hay animales\n en las casillas",
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
                "it", "Saisir lettres", "Osservare lettere",
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
                "it", "italien", "italiano",
                "it", "portugais", "portoghesi",
                "it", "Quelle difficult�?", "Quale difficolt�?",
                "it", "Facile", "Facile",
                "it", "Difficile", "Difficile",
                "it", "Tr�s difficile", "Molto difficile",
                "it", "Aide?","Aiuto?",
                "it", "Enfant","Bambino",
                "it", "chiffres","numeri",
                "it", "animaux","animali",
                "it", "lettres","lettere",
                "it", "couleurs","colori",
                "it", "Choisissez", "Scegliete",
                "it", "Choisir dessin","Scegliere disegno",
                "it", "Choisir couleurs", "Scegliere colori",
                "it", "Annulation","Annullamento",
                "it", "Simpliste","Simplista",
                "it", "Ardu","Arduo",
                "it", "Grille 9x9 normale", "Normale griglia 9x9",
                "it", "Grille 6x6 facile", "Griglia 6x6 facile",
                "it", "Grille 8x8 pas facile", "Griglia 8x8 non facile",
                "it", "Grille 10x10 Difficile", "Griglia 10x10 Difficile",
                "it", "Grille 12x12 Tr�s difficile", "Griglia 12x12 molto difficile",
                "it", "Grille 16x16 tr�s difficile", "Griglia 16x16 molto difficile",
                "it", "Grille 4x4 tr�s facile\navec dessins d'animaux\npar d�faut", "griglia 4x4\nmolto facile \ncon animali per difetto",
                "it", "Saisir une grille\npour la r�soudre", "Afferrare una griglia\nper risolverla",
                "it", "Cr�er une grille soi m�me", "Creare una griglia s� anche",
                "it", "Il y a des chiffres\n dans les cases", "Ci sono cifre\nnelle scatole",
                "it", "Il y a des lettres\n dans les cases", "Ci sono lettere\nnelle scatole",
                "it", "Demander une nouvelle grille", "chiedere una nuova griglia",
                "it", "Il y a des animaux\n dans les cases", "Ci sono animali\n nelle scatole",
                "it", "Il y a des couleurs\n dans les cases", "Ci sono colori\n nelle scatole",
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
                "pt", "Saisir lettres", "Apreender cartas",
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
                "pt", "italien", "italiano",
                "pt", "portugais", "portugueses",
                "pt", "Quelle difficult�?", "qual dificulda",
                "pt", "Facile", "facil",
                "pt", "Difficile", "dificil",
                "pt", "Tr�s difficile", "muito dificil",
                "pt", "Aide?","ayuda?",
                "pt", "chiffres","n�meros",
                "pt", "animaux","animais",
                "pt", "lettres","lettere",
                "pt", "couleurs","cores",
                "pt", "Choisissez", "Selecionar",
                "pt", "Choisir dessin","Escolher desenho",
                "pt", "Choisir couleurs", "Escolher cores",
                "pt", "Annulation","Anula��o",
                "pt", "Enfant","crian�a",
                "pt", "Simpliste","Simplista",
                "pt", "Grille 9x9 normale", "Normal grelha 9x9",
                "pt", "Grille 6x6 facile", "grelha 6x6 f�cil",
                "pt", "Grille 8x8 pas facile", "grelha 8x8 n�o f�cil",
                "pt", "Grille 10x10 Difficile", "grelha 10x10 dificil",
                "pt", "Grille 12x12 Tr�s difficile", "grelha 12x12 muito dificil",
                "pt", "Grille 16x16 tr�s difficile", "grelha 16x16 muito dificil", 
                "pt", "Grille 4x4 tr�s facile\navec dessins d'animaux\npar d�faut","grelha 4x4 muito f�cil\ncom animais\npor defeito",
                "pt", "Saisir une grille\npour la r�soudre", "Apreender uma grelha\npara resolver-o",
                "pt", "Cr�er une grille soi m�me", "Criar uma grelha ele mesmo",
                "pt", "Il y a des chiffres\n dans les cases", "H� n�meros\nnos compartimentos",
                "pt", "Demander une nouvelle grille", "pedir uma nova grelha",
                "pt", "Il y a des animaux\n dans les cases", "H� animais\nnos compartimentos",
                "pt", "Il y a des lettres\n dans les cases", "H� cartas\nnos compartimentos",
                "pt", "Il y a des couleurs\n dans les cases", "H� cores\nnos compartimentos",
                "pt", "Ardu","�rduo"
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
        