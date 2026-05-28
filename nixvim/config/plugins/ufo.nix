{
  plugins.nvim-ufo = {
    enable = true;
    setupLspCapabilities = true;
    settings = {
      fold_virt_text_handler.__raw = ''
        function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (' 󰁂 %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
              local chunkText = chunk[1]
              local chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
              else
                  chunkText = truncate(chunkText, targetWidth - curWidth)
                  local hlGroup = chunk[2]
                  table.insert(newVirtText, {chunkText, hlGroup})
                  chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  -- str width returned from truncate() may less than 2nd argument, need padding
                  if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                  end
                  break
              end
              curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, {suffix, 'MoreMsg'})
          return newVirtText
        end
      '';
    };
  };
  keymaps = [
    {
      key = "zR";
      action.__raw = "require('ufo').openAllFolds";
      mode = "n";
      options.desc = "Open all folds";
    }
    {
      key = "zM";
      action.__raw = "require('ufo').closeAllFolds";
      mode = "n";
      options.desc = "Close all folds";
    }
    {
      key = "zr";
      action.__raw = "require('ufo').openFoldsExceptKinds";
      mode = "n";
      options.desc = "Open folds except kinds";
    }
    {
      key = "zm";
      action.__raw = "require('ufo').closeFoldsWith";
      mode = "n";
      options.desc = "Close folds with";
    }
    {
      key = "zp";
      action.__raw = "require('ufo').peekFoldedLinesUnderCursor";
      mode = "n";
      options.desc = "Peek folded lines under cursor";
    }
  ];
}
