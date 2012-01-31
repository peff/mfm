my $src = replace_ext($TARGET, '1', 'xml');

target;
dependon $src;
# XXX we should take care to do this atomically,
# but xmlto makes this hard
formake "xmlto -o Documentation man $src"
