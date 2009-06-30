# Public domain.

base=${1%.tex}

die() {
  echo $0: $* >&2
  rm -f $base.dvi
  exit 1
}

rm -f $base.aux $base.log $base.toc $base.lof $base.lot
rm -f $base.bbl $base.blg
rm -f $base.gls.aux $base.gls.bbl $base.gls.blg

echo @@LATEX@@ $base.tex
@@LATEX@@ $base.tex || die "latex returned non-zero"

for sanity in 1 2 3 4 5; do
  if fgrep 'Package gloss Warning:' $base.log; then
    echo bibtex $base.gls
    bibtex $base.gls || die "glotex returned non-zero"
  fi
  if fgrep 'LaTeX Warning: Citation' $base.log ||
     fgrep "No file $base.bbl" $base.log; then
    echo bibtex $base
    bibtex $base || die "bibtex returned non-zero"
  fi
  if fgrep 'LaTeX Warning:' $base.log || \
     fgrep 'No file' $base.log; then 
    echo @@LATEX@@ $base.tex
    @@LATEX@@ $base.tex || die "latex returned non-zero"
  else
    exit 0
  fi
done

die "exceeded maximum sanity"
