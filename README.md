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
     log_file = vim.fn.expand("~/.local/share/nvim/tempo_log")
   })
   ```

## Configuration

The plugin accepts the following options in the `setup()` function:

```lua
tempo.setup({
  log_file = "/path/to/your/tempo_log"  -- Default: stdpath("data")/tempo_log
})
```

## Commands

- `:TempoStart` - Start a new timer
- `:TempoPause` - Pause/resume the current timer
- `:TempoStop` - Stop the timer and log the session
- `:TempoShow` - Display the current timer value
- `:TempoToggle` - Start the timer if not running, or pause/resume if running
- `:TempoOpen` - Open the log file in a new buffer

## Log Format

Each timer session is logged in the following format:
```
YYYY-MM-DD HH:MM:SS | HH:MM:SS
```

Example:
```
2024-12-01 14:30:00 | 01:23:45
2024-12-01 16:15:30 | 00:45:12
```

## Usage Example

```vim
:TempoStart          " Start tracking time
:TempoShow           " Check current time: 00:05:23
:TempoPause          " Pause the timer
:TempoPause          " Resume the timer
:TempoStop           " Stop and log the session

" Or use TempoToggle for convenience:
:TempoToggle         " Start the timer
:TempoToggle         " Pause the timer
:TempoToggle         " Resume the timer
:TempoStop           " Stop and log the session
```

## Features

- Track time with start/pause/stop functionality
- Automatic logging to a configurable file
- Formatted time display (HH:MM:SS)
- Persistent log entries with start date and duration
- Notifications for all actions
