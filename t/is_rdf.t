use Test::Tester tests => 19;

use Test::RDF;

check_test(
	   sub {
	     is_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', '<?xml version="1.0" encoding="utf-8"?> <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">   <rdf:Description rdf:about="file:///foo">     <ns0:label xmlns:ns0="http://www.w3.org/2000/01/rdf-schema#" xml:lang="en">This is a Another test</ns0:label>   </rdf:Description> </rdf:RDF>', 'rdfxml', 'Equal strings');
	   },
	   {
	    ok => 1,
	    name => 'Equal strings',
	   }
);
