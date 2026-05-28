{aitools, ...}: {
  plugins.codecompanion = {
    enable = true;

    settings = {
      log_level = "INFO";
      interactions = {
        chat.adapter = "codex";
        inline.adapter = "openrouter";
        agent.adapter = "codex";
      };
      adapters.acp = {
        codex.__raw = ''
          function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt"
              }
            })
          end
        '';
      };
      adapters.http = {
        openrouter.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "qwen/qwen3-coder",
                  choices = {
                    "x-ai/grok-code-fast-1",
                    "openai/gpt-5-codex",
                    "anthropic/claude-sonnet-4.5"
                  }
                },
              }
            })
          end
        '';
      };
      display = {
        diff = {
          enabled = true;
          close_chat_at = 240; #Close an open chat buffer if the total columns of your display are less than...
          provider = "mini_diff"; #default|mini_diff
        };
      };
    };
  };
  keymaps = [
    {
      mode = ["n" "v"];
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = ["n" "v"];
      key = "<LocalLeader>a";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "ca";
      action = "<cmd>CodeCompanionChat Add<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  extraPackages = [
    aitools.codex-acp
  ];

  plugins.fidget.luaConfig.post = builtins.readFile ./lua/codecompanion_fidget.lua;

  extraConfigVim = "cabbrev cc CodeCompanion";
}
