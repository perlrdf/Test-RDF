use inc::Module::Install;

name     'Test-RDF';
all_from 'lib/Test/RDF.pm';
author   q{Kjetil Kjernsmo <kjetilk@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

