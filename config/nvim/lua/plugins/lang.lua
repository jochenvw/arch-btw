-- Enable LazyVim language extras
return {
  -- Go: gopls LSP, gofumpt formatter, goimports, gotest, delve debugger
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Python: pyright LSP, ruff linter/formatter, debugpy
  { import = "lazyvim.plugins.extras.lang.python" },

  -- JSON/YAML (for configs)
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- Docker
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- Git integration
  { import = "lazyvim.plugins.extras.lang.git" },

  -- DAP (debug adapter protocol)
  { import = "lazyvim.plugins.extras.dap.core" },
}
