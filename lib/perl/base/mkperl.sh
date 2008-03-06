out="$1"; shift
(echo '#!@PERL@';
 echo '# WARNING: This file was auto-generated. Do not edit!'
 for i in "$@"; do
   case "$i" in
     *.pm) ;;
     *)
       echo "#line 1 \"$i\""
       cat "$i" || exit 1
       ;;
   esac
 done
 echo '__END__'
 for i in "$@"; do
   case "$i" in
     *.pm)
       echo "__STATIC_INCLUDE__ $i"
       cat "$i" || exit 1
       echo '__END__'
       ;;
   esac
 done
) > "$out.tmp" || exit 1
@PERL@ -c -Mwarnings=FATAL,all "$out.tmp" || exit 1
chmod 755 "$out.tmp" || exit 1
mv "$out.tmp" "$out"
