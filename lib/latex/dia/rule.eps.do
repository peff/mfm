my $src = replace_ext($TARGET, 'eps', 'dia');

target;
dependon qw(mkdiaps), get($src)->getattr_recurse('diadeps');
formake "./mkdiaps $src $TARGET";
