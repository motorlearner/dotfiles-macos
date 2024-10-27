local wezterm = require "wezterm"
local config  = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 12

config.enable_tab_bar = false
config.macos_window_background_blur = 20
config.window_background_opacity = 0.65
config.window_padding = {
  left   = 10,
  right  = 10,
  top    = 10,
  bottom = 10,
}

config.colors = {
	foreground    = "#D2D4C8",
	background    = "#000C15",
	cursor_border = "#D2D2D2",
	cursor_bg     = "#D2D2D2",
	cursor_fg     = "#000000",
	selection_bg  = "#0B3954",
	selection_fg  = "#CBE0F0",
  split         = "#0F5EBE",
	ansi = {
    'black', -- prompt right side tick bg && right side all fg && left side 3rd patch fg
    'red', -- ls file size if > 1gb
    'limegreen', -- command exsiting && prompt tick fg
    '#DB9D47', -- prompt third patch bg && ls file language icons && ls size if > 1mb
    '#235F93', -- prompt second patch bg && ls times && ls folder icons
    'silver', -- ls picture files fg
    'purple',
    '#D2D4C8', -- prompt first patch bg
  },
  brights = {
    'grey', -- autocomplete suggestion
    'red', -- command not existing
    'lime', -- ls file size if > 1kb
    'silver', -- ls user and filenames
    'silver', -- ls dirnames
    'fuchsia', -- warning
    'purple',
    'purple',
  },
}

config.color_scheme = "Atom"

config.leader = {
  key  = "Enter",
  mods = "CTRL|ALT",
  timeout_milliseconds = 2000
}

config.disable_default_key_bindings = true


config.keys = {
  -- split pane in direction
  {
    key = "RightArrow",
    mods = "LEADER|CTRL|ALT",
    action = wezterm.action.SplitPane {
      direction = "Right",
      size = { Percent = 50 }
    }
  },
  {
    key = "LeftArrow",
    mods = "LEADER|CTRL|ALT",
    action = wezterm.action.SplitPane {
      direction = "Left",
      size = { Percent = 50 }
    }
  },
  {
    key = "UpArrow",
    mods = "LEADER|CTRL|ALT",
    action = wezterm.action.SplitPane {
      direction = "Up",
      size = { Percent = 50 }
    }
  },
  {
    key = "DownArrow",
    mods = "LEADER|CTRL|ALT",
    action = wezterm.action.SplitPane {
      direction = "Down",
      size = { Percent = 50 }
    }
  },
  -- select pane in direction
  {
    key = 'LeftArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivatePaneDirection 'Left'
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivatePaneDirection 'Right'
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivatePaneDirection 'Up'
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivatePaneDirection 'Down'
  },
  -- toggle pane large
  {
    key = 'l',
    mods = 'CTRL|ALT',
    action = wezterm.action.TogglePaneZoomState,
  },
  -- toggle resize_pane keytable
  {
    key = "s",
    mods = "CTRL|ALT",
    action = wezterm.action.ActivateKeyTable {
      name = "resize_pane",
      one_shot = false,
    }
  }
}

config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Enter', action = 'PopKeyTable' },
  }
}

return config