my $base = replace_ext($TARGET, 'ps');

target;
dependon qw(mkdvips), "$base.dvi";
formake "./mkdvips $base";
