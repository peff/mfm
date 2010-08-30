my ($command, @deps) = cat($RULEDATA);
my ($prog) = (split / /, $command)[0];
target;
dependon $prog if $prog =~ s,^\./,,;
dependon @deps;
formake atomic($command);
