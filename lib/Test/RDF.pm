package Test::RDF;

use warnings;
use strict;

use Carp;
use RDF::Trine;
use RDF::Trine::Parser;
use RDF::Trine::Model;
use RDF::Trine::Graph;

use base 'Test::Builder::Module';
our @EXPORT = qw/are_subgraphs is_rdf is_valid_rdf isomorph_graphs has_subject has_predicate has_object_uri has_uri has_literal/;



=head1 NAME

Test::RDF - Test RDF data for content, validity and equality, etc.

=head1 VERSION

Version 0.22

=cut

our $VERSION = '0.22';


=head1 SYNOPSIS

 use Test::RDF;

 is_valid_rdf($rdf_string, $syntax,  'RDF string is valid according to selected syntax');
 is_rdf($rdf_string, $syntax1, $expected_rdf_string, $syntax2, 'The two strings have the same triples');
 isomorph_graphs($model, $expected_model, 'The two models have the same triples');
 are_subgraphs($model1, $model2, 'Model 1 is a subgraph of model 2' );
 has_subject($uri_string, $model, 'Subject URI is found');
 has_predicate($uri_string, $model, 'Predicate URI is found');
 has_object_uri($uri_string, $model, 'Object URI is found');
 has_literal($string, $language, $datatype, $model, 'Literal is found');


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

Use to check if the input RDF strings are isomorphic (i.e. the same).

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

Use to check if the input RDF::Trine::Models have isomorphic graphs.

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
        $test->diag('Graphs differ:');
        $test->diag($g1->error);
        return;
    }
}

=head2 are_subgraphs

Use to check if the first RDF::Trine::Models is a subgraph of the second.

=cut

sub are_subgraphs {
    my ($model1, $model2, $name) = @_;
    my $g1 = RDF::Trine::Graph->new( $model1 );
    my $g2 = RDF::Trine::Graph->new( $model2 );
    my $test = __PACKAGE__->builder;

    if ($g1->is_subgraph_of($g2)) {
        $test->ok( 1, $name );
        return 1;
    } else {
        $test->ok( 0, $name );
	$test->diag('Graph not subgraph: ' . $g1->error) if defined($g1->error);
        $test->diag('Hint: There are ' . $model1->size . ' statement(s) in model1 and ' . $model2->size . ' statement(s) in model2');
        return;
    }
}

=head2 has_subject

Check if the string URI passed as first argument is a subject in any
of the statements given in the model given as second argument.

=cut

sub has_subject {
  my ($uri, $model, $name) = @_;
  my $count = $model->count_statements(RDF::Trine::Node::Resource->new($uri), undef, undef);
  return _single_uri_tests($count, $name);
}


=head2 has_predicate

Check if the string URI passed as first argument is a predicate in any
of the statements given in the model given as second argument.

=cut

sub has_predicate {
  my ($uri, $model, $name) = @_;
  my $count = $model->count_statements(undef, RDF::Trine::Node::Resource->new($uri), undef);
  return _single_uri_tests($count, $name);
}

=head2 has_object_uri

Check if the string URI passed as first argument is a object in any
of the statements given in the model given as second argument.

=cut

sub has_object_uri {
  my ($uri, $model, $name) = @_;
  my $count = $model->count_statements(undef, undef, RDF::Trine::Node::Resource->new($uri));
  return _single_uri_tests($count, $name);
}

=head2 has_literal

Check if the string passed as first argument, with corresponding
optional language and datatype as second and third respectively, is a
literal in any of the statements given in the model given as fourth
argument.

language and datatype may not occur in the same statement, so the test
fails if they are both set. If none are used, use C<undef>, like e.g.

 has_literal('A test', undef, undef, $model, 'Simple literal');

A test for a typed literal may be done like

 has_literal('42', undef, 'http://www.w3.org/2001/XMLSchema#integer', $model, 'Just an integer');

and a language literal like

 has_literal('This is a Another test', 'en', undef, $model, 'Language literal');


=cut

sub has_literal {
  my ($string, $lang, $datatype, $model, $name) = @_;
  my $literal;
  my $test = __PACKAGE__->builder;
  eval {
    $literal = RDF::Trine::Node::Literal->new($string, $lang, $datatype);
  };
  if ( my $error = $@ ) {
    $test->ok( 0, $name );
    $test->diag("Invalid literal:\n\n\t$error");
    return;
  }

#  local $Test::Builder::Level = $Test::Builder::Level + 1;
  if ($model->count_statements(undef, undef, $literal) > 0) {
    $test->ok( 1, $name );
    return 1;
  } else {
    $test->ok( 0, $name );
    $test->diag('No matching literals found in model');
    return 0;
  }}


=head2 has_uri

Check if the string URI passed as first argument is present in any of
the statements given in the model given as second argument.

=cut

sub has_uri {
  my ($uri, $model, $name) = @_;
  my $test = __PACKAGE__->builder;
  if ($model->count_statements(undef, undef, RDF::Trine::Node::Resource->new($uri)) > 0
      || $model->count_statements(undef, RDF::Trine::Node::Resource->new($uri), undef) > 0
      || $model->count_statements(RDF::Trine::Node::Resource->new($uri), undef, undef) > 0) {
    $test->ok( 1, $name );
    return 1;
  } else {
    $test->ok( 0, $name );
    $test->diag('No matching URIs found in model');
    return 0;
  }
}


sub _single_uri_tests {
  my ($count, $name) = @_;
  my $test = __PACKAGE__->builder;
  local $Test::Builder::Level = $Test::Builder::Level + 1;
  if ($count > 0) {
    $test->ok( 1, $name );
    return 1;
  } else {
    $test->ok( 0, $name );
    $test->diag('No matching URIs found in model');
    return 0;
  }
}


=head1 NOTE

Graph isomorphism is a complex problem, so do not attempt to run the
isomorphism tests on large datasets. For more information see
L<http://en.wikipedia.org/wiki/Graph_isomorphism_problem>.


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

Copyright 2010 ABC Startsiden AS and 2010-2011 Kjetil Kjernsmo.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Test::RDF
