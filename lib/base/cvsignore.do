finalize sub {
  push @CLEAN, '.cvsignore';
  my @manual = cat_lines('CVSIGNORE') if -r 'CVSIGNORE';
  my @files = ('Makefile', 'FILES', 'CLEAN', 'REALLYCLEAN',
    @manual, @CLEAN, @REALLYCLEAN, grep { $_->visible } targets);
  write_file('.cvsignore', @files);
}
