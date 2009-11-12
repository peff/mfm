my ($data, @deps) = cat($RULEDATA);
my ($type, $prog, $opt1, $opt2) = (split / +/, $data);

$opt1 ||= "${TARGET}1";
$opt2 ||= "${TARGET}2";

target;
dependon 'choose';
dependon 'compile' if($type =~ /c/);
dependon 'mkex' if($type =~ /l/);
dependon "$prog.c", $opt1, $opt2;
formake atomic("./choose $type $prog $opt1 $opt2");

setattr(cdeps => @deps);
