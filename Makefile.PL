use inc::Module::Install;

name     'Test-RDF';
all_from 'lib/Test/RDF.pm';
readme_from 'lib/Test/RDF.pm';
author   q{Kjetil Kjernsmo <kjetilk@cpan.org>};
license  'perl';

test_requires 'Test::Tester';


requires 'Scalar::Util';
requires 'Test::More';
requires 'Test::Builder::Module';
requires 'RDF::Trine' => '0.134';

author_tests('xt');

auto_set_repository;

resources
  bugtracker    => "https://github.com/kjetilk/Test-RDF/issues";

rdf_metadata;
write_doap_changes;

sign;


WriteAll;

