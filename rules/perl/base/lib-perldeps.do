setattr run =>
sub {
  my $source = shift;
  my @r;
  open(my $fh, '<', $source)
    or die "unable to open $source: $!";
  while(my $line = <$fh>) {
    if($line =~ /^use base qw\((.*)\); # DEPEND/) {
      push @r, split / /, $1;
    }
    elsif($line =~ /^(?:use|require) ([A-Za-z0-9:]+).*; # DEPEND/) {
      push @r, $1;
    }
    elsif($line eq "__END__\n") {
      last;
    }
  }
  return map { s!::!/!g; "lib/$_.pm" } @r;
}
