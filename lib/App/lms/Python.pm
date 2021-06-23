package App::lms::Python;
use v5.14;
use warnings;

sub get_path {
    my($app, $name) = @_;
    getsourcefile($name);
}

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

END

1;
