{
  home.file = {
    ".ipython/profile_default/startup/00-autoreload.ipy".text = ''
      %load_ext autoreload
      %autoreload 2
    '';
    ".psqlrc".text = ''
      \setenv PAGER pspg
      \set QUIET 1
      \pset linestyle unicode
      \pset border 2
      \pset null ∅
      \unset QUIET
    '';
    ".pspgconf".source = ./files/_pspgconf;
  };
}
