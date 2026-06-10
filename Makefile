NIX_UPDATE ?= nix run nixpkgs\#nix-update --
SKILL_SOURCE_PACKAGES := openai-skills duckdb-skills aws-agent-toolkit-for-aws pydantic-skills

.PHONY: update-home-manager update-skills update-weekly

update-skills:
	@for pkg in $(SKILL_SOURCE_PACKAGES); do \
		$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix $$pkg; \
	done
	$(NIX_UPDATE) --flake --src-only --override-filename packages/lean-ctx.nix lean-ctx

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-skills
	$(MAKE) update-home-manager
