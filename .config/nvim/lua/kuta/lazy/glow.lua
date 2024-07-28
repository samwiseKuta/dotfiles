return {
"ellisonleao/glow.nvim",
config = function()
require('glow').setup({
            style = "dark",
            width_ratio = 1, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
            height_ratio = 1,

})
    end
}
