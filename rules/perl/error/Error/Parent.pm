package Error::Parent;
use strict;
use overload '""' => \&stringify;

sub new {
  my $self = bless {}, shift;
  $self->{msg} = shift;
  $self->{child} = shift;
  return $self;
}

sub stringify {
  my $self = shift;
  return "$self->{child}\n  $self->{msg}";
}

1;
