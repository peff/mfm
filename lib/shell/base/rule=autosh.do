my ($var, $src) = cat($RULEDATA);

target;
dependon $src;
formake atomic(qq(echo "$var=\\"`head -n 1 $src`\\""));
