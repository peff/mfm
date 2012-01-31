my $prefix = "";
foreach my $p (qw(Documentation)) {
  if (-d $p) {
    $prefix = "$p/";
    last;
  }
}

my @sections;
my @manpages;
foreach my $section (1) {
  trydepend("MFM-MAN$section")
    or next;
  my @deps = map { "$prefix$_.$section" } cat("MFM-MAN$section");
  push @manpages, @deps;
  push @sections, [$section, @deps];
}

setattr sections => @sections;
target;
dependon @manpages;
