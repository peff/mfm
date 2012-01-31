my $src = replace_ext($TARGET, 'xml', 'txt');

target;
dependon uniq($src, get($src)->getattr_recurse('txtdeps'));
formake atomic("asciidoc -o - -b docbook -d manpage $src");
