# tempo.nvim

The most straightforward Neovim timer plugin for tracking time and logging sessions to a file.

## Installation

### Using lazy.nvim

```lua
{
  "mtarld/tempo.nvim",

  opts = {
    -- Optional: customize log file location
    -- Default: stdpath("data")/tempo_log
    log_file = vim.fn.expand("~/.local/share/nvim/tempo_log"),

    -- Optional: enable/disable timer name prompts
    -- Default: true
    prompt_for_name = true,
  },

  -- Add any command that you're going to use.
  cmd = { "TempoStart", "TempoPause", "TempoToggle", "TempoStop", "TempoShow", "TempoOpen" },

  -- Define your own mapping. For example, this is mine
  keys = {
    { "<leader>tt", ":TempoToggle<CR>" },
    { "<leader>tx", ":TempoStop<CR>" },
    { "<leader>ts", ":TempoShow<CR>" },
    { "<leader>to", ":TempoOpen<CR>" },
  },
}
```

### Manual Installation

1. Copy `lua/init.lua` to your Neovim config directory:
   ```
   ~/.config/nvim/lua/tempo.lua
   ```

2. Add to your `init.lua`:
   ```lua
   local tempo = require("tempo")
   tempo.setup({
      -- Optional: customize log file location
      -- Default: stdpath("data")/tempo_log
      log_file = "/path/to/your/tempo_log",

      -- Optional: enable/disable timer name prompts
      -- Default: true
      prompt_for_name = true,
   })
   ```

## Commands

- `:TempoStart` - Start a new timer (prompts for an optional timer name)
- `:TempoPause` - Pause/resume the current timer
- `:TempoStop` - Stop the timer and log the session (prompts to update the timer name)
- `:TempoShow` - Display the current timer value and name
- `:TempoToggle` - Start the timer if not running, or pause/resume if running
- `:TempoOpen` - Open the log file in a new buffer

## Log Format

Each timer session is logged in the following format:
```
YYYY-MM-DD HH:MM:SS | HH:MM:SS | timer_name
```

The timer name is optional. If no name is provided, the log entry will only contain the date and duration:
```
YYYY-MM-DD HH:MM:SS | HH:MM:SS
```

Example:
```
2024-12-01 14:30:00 | 01:23:45 | Implementing feature X
2024-12-01 16:15:30 | 00:45:12 | Code review
2024-12-01 18:00:00 | 02:15:30
```

## Usage Example

```vim
:TempoStart          " Prompts for timer name (optional), then starts tracking time
:TempoShow           " Check current time: 00:05:23 "My task"
:TempoPause          " Pause the timer
:TempoPause          " Resume the timer
:TempoStop           " Prompts to update timer name, then stops and logs the session

" Or use TempoToggle for convenience:
:TempoToggle         " Prompts for timer name and starts the timer
:TempoToggle         " Pause the timer
:TempoToggle         " Resume the timer
:TempoStop           " Prompts to update timer name and logs the session
```

## Features

- Track time with start/pause/stop functionality
- Optional timer names for better task tracking
- Ability to update timer names when stopping
- Automatic logging to a configurable file
- Formatted time display (HH:MM:SS)
- Persistent log entries with start date, duration, and optional name
- Notifications for all actions
