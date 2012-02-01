dependon 'MFM-BINARIES';
write_file('MFM-MAN1', cat('MFM-BINARIES'));
push @CLEAN, 'MFM-MAN1';
