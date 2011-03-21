package MFM::Target;
use strict;
use File::Glob qw(:glob);
use File::Basename;
use Text::Wrap;
use SimpleIO::Cat; # DEPEND
use Error::Parent; # DEPEND
use overload '""' => \&name;
use overload 'cmp' => sub { "$a" cmp "$b" };

our %TARGETS;

sub new {
  my $self = bless {}, shift;
  $self->{name} = shift;
  $self->{deps} = [];
  $self->{commands} = [];
  $self->{priority} = 50;
  $self->{visible} = 0;
  $self->{output} = [];
  $self->{attrs} = {};
  return $self;
}

sub name {
  my $self = shift;
  return $self->{name};
}

sub _list {
  my $what = shift;
  my $self = shift;
  push @{$self->{$what}}, @_;
  return @{$self->{$what}};
}

sub _scalar {
  my $what = shift;
  my $self = shift;
  $self->{$what} = shift if @_;
  return $self->{$what};
}

sub commands { _list(commands => @_) }
sub deps { _list(deps => @_) }
sub output { _list(output => @_) }
sub priority { _scalar(priority => @_) }
sub visible { _scalar(visible => @_) }
sub finalize { _scalar(finalize => @_) }

sub tempfile {
  my $self = shift;
  local $_ = $self->name;
  s/(\.[^.]+)?$/.tmp$1/;
  return $_;
}

sub run_finalize {
  my $self = shift;
  return unless $self->{finalize};

  eval {
    local $MFM::TARGET = $self;
    $self->{finalize}->();
  };
  $@ and die Error::Parent->new("...while finalizing $self", $@);
}

sub write_makefile {
  my $self = shift;
  my $fh = shift;

  if($self->{visible} && ($self->deps || $self->commands)) {
    print $fh "\n";
    print $fh "$self:";
    if($self->deps) {
      print $fh " \\\n";
      print $fh _wrap($self->deps);
    }
    else {
      print $fh "\n";
    }
    print $fh "\t", $_, "\n" foreach (map { split /\n/ } $self->commands);
  }
  if($self->output) {
    print $fh "\n" unless $self->{visible};
    print $fh $_, "\n" foreach $self->output;
  }
}

sub setattr {
  my $self = shift;
  my $k = shift;
  $self->{attrs}->{$k} = [@_];
}

sub getattr {
  my $self = shift;
  my $k = shift;
  $self->run_rules;
  return wantarray ? @{$self->{attrs}->{$k} || []} : $self->{attrs}->{$k}->[0];
}

sub getattr_recurse {
  my $self = shift;
  my $k = shift;

  return () if $self->{getattr_seen}->{$k};
  local $self->{getattr_seen}->{$k} = 1;

  return map { $_, _get($_)->getattr_recurse($k) } $self->getattr($k);
}

sub set_rule {
  my $self = shift;
  $self->{rule} = shift;
}

sub run_rules {
  my $self = shift;

  my $marker = \$self->{run_status}->{$self->{rule} || ''};
  return if $$marker > 1;
  die "circular dependency: $self" if $$marker > 0;
  $$marker = 1;

  my $rule;
  eval {
    ($rule, my $data) = $self->_find_rule;
    $self->_do_rule($rule, $data);
    $$marker = 2;
  };
  $@ and die Error::Parent->new(
    "...while making $self"
      . ($rule
          ? ' (rule: ' . ($MFM::DEBUG > 0 ? $rule : basename($rule)) . ')'
          : ''),
    $@);
}

sub _find_rule {
  my $self = shift;
  my $rule;

  if($self->{rule}) {
    $rule = _lookup_rule($self->{rule})
      or die "unable to find rule $self->{rule}";
    return $rule;
  }

  $rule = _lookup_rule("$self.do", "$self=*");
  if(defined $rule) {
    return $rule if $rule =~ /\.do$/;
    if($rule =~ /.*=(.*)/) {
      my $data = $rule;
      $rule = _lookup_rule("rule=$1.do")
        or die "unable to find rule=$1.do to match $data";
      return ($rule, $data);
    }
  }

  if($self =~ /.*\.(.*)/) {
    $rule = _lookup_rule("rule.$1.do")
      and return $rule;
  }

  $rule = _lookup_rule("default.do")
    and return $rule;

  die "no rule found";
}

sub _lookup_rule {
  foreach my $f (MFM::Path::components(@_)) {
    foreach my $d (MFM::Path::rule()) {
      foreach my $r (bsd_glob("$d/$f", 0)) {
        return $r;
      }
    }
  }
  return undef;
}

my $CODE_NUMBER = 0;
sub _do_rule {
  my ($self, $rule, $data) = @_;

  local $MFM::TARGET = $self;
  local $MFM::TEMPFILE = $self->tempfile;
  local $MFM::RULEDATA = $data;

  $CODE_NUMBER++;
  my $code = "#line 1 $rule\n" .
             "package MFM::Eval$CODE_NUMBER;\n" .
             "use MFM;\n" .
             "use SimpleIO::Cat;\n" .
             "use SimpleIO::Write;\n" .
             cat_scalar($rule);
  eval $code;
  $@ and die $@;
}

sub _get {
  my $name = shift;
  return $TARGETS{$name} ||= MFM::Target->new($name);
}

sub _wrap {
  local $Text::Wrap::columns = 70;
  local $Text::Wrap::huge = 'overflow';
  return join(" \\\n", split /\n/, wrap('','',@_)) . "\n";
}

1;
