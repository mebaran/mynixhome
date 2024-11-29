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
  diagnostics = {
    virtual_text = false;
    underline = true;
    severity_sort = true;
  };

  # Term improvements
  autoCmd = [
    {
      event = ["TermOpen" "TermEnter"];
      callback.__raw = ''
        function(event)
            vim.cmd("setlocal nonumber")
            vim.cmd("setlocal norelativenumber")
            vim.cmd("setlocal signcolumn=yes:1")
            -- vim.cmd('startinsert!')
            vim.cmd("set cmdheight=1")
            -- vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
      '';
    }
    {
      event = "WinEnter";
      pattern = "term://*";
      command = "startinsert!";
    }
  ];
}
