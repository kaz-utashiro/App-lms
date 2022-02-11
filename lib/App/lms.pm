package App::lms;

our $VERSION = "0.07";

use v5.14;
use warnings;

use utf8;
use Encode;
use Data::Dumper;
use open IO => 'utf8', ':std';
use Pod::Usage;
use List::Util qw(any first);
use App::lms::Util;

use Getopt::EX::Hashed; {
    has debug   => '       ' , is => 'ro' ;
    has list    => ' l     ' , is => 'ro' ;
    has verbose => ' v !   ' , is => 'ro' , default => 1 ;
    has pager   => ' p =s  ' , is => 'ro' ;
    has suffix  => '   =s  ' , is => 'ro' , default => [ qw( .pm ) ] ;
    has skip    => '   =s@ ' , is => 'ro' ,
	default => [ $ENV{OPTEX_BINDIR} || ".optex.d/bin" ] ;
} no Getopt::EX::Hashed;

sub run {
    my $app = shift;
    @_ = map { utf8::is_utf8($_) ? $_ : decode('utf8', $_) } @_;

    use Getopt::EX::Long qw(GetOptionsFromArray Configure ExConfigure);
    ExConfigure BASECLASS => [ __PACKAGE__, "Getopt::EX" ];
    Configure qw(bundling no_getopt_compat);
    GetOptionsFromArray(\@_, $app->optspec) || pod2usage();

    my $name = pop // pod2usage();
    my @option = splice @_;
    my $pager = $app->pager || $ENV{'PAGER'} || 'less';

    my @found = do {
	no strict 'refs';
	grep { defined }
	map {
	    eval "require $_" ? &{"$_\::get_path"}($app, $name) : ();
	}
	map { __PACKAGE__ . '::' . $_ }
	qw( Command Perl Python );
    };

    if (not @found) {
	warn "$name: Nothing found.\n";
	return 1;
    }

    if ($app->list) {
	if ($app->verbose) {
	    system 'ls', '-l', @found;
	} else {
	    print "@found\n";
	}
	return 0;
    }

    @found = grep {
	not &is_binary($_) or do {
	    system 'file', $_;
	    0;
	}
    } @found or return 0;

    exec $pager, @option, @found;
    die "$pager: $!\n";
}

use List::Util qw(none);

sub valid {
    my $app = shift;
    state $sub = do {
	my @re = map { qr/\Q$_\E$/ } @{$app->skip};
	sub { none { $_[0] =~ $_ } @re };
    };
    $sub->(@_);
}

1;

__END__

=encoding utf-8

=head1 NAME

lms - Let Me See command

=head1 SYNOPSIS

lms command/library

=head1 DESCRIPTION

Document is included in executable script.
Use `perldoc lms`.

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 1992-2021 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
