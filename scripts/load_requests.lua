local cjson = require("cjson")
local logger = require("scripts/logger")
local inspect = require("scripts/inspect")

function load_json(filename)
    local data = {}
    local content
    local f = io.open(filename, "r")
    if f ~= nil then
        content = f:read("*all")
        io.close(f)
    else
        logger.error("open file " .. filename .. " failed.")
        return nil
    end

    data = cjson.decode(content)

    return data
end

function load_requests(filename)
  local ret = load_json(filename)
  
  if ret == nil or #ret.requests <= 0 then
      logger.warn("No request found, exit\n")
      os.exit(0)
  end

  if ret.options.debug == true then
    logger.debug("Found " .. #ret.requests .. " ret")
    logger.debug(inspect.inspect(ret.options))
  end

  return ret
end

return load_requests;

