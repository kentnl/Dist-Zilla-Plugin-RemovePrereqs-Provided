use strict;
use warnings;

use Test::More;

# ABSTRACT: A basic test
use recommended "Dist::Zilla::Plugin::MetaProvides::Package";

BEGIN {
  plan skip_all => "Requires [MetaProvides::Package]"
    unless recommended->has("Dist::Zilla::Plugin::MetaProvides::Package");
}

use Dist::Zilla::Plugin::Prereqs;
use Dist::Zilla::Plugin::GatherDir;
use Dist::Zilla::Util::Test::KENTNL 1.005000 qw( dztest );
use Test::DZil qw( simple_ini );

my $t       = dztest();
my $package = 'BadName';

$t->add_file(
  'dist.ini' => simple_ini(
    ['GatherDir'],                #
    ['MetaProvides::Package'],    #
    [ 'Prereqs', { $package => 0 } ],    #
    ['RemovePrereqs::Provided'],         #
  )
);
$t->add_file( 'lib/BadName.pm' => <<"EOF" );
package ${package};

our \$VERSION = 0.001;
1;
EOF

$t->build_ok;

$t->prereqs_deeply( {} );                # No prereqs

note explain $t->builder->log_messages;
done_testing;
