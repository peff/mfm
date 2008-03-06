package SimpleIO::Cat;
use strict;
use base qw(Exporter);
our @EXPORT = qw(cat_scalar cat_rawlines cat_lines cat_sh cat);

sub cat_scalar {
  my $buf;
  my $len = 0;

  foreach my $f (@_) {
    use IO::File;
    my $fh = ref($f) ? $f : new IO::File($f, 'r');
    $fh or die "unable to open $f: $!";

    while(1) {
      my $r = $fh->read($buf, 4096, $len);
      defined($r) or die "error reading $f: $!";
      return $buf unless $r;
      $len += $r;
    }
  }

  return $buf;
}

sub cat_rawlines {
  return split /\n/, cat_scalar(@_);
}

sub cat_lines {
  return map {
    s/^[ \t]+//;
    s/[ \t]+$//;
    $_ ? $_ : ();
  } cat_rawlines(@_);
}

sub cat_sh {
  return map {
    split /[ \t]+/;
  } cat_lines(@_);
}

sub cat {
  return wantarray ? cat_lines(@_) : cat_scalar(@_);
}

1;
