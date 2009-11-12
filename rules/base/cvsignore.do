finalize sub {
  push @CLEAN, '.cvsignore';
  my @manual = cat_lines('MFM-CVSIGNORE') if -r 'MFM-CVSIGNORE';
  my @files = ('Makefile', 'MFM-FILES', 'MFM-CLEAN', 'MFM-REALLYCLEAN',
    @manual, @CLEAN, @REALLYCLEAN, grep { $_->visible } targets);
  write_file('.cvsignore', @files);
}
