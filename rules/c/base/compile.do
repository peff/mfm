target;
dependon qw(warn-auto.sh conf-cc);
formake atomic(
  q(cat warn-auto.sh),
  q(echo exec "`head -n 1 conf-cc`" '-o $${1%.c}.o -c $${1+"$$@"}')
);
formake "chmod 755 $TEMPFILE";
