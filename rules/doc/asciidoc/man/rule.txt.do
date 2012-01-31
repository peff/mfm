borrow $TARGET;
push @FILES, $TARGET;
setattr(txtdeps => run('lib-txtdeps', $TARGET->name));
