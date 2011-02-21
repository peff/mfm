my $base = replace_ext($TARGET, 'lib');

target;
dependon "conf-$base";
formake atomic("head -n 1 conf-$base");
