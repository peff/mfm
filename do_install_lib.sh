cd lib
mkdir -p "$auto_home/share/mfm"
tar cf - * | tar -C "$auto_home/share/mfm" -xf -
