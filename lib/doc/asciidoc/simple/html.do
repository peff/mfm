dependon 'ASCIIDOC';
target;
dependon map { "$_.html" } cat('ASCIIDOC');
