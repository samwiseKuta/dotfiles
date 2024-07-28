local cache_time = 5 * 60 * 1000 -- 5 minutes
local password = nil
local timer = nil

local expect = function(expected, fn, description)
    local result = fn()
    if result ~= expected then
        error('error: wincent.sudo.write got result ' .. result .. ' for ' .. description .. '(expected ' .. expected .. ')')
    end
end

local reject = function(rejected, fn, description)
    local result = fn()
    if result == rejected then
        error('error: wincent.sudo.write got result ' .. result .. ' for ' .. description .. '(expected non-' .. rejected .. ')')
    end
end

local write = function(bang)
    if bang == '!' or password == nil then
        password = vim.fn.inputsecret('Password:')
        if timer ~= nil then
            timer:stop()
        end
        timer = vim.defer_fn(function()
            password = nil
        end, cache_time)
    end

    local askpass = vim.fn.tempname()

    expect(0, function() return vim.fn.writefile({''}, askpass, 's') end, 'writefile (touch)')
    reject(0, function() return vim.fn.setfperm(askpass, 'rwx------') end, 'setfperm')
    expect(0, function() return vim.fn.writefile({'#!/bin/bash', 'builtin echo -n ' .. vim.fn.shellescape(password)}, askpass, 's') end, 'writefile (fill)')

    -- Set buftype to non-empty (e.g. nowrite) to prevent Neovim asking the file has changed question (:help W12)
    -- otherwise prompt is shown: "W12: Warning: File <x> has changed and the buffer was changed in Vim as well"
    local stored_buftype = vim.o.buftype
    vim.o.buftype = 'nowrite'
    pcall(function()
        vim.cmd('silent write !env SUDO_ASKPASS=' .. vim.fn.shellescape(askpass) .. '  sudo -A tee % > /dev/null')
    end)
    local shell_error = vim.v.shell_error

    if vim.v.shell_error ~= 0 then
        -- Common cause of this is wrong password, so invalidate the cache.
        password = nil
        if timer ~= nil then
            timer:stop()
        end
    end

    expect(0, function() return vim.fn.delete(askpass) end, 'delete')
    if shell_error ~= 0 then
        -- Restore buftype immediately on error
        vim.o.buftype = stored_buftype
    else
        vim.cmd('autocmd BufReadPost <buffer> ++once set buftype=' .. stored_buftype)
        -- Reload the buffer (this will trigger the autocmd and reset the buftype back to original value)
        vim.cmd('edit')
    end
end
return write
