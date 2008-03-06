my ($var, $src) = cat($RULEDATA);
my $package = $TARGET->name;
$package =~ s#/#::#g;
$package =~ s/\.pm$//;

target;
dependon $src;
formake atomic(
    qq(echo 'package $package;'),
    qq(echo "our \\\$\$$var = '`head -n 1 $src`';"),
    qq(echo '1;')
);
