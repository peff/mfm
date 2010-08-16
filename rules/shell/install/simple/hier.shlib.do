my @TYPES = (
  ['MFM-BINARIES', 'bin', '0755'],
  ['MFM-SHARE', 'share', '0644'],
);

my @lines;
foreach my $t (@TYPES) {
  my ($file, $dir, $mode) = @$t;
  next unless trydepend($file);
  push @lines, qq(  d "\$auto_home/$dir" -1 -1 0755);
  foreach my $f (cat($file)) {
    push @lines, qq(    c "\$auto_home/$dir" $f -1 -1 $mode);
  }
}

push @lines, cat('MFM-HIEREXTRA') if trydepend('MFM-HIEREXTRA');

push @FILES, 'hier.shlib';
push @CLEAN, 'hier.shlib';
write_file('hier.shlib',
    'hier() {',
    @lines,
    '}'
);
