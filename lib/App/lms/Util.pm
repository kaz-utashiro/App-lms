package App::lms;
use v5.14;
use warnings;

sub make_options {
    map {
	# "foo_bar" -> "foo_bar|foo-bar|foobar"
	s{^(?=\w+_)(?<opt>\w+)\K}{
	    "|" . $+{opt} =~ tr[_][-]r . "|" . $+{opt} =~ tr[_][]dr
	}er;
    }
    grep {
	s/#.*//;
	s/\s+//g;
	/\S/;
    }
    map { split /\n+/ }
    @_;
}

sub is_binary {
    my $file = shift // die;
    open my $fh, '<', $file or die "$file: $!\n";
    binmode $fh, ':raw';
    $fh->read(local $_, 512);
    /[\0\377]/ || (tr/\000-\007\013\016-\032\034-\037/./ * 10 > length);
}

1;
