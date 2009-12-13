package Editor;
use strict;

sub guess {
  foreach my $e ($ENV{VISUAL}, $ENV{EDITOR}, 'vi') {
    return $e if defined $e;
  }
}

1;
