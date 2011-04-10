package SimpleIO::Cat;
use strict;
use base qw(Exporter);
our @EXPORT = qw(cat_scalar cat_rawlines cat_lines cat_sh cat);

sub cat_scalar {
  my $buf;

  FILE:
  foreach my $f (@_) {
    my $fh;
    if (!ref($f)) {
      open($fh, '<', $f)
        or die "unable to open $f: $!";
    }
    else {
      $fh = $f;
    }

    while(1) {
      my $r = read($fh, $buf, 4096, length($buf));
      defined($r) or die "error reading $f: $!";
      next FILE unless $r;
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
