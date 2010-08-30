my @deps = cat($RULEDATA);

target;
dependon 'mkbash', 'warn-auto.bash', "$TARGET.bash", @deps;
formake wrap('./mkbash', $TARGET, 'warn-auto.bash', @deps, "$TARGET.bash");
