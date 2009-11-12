my $base = replace_ext($TARGET, 'dvi');
my $src = "$base.tex";

extragen "$base.gls.aux";
extragen "$base.gls.bbl";
extragen "$base.gls.blg";
extragen "$base.bbl";
extragen "$base.blg";
extragen "$base.log";
extragen "$base.out";
extragen "$base.toc";
extragen "$base.lof";

foreach my $t (uniq($src, get($src)->getattr_recurse('texdeps'))) {
  if($t =~ /\.tex/) {
    extragen(replace_ext($t, 'tex', 'aux'));
  }
}

target;
dependon qw(mklatex), get($src)->getattr_recurse('texdeps');
formake "./mklatex $src";
