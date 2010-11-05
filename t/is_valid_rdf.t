use Test::Tester tests => 13;

use Test::RDF;

check_test(
	   sub {
	     is_valid_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', 'Valid turtle');
	   },
	   {
	    ok => 1,
	    name => 'Valid turtle'
	   }
);

check_test(
	   sub {
	     is_valid_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test@en .', 'turtle', 'Valid turtle');
	   },
	   {
	    ok => 0,
	    name => 'Valid turtle',
	    diag => "Input was not valid RDF:\n\n\tNo tokens"
	   }
);

