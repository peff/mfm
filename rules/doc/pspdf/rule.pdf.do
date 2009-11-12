my $base = replace_ext($TARGET, 'pdf');

target;
dependon qw(mkpspdf), "$base.ps";
formake "./mkpspdf $base";
