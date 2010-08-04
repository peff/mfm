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

sub _expand_components {
  local $_ = shift;

  my @path = split /\//;
  my @expanded;
  do {
    push @expanded, join('/', @path);
    shift @path;
  } while(@path);

  return @expanded;
}

sub components {
  my @expanded = map { [_expand_components($_)] } @_;

  my @r;
  while (@expanded) {
    my $e = pop @expanded;
    push @r, pop(@$e);
    push @expanded, $e if @$e;
  }

  return @r;
}

1;
