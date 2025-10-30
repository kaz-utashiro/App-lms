[![Actions Status](https://github.com/kaz-utashiro/App-lms/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/kaz-utashiro/App-lms/actions?workflow=test)
# NAME

lms - Let Me See command

# VERSION

Version 0.09

# SYNOPSIS

    lms [options] command/library

    # Look at a command file
    lms perl

    # Look at a Perl module
    lms Getopt::Long

    # Look at a Python library
    lms os.path

    # Show file path only
    lms -l Getopt::Long

    # Show detailed file information
    lms -ll Getopt::Long

# DESCRIPTION

**lms** (Let Me See) is a utility to locate and display command or library files.

It is convenient to see a command file written in shell or any other
script language.

For library files, Perl modules are fully supported, and experimental support
for Python libraries is included.

The program searches through different file types in order (command, Perl, Python by default)
and displays the first match found using a pager.

# OPTIONS

- **-l**, **--list**

    Print module path instead of displaying the file contents.
    Use multiple times (`-ll`) to call `ls -l` for detailed file information.

- **-v**, **--version**

    Display version information and exit.

- **-p**, **--pager** _command_

    Specify the pager command to use for displaying files.
    Defaults to the `$PAGER` environment variable, or `less` if not set.

- **-t**, **--type** _handler\[:handler:...\]_

    Specify which file type handlers to use and in what order.
    Handlers are specified as colon-separated names.

    Default: `Command:Perl:Python`

    Available handlers:
    \- `Command`: Search for executable commands in `$PATH`
    \- `Perl`: Search for Perl modules in `@INC`
    \- `Python`: Search for Python libraries using Python's inspect module

    Examples:
        lms --type Perl Getopt::Long       # Only search Perl modules
        lms --type Python:Perl os.path     # Search Python first, then Perl

- **--suffix** _extension_

    Specify file suffix/extension to search for (mainly for Perl modules).

    Default: `.pm`

- **--skip** _pattern_

    Specify directory patterns to skip during search.
    Can be used multiple times to specify multiple patterns.

    Default: `.optex.d/bin` (or `$OPTEX_BINDIR` if set)

# HANDLER MODULES

The program uses a plugin architecture where different file type handlers
are dynamically loaded based on the `--type` option. Each handler must
implement a `get_path($app, $name)` method.

- **App::lms::Command**

    Handler for executable commands. Searches through `$PATH` environment
    variable to find executable files.

- **App::lms::Perl**

    Handler for Perl modules. Searches through `@INC` paths to find
    Perl module files (.pm and .pl files).

- **App::lms::Python**

    Handler for Python libraries. Uses [Inline::Python](https://metacpan.org/pod/Inline%3A%3APython) module to execute
    Python's `inspect.getsourcefile()` function to locate Python module files.
    This is experimental functionality.

# FILES

- `~/.Inline`

    Directory used by the [Inline::Python](https://metacpan.org/pod/Inline%3A%3APython) module for caching compiled Python bindings.
    Automatically created on first use when accessing Python libraries.

# EXAMPLES

    # Display a shell command file
    lms bash

    # Display a Perl module
    lms List::Util

    # Display a Python library
    lms os.path

    # Just show the file path
    lms -l perl

    # Show detailed file information
    lms -ll Getopt::EX::Long

    # Only search for Perl modules
    lms --type Perl Data::Dumper

    # Search Python first, then fall back to Perl
    lms --type Python:Perl sys

    # Use a custom pager
    lms --pager "vim -R" Moose

    # Pass options to the pager (use -- to separate)
    lms -- +10 List::Util  # Open less at line 10

# INSTALLATION

    # From CPAN
    cpanm App::lms

    # From GitHub
    cpanm https://github.com/kaz-utashiro/App-lms.git

    # From source
    git clone https://github.com/kaz-utashiro/App-lms.git
    cd App-lms
    cpanm --installdeps .
    cpanm .

# ENVIRONMENT

- **PAGER**

    Default pager command to use when displaying files.
    If not set, `less` is used.

- **OPTEX\_BINDIR**

    If set, overrides the default skip pattern for the `--skip` option.

# SEE ALSO

[App::lms](https://metacpan.org/pod/App%3A%3Alms), [Getopt::EX](https://metacpan.org/pod/Getopt%3A%3AEX), [Getopt::EX::Hashed](https://metacpan.org/pod/Getopt%3A%3AEX%3A%3AHashed), [Inline::Python](https://metacpan.org/pod/Inline%3A%3APython)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 1992- Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
