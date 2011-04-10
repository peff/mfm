my ($input, @specs) = cat($RULEDATA);
my @inputs = split / /, $input;
my @replace = map { [split / /, $_, 3] } @specs;
my @sed = map {
  my ($token, $file, $field) = @$_;
  my $cmd = "head -n 1 $file";
  if ($field) {
    $cmd .= "| cut -d' ' -f$field";
  }
  qq(-e "s}\@\@$token\@\@}`$cmd`}")
} @replace;

target;
dependon @inputs, map { $_->[1] } @replace;
formake atomic(
  'sed' . join('', map { " \\\n  $_" } @sed, join(' ', @inputs))
);
