local CommandExecutor = require("command-executor")
local CommandHelpers = require("command-helpers")

local CliParser = {}

function CliParser.parse(cli_args)
    local cmd_name = table.remove(cli_args, 1)
    local cmd = CommandExecutor.get_cmd_by_name(cmd_name)
    if not cmd then return nil end
    cmd = setmetatable({}, {__index = cmd})

    for i = 1, #cli_args do
        local arg_str = cli_args[i]
        
        for _, arg in ipairs(cmd.possible_args) do
            if arg:name_matches(arg_str) then
                local has_optional_values = false
                local has_required_values = false

                for _, val in ipairs(arg.possible_values) do
                    i = i + 1
                    local val_str = cli_args[i]

                    if val.type == CommandHelpers.ValueType.REQUIRED then
                        has_required_values = true
                        if not val_str or val_str:match("^%-") then
                            return error(string.format("Missing required value %s", val.name))
                        end
                    elseif val.type == CommandHelpers.ValueType.OPTIONAL then
                        has_optional_values = true
                        if not val_str or val_str:match("^%-") then
                            break
                        end
                    end
                    
                    val.value = val_str
                    table.insert(arg.values, val)
                end

                if has_optional_values and has_required_values then
                    return error("An argument must not have a combination of optional and required values.")
                end

                table.insert(cmd.args, arg)
            end
        end
    end

    return cmd 
end

return CliParser
