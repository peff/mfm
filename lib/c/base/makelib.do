target;
dependon qw(warn-auto.sh);

formake atomic(
  q(cat warn-auto.sh),
  q(echo 'main="$$1"; shift'),
  q(echo 'rm -f "$$main"'),
  q(echo 'ar rcs "$$main" $${1+"$$@"}')
);
formake "chmod +x $TEMPFILE";
