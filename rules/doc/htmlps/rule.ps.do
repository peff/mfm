my $base = replace_ext($TARGET, 'ps');

target;
dependon qw(mkhtmlps), "$base.html";
formake "./mkhtmlps $base";
