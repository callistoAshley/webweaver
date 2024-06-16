local Blog =
{
    posts_dir = "",
    skeleton = "",
}

function Blog:new(o)
    self.__index = self
    o = o or {}
    setmetatable(o, self)
    return o
end

return Blog
