class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.13.1/docutils-0.13.1.tar.gz"
  sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6818d075546c76d51350b02b1ca003ca1ffe1b1eb36ba6ad82073ca65898087f" => :sierra
    sha256 "68facf0a5a3540d63e554dd5225683ca514193823468038d8ef0f6a7d7204c25" => :el_capitan
    sha256 "f889bbf58533bd947c0b5db906e7e1a8f3ec8439f13f6532b33f8d325a83a380" => :yosemite
    sha256 "4aabe59f179ca81e0d3c095b2bb0660d71be89cbead3472d10b463051c8fbbec" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python2.7/site-packages" unless OS.mac?
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
