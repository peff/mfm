package Error::Base;
use strict;
use overload '""' => \&stringify;

sub new {
  my $self = bless {}, shift;
  $self->{msg} = shift;
  return $self;
}

sub stringify {
  my $self = shift;
  return $self->{msg};
}

1;
