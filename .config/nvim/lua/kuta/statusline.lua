local truncated_width = {
    mode = 80,
    git_status = 90,
    filename = 140,
    line_col = 60
}


local function is_truncated(width)
    local current_width = vim.api.nvim_win_get_width(0)
    return current_width < width
end


-- you can of course pick whatever colour you want, I picked these colours
-- because I use Gruvbox and I like them
local highlights = {
  {'StatusLine', { fg = '#3C3836', bg = '#EBDBB2' }},
  {'StatusLineNC', { fg = '#3C3836', bg = '#928374' }},
  {'Mode', { bg = '#928374', fg = '#1D2021', gui="bold" }},
  {'LineCol', { bg = '#928374', fg = '#1D2021', gui="bold" }},
  {'Git', { bg = '#504945', fg = '#EBDBB2' }},
  {'Filetype', { bg = '#504945', fg = '#EBDBB2' }},
  {'Filename', { bg = '#504945', fg = '#EBDBB2' }},
  {'ModeAlt', { bg = '#504945', fg = '#928374' }},
  {'GitAlt', { bg = '#3C3836', fg = '#504945' }},
  {'LineColAlt', { bg = '#504945', fg = '#928374' }},
  {'FiletypeAlt', { bg = '#3C3836', fg = '#504945' }},
}


local set_highlight = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

for _,highlight in ipairs(highlights) do
  set_highlight(highlight[1], highlight[2])
end

local modes = {
 ['n']  = {'Normal', 'N'};
  ['no'] = {'N·Pending', 'N·P'};
  ['v']  = {'Visual', 'V' };
  ['V']  = {'Vis·Line', 'V·L' };
  [''] = {'Vis·Block', 'V·B'};
  ['s']  = {'Select', 'S'};
  ['S']  = {'S·Line', 'S·L'};
  [''] = {'S·Block', 'S·B'};
  ['i']  = {'Insert', 'I'};
  ['ic'] = {'Insert', 'I'};
  ['R']  = {'Replace', 'R'};
  ['Rv'] = {'Viv·Replace', 'V·R'};
  ['c']  = {'Command', 'C'};
  ['cv'] = {'Vim·Ex ', 'V·E'};
  ['ce'] = {'Ex ', 'E'};
  ['r']  = {'Prompt ', 'P'};
  ['rm'] = {'More ', 'M'};
  ['r?'] = {'Confirm ', 'C'};
  ['!']  = {'Shell ', 'S'};
  ['t']  = {'Terminal ', 'T'};
}

local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    if is_truncated(truncated_width.mode) then
        return string.format(' %s ', modes[current_mode][2]):upper()
    end

    return string.format(' %s ', modes[current_mode][1]):upper()
end

--local function update_mode_colors()
--  local current_mode = vim.api.nvim_get_mode().mode
--  local mode_color = "%#StatusLineAccent#"
--  if current_mode == "n" then
--      mode_color = "%#StatuslineAccent#"
--  elseif current_mode == "i" or current_mode == "ic" then
--      mode_color = "%#StatuslineInsertAccent#"
--  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
--      mode_color = "%#StatuslineVisualAccent#"
--  elseif current_mode == "R" then
--      mode_color = "%#StatuslineReplaceAccent#"
--  elseif current_mode == "c" then
--      mode_color = "%#StatuslineCmdLineAccent#"
--  elseif current_mode == "t" then
--      mode_color = "%#StatuslineTerminalAccent#"
--  end
--  return mode_color
--end


local function filename()

    if is_truncated(truncated_width.filename) then return " %<%f " end
    return " %<%F "
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors =  "errors|"..count["errors"].."|"
  end
  if count["warnings"] ~= 0 then
    warnings = "warnings|"..count["warnings"].."|"
  end
  if count["hints"] ~= 0 then
    hints = "hints|"..count["hints"].."|"
  end
  if count["info"] ~= 0 then
    info = "info|"..count["info"].."|"
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end



local function filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end


local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return "%l|%c %P"
end

-- highlight groups
local colors = {
  active        = '%#StatusLine#',
  inactive      = '%#StatuslineNC#',
  mode          = '%#Mode#',
  mode_alt      = '%#ModeAlt#',
  git           = '%#Git#',
  git_alt       = '%#GitAlt#',
  filetype      = '%#Filetype#',
  filetype_alt  = '%#FiletypeAlt#',
  line_col      = '%#LineCol#',
  line_col_alt  = '%#LineColAlt#',
}
Statusline = {}

Statusline.active = function()
  return table.concat {
    "%#Statusline#",
    --update_mode_colors(),
    get_mode(),
    "%#Normal# ",
    filename(),
    "%#Normal#",
    lsp(),
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  }
end

function Statusline.inactive()
  return " %F"
end


vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]], false)
