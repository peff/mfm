package Mfm::File;
use strict;
use SimpleIO::Cat; # DEPEND

sub expand {
  my $fn = shift;
  return
  map {
    $_,
    -f "$_/MFM" ? expand("$_/MFM", @_) : ()
  }
  grep { -d $_ }
  map {
    my $f = $_;
    m{^[/.]} ? $_ : map { "$_/$f" } @_
  }
  grep { /[^ ]/ }
  split /\n/, interpolate($fn);
}

sub interpolate {
  my $fn = shift;
  my $s = cat_scalar($fn);
  my $r = eval"#line 1 $fn\n<<__MFM_EOS__\n${s}__MFM_EOS__\n";
  $@ and die Error::Parent->new("...while parsing $fn", $@);
  chop $r;
  return $r;
}

1;
