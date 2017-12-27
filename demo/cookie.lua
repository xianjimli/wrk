-- load/save cookies

local cookie =  {
    cookies = {}
};

function cookie.save(headers) 
    cookie.cookies = {}
    for k,v in pairs(headers) do
        if string.find(k, "Set-Cookie", 1, true)  then
            cookie.cookies[k] = v;
        end
    end
end

function cookie.load(headers) 
    local i = 0
    for k,v in pairs(cookie.cookies) do
        headers[string.format("Cookie#%d", i)] = v;
        i = i + 1
    end
end

return cookie;

-- Example 
--[[
cookie = require("scripts/cookie")

request = function()
    local r = {
        ["method"] = "GET",
        ["path"] = "/v1/auth/smscode",
        ["headers"] = {
        }
    };
    local content = "{}"

    cookie.load(r.headers);

    return wrk.format(r.method, r.path, r.headers, content)
end

response = function(status, headers, body, allheaders)
    cookie.save(allheaders);
end
--]]
--
