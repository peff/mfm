finalize sub {
  push @CLEAN, '.gitignore';
  my @manual = cat_lines('MFM-GITIGNORE') if -r 'MFM-GITIGNORE';
  my @files = ('Makefile', 'MFM-FILES', 'MFM-CLEAN', 'MFM-REALLYCLEAN',
    @manual, @CLEAN, @REALLYCLEAN, grep { $_->visible } targets);
  write_file('.gitignore', map { "/$_" } @files);
}
