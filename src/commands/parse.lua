local CmdHelpers = require("command-helpers")

local function parse_func(cmd)
    print("i am the parse func")
end

return CmdHelpers.new_command
{
    name = "parse",
    short_help = "Invoke the parser without generating a new blog post.",
    long_help = 
    [[
        Invoke the parser without generating a new blog post.
    ]],
    func = parse_func,
}
