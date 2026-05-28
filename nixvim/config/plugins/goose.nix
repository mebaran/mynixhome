{
  pkgs,
  aitools,
  ...
}: {
  extraPackages = [
    aitools.goose-cli
  ];
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "goose-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "azorng";
        repo = "goose.nvim";
        rev = "main";
        sha256 = "sha256-eCilRNQWTkfC+12vB+S/YoTlxI2EHOFA37Cw5ivaHfM=";
      };
      doCheck = false;
    })
  ];
  extraConfigLua = ''
    require('goose').setup()
  '';
}
