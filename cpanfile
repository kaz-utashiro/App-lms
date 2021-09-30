requires 'Encode';
requires 'Getopt::EX::Long';
requires 'List::Util';
requires 'Getopt::EX::Hashed', '0.9920';
requires 'Pod::Usage';
requires 'perl', 'v5.14.0';
requires 'Inline';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
