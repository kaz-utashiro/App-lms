package App::lms;

our $VERSION = "0.01";

use v5.14;
use warnings;

use utf8;
use Encode;
use Data::Dumper;
use open IO => 'utf8', ':std';
use Pod::Usage;
use List::Util qw(any first);

use Moo;

has list    => ( is => 'ro' );
has pager   => ( is => 'ro' );
has suffix  => ( is => 'ro', default => sub { [ qw( .pm ) ] } );
has verbose => ( is => 'ro', default => 1 );
has skip    => ( is => 'ro',
		 default => sub { [ $ENV{OPTEX_BINDIR} || ".optex.d/bin" ] } );

no Moo;

sub run {
    my $obj = shift;
    @_ = map { utf8::is_utf8($_) ? $_ : decode('utf8', $_) } @_;

    use Getopt::EX::Long qw(GetOptionsFromArray Configure ExConfigure);
    ExConfigure BASECLASS => [ __PACKAGE__, "Getopt::EX" ];
    Configure "bundling";
    GetOptionsFromArray(
	\@_,
	$obj,
	map { s/^(?=\w+_)(\w+)\K/"|".$1=~tr[_][-]r."|".$1=~tr[_][]dr/er }
	"list|l",
	"verbose|v!",
	"pager|p=s",
	"skip=s",
	) || pod2usage();

    my $name = shift || pod2usage();

    # perl module
    if ($name =~ s[::][/]g) {
	$name .= ".pm";
    }

    my $skip = do {
	my @re = map { qr/\Q$_\E$/ } @{$obj->skip};
	sub { any { $_[0] =~ $_ } @re };
    };
    my @path = grep !$skip->($_), split /:/, $ENV{'PATH'};
    my %path = map { $_ => 1 } @path;
    push @path, grep !$path{$_}, @INC;

    my @found;
    my $count = 0;

    for my $path (@path) {
	my $file = do {
	    first { -f $_ && -r $_ }
	    map { "$path/$name" . $_ } '', @{$obj->suffix};
	} or next;
	$count++;
	if (&binary($file) and not $obj->list) {
	    system 'file', $file;
	    next;
	}
	push @found, $file;
    }

    die "nothing hit in path\n" if $count == 0;

    @found or return;

    if ($obj->list) {
	if ($obj->verbose) {
	    system 'ls', '-l', @found;
	} else {
	    print "@found\n";
	}
	exit 0;
    }
    my $pager = $obj->pager || $ENV{'PAGER'} || 'more';
    exec "$pager @found";
    die "$pager: $!\n";
}

######################################################################

sub binary {
    my $file = shift // die;
    open my $fh, '<', $file or die "$file: $!\n";
    binmode $fh, ':raw';
    $fh->read(local $_, 512);
    /[\0\377]/ || (tr/\000-\007\013\016-\032\034-\037/./ * 10 > length);
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
