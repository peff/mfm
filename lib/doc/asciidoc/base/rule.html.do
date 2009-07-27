my $source = replace_ext($TARGET, 'html', 'txt');

target;
dependon 'mkasciidoc', $source;
formake "./mkasciidoc $TARGET $source";
