local Blog =
{
    posts_dir = "",
    skeleton = "",
}

function Blog:new(o)
    o = o or {}
    setmetatable(o, self)
    for k, v in pairs(self) do
        if type(v) ~= "function" and not o[k] then o[k] = v end
    end
    return o
end

return Blog
