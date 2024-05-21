local Helpers = require("helpers")

local CmdHelpers = {}

CmdHelpers.ArgType =
{
    REQUIRED = "required",
    OPTIONAL = "optional",
}
CmdHelpers.ValueType = CmdHelpers.ArgType

-- assumes `table` is an array of tables where each entry contains a field called `name`. if this field matches the value specified in the `name` parameter,
-- the field is returned
local function get_by_name(table, name)
    for _, val in ipairs(table) do
        if val.name == name then
            return val
        end
    end
    return nil
end

-- similar tp get_by_name, but allows the `name` field of an entry in `table` to itself optionally be a table, in which case it specifies a list of "aliases"
-- each of the aliases is compared against `name` until a match is found
local function get_by_name_or_alias(table, name)
    for _, val in ipairs(table) do
        if type(val.name) == "table" then
            for _, alias in val.name do
                if alias == name then
                    return val
                end
            end
        elseif type(val.name == "string") and val.name == name then
            return val
        end
    end
    return nil
end

local Command =
{
    name = "name",
    short_help = "help",
    long_help = "long_help",
    possible_args = {},
    func = nil,

    args = {},

    get_possible_arg_by_name = function(self, name)
        return get_by_name_or_alias(self.possible_args, name)
    end,
    get_arg_by_name = function(self, name)
        return get_by_name_or_alias(self.args, name)
    end,
}

local Arg =
{
    name = "name", -- may also be an array of strings specifying alternate names (i.e. aliases)
    help = "help",
    type = CmdHelpers.ArgType.OPTIONAL,
    possible_values = {},

    values = {},

    get_possible_value_by_name = function(self, name)
        return get_by_name(self.possible_values, name)
    end,
    get_value_by_name = function(self, name)
        return get_by_name(self.values, name)
    end,

    name_matches = function(self, name)
        if type(self.name) == "table" then
            for _, alias in ipairs(self.name) do
                if alias == name then 
                    return true 
                end
            end
        elseif type(self.name == "string") then
            return self.name == name
        end
        return false
    end,
}

local Value =
{
    name = "name",
    type = CmdHelpers.ArgType.OPTIONAL,
    value = nil,
}

function CmdHelpers.new_command(cmd)
    Helpers.require_keys(cmd, "name", "short_help", "long_help", "func")
    return setmetatable(cmd, {__index = Command})
end

function CmdHelpers.new_arg(name, help, type, possible_values)
    Helpers.require_enum(type, CmdHelpers.ArgType, "CmdHelpers.ArgType")
    return setmetatable(
    {
        name = name,
        help = help,
        type = type,
        possible_values = possible_values,
    }, {__index = Arg})
end

function CmdHelpers.new_value(name, type)
    Helpers.require_enum(type, CmdHelpers.ValueType, "CmdHelpers.ValueType")
    return setmetatable(
    {
        name = name,
        type = type,
    }, {__index = Value})
end

return CmdHelpers
