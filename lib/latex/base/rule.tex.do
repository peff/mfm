borrow $TARGET;
push @FILES, $TARGET;
setattr(texdeps => run('lib-texdeps', $TARGET->name));
