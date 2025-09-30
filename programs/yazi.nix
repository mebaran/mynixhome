{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = let
      yp = pkgs.yaziPlugins;
    in {
      bypass = yp.bypass;
      git = yp.git;
      lazygit = yp.lazygit;
      smart-enter = yp.smart-enter;
    };
    keymap.mgr.prepend_keymap = [
      {
        on = ["g" "l"];
        run = "plugin lazygit";
        desc = "run lazy git";
      }
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
      {
        on = "<Enter>";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
    ];
  };
}
