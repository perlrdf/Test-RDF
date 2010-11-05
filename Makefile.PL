use inc::Module::Install;

name     'Test-RDF';
all_from 'lib/Test/RDF.pm';
readme_from 'lib/Test/RDF.pm';
author   q{Kjetil Kjernsmo <kjetilk@cpan.org>};
license  'perl';

requires 'Test::More';
requires 'Test::Builder::Module';
requires 'Text::Diff::Table';
requires 'RDF::Trine';

test_requires 'Test::Tester';

author_tests('xt');

auto_set_repository;
auto_set_bugtracker;

write_doap_changes;

sign;


WriteAll;

