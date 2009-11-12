finalize sub {
  push @CLEAN, 'MFM-TARGETS';
  write_file('MFM-TARGETS', grep { $_->visible } targets);
}
