--  This config file is to configure my Status line
--  Most of this is yoinked from other repos or blog posts, so I'll just link to those here:
--  TIP: pressing 'gx' opens the link in browser (if netrw is enabled)
-- Blog: (https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/)
-- Blog: (https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html)
-- Blog: (https://elianiva.my.id/posts/neovim-lua-statusline/)

-- Determines how much space an object has before it has to be truncated
-- These are default values, for certain elements of the status line this value is dynamic,
-- making these values just safety checks if something goes wrong
local default_truncate_width = {
    mode = 55,
    lsp_info = 45,
    filename = 60,
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
    if is_truncated(default_truncate_width.mode) then
        return string.format(' %s ', modes[current_mode][2]):upper()
    end

    return string.format(' %s ', modes[current_mode][1]):upper()
end

-- Outputs either the full filepath or a truncated one
local function get_filename(available_space)
    if(available_space == nil)then available_space = default_truncate_width.filename  end
    local fullpath  = vim.fn.expand('%:~')
    local shortpath = vim.fn.expand('%:.')
    local filename  = (#fullpath < available_space) and fullpath or shortpath

    return filename
end


-- Outputs errors, hints and warnings it gets from the LSP,either the native or a custom one
local function get_lsp_info(available_space)
    if(available_space == nil)then available_space = default_truncate_width.lsp_info end
    local counter = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }
    local output = {}
    local count = 0;
    for k, level in pairs(levels) do
        count = vim.tbl_count(vim.diagnostic.get(0, { severity = level }));
        if count ~= 0   then
            counter[k] = count
            table.insert(output,k.."·"..count)
        end
    end

    if(#table.concat(output) > available_space) then
        output = {}
        for k,value in pairs(counter) do
            table.insert(output,string.sub(k,1,1).."·"..value)
        end
    end

    if #output > 1 then
        for k, value in pairs(output) do
            output[k] = value.."|"
        end

    end

    return table.concat(output)
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
    return "%m%r% %l|%c %P"
end

-- Defining 'parts' of the statusline by putting them into a highlight group, which can then
-- be colored a specific way
local highlight_groups = {
    active      ='%#StatusLine#',
    inactive    ='%#StatuslineNC#',
    mode        ='%#Mode#',
    lsp         ='%#Lsp#',
    filename    ='%#Filename#',
    modified    ='%#Modified#',
    filetype    ='%#Filetype#',
    line_col    ='%#LineCol#',
}

-- This table matches bg and fg colors to the previously defined highlight groups
local colors = {
    {'StatusLine', { fg = '#3C3836', bg = '#EBDBB2' }},
    {'StatusLineNC', { fg = '#3C3836', bg = '#928374' }},
    {'Mode', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'Lsp', { bg = '#504945', fg = '#EBDBB2' }},
    {'Filename', { bg = '#504945', fg = '#fffff' }},
    {'Modified', { bg = '#928374', fg = '#1D2021', gui="bold" }},
    {'Filetype', { bg = '#504945', fg = '#EBDBB2' }},
    {'LineCol', { bg = '#928374', fg = '#1D2021', gui="bold" }},
}

-- This function pairs up the highlight group with it's color
-- I stole most of this config code so I have no clue how it does it's thing, do check out the
-- source links at the top of the file
local set_color = function(group, options)
    local bg = options.bg == nil and '' or 'guibg=' .. options.bg
    local fg = options.fg == nil and '' or 'guifg=' .. options.fg
    local gui = options.gui == nil and '' or 'gui=' .. options.gui

    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end


local color_it = function()
    for _,color in ipairs(colors) do
        set_color(color[1], color[2])
    end
end


-- Outputs given string, padded on both sides by padding_string until final_length has been reached
local even_padding_to_length = function(string,final_length,padding_string)

    local padding   = (final_length - #string)

    padding = (padding % 2 == 0) and (padding / 2) or ((padding+1) / 2)

    for i = 1,padding,1 do
        string = padding_string..string..padding_string
    end
    return string

end

Statusline = {}

-- Statusline for current window
Statusline.active = function()

    local mode =  get_mode()
    local filetype =  get_filetype()
    local line_col =  get_lineinfo()

    local remaining_space = vim.api.nvim_win_get_width(0) - (#mode+#filetype+#line_col)
    local lsp_info = get_lsp_info(remaining_space)
    remaining_space = remaining_space - #lsp_info
    local filename = get_filename(remaining_space)
    lsp_info = get_lsp_info(remaining_space-#filename)

    -- %< tells the statusline to start removing this element before the others
    -- So if the status line gets too short, mode and lsp info will stay but filename gets deleted
    -- %= Makes the element function similarly to CSS flex space around, best I can explain it
    filename = "%<"..even_padding_to_length(filename,remaining_space," ").."%="


    local statusline = table.concat {
        highlight_groups.active,
        highlight_groups.mode       .. mode,
        highlight_groups.lsp        .. lsp_info,
        highlight_groups.filename   .. filename,
        highlight_groups.filetype   .. filetype,
        highlight_groups.line_col   .. line_col
    }
    color_it()
    return statusline
end
-- The inactive window statusline
function Statusline.inactive()
    -- A way to get full terminal width
    local term_width = tonumber(vim.api.nvim_command_output("echo &columns")) or 0
    color_it()
    return highlight_groups.inactive
        ..
        even_padding_to_length(get_filename(),term_width-vim.api.nvim_win_get_width(0),".")
end

-- Exporer (netrw) statusline
Statusline.netrw = function()
    color_it()
    return " "

end


-- This is the command that tells neovim to build the status line
-- You can see in the command there are different events, that build a different statusLine
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.netrw()
  augroup END
]], false)
