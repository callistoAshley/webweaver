local CmdHelpers = require("command-helpers")
local Helpers = require("helpers")
local Parser = require("parser")

local function parse_func(cmd)
    local input = cmd:get_arg_by_name("-i"):get_value_by_name("input").value
    local parsed = Parser:parse(Helpers.file_text(input) or error(string.format("No such file `%s`", input)))
    print(parsed)
end

return CmdHelpers.new_command
{
    name = "parse",
    short_help = "Invoke the parser without generating a new blog post.",
    long_help = 
    [[Invoke the parser without generating a new blog post.]],
    func = parse_func,

    possible_args =
    {
        CmdHelpers.new_arg
        (
            {"-i", "--input"},
            "Specify the input source file.",
            CmdHelpers.ArgType.REQUIRED,
            {
                CmdHelpers.new_value("input", CmdHelpers.ValueType.REQUIRED)
            }
        ),
    }
}
