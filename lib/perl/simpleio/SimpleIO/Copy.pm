package SimpleIO::Copy;
use strict;
use File::Copy;
use base qw(Exporter);
our @EXPORT = qw(safe_copy);

sub safe_copy {
  use File::stat;
  my $from = shift;
  my $to = shift;
  my $tmp = "$to.tmp";

  my $st = stat($from) or die "unable to stat $from: $!";
  open(my $fh, '>', $tmp)
    or die "unable to open $tmp for writing: $!";
  chmod($st->mode, $tmp) or die "unable to set mode of $tmp: $!";
  copy($from, $fh)
    or die "unable to copy $from to $tmp: $!";
  utime($st->atime, $st->mtime, $tmp)
    or die "unable to set mtime of $tmp: $!";
  rename($tmp, $to)
    or die "unable to rename $tmp to $to: $!";
}

1;
