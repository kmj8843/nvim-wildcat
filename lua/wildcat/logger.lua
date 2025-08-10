local M = {}

local isDebugging = true

local function fmt(msg)
  if type(msg) == "table" then
    return vim.inspect(msg)
  end
  return tostring(msg)
end

function M.info(msg)
  vim.notify(fmt(msg), vim.log.levels.INFO, { title = "󰄛 Wildcat" })
end

function M.warn(msg)
  vim.notify(fmt(msg), vim.log.levels.WARN, { title = "󰄛 Wildcat" })
end

function M.error(msg)
  vim.notify(fmt(msg), vim.log.levels.ERROR, { title = "󰄛 Wildcat" })
end

function M.debug(msg)
  if isDebugging then
    vim.notify(
      fmt(msg),
      vim.log.levels.DEBUG,
      { title = "󰄛 Wildcat [Debug]" }
    )
  end
end

return M
