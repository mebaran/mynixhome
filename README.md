# Nix Home Manager Configuration

## Build/Test Commands
- `nix flake check` - Validate flake configuration
- `home-manager switch --flake .#<configName>` - Apply configuration (configName: mebaran, mebaran@nixos-wsl, markbaran, mbaran)
- `nix develop` - Enter development shell with nixlang LSP
- `nix flake update` - Update flake inputs

## WSL Profiles
- `mebaran@nixos-wsl` and `mbaran` use the shared CLI-only modules: no desktop apps or Paseo service.
- `mebaran` is the native Linux desktop profile; do not select it on WSL.

## Home Scripts
- `scripts/pgservicedburi.py` replaces the former `mebaran/mytools` package; it is installed in every profile and available with `nix run .#pgservicedburi -- <service>`.
- Check it with `python3 scripts/test_pgservicedburi.py "$(nix build .#pgservicedburi --no-link --print-out-paths)/bin/pgservicedburi"`.

## Browser Recordings
- The shared profile includes `ffmpeg`, the `playwright` CLI, and matching Nix-managed browsers via `PLAYWRIGHT_BROWSERS_PATH`.
- Browser video recording uses Playwright's `recordVideo` context option; these packages do not configure a Claude MCP server or record the entire desktop.
- Project-local Playwright versions must match the Nix-provided CLI (`playwright --version`) to use these browsers.

## Code Style Guidelines
- **Language**: Nix expression language
- **Formatting**: Use 2-space indentation, align attributes vertically
- **Imports**: Group imports at top, use relative paths (./file.nix)
- **Naming**: Use camelCase for attributes, kebab-case for package names
- **Structure**: Separate concerns into modules (packages.nix, programs/, files.nix)
- **Comments**: Use `#` for single-line comments, minimal commenting preferred
- **Attributes**: Use `inherit` when passing through variables unchanged
- **Functions**: Use `let...in` for local bindings, destructure function arguments

## Architecture
- `flake.nix` - Main entry point with multiple system configurations
- `home.nix` - Core home-manager configuration with imports
- `packages.nix` - User packages including Python distribution
- `programs/` - Program-specific configurations (zsh, zellij, etc.)
- `files.nix` - Dotfile management for various tools