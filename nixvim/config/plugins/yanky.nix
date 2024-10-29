{
  plugins.yanky = {
    enable = true;
    settings = {
      highlight = {timer = 250;};
      ring = {storage = "sqlite";};
    };
  };
  keymaps = [
    {
      key = "y";
      action = "<Plug>(YankyYank)";
      mode = ["n" "x"];
      options.desc = "Yank text";
    }
    {
      key = "p";
      action = "<Plug>(YankyPutAfter)";
      mode = ["n" "x"];
      options.desc = "Put yanked text after cursor";
    }
    {
      key = "P";
      action = "<Plug>(YankyPutBefore)";
      mode = ["n" "x"];
      options.desc = "Put yanked text before cursor";
    }
    {
      key = "gp";
      action = "<Plug>(YankyGPutAfter)";
      mode = ["n" "x"];
      options.desc = "Put yanked text after selection";
    }
    {
      key = "gP";
      action = "<Plug>(YankyGPutBefore)";
      mode = ["n" "x"];
      options.desc = "Put yanked text before selection";
    }
    {
      key = "[y";
      action = "<Plug>(YankyCycleForward)";
      options.desc = "Cycle forward through yank history";
    }
    {
      key = "]y";
      action = "<Plug>(YankyCycleBackward)";
      options.desc = "Cycle backward through yank history";
    }
    {
      key = "]p";
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      options.desc = "Put indented after cursor (linewise)";
    }
    {
      key = "[p";
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      options.desc = "Put indented before cursor (linewise)";
    }
    {
      key = "]P";
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      options.desc = "Put indented after cursor (linewise)";
    }
    {
      key = "[P";
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      options.desc = "Put indented before cursor (linewise)";
    }
    {
      key = ">p";
      action = "<Plug>(YankyPutIndentAfterShiftRight)";
      options.desc = "Put and indent right";
    }
    {
      key = "<p";
      action = "<Plug>(YankyPutIndentAfterShiftLeft)";
      options.desc = "Put and indent left";
    }
    {
      key = ">P";
      action = "<Plug>(YankyPutIndentBeforeShiftRight)";
      options.desc = "Put before and indent right";
    }
    {
      key = "<P";
      action = "<Plug>(YankyPutIndentBeforeShiftLeft)";
      options.desc = "Put before and indent left";
    }
    {
      key = "=p";
      action = "<Plug>(YankyPutAfterFilter)";
      options.desc = "Put after applying a filter";
    }
    {
      key = "=P";
      action = "<Plug>(YankyPutBeforeFilter)";
      options.desc = "Put before applying a filter";
    }
  ];
}
