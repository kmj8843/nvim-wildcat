local utils = require("wildcat.utils")
local logger = require("wildcat.logger")

local lua_wildcat_path = debug.getinfo(1).source:match("@?(.*/)")
local wildcat_root_path = lua_wildcat_path:gsub("/lua/wildcat", "")
local wildcat_log_file = vim.fn.stdpath("log") .. "/wildcat.log"

return {
  build = function()
    if vim.fn.executable("cargo") == 0 then
      logger.warn(
        "Cargo (Rust) is required. Install it to use this plugin and then execute manually :WildcatBuild"
      )
      return false
    end

    local script = string.format(
      "%sscript/build.sh %s 2> >( while read line; do echo \"[ERROR][$(date '+%%m/%%d/%%Y %%T')]: ${line}\"; done >> %s)",
      wildcat_root_path,
      wildcat_root_path,
      wildcat_log_file
    )

    utils.show_progress("󰄛 Wildcat   Building plugin...")

    local stdout_lines = {}
    local stderr_lines = {}

    return vim.fn.jobstart(script, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stdout_lines, line)
          end
        end
      end,
      on_stderr = function(_, data, _)
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_lines, line)
          end
        end
      end,
      on_exit = function(_, code)
        utils.stop_progress()

        if code == 0 then
          logger.info("󰄛 Wildcat    Plugin ready to be used!")
          logger.debug(table.concat(stdout_lines, "\n"))
        else
          logger.error("󰄛 Wildcat build failed with exit code " .. code)

          if #stderr_lines > 0 then
            logger.error(table.concat(stderr_lines, "\n"))
          else
            logger.debug(table.concat(stdout_lines, "\n"))
          end
        end
      end,
    })
  end,
}
