my $data = join(' ', qw(warn-auto.sh), cat_scalar($RULEDATA));
alias 'rule=replace.do', \$data;
formake "chmod 755 $TEMPFILE";
