local CCFidget = {}


function CCFidget.start_fidget()
    local has_fidget, fidget = pcall(require, "fidget")
    if not has_fidget then
        return
    end

    if CCFidget.fidget_progress_handle then
        CCFidget.fidget_progress_handle.message = "Abort."
        CCFidget.fidget_progress_handle:cancel()
        CCFidget.fidget_progress_handle = nil
    end

    CCFidget.fidget_progress_handle = fidget.progress.handle.create({
        title = "",
        message = "Thinking...",
        lsp_client = { name = "CodeCompanion" },
    })
end

function CCFidget.stop_fidget()
    local has_fidget, _ = pcall(require, "fidget")
    if not has_fidget then
        return
    end

    if CCFidget.fidget_progress_handle then
        CCFidget.fidget_progress_handle.message = "Done."
        CCFidget.fidget_progress_handle:finish()
        CCFidget.fidget_progress_handle = nil
    end
end

function CCFidget.setup_fidget()
    local has_fidget, _ = pcall(require, "fidget")
    if has_fidget then
        -- New AU group:
        local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

        -- Attach:
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequest*",
            group = group,
            callback = function(request)
                if request.match == "CodeCompanionRequestStarted" then
                    CCFidget.start_fidget()
                elseif request.match == "CodeCompanionRequestFinished" then
                    CCFidget.stop_fidget()
                end
            end,
        })
    end
end


CCFidget.setup_fidget()
