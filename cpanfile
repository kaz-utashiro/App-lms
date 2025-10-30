requires 'Encode';
requires 'Getopt::EX::Long';
requires 'List::Util';
requires 'Getopt::EX::Hashed', '1.05';
requires 'Pod::Usage';
requires 'perl', 'v5.24';
requires 'Inline';
requires 'Inline::Python';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};

on develop => sub {
    requires 'Dist::Zilla::Plugin::GitHubREADME::Badge';
};
