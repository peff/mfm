my $prefix = get('lib-perldeps')->getattr('prefix');

my @sed = (
   q(-e "s}@PERL@}`head -n 1 conf-perl`}g"),
  qq(-e "s}\@PREFIX@}$prefix}g"),
   q(< mkperl.sh)
 );

target;
dependon qw(conf-perl warn-auto.sh mkperl.sh);
formake atomic(
    'cat warn-auto.sh',
    'sed' . join('', map { " \\\n  $_" } @sed)
);
formake "chmod 755 $TEMPFILE"
