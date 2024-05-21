local CmdHelpers = require("command-helpers")

local function help_func(cmd)
    print("i am the help func")
end

return CmdHelpers.new_command
{
    name = "help",
    short_help = "Display detailed help on a particular command.",
    long_help = 
    [[
        Display detailed help on a particular command.
    ]],
    func = help_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-c", "--command"},
            "Specify the command.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("help", CmdHelpers.ValueType.REQUIRED),
            }
        ),
    },
}
