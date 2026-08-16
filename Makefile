NIX_UPDATE ?= nix run nixpkgs\#nix-update --
.PHONY: update-home-manager update-local-packages update-skill-sources update-weekly

update-local-packages:
	$(NIX_UPDATE) --flake --use-github-releases --override-filename packages/dbxcli.nix dbxcli

update-skill-sources:
	$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix openai-skills

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-local-packages
	$(MAKE) update-skill-sources
	$(MAKE) update-home-manager
