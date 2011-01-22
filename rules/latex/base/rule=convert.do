my ($source, @options) = cat($RULEDATA);

target;
dependon $source;
formake join(' ', 'convert', @options, $source, $TARGET);
