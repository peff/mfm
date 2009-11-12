package Error::Multi;
use strict;
use overload '""' => \&stringify;

sub new {
  my $self = bless {}, shift;
  $self->{msg} = shift;
  $self->{children} = [@_];
  return $self;
}

sub stringify {
  my $self = shift;
  if(@{$self->{children}} > 1) {
    return join("\n", $self->{msg},
        map {
        my $s = "$_";
        $s =~ s/^/    /mg if @{$self->{children}} > 1;
        $s
        } @{$self->{children}});
  }
  else {
    return join(' ', $self->{msg}, @{$self->{children}});
  }
}

1;
