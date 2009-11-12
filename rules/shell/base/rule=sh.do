my @deps = cat($RULEDATA);

target;
dependon 'mksh', 'warn-auto.sh', "$TARGET.sh", @deps;
formake wrap('./mksh', $TARGET, 'warn-auto.sh', @deps, "$TARGET.sh");
