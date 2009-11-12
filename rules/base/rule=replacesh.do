my ($input, @specs) = cat($RULEDATA);
my @replace = map { [split / /, $_, 2] } @specs;
my @sed = map { qq(-e "s}\@\@$_->[0]\@\@}`head -n 1 $_->[1]`}") } @replace;

target;
dependon qw(warn-auto.sh), $input, map { $_->[1] } @replace;
formake atomic(
  'cat warn-auto.sh',
  'sed' . join('', map { " \\\n  $_" } @sed, "< $input")
);
formake "chmod 755 $TEMPFILE";
