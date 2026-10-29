# bkuberek/homebrew-tap

Homebrew formulae and casks for projects by Bastian Kuberek. Each project's release workflow publishes its entry here automatically; nothing in this repository is edited by hand except this README.

## Tools

| Tool | Type | Description | Install |
|---|---|---|---|
| [cstudy](https://github.com/bkuberek/coding-study) | Formula | Local, IDE-first practice for coding interviews | `brew install bkuberek/tap/cstudy` |
| [spmeta](https://github.com/bkuberek/spmeta) | Cask | Now-playing metadata for Spotify | `brew install bkuberek/tap/spmeta` |

A formula installs a tool that Homebrew sets up on your machine (cstudy runs on Homebrew's Python). A cask installs a prebuilt binary (spmeta is a single Go binary per platform).

## Install

Install any tool by its full name, as in the table. Homebrew taps this repository on first use.

Homebrew 7 asks you to trust a third-party tap before some other commands read it, for example `brew info cstudy`. Trust it once:

```bash
brew trust bkuberek/tap
```

## Upgrade and remove

```bash
brew update
brew upgrade cstudy        # or: brew upgrade spmeta
brew uninstall cstudy      # or: brew uninstall spmeta
```

## After installing

- **cstudy** needs the language toolchains you practice in (Python via uv, Node.js, Java 21). See the [toolchains guide](https://github.com/bkuberek/coding-study/blob/main/docs/guides/toolchains.md), then run `cstudy init` and `cstudy doctor`.
- **spmeta**: see its [README](https://github.com/bkuberek/spmeta#readme).

## Issues

Report problems with a tool in that tool's repository.
