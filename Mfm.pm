package Mfm;
use strict;
use File::Path;
use File::Basename;
use File::Copy;
use Mfm::Path; # DEPEND
use Mfm::Target; # DEPEND
use base qw(Exporter);
our @EXPORT;

our $DEBUG = $ENV{MFM_DEBUG} || $ENV{DEBUG} || 0;
my @PATH = split /:/, $ENV{MFM_PATH};

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

sub safe_copy {
  use File::stat;
  my $from = shift;
  my $to = shift;
  my $tmp = "$to.tmp";

  my $st = stat($from) or die "unable to stat $from: $!";
  my $fh = IO::File->new($tmp, 'w')
    or die "unable to open $tmp for writing: $!";
  chmod($st->mode, $tmp) or die "unable to set mode of $tmp: $!";
  copy($from, $fh)
    or die "unable to copy $from to $tmp: $!";
  utime($st->atime, $st->mtime, $tmp)
    or die "unable to set mtime of $tmp: $!";
  rename($tmp, $to)
    or die "unable to rename $tmp to $to: $!";
}

push @EXPORT, qw(borrow);
sub borrow {
  my $to = shift;
  return if -e $to;
  my $src = shift || $to;

  my $base = basename($src);
  foreach my $dir (Mfm::Path::borrow) {
    foreach my $from (uniq("$dir/$src", "$dir/$base")) {
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
  return Mfm::Target::_get(@_);
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
  return Mfm::Target::_wrap(@_);
}

push @EXPORT, qw(targets);
sub targets {
  return sort values(%Mfm::Target::TARGETS);
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
  $TARGET->set_rule($rule);
  $TARGET->run_rules;
}

1;
