finalize sub {
  push @CLEAN, 'TARGETS';
  write_file('TARGETS', grep { $_->visible } targets);
}
