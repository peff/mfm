which_out_=
which_() {
  if ! which_out_=`which "$1" 2>/dev/null`; then
    return 100
  fi
  case "$which_out_" in
    # Solaris.
    "no $1 in") return 100 ;;
  esac
  echo "$which_out_"
  return 0;
}
