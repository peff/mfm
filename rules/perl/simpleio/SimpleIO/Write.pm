package SimpleIO::Write;
use strict;
use base qw(Exporter);
our @EXPORT = qw(write_file write_file_lines write_file_scalar
                 append_file append_file_lines append_file_scalar);
use IO::File;

sub _doit {
  my $mode = shift;
  my $f = shift;

  my $fh = ref($f) ? $f : IO::File->new($f, $mode);
  $fh or die "unable to open $f for writing: $!";
  $fh->print(join('', @_)) && $fh->flush
    or die "unable to write to $f: $!";
}

sub write_file_scalar { _doit('w', @_) }
sub append_file_scalar { _doit('a', @_) }
sub write_file_lines { my $f = shift; _doit('w', $f, join("\n", @_) . "\n") }
sub append_file_lines { my $f = shift; _doit('a', $f, join("\n", @_) . "\n") }
sub write_file { write_file_lines(@_) }
sub append_file { append_file_lines(@_) }
