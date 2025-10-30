[![Actions Status](https://github.com/kaz-utashiro/App-lms/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/kaz-utashiro/App-lms/actions?workflow=test)
# NAME

lms - Let Me See command

# VERSION

Version 0.09

# SYNOPSIS

lms command/library

# DESCRIPTION

This is a small program to look a command or library file.

It is convenient to see a command file written in shell or any other
script language.

As for library files, only Perl is supported, and experimental support
for Python is included.

# OPTIONS

- **-l**

    Print module path.  Use multple times (`-ll`) to call `ls -l`.

# MODULES

- <App::lms::Command>

    Module for executable file.

- <App::lms::Perl>

    Module for Perl module file.

- <App::lms::Python>

    Module for Python library file.  Use [Inline](https://metacpan.org/pod/Inline) module to execute
    Phthon script within Perl module.

# FILES

- `~/.Inline`

    Directory used by [Inline](https://metacpan.org/pod/Inline) module.  Automatically created if not
    exists.

# INSTALL

cpanm https://github.com/kaz-utashiro/App-lms.git

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 1992- Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
