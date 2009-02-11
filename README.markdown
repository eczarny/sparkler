# Sparkler

A simple, Sparkle-powered, software updater.

# What if I find a bug, or what if I want to help?

Please, contact me with any questions, comments, suggestions, or problems. I try
to  make  the  time  to  answer  every  request.  If you find a bug, it would be
helpful to also provide steps to reproduce the problem.

Those  wishing  to  contribute  to  the  project  should  begin by obtaining the
latest source with Git:

    $ git clone git://github.com/eczarny/sparkler.git Sparkler

Now that you have a copy of the project, create a new local branch:

    $ git checkout -b my-bug-fix

This new branch, my-bug-fix, is where all of your changes should go.

There  is  always  the possibility that new changes will be pushed to the remote
repository while you make your changes in the my-bug-fix branch. The best way to
keep  up-to-date  with  these changes is to pull them from the remote repository
and use them as the new base for the my-bug-fix branch:

    $ git checkout master
    $ git pull
    $ git rebase master my-bug-fix

The changes from the remote repository are pulled into your local master branch,
providing  you with the most recent base to apply your changes. The changes from
your my-bug-fix branch will then use the most recent changes you pulled from the
remote repository as their base.

Finally, create the patch that you plan on submitting:

    $ git format-patch master --stdout > my-bug-fix.diff

This  patch,  my-bug-fix.diff, now contains all of your changes. Please, be sure
to provide your patch with a detailed description of your changes.

# Acknowledgments

The preferences controller was designed with Matt Gemmel's SS_PrefsController as
a template, much of his work resides in this controller.

Please refer to the LICENSES file for third-party license information.

# License

Copyright (c) 2008 Eric Czarny.

Sparkler should be accompanied by a LICENSE file, this file contains the license
relevant to this distribution.

If no LICENSE exists please contact Eric Czarny <eczarny@gmail.com>.
