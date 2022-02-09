package App::lms::Python;
use v5.14;
use warnings;

sub get_path {
    my($app, $name) = @_;
    getsourcefile($name);
}

my $DIR;
BEGIN {
    $DIR = "$ENV{HOME}/.Inline";
    unless (-d $DIR) {
	mkdir $DIR || die "$!";
	warn "Make $DIR directory.\n";
    }
}

use Inline
    DIRECTORY => $DIR,
    Python => <<'END';

import re
import inspect

def getsourcefile(name):
    if re.search(r'[^\w\.]', name):
        return
    try:
        exec('import ' + name)
    except:
        return
    return inspect.getsourcefile(eval(name))

END

1;
