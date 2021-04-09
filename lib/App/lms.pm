package App::lms;

our $VERSION = "0.04";

use v5.14;
use warnings;

use utf8;
use Encode;
use Data::Dumper;
use open IO => 'utf8', ':std';
use Pod::Usage;
use List::Util qw(any first);
use App::lms::Util;

use Moo;

has debug   => ( is => 'ro' );
has list    => ( is => 'ro' );
has verbose => ( is => 'ro', default => 1 );
has pager   => ( is => 'ro' );
has suffix  => ( is => 'ro', default => sub { [ qw( .pm ) ] } );
has skip    => ( is => 'ro',
		 default => sub { [ $ENV{OPTEX_BINDIR} || ".optex.d/bin" ] } );

no Moo;

sub run {
    my $app = shift;
    @_ = map { utf8::is_utf8($_) ? $_ : decode('utf8', $_) } @_;

    use Getopt::EX::Long qw(GetOptionsFromArray Configure ExConfigure);
    ExConfigure BASECLASS => [ __PACKAGE__, "Getopt::EX" ];
    Configure qw(bundling no_getopt_compat);
    GetOptionsFromArray(\@_, $app, make_options "
	debug
	list    | l
	verbose | v !
	pager   | p =s
	suffix      =s
	skip        =s@
	") || pod2usage();

    my $name = pop // pod2usage();
    my @option = splice @_;
    my $pager = $app->pager || $ENV{'PAGER'} || 'less';

    my $skip = do {
	my @re = map { qr/\Q$_\E$/ } @{$app->skip};
	sub { any { $_[0] =~ $_ } @re };
    };
    my @path = grep !$skip->($_), split /:/, $ENV{'PATH'};
    my %path = map { $_ => 1 } @path;
    push @path, grep !$path{$_}, @INC;

    my @found;
    my $count = 0;

    for my $path (@path) {
	my $file = do {
	    first {
		warn "test $_\n" if $app->debug;
		-f $_ && -r $_;
	    }
	    map { ( $_, s[::][/]g ? $_ : () ) }
	    map { "$path/$name" . $_ }
	    '', @{$app->suffix};
	} or next;
	$count++;
	if (&is_binary($file) and not $app->list) {
	    system 'file', $file;
	    next;
	}
	push @found, $file;
    }

    die "nothing hit in path\n" if $count == 0;

    return if not @found;

    if ($app->list) {
	if ($app->verbose) {
	    system 'ls', '-l', @found;
	} else {
	    print "@found\n";
	}
	exit 0;
    }
    exec $pager, @option, @found;
    die "$pager: $!\n";
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
