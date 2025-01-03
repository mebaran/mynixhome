{ pkgs, ... }:
{
  plugins = {
    conform-nvim.settings.formatters_by_ft.sql = [
      "sleek"
    ];
  };
  extraPackages = with pkgs; [
    sleek
  ];
}
