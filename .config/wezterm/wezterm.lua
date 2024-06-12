local wezterm = require 'wezterm';

return {
  -- Window settings
  window_decorations = "RESIZE",
  initial_cols = 180,
  initial_rows = 55,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_background_opacity = 0.98,
  enable_tab_bar = true,
  window_frame = {
    active_titlebar_bg = '#1d1f21',
    inactive_titlebar_bg = '#1d1f21',
  },
  default_cursor_style = "SteadyBlock",
  cursor_blink_ease_in = "Ease",
  cursor_blink_ease_out = "Ease",

  -- Font settings
  font = wezterm.font("HackGen35 Console NF"),
  font_size = 16.0,
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},

  -- Colors
  color_scheme = 'Gruvbox Dark (Gogh)',
  -- colors = {
  --   foreground = '#c5c8c6',
  --   cursor_bg = '#c5c8c6',
  --   cursor_fg = '#1d1f21',
  --   cursor_border = '#c5c8c6',
  --   selection_fg = '#c5c8c6',
  --   selection_bg = '#3E4451',
  --   scrollbar_thumb = '#3E4451',
  --   split = '#444444',
  --   ansi = {'#1d1f21', '#cc6666', '#b5bd68', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#c5c8c6'},
  --   brights = {'#666666', '#d54e53', '#b9ca4a', '#e7c547', '#7aa6da', '#c397d8', '#70c0b1', '#eaeaea'},
  -- },

  -- Key bindings
  keys = {
    {key="¥", mods="ALT", action=wezterm.action{SendString="\\"}},
    {key="V", mods="CTRL|SHIFT", action=wezterm.action.PasteFrom("Clipboard")},
    {key="C", mods="CTRL|SHIFT", action=wezterm.action.CopyTo("Clipboard")},
    {key="=", mods="CMD|SHIFT", action=wezterm.action.IncreaseFontSize},
  },

  -- Other settings
  enable_wayland = false,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,
}
