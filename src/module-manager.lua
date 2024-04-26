local loader = require("luarocks.loader")

local function find_missing(deps)
    local missing = {}
    for _, dep in ipairs(deps) do
        -- if this function fails to find a module, it returns an error message as a string
        if type(loader.luarocks_loader(dep)) == "string" then
            table.insert(missing, dep)
        end
    end
    return missing
end

local function install(name)
    local status = os.execute(string.format("luarocks install --local %s", name)) -- teehee
    return status
end

return
{
    find_missing = find_missing,
    install = install,
}
