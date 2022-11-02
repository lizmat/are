[![Actions Status](https://github.com/lizmat/are/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/are/actions)

NAME
====

are - produce the common type / role of a list of objects

SYNOPSIS
========

```raku
use are;

say are 1,1.2,pi;                   # (Real)

say (1,1.2,pi,i).&are;              # (Numeric)

say (1,"one").&are;                 # (Cool)

say are DateTime.now, Date.today);  # (Dateish)
```

DESCRIPTION
===========

The `are` subroutine (the only subroutine exported by this module) returns the most common class or role from a list of objects.

It was introduced in Rakudo release 2022.01 as a method on `Any`. It is provided here to allow the functionality to be used with older versions of Rakudo.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/are . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

