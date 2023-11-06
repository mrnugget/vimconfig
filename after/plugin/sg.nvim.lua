if vim.fn.has "mac" == 1 then
  require("sg").setup {
    node_executable = "/Users/thorstenball/.asdf/installs/nodejs/20.4.0/bin/node",
  }
end
