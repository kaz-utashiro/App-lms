package App::lms::Perl;
use v5.14;
use warnings;

sub get_path {
    my $app  = shift;
    my $name = shift;

    grep { -f $_ and -r $_ }
    map  { s[::][/]gr }
    map  { ( "$_/$name", "$_/$name.pm", "$_/$name.pl" ) }
    grep { $app->valid($_) }
    @INC;
}

1;
