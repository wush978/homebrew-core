class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.117.tar.gz"
  sha256 "f4dc5135dec35199583ad4770b184e057c67fe8ddae6a0bf5dfca71640447743"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2f1c9e84233b300a0db07f16f32bee791ac5e1d6a08f6b0dc2e0e260f719468" => :sierra
    sha256 "04de2777178e8ddcd61af3befa9d27b5a8b3424420b4d80b5d68c94dcc6582ac" => :el_capitan
    sha256 "64fcea9641458e81a121e75f240447c995d07d673097da2f7148c18fdabd985f" => :yosemite
    sha256 "347a290c9d5c214e295d2d648058fc8df0494c8067a8c5c59b9f2153ec6e5df9" => :x86_64_linux
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  depends_on "libyaml" unless OS.mac?

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
