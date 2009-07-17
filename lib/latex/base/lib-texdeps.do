setattr run =>
sub {
  my $fn = shift;

  open(my $fh, '<', $fn)
    or die "unable to open $fn: $!";

  my @deps = ($fn);
  while(<$fh>) {
    chomp;
    if(/^\\([a-zA-Z]+)(?:\[[^\]]*\])?{([^}]*)}(?: *%% *)?([A-Z]+)?/) {
      my($macro, $arg) = ($1, $2);
      my $depend = defined($3) && ($3 eq 'DEPEND');
      my $nodepend = defined($3) && ($3 eq 'NODEPEND');

      if($macro =~ /^(documentclass|LoadClass(WithOptions)?)$/ && $depend) {
        push @deps, "$arg.cls";
      }
      elsif($macro =~ /^(usepackage|RequirePackage(WithOptions)?)$/ && $depend) {
        push @deps, "$arg.sty";
      }
      elsif($macro =~ /^include.*graphics$/ && !$nodepend) {
        push @deps, ($arg =~ /\./ ? $arg : "$arg.eps");
      }
      elsif($macro =~ /^(include|input)$/ && !$nodepend) {
        push @deps, "$arg.tex";
      }
      elsif($macro =~ /^verbatiminput.*$/ && !$nodepend) {
        push @deps, $arg;
      }
      elsif($macro eq 'bibliography' && !$nodepend) {
        push @deps, map { "$_.bib" } split /,/, $arg;
      }
      elsif($macro eq 'bibliographystyle' && $depend) {
        push @deps, "$arg.bst";
      }
      elsif($macro eq 'printgloss' && $depend) {
        if($arg =~ /.*,(.*)/) {
          push @deps, "$1.bib";
        }
      }
    }
  }

  return @deps;
}
