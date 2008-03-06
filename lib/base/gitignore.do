finalize sub {
  push @CLEAN, '.gitignore';
  my @manual = cat_lines('GITIGNORE') if -r 'GITIGNORE';
  my @files = ('Makefile', 'FILES', 'CLEAN', 'REALLYCLEAN',
    @manual, @CLEAN, @REALLYCLEAN, grep { $_->visible } targets);
  write_file('.gitignore', @files);
}
