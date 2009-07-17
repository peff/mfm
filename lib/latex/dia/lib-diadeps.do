use File::Spec;

my @DEP_PATHS = (
  q(//dia:object[@type='Standard - Image']
  /dia:attribute[@name='file']
  /dia:string)
);

setattr run =>
sub {
  my $fn = shift;

  eval 'use XML::XPath';
  $@ and return ($fn);

  my $xp = XML::XPath->new(filename => $fn)
    or die "unable to parse $fn: $!";
  return
    $fn,
    map {
      my $v = $_->string_value;
      $v =~ s/(^#|#$)//g;
      File::Spec->canonpath($v);
    }
    map { $xp->findnodes($_) }
    @DEP_PATHS;
};
