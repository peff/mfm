package Mfm::Path;
use strict;
use Mfm::File; # DEPEND
use Mfm; # DEPEND

my @PATH = split /:/, $ENV{MFM_PATH};
eval {
require AutoHome; # DEPEND
push @PATH, "$AutoHome::HOME/share/mfm";
};

my $borrow;
sub borrow {
  $borrow ||= [Mfm::uniq(Mfm::File::expand('MFM-RULES', @PATH))];
  return @$borrow;
}

sub rule {
  return ('.', borrow);
}

1;
