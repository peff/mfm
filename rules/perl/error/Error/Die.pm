package Error::Die;
use strict;
use Error::Base; # DEPEND

use vars qw($FATAL $DEBUG @CLEANUP);

sub die {
  if(ref $_[0]) {
    CORE::die @_;
  }
  else {
    my $s = join(' ', @_);
    chomp $s;
    CORE::die Error::Base->new($DEBUG > 0 ? Carp::longmess($s) : $s);
  }
}

sub catch_top {
  CORE::die @_ if $^S || !defined($^S);
  print STDERR "$FATAL@_\n";
  $_->() foreach @CLEANUP;
  exit 111;
}

BEGIN {
  *CORE::GLOBAL::die = \&die;
  use Carp;
  my $prog = $0 =~ m!/([^/]*)$! ? $1 : $0;
  $FATAL = "$prog: fatal: ";
  $DEBUG = $ENV{DEBUG} || 0;
}

INIT {
  $SIG{__DIE__} = \&catch_top;
}

sub import {
  my $class = shift;
  $FATAL ||= shift;
}

1;
