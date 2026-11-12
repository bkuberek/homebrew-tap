# The Homebrew formula for ropeshift. scripts/homebrew-formula.sh renders it for each release from the
# release's checksums.txt, and a maintainer commits the result to the project's tap
# (docs/releasing.md). A formula, not a cask, because only a formula's service block is what
# `brew services` runs (ADR-0001).
class Ropeshift < Formula
  desc "Self-hosted software factory that runs supervised agent CLIs"
  homepage "https://ropeshift.com/"
  version "0.1.0-alpha.11"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.11/ropeshift_0.1.0-alpha.11_darwin_arm64.tar.gz"
      sha256 "1687c51dd1159769531de96a102123380b1419d5cb5660ffa8c7e0c99c311570"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.11/ropeshift_0.1.0-alpha.11_darwin_amd64.tar.gz"
      sha256 "7454fa5982d5c7af7fedd0edc28a0fc1276805789a9734907aabcc20ac52ba7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.11/ropeshift_0.1.0-alpha.11_linux_arm64.tar.gz"
      sha256 "3370d0fdfd6e6535942d2a88c109defe661dd56331e209e0a8a6853f28d13e7a"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.11/ropeshift_0.1.0-alpha.11_linux_amd64.tar.gz"
      sha256 "11e94bc45394b810c52fc751a3c6b30785da60c01fc9d730134a604d1a89e38d"
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
