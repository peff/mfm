my ($var, $src) = cat($RULEDATA);

target;
dependon 'auto-str', $src;
formake atomic(qq(./auto-str $var "`head -n 1 $src`"));
