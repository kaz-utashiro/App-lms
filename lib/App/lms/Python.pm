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

use Inline Config => directory => $DIR;
use Inline Python => <<'END';

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

import os
import sys

def find_module_file(module_name):
    for path in sys.path:
        file_path = os.path.join(path, module_name.replace('.', os.sep) + ".py")
        if os.path.isfile(file_path):
            return file_path
    return None

END

1;
