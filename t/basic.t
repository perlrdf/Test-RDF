use Test::Builder::Tester tests => 1;
use Test::More;

use Test::RDF;

test_out('ok 1 - Valid turtle');
#test_fail(+1);
is_valid_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', 'Valid turtle');
test_test("Valid Turtle test ok");
