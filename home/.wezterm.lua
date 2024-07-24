-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Andromeda'
config.color_scheme = 'Apprentice (Gogh)'
config.color_scheme = 'Atelier Estuary Light (base16)'
config.color_scheme = 'Alabaster'
config.color_scheme = 'Afterglow'

config.enable_scroll_bar = true

config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 0,
}

config.font = wezterm.font 'Inconsolata'
config.font_size = 14

config.window_decorations = "TITLE | RESIZE"

config.hide_tab_bar_if_only_one_tab = true

wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Rename tab',
      icon = 'md_rename_box',

      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },
  }
end)

config.keys = {
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}
config.canonicalize_pasted_newlines = "None"

-- and finally, return the configuration to wezterm
return config
