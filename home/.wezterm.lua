-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Atelier Estuary Light (base16)'
config.color_scheme = 'Alabaster'
config.color_scheme = 'Apprentice (Gogh)'
config.color_scheme = 'Solar Flare (base16)'
config.color_scheme = 'Solar Flare Light (base16)'
config.color_scheme = 'Solarized Darcula (Gogh)'
config.color_scheme = 'Solarized Darcula (Gogh)'
config.color_scheme = 'Default Dark (base16)'
config.color_scheme = 'Solarized Dark - Patched'
config.color_scheme = 'Dracula'
config.color_scheme = 'Maia (Gogh)'
config.color_scheme = 'Dimmed Monokai (Gogh)'
config.color_scheme = 'Dracula+'
config.color_scheme = 'Decaf (base16)'
config.color_scheme = 'Desert (Gogh)'
config.color_scheme = 'Dracula (Gogh)'
config.color_scheme = 'Andromeda'
config.color_scheme = 'Afterglow'
config.color_scheme = 'Catppuccin Frappe'
config.color_scheme = 'Solarized Dark - Patched'
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.color_scheme = 'Atelier Estuary Light (base17)'
config.color_scheme = 'Alabaster'
config.color_scheme = 'Solar Flare (base16)'
config.color_scheme = 'Solar Flare Light (base16)'

config.color_scheme = 'Andromeda'

config.color_scheme = 'Dimmed Monokai (Gogh)'
config.enable_scroll_bar = true

config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 0,
}

config.font = wezterm.font 'Inconsolata'
config.font_size = 17

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
  { key = "Escape", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

config.canonicalize_pasted_newlines = "None"

config.hyperlink_rules = {
  -- Matches: a URL in parens: (URL)
  {
    regex = '\\((\\w+://\\S+)\\)',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in brackets: [URL]
  {
    regex = '\\[(\\w+://\\S+)\\]',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in curly braces: {URL}
  {
    regex = '\\{(\\w+://\\S+)\\}',
    format = '$1',
    highlight = 1,
  },
  -- Matches: a URL in angle brackets: <URL>
  {
    regex = '<(\\w+://\\S+)>',
    format = '$1',
    highlight = 1,
  },
  -- Then handle URLs not wrapped in brackets
  {
    regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
    format = '$0',
  },
}

-- and finally, return the configuration to wezterm
return config
