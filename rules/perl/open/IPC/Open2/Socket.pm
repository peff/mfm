package IPC::Open2::Socket;
use strict;
use base qw(Exporter);
our @EXPORT = qw(open2_socket);

sub open2_socket {
  use Socket;
  use POSIX;
  my ($local, $remote);
  socketpair($local, $remote, AF_UNIX, SOCK_STREAM, PF_UNSPEC)
    or die "unable to create socket: $!";
  my $pid = fork();
  defined $pid or die "unable to fork: $!";
  if (!$pid) {
    close($local);
    dup2(fileno($remote), 0) or die "dup2: $!";
    dup2(fileno($remote), 1) or die "dup2: $!";
    close($remote);
    exec @_;
    die "unable to exec $_[0]: $!";
  }
  close($remote);
  return $local;
}
