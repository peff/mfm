# Public domain.

die() {
  echo do_install: fatal: "$@" >&2
  exit 111
}

d() {
  owner=
  group=
  if test "$2" -ne "-1"; then
    owner="-o $2"
  fi
  if test "$3" -ne "-1"; then
    group="-o $3"
  fi

  $install_verbose echo Creating directory "$1"
  install -d -m $4 $owner $group "${DESTDIR}$1" \
    || die "unable to make directory $1"
}

cb() {
  owner=
  group=
  if test "$3" -ne "-1"; then
    owner="-o $3"
  fi
  if test "$4" -ne "-1"; then
    group="-o $4"
  fi

  $install_verbose echo Copying file "$1"
  install -c -m $5 $owner $group $2 "${DESTDIR}$1" \
    || die "unable to install file $1"
}

c() {
  cb "$1/$2" "$2" "$3" "$4" "$5"
}

install_verbose_on() {
  install_verbose=
}

install_verbose_off() {
  install_verbose=:
}

install_verbose_off
if test -z "$1"; then
  hier
else
  for i in "$@"; do
    hier_$i
  done
fi
