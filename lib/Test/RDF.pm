package Test::RDF;

use warnings;
use strict;

use Carp;
use Text::Diff;

use base 'Test::Builder::Module';
our @EXPORT = qw/is_rdf is_valid_rdf/;



=head1 NAME

Test::RDF - Test RDF data

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

 use Test::RDF;

 is_valid_rdf $rdf_string, $syntax,  'RDF string is valid according to selected syntax';
 is_rdf       $rdf_string, $syntax1, $expected_rdf_string, $syntax2, 'The two strings have the same triples';
 isomorph_graphs $model, $expected_model, 'The two models have the same triples'


=head1 EXPORT

=head2 is_valid_rdf

Use to check if the input RDF is valid in the chosen syntax

=cut

sub is_valid_rdf {
    my ($rdf, $syntax, $name) = @_;
    my $parser = RDF::Trine::Parser->new($syntax);
    my $test = __PACKAGE__->builder;
    eval {
        $parser->parse('http://example.org/', $rdf);
    };
    if ( my $error = $@ ) {
        $test->ok( 0, $name );
        $test->diag("Input was not valid RDF:\n\n\t$error");
        return;
    }
    else {
        $test->ok( 1, $name );
        return 1;
    }
}


=head1 AUTHOR

Kjetil Kjernsmo, C<< <kjetilk at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-rdf at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-RDF>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::RDF


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-RDF>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-RDF>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-RDF>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-RDF/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Test::RDF
