package Games::Sudoku::SudokuTk;

use 5.008007;
#use strict;
use warnings;


our $VERSION = '0.01';

sudoku();

# Autoload methods go after =cut, and are processed by the autosplit program.


1;

sub sudoku {
use Tk;
use Games::Sudoku::menu;
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
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Games::Sudoku::SudokuTk - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Games::Sudoku::SudokuTk;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Games::Sudoku::SudokuTk, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

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
