return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
    "williamboman/mason.nvim",        -- Ensure Mason is a dependency
    "williamboman/mason-nvim-dap.nvim", -- For Mason DAP integration
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup DAP UI
    dapui.setup()

    -- Setup Go debugging
    require("dap-go").setup()

    -- Setup Mason DAP integration
    require("mason-nvim-dap").setup({
      automatic_setup = true,
    })

    -- Setup codelldb for C++ and Rust
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.configurations.rust = dap.configurations.cpp -- Reuse C++ configuration for Rust

    -- Setup Node Debug Adapter for JS/TS
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    dap.configurations.javascript = {
      {
        name = "Launch Program",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Attach to Process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
        cwd = vim.fn.getcwd(),
      },
    }

    dap.configurations.typescript = dap.configurations.javascript -- Reuse JS config for TS

    -- DAP UI integration: Open/close automatically
    dap.listeners.before.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Key mappings for DAP
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
  end,
}
