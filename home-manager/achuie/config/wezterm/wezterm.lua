local wezterm = require 'wezterm'

wezterm.on('toggle-ligature', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    overrides.harfbuzz_features = { 'aalt=0', 'calt=0', 'clig=0', 'liga=0' }
  else
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end)

return {
  hide_tab_bar_if_only_one_tab = true,

  use_ime = false,

  quick_select_patterns = {
    -- Git-status file paths
    '(?<=\\s{8}|\\s{8}modified:\\s{3})/*[0-9A-Za-z.+_/-]+',
    -- Git branch names in ()
    '\\(([0-9A-Za-z_+-]+)\\)',
  },

  font = wezterm.font_with_fallback {
    'Fira Code Custom',
    'Iosevka Custom Extended',
    'Rec Mono Custom',
    'Font Awesome 6 Free',
  },
  font_size = 12,
  font_rules = {
    {
      italic = false,
      intensity = 'Bold',
      font = wezterm.font('Fira Code Custom', { weight = 'Bold' }),
    },
    {
      italic = true,
      font = wezterm.font('Iosevka Custom Extended', { italic = true }),
    },
    {
      italic = true,
      intensity = 'Bold',
      font = wezterm.font('Iosevka Custom Extended', { italic = true }),
    },
  },

  window_background_opacity = 0.9,

  color_scheme = 'tokyo-night-storm',
  color_schemes = {
    ['tokyo-night-storm'] = {
      foreground = '#d3d7eb',
      background = '#24283b',
      cursor_fg = '#24283b',
      cursor_bg = '#c9d3ff',
      cursor_border = '#c9d3ff',
      selection_bg = '#2d4370',
      ansi = {
        '#32344a',
        '#ea4e6b',
        '#9ece6a',
        '#ff9e64',
        '#7aa2f7',
        '#ad8ee6',
        '#75c1ee',
        '#b6b9cc',
      },
      brights = {
        '#444b6a',
        '#ff4266',
        '#ace173',
        '#e0af68',
        '#9abaff',
        '#bb9af7',
        '#7dcfff',
        '#cbcff5',
      },
    },
  },

  keys = {
    {
      key = 'E',
      mods = 'CTRL',
      action = wezterm.action.EmitEvent 'toggle-ligature',
    },
    {
      key = 'Enter',
      mods = 'SHIFT|CTRL',
      action = wezterm.action.SpawnWindow,
    },
  },

  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("PrimarySelection"),
    },
  },
}
