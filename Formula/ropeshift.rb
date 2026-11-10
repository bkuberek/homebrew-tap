# The Homebrew formula for ropeshift. scripts/homebrew-formula.sh renders it for each release from the
# release's checksums.txt, and a maintainer commits the result to the project's tap
# (docs/releasing.md). A formula, not a cask, because only a formula's service block is what
# `brew services` runs (ADR-0001).
class Ropeshift < Formula
  desc "Self-hosted software factory that runs supervised agent CLIs"
  homepage "https://ropeshift.com/"
  version "0.1.0-alpha.5"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.5/ropeshift_0.1.0-alpha.5_darwin_arm64.tar.gz"
      sha256 "680ca800fa04a0d7e5369ab1995547c3ccc125acac1898664bda97a939db8bf9"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.5/ropeshift_0.1.0-alpha.5_darwin_amd64.tar.gz"
      sha256 "2f6aaca2aa23c59f7d35d0753bba1d57e9b43dc92b96a216feecd26ac94a5a43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.5/ropeshift_0.1.0-alpha.5_linux_arm64.tar.gz"
      sha256 "656bffdbb9cc929a71ded6e944b4a1b8300e60141eddb3ed6d6718749731ff47"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.5/ropeshift_0.1.0-alpha.5_linux_amd64.tar.gz"
      sha256 "2ba3131ff4fb539f5f6d2c9e201949fbaeac941ad8b26900bf842e2c998eecad"
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
