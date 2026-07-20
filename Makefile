NIX_UPDATE ?= nix run nixpkgs\#nix-update --
SKILL_SOURCE_PACKAGES := openai-skills

.PHONY: update-home-manager update-lean-ctx update-skill-sources update-weekly

update-lean-ctx:
	$(NIX_UPDATE) --flake --src-only --override-filename packages/lean-ctx.nix lean-ctx

update-skill-sources:
	@for pkg in $(SKILL_SOURCE_PACKAGES); do \
		$(NIX_UPDATE) --flake --version=branch --src-only --override-filename packages/skill-sources.nix $$pkg; \
	done

update-home-manager:
	nix flake update

update-weekly:
	$(MAKE) update-lean-ctx
	$(MAKE) update-skill-sources
	$(MAKE) update-home-manager
