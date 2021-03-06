package Ref::Util;

use strict;
use warnings;
use XSLoader;

use Exporter 5.57 'import';

our $VERSION     = '0.001';
our %EXPORT_TAGS = ( 'all' => [qw<
    is_scalarref is_arrayref is_hashref is_coderef is_regexpref
    is_globref is_formatref is_ioref
>] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );

XSLoader::load('Ref::Util', $VERSION);

1;

__END__

=pod

=head1 NAME

Ref::Util - Utility functions for checking references

=head1 DESCRIPTION

Ref::Util introduces several functions to help identify references in a
faster, but mostly B<smarter>, way. In short:

    ref $foo eq 'ARRAY'

    # is now:

    is_arrayref($foo)

The difference:

=over 4

=item * No comparison against a string constant

When you call C<ref>, you stringify the reference and then compare it
to some string constant (like C<ARRAY> or C<HASH>). Not just awkward,
it's brittle since you can mispell the string.

=item * Supports blessed variables

When calling C<ref>, you receive either the reference type (B<SCALAR>,
B<ARRAY>, B<HASH>, etc.) or the package it's blessed into.

When calling C<is_arrayref> (et. al.), you check the variable flags,
so even if it's blessed, you know what type of variable is blessed.

=item * Supports overloaded variables

If you've overloaded anything (C<eq>, stringification), you will
probably get bitten. However, these functions do not care since they
only check flags.

=back

Additionally, two implementations are available, depending on the perl
version you have. For perl that supports Custom OPs, we actually add
an OP code (which is faster), and for perls that do not, we include
an implementation that just calls an XS function - which is still
faster than the Pure-Perl equivalent.

We might also introduce a Pure-Perl version of everything, allowing
to install this module where a compiler is not available, making the
XS parts optional.

=head1 SUBROUTINES

=head2 is_scalarref

    is_scalarref(\$foo);

=head2 is_arrayref

    is_arrayref([]);

=head2 is_hashref

    is_hashref({});

=head2 is_coderef

    is_coderef( sub {} );

=head2 is_regexpref

    is_regexpref( qr// );

=head2 is_globref

    is_globref( *foo );

=head2 is_formatref

    # set up format in STDOUT
    format STDOUT =
    @
    .

    # now we can test it
    is_formatref( *STDOUT{FORMAT} );

=head2 is_ioref

    is_ioref( *STDOUT{IO} );

=head1 SEE ALSO

=over 4

=item * L<Params::Classify>

=back

=head1 AUTHORS

=over 4

=item * Vikentiy Fesunov

=item * Sawyer X

=item * Gonzalo Diethelm

=item * p5pclub

=back
