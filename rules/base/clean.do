dependon 'MFM-TARGETS';
priority 99;
target;
formake 'rm -rf `cat MFM-TARGETS`';
push @FILES, 'MFM-TARGETS';
