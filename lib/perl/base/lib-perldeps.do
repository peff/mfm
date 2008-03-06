setattr run =>
sub {
  my $source = shift;
  my @r;
  open(my $fh, '<', $source)
    or die "unable to open $source: $!";
  while(my $line = <$fh>) {
    push @r, $1 if $line =~ /^(?:use|require) ([A-Za-z0-9:]+).*; # DEPEND/;
    last if $line eq "__END__\n";
  }
  return map { s!::!/!g; "$_.pm" } @r;
}
