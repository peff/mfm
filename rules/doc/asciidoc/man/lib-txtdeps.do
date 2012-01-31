use File::Basename;

setattr run =>
sub {
  my $f = shift;
  my $dir = dirname($f); $dir .= '/' if length($dir);
  return grep { s/^include::(.*)\[\]$/$dir$1/ } cat_lines($f);
}
