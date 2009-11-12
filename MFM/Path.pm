package MFM::Path;
use strict;
use MFM::File; # DEPEND
use MFM; # DEPEND

my @PATH = split /:/, $ENV{MFM_PATH};
eval {
require AutoHome; # DEPEND
push @PATH, "$AutoHome::HOME/share/mfm";
};

my $borrow;
sub borrow {
  $borrow ||= [MFM::uniq(MFM::File::expand('MFM-RULES', @PATH))];
  return @$borrow;
}

sub rule {
  return ('.', borrow);
}

1;
