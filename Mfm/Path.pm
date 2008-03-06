package Mfm::Path;
use strict;
use Mfm::File; # DEPEND
use Mfm; # DEPEND
use AutoHome; # DEPEND

my @PATH = split /:/, $ENV{MFM_PATH};
push @PATH, "$AutoHome::HOME/share/mfm";

my $borrow;
sub borrow {
  $borrow ||= [Mfm::uniq(Mfm::File::expand('MFM', @PATH))];
  return @$borrow;
}

sub rule {
  return ('.', borrow);
}

1;
