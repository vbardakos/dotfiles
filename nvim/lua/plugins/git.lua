return {
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    {
	"kdheepak/lazygit.nvim",
	cmd = {
	    "LazyGit",
	    "LazyGitConfig",
	    "LazyGitCurrentFile",
	    "LazyGitFilter",
	    "LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
	    "nvim-lua/plenary.nvim",
	},
    },
}
