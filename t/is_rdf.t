use Test::Tester tests => 39;

use Test::RDF;

check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle','</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', 'Compare Turtle exact matches' );
	   },
	   {
	    ok => 1,
	    name => 'Compare Turtle exact matches',
	   }
);


check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', '<?xml version="1.0" encoding="utf-8"?><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description rdf:about="/foo"><ns0:label xmlns:ns0="http://www.w3.org/2000/01/rdf-schema#" xml:lang="en">This is a Another test</ns0:label></rdf:Description></rdf:RDF>', 'rdfxml', 'Compare RDF/XML and Turtle');
	   },
	   {
	    ok => 1,
	    name => 'Compare RDF/XML and Turtle',
	   }
);


check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle','</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a test"@en .', 'turtle', 'Compare Turtle exact matches, with error' );
	   },
	   {
	    ok => 0,
	    name => 'Compare Turtle exact matches, with error',
	    diag => "Graphs differ:\nnon-blank triples don't match: \$VAR1 = '(triple <http://example.org/foo> <http://www.w3.org/2000/01/rdf-schema#label> \"This is a Another test\"\@en)';\n\$VAR2 = '(triple <http://example.org/foo> <http://www.w3.org/2000/01/rdf-schema#label> \"This is a test\"\@en)';"
	   }
);


check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', '<?xml version="1.0" encoding="utf-8"?><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description rdf:about="/foo"><ns0:label xmlns:ns0="http://www.w3.org/2000/01/rdf-schema#" xml:lang="en">This is a test</ns0:label></rdf:Description></rdf:RDF>', 'rdfxml', 'Compare RDF/XML and Turtle, with error');
	   },
	   {
	    ok => 0,
	    name => 'Compare RDF/XML and Turtle, with error',
	    diag => "Graphs differ:\nnon-blank triples don't match: \$VAR1 = '(triple <http://example.org/foo> <http://www.w3.org/2000/01/rdf-schema#label> \"This is a Another test\"\@en)';\n\$VAR2 = '(triple <http://example.org/foo> <http://www.w3.org/2000/01/rdf-schema#label> \"This is a test\"\@en)';"
	   }
);

TODO: {
local $TODO = "TODO";
check_test(
	   sub {
	     isnt_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle','</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', 'Compare Turtle exact matches that shouldnt be' );
	   },
	   {
	    ok => 0,
	    name => 'Compare Turtle exact matches that shouldnt be',
	    diag => "Graphs are equal."
	   }
);

check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle','</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a test"@en .', 'turtle', 'Compare Turtle with error' );
	   },
	   {
	    ok => 1,
	    name => 'Compare Turtle with error',
	   }
);
}
