# The Homebrew formula for ropeshift. scripts/homebrew-formula.sh renders it for each release from the
# release's checksums.txt, and a maintainer commits the result to the project's tap
# (docs/releasing.md). A formula, not a cask, because only a formula's service block is what
# `brew services` runs (ADR-0001).
class Ropeshift < Formula
  desc "Self-hosted software factory that runs supervised agent CLIs"
  homepage "https://ropeshift.com/"
  version "0.1.0-alpha.2"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.2/ropeshift_0.1.0-alpha.2_darwin_arm64.tar.gz"
      sha256 "d6099fdde478023a0d827a6bb55a3bedf0e70e77c12791b4393f01a666a30d8a"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.2/ropeshift_0.1.0-alpha.2_darwin_amd64.tar.gz"
      sha256 "176c723bc2980a4b04d14b2e0e15555b71cd6157996d6bcfa4a40d30e21a3b52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.2/ropeshift_0.1.0-alpha.2_linux_arm64.tar.gz"
      sha256 "545a3119e3c8d1f860bd94cca0c9461ad6fb2529438e21e846c392b49a8b08b1"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.2/ropeshift_0.1.0-alpha.2_linux_amd64.tar.gz"
      sha256 "f5d7fdb3245c5f1ceb372b9977db2a16d307ee06cfa097ebc5ea6115c41cc619"
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
