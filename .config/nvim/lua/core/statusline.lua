--  This config file is to configure my Status line
--  Most of this is yoinked from other repos or blog posts, so I'll just link to those here:
--  TIP: pressing 'gx' opens the link in browser (if netrw is enabled)
-- Blog: (https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/)
-- Blog: (https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html)
-- Blog: (https://elianiva.my.id/posts/neovim-lua-statusline/)

-- Disables mode in default statusline
vim.opt.showmode = false
-- Sets priority for the order in which regions should be truncated
-- lower number -> higher priority
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

-- Outputs the current mode, either full or truncated based on in param
local function get_mode(truncated)
    if truncated==nil or truncated == false  then
        local current_mode = modes[vim.api.nvim_get_mode().mode][1]
        if(current_mode == nil) then current_mode = "Unknown" end
        return string.format(' %s ', current_mode):upper()
    end

    local current_mode = modes[vim.api.nvim_get_mode().mode][1]
    if(current_mode == nil) then current_mode = "Unknown" end
    return string.format(' %s ', current_mode):upper()

end

-- Outputs either the full filepath or a truncated one based on in param
local function get_filename(truncated)
    if(truncated == nil or truncated == false)then return vim.fn.expand('%:~') end


    return vim.fn.expand('%:.')
end


-- Outputs errors, hints and warnings it gets from the LSP,either the native or a custom one
-- Full or truncated based on in param
local function get_lsp_info(truncated)
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

    if(truncated == nil or truncated == false) then

        if #output > 1 then
            for k, value in pairs(output) do
                output[k] = value.."|"
            end

        end
        return table.concat(output)

    end

    output = {}
    for k,value in pairs(counter) do
        table.insert(output,string.sub(k,1,1).."·"..value)
    end

    if #output > 1 then
        for k, value in pairs(output) do
            output[k] = value.."|"
        end

    end

    return table.concat(output)
end



-- Outputs detected filetype and the modified symbol next to it
local function get_filetype()
    return string.format(" %s", vim.bo.filetype.." %m%r% "):upper()
end

-- Outputs cursor position and  scroll% from top
local function get_lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return "%l|%c %P"
end

-- Defining 'parts' of the statusline by putting them into a highlight group, which can then
-- be colored a specific way
local highlight_groups = {
    netrw      ='%#Netrw#',
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
    {'Netrw', { fg = '#3C3836', bg = '#292522' }},
    {'StatusLineNC', { fg = '#867462', bg = '#292522' }},
    {'Mode', { bg = '#A3A9CE', fg = '#292522', gui="bold" }},
    {'Lsp', { bg = '#292522', fg = '#EBC06D' }},
    {'Filename', { bg = '#292522', fg = '#A3A9CE' }},
    {'Modified', { bg = '#928374', fg = '#1D2021'}},
    {'Filetype', { bg = '#403A36', fg = '#ECE1D7',gui="bold" }},
    {'LineCol', { bg = '#403A36', fg = '#A3A9CE', gui="bold" }},
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


local color_all = function()
    for _,color in ipairs(colors) do
        set_color(color[1], color[2])
    end
end


-- Outputs given string, padded on both sides by pad_length
local even_padding_by_amount = function(string,pad_length,padding_string)

    pad_length = (pad_length % 2 == 0) and (pad_length / 2) or ((pad_length+1) / 2)

    for _ = 1,pad_length,1 do
        string = padding_string..string..padding_string
    end
    return string

end


Statusline = {}

-- Statusline for current window
Statusline.active = function()
    color_all()

    local M = {
        mode = get_mode(),
        filename = get_filename(),
        filetype = get_filetype(),
        lsp_info = get_lsp_info(),
        line_col = get_lineinfo(),
    }
    local window_width = vim.api.nvim_win_get_width(0)
    local remaining_space = window_width - #table.concat{
        M.mode,M.filename,M.filetype,M.lsp_info,M.line_col
    }

    if(remaining_space <= 0) then
        local truncated_values = {
            filename = get_filename(true),
            lsp_info = get_lsp_info(true),
            mode = get_mode(true)
        }
        local truncate_queue = {
            "filename",
            "lsp_info",
            "mode"
        }
        for _,value in pairs(truncate_queue) do
            M[value] = truncated_values[value]
            remaining_space = window_width - #table.concat{
                M.mode,M.filename,M.filetype,M.lsp_info,M.line_col
            }

            if(remaining_space > 0) then break end
        end

    end

    -- %< tells the statusline to start removing this element before the others
    -- So if the status line gets too short, mode and lsp info will stay but filename gets deleted
    -- %= Makes the element function similarly to CSS flex space around, best I can explain it
    M.filename = "%<"..even_padding_by_amount(M.filename,remaining_space," ").."%="
    M.lsp_info = " "..M.lsp_info


    local statusline = table.concat {
        highlight_groups.mode       .. M.mode,
        highlight_groups.lsp        .. M.lsp_info,
        highlight_groups.filename   .. M.filename,
        highlight_groups.filetype   .. M.filetype,
        highlight_groups.line_col   .. M.line_col
    }
    return statusline
end
-- The inactive window statusline
function Statusline.inactive()
    -- A way to get full terminal width
    local term_width = tonumber(vim.api.nvim_command_output("echo &columns")) or 0
    color_all()
    return highlight_groups.inactive
        ..
        even_padding_by_amount(get_filename(),term_width-vim.api.nvim_win_get_width(0)-#get_filename(),".")
end

-- Exporer (netrw) statusline
Statusline.netrw = function()
    color_all()
    return highlight_groups.netrw.." "
end


-- This is the command that tells neovim to build the status line
-- You can see in the command there are different events, that build a different statusLine
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType netrw setlocal statusline=%!v:lua.Statusline.netrw()
  augroup END
]], false)
