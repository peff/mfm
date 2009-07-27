my $source = replace_ext($TARGET, 'html', 'txt');

target;
dependon qw(mkasciidoc asciidoc.conf), $source;
formake "./mkasciidoc $TARGET $source";
