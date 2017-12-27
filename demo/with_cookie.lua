cookie = require("scripts/cookie")

request = function()
    local r = {
        ["method"] = "GET",
        ["path"] = "/v1/auth/smscode",
        ["headers"] = {
        }
    };
    -- load saved cookie
    cookie.load(r.headers);

    return wrk.format(r.method, r.path, r.headers)
end

response = function(status, headers, body, allheaders)
    -- save cookie for later use.
    cookie.save(allheaders);
end

