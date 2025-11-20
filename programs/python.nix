{pkgs, ...}: let
  pyDist = pkgs.python3.withPackages (ps:
    with ps; [
      ipython
    ]);
in {
  home.packages = [
    pyDist
    pkgs.uv
  ];
  home.sessionVariables = {
    UV_PYTHON = pyDist.interpreter;
    UV_PYTHON_DOWNLOADS = "never";
  };
}
