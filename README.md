# GitHub Copilot App Nix Flake

This flake packages the official GitHub Copilot Linux AppImage from
[`github/app`](https://github.com/github/app). It is pinned to a specific
upstream release and wrapped with Nix's AppImage tooling, so it runs on NixOS
without FUSE.

## Run

Run the checked-out flake locally:

```bash
nix run .
```

After publishing the repository, run it directly from GitHub:

```bash
nix run github:<owner>/nixos-flake-github-copilot-app
```

## Install

Add the flake as an input and install its default package:

```nix
inputs.github-copilot-app.url = "github:<owner>/nixos-flake-github-copilot-app";

# In the NixOS configuration module:
environment.systemPackages = [
  inputs.github-copilot-app.packages.${pkgs.system}.default
];
```

The package currently supports `x86_64-linux`. Once installed, launch it as
`github-copilot-app` or from the desktop application launcher.

## Update

1. Change `version` in `package.nix` to the desired
   [`github/app` release](https://github.com/github/app/releases).
2. Temporarily set `hash = lib.fakeHash;`.
3. Run `nix build .#github-copilot-app`. Copy Nix's reported `got:` hash into
   `package.nix`.
4. Run `nix flake update --flake .` and `nix build .#github-copilot-app`.
