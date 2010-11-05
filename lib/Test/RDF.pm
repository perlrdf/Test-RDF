package Test::RDF;

use warnings;
use strict;

use Carp;
use Text::Diff;
use RDF::Trine;
use RDF::Trine::Parser;
use RDF::Trine::Model;
use RDF::Trine::Graph;
use RDF::Trine::Serializer::NTriples::Canonical;

use base 'Test::Builder::Module';
our @EXPORT = qw/is_rdf is_valid_rdf isomorph_graphs/;



=head1 NAME

Test::RDF - for validity and equality

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.10';


=head1 SYNOPSIS

 use Test::RDF;

 is_valid_rdf $rdf_string, $syntax,  'RDF string is valid according to selected syntax';
 is_rdf       $rdf_string, $syntax1, $expected_rdf_string, $syntax2, 'The two strings have the same triples';
 isomorph_graphs $model, $expected_model, 'The two models have the same triples'


=head1 EXPORT

=head2 is_valid_rdf

Use to check if the input RDF string is valid in the chosen syntax

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


=head2 is_rdf

Use to check if the input RDF strings are isomorphic (i.e. the same)

=cut


sub is_rdf {
    my ($rdf1, $syntax1, $rdf2, $syntax2, $name) = @_;
    my $parser1 = RDF::Trine::Parser->new($syntax1);
    my $test = __PACKAGE__->builder;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    # First, test if the input RDF is OK
    my $model1 = RDF::Trine::Model->temporary_model;
    eval {
        $parser1->parse_into_model('http://example.org/', $rdf1, $model1);
    };
    if ( my $error = $@ ) {
        $test->ok( 0, $name );
        $test->diag("Input was not valid RDF:\n\n\t$error");
        return;
    }

    # If the expected RDF is non-valid, don't catch the exception
    my $parser2 = RDF::Trine::Parser->new($syntax2);
    my $model2 = RDF::Trine::Model->temporary_model;
    $parser2->parse_into_model('http://example.org/', $rdf2, $model2);
    return isomorph_graphs($model1, $model2, $name);
}


=head2 isomorph_graphs

Use to check if the input RDF::Trine::Models have isomorphic graphs

=cut


sub isomorph_graphs {
    my ($model1, $model2, $name) = @_;
    my $g1 = RDF::Trine::Graph->new( $model1 );
    my $g2 = RDF::Trine::Graph->new( $model2 );
    my $test = __PACKAGE__->builder;

    if ($g1->equals($g2)) {
        $test->ok( 1, $name );
        return 1;
    } else {
        $test->ok( 0, $name );
        my $serializer = RDF::Trine::Serializer::NTriples::Canonical->new;
        $test->diag('Graphs differ:');
        $test->diag(diff \$serializer->serialize_model_to_string($model1),
                         \$serializer->serialize_model_to_string($model2),
                    { STYLE => "Table" });
        return;
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

Michael Hendricks wrote the first Test::RDF. The present module is a
complete rewrite from scratch using Gregory Todd William's
L<RDF::Trine::Graph> to do the heavy lifting.


=head1 LICENSE AND COPYRIGHT

Copyright 2010 ABC Startsiden AS and Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Test::RDF
