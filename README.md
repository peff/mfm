mfm -- The MakeFile Maker
=========================

mfm is a program for automatically generating Makefiles. Its goals are:

   * to create portable Makefiles that will work with all POSIX-compliant
     versions of make

   * to minimize the effort required by the writer of the Makefile

   * to be easily extensible

mfm consists of a Perl script and a set of reusable rule templates, also
written in Perl. For each item to be built, a software author specifies
a rule template and its parameters; the mfm program uses this
information to build a Makefile. The Makefile is distributed with the
source code; an end-user of the package doesn't need to have any special
software installed. The system can be extended by writing new rule
templates.

mfm works in a top-down way. You specify the targets you want built, and
it deduces how to build them either from target-specific rules, rule
templates, implicit rules based on the target's extension, or default
rules. The bundled rules can handle complex situations like automatic
dependency generation for C header files, user build parameters,
selecting platform-dependent code, and more.

See the entries in Documentation/ for more details, including an idea of
what mfm's input looks like.

mfm is self-hosting. To install it:

   1. Clone the repository.

   2. Run `./bootstrap` to build the Makefile.

   3. (Optional) Edit conf-\* for any non-standard parameters.

   4. Run `make install` to install.

Send questions or comments to peff@peff.net.
