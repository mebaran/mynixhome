NIX_UPDATE ?= nix run nixpkgs\#nix-update --
SKILL_SOURCE_PACKAGES := openai-skills duckdb-skills aws-agent-toolkit-for-aws lean-ctx

.PHONY: update-home-manager update-skills update-weekly

update-skills:
	$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix openai-skills duckdb-skills aws-agent-toolkit-for-aws
	$(NIX_UPDATE) --flake --version=latest --src-only --override-filename packages/skill-sources.nix lean-ctx

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-skills
	$(MAKE) update-home-manager
