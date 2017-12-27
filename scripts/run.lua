local tester = require("scripts/tester")

function setup(thread)
  return tester.setup(thread)
end

function init(args)
  return tester.init(args)
end

function done(summary, latency, requests)
  return tester.done(summary, latency, requests)
end

request = function()
  return tester.request()
end

response = function(status, headers, body, allheaders)
  return tester.response(status, headers, body, allheaders)
end

