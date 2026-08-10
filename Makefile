NIX_UPDATE ?= nix run nixpkgs\#nix-update --
.PHONY: update-home-manager update-skill-sources update-weekly

update-skill-sources:
	$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix openai-skills

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-skill-sources
	$(MAKE) update-home-manager
