setattr run =>
sub {
  my $f = shift;
  return grep { s/^#include "([^"]+)"$/$1/ } cat_lines($f);
}
