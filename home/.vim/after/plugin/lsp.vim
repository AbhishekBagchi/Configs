vim9script
var servers = [
    {
        name: "clangd",
        filetype: ["c", "cpp"],
        path: "/usr/bin/clangd",
        args: ["--background-index",
            "--clang-tidy",
            "--all-scopes-completion",
            "--completion-style=detailed",
            "--header-insertion-decorators",
            "--header-insertion=iwyu",
            "--rename-file-limit=0"]
    },
    {
        name: "pylsp",
        filetype: "python",
        path: "/opt/homebrew/bin/pylsp",
        workspaceConfig: {
            'pylsp': {
                'configurationSources': [],
                'plugins': {
                    'black': {
                        'enabled': 1,
                        'line_length': 120,
                    },
                    'isort': {
                        'enabled': 1,
                        'add_imports': 1
                    },
                    'flake8': {
                        'enabled': 0,
                    },
                    'pycodestyle': {
                        'maxLineLength': 120,
                    }
                }
            }
        }
    },
    {
        name: 'rustanalyzer',
        filetype: ['rust'],
        path: '/Users/abhishekbagchi/.cargo/bin/rust-analyzer',
        args: [],
        syncInit: v:true,
        initializationOptions: {
            inlayHints: {
                typeHints: {
                    enable: v:true
                },
                parameterHints: {
                    enable: v:true
                }
            },
        }
    }
]

call LspAddServer(servers)
