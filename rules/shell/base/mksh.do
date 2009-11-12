target;
dependon qw(warn-auto.sh mksh.sh);
formake atomic("cat warn-auto.sh mksh.sh");
formake "chmod +x $TEMPFILE";
