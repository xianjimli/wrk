local cjson = require("cjson")
local logger = require("scripts/logger")
local cookie = require("scripts/cookie")
local inspect = require("scripts/inspect")
local load_requests = require("scripts/load_requests")

local tester = {}

-- globals
threads = {}
smscode = ""
eq_nr = 0;
resp_nr = 0;
req_index = 1
request_list = nill 
-- globals end

function tester.load_requests(filename)
  request_list = load_requests(filename)
end

function tester.setup(thread)
   table.insert(threads, thread)
end

function tester.init(args)
  req_nr  = 0 
  resp_nr = 0 
  filename = args[1]

  logger.debug(string.format("tid=%d load json %s\n", thread_id, filename));
  tester.load_requests(filename)
end

function tester.done(summary, latency, requests)
   for index, thread in ipairs(threads) do
    local id      = thread:get("thread_id")
    local req_nr  = thread:get("req_nr") or 0
    local resp_nr = thread:get("resp_nr") or 0
    local msg = "thread %d made %d requests and got %d responses"
    logger.debug(msg:format(id, req_nr, resp_nr))
   end 
end

function prepare_request(req)
    local r = cjson.decode(cjson.encode(req))

    cookie.load(r.headers)

    return r
end

function expand(s, vars)
     return string.gsub(s, "$(%w+)", vars)
end

tester.request = function()
  local content = ""; 
  local tid = thread_id
  if req_index > #request_list then
    wrk.thread:stop()
    return nil
  end

  local r = prepare_request(request_list[req_index])

  logger.debug(string.format("tid=%d req_index=%d\n", tid, req_index))

  local vars = {
    smscode = smscode,
    tid = string.format("%06d", tid), 
    index = string.format("%06d", req_index)
  }

  local path,_ = expand(r.path, vars);    
  if r.body then
    content,_ = expand(cjson.encode(r.body), vars)
  end

  req_nr = req_nr + 1
  req_index = req_index + 1
  local str = wrk.format(r.method, path, r.headers, content)
  logger.debug(str)

  logger.progress()

  return str;
end

tester.response = function(status, headers, body, allheaders)
  local r = request_list[req_index-1]

  if r.saveSmsCode then
    local json = cjson.decode(body)
    smscode = json.message
  end
  
  cookie.save(allheaders);

  resp_nr = resp_nr + 1
  if status >= 400 then
    logger.warn(status, body)
  end
end

return tester
