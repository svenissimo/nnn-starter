# nnn-starter

<p align="center">
  <img src="screenshot.png" alt="Screenshot of the NNN desktop — Niri + Noctalia on NixOS" width="100%">
</p>

> Three letters, zero compromise — now with batteries included.

An opinionated [omarchy](https://omarchy.org)-style NixOS starter for the [**NNN
stack**](https://the-nnn-stack.github.io/): **N**ixOS + **N**iri + **N**octalia. Clone it, set two placeholders,
run one command, and get a cohesive, themed, developer-ready Wayland desktop.

## What you get

| Layer        | Choice |
|--------------|--------|
| Compositor   | [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland), package from locked nixpkgs with [niri-flake](https://github.com/sodiboo/niri-flake) integration |
| Shell/UI     | [Noctalia](https://github.com/noctalia-dev/noctalia-shell) **v5** (bar, launcher, notifications, lock, control center) |
| Theming      | [Stylix](https://github.com/nix-community/stylix) with the **Kanagawa** palette; Noctalia uses its **Kanagawa Paper** community palette |
| Terminal     | [Ghostty](https://ghostty.org) |
| Shell + prompt | Zsh + [Starship](https://starship.rs) (autosuggestions, syntax highlighting, fzf, zoxide) |
| Editor (GUI) | [Zed](https://zed.dev) — themed via Stylix; default handler for text/source files |
| Editor (terminal) | Neovim, preconfigured (LSP, treesitter, telescope, completion); the `$EDITOR` |
| Browser      | [Zen](https://zen-browser.app) (beta channel, via the community flake) |
| File manager | [Strata](https://github.com/deepwatrcreatur/nix-strata-filemanager) |

Strata is installed through its upstream NixOS module, so it is available to all
system users. The system does not force a default file-manager association or
manage Strata preferences; each user can customize the app and choose their own
default.

| Font         | Maple Mono NF |
| Login        | Noctalia Greeter → niri session |

### Modern command-line toolset
`lsd` · `fzf` · `bat` · `btop` · `ripgrep` · `fd` · `zoxide` · `eza` · `yazi` ·
`dust` · `duf` · `procs` · `bandwhich` · `gping` · `zellij` ·
`tealdeer` · `jq` · `yq` · `lazygit` · `delta` · `gh` · `direnv` + `nix-direnv` ·
`nh` · `nom` · `claude` ([Claude Code](https://github.com/anthropics/claude-code)).
Old names are aliased to the new tools (`ls`→`lsd`, `cat`→`bat`,
`cd`→`zoxide`, `top`→`btop`, …).

## Quick start

```sh
# 1. Get the repo onto your machine (or into the live NixOS installer).
git clone https://github.com/<you>/nnn-starter ~/nnn-starter
cd ~/nnn-starter

# 2. Generate real hardware config for THIS machine.
sudo nixos-generate-config --show-hardware-config > hosts/nnn/hardware-configuration.nix

# 3. Put your identity in local.nix (see Placeholders below), then keep your
#    edits out of git history:
git update-index --skip-worktree local.nix

# 4. Build & switch.
sudo nixos-rebuild switch --flake .#nnn
```

After the first build, rebuild with `nh os switch` (aliased to `rebuild`) or
`update` (which also bumps `flake.lock`).

## Placeholders to edit

Your personal settings live in one place — [`local.nix`](local.nix). It's
tracked with neutral defaults but marked `skip-worktree` (step 3) so your real
values never get staged or committed.

| What | Where |
|------|-------|
| **Username, hostname, full name** | [`local.nix`](local.nix) |
| **Git identity** (name, email) | [`local.nix`](local.nix) |
| **Timezone** | [`local.nix`](local.nix) |
| **Monitor scale** | [`local.nix`](local.nix) |
| **Hardware** | `hosts/nnn/hardware-configuration.nix` (generated, step 2 above) |
| **Locale / keyboard layout** | [`hosts/nnn/default.nix`](hosts/nnn/default.nix) |
| **Monitor name / position** | `outputs` in [`modules/home/niri.nix`](modules/home/niri.nix) |

> Editing the defaults themselves (e.g. to change the placeholders this repo
> ships) needs `git update-index --no-skip-worktree local.nix` first.

## Layout

```
flake.nix              # inputs + the single `nixosConfigurations.nnn`
local.nix              # your machine-local identity (skip-worktree)
hosts/nnn/             # host: hardware + locale/timezone
modules/nixos/         # system: boot, audio, niri, noctalia, stylix, users…
modules/home/          # user: zsh, ghostty, wallpapers, and other home config…
modules/home/default.nix # shared user defaults, including wallpaper links
themes/                # vendored palette and the wallpaper used by Stylix and Home Manager
```

## Wallpapers

`walls` and `makccr-wallpapers` are shallow Git inputs pinned by `flake.lock`; Home Manager links their source trees into `~/Pictures/Wallpapers`. Shallow fetching omits Git history, not the large wallpaper files. `wallpaper.png` is linked from `themes/wallpaper.png`.

Update these upstream snapshots through the normal flake lock update workflow. Home Manager manages the target paths, so the linked repository contents are read-only; edit the upstream inputs or configuration rather than files beneath those links.

## Key bindings (niri)

| Keys | Action |
|------|--------|
| `Mod`+`Return` | Terminal (ghostty) |
| `Mod`+`Space` | Noctalia launcher |
| `Mod`+`B` | Browser (Zen) |
| `Mod+E` | File manager (Strata) |
| `Mod`+`Q` | Close window |
| `Mod`+`Tab` | Toggle overview (with wallpaper backdrop) |
| `Mod`+`F` / `Mod`+`Shift`+`F` | Maximize column / fullscreen |
| `Mod`+`H`/`J`/`K`/`L` | Focus left/down/up/right |
| `Mod`+`Shift`+`H`/`J`/`K`/`L` | Move window |
| `Mod`+`Shift`+`Tab` | Focus previously focused window |
| `Mod`+`1`…`5` | Switch workspace |
| `Mod`+`R` | Cycle column width |
| `Print` | Screenshot |
| `Mod`+`Shift`+`/` | Hotkey overlay (full list) |
| `Mod`+`Shift`+`E` | Quit niri |

## Reskin it

Everything is driven by one base16 file. Swap the palette and rebuild:

```nix
# modules/nixos/stylix.nix
stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
```

…or edit `themes/kanagawa.yaml` directly.

## Per-project dev environments

This starter deliberately keeps language toolchains **out** of the global
system. Use direnv + flakes per project instead:

```sh
# in a project repo
echo "use flake" > .envrc && direnv allow
```

```nix
# that project's flake.nix devShell, e.g.
devShells.default = pkgs.mkShell { packages = [ pkgs.nodejs pkgs.cargo ]; };
```

## Verifying changes

You can develop this on **macOS**, but a NixOS system can't be *built* there
without a Linux builder — these all work locally as pure evaluation/lint:

```sh
nix flake check                                              # evaluate everything
nix flake show                                               # list outputs
nix fmt                                                      # format (alejandra)
nix run nixpkgs#statix -- check . && nix run nixpkgs#deadnix # lint
nix eval .#nixosConfigurations.nnn.config.system.build.toplevel.drvPath
```

On a NixOS box (or with a remote/`linux-builder`) you can smoke-test in a VM:

```sh
nixos-rebuild build-vm --flake .#nnn
./result/bin/run-nnn-vm
```

### CI

[`.github/workflows/check.yml`](.github/workflows/check.yml) runs on every push
and PR:

- **eval** — `nix flake check --no-build` evaluates the whole config (the fast,
  reliable signal: catches option typos and niri schema errors).
- **lint** — `alejandra --check`, `statix`, `deadnix`.
- **build** — realises the full system closure; runs on `main` / manual
  dispatch. Noctalia is pulled from its Cachix cache; Niri and system packages
  use the nixpkgs binary cache when available.

> **Commit a `flake.lock`.** Generate it once on a machine with Nix
> (`nix flake lock`) and commit it, so CI and your machines resolve identical
> inputs. Until then, each run pins the latest upstream automatically.

## Notes / next steps (not included)

- Secrets: add [sops-nix](https://github.com/Mic92/sops-nix) or
  [agenix](https://github.com/ryantm/agenix).
- Declarative disks: add [disko](https://github.com/nix-community/disko).
- Multi-host: factor `hosts/` into one folder per machine and add more
  `nixosConfigurations` entries.

### Binary caches

Noctalia is pinned to its `cachix` branch; upstream pushes each commit after
its package is available from `noctalia.cachix.org`. The Noctalia cache is
trusted in [`modules/nixos/default.nix`](modules/nixos/default.nix).

Niri uses `pkgs.niri` from the locked system nixpkgs, so its graphics libraries
match the system Mesa/glibc set. The `niri-flake` input remains for its NixOS
and Home Manager integration, not its package or binary cache.
