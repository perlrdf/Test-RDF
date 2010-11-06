#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::RDF' ) || print "Bail out!
";
}

diag( "Testing Test::RDF $Test::RDF::VERSION, Perl $], $^X" );
