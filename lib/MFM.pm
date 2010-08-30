package MFM;
use strict;
use File::Path;
use File::Basename;
use MFM::Path; # DEPEND
use MFM::Target; # DEPEND
use Error::Multi; # DEPEND
use SimpleIO::Copy; # DEPEND
use base qw(Exporter);
our @EXPORT;

our $DEBUG = $ENV{MFM_DEBUG} || $ENV{DEBUG} || 0;

our $TARGET; push @EXPORT, '$TARGET';
our $RULEDATA; push @EXPORT, '$RULEDATA';
our $TEMPFILE; push @EXPORT, '$TEMPFILE';
our @FILES; push @EXPORT, '@FILES';
our @CLEAN; push @EXPORT, '@CLEAN';
our @REALLYCLEAN; push @EXPORT, '@REALLYCLEAN';

push @EXPORT, qw(uniq);
sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}

push @EXPORT, qw(dependon);
sub dependon {
  $TARGET->deps(@_) if $TARGET->visible;
  foreach my $t (@_) {
    get($t)->run_rules;
  }
}

push @EXPORT, qw(borrow);
sub borrow {
  my $to = shift;
  return if -e $to;
  my $src = shift || $to;

  foreach my $search (MFM::Path::components($src)) {
    foreach my $dir (MFM::Path::borrow) {
      my $from = "$dir/$search";
      if(-e $from) {
        push @CLEAN, mkpath(dirname($to));
        push @CLEAN, $to;
        safe_copy($from, $to);
        return;
      }
    }
  }

  die "unable to find $to";
}

push @EXPORT, qw(priority);
sub priority {
  $TARGET->priority(shift);
}

push @EXPORT, qw(target);
sub target {
  if(@_) {
    $TARGET = get(shift);
    $TEMPFILE = $TARGET->tempfile;
  }
  $TARGET->visible(1);
}

push @EXPORT, qw(get);
sub get {
  return MFM::Target::_get(@_);
}

push @EXPORT, qw(formake);
sub formake {
  if($TARGET->visible) {
    $TARGET->commands(@_);
  }
  else {
    $TARGET->output(@_);
  }
}

push @EXPORT, qw(atomic);
sub atomic {
  $TARGET->output(join(' ', "\tmv", $TARGET->tempfile, $TARGET->name));
  return undef unless @_;
  return "$_[0] > $TEMPFILE" unless @_ > 1;
  return '( ' . join(" && \\\n  ", @_) . " \\\n) > $TEMPFILE";
}

push @EXPORT, qw(wrap);
sub wrap {
  return MFM::Target::_wrap(@_);
}

push @EXPORT, qw(targets);
sub targets {
  return sort values(%MFM::Target::TARGETS);
}

push @EXPORT, qw(finalize);
sub finalize {
  $TARGET->finalize(@_)
}

push @EXPORT, qw(setattr);
sub setattr {
  $TARGET->setattr(@_)
}

push @EXPORT, qw(run);
sub run {
  my $target = shift;
  my ($fun, @args) = get($target)->getattr('run')
    or die "attempt to 'run' target with no run attribute: $target";
  $fun->(@args, @_);
}

push @EXPORT, qw(alias);
sub alias {
  my $rule = shift;
  eval {
    $TARGET->set_rule($rule);
    $TARGET->run_rules;
  };
  $@ and die $DEBUG ? $@ : $@->{child};
}

push @EXPORT, qw(trydepend_init trydepend trydepend_die);
my @TRYDEPEND_EXCEPTIONS;
sub trydepend_init {
  @TRYDEPEND_EXCEPTIONS = ();
}
sub trydepend {
  eval {
    dependon @_;
  };
  return 1 unless $@;
  push @TRYDEPEND_EXCEPTIONS, $@;
  return 0;
}
sub trydepend_die {
  my $m = shift;
  die Error::Multi->new($m, @TRYDEPEND_EXCEPTIONS);
}

push @EXPORT, qw(extragen);
sub extragen {
  get($_)->visible(1) foreach @_;
}

push @EXPORT, qw(replace_ext);
sub replace_ext {
  local $_ = shift;
  my $old = shift || '[^.]+';
  my $new = shift;

  if(s/\.\Q$old\E$// && defined $new) {
    $_ .= ".$new";
  }
  return $_;
}


1;
