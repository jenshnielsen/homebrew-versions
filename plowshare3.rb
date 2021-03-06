require 'formula'

class Plowshare3 < Formula
  homepage 'http://code.google.com/p/plowshare/'
  url 'https://plowshare.googlecode.com/files/plowshare3-snapshot-git20131009.55e67de.tar.gz'
  version '3.GIT-55e67de'
  sha1 '6acb3a2264de6fc1e516ed4574028cc4a94e9fa6'

  head 'https://code.google.com/p/plowshare/', :using => :git

  conflicts_with 'plowshare'

  depends_on 'recode'
  depends_on 'imagemagick'
  depends_on 'tesseract'
  depends_on 'spidermonkey'
  depends_on 'aview'
  depends_on 'coreutils'
  depends_on 'gnu-sed'
  depends_on 'gnu-getopt'

  def patches
    DATA
  end

  def install
    ENV["PREFIX"] = prefix
    system "bash setup.sh install"
  end

  def caveats; <<-EOS.undent
    The default installation of imagemagick does not enable
    X11 support. plowshare uses the display command which does
    not work if X11 support is not enabled. To enable:
      brew remove imagemagick
      brew install imagemagick --with-x
    EOS
  end
end

# This patch makes sure GNUtools are used on OSX.
# gnu-getopt is keg-only hence the backtick expansion.
# These aliases only exist for the duration of plowshare,
# inside the plowshare shells. Normal operation of bash is
# unaffected - getopt will still find the version supplied
# by OSX in other shells, for example.
__END__
--- a/src/core.sh
+++ b/src/core.sh
@@ -1,4 +1,8 @@
 #!/bin/bash
+shopt -s expand_aliases
+alias sed='gsed'
+alias getopt='`brew --prefix gnu-getopt`/bin/getopt'
+alias head='ghead'
 #
 # Common set of functions used by modules
 # Copyright (c) 2010 - 2011 Plowshare team
