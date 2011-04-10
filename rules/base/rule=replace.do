my ($input, @specs) = cat($RULEDATA);
my @inputs = split / /, $input;
my @replace = map { [split / /, $_, 2] } @specs;
my @sed = map { qq(-e "s}\@\@$_->[0]\@\@}`head -n 1 $_->[1]`}") } @replace;

target;
dependon @inputs, map { $_->[1] } @replace;
formake atomic(
  'sed' . join('', map { " \\\n  $_" } @sed, join(' ', @inputs))
);
