package Mfm::Client;
use strict;
use base qw(Exporter);
our @EXPORT = qw(
@FILES
@CLEAN
@REALLYCLEAN
$TARGET
$RULEDATA
$TEMPFILE
dependon
uniq
);

our @FILES;
our @CLEAN;
our @REALLYCLEAN;

our %TARGETS;
our $TARGET;
our $RULEDATA;
our $TEMPFILE;

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}

sub dependon {
  if(defined $TARGET) {
    my $t = $TARGETS{$TARGET};
    $t->deps(@_) if $t && $t->makefile_target;
  }

  foreach my $t (@_) {
    run_rules($t);
  }
}

1;
