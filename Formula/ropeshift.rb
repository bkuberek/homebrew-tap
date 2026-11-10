# The Homebrew formula for ropeshift. scripts/homebrew-formula.sh renders it for each release from the
# release's checksums.txt, and a maintainer commits the result to the project's tap
# (docs/releasing.md). A formula, not a cask, because only a formula's service block is what
# `brew services` runs (ADR-0001).
class Ropeshift < Formula
  desc "Self-hosted software factory that runs supervised agent CLIs"
  homepage "https://ropeshift.com/"
  version "0.1.0-alpha.6"
  license "FSL-1.1-ALv2"

  on_macos do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.6/ropeshift_0.1.0-alpha.6_darwin_arm64.tar.gz"
      sha256 "65b91ddda2116b7cf08cbc904b3a74f74b42143218c06854a2c277f5ec0be888"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.6/ropeshift_0.1.0-alpha.6_darwin_amd64.tar.gz"
      sha256 "7bb7b5f1c932b1393b273edddeda5de1467bfae3ffdbd0b340ca81d4bda8a047"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.6/ropeshift_0.1.0-alpha.6_linux_arm64.tar.gz"
      sha256 "621c99f769d77f79acf6f1fa7465960172d5288a86fcc896d1404500bbe13237"
    end
    on_intel do
      url "https://github.com/bkuberek/ropeshift/releases/download/v0.1.0-alpha.6/ropeshift_0.1.0-alpha.6_linux_amd64.tar.gz"
      sha256 "131a554bee061caa3766c76e6a15d6359cfc0c01c2abe4c18ae5463d1d8404bc"
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
