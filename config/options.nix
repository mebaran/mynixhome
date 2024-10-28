let
  indent = 4;
in {
  globals = {
    mapleader = " ";
  };
  opts = {
    # misc;
    backspace = ["eol" "start" "indent"];
    encoding = "utf-8";
    matchpairs = ["(:)" "{:}" "[:]" "<:>"];
    syntax = "enable";
    listchars = "tab:▸ ";
    exrc = true;

    # indentation;
    autoindent = true;
    expandtab = true;
    shiftwidth = indent;
    smartindent = true;
    softtabstop = indent;
    tabstop = indent;

    # search;
    hlsearch = true;
    ignorecase = true;
    smartcase = true;
    wildmenu = true;

    # ui;
    number = true;
    rnu = true;
    scrolloff = 20;
    showmode = false;
    sidescrolloff = 3;
    signcolumn = "yes";

    # backups;
    backup = false;
    swapfile = false;
    writebackup = false;
    updatetime = 250;
  };
}
