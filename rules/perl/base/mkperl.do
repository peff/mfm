target;
dependon qw(conf-perl warn-auto.sh mkperl.sh);
formake atomic(
    'cat warn-auto.sh',
    q#sed 's}@PERL@}'"`head -n 1 conf-perl`"'}g' < mkperl.sh#
);
formake "chmod 755 $TEMPFILE"
