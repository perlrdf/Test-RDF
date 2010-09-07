use Test::Builder::Tester tests => 2;
use Test::More;

use Test::RDF;

test_out('ok 1 - Valid turtle');
is_valid_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test"@en .', 'turtle', 'Valid turtle');
test_test("Valid Turtle test ok");

test_out('not ok 1 - Valid turtle');
#test_fail(+1);
test_err("#   Failed test 'Valid turtle'\n#   at $0 line ".line_num(+1).".\n# Input was not valid RDF:\n#\n#\tNo tokens");
is_valid_rdf('</foo> <http://www.w3.org/2000/01/rdf-schema#label> "This is a Another test@en .', 'turtle', 'Valid turtle');
test_test("Invalid Turtle test ok");
