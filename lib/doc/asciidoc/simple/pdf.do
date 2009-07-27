dependon 'ASCIIDOC';
target;
dependon map { "$_.pdf" } cat('ASCIIDOC');
