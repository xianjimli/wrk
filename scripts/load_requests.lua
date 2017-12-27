local cjson = require("cjson")
local logger = require("scripts/logger")

function load_json(filename)
    local data = {}
    local content
    local f = io.open(filename, "r")
    if f ~= nil then
        content = f:read("*all")
        io.close(f)
    else
        logger.error("open file " .. filename .. " failed.")
        return data 
    end

    data = cjson.decode(content)

    return data
end

function load_requests(filename)
  local requestList = load_json(filename)

  if #requestList <= 0 then
      logger.warn("No requestList found\n")
      os.exit(0)
  end

  logger.debug("Found " .. #requestList .. " requestList")

  return requestList
end

return load_requests;

