my $base = replace_ext($TARGET, 'pdf');

target;
dependon qw(mkdvipdf), "$base.dvi";
formake "./mkdvipdf $base";
