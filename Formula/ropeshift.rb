# The Homebrew formula for ropeshift. scripts/homebrew-formula.sh renders it for each release from the
# release's checksums.txt, and a maintainer commits the result to the project's tap
# (docs/releasing.md). A formula, not a cask, because only a formula's service block is what
# `brew services` runs (ADR-0001).
class Ropeshift < Formula
  desc "Self-hosted software factory that runs supervised agent CLIs"
  homepage "https://ropeshift.com/"
  version "0.1.0-alpha.13"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.13/ropeshift_0.1.0-alpha.13_darwin_arm64.tar.gz"
      sha256 "f3ca3b650f5a0b931c2eec344ef7e45d242ab095347a641a0690d5348a283f94"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.13/ropeshift_0.1.0-alpha.13_darwin_amd64.tar.gz"
      sha256 "f8f9e66b92ee02003320e8c0a911c0aced2b4e9d34f06db7b5c6bccf8a2a6758"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.13/ropeshift_0.1.0-alpha.13_linux_arm64.tar.gz"
      sha256 "8e05c3fd01b7a50e28e9ee1be6efc7a6bbab9cf6617e36e844b7fd4e71a0c624"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.13/ropeshift_0.1.0-alpha.13_linux_amd64.tar.gz"
      sha256 "07fb2d4c223e4143a78d08866619dcb09afab3c8799b1c8c7b1de513746dae25"
    end
  end

  # One binary, and the name a process starts under picks the command (D5).
  def install
    bin.install "ropeshift"
    bin.install_symlink "ropeshift" => "ropeshiftd"
  end

  # launchd throttles a job with no process class, so the daemon runs as an interactive one.
  service do
    run [opt_bin/"ropeshiftd", "solo"]
    keep_alive true
    process_type :interactive
    environment_variables PATH: std_service_path_env
    log_path var/"log/ropeshift.log"
    error_log_path var/"log/ropeshift.log"
  end

  def caveats
    <<~EOS
      Ropeshift runs git, tmux for interactive lanes, and the agent CLIs you install and sign in to.

      `brew services start ropeshift` runs the daemon with no repository source. To name sources, run
        ropeshift service install -- --source /path/to/repository
      instead. Use one or the other: two daemons for one installation conflict.
    EOS
  end

  test do
    assert_match "\"version\":\"v#{version}\"", shell_output("#{bin}/ropeshift version --json")
    assert_match "\"command\":\"ropeshiftd\"", shell_output("#{bin}/ropeshiftd version --json")
  end
end
