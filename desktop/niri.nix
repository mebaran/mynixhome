{
  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;
      window-rules = [
        {
          clip-to-geometry = true;
        }
      ];
    };
  };
}
