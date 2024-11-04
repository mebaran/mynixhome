{
  plugins.dap = {
    enable = true;
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
    };
  };
  keymaps = [
    {
      key = "<leader>dR";
      action.__raw = ''function() require("dap").run_to_cursor() end'';
      options.desc = "Run to Cursor";
    }
    {
      key = "<leader>dE";
      action.__raw = ''function() require("dapui").eval(vim.fn.input "[Expression] > ") end'';
      options.desc = "Evaluate Input";
    }
    {
      key = "<leader>dC";
      action.__raw = ''function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end'';
      options.desc = "Conditional Breakpoint";
    }
    {
      key = "<leader>dU";
      action.__raw = ''function() require("dapui").toggle() end'';
      options.desc = "Toggle UI";
    }
    {
      key = "<leader>db";
      action.__raw = ''function() require("dap").step_back() end'';
      options.desc = "Step Back";
    }
    {
      key = "<leader>dc";
      action.__raw = ''function() require("dap").continue() end'';
      options.desc = "Continue";
    }
    {
      key = "<leader>dd";
      action.__raw = ''function() require("dap").disconnect() end'';
      options.desc = "Disconnect";
    }
    {
      key = "<leader>de";
      action.__raw = ''function() require("dapui").eval() end'';
      mode = ["n" "v"];
      options.desc = "Evaluate";
    }
    {
      key = "<leader>dg";
      action.__raw = ''function() require("dap").session() end'';
      options.desc = "Get Session";
    }
    {
      key = "<leader>dh";
      action.__raw = ''function() require("dap.ui.widgets").hover() end'';
      options.desc = "Hover Variables";
    }
    {
      key = "<leader>dS";
      action.__raw = ''function() require("dap.ui.widgets").scopes() end'';
      options.desc = "Scopes";
    }
    {
      key = "<leader>di";
      action.__raw = ''function() require("dap").step_into() end'';
      options.desc = "Step Into";
    }
    {
      key = "<leader>do";
      action.__raw = ''function() require("dap").step_over() end'';
      options.desc = "Step Over";
    }
    {
      key = "<leader>dp";
      action.__raw = ''function() require("dap").pause.toggle() end'';
      options.desc = "Pause";
    }
    {
      key = "<leader>dq";
      action.__raw = ''function() require("dap").close() end'';
      options.desc = "Quit";
    }
    {
      key = "<leader>dr";
      action.__raw = ''function() require("dap").repl.toggle() end'';
      options.desc = "Toggle REPL";
    }
    {
      key = "<leader>ds";
      action.__raw = ''function() require("dap").continue() end'';
      options.desc = "Start";
    }
    {
      key = "<leader>dt";
      action.__raw = ''function() require("dap").toggle_breakpoint() end'';
      options.desc = "Toggle Breakpoint";
    }
    {
      key = "<leader>dx";
      action.__raw = ''function() require("dap").terminate() end'';
      options.desc = "Terminate";
    }
    {
      key = "<leader>du";
      action.__raw = ''function() require("dap").step_out() end'';
      options.desc = "Step Out";
    }
    {
      key = "<leader>td";
      action.__raw = ''function() require("neotest").run.run({ strategy = "dap" }) end'';
      options.desc = "Debug Nearest";
    }
  ];
  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
  '';
}
