mktemp_out_=
mktemp_in_=
mktemp_() {
  mktemp_in_=$1; shift
  if mktemp_out_=`mktemp $@ -t "$mktemp_in_" 2>/dev/null`; then
    echo "$mktemp_out_"
    return 0
  fi
  mktemp $@ $2 /tmp/"$mktemp_in_"
}

mktemp_dir_() {
  mktemp_ "$1" -d
}
