-- example dynamic request script which demonstrates changing
-- the request path and a header for each request
-------------------------------------------------------------
-- NOTE: each wrk thread has an independent Lua scripting
-- context and thus there will be one counter per thread


request = function()
   path = "/" .. threadid()
   print(path)
   return wrk.format(nil, path)
end
