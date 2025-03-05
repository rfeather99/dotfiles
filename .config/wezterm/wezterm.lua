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

  leader = { key = 'j', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    {key="¥", mods="ALT", action=wezterm.action{SendString="\\"}},
    {key="V", mods="CTRL|SHIFT", action=wezterm.action.PasteFrom("Clipboard")},
    {key="C", mods="CTRL|SHIFT", action=wezterm.action.CopyTo("Clipboard")},
    {key="=", mods="CMD|SHIFT", action=wezterm.action.IncreaseFontSize},
    {
      key = '|',
      mods = 'LEADER|SHIFT',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = '-',
      mods = 'LEADER',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'c',
      mods = 'LEADER',
      action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    -- Paneを終了する
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true }, },
    -- 前,後のタブに移動
    { key = "l", mods = 'LEADER|CTRL', action = wezterm.action.ActivateTabRelative(1), },
    { key = "h", mods = 'LEADER|CTRL', action = wezterm.action.ActivateTabRelative(-1), },
    { key = "l", mods = 'ALT', action = wezterm.action.ActivateTabRelative(1), },
    { key = "h", mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1), },
    -- 指定のタブに移動
    { key = "1", mods = 'LEADER', action = wezterm.action.ActivateTab(0), },
    { key = "2", mods = 'LEADER', action = wezterm.action.ActivateTab(1), },
    { key = "3", mods = 'LEADER', action = wezterm.action.ActivateTab(2), },
    { key = "4", mods = 'LEADER', action = wezterm.action.ActivateTab(3), },
    { key = "5", mods = 'LEADER', action = wezterm.action.ActivateTab(4), },
    { key = "6", mods = 'LEADER', action = wezterm.action.ActivateTab(5), },
    { key = "7", mods = 'LEADER', action = wezterm.action.ActivateTab(6), },
    { key = "8", mods = 'LEADER', action = wezterm.action.ActivateTab(7), },
    { key = "9", mods = 'LEADER', action = wezterm.action.ActivateTab(8), },
    -- Leader + h/j/k/l で Pane を移動
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    -- タブを左, 右へ移動 (現在のタブを1つ横にスワップ)
    { key = "h", mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
    { key = "l", mods = "LEADER|SHIFT", action = wezterm.action.MoveTabRelative(1) },

    { key = "Space", mods = 'LEADER', action = wezterm.action.ActivateCopyMode, },
  },

  key_tables = {
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
      { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
      { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
      { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },

    search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
  },

  -- Other settings
  enable_wayland = false,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,
}
