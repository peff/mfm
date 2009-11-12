my $base = replace_ext($TARGET, 'o');

trydepend_init;
my ($src, $compile) =
  trydepend("$base.c") ? ("$base.c", 'compile') :
  trydepend("$base.cc") ? ("$base.cc", 'compilex') :
  trydepend_die("no sensible source for $TARGET");

target;
dependon $compile, uniq($src, get($src)->getattr_recurse('cdeps'));
formake "./$compile $src"
