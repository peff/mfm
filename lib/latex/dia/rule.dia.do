borrow $TARGET;
push @FILES, $TARGET;
setattr(diadeps => run('lib-diadeps', $TARGET->name));
