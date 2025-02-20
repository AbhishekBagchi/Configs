vim9script
var servers = [
    {
        name: "clangd",
        filetype: ["c", "cpp"],
        path: "/usr/bin/clangd",
        args: ["--background-index", "--clang-tidy", "--all-scopes-completion", "--completion-style=detailed", "--header-insertion-decorators", "--header-insertion=iwyu", "--rename-file-limit=0"]
    },
    {
        name: "pylsp",
        filetype: "python",
        path: "/opt/homebrew/bin/pylsp",
        args: []
    }
]

call LspAddServer(servers)
