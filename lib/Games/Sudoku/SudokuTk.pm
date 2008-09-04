package Games::Sudoku::SudokuTk;

use 5.008008;
#use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Games::Sudoku::SudokuTk ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.10';
sudoku();
# Preloaded methods go here.

1;

sub sudoku {
use Tk;
use Games::Sudoku::menu;
#use Games::Sudoku::conf;
#conf();
foreach $a (@INC) {             # we verifie that drawings are here
        $retour = opendir('DIRECTORY',$a . '/Games/Sudoku/photos');
        $b = $a;
        if ($retour) {
          last;
        }
}
closedir('DIRECTORY');
#print ("fichier " . "$b" . "\n");
$system = $^O;                  # we find the system
#print "system $system\n";
$pref = "$b" . "/Games/Sudoku";
@precarre = "";
@wprecarre = "";
# Definition of main window 
$langue = "";
$dessin = "chiffres";
$MaxiSudoku = 0;             # 0 non choisi 1 choisi 2 autre choisi
$Normal = 0;                 # idem
$Enfant = 0;                 # idem
$trait = "sudoku";
$main = MainWindow->new();
menu($trait);
$canvas = $main->Label(-text => 'Sudoku',
        -height => 4, -width => 10,
        -font => "Nimbus 80")->pack;
$framed = $main->Frame->pack();
$canvas1 = $framed->Canvas('-width' => 100,
        -height => 100);
$framed->Photo('image1', -file => $pref . '/photos/20.gif');
$canvas1->createImage(0, 0, -anchor => 'nw',
        -image => image1);
$canvas1->pack;
$rbutton1= $framed->Radiobutton(-text 
                        => tr1('Normal'), 
                        -font => "Nimbus 30",
                        -value => 1,         # valeur transmise de la variable
                        -command => [\&Normal],
                        -variable => \$Normal
                        )->pack(-side => 'left');
$rbutton2= $framed->Radiobutton(-text 
                        => tr1('MaxiSudoku'), 
                        -font => "Nimbus 30",
                        -value => 1,
                        -command => [\&MaxiSudoku],
                        -variable => \$MaxiSudoku
                        )->pack(-side => 'left');
$rbutton3= $framed->Radiobutton(-text 
                        => tr1('Enfant'), 
                        -font => "Nimbus 30",
                        -value => 1,
                        -command => [\&Enfant],
                        -variable => \$Enfant
                        )->pack(-side => 'left');
$wcanvas = 1;
MainLoop;
}
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Games::Sudoku::SudokuTk - Sudoku Game 

=head1 SYNOPSIS

  use Games::Sudoku::SudokuTk;

=head1 DESCRIPTION

Game Sudoku allows to solve grids Sudoku in some seconds, to generate new grids, to work out grids.
3 dimensions are possible - For the children 4x4 - Normal Sudoku 9x9 - MaxiSudoku 16x16
Symbols to be found are figures but can be drawings of animals (by default for format child)
Sudoku exists in several languages: French, English, German, Spanish, Portuguese. 
Resolutions are approachable and a help is given to find resolution if you want it


=head2 EXPORT

None by default.



=head1 SEE ALSO

Dependance: Tk, IO::File

=head1 AUTHOR

Christian Guine, E<lt>c.guine@free.frE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Christian Guine

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut