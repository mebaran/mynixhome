{pkgs, ...}: {
  plugins.conform-nvim.settings.formatters_by_ft.json = ["jq"];
  extraPackages = [
    pkgs.jq
  ];
}
