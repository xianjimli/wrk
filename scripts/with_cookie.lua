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

