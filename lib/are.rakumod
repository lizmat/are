use nqp;  # basically the code of Any.are from 2022.01 onward

my proto sub are(|) is export {*}
my multi sub are(Any:U $what) { $what      }
my multi sub are(Any:D $what) { $what.WHAT }
my multi sub are(Iterable:D $values) { infer $values.iterator }
my multi sub are(*@values)           { infer @values.iterator }

my sub infer(Iterator:D $iterator) {
    nqp::if(
      nqp::eqaddr((my $pulled := $iterator.pull-one),IterationEnd),
      Nil,                                            # nothing to check
      nqp::stmts(
        (my $type := $pulled.WHAT),                   # initial type
        nqp::until(
          nqp::eqaddr(($pulled := $iterator.pull-one),IterationEnd)
            || nqp::not_i(nqp::eqaddr($pulled.WHAT,$type)),
          nqp::null
        ),
        nqp::if(
          nqp::eqaddr($pulled,IterationEnd),
          $type,                                      # all the same
          slow-infer($iterator, $type, $pulled)       # find out what
        )
      )
    )
}
my multi sub are(Slip:D $what) {
    nqp::eqaddr($what,Empty) ?? Nil !! nextsame
}

my sub slow-infer($iterator, Mu $type is copy, Mu $pulled is copy) {
    # set up types to check
    my $mro :=
      nqp::clone(nqp::getattr($type.^mro(:roles),List,'$!reified'));

    nqp::repeat_until(
      nqp::eqaddr(($pulled := $iterator.pull-one),IterationEnd)
        || nqp::eqaddr($type,Mu),
      nqp::until(
        nqp::istype($pulled,nqp::atpos($mro,0)),
        nqp::stmts(                       # not the same base type
          nqp::shift($mro),
          ($type := nqp::atpos($mro,0)),  # assume next type for now
        )
      )
    );
    $type
}

=begin pod

=head1 NAME

are - produce the common type / role of a list of objects

=head1 SYNOPSIS

=begin code :lang<raku>

use are;

say are 1,1.2,pi;                   # (Real)

say (1,1.2,pi,i).&are;              # (Numeric)

say (1,"one").&are;                 # (Cool)

say are DateTime.now, Date.today);  # (Dateish)

=end code

=head1 DESCRIPTION

The C<are> subroutine (the only subroutine exported by this module)
returns the most common class or role from a list of objects.

It was introduced in Rakudo release 2022.01 as a method on C<Any>.
It is provided here to allow the functionality to be used with
older versions of Rakudo.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/are .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
