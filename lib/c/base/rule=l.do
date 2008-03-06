my @objs = cat($RULEDATA);

target;
dependon 'makelib', @objs;
formake wrap('./makelib', $TARGET, @objs);
