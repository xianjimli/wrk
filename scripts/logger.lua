
local logger = {
}

function logger.verbose(str) 
end

function logger.debug(str) 
  print(str)
  io.flush()
end

function logger.warn(str) 
  print(str)
  io.flush()
end

function logger.error(str) 
  print(str)
  io.flush()
end

function logger.progress(str) 
  io.write(".")
  io.flush()
end

return logger;
