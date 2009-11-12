out="$1"; shift
head="$1"; shift
( cat "$head"
  for i in "$@" ; do
    echo "#line 1 \"$i\""
    cat $i || exit 1
  done
) > "$out.tmp"
sh -n "$out.tmp" || exit 1
chmod +x "$out.tmp" || exit 1
mv "$out.tmp" "$out"
