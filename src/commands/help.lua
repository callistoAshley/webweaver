local CmdHelpers = require("command-helpers")

local function help_func(cmd)
    local CommandExecutor = require("command-executor")

    local cmd_name = cmd:get_arg_by_name("-c"):get_value_by_name("command").value

    local command = CommandExecutor.get_cmd_by_name(cmd_name)
    if command then
        print(string.format("HELP: %s", command.name))
        print(string.format("\t%s", command.long_help))
        print("\nOPTIONS:")
        for _, arg in ipairs(command.possible_args) do
            local text = ""

            if type(arg.name) == "table" then
                for i = 1, #arg.name do
                    if i > 1 then text = text .. ", " end
                    text = text .. arg.name[i]
                end
            else
                text = text .. arg.name
            end

            for _, value in ipairs(arg.possible_values) do
                if value.type == CmdHelpers.ValueType.REQUIRED then
                    text = text .. string.format(" <%s>", value.name)
                else
                    text = text .. string.format(" [<%s>]", value.name)
                end
            end

            if arg.type == CmdHelpers.ArgType.OPTIONAL then
                text = string.format("[%s]", text)
            end

            text = "\t" .. text .. string.format(": %s", arg.help)

            print(text)
        end
        return
    end
    print(string.format("No such command `%s`", cmd_name))
end

return CmdHelpers.new_command
{
    name = "help",
    short_help = "Display detailed help on a particular command.",
    long_help = 
    [[Display detailed help on a particular command.]],
    func = help_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-c", "--command"},
            "Specify the command.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("command", CmdHelpers.ValueType.REQUIRED),
            }
        ),
    },
}
