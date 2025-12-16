local wezterm = require 'wezterm';

-- カレントディレクトリ名を取得する関数
local function get_current_directory_name(pane)
  if not pane then
    return nil
  end

  local cwd_uri = pane:get_current_working_dir()

  if cwd_uri then
    local cwd_str = tostring(cwd_uri)
    local cwd = cwd_str:match("file://.+/(.+)")
    if cwd then
      return cwd:match("([^/]+)$") or cwd  -- 最後のディレクトリ名を取得
    end
  end

  return nil
end

-- タブのタイトルを変更
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = wezterm.mux.get_pane(tab.active_pane.pane_id)
  local process_name = tab.active_pane.foreground_process_name or ""

  if process_name:match(".+/nvim$") then
    return tostring(tab.tab_index + 1) .. ": " .. get_current_directory_name(pane) .. " - NVIM"
  elseif process_name:match(".+/zsh$") then
    return tostring(tab.tab_index + 1) .. ": " .. get_current_directory_name(pane) .. " - zsh"
  end
end)

local act = wezterm.action

return {
  -- Mux settings
  --
  -- デフォルトでこのセッションに接続
  default_gui_startup_args = {"connect", "local"},

  -- Window settings
  window_decorations = "RESIZE",
  initial_cols = 180,
  initial_rows = 50,
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
  font_size = 15.5,
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},

  -- Colors
  color_scheme = 'Gruvbox Dark (Gogh)',
  colors = {
    tab_bar = {
      background = '#1d1f21',
      active_tab = {
        bg_color = '#2e3440',
        fg_color = '#d8dee9',
        intensity = 'Normal',
        underline = 'None',
      },
      inactive_tab = {
        bg_color = '#1d1f21',
        fg_color = '#666666',
      },
      inactive_tab_hover = {
        bg_color = '#1d1f21',
        fg_color = '#c5c8c6',
      },
    },
  },
  -- Key bindings
  --
  disable_default_key_bindings = true,
  keys = {
    {key="¥", mods="ALT", action=wezterm.action{SendString="\\"}},
    {key="V", mods="CTRL|SHIFT", action=wezterm.action.PasteFrom("Clipboard")},
    {key="C", mods="CTRL|SHIFT", action=wezterm.action.CopyTo("Clipboard")},
    {key="v", mods="CMD", action=wezterm.action.PasteFrom("Clipboard")},
    {key="c", mods="CMD", action=wezterm.action.CopyTo("Clipboard")},
    {key="n", mods="CMD", action=wezterm.action.SpawnWindow},
    {key="=", mods="CTRL|SHIFT", action=wezterm.action.IncreaseFontSize},
    {key="-", mods="CTRL", action=wezterm.action.DecreaseFontSize},
    {key="[", mods="CTRL", action=wezterm.action.SendString("\x1b")},
  },

  -- Other settings
  enable_wayland = false,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,
}
