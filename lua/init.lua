local M = {}

M.config = {
    log_file = vim.fn.stdpath("data") .. "/tempo_log",
    prompt_for_name = true,
}

local timer = {
    start_time = nil,
    elapsed = 0,
    running = false,
    paused = false,
    name = "",
}

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})
end

local function get_elapsed_time()
    if timer.running and not timer.paused then
        return timer.elapsed + (os.time() - timer.start_time)
    end

    return timer.elapsed
end

local function format_time(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function write_log(start_date, duration, name)
    local file = io.open(M.config.log_file, "a")

    if file then
        local name_part = name and name ~= "" and " | " .. name or ""
        file:write(string.format("%s | %s%s\n", start_date, format_time(duration), name_part))
        file:close()

        return
    end

    vim.notify("Failed to write to log file: " .. M.config.log_file, vim.log.levels.ERROR)
end

function M.start()
    if timer.running then
        vim.notify("Timer is already running", vim.log.levels.WARN)

        return
    end

    local function start_timer(name)
        timer.start_time = os.time()
        timer.elapsed = 0
        timer.running = true
        timer.paused = false
        timer.name = name or ""
        timer.log_start_date = os.date("%Y-%m-%d %H:%M:%S")

        local name_msg = timer.name ~= "" and ' "' .. timer.name .. '"' or ""
        vim.schedule(function()
            vim.notify("Timer started" .. name_msg, vim.log.levels.INFO)
        end)
    end

    if M.config.prompt_for_name then
        vim.ui.input({ prompt = "Timer name (optional): " }, function(input)
            start_timer(input)
        end)
    else
        start_timer("")
    end
end

function M.pause()
    if not timer.running then
        vim.notify("No timer running", vim.log.levels.WARN)

        return
    end

    if timer.paused then
        timer.start_time = os.time()
        timer.paused = false
        vim.notify("Timer resumed", vim.log.levels.INFO)

        return
    end

    timer.elapsed = get_elapsed_time()
    timer.paused = true
    vim.notify("Timer paused at " .. format_time(timer.elapsed), vim.log.levels.INFO)
end

function M.stop()
    if not timer.running then
        vim.notify("No timer running", vim.log.levels.WARN)

        return
    end

    local final_time = get_elapsed_time()

    local function stop_timer(name)
        write_log(timer.log_start_date, final_time, name)

        timer.start_time = nil
        timer.elapsed = 0
        timer.running = false
        timer.paused = false
        timer.name = ""

        vim.schedule(function()
            vim.notify("Timer stopped and logged: " .. format_time(final_time), vim.log.levels.INFO)
        end)
    end

    if M.config.prompt_for_name then
        vim.ui.input({
            prompt = "Timer name (optional): ",
            default = timer.name,
        }, function(input)
            stop_timer(input or timer.name)
        end)
    else
        stop_timer(timer.name)
    end
end

function M.toggle()
    if not timer.running then
        M.start()

        return
    end

    M.pause()
end

function M.show()
    if not timer.running then
        vim.notify("No timer running", vim.log.levels.INFO)

        return
    end

    local current_time = get_elapsed_time()
    local status = timer.paused and " (paused)" or ""
    local name_part = timer.name ~= "" and ' "' .. timer.name .. '"' or ""

    vim.notify("Timer: " .. format_time(current_time) .. status .. name_part, vim.log.levels.INFO)
end

function M.open_log()
    local file = io.open(M.config.log_file, "r")

    if not file then
        file = io.open(M.config.log_file, "w")
        if file then
            file:close()
        else
            vim.notify("Failed to create log file: " .. M.config.log_file, vim.log.levels.ERROR)
        end

        return
    end

    file:close()

    -- Open the log file in a new buffer
    vim.cmd("edit " .. vim.fn.fnameescape(M.config.log_file))
end

vim.api.nvim_create_user_command("TempoStart", function()
    M.start()
end, {})

vim.api.nvim_create_user_command("TempoPause", function()
    M.pause()
end, {})

vim.api.nvim_create_user_command("TempoToggle", function()
    M.toggle()
end, {})

vim.api.nvim_create_user_command("TempoStop", function()
    M.stop()
end, {})

vim.api.nvim_create_user_command("TempoShow", function()
    M.show()
end, {})

vim.api.nvim_create_user_command("TempoOpen", function()
    M.open_log()
end, {})

return M
