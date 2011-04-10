dependon qw(MFM-PACKAGE);
my ($package) = cat('MFM-PACKAGE');

my $version = `git describe --always HEAD 2>/dev/null`;
if (!$?) {
  chomp $version;
  $version =~ s/^v//;
}
else {
  $version = 'unknown';
}

push @CLEAN, 'MFM-VERSION';
write_file('MFM-VERSION', "$package $version");
