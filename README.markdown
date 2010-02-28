# Sparkler

A simple, Sparkle-powered, software updater.

# Requirements

Sparkler has been built, and designed, for Mac OS X 10.5 or later.

In  order  to  build  Sparkler please download the [Sparkle] [1] source code and
make the following header files public:

  * SUAppcast
  * SUAppcastItem
  * SUHost

Once Sparkle has been built with the necessary changes copy it to:

    /Library/Frameworks/

Finally,  please  be  sure to download and install [RegexKit] [2]. If everything
worked the Xcode build should succeed.

# What if I find a bug, or what if I want to help?

Please, contact me with any questions, comments, suggestions, or problems. I try
to  make the time to answer every request.

Those  wishing to contribute to the project should begin by obtaining the latest
source  with  Git. The project is hosted on GitHub, making it easy for anyone to
make contributions. Simply create a fork and make your changes.

# Acknowledgments

The preferences window controller is based on software provided by Matt Gemmel.

Please refer to the LICENSES file for third-party license information.

# License

Copyright (c) 2010 Eric Czarny.

Sparkler  should  be  accompanied  by  a  LICENSES  file containing the licenses
relevant to this distribution.

If no LICENSES exists please contact Eric Czarny <eczarny@gmail.com>.

[1]: http://sparkle.andymatuschak.org/
[2]: http://regexkit.sourceforge.net/
