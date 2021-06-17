package App::lms::Command;
use v5.14;
use warnings;

my @path = split /:+/, $ENV{'PATH'};

sub get_path {
    my $app  = shift;
    my $name = shift;
    my @path = grep $app->valid($_), split /:/, $ENV{'PATH'};
    grep { -x $_ } map { "$_/$name" } @path;
}

1;
