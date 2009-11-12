my @source = (
  (-e 'MFM-PERLHEADER' ? cat('MFM-PERLHEADER') : ()),
  cat($RULEDATA),
  "$TARGET.pl"
);
@source = uniq(map { $_, get($_)->getattr_recurse('perldeps') } @source);

if(grep { /\.pm$/ } @source) {
  unshift @source, 'static.plib';
}

target;
dependon qw(mkperl), @source;
formake wrap('./mkperl', $TARGET, @source);
