{pkgs, ...}: let
  pyDist = pkgs.python3.withPackages (ps:
    with ps; [
      ipython
    ]);
in {
  home.packages = [
    pyDist
  ];
  programs.uv.enable = true;
  home.sessionVariables = {
    UV_PYTHON = pyDist.interpreter;
    UV_PYTHON_DOWNLOADS = "never";
  };
}
