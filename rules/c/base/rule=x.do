my @deps = cat($RULEDATA);
my @objects = map { /\.lib$/ ? "`cat $_`" : $_ } @deps;

target;
dependon 'mkex', "$TARGET.o", @deps;
formake wrap('./mkex', $TARGET, @objects);
