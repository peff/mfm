my @TYPES = (
  ['MFM-BINARIES', 'bin', '0755'],
  ['MFM-SHARE', 'share', '0644'],
);

my @lines;

push @lines, "hier() {";
foreach my $t (@TYPES) {
  my ($file, $dir, $mode) = @$t;
  next unless trydepend($file);
  push @lines, qq(  d "\$auto_home/$dir" -1 -1 0755);
  foreach my $f (cat($file)) {
    push @lines, qq(    c "\$auto_home/$dir" $f -1 -1 $mode);
  }
}
push @lines, "}";

if (trydepend('man')) {
  require File::Basename;

  push @lines, "";
  push @lines, "hier_man() {";
  foreach my $vs (get('man')->getattr('sections')) {
    my ($section, @files) = @$vs;
    my $dir = "\$auto_home/share/man/man$section";
    push @lines, qq(  d "$dir" -1 -1 0755);
    foreach my $f (@files) {
      my $b = File::Basename::basename($f);
      push @lines, qq(    cb "$dir/$b" $f -1 -1 0644);
    }
  }
  push @lines, "}";
}

push @lines, cat('MFM-HIEREXTRA') if trydepend('MFM-HIEREXTRA');

push @FILES, 'hier.shlib';
push @CLEAN, 'hier.shlib';
write_file('hier.shlib', @lines);
