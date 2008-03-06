borrow $TARGET;
push @FILES, $TARGET;
setattr(cdeps => run('lib-cdeps', $TARGET->name));
