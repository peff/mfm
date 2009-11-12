dependon 'MFM-ASCIIDOC';
target;
dependon map { "$_.html" } cat('MFM-ASCIIDOC');
