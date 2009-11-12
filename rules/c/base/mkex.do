target;
dependon qw(warn-auto.sh conf-ld);

formake atomic(
  q(cat warn-auto.sh),
  q(echo 'main="$$1"; shift'),
  q(echo exec "`head -n 1 conf-ld`" '-o "$$main" "$$main".o $${1+"$$@"}')
);
formake "chmod 755 $TEMPFILE";
