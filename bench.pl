use strict;
use warnings;

use Ref::Util 'is_arrayref';
use Dumbbench;

my $bench = Dumbbench->new(
    target_rel_precision => 0.005, # seek ~0.5%
    initial_runs         => 20,    # the higher the more reliable
);

my $ref = [];
no warnings;
$bench->add_instances(
    Dumbbench::Instance::PerlSub->new(
        name => 'XS',
        code => sub { Ref::Util::is_arrayref($ref) for(1..1e6) },
    ),

    Dumbbench::Instance::PerlSub->new(
        name => 'PP',
        code => sub { ref($ref) eq 'ARRAY' for(1..1e6) },
    ),
);

$bench->run;
$bench->report;
