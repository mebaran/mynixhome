NIX_UPDATE ?= nix run nixpkgs\#nix-update --
SKILL_SOURCE_PACKAGES := openai-skills duckdb-skills aws-agent-toolkit-for-aws

.PHONY: update-home-manager update-skills update-weekly

update-skills:
	@for package in $(SKILL_SOURCE_PACKAGES); do \
		$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix "$$package"; \
	done

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-skills
	$(MAKE) update-home-manager
