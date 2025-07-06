# Nix Home Manager Configuration

## Build/Test Commands
- `nix flake check` - Validate flake configuration
- `home-manager switch --flake .#<username>` - Apply configuration (username: mebaran, markbaran, mbaran)
- `nix develop` - Enter development shell with nixlang LSP
- `nix flake update` - Update flake inputs

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