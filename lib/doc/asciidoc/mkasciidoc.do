target;
dependon qw(warn-auto.sh conf-asciidoc);

formake atomic(
  q(cat warn-auto.sh),
  q(echo exec "`head -n 1 conf-asciidoc`" '-o "$$1" "$$2"')
);
formake "chmod +x $TEMPFILE"
