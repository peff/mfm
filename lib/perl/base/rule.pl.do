borrow $TARGET;
push @FILES, $TARGET;
setattr(perldeps => run('lib-perldeps', $TARGET));
