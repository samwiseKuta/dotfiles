-- Separator between statusline regions
local part_separator = " ";

-- Determines at what width a region should be truncated
local truncated_width = {
    mode = 50,
    lsp_info = 100,
    filename = 120,
}

-- Outputs true/false whether the input width is less than buffer width
local function is_truncated(width)
    local current_width = vim.api.nvim_win_get_width(0)
    return current_width < width
end


-- Maps the shortcut vim returns for it's mode to what should be displayed on the statusline
-- Has two values, the shorter one is for truncated width
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

-- Outputs the current mode, either full or truncated based on truncated_width.mode
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


-- Outputs either the full filepath or a truncated one
local function get_filename()

    if is_truncated(truncated_width.filename) then return " %<%f " end
    return " %<%F "
end


-- Outputs errors, hints and warnings it gets from the LSP,either the native or a custom one
local function get_lsp_info()
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

    local output = {}

    if is_truncated(truncated_width.lsp_info) then

        if count["errors"] ~= 0 then
            errors =  "e.."..count["errors"]
            table.insert(output,errors)
        end
        if count["warnings"] ~= 0 then
            warnings = "w.."..count["warnings"]
            table.insert(output,warnings)

        end
        if count["hints"] ~= 0 then
            hints = "h.."..count["hints"]
            table.insert(output,hints)

        end
        if count["info"] ~= 0 then
            info = "i.."..count["info"]
            table.insert(output,info)

        end
        if #output > 1 then
            for k, value in pairs(output) do
                output[k] = value.."|"
            end

        end
        return table.concat(output).."%#Normal#"
    end

    if count["errors"] ~= 0 then
        errors =  "errors.."..count["errors"]
        table.insert(output,errors)
    end
    if count["warnings"] ~= 0 then
        warnings = "warnings.."..count["warnings"]
        table.insert(output,warnings)
    end
    if count["hints"] ~= 0 then
        hints = "hints.."..count["hints"]
        table.insert(output,hints)
    end
    if count["info"] ~= 0 then
        info = "info.."..count["info"]
        table.insert(output,info)
    end
    if #output > 1 then
        for k, value in pairs(output) do
            output[k] = value.."|"
        end

    end

    return table.concat(output).."%#Normal#"
end



-- Outputs detected filetype
local function get_filetype()
    return string.format(" %s ", vim.bo.filetype):upper()
end

-- Outputs information about cursor position and percentage scroll
local function get_lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return "%l|%c %P"
end

-- Parts of the statusline
local parts = {
    active        = '%#StatusLine#',
    inactive      = '%#StatuslineNC#',
    mode          = '%#Mode#',
    mode_alt      = '%#ModeAlt#',
    lsp = '%#Lsp#',
    lsp_alt  = '%#LspAlt#',
    filetype      = '%#Filetype#',
    filetype_alt  = '%#FiletypeAlt#',
    line_col      = '%#LineCol#',
    line_col_alt  = '%#LineColAlt#',
}

-- you can of course pick whatever colour you want, I picked these colours
-- because I use Gruvbox and I like them
local colors = {
    {'StatusLine', { fg = '#3C3836', bg = '#EBDBB2' }},
    {'StatusLineNC', { fg = '#3C3836', bg = '#928374' }},
    {'Mode', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'Lsp', { bg = '#504945', fg = '#EBDBB2' }},
    {'LspAlt', { bg = '#3C3836', fg = '#504945' }},
    {'Filetype', { bg = '#504945', fg = '#EBDBB2' }},
    {'FiletypeAlt', { bg = '#3C3836', fg = '#504945' }},
    {'Filename', { bg = '#504945', fg = '#EBDBB2' }},
    {'ModeAlt', { bg = '#504945', fg = '#928374' }},
    {'LineCol', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'LineColAlt', { bg = '#504945', fg = '#928374' }},
}

-- Using the parts and colors tables, this function sets the color for each part of the statusline
local set_color = function(group, options)
    local bg = options.bg == nil and '' or 'guibg=' .. options.bg
    local fg = options.fg == nil and '' or 'guifg=' .. options.fg
    local gui = options.gui == nil and '' or 'gui=' .. options.gui

    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

for _,color in ipairs(colors) do
    set_color(color[1], color[2])
end


Statusline = {}


Statusline.active = function()

    local mode = parts.mode .. get_mode()
    local mode_alt = parts.mode_alt --.. part_separator
    local lsp_info = parts.lsp .. get_lsp_info() --.. part_separator
    local filename = parts.inactive .. get_filename()
    local filetype_alt = parts.filetype_alt --.. part_separator
    local filetype = parts.filetype .. get_filetype()
    local line_col = parts.line_col .. get_lineinfo()
    local line_col_alt = parts.line_col_alt --.. part_separator

    return table.concat {
        parts.active, mode, mode_alt,lsp_info,
        filename, "%=",
        filetype_alt, filetype, line_col_alt, line_col
    }
end

function Statusline.inactive()
    return "%F"
end

Statusline.explorer = function()
    local title = parts.mode .. ' '
    local title_alt = parts.mode_alt .. part_separator

    return table.concat({ parts.active, title, title_alt })
end


-- This is the command that tells neovim to build the status line
-- You can see in the command there are different events, that build a different statusLine
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.explorer()
  augroup END
]], false)
