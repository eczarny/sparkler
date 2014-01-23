# Sparkler

A simple, Sparkle-powered, software updater.

# Requirements

Sparkler has been built, and designed, for Mac OS X 10.5 or later.

In order to build Sparkler please download the [Sparkle] [1] source code and make the following header files public:

  * SUAppcast
  * SUAppcastItem
  * SUHost

Once Sparkle has been built with the necessary changes copy it to:

    /Library/Frameworks/

In addition to Sparkle, [RegexKit] [2] and [ZeroKit] [3] are also required when building Sparkler. Place RegexKit in the default location and be sure to put ZeroKit in the same directory as Sparkle.

If everything is in its proper place the Xcode build should succeed.

# What if I find a bug, or what if I want to help?

Please, contact me with any questions, comments, suggestions, or problems. I try to make the time to answer every request.

Those wishing to contribute to the project should begin by obtaining the latest source with Git. The project is hosted on GitHub, making it easy for anyone to make contributions. Simply create a fork and make your changes.

# License

Copyright (c) 2012 Eric Czarny.

Sparkler should be accompanied by a LICENSE file containing the license relevant to this distribution.

If no LICENSE exists please contact Eric Czarny <eczarny@gmail.com>.

[1]: http://sparkle.andymatuschak.org
[2]: http://regexkit.sourceforge.net
[3]: http://github.com/eczarny/zerokit
