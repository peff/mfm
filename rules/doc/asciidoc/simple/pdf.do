dependon 'MFM-ASCIIDOC';
target;
dependon map { "$_.pdf" } cat('MFM-ASCIIDOC');
